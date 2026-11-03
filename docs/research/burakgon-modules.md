# Burakgon module assessment for UX8407AA / CachyOS / KDE

**All 23 modules are not applied at this handoff.** This is a selection plan, not a record of working hardware. The catalog preserves the reviewed module metadata and immutable source links. Reassess it against the running kernel and actual symptoms before installation.

## Candidate selection

| Module | Proposed handling | Reason / required validation |
| --- | --- | --- |
| [audio-cs35l56-ot25](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/audio-cs35l56-ot25) | Skip on current 7.3.1 | Targets incomplete 7.2.11 backport; do not duplicate upstream fix. |
| [audio-ghost-rt722](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/audio-ghost-rt722) | Skip on current 7.3.1 | Upstream 7.3 fix reported; test actual audio first. |
| [desktop-kde-duo](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/desktop-kde-duo) | Core integration candidate | Review dependencies, Qt build, actual display manager and lower-panel guard. |
| [desktop-power-widget](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/desktop-power-widget) | Optional; defer | Telemetry UI after core hardware is stable. |
| [display-dpcd-backlight](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/display-dpcd-backlight) | Candidate if brightness needs it | Verify effective xe parameter and actual panel brightness response. |
| [display-dsc-10bit](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/display-dsc-10bit) | Defer until stable | Colour-depth/DSC optimization; dependency and stability check required. |
| [display-edp2-tcss](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/display-edp2-tcss) | High-priority separate candidate | Fixes startup-dependent lower-panel power; resolve rollback/hooks and validate DKMS/initramfs first. |
| [display-psr-et-off](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/display-psr-et-off) | Conditional graphics candidate | Targets Panel Replay Early Transport/cursor artifacts; not a proven DMC remedy. |
| [keyboard-hid-asus](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/keyboard-hid-asus) | Core input candidate | Confirm IDs; use matching 7.3 source; validate docked/Bluetooth keys and LEDs. |
| [power-dtt](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/power-dtt) | Defer | Raises power limits via firmware tables; needs thermal and battery validation. |
| [power-kbd-lid-wake](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/power-kbd-lid-wake) | Candidate after sleep baseline | Investigate docked keyboard remote-wakeup behavior before applying. |
| [power-profile-sync](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/power-profile-sync) | Defer until power baseline | Profile mapping changes require mode transition tests. |
| [power-runtime-pm](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/power-runtime-pm) | Defer | Broad runtime-power policy; validate suspend and device behavior. |
| [power-tpm-rng](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/power-tpm-rng) | Optional; defer | Power/entropy policy, not a display repair. |
| [sensors-accel-mount](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/sensors-accel-mount) | With validated sensor setup | Coordinate mount matrix with desktop rotation ownership. |
| [sensors-ish-firmware](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/sensors-ish-firmware) | Core candidate if sensors fail | Verify ASUS package checksum/model and use firmware/updates path. |
| [system-health](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/system-health) | Pair with validated fixes | Useful ongoing checks/notifications; independently verify active drivers. |
| [touchpad-accel](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/touchpad-accel) | Optional; defer | Preference/performance library, not required to make the machine boot. |
| [touchpad-motion](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/touchpad-motion) | Conditional input candidate | Bluetooth timing and axis normalization; validate versions and behavior. |
| [touchpad-palm](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/touchpad-palm) | Input candidate after baseline | Test disable-while-typing/palm rejection with actual keyboard. |
| [touchscreen-hid](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/touchscreen-hid) | Core candidate after baseline | Inspect top touch binding; blacklist/calibrate only for matching hardware. |
| [wifi-powersave-ac](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/wifi-powersave-ac) | Optional; defer | Installer mirror slowness does not establish a Wi-Fi power-save defect. |
| [wifi-roam-deauth](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/wifi-roam-deauth) | Defer unless roaming defect observed | Additional mac80211 DKMS/hook compatibility; no local roaming failure recorded. |

## Apply in attributable groups

First resolve the observed DMC evidence and create recovery/rollback coverage. Inspect and correct SRC-001 before relying on the apply/revert framework. Confirm pacman hook compatibility before xe/mac80211 source-fetch hooks. Then compute the actual dependency closure for the chosen display/input/sensor group; module metadata is not permission to run the entire recommended preset.

Use the logged-in desktop user as the caller for KDE integration rather than a bare root login. Check the actual SDDM/plasmalogin service and avoid another Duo display controller. The reviewed helper is a C++/Qt service, not the Rust/Tauri runtime used by the other two broad installers.

The reviewed source offers commands such as `./duo list`, `./duo info MODULE`, `./duo status`, `./duo doctor`, `sudo ./duo apply MODULE...` and `sudo ./duo revert MODULE...`. These were researched, not executed on the target. Inspect implementations before running them; the isolated rollback reproduction shows why revert must not be assumed safe.

## Build and update checks

- xe/mac80211 sources must match the kernel package tree/tag. CachyOS uses `CachyOS/linux`, e.g. `cachyos-7.3.1-1`; `CachyOS/linux-cachyos` was an incorrect source-tree guess during research.
- Record every installed kernel, headers, DKMS version, source tag and build log. Unsupported/excluded LTS builds and real compilation failures need separate classification.
- Confirm module paths and effective parameters after boot, including the TCSS marker if that patch is applied. Inspect the initramfs and generated Limine entries rather than trusting a command exit code.
- Test kernel upgrades using a retained recovery entry and explicit rollback. Revisit 7.4+ keyboard source availability and whether upstream has absorbed workarounds.
- Secure Boot is currently on the disabled-boot path. If later enabling it, the bootloader/kernel/module-signing chain needs a separate validated plan; do not merely toggle firmware back on after adding unsigned DKMS drivers.

## What this plan deliberately leaves undecided

No full-kernel patch, blanket recommended apply, power-limit increase, optional touchpad curve, broad runtime-PM policy or Wi-Fi DKMS change has been executed or selected as the concrete next trial in the preserved handoff. The user selected the Burakgon approach; choose its exact fixes from local evidence and document them within that scope.

Full metadata: [burakgon-module-catalog.json](burakgon-module-catalog.json). Source risks: [source-review-findings.md](source-review-findings.md). Current machine: [profile](../../machines/ux8407aa-2026/README.md).
