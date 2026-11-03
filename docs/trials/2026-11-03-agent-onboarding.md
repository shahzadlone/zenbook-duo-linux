# Trial: agent onboarding documentation

- Date: 2026-11-03, America/Toronto.
- Environment: older Windows/WSL preparation host.
- Scope: README setup guide, two starting prompts, CLI/Git setup documentation,
  Claude instruction entry point and workflow links.
- Hardware outcome: no target package, module, boot setting or firmware changed.

## Source checks

Reviewed official Codex CLI installation and AGENTS.md documentation, the current
standalone installer's default path and shell handling, Claude Code setup and
instruction imports, and GitHub credential setup. Source links are retained in
[agent-setup.md](../agent-setup.md). The existing preparation-host Codex command
is a symlink to a standalone installation; this does not establish that the new
laptop has Codex installed. No installer was executed during this documentation
task and no credentials were read.

## Validation

`python3 scripts/check_repository.py` passed for 44 files, including relative
Markdown targets, JSON, published evidence hashes and tracked-path checks.
`git diff --check` passed. Manual review checked the two machine roles, Fish/Bash
distinction, shared instruction import, pending hardware state and preservation
of the installation history. Installer and authentication commands were checked
against their sources, not executed as target-installation tests. These checks
do not establish target CLI authentication or hardware stability.

## Cleanup

No Rust build ran and no build cache was created. Recovered Rust build space:
0 bytes; no Rust build cache retained by this task.
