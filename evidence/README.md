# Evidence catalog

All artifacts below relate to the 2026 UX8407AA unless explicitly identified as the older preparation host. [manifest.json](manifest.json) records published hashes, original hashes, provenance, transformations and limitations.

| Artifact | What it establishes | Limits |
| --- | --- | --- |
| [14:27 live output photo](2026-11-03-ux8407aa/20261103_142724.jpg) | Live kernel 7.1.6, Wayland, USB/internal storage layout. | A photograph of command output, not a full hardware inventory. |
| [14:40 install summary photo](2026-11-03-ux8407aa/20261103_144023.jpg) | Correct internal KIOXIA disk, GPT/4 GiB boot/Btrfs plan, locale. | Precedes later encryption selection; not proof of final installed config. |
| [Failed installer log](2026-11-03-ux8407aa/installer-failed.redacted.log) | Partitioning/encryption completed, mirror timeouts, exact 30-second keyring failure, later jobs skipped. | Extracted text from HTML paste; credential-related lines redacted; no successful retry log. |
| [Rufus log](2026-11-03-ux8407aa/rufus.redacted.log) | Older-host USB preparation/image analysis and final observed layout. | Local-user path redacted; not a full byte-for-byte USB verification. |
| [15:22 downloading photo](2026-11-03-ux8407aa/20261103_152237.jpg) | Retry reached pacstrap, package list, download amount and 17% stage. | Slideshow entries alone do not prove network progress. |
| [16:19 kernel-warning photo](2026-11-03-ux8407aa/20261103_161909.jpg) | Previous-boot xe/DMC warning and pipe A/B commit timeouts; BIOS/version. | Only the last visible part of the journal; full log still expected. |
| [Selected warning transcription](2026-11-03-ux8407aa/graphics-photo-transcription.md) | Searchable diagnostic lines from the preceding photograph. | Selected lines only, not an invented full log or automated OCR assertion. |
| [16:41 working-boot/config photo](2026-11-03-ux8407aa/20261103_164134.jpg) | Current filter has no matches; full-log export command shown; Limine config visible. | No matching subset is not a clean full journal or permanent-fix result. |
| [Working-boot/config transcription](2026-11-03-ux8407aa/current-boot-and-limine.md) | Portable record of that output and the expected saved files. | Config transcribed from photo, not received as a raw file. |
| [Rollback reproduction](research/burakgon-rollback-reproduction.txt) | SRC-001 reproduced against pinned upstream helper code in disposable paths. | Tests helper behavior only; no target-system module applied. |

## Publication handling

Five originals had EXIF metadata including GPS tags. Published copies have APP1/EXIF/XMP, APP13 and JPEG comment metadata removed where present, plus trailing metadata/auxiliary content after the primary JPEG end marker; orientation was normal in each source. The primary compressed image stream was retained and its decoded pixels were compared exactly with the originals. Auxiliary/HDR metadata is not retained. No primary image was regenerated, resized or visually retouched. Original images remain unchanged in the user's Downloads and copied only to ignored local storage.

The failed installer log has 42 credential-related lines withheld conservatively, including benign password-validation text; the remaining diagnostic ordering/content is preserved. Rufus has one local Windows-user path replaced. Exact counts are in the manifest. No password, recovery key or private signing key was intentionally collected for publication.

Original logs/photos and temporary checkouts are not pushed. The SHA-256 of an original permits later identity checks without publishing its private metadata. Full future kernel logs must pass the same review process; the existence of a GitHub paste does not make every log safe to republish blindly.

## Missing artifacts

- Full successful-install retry log (`~/cachy-install.log` existed in the live session but was not supplied).
- `zenbook-previous-first-boot.log`: user reports saved; not yet received.
- `zenbook-current-fixed-boot.log`: export command visible; full file not yet received.
- A separate text copy of the current no-matches result: planned by user, photograph already retained.

See [logs intake](../logs/README.md). Missing artifacts are not placeholders for fabricated content; their files are intentionally absent until provided.
