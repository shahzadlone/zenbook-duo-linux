# Decision register

| ID | Date | Decision | Reason and qualification |
| --- | --- | --- | --- |
| DEC-001 | 2026-11-03 | Work on UX8407AA first. | User prioritized the new 2026 machine; older machine remains a separate future task. |
| DEC-002 | 2026-11-03 | CachyOS + KDE Wayland + selected Burakgon modules. | Aligns model/distro/desktop with the modular implementation; selection remains conditional on source/diagnostic review. |
| DEC-003 | 2026-11-03 | Replace Windows and recovery partitions on the 2026 internal SSD. | Explicit user confirmation that backups exist and loss is accepted. Not authorization for another disk/machine. |
| DEC-004 | 2026-11-03 | Btrfs + LUKS2, separate FAT32 /boot; Limine. | Chosen installer path; encryption confirmed in actual install log; actual mounted layout needs local verification. |
| DEC-005 | 2026-11-03 | Keep keyboard off lower screen at startup pending validated TCSS handling. | Documented model-specific power issue; not proof this prevents every graphics freeze. |
| DEC-006 | 2026-11-03 | Raise the live installer's keyring timeout, then retry after a reboot. | Exact log matches missing 30-second timeout; avoids unnecessary kernel/distro changes for an installer bug. |
| DEC-007 | 2026-11-03 | Let active downloads continue despite a stationary percentage. | Received-byte measurements and later stage transitions supported progress. |
| DEC-008 | 2026-11-03 | Preserve graphics evidence and separate DMC from TCSS. | Same visual symptom can have different driver causes; current log supports DMC failure area. |
| DEC-009 | 2026-11-03 | Do not yet run a full recommended module set or stack competing installers. | Rollback risk, kernel-specific applicability and overlapping runtime ownership need handling first. |
| DEC-010 | 2026-11-03 | Store this folder as the user's GitHub repository on main. | Explicit user request for persistent agent context, research, trials, logs and future model profiles. |
| DEC-011 | 2026-11-03 | Keep originals private/ignored; publish reviewed evidence. | Actual photographs contain GPS metadata; kernel/setup logs can contain identifiers. Pixel-preserving metadata removal and documented log redaction retain diagnostic value. |

Proposed but **not decided/applied**: `xe.enable_dc=0` diagnostic trial; any BIOS update; exact module dependency group; external-keyboard availability; a distribution for the old machine; Secure Boot signing for future DKMS drivers; hibernation support.
