# Current handoff: UX8407AA on CachyOS

Recorded 2026-11-03; updated 2026-11-22 (local agent session on the laptop). Read this before any installer, package or bootloader mutation.

## 2026-11-22 update: native agent session active

- The repository is cloned on the target laptop (`/home/s/Desktop/2026ZenBookWork/zenbook-duo-linux`); identity verified: DMI `Zenbook Duo UX8407AA`, CachyOS, KDE, Wayland session, native Btrfs root.
- Running kernel is now **7.3.3-1-cachyos** (user updated from 7.3.1); LTS 6.18.60 and both header packages are installed. No DKMS is installed. Secure Boot measured disabled (efivar value `0x00`). Snapper `root` config exists; Limine `BOOT_ORDER="*, *lts, *fallback, Snapshots"`.
- Both pending kernel logs were received in `logs/incoming/`, reviewed, MAC-redacted and published under `logs/reviewed/2026-11-03-ux8407aa/` with SHA-256 provenance. The full-log findings are recorded in [graphics-freeze](troubleshooting/graphics-freeze.md): the freeze fires inside `gen9_set_dc_state`/`intel_dmc_wl_get` during a display DC-state transition; the working boot shows no DMC errors but repeated pipe A plane 5A faults.
- Sudo baseline was collected 2026-11-22 evening (capture `20261123T030620Z-RVwiDq`, ignored `.local/`). Headline: DMC freeze has **not** recurred since 2026-11-03 (5 boots total); a **new kernel Oops** in `raydium_i2c_irq` disabled the RAYD0001 touchscreen IRQ on 2026-11-21 (touch status since then unconfirmed); xe plane-fault errors are chronic but non-fatal; boot/snapshot recovery posture is strong (7.3.3 + LTS + 25 bootable snapshots); stock xe has no `zenbook_duo_edp2_tcss` parameter.
- No module, kernel parameter or BIOS change has been applied in this session yet.
- SRC-001 is now fixed and tested in a reviewed local checkout (`.local/research/burakgon-fixed`, patch and 13-scenario matrix in evidence and scripts): revert no longer deletes pre-existing identical files, modes are enforced, symlinks are preserved. Not upstream, not yet in system use. See the [trial](trials/2026-11-22-burakgon-rollback-fix.md).

## Original 2026-11-03 record

## Current facts

- User installed CachyOS on the new ASUS Zenbook Duo **UX8407AA** and is logged into its desktop.
- Running kernel **7.3.1-1-cachyos**; session **Wayland**; KDE Plasma selected. Exact Plasma version not yet collected.
- The successful installation followed an earlier keyring timeout. Root is Btrfs inside LUKS2 on the internal 953.9 GiB KIOXIA SSD, with a separate 4 GiB FAT32 /boot planned by the installer. Verify the installed mount layout before changing it.
- Windows and recovery partitions were intentionally removed with explicit user authorization. The old computer was not erased.
- First installed boot reached the graphical login screen after disk unlock, then froze. Ctrl+Alt+F3 and the Fn variant did not visibly change the screen. A cold-boot recovery was followed by a successful login.
- Previous-boot photograph confirms `DMC wakelock ack timed out` and `flip_done` / commit-wait timeouts on pipes A and B. BIOS shown: **UX8407AA.305, 02/10/2026**. Do not assume this is the latest BIOS or flash it automatically.
- No Burakgon modules or other Duo runtime, custom kernel, proposed `xe.*` parameters, or BIOS update has been applied by this workflow.
- Wi-Fi worked in the live session; installed-system Wi-Fi needs a fresh check. Bluetooth pairing and all other hardware tests remain unverified unless explicitly recorded.

## Latest update during repository preparation

The user supplied `uname -r`, `wayland`, and the kernel-warning photograph. The assistant then requested:

```sh
sudo journalctl -b -1 -k --no-pager > ~/zenbook-previous-boot.log
sudo journalctl -b 0 -k --no-pager -g 'DMC wakelock|DBuf|flip_done|PHY B' -n 30
cat /etc/default/limine
```

The user initially paused those checks to request this repository, then supplied a **16:41 photograph** while it was being prepared:

- The current-boot filter returned **`-- No entries --`**. This checks only the named patterns, not every possible warning or every prior boot.
- `/etc/default/limine` is now visible: `/boot` ESP path, encrypted Btrfs `subvol=/@`, and no `xe.*` graphics override in the displayed default line. See the [transcription](../evidence/2026-11-03-ux8407aa/current-boot-and-limine.md).
- The user reports saving the failed boot to **`zenbook-previous-first-boot.log`** and plans to place it in this repository's log folder. It has **not yet been received** by the documentation agent.
- The photo shows a full current-kernel-log export to **`~/Desktop/zenbook-current-fixed-boot.log`**. This full file also has not been received. The name “fixed” is a user filename, not a validated defect-resolution status. They also intend to include the no-matches result.

Boot index `-1` was appropriate when requested; after additional reboots, find the failure using `journalctl --list-boots` and its timestamp/boot ID. The full failed/current logs remain the first evidence gap; the filtered check and Limine photograph no longer do.

## First actions for the new local agent

1. Confirm native UX8407AA/CachyOS/KDE/Wayland and whether this checkout is on that machine. Check `git status`; fetch and reconcile main without discarding local work.
2. Run `bash scripts/collect-diagnostics.sh --sudo` from the logged-in user's desktop terminal. This collects diagnostics only and writes ignored local files. Review its code first as normal for a repository script. The script does not install packages or upload data.
3. Read the user's saved logs from `logs/incoming/` or their supplied location. Preserve complete failed/current journals, actual boot configuration, effective kernel command line, graphics parameters, module status and mount layout. The current filter was clear at 16:41; check again before new trials.
4. Establish recovery: retain the installer USB; inventory the regular and LTS kernels and headers; inspect Snapper configuration and boot entries; back up actual /boot and bootloader configuration before changes. Do not assume the older LTS kernel is a suitable primary kernel for this hardware.
5. Read the rollback finding and pacman-hook finding before using the Burakgon apply/revert framework. Reproduce the former with the included isolated script, then fix and test it in a reviewed source checkout if still present.
6. Choose an evidence-based first graphics trial if needed. `xe.enable_dc=0` was researched as a **possible diagnostic test** because it disables display C-states; it was not proposed to the user as a confirmed remedy and was not applied. Its benefit for this DMC failure is unproven and it may increase power consumption. A temporary one-boot change can be preferable to persistent configuration, provided recovery/input is workable.
7. Then use the [module assessment](research/burakgon-modules.md) to select the necessary UX8407AA fixes. Confirm dependency closure and record every module's version, manifest, build results and observed behavior. Keep the DMC issue separate from TCSS lower-screen behavior.
8. Update this handoff and the machine ledger after each checkpoint. The goal is a stable, repeatable setup, not merely one successful boot.

## Boot/input constraint

Until the TCSS issue has a validated fix, start and restart with the Duo keyboard lifted off the lower screen. A separate USB keyboard is useful through encrypted boot. The earlier advice that reattaching at the encryption prompt was definitely safe was too broad: a freeze followed on this machine, but causation was not established. Repeated attach/detach tests should wait until logging and recovery are available.

If a GUI freezes, try a TTY and capture logs first. A visibly frozen TTY attempt does not prove the entire kernel is dead. If there is no usable input path, the documented cold-power recovery can be used; do not repeatedly reinstall an already installed system.

## Acceptance criteria still outstanding

Cold and warm boot, login/lock/unlock, keyboard dock/undock, both panels, correct rotation and touch/pen mapping, brightness, audio/microphone, Bluetooth, suspend/resume and lid wake behavior must be tested. Verify DKMS rebuilds/active modules after a kernel update. Record battery/power tradeoffs for any disabled power feature. Keep untested items explicitly untested.

## Suggested opening request to the next agent

Use **Prompt 2** in [README.md](../README.md#prompt-2--finish-setup-locally-on-the-linux-laptop) from the cloned repository on the installed laptop. **Prompt 1** is for a preparation computer guiding installation on another machine. [Agent setup](agent-setup.md) covers Codex/Claude installation, Fish/Bash, cloning, account login and GitHub push access. `CLAUDE.md` imports the canonical AGENTS.md workflow.

The setup instructions were added after the initial repository handoff. No agent installation on the target, hardware fix, new kernel log receipt or additional hardware test is implied by that documentation update.
