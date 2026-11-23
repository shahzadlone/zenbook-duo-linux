#!/usr/bin/env bash
# Exercise SRC-001 rollback semantics against a Burakgon lib checkout.
# Usage: bash scripts/test-burakgon-rollback-fix.sh /path/to/burakgon-checkout
# Runs isolated scenarios in disposable temp paths; never touches system files.
set -uo pipefail
if [[ ${1:-} == --help || $# != 1 ]]; then
    echo 'Usage: bash scripts/test-burakgon-rollback-fix.sh /path/to/burakgon-checkout'
    exit 0
fi
if ((EUID == 0)); then echo 'Run this test as an ordinary user, not root.' >&2; exit 2; fi
source_tree=$(cd -- "$1" && pwd)
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mkdir -p -- "$repo_root/.local"
work=$(mktemp -d "$repo_root/.local/rollback-test-XXXXXX")
trap 'rm -rf -- "$work"' EXIT
pass=0 fail=0

scenario() { # scenario NAME — fresh state dir, sourced helpers, MOD_ID set
    local name=$1
    export DUO_STATE_DIR="$work/$name/state"
    rm -rf "$DUO_STATE_DIR"
    source "$source_tree/lib/common.sh"
    source "$source_tree/lib/actions.sh"
    MOD_ID="test-$name"
}

check() { # check NAME CONDITION(0=pass)
    local name=$1; shift
    if "$@"; then
        printf 'PASS  %s\n' "$name"; pass=$((pass + 1))
    else
        printf 'FAIL  %s\n' "$name"; fail=$((fail + 1))
    fi
}

write_file() { printf '%b' "$2" >"$1"; }   # write_file PATH 'content\n'
content_is() { [[ -f $1 && "$(cat -- "$1")" == "$(printf '%b' "$2")" ]]; }
file_absent() { [[ ! -e $1 ]]; }
mode_is() { [[ $(stat -c %a "$1") == "$2" ]]; }
is_symlink() { [[ -L $1 ]]; }

# 1 SRC-001: pre-existing identical file survives apply+revert
scenario preexisting-identical
write_file "$work/s1.src" 'user content\n'; cp "$work/s1.src" "$work/s1.dest"
duo_install_file "$work/s1.src" "$work/s1.dest" >/dev/null 2>&1
duo_revert_manifest >/dev/null 2>&1
check '1 pre-existing identical file survives revert' content_is "$work/s1.dest" 'user content\n'

# 2 pre-existing different file: original content restored
scenario preexisting-different
write_file "$work/s2.dest" 'original\n'; write_file "$work/s2.src" 'module\n'
duo_install_file "$work/s2.src" "$work/s2.dest" >/dev/null 2>&1
duo_revert_manifest >/dev/null 2>&1
check '2 pre-existing different file restored' content_is "$work/s2.dest" 'original\n'

# 3 new file: created then removed by revert
scenario new-file
write_file "$work/s3.src" 'module\n'
duo_install_file "$work/s3.src" "$work/s3.dest" >/dev/null 2>&1
check '3a new file installed' content_is "$work/s3.dest" 'module\n'
duo_revert_manifest >/dev/null 2>&1
check '3b module-created file removed by revert' file_absent "$work/s3.dest"

# 4 module-created file, idempotent reapply, revert still removes it
scenario module-created-reapply
write_file "$work/s4.src" 'module\n'
duo_install_file "$work/s4.src" "$work/s4.dest" >/dev/null 2>&1
duo_install_file "$work/s4.src" "$work/s4.dest" >/dev/null 2>&1   # unchanged reapply
duo_revert_manifest >/dev/null 2>&1
check '4 module-created file removed after reapply+revert' file_absent "$work/s4.dest"

# 5 repeated applies over pre-existing file: revert restores original
scenario repeated-apply
write_file "$work/s5.dest" 'original\n'; write_file "$work/s5.src" 'module\n'
duo_install_file "$work/s5.src" "$work/s5.dest" >/dev/null 2>&1
duo_install_file "$work/s5.src" "$work/s5.dest" >/dev/null 2>&1
duo_revert_manifest >/dev/null 2>&1
check '5 repeated applies restore original' content_is "$work/s5.dest" 'original\n'

# 6 module-created file, source changes between applies: revert removes it
scenario src-change-module-created
write_file "$work/s6.src" 'v1\n'
duo_install_file "$work/s6.src" "$work/s6.dest" >/dev/null 2>&1
write_file "$work/s6.src" 'v2\n'
duo_install_file "$work/s6.src" "$work/s6.dest" >/dev/null 2>&1
duo_revert_manifest >/dev/null 2>&1
check '6 changed-source module file removed by revert' file_absent "$work/s6.dest"

# 6b pre-existing file, source changes between applies: revert restores original
scenario src-change-preexisting
write_file "$work/s6b.dest" 'original\n'; write_file "$work/s6b.src" 'v1\n'
duo_install_file "$work/s6b.src" "$work/s6b.dest" >/dev/null 2>&1
write_file "$work/s6b.src" 'v2\n'
duo_install_file "$work/s6b.src" "$work/s6b.dest" >/dev/null 2>&1
duo_revert_manifest >/dev/null 2>&1
check '6b changed-source pre-existing file restored' content_is "$work/s6b.dest" 'original\n'

# 7 SRC-001 review note: identical content but wrong mode is not a no-op
scenario mode-change
write_file "$work/s7.dest" 'user content\n'; chmod 600 "$work/s7.dest"
write_file "$work/s7.src" 'user content\n'
duo_install_file "$work/s7.src" "$work/s7.dest" 0644 >/dev/null 2>&1
check '7a mode enforced on apply' mode_is "$work/s7.dest" 644
duo_revert_manifest >/dev/null 2>&1
check '7b original mode and content restored' content_is "$work/s7.dest" 'user content\n' && mode_is "$work/s7.dest" 600

# 8 symlink destination: backed up and restored as a symlink
scenario symlink-dest
write_file "$work/s8.target" 'target content\n'; ln -s "$work/s8.target" "$work/s8.dest"
write_file "$work/s8.src" 'module content\n'
duo_install_file "$work/s8.src" "$work/s8.dest" >/dev/null 2>&1
if is_symlink "$work/s8.dest"; then check '8a symlink replaced by regular file' false; else check '8a symlink replaced by regular file' true; fi
duo_revert_manifest >/dev/null 2>&1
check '8b symlink restored by revert' is_symlink "$work/s8.dest"

# 9 unchanged identical pre-existing file is backed up exactly once, no dupes
scenario backup-once
write_file "$work/s9.dest" 'user content\n'; write_file "$work/s9.src" 'user content\n'
duo_install_file "$work/s9.src" "$work/s9.dest" >/dev/null 2>&1
duo_install_file "$work/s9.src" "$work/s9.dest" >/dev/null 2>&1
backup_count=$(find "$DUO_STATE_DIR" -path '*/backup/*' -type f | wc -l)
check '9 backup created exactly once across reapplies' test "$backup_count" -eq 1

printf '\ntest-burakgon-rollback-fix: %d passed, %d failed (source: %s)\n' "$pass" "$fail" "$source_tree"
((fail == 0))
