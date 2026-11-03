# Selected visible lines from 20261103_161909.jpg

Source: [original-content photograph, metadata removed](20261103_161909.jpg). Transcribed for searchability. This is not the full journal and does not reconstruct omitted lines, register dumps or stack frames.

The command requested by the assistant was:

```sh
sudo journalctl -b -1 -k -p warning --no-pager -n 50
```

The user separately reported:

```text
uname -r: 7.3.1-1-cachyos
XDG_SESSION_TYPE: wayland
```

Visible warning/error fragments:

```text
Nov 03 16:08:31 ... DMC wakelock ack timed out
... WARNING: drivers/gpu/drm/i915/display/intel_dmc_wl.c:227 at intel_dmc_wl_get ... [xe]
... 7.3.1-1-cachyos #1 PREEMPT(full)
... Hardware name: ASUS Zenbook Duo UX8407AA/UX8407AA, BIOS UX8407AA.305 02/10/2026
... Workqueue: events_unbound intel_display_power_put_async_work [xe]
... RIP: ... intel_dmc_wl_get ... [xe]
... gen9_set_dc_state ... [xe]
... __intel_display_power_put_domain ... [xe]
... intel_display_power_put_async_work ... [xe]
Nov 03 16:08:41 ... xe 0000:00:02.0: [drm] *ERROR* flip_done timed out
Nov 03 16:08:41 ... [CRTC:153:pipe A] commit wait timed out
Nov 03 16:08:51 ... xe 0000:00:02.0: [drm] *ERROR* flip_done timed out
Nov 03 16:08:51 ... [CRTC:273:pipe B] commit wait timed out
Nov 03 16:09:01 ... xe 0000:00:02.0: [drm] *ERROR* flip_done timed out
Nov 03 16:09:01 ... [CONNECTOR:517:eDP-1] commit wait timed out
```

Ellipses explicitly mark omitted prefixes/offsets rather than pretending to reproduce complete lines. A DBuf message is part of the upstream comparison but is not visibly established by this image. Obtain the full failed-boot journal before drawing more specific conclusions.
