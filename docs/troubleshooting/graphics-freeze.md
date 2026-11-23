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

## Full-log review (received 2026-11-22)

The user supplied both complete `journalctl -k` exports; reviewed copies with
SHA-256 provenance are in [`logs/reviewed/2026-11-03-ux8407aa/`](../../logs/reviewed/2026-11-03-ux8407aa/).
Both cover kernel 7.3.1-1-cachyos on 2026-11-03. Established facts from the full files:

- Failed boot (16:04:31 start): the first error is at 16:05:28 —
  `WARNING: drivers/gpu/drm/i915/display/intel_dmc_wl.c:227 at intel_dmc_wl_get`,
  reached from `gen9_set_dc_state` ← `__intel_display_power_put_domain` ←
  `intel_display_power_put_async_work`. The freeze therefore occurs **inside a
  display DC-state (DMC) power transition**, not merely near one. `Unexpected DBuf
  power power state (0x00000000, expected 0x0000000f)` follows, then repeated
  `flip_done`/`commit wait` timeouts on pipes A and B and eDP-1 through 16:09:01.
- The Duo keyboard USB device (`usb 3-6`) disconnected at 16:05:47 and
  re-enumerated at 16:05:55 during the incident. This is consistent with the
  keyboard being a casualty of the freeze (or of a USB/TCSS reset) rather than
  a proven cause; causation remains unestablished.
- Working boot (16:10:05 start): **no** DMC/DBuf/flip_done errors at all.
  New signatures instead: `Selective fetch area calculation failed in pipe A`
  at driver init, one `GSC proxy component not bound` at 16:10:27, and repeated
  `[CRTC:153:pipe A][PLANE:136:plane 5A] fault (SURF=0x5200000, SURFLIVE=0x5200000)`
  at 16:11:30 and 16:13:29. The export ends at 16:13:29; the desktop was in use.
- Both boots used the same kernel command line: `quiet nowatchdog splash rw
  rootflags=subvol=/@ rd.luks.uuid=... root=/dev/mapper/luks-...` — no `xe.*`
  parameters were active in either boot.

The DC-state call trace makes `xe.enable_dc=0` a **directly targeted** diagnostic
(it disables exactly the power-saving path in which the warning fired), while
remaining unproven as a permanent fix and potentially increasing power use.

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

The later [16:41 photograph](../../evidence/2026-11-03-ux8407aa/20261103_164134.jpg) shows no matches for `DMC wakelock|DBuf|flip_done|PHY B` in the current boot and shows `/etc/default/limine`. This is a useful clean check for those patterns at that time, not a complete clean-journal or permanent-fix result. The full previous/current logs were received 2026-11-22 and are reviewed above; they supersede the photographic excerpts for diagnosis.

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
