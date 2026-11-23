# Machine: 2026 Zenbook Duo UX8407AA

## Identity and installation

| Field | Evidence/state |
| --- | --- |
| Model | User identified UX8407AA; kernel photograph says ASUS Zenbook Duo UX8407AA/UX8407AA. |
| CPU platform | UX8407AA Panther Lake platform; exact CPU SKU not captured from this user's machine. Do not copy the research author's X9/Arc B390 configuration. |
| Memory | Live zram showed 30.8 GiB; approximately 32 GiB installed is an inference, not a collected DIMM report. |
| Internal disk | KIOXIA KBG60ZNV1T02, `/dev/nvme0n1`, 953.9 GiB in installer/live output. |
| Firmware | Kernel photograph: UX8407AA.305, date text `02/10/2026`. No firmware update performed. |
| OS | CachyOS desktop, rolling; KDE Plasma selected; Wayland confirmed. |
| Kernel | Live USB: 7.1.6-1-cachyos. Installed at incident: 7.3.1-1-cachyos (see reviewed logs). Running as of 2026-11-22: 7.3.3-1-cachyos after user system update; LTS 6.18.60-2 also installed with both header packages. No stability qualification on 7.3.3 yet. |
| Other kernel | Installer package list included linux-cachyos-lts 6.18.55-2 and both headers; installed package inventory still needed. |
| Bootloader | Limine selected; `/etc/default/limine` photographed at 16:41, with /boot ESP path and encrypted-root arguments. Effective `/proc/cmdline` and generated entries still to inspect. |
| Root/boot | Installer created LUKS2 + Btrfs root and a separate 4 GiB FAT32 /boot; installed mount inventory pending. |
| Shell | Installed Konsole photograph shows Fish. |
| Secure Boot | Initial USB boot failed signature policy. Disable flow supplied and subsequent USB boot succeeded. Current state not measured. |
| Locale | Installer summary: America/Toronto, en_CA, English US/default keyboard, Generic 105-key PC. |

## Hardware behavior ledger

| Feature | Local result |
| --- | --- |
| Wi-Fi | Worked in live session; installed system: Intel BE201 (Wi-Fi 7) on iwlwifi/iwlmld, connected; UFW firewall active. |
| Desktop/login | Eventually successful after cold recovery; initial login froze. No freeze recurrence Nov 3–22. |
| Displays | eDP-1 enabled 2880x1800@144, scale 2, rotation 4 (180°), geometry 0,0; eDP-2 connected but disabled (user intent unconfirmed). Brightness control supported on both. |
| xe plane faults | Chronic, non-fatal: 131 `PLANE ... fault (SURF==SURFLIVE)` lines on pipe A in current boot (7.3.3), also on 7.3.1 working boot; "Selective fetch area calculation failed in pipe A" at init. |
| Upper-panel touchscreen (RAYD0001) | Kernel Oops 2026-11-21 20:13 EST: NULL deref in `raydium_i2c_irq`, IRQ #108 disabled; touch status since then unconfirmed. |
| Lower-panel touch/stylus (RAYD0002) | Devices enumerated (touch, stylus, unknown); function untested. Nov 3 log showed one `incomplete report` warning. |
| Keyboard typing | Worked during installation and for encryption/user interaction; freeze association unproven. Docked over internal USB (0b05:1cd7). Detached: dead — Bluetooth never paired (upstream pairing procedure identified: F11 pairing key, bluetoothctl scan le, passkey on keyboard). |
| Panel orientation | eDP-1 physically mounted 180° (upstream-confirmed); user's manual KDE rotation is the correct workaround; early-boot/TTY output appears upside down. |
| Battery | 94.46/98.97 Wh (95%), reported Full, 0 W draw at capture. |
| Sensors | Fans, NVMe, ACPI thermal zones readable via lm-sensors. |
| Top touch, bottom touch, pen | Pending independent tests. |
| Backlight/Fn/media keys | Pending. |
| Speakers, microphone, headset | Pending; upstream 7.3 audio fixes do not prove local audio success. |
| Rotation sensors/hinge/ALS | Pending. |
| Bluetooth/detached keyboard | Pairing and functional state pending. |
| Sleep/resume/lid wake | Pending. |
| Webcam/IR/NPU/video acceleration | Pending; upstream claims only. |
| Battery/runtime/power modes | Pending. |

Every Burakgon module is `not_applied` in the initial [state record](state.json). The [module assessment](../../docs/research/burakgon-modules.md) is a plan, not an installation ledger of completed work.

## Storage before installation

USB `/dev/sda` was 14.4 GiB with approximately 2.9 GiB ISO9660 and 23 MiB EFI partitions. Internal partitions were 450 MiB FAT32 EFI, 16 MiB reserved, 927.9 GiB BitLocker Windows, approximately 1.3 GiB NTFS recovery, 24 GiB NTFS recovery and 260 MiB FAT32. User explicitly approved replacing all of them. That approval is machine-specific.

## Related records

- [Installation journal](../../docs/journey/2026-11-03.md)
- [Graphics freeze](../../docs/troubleshooting/graphics-freeze.md)
- [Installer timeout](../../docs/troubleshooting/installer-keyring-timeout.md)
- [Evidence](../../evidence/README.md)
- [Current handoff](../../docs/handoff.md)
