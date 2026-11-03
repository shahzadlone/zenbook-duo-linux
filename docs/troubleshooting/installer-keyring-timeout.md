# Installer failure: keyring command exceeds 30 seconds

Status: **installation recovered; root cause identified in retained failed log**. This was a live-installer configuration issue, separate from post-install graphics problems.

Evidence: [installer log](../../evidence/2026-11-03-ux8407aa/installer-failed.redacted.log), [upstream issue 236](https://github.com/CachyOS/cachyos-calamares/issues/236), [proposed fix 237](https://github.com/CachyOS/cachyos-calamares/pull/237), [official retry advice](https://wiki.cachyos.org/installation/installation_on_root/).

The keyring script starts at 14:47:35; ca.mirror.cx consumes two roughly ten-second timeouts; the archlinux-keyring upgrade begins; Calamares kills the step at 14:48:05. The installed module configuration omitted an explicit timeout for that command, inheriting 30 seconds. The neighboring mirror-ranking command already had 3600 seconds.

The targeted change is `timeout: 3600` below the keyring command in `/etc/calamares/modules/shellprocess_initialize_pacman.conf`. The complete historical edit and launch sequence are in the [journal](../journey/2026-11-03.md). Use them only after checking a future installer's actual configuration. Bash syntax from that live session is not automatically valid pasted into Fish.

Reboot the ISO after a failed install to clear mounts. The Welcome launcher runs preparation and installs/updates Calamares, so apply the change after that preparation and launch the installer directly. The session used `pkexec-wrapper calamares -D6` with output appended through tee.

The edit was tested for the exact source change and repeat application. The user later passed this step and completed installation; a successful full retry log was not supplied. The larger timeout allows mirror fallback and slow key preparation, but cannot repair permanently broken networking. Do not disable package signature verification to address this error.

Disk changes precede this step. On this machine, GPT/LUKS2/Btrfs creation had already removed Windows. The failure did not roll the disk back. That was within the user's explicit erase authorization; on a different installation, assess consequences from the actual log rather than assuming a failed installer left existing data intact.
