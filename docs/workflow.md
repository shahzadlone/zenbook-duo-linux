# Maintaining context across agents and machines

## Start a session

Read AGENTS.md and the current handoff. Confirm the physical machine and whether the shell is native Linux, live media, WSL or a chroot. Inspect Git state and reconcile remote main before editing. Check for new logs in `logs/incoming/` and existing local captures. Do not rerun an installation because an earlier step's output is missing.

The repository improves continuity by giving the next agent explicit, versioned evidence and decisions. It does not automatically train a model or supply context to an agent that has not read it.

## Collect diagnostics

From a native Linux desktop terminal in the cloned repository:

```sh
bash scripts/collect-diagnostics.sh --sudo
```

The collector uses read-only system commands and writes only its diagnostic output directory under `.local/diagnostics/`. `--sudo` allows journal/module/config reads; it does not install or modify system settings. Without it, permission-restricted commands may fail and their exit status is saved. Missing optional tools are recorded instead of installed. Run `--help` for details. Never mistake data collected on WSL for the new laptop's hardware state.

Review the output and save the successful/failed boot IDs. Keep full raw originals in ignored storage. Prepare reviewed copies for `logs/reviewed/<date>-<machine>/` or the dated evidence directory; hash them and describe redactions. The current collector does not automatically redact or publish.

`python3 scripts/prepare-evidence.py --help` describes the reproducible log-redaction and JPEG-metadata helper used for this record. The log filter is incomplete and always needs manual review. JPEG pixel verification requires Pillow; no dependency is automatically installed. The helper refuses overwriting an original or an existing destination and reports hashes. It does not update the manifest or publish automatically.

## Record an experiment

Copy [experiment.md](../templates/experiment.md) to `docs/trials/<date>-<short-name>.md`. Include the machine, baseline, hypothesis, exact source/version, exact commands and working directories, expected result, actual exit/output, rollback and validation. A proposed experiment gets state `proposed`; only mark it `applied` after execution evidence and `validated` after the stated checks.

Before changing boot parameters, inspect the actual source configuration and effective command line. Preserve encrypted-root arguments. Back up /boot and settings using a known destination. Before DKMS, confirm headers and exact sources; after DKMS, inspect logs, module path, initramfs contents and effective loaded driver. Keep a usable recovery entry. Snapshot coverage is not automatically whole-disk coverage.

Hardware checks should cover cold/warm boot, encrypted unlock, login, lock/unlock, screen layout and rotation, touch and pen mapping, brightness, keyboard/Fn/touchpad over dock/Bluetooth, audio/microphone, lid behavior, suspend/resume, and power consumption where a policy changes. Record untested cases rather than extrapolating.

## Update the repository at a checkpoint

Update all affected items together:

- `docs/handoff.md`: what is true now and the exact next action.
- `machines/<model>/state.json`: applied modules, active kernel/settings, test status and evidence links.
- Dated journal/trial: immutable history with appended corrections.
- `docs/open-issues.md` and `docs/decisions.md`: state transitions and rationale.
- `evidence/manifest.json`: new artifact hashes/provenance and transformed-original relationship.
- Source review/commit index when upstream versions change.

Run:

```sh
python3 scripts/check_repository.py
bash -n scripts/collect-diagnostics.sh
bash -n scripts/reproduce-burakgon-rollback.sh
git diff --check
git status --short
```

Review the exact staged files before committing, especially logs and photographs. The user authorized main-branch work and pushes for this record. Use ordinary `git add` with explicit paths, commit meaningful checkpoints, fetch remote main before pushing, and preserve other machines' work. Never force-push to overwrite concurrent updates.

## Add another model or distro

Use [machine.md](../templates/machine.md). Record product and board, CPU/GPU, BIOS, keyboard IDs, OS/kernel/desktop, existing services, disk plan, firmware and baseline functions. Link a source snapshot and explain selection. Preserve each machine's own apply/revert state and evidence. A 2026 distro decision is not a prescription for UX8406MA/CA.

## Documentation checks versus hardware checks

Repository checks verify links, JSON, evidence integrity and obvious publication hazards. The isolated rollback reproducer verifies an upstream helper defect using disposable paths. Neither claims the laptop is stable. A change that needs hardware validation must retain that limitation in its state and handoff.

## Cleanup and licensing

Follow AGENTS.md's Rust cleanup requirements. Do not commit builds, ISO images, firmware binaries, credentials or nested source repositories. Cache only what imminent work needs and document retained caches. Preserve upstream notices when importing code. No blanket license for third-party material is created by this research record.
