# Logs: intake and reviewed publication

Put new raw logs in **`logs/incoming/`**. That directory's contents are ignored by Git so an agent can review and redact them before publishing. Files dropped directly as `logs/*.log` are ignored for the same reason. Move reviewed copies into `logs/reviewed/<date>-<machine>/`, record provenance/checksums and update the journal and handoff before committing. Do not use `git add -f` to bypass review.

Expected from the UX8407AA user, as of the 2026-11-03 handoff — **both kernel logs were received 2026-11-22 and are published under [`logs/reviewed/2026-11-03-ux8407aa/`](reviewed/2026-11-03-ux8407aa/)**:

| File/result | State |
| --- | --- |
| `zenbook-previous-first-boot.log` | Received. Kernel journal of the frozen boot (16:04–16:09), kernel 7.3.1. Published with MAC redaction only; see [provenance](reviewed/2026-11-03-ux8407aa/provenance.md). |
| `zenbook-current-fixed-boot.log` | Received. Kernel journal of the working boot (16:10–16:13, partial export). Published with MAC redaction only. "Fixed" remains the user's filename, not a validated status. |
| Current filtered no-matches output | Photograph retained under evidence; superseded by the received full logs. |

The earlier [failed installer and Rufus logs](../evidence/README.md) are already published as reviewed/redacted historical evidence. Do not mistake them for the missing installed-system kernel logs.

Keep original files unchanged in ignored storage and record their SHA-256 before redaction. Look for passwords, passphrases, recovery keys, network credentials, tokens, serials, MAC/IP addresses, usernames and unrelated personal paths. Not every identifier is secret (for example, a filesystem UUID), but preserve only what supports diagnosis. Describe any redaction; never imply a transformed log is an untouched original.

The collector writes `.local/diagnostics/` by default. It does not copy or publish files here automatically. See [workflow](../docs/workflow.md).
