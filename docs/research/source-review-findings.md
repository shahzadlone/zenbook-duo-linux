# Source-review findings that affect the next step

All line references refer to the pinned source snapshot unless updated by a later dated trial. These are not claims that an entire repository was formally audited.

## SRC-001: revert can delete an identical pre-existing file

**Status: reproduced against pinned upstream (2026-11-22, reconfirmed); fixed and tested in a reviewed local checkout — not upstream, not yet in use on the laptop.**

Source: [Burakgon lib/actions.sh](https://github.com/burakgon/zenbook-duo-2026-linux/blob/8030783aac5273da5f2aa0da217a6bc408ee0533/lib/actions.sh), `duo_install_file`, `_existing_backup`, `_backup_once`, `duo_revert_manifest`.

The bug: an unchanged (byte-identical) destination is recorded with `_existing_backup`, which returns `-` when the module never backed the file up; revert interprets `-` as module ownership and removes the file. A related finding: the content-equality branch ignored the requested mode, and symlinks were not excluded from the unchanged shortcut.

Fix (see [the trial](../trials/2026-11-22-burakgon-rollback-fix.md) and [patch](../../evidence/research/burakgon-rollback-fix.patch)): back up a pre-existing identical destination before recording; module-created files still get removed because their older `-` manifest line wins on newest-first replay; enforce mode; exclude symlinks from the unchanged shortcut. The 13-scenario [test matrix](../../scripts/test-burakgon-rollback-fix.sh) passes fully on the fixed checkout and reproduces the bug on pristine.

## SRC-002: pacman hook syntax is distribution-dependent

**Status: verified in code and open PR; target pacman capability not measured.**

[PR #2](https://github.com/burakgon/zenbook-duo-2026-linux/pull/2) concerns `NetworkAccess = allowed` in xe/mac80211 source-fetch hooks. CachyOS's pacman isolation extension and upstream Arch pacman do not necessarily support identical hook syntax even at the same nominal version. On unsupported implementations an invalid hook option can block package transactions.

The proposed helper checks libalpm for support and omits the option where it is unknown; its patch was inspected, not applied. The source comment that broadly attributes this behavior to “pacman 7.1” needs the distro qualification. Check actual capabilities and current PR status before using either affected module.

## SRC-003: success must be verified beyond helper exit status

**Status: source-verified.** `duo_dkms_install` reports excluded or failed kernel builds without necessarily aborting the entire transaction. Bootloader/initramfs regeneration also has warning paths. Inspect DKMS status/build logs, `modinfo -n`, required module parameters, generated boot entries and initramfs contents. In particular, confirm that xe in the boot image is the intended replacement; a source directory or healthy-looking install message is insufficient.

## SRC-004: model and kernel scope

**Status: source-verified; not exercised on this user's hardware.** The Burakgon framework's DMI guard is UX8407-oriented. Keyboard driver source variants were provided for 7.2 and 7.3; 7.4 needs reassessment. TCSS and Wi-Fi replacements fetch the installed kernel's source and apply patches, so a later kernel may require patch adaptation even if the module declares a broad version range. The regular 7.3.1 kernel and the installer-listed 6.18 LTS kernel must not be assumed to have equal hardware support.

## SRC-005: firmware and desktop ownership

**Status: source-verified.** The sensor module fetches an ASUS driver package with checksum verification and installs model-specific firmware under `/usr/lib/firmware/updates/...`. This is preferable to silently overwriting a distribution firmware file, but still requires matching hardware, verified extraction and documented provenance. Do not commit firmware binaries here.

The KDE helper controls rotation/layout, touch mapping, brightness and dock behavior, including login integration and a lower-panel guard. Hinge-posture automation was not fully implemented in the reviewed report. Confirm the actual display manager (SDDM versus plasmalogin), desktop version and service owner; do not copy a user-specific login configuration blindly.

## SRC-006: optional behavior is not a necessary repair

**Status: source-verified selection concern.** `--recommended` includes power limits, runtime power policy, Wi-Fi behavior and other changes in addition to display/input fixes. Those require separate workload/battery/suspend validation. An optional Apple-like touchpad acceleration module is especially unnecessary for initial stability. The [module assessment](burakgon-modules.md) separates candidates from deferred choices.

## SRC-007: no confirmed DMC remedy from a matching report

**Status: local pattern match; cause unresolved.** The user's DMC/wakelock/dual-pipe log resembles the reviewed author's first 7.3.0 login freeze. The report says it did not recur in subsequent boots; it does not identify a tested permanent DMC fix. Do not turn that absence of recurrence into a causal claim for a module or a boot parameter.

## Review limits

No full kernel, Rust runtime or UI was compiled. No hardware module was installed. No suspend, lid, power-limit or dock stress test was performed on the new laptop. Temporary source checkouts are research inputs, not deployed code. Audit claims and local validation must remain separate in future updates.
