# Open issues and completed checkpoints

## Active

| ID | Priority | State | Next evidence/action |
| --- | --- | --- | --- |
| DUO-001 | High | DMC freeze observed once (2026-11-03); not recurred through 2026-11-22 on boots -3..0 | Keep `xe.enable_dc=0` one-boot trial in reserve if it recurs. Chronic non-fatal xe plane faults on pipe A (131 lines on current boot) recorded separately. |
| DUO-010 | High | NEW: raydium touchscreen IRQ Oops disabled IRQ #108 on 2026-11-21 (kernel 7.3.3) | NULL deref in `raydium_i2c_irq+0x138 [raydium_i2c_ts]` on RAYD0001; IRQ thread died, "nobody cared", IRQ disabled. Confirm whether RAYD0001 touch is dead since then; check upstream for fix; reboot restores pending test. |
| DUO-002 | High | UX8407AA TCSS lower-panel risk, unpatched | Keep keyboard lifted at startup. Confirm symptoms/source compatibility and driver rollback before selecting xe DKMS. Do not conflate with DUO-001. |
| DUO-003 | High | SRC-001 fixed and tested in reviewed local checkout; not upstream, not yet in system use | Patch + 13-scenario matrix pass; see 2026-11-22 trial. Remaining: decide whether to use the fixed lib for the first real apply, and whether to propose it upstream. |
| DUO-004 | High | Full installed-system logs received, reviewed and published 2026-11-22 | See `logs/reviewed/2026-11-03-ux8407aa/`. Originals checksummed; only MAC addresses redacted. Close after confirming no further intake expected for this incident. |
| DUO-005 | Medium | Kernel/package/boot baseline complete 2026-11-22 | Diagnostics capture `20261123T030620Z-RVwiDq`: mounts, subvolumes, limine.conf entries (7.3.3 + LTS + 25 snapshot entries), Secure Boot disabled, xe parameters (all auto/-1), battery 94.5/99 Wh, sensors working, UFW active. Snapshot rollback path untested. |
| DUO-006 | Medium | Core hardware validation incomplete | Observed: both panels present (eDP-1 enabled rotated 180°, eDP-2 connected disabled — user intent unconfirmed); brightness control supported; RAYD0001 touchscreen suspect since Nov 21 crash; RAYD0002 touch/stylus devices enumerated. Still to test: dock matrix, audio, BT, sleep, Fn, pen mapping. |
| DUO-007 | Medium | Pacman hook capability unverified | Check actual libalpm support and upstream PR #2 status before installing source-fetch hooks. |
| DUO-008 | Medium | Update/rollback procedure not exercised | Preserve /boot separately from root snapshots; test module rebuild and kernel-update recovery. |
| DUO-009 | Future | UX8406MA/CA route unselected | Verify exact model and desktop preference; assess Zakstam/Cceelen with fresh sources and native live tests. |

## Completed checkpoints, with limits

| ID | Result | Evidence/limit |
| --- | --- | --- |
| DONE-001 | Usable official CachyOS USB prepared | Hash/signature checks from earlier session; Rufus log and successful live boot. No full USB byte verification. |
| DONE-002 | USB boot after Secure Boot violation | User reached live system. Firmware setting not remeasured. |
| DONE-003 | Live Wi-Fi and Wayland baseline | User outputs and 14:27 photograph. |
| DONE-004 | Installer timeout identified and retry completed | Failed log, exact source match, tested config edit, later successful user installation. Successful full installer log missing. |
| DONE-005 | Installed desktop reached | User reports successful login after cold recovery. One boot is not stability qualification. |
| DONE-006 | Kernel/Wayland and DMC signature established | User confirms 7.3.1-1-cachyos/Wayland; previous-boot warning photograph. |
| DONE-007 | Current filtered journal and Limine config collected photographically | No matches for specified graphics patterns at 16:41; complete current log still pending. |
| DONE-008 | Full failed/current kernel logs received, reviewed and published | `logs/reviewed/2026-11-03-ux8407aa/` with SHA-256 provenance; kernel-only journals, MAC redaction only. No 7.3.3 stability evidence yet. |

Close an active issue only with the affected machine/kernel, evidence, validation conditions and rollback state recorded in a dated trial. If a workaround merely suppresses a symptom, say so and retain the maintenance obligation.
