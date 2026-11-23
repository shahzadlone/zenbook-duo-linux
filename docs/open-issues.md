# Open issues and completed checkpoints

## Active

| ID | Priority | State | Next evidence/action |
| --- | --- | --- | --- |
| DUO-001 | High | DMC login freeze recovered, unresolved; full logs reviewed 2026-11-22 | Failed boot shows WARNING at `intel_dmc_wl.c:227` reached from `gen9_set_dc_state` (display DC-state transition); keyboard USB disconnected mid-incident. Working boot has repeated pipe A plane 5A faults instead. Evaluate one-boot `xe.enable_dc=0` trial. |
| DUO-002 | High | UX8407AA TCSS lower-panel risk, unpatched | Keep keyboard lifted at startup. Confirm symptoms/source compatibility and driver rollback before selecting xe DKMS. Do not conflate with DUO-001. |
| DUO-003 | High | SRC-001 fixed and tested in reviewed local checkout; not upstream, not yet in system use | Patch + 13-scenario matrix pass; see 2026-11-22 trial. Remaining: decide whether to use the fixed lib for the first real apply, and whether to propose it upstream. |
| DUO-004 | High | Full installed-system logs received, reviewed and published 2026-11-22 | See `logs/reviewed/2026-11-03-ux8407aa/`. Originals checksummed; only MAC addresses redacted. Close after confirming no further intake expected for this incident. |
| DUO-005 | Medium | Kernel/package/boot baseline partially complete | Collected 2026-11-22: linux-cachyos 7.3.3 + LTS 6.18.60 both with headers, no DKMS installed, Secure Boot disabled (efivar 0x00), snapper `root` config, Limine `BOOT_ORDER="*, *lts, *fallback, Snapshots"`. Still pending: mount layout, generated Limine entries in `/boot`, current-boot journal, snapshot coverage test. |
| DUO-006 | Medium | Core hardware validation incomplete | Both displays, touch/pen, rotation, brightness, audio, keyboard/Fn, Bluetooth and sleep tests; record before/after. |
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
