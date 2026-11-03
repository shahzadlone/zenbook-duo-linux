#!/usr/bin/env bash
# Reproduce SRC-001 against the reviewed source in disposable paths only.
set -euo pipefail
if [[ ${1:-} == --help || $# != 1 ]]; then
    echo 'Usage: bash scripts/reproduce-burakgon-rollback.sh /path/to/reviewed-burakgon-checkout'
    exit 0
fi
if ((EUID == 0)); then echo 'Run this isolated test as an ordinary user, not root.' >&2; exit 2; fi
source_tree=$(cd -- "$1" && pwd)
expected=8030783aac5273da5f2aa0da217a6bc408ee0533
actual=$(git -C "$source_tree" rev-parse HEAD)
if [[ $actual != "$expected" ]]; then
    echo "Refusing unreviewed source commit $actual; expected $expected." >&2
    exit 2
fi
if ! git -C "$source_tree" diff --quiet HEAD -- lib/common.sh lib/actions.sh; then
    echo 'Reviewed helper files have local modifications; inspect them before adapting the reproducer.' >&2
    exit 2
fi
repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mkdir -p -- "$repo_root/.local"
trial_dir=$(mktemp -d "$repo_root/.local/rollback-XXXXXX")
trap 'rm -rf -- "$trial_dir"' EXIT
export DUO_STATE_DIR="$trial_dir/state"
source "$source_tree/lib/common.sh"
source "$source_tree/lib/actions.sh"
MOD_ID=identical-preexisting-file
printf 'pre-existing user-owned content\n' >"$trial_dir/source"
cp -- "$trial_dir/source" "$trial_dir/destination"
duo_install_file "$trial_dir/source" "$trial_dir/destination" >/dev/null
if [[ ! -f $trial_dir/destination ]]; then echo 'Unexpected: apply removed the file.'; exit 1; fi
duo_revert_manifest >/dev/null
printf 'Source commit: %s\n' "$actual"
printf 'Scenario: destination existed before apply and had identical content.\n'
printf 'After apply: destination present.\n'
if [[ ! -e $trial_dir/destination ]]; then
    echo 'After revert: destination missing.'
    echo 'SRC-001 REPRODUCED: revert deleted an unowned, pre-existing identical file.'
    echo 'Only disposable test files were affected; the temporary directory was cleaned.'
else
    echo 'SRC-001 NOT REPRODUCED: inspect the code and update the record.'
    exit 1
fi
