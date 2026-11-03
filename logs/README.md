# Logs: intake and reviewed publication

Put new raw logs in **`logs/incoming/`**. That directory's contents are ignored by Git so an agent can review and redact them before publishing. Files dropped directly as `logs/*.log` are ignored for the same reason. Move reviewed copies into `logs/reviewed/<date>-<machine>/`, record provenance/checksums and update the journal and handoff before committing. Do not use `git add -f` to bypass review.

Expected from the UX8407AA user, as of the 2026-11-03 handoff:

| File/result | Known state |
| --- | --- |
| `zenbook-previous-first-boot.log` | User reports it was saved; full file not received yet. It should contain the boot that froze. Verify timestamps/boot ID. |
| `zenbook-current-fixed-boot.log` | Screenshot shows export to the new laptop's Desktop; full file not received yet. Filename is not proof of a permanent fix. |
| Current filtered no-matches output | Photograph received, recorded under evidence; user also intends to supply a text log. |

The earlier [failed installer and Rufus logs](../evidence/README.md) are already published as reviewed/redacted historical evidence. Do not mistake them for the missing installed-system kernel logs.

Keep original files unchanged in ignored storage and record their SHA-256 before redaction. Look for passwords, passphrases, recovery keys, network credentials, tokens, serials, MAC/IP addresses, usernames and unrelated personal paths. Not every identifier is secret (for example, a filesystem UUID), but preserve only what supports diagnosis. Describe any redaction; never imply a transformed log is an untouched original.

The collector writes `.local/diagnostics/` by default. It does not copy or publish files here automatically. See [workflow](../docs/workflow.md).
