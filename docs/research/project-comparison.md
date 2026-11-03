# Research snapshot and selection rationale

Reviewed on 2026-11-03. Commits and sampled issue/release/CI metadata are preserved in [sources.json](sources.json). These projects are community implementations, with different hardware, desktop and kernel assumptions. Activity is useful context, not evidence of correctness. No complete upstream project's build/test suite was run in this session, and no project was installed on either user machine.

## Compared implementations

| Project and reviewed commit | Architecture and stated test scope | Decision for this installation |
| --- | --- | --- |
| [Burakgon](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533), `8030783a`, Oct 29 | UX8407AA-focused shell module framework; selective config/firmware fixes; several DKMS driver replacements; KDE integration via a Qt/C++ helper. Author's principal environment is Arch/CachyOS/KDE Wayland. | Preferred **selected-module** route for UX8407AA/CachyOS/KDE after source-review issues and recovery are addressed. No full custom kernel inherently required by this approach. |
| [therealarnold666 Ubuntu fork](https://github.com/therealarnold666/zenbook-duo26-Ubuntu26.04/tree/39055b6c0772f1a049e46d5ed3549117251c1bce), `39055b6c`, Oct 24 | Rust system daemon/lifecycle helper/session agent, Tauri control panel and desktop setup scripts. Principal documented known-good UX8407AA environment: Ubuntu 26.04 + GNOME Wayland + custom 7.2-rc4-derived kernel. Extensive kernel/display investigations. | Valuable source of TCSS/audio investigations and patches. Its full installer is not the selected CachyOS stack. Custom kernel is separate from its installer. |
| [Zakstam](https://github.com/zakstam/zenbook-duo-linux/tree/a6331be81dcd0e14e3574f73b13fc0a6c628b2e9), `a6331be8`, Nov 3 | Rust runtime and Tauri UI, multiple desktop backends; apt/dnf/pacman support. Lists UX8406MA/CA and UX8407AA, with extra 2026 kernel/firmware preparation. | Serious candidate for older models or alternative desktop workflows. Its 2026 instructions still require separate kernel preparation and a broader parameter/firmware approach; not combined with Burakgon here. |
| [Cceelen UX8406 packages](https://github.com/cceelen/asus-zenbook-duo-ux8406/tree/c450381e6c263e9a767761097928a99b2acc2f42), `c450381e`, Nov 3 | Packaged thermal guard, second-screen support, HID-BPF keyboard, GNOME keys and rotation. Published packages across several distros; hardware-tested UX8406CA/Fedora 44/GNOME 50. | Useful UX8406 route, especially for GNOME/Fedora. Explicitly not hardware-tested on UX8406MA in reviewed docs, and not a UX8407AA solution. |

## Why kernel-patching advice conflicts

The posts refer to different generations, kernel versions and failure classes. A userspace daemon can arrange displays or react to dock events; it cannot supply missing kernel TCSS power sequencing. Conversely, an already-upstream audio fix should not be reapplied just because an older guide used a custom kernel.

For the reviewed 2026 stack:

- Audio changes described for 7.2 are reported upstream in 7.3. The user's kernel is 7.3.1, so audio should be tested before adding old DKMS replacements.
- The lower-panel TCSS change was still an upstream proposal in the retained research. Burakgon carries a targeted xe DKMS build from the exact installed kernel source, avoiding a whole custom kernel in normal operation.
- Keyboard, sensor firmware, touch binding, panel orientation and desktop coordination are separate concerns.
- DMC login freezes are a separate observed failure family. A TCSS patch should not be sold as its proven remedy.

References: [audio module](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/audio-ghost-rt722), [TCSS implementation](https://github.com/burakgon/zenbook-duo-2026-linux/tree/8030783aac5273da5f2aa0da217a6bc408ee0533/modules/display-edp2-tcss), [Ubuntu kernel report](https://github.com/therealarnold666/zenbook-duo26-Ubuntu26.04/blob/39055b6c0772f1a049e46d5ed3549117251c1bce/UX8407AA_KERNEL_AND_RUNTIME_FIXES_2026-07-27.md), [Zakstam 2026 setup](https://github.com/zakstam/zenbook-duo-linux/blob/a6331be81dcd0e14e3574f73b13fc0a6c628b2e9/README.md).

## Source and maintenance observations

**Burakgon:** Small individually selectable fixes make it possible to attribute changes and retire workarounds as upstream improves. However, the reviewed recommended set includes most modules, including power and Wi-Fi behavior changes; it is not a minimal hardware-repair preset. No releases or Actions runs appeared in the sampled API data. The source audit found a reproduced file-ownership rollback defect. PR #2 was open and addressed pacman `NetworkAccess` compatibility. Build and regeneration helpers can downgrade failures to messages; validate actual results.

**Ubuntu fork:** Its display investigation separates the lower-panel PHY power problem from broad PSR/DSB experiments. The supplied TCSS patch includes a broader diagnostic delta than Burakgon's narrowed runtime replacement. Open reports covered dock events doing nothing, disappearing dual-screen switching, daemon/session logs, Bluetooth restart side effects, brightness and wake behavior; these are user reports, not universal failures. Two open PRs addressed GNOME locale parsing and Bluetooth hidraw selection. Sampled releases/Actions results were empty.

**Zakstam:** Has explicit multi-generation and multi-compositor support, with feature-oriented documentation and active changes, including a same-day Hyprland lower-screen fix. It currently excludes X11 and atomic distributions such as Bazzite/Silverblue in its README; an atomic-distro request remained open. Its reviewed UX8407AA guide proposes a custom kernel and an `IgnorePkg` hold plus a firmware-file replacement. Those require an update/security maintenance plan and should not be copied into the selected modular CachyOS route. Sampled releases/Actions results were empty.

**Cceelen:** Had release v0.5.0 dated Oct 7 and successful sampled release/codeql/plumber runs at the reviewed commit. Its compatibility table distinguishes package installation in containers from tests on real hardware; keep that distinction. Open reports include UX8406MA test coverage, charge-limit anomalies and window restoration on the lower screen. A PR proposed changing GNOME extension packaging. The GNOME-only components do not supply KDE integration.

These are bounded snapshots of API results, not exhaustive repository-history audits. See the individual issue URLs in the source index for live status.

## Distribution choice

The user chose CachyOS/KDE/Wayland for UX8407AA. It provides recent kernels and aligns with Burakgon's tested environment, while requiring attention to rolling kernel updates, DKMS compatibility and recovery. The decision was not that CachyOS is universally the most stable distribution for every Zenbook Duo.

Ubuntu 26.04/GNOME is a documented environment for the Ubuntu fork, but the kernel delta and runtime still need maintenance. Fedora/GNOME is attractive to investigate for the UX8406CA package route because that is Cceelen's hardware-tested combination. UX8406MA and other desktops need their own evidence. Reassess distribution/kernel choices when moving machines or revisiting this record months later.

## Coexistence and licensing

These stacks can overlap display control, input rules, system services and `/var/lib/zenbook-duo` state. Choose one runtime owner per feature; inspect installed services and file ownership before migration. Do not run all installers to “get all fixes.”

The reviewed repositories declare GPL-2.0 (Burakgon), GPL-3.0 (Ubuntu/Zakstam) and MIT (Cceelen). This repository links and analyzes their work rather than vendoring entire source trees or firmware binaries. Preserve applicable notices when future patches/code are imported.
