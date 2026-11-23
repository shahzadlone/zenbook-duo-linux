# Provenance: UX8407AA kernel logs, 2026-11-03

Received 2026-11-22 in `logs/incoming/` from the user. Both files are complete
`journalctl -k` kernel-journal exports from the installed CachyOS system on the
UX8407AA, covering the first installed boot and the working recovery boot of
2026-11-03 (kernel 7.3.1-1-cachyos at that date).

| File | Received SHA-256 (original) | Reviewed copy | Reviewed SHA-256 |
| --- | --- | --- | --- |
| `zenbook-previous-first-boot.log` | `996482c38d250924cae337688c39b0bf5aacf909fec130fb20387c448def2cca` | `zenbook-previous-first-boot.redacted.log` | `a2ea2864ecd26b8322f7a1765fdb5cc3276c63f7fd5fcc2118aa60b2bb2e312d` |
| `zenbook-current-fixed-boot.log` | `78ee7e57fe0cf55db1b82bf17c9bb6cd5981ba22465a4029ce814e65a8c2e184` | `zenbook-current-fixed-boot.redacted.log` | `edb69318add524f6b6733ba7994c65d6487ee1f300d3a462327b5b4fbd3bcdc1` |

## Transformation

Only MAC addresses were redacted; every other byte is unchanged:

- `d4:94:a9:46:c4:04` → `d4:94:a9:XX:XX:XX` (laptop Wi-Fi base HW address, OUI retained)
- `b2:8b:a9:92:08:a3` → `b2:8b:a9:XX:XX:XX` (access-point BSSID, locally administered bit set)

## Review notes

- Kernel-only journals: no passwords, passphrases, tokens or user file paths present.
- Visible identifiers left as-is because they support diagnosis: hostname `ss`
  / `cachyos`, LUKS/filesystem UUIDs, USB and PCI identifiers, kernel module list.
- The username `s` appears only in the transient kernel-reported hostname, not in paths.
- The original files remain in ignored local storage (`logs/incoming/` is Git-ignored);
  published copies are the redacted files only.

## Diagnostic reading order

1. `zenbook-previous-first-boot.redacted.log`: boot 16:04:31 → desktop, then from
   16:05:28 `WARNING intel_dmc_wl.c:227 intel_dmc_wl_get` reached from
   `gen9_set_dc_state` ← `intel_display_power_put_async_work`, DBuf power-state
   mismatch, and from 16:05:39 `flip_done`/`commit wait` timeouts on pipes A and B,
   repeated through 16:09:01. The Duo keyboard USB device disconnected at
   16:05:47 and re-enumerated at 16:05:55 during the incident. A worker-thread
   task trace accompanies the warnings.
2. `zenbook-current-fixed-boot.redacted.log`: boot 16:10:05 → desktop with **no**
   DMC/DBuf/flip_done errors. New observations: `Selective fetch area calculation
   failed in pipe A` at init, `GSC proxy component not bound` once at 16:10:27, and
   repeated `[CRTC:153:pipe A][PLANE:136:plane 5A] fault (SURF=SURFLIVE=0x5200000)`
   at 16:11:30 and 16:13:29. Log ends 16:13:29; it is a partial export of a working
   session, and "fixed" in the filename is the user's label, not a validated status.
