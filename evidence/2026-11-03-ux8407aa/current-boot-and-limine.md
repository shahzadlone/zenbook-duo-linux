# Working-boot check and Limine configuration

Source: [16:41 photograph](20261103_164134.jpg), supplied while documentation was being created. The user also reports saving the failed boot as `zenbook-previous-first-boot.log` and plans to place it in the repository log folder. Neither full kernel file has been received yet.

Visible export command, with terminal wrapping joined:

```sh
sudo journalctl -b -0 -k --no-pager > ~/Desktop/zenbook-current-fixed-boot.log
```

The filename includes “fixed”; this is not a permanent-fix conclusion. It exports the full current kernel journal, not merely the following filtered result.

Visible query and result:

```sh
sudo journalctl -b -0 -k --no-pager -g 'DMC wakelock|DBuf|flip_done|PHY B' -n 30
```

```text
-- No entries --
```

Visible `/etc/default/limine`, transcribed from the photograph with wrapped lines joined:

```bash
ESP_PATH="/boot"
KERNEL_CMDLINE[default]+="quiet nowatchdog splash rw rootflags=subvol=/@ rd.luks.uuid=c9c9b9a5-d033-4181-9aec-da5faa72d514 root=/dev/mapper/luks-c9c9b9a5-d033-4181-9aec-da5faa72d514"
BOOT_ORDER="*, *lts, *fallback, Snapshots"
```

This is **machine-specific historical evidence**, not a replacement configuration to apply elsewhere. The LUKS UUID is a volume identifier, not the encryption passphrase. Confirm it against the actual file before editing. The failed install's earlier UUID must not be reused after the successful retry recreated the filesystem.

No `xe.*` parameter appears in the displayed default line. This alone does not establish the effective command line: inspect `/proc/cmdline`, generated entries and any other configuration sources locally. `/boot` is the configured ESP path; actual mount verification remains pending.
