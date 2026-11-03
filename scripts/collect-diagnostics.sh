#!/usr/bin/env bash
# Read-only system probes; output is private until reviewed. No package installs.
set -u
umask 077

usage() {
    cat <<'EOF'
Usage: bash scripts/collect-diagnostics.sh [--sudo]

Run on the actual native-Linux laptop, preferably from its desktop session.
Writes a timestamped directory under this checkout's ignored .local/diagnostics/.
--sudo requests sudo authentication for restricted read-only probes.
Without --sudo, permission errors are recorded and collection continues.
The collector refuses WSL, never installs software, and never uploads files.
Raw journals/configuration may contain identifiers. Review before publication.
EOF
}

privileged=0
case "${1:-}" in
    --help|-h) usage; exit 0 ;;
    --sudo) privileged=1 ;;
    '') ;;
    *) usage >&2; exit 2 ;;
esac
if (($# > 1)); then usage >&2; exit 2; fi

if [[ $(uname -s) != Linux ]]; then
    echo 'Run this collector on the installed Linux laptop.' >&2
    exit 2
fi
if grep -qiE 'microsoft|wsl' /proc/sys/kernel/osrelease; then
    echo 'WSL detected: this shell is not the native Zenbook Linux installation. No capture created.' >&2
    exit 2
fi

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
mkdir -p -- "$repo_root/.local/diagnostics"
capture_dir=$(mktemp -d "$repo_root/.local/diagnostics/$(date -u +%Y%m%dT%H%M%SZ)-XXXXXX")
sudo_prefix=()
if ((privileged && EUID != 0)); then
    if ! sudo -v; then
        echo "sudo authentication failed. Empty capture directory: $capture_dir" >&2
        exit 1
    fi
    sudo_prefix=(sudo -n)
fi

record() {
    local filename=$1 rc
    shift
    {
        printf 'Captured UTC: %s\nCommand:' "$(date -u +%FT%TZ)"
        printf ' %q' "$@"
        printf '\n\n'
        "$@"
        rc=$?
        printf '\n[exit_status=%s]\n' "$rc"
    } >"$capture_dir/$filename" 2>&1
    printf '%s\t%s\n' "$filename" "$rc" >>"$capture_dir/status.tsv"
}

record identity.txt bash -c '
    uname -srmo
    cat /etc/os-release
    for field in sys_vendor product_name board_name bios_version bios_date; do
        printf "%s: " "$field"
        cat "/sys/class/dmi/id/$field" 2>/dev/null || true
    done
    printf "session_type=%s desktop=%s shell=%s\n" "${XDG_SESSION_TYPE:-unknown}" "${XDG_CURRENT_DESKTOP:-unknown}" "${SHELL:-unknown}"
    systemd-detect-virt || true
'
record mounts.txt lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
record root-mount.txt findmnt /
record boot-mount.txt findmnt /boot
record command-line.txt cat /proc/cmdline
record limine-defaults.txt "${sudo_prefix[@]}" cat /etc/default/limine
record limine-entries.txt "${sudo_prefix[@]}" cat /boot/limine.conf
record journal-boots.txt "${sudo_prefix[@]}" journalctl --list-boots --no-pager
record kernel-current.log "${sudo_prefix[@]}" journalctl -b 0 -k --no-pager
record kernel-previous.log "${sudo_prefix[@]}" journalctl -b -1 -k --no-pager
record graphics-current-filter.log "${sudo_prefix[@]}" journalctl -b 0 -k --no-pager -g 'DMC wakelock|DBuf|flip_done|PHY B|PSR|DSB|raydium|hid-asus' -n 100
record xe-module.txt modinfo xe
record xe-parameters.txt "${sudo_prefix[@]}" bash -c '
    for field in enable_dc enable_dmc_wl enable_psr enable_panel_replay enable_dpcd_backlight zenbook_duo_edp2_tcss; do
        printf "%s: " "$field"
        cat "/sys/module/xe/parameters/$field" 2>/dev/null || printf "unavailable\n"
    done
'
record modules.txt lsmod
record pci.txt lspci -nnk
record usb.txt lsusb
record kernel-directories.txt ls -la /usr/lib/modules
record display-manager.txt systemctl status display-manager --no-pager
record system-services.txt systemctl list-units --type=service --all --no-pager
record user-services.txt systemctl --user list-units --type=service --all --no-pager

if command -v pacman >/dev/null; then
    record packages.txt pacman -Q
    record pacman-version.txt pacman -V
    record pacman-hooks.txt "${sudo_prefix[@]}" bash -c '
        for file in /etc/pacman.d/hooks/*; do
            [[ -f $file ]] || continue
            printf "\nFILE %s\n" "$file"
            cat "$file"
        done
    '
fi
if command -v dkms >/dev/null; then record dkms.txt "${sudo_prefix[@]}" dkms status; fi
if command -v kscreen-doctor >/dev/null; then record displays.txt kscreen-doctor -o; fi
if command -v wpctl >/dev/null; then record audio.txt wpctl status; fi
if command -v snapper >/dev/null; then record snapper-configs.txt "${sudo_prefix[@]}" snapper list-configs; fi
if command -v mokutil >/dev/null; then record secure-boot.txt mokutil --sb-state; fi
if command -v nmcli >/dev/null; then record network-state.txt nmcli general status; fi

cat >"$capture_dir/README.txt" <<'EOF'
Read-only diagnostic capture. Raw files may include private identifiers.
status.tsv records exit codes; absent commands/permissions are not hardware failures.
The previous boot may not be the boot that froze. Check journal-boots.txt.
No modules, settings, packages or boot entries were changed by this collector.
Review/redact selected evidence before adding it to Git. Do not publish this
directory wholesale or infer a permanent fix from a clear filtered log alone.
EOF
printf 'Capture saved to: %s\nReview status.tsv and preserve this raw directory privately.\n' "$capture_dir"
