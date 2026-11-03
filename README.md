# Zenbook Duo Linux field notes

An evidence-backed installation journal and agent handoff for getting ASUS Zenbook Duo laptops working on Linux. The first machine is a **2026 UX8407AA running CachyOS, KDE Plasma and Wayland**. Future UX8406MA (2024), UX8406CA (2025), and other machines get separate profiles and results.

**Last recorded state: 2026-11-03, America/Toronto.** Installation succeeded and the user reached the desktop after recovering from a first-login graphics freeze. The running kernel is `7.3.1-1-cachyos`. **No Burakgon modules, custom kernel, or proposed graphics boot parameters have been applied.** The freeze is diagnosed to the display-driver area; its exact cause and durable fix remain unresolved.

## Start here

1. Agents: read [AGENTS.md](AGENTS.md), then the [current handoff](docs/handoff.md).
2. Read the [UX8407AA profile](machines/ux8407aa-2026/README.md) and [open issues](docs/open-issues.md).
3. Follow the [full installation journal](docs/journey/2026-11-03.md) for commands, failures, corrections and outcomes.
4. Consult the [project comparison](docs/research/project-comparison.md), [module assessment](docs/research/burakgon-modules.md), and [source index](docs/research/sources.json).
5. Add future work using the [recording workflow](docs/workflow.md) and [templates](templates/README.md).

## What has happened

| Stage | Recorded result |
| --- | --- |
| Research | Compared Burakgon, therealarnold666, Zakstam and Cceelen; recorded source commits and qualifications. |
| USB preparation | Official `cachyos-desktop-linux-260809.iso`; checksum checked; Rufus DD-mode preparation; live USB booted. |
| Firmware/boot | Secure Boot violation resolved sufficiently to boot by following the disable-Secure-Boot flow; keyboard lifted at startup. Exact current firmware state still needs a local check. |
| Live session | Wi-Fi worked; kernel `7.1.6-1-cachyos`; Wayland; internal SSD correctly identified. |
| Disk replacement | User explicitly authorized removing Windows and all recovery partitions after backing up files. |
| First installation | Disk partitioning/encryption completed; keyring step was killed after 30 seconds. Linux installation had not reached package or bootloader installation. |
| Retry | Increased the keyring-step timeout to 3600 seconds in the live installer configuration; installation subsequently passed that step and completed. |
| Slow download | About 1.25 MB/s sampled; progress advanced 17% → 35% → 41% → 82% → complete. |
| First installed boot | Disk unlocked; login screen froze; TTY shortcuts did not visibly respond. |
| Recovery | Full shutdown/cold-boot instructions supplied; user subsequently booted and logged in. Exact physical sequence was not independently verified. |
| Evidence | Previous-boot screenshot shows `DMC wakelock ack timed out` and `flip_done` timeouts on pipes A and B. |
| Working-boot check | Filtered current journal returned no matching DMC/DBuf/flip_done/PHY B entries; Limine configuration supplied in a later photograph. Full saved logs await upload. |
| Next | Review full previous/current logs locally, protect rollback, then choose fixes. |

## Chosen approach

For this **UX8407AA + CachyOS + KDE Wayland** installation, use **selected Burakgon modules** after checking the installed kernel, dependencies, existing configuration and the source-review findings. A module is a separately selectable fix; some are configuration changes, some firmware placement, and some build replacement kernel drivers with DKMS. This is not a commitment to run every recommended module.

The DMC login-freeze signature and the lower-screen TCSS/PHY power failure must be tracked separately. The TCSS patch is not established as the fix for the photographed DMC failure. See [graphics incident](docs/troubleshooting/graphics-freeze.md).

The older machine is recorded as UX8406MA in the earlier session summary and currently hosts Windows/WSL. Its Linux installation has not begun. Reconfirm its DMI identity before selecting a solution; do not copy the UX8407AA patches to it. See the [UX8406 planning profile](machines/ux8406-family/README.md).

## Evidence and tools

- [Evidence catalog](evidence/README.md): installer log, Rufus log, five photographs and selected-line transcriptions.
- [Log intake](logs/README.md): where the user's saved previous/current boot files should be placed and reviewed.
- [Evidence checksums and provenance](evidence/manifest.json): published files, original hashes, transformations and limitations.
- [Read-only diagnostic collector](scripts/collect-diagnostics.sh): run on the actual installed laptop; raw output stays under ignored `.local/`.
- [Repository checks](scripts/check_repository.py): JSON, links, evidence hashes, image metadata and private-path checks.
- [Evidence preparation](scripts/prepare-evidence.py): reproducible log redaction and pixel-verified JPEG metadata removal, followed by manual review.
- [Upstream rollback reproducer](scripts/reproduce-burakgon-rollback.sh): isolated test of a source-review finding; no real system files are touched.
- [Repository validation record](docs/trials/2026-11-03-repository-validation.md): checks performed and their limits.

This repository contains no automatic hardware installer and no applied hardware patch. It records what was observed, what was tried, what was inferred and what remains to be done. It is a reconstruction from the conversation, retained research and available artifacts, not a verbatim export of every chat message. Missing outputs are explicitly marked pending.

## Maintaining the record

The user authorized this whole folder to become `git@github.com:shahzadlone/zenbook-duo-linux.git`, with work on **main** and pushes of the documentation. Future agents should update the machine state, journal, issues and evidence together after each meaningful checkpoint. Confirm remote changes before pushing; never force-push over another machine's work.

Published logs have documented redactions. Photographs have metadata removed while their decoded pixels remain identical. Original evidence stays outside tracked paths. Do not publish passwords, recovery keys, Wi-Fi secrets, tokens, SSH keys or unreviewed raw captures.
