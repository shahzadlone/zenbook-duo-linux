# First-login graphics freeze

Status: **recovered enough to use the desktop; lasting fix unresolved**.

## Local evidence

The user unlocked LUKS on the first installed boot and reached graphical sign-in, then input/display appeared frozen. Ctrl+Alt+F3 and Ctrl+Alt+Fn+F3 produced no visible console. A later cold boot reached the desktop. Current running kernel is user-confirmed `7.3.1-1-cachyos`, on Wayland.

The [photograph](../../evidence/2026-11-03-ux8407aa/20261103_161909.jpg) shows previous-boot warnings at approximately 16:08–16:09 local time:

```text
DMC wakelock ack timed out
intel_dmc_wl_get ... [xe]
[drm] *ERROR* flip_done timed out
[CRTC:153:pipe A] commit wait timed out
[CRTC:273:pipe B] commit wait timed out
[CONNECTOR:517:eDP-1] commit wait timed out
```

These are selected visible diagnostic lines, not a complete journal export. The warning stack points into the display power/wakelock path; the log's kernel-taint letters alone do not prove third-party modules were installed. The workflow had installed none.

## Distinguish these hypotheses

| Failure family | Diagnostic evidence | Interpretation for this user |
| --- | --- | --- |
| DMC/display-power handshake | DMC wakelock acknowledgement timeout, possibly DBuf errors, then multiple display-pipe timeouts | DMC + dual-pipe pattern observed; exact cause not established. DBuf is in the upstream comparison, not visibly confirmed in the supplied photo. |
| Lower-panel TCSS/PHY power | PHY B/refclk/AUX B failures after keyboard-covered startup | Known UX8407AA defect; not established as this photographed incident's cause. |
| PSR/Panel Replay | PSR idle timeout, pipe-A hang, cursor ghosts/stutter | Source-reported alternative; inspect full logs before treating it as observed here. |
| Input-only problem | Display continues updating but keyboard/trackpad events disappear | Not excluded by the initial description alone; the later graphics warnings strongly motivate display investigation. |

[Burakgon's report](https://github.com/burakgon/zenbook-duo-2026-linux/blob/8030783aac5273da5f2aa0da217a6bc408ee0533/docs/hardware-report.md) describes a similar first-login freeze on stock 7.3.0, with the keyboard detached, not reproduced in subsequent boots. This is a matching report, not proof of a single shared cause or a confirmed remedy.

## Preserving evidence

Collect all available boot IDs before selecting the failed one. `-b -1` means the immediately preceding boot, not permanently “the bad boot.” Save the entire kernel log and optionally the full system journal locally, then publish reviewed/redacted excerpts. Include current kernel, package versions, firmware messages, BIOS, actual xe module path, command line, current parameters, display topology and whether the keyboard was on the lower screen at power-on.

The later [16:41 photograph](../../evidence/2026-11-03-ux8407aa/20261103_164134.jpg) shows no matches for `DMC wakelock|DBuf|flip_done|PHY B` in the current boot and shows `/etc/default/limine`. This is a useful clean check for those patterns at that time, not a complete clean-journal or permanent-fix result. The user's saved full previous/current logs still await upload.

## Candidates that were researched, not applied

- `xe.enable_dc=0`: the exact CachyOS kernel source describes this as disabling power-saving display C-states. It is a plausible diagnostic experiment around the observed power transition, not a proven UX8407AA DMC fix. It may raise power use. Record baseline, apply one attributable change with rollback, and verify effective parameters and repeated boot behavior.
- `xe.enable_dmc_wl`: source exposes this control; its existence is not a recommendation to disable synchronization blindly.
- `xe.enable_panel_replay=0 xe.enable_psr=1`: Burakgon documents this fallback for its PSR/Panel Replay failure pattern. It was not applied or established as this incident's remedy.
- TCSS xe DKMS: candidate for the separate lower-screen power issue. Check source tag, headers, build result, initramfs inclusion and the live marker before a docked-startup test.
- BIOS/firmware: user's photograph shows BIOS 305; the research author's setup used 310. No current vendor release check or update has been performed. Do not claim a newer BIOS fixes this incident without release evidence and a tested outcome.

Kernel source checked: [parameters at cachyos-7.3.1-1](https://github.com/CachyOS/linux/blob/cachyos-7.3.1-1/drivers/gpu/drm/i915/display/intel_display_params.c), [wakelock implementation](https://github.com/CachyOS/linux/blob/cachyos-7.3.1-1/drivers/gpu/drm/i915/display/intel_dmc_wl.c), [power-well transitions](https://github.com/CachyOS/linux/blob/cachyos-7.3.1-1/drivers/gpu/drm/i915/display/intel_display_power_well.c).

## Recovery and validation

Keep the installer USB available. Prefer TTY/log capture and orderly shutdown when responsive. If no input path works, a forced shutdown and cold power cycle was the recovery path in this session. Start with the keyboard off the lower screen; an external USB keyboard helps through disk unlock. A failed visible TTY switch does not identify whether the kernel, display, or input path was responsible.

After each trial verify current warnings, active settings, cold/warm starts, login/lock/unlock, suspend/resume and display/keyboard transitions. Record pass counts and conditions. Do not claim “fixed” after one successful login.
