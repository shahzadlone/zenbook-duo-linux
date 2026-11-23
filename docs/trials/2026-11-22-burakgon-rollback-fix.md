# Trial: SRC-001 rollback fix, 2026-11-22

Machine: UX8407AA laptop (agent session; test code only ran in disposable temp
paths under `.local/`). Upstream source: Burakgon
`zenbook-duo-2026-linux` commit `8030783aac5273da5f2aa0da217a6bc408ee0533`.

## What was done

1. Re-ran the original reproducer against a pristine checkout
   (`.local/research/burakgon-upstream`): **SRC-001 still reproduces** —
   revert deleted a pre-existing, unowned, byte-identical destination file.
2. Implemented a fix in a separate reviewed checkout
   (`.local/research/burakgon-fixed`), only `lib/actions.sh` changed.
   Patch preserved at [burakgon-rollback-fix.patch](../../evidence/research/burakgon-rollback-fix.patch).
3. Added a 13-scenario matrix, [test-burakgon-rollback-fix.sh](../../scripts/test-burakgon-rollback-fix.sh):
   pre-existing identical/different, new file, module-created file (idempotent
   reapply, changed source), repeated applies, mode enforcement, symlink
   destination, single-backup invariant.

## Fix design

`duo_install_file`'s unchanged branch previously recorded the destination with
`_existing_backup` (which returns `-` when the module never backed it up);
revert treats `-` as "module created this" and deletes it. The fix:

- Backs up a pre-existing identical destination **before** recording it, so
  revert restores instead of deletes. A module-created file is still removed on
  revert because its older `-` manifest line replays after the restore
  (manifests are replayed newest-first).
- Treats identical content with a different requested mode as **not** a no-op
  (addresses the review's mode-enforcement concern).
- Excludes symlinks from the unchanged shortcut so they are backed up and
  restored as symlinks rather than silently replaced in place.

## Results

| Checkout | Test matrix | Result |
| --- | --- | --- |
| pristine `8030783` | [pristine transcript](../../evidence/research/burakgon-rollback-fix-tests-pristine.txt) | 9 passed / 4 failed — scenario 1 (SRC-001) and 7a/7b (mode) fail as expected |
| fixed (this patch) | [fixed transcript](../../evidence/research/burakgon-rollback-fix-tests-fixed.txt) | **13 passed / 0 failed** |

## Status and limits

- `applied` in the reviewed local checkout only; **not upstream, not on this
  laptop's system state, no module installed yet**.
- Not sent upstream — no upstream communication is authorized yet.
- The revert-time `_record`/dedupe interplay was tested only through
  `duo_install_file` scenarios; DKMS, unit and cmdline revert paths are
  unchanged code and were not exercised here.
- Test harness runs helpers directly with `MOD_ID` set; it does not run the
  `duo` CLI entry, so argument parsing and module selection remain untested.
