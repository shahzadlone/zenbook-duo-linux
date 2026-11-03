# Agent instructions for this repository

## Purpose and required reading

This is the user's persistent research, installation and troubleshooting record for ASUS Zenbook Duo Linux installations. Read `docs/handoff.md`, the relevant `machines/*/README.md` and `state.json`, `docs/open-issues.md`, and the latest journal before making changes. Read the applicable research findings before using third-party installers.

The filename is **AGENTS.md**; the user's request also spelled it AGNETS.md. The canonical file is this one.

README.md is the user-facing installation entry point: keep it focused on model/distro guidance, setup commands, starting prompts and links. Local development housekeeping, build cleanup, evidence processing and repository maintenance belong here or in the relevant docs, not in the README narrative. This separation was explicitly requested by the user.

Keep README instructions and prompts reusable. Personal pending tasks, specific saved-log filenames and session-specific machine status belong in the handoff, machine profile or log-intake docs. Link those records instead of embedding their current to-do list in the README.

Agent installation and Git access are documented in `docs/agent-setup.md`. The README contains separate preparation-computer and native-target prompts. `CLAUDE.md` imports this file so both agents share the same workflow. At session start summarize the verified machine, current status, missing evidence and next action; do not imply the agent inherited the chat or automatically read every linked document.

## Verify which machine you control

The initial documentation agent ran in WSL on the older computer, at `/home/shahzad/~~/ask/zenbook-duo-linux`. Its terminal did **not** control the new UX8407AA. Commands supplied in chat for the new machine are not evidence that they ran unless the user returned results.

On a new session read DMI product/board, OS release, kernel, desktop/session type, bootloader and root filesystem. Distinguish native Linux, live USB, WSL and chroot. Never infer the target from this repository's name. The diagnostic collector rejects WSL by default. Hardware and disk commands must run only on the identified target.

Current route: UX8407AA + CachyOS + KDE Wayland → evaluate selected Burakgon modules. UX8406MA/CA and other models → new profile and fresh compatibility assessment. Never set a force-model override just to make an installer proceed.

## Evidence discipline

- Keep `observed`, `user-reported`, `source-verified`, `inferred`, `proposed`, `applied`, and `validated` distinct.
- Treat upstream support tables as upstream claims, not this user's test results.
- Preserve failed attempts and corrections. Add dated outcomes instead of silently rewriting a failed trial as successful.
- Record exact commands, working directory, machine, kernel, source commit, exit status, results and rollback for meaningful trials.
- Mark missing outputs as pending. Do not fabricate a complete transcript or assume a proposed command was executed.
- A desktop reached after a reboot is recovery, not proof a graphics bug is fixed. A successful DKMS command is not proof the replacement driver is running.
- The photographed DMC/dual-pipe timeout and lower-panel TCSS/PHY failure are distinct hypotheses. Do not claim the TCSS module fixes the DMC freeze without evidence.

## Operating workflow

1. Inspect state and identify the machine. Prefer read-only diagnostics first.
2. Preserve full baseline logs locally and record relevant excerpts. Establish rollback before persistent changes.
3. Inspect the exact upstream commit and refresh issues relevant to the planned change. `docs/research/sources.json` is a historical snapshot, not a promise that upstream is unchanged.
4. Make one attributable change or a necessary dependency group. Verify build output, active driver/configuration, boot and the affected behavior.
5. Update the journal, issue status, machine JSON, handoff, module ledger and evidence catalog at the same checkpoint.
6. Run `python3 scripts/check_repository.py` and appropriate script syntax/behavior checks, then commit and push to main when within the user's repository-maintenance request.

Use the user's existing authorization. Windows/recovery erasure was explicitly approved **for the 2026 SSD during this installation**, not for other machines or future disks. Do not ask for that historical approval again; do not generalize it. The user explicitly authorized publishing this repository and keeping it on main. Inspect and sanitize new evidence before committing. Do not send upstream issue reports or other messages on the user's behalf without authorization.

If a live user has not authorized risky hardware work, explain the concrete proposed change after preparing its reviewable plan. Routine read-only work, documentation and reversible fixes within the existing task do not need repeated permission questions.

## Upstream implementation cautions

- No Burakgon module was installed at the initial handoff. Do not run `sudo ./duo apply --recommended` as an automatic onboarding step.
- Read `docs/research/source-review-findings.md`: an identical pre-existing file can be deleted on revert by the reviewed `duo_install_file` implementation. Reproduce, resolve and test ownership/rollback behavior before relying on it.
- Open upstream PR #2 addresses `NetworkAccess` hook compatibility. Test the actual pacman/libalpm capability; do not infer it solely from a version number.
- Some DKMS failures and initramfs/bootloader failures are logged as warnings. Inspect actual results and boot entries; do not equate exit 0 with complete installation.
- Preserve the encrypted-root command line, initramfs and /boot artifacts. Btrfs root snapshots do not automatically protect the FAT32 /boot partition or every excluded subvolume.
- Do not install competing Burakgon, Zakstam and Ubuntu runtime services together. Their ownership, display control and paths can overlap.
- Check kernel applicability. The reviewed 7.2 audio fixes should not be blindly applied to 7.3. Keyboard DKMS source was available for 7.2/7.3, not automatically 7.4.
- Fish is the user's installed terminal shell. Use `bash scripts/...` for Bash scripts and avoid giving unwrapped Bash assignments/heredocs to Fish.

## Keeping useful context

Use `templates/experiment.md` for trials and `templates/machine.md` for additional hardware. Keep raw data in `.local/` until reviewed. Publish selected evidence under a dated machine directory with checksums and a redaction note. Large build trees, ISOs, firmware dumps and upstream source checkouts do not belong in Git.

Do not include unrelated personal files or secrets. Keep JPEG evidence pixels unchanged when removing GPS/EXIF metadata. Preserve original hashes and describe transformations. Do not generate replacement screenshots with an image model.

Check `git status`, fetch remote changes and use ordinary fast-forward/rebase/merge workflows as appropriate; preserve concurrent work. No force push, destructive reset or automatic deletion of someone else's artifacts. Do not embed absolute workstation paths in Markdown links; documentation must work after cloning on another machine.

## Rust build cleanup (required user instruction)

Build artifacts are temporary. Clean up your own Rust outputs regularly, after completed checkpoints and before finishing or handing off a task. Do not wait for the user to notice disk growth.

- Before a substantial build, identify the actual target directory, including `CARGO_TARGET_DIR`, Cargo config overrides, nested workspaces and worktrees. Measure disk use at checkpoint boundaries. If project build caches exceed 5 GiB, review and remove obsolete caches before adding more; this is a review threshold, not permission to delete active outputs.
- Keep only caches needed for current work. Remove completed experiment, qualification, cross-compilation and abandoned worktree build outputs. Use distinct target directories when concurrent checkouts require isolation; retire each directory when that checkout's validation is complete.
- Once builds/tests and downstream consumers are finished, prefer `cargo clean --manifest-path /absolute/path/Cargo.toml --target-dir /absolute/path/to/target`. For a verified default workspace target, `cargo clean` is sufficient. Confirm resolved paths and ownership first; never run broad cleanup against a shared or unknown target directory.
- Before cleaning, check for active Cargo, rustc, nextest, test and application processes using those outputs, including other agents. Never interrupt them or delete their files. Recheck later if outputs remain in use.
- Save required test reports, audit evidence and requested release binaries outside the target directory before cleaning. Preserve source, uncommitted changes, lockfiles, installed tools and user data. Do not clear shared Cargo registry/git caches or Rust toolchains as routine project cleanup.
- Remove temporary Git worktrees only when clean, no longer in use and their commits are retained in the intended integration branch. Never force removal of a dirty worktree to recover space.
- Keep an active cache when imminent work genuinely needs it, then clean it after its last consumer finishes. Do not clean after every compile if that would force repeated rebuilds.
- At task completion, verify and briefly report recovered space and any deliberately retained build cache. The initial research/documentation work performed no Rust builds.
