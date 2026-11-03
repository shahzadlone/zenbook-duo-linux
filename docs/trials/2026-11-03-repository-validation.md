# Trial: preserve and validate the initial handoff repository

- Date: 2026-11-03, America/Toronto.
- Environment: older Windows/WSL documentation host, not the new laptop.
- Scope: documentation, evidence publication, reproducible diagnostic/review tooling and Git handoff.
- Hardware outcome: no target system setting, kernel, firmware or module changed.
- Source input: four pinned research checkouts; retained installer/Rufus logs; five user photographs; conversation and earlier session summary.

## Checks performed

| Check | Result and limit |
| --- | --- |
| Remote repository | Empty main-target repository; SSH read access succeeded. GitHub API reports public visibility; no visibility change requested or made. |
| GitHub CLI | Not authenticated on the preparation host; SSH Git transport was available, so no CLI login was necessary. |
| Local repository | Initialized this previously empty folder on main with the exact user-provided SSH origin. |
| Evidence metadata | Five photos contained GPS EXIF. Initial removal exposed extra XMP after the primary JPEG end marker; validation caught it. Trailing metadata/auxiliary content was then removed too. |
| Photo integrity | Primary decoded pixels, mode and dimensions compared exactly before/after for all five photos. No visual regeneration, cropping or resizing. |
| Log preparation | 42 credential-related installer lines withheld conservatively; one Rufus local-user path redacted. Original hashes retained; raw originals ignored. |
| Preparation reproducibility | The checked-in helper reproduced all five published JPEG files and both published logs exactly. |
| Test correction | An initial comparison normalized CRLF by using text-mode input and failed. Reading the original bytes and decoding without newline conversion matched the real helper/publication path and passed. Evidence bytes were not changed to conceal the mismatch. |
| Whitespace preservation | Calamares evidence contains original trailing spaces. Log-only Git attributes exclude those artifacts from formatting checks and disable line-ending normalization; authored documentation/scripts still receive normal checks. Staged evidence hashes were compared directly with the manifest. |
| Preparation guards | Synthetic credential/path/MAC redaction retained diagnostic lines and liveuser paths; invalid JPEG rejected; attempts to overwrite the original rejected. These are bounded checks, not proof of complete redaction for arbitrary logs. |
| Read-only collector | Bash syntax and help checked. Executing on this host returned the intended WSL refusal (exit 2) without creating a diagnostic capture. Native target execution remains for the next agent. |
| Upstream rollback defect | Isolated pinned-source reproduction succeeded (defect present). Temporary test files cleaned; no real system file affected. |
| Machine/catalog consistency | All 23 reviewed Burakgon modules have local state not_applied; no module success invented. |
| Repository validation | JSON parsing, relative Markdown targets, evidence hashes, absence of EXIF/XMP in published photos and tracked-path checks passed before and after staging; staged evidence bytes also matched the manifest. |
| Manual review | Reviewed the artifact inventory, redaction counts, key failure lines, source qualifications and pending-versus-returned results. No complete target kernel log is present yet. |

## Commands used for routine validation

```sh
python3 scripts/check_repository.py
bash -n scripts/collect-diagnostics.sh
bash -n scripts/reproduce-burakgon-rollback.sh
bash scripts/collect-diagnostics.sh --help
bash scripts/collect-diagnostics.sh
bash scripts/reproduce-burakgon-rollback.sh /path/to/pinned-burakgon-checkout
git diff --check
```

The unprivileged collector call is expected to fail on WSL; do not describe it as a successful native diagnostic capture. Preparation behavior was additionally checked by importing `scripts/prepare-evidence.py` against retained originals and comparing SHA-256 values with the manifest.

## Storage and cleanup

No Rust compilation ran. No Rust build cache was created, so there was no Rust build space to reclaim and no retained Rust target directory. The disposable rollback test cleaned its owned directory. Approximately 21 MiB of upstream **source checkouts** remain in the preparation host's temporary research directory for continuity, and about 18 MiB of original evidence remains in ignored `.local/originals`. These are source/evidence inputs, not build outputs, and are not pushed. The original user Downloads files remain unchanged.

## Handoff limitation

Repository checks certify this record's internal consistency, not the laptop's reliability. Full installed-system logs, a native diagnostic run, rollback coverage and any hardware-fix validation are still required. Record the actual pushed commit in Git history; do not fabricate a remote-success result before the push succeeds.
