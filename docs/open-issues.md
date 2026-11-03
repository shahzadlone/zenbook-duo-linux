# Open issues and completed checkpoints

## Active

| ID | Priority | State | Next evidence/action |
| --- | --- | --- | --- |
| DUO-001 | High | DMC login freeze recovered, unresolved | Review full failed/current logs; current filtered query was clear at 16:41. Preserve effective boot config and evaluate one reversible trial if warranted. |
| DUO-002 | High | UX8407AA TCSS lower-panel risk, unpatched | Keep keyboard lifted at startup. Confirm symptoms/source compatibility and driver rollback before selecting xe DKMS. Do not conflate with DUO-001. |
| DUO-003 | High | Burakgon identical-file rollback bug reproduced | Resolve and test ownership semantics before relying on module revert. See SRC-001. |
| DUO-004 | High | Full installed-system logs not yet received | User will supply `zenbook-previous-first-boot.log`, `zenbook-current-fixed-boot.log`, and filtered output. Preserve originals and review publication. |
| DUO-005 | Medium | Kernel/package/boot baseline incomplete | Inventory installed regular/LTS kernels, headers, active module paths, generated Limine entries, actual mount layout, Secure Boot and snapshot configuration. Limine source config photo is available. |
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

Close an active issue only with the affected machine/kernel, evidence, validation conditions and rollback state recorded in a dated trial. If a workaround merely suppresses a symptom, say so and retain the maintenance obligation.
