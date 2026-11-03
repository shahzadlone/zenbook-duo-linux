# Set up an agent and clone the installation record

Instructions checked against official documentation on **2026-11-03**. This page
sets up an agent; it does not install laptop drivers. The two starting prompts
are in [README.md](../README.md).

## Choose the machine

| Where you run the agent | Role |
| --- | --- |
| Older Windows computer, inside WSL | Preparation and guidance. Its terminal cannot inspect the new laptop's hardware. Use Prompt 1. |
| New UX8407AA, installed CachyOS desktop | Local diagnostics and configuration. Use Prompt 2. |
| A future 2024/2025 machine | Identify the model and distro, then use a separate machine profile. Use Prompt 1 before installation or Prompt 2 once installed. |

On Windows, these Linux commands belong in an existing **WSL terminal**, not
PowerShell. Keep the checkout in the WSL home directory. On the new laptop, open
**Konsole in the installed desktop**, not the USB live session. No WSL is needed
on native CachyOS.

## Prerequisites

Check `git --version` and `curl --version`. On CachyOS, install missing tools with:

```sh
sudo pacman -S --needed git curl
```

On an Ubuntu/Debian WSL preparation environment, if needed:

```sh
sudo apt update
sudo apt install git curl
```

Use the package manager for the actual OS. If pacman reports stale mirrors or
missing package versions, retain the error for diagnosis; do not use `pacman -Sy`
alone. A system upgrade that changes the laptop's kernel belongs in the hardware
trial record, not an unnoticed agent-install prerequisite. See [Arch's partial
upgrade guidance](https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported).

## Codex CLI

Run the official standalone installer as your ordinary user:

```sh
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

This route installs a prebuilt CLI and needs neither npm nor a local Rust build.
Its default command location is `~/.local/bin/codex`. For the current CachyOS
Fish terminal:

```fish
fish_add_path "$HOME/.local/bin"
codex --version
```

For Bash, including a typical WSL terminal:

```bash
export PATH="$HOME/.local/bin:$PATH"
codex --version
```

The Bash command updates the current terminal; the installer also configures a
shell startup file. If a later terminal cannot find Codex, check the installer
output and PATH. In Fish, `fish_add_path` persists the path. Do not put a Bash
`export` command into Fish configuration. See the [Fish PATH command
reference](https://fishshell.com/docs/current/cmds/fish_add_path.html).

After cloning below, run `codex` from the repository root and complete **Sign in
with ChatGPT** in the browser, or use another supported method offered by the
CLI. Access depends on the signed-in account. Keep credentials out of this
repository. You do not need to create an API key just to try ChatGPT sign-in.

Sources: [official Codex CLI guide](https://learn.chatgpt.com/docs/codex/cli),
[installer source](https://chatgpt.com/codex/install.sh).

## Claude Code alternative

Install the native CLI as your ordinary user:

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

In Fish, run `fish_add_path "$HOME/.local/bin"`; in Bash, run
`export PATH="$HOME/.local/bin:$PATH"`. Then:

```sh
claude --version
```

Start `claude` from the cloned repository and complete its sign-in flow. Use an
account with Claude Code access; a ChatGPT subscription does not authenticate
Claude. The CLI's Linux route is the one documented here. CachyOS is not named
in Anthropic's listed distribution requirements, so successful operation on this
particular laptop remains to be verified. Node.js is not needed for this native
installer. If it fails, preserve the exact error.

Sources: [Claude Code setup](https://code.claude.com/docs/en/setup) and
[first-session quickstart](https://code.claude.com/docs/en/quickstart).

## Clone and start

The repository is public, so HTTPS cloning does not require a GitHub login:

```sh
cd ~
git clone https://github.com/shahzadlone/zenbook-duo-linux.git
cd zenbook-duo-linux
git status --short --branch
codex
```

Replace the last command with `claude` if you chose Claude Code. Paste the
appropriate prompt from [README.md](../README.md). Do not run the agent with
`sudo`; elevate individual system commands only when needed. You may need to
enter your password in the local terminal for those commands.

If SSH is already configured on **this** machine, you can instead clone with:

```sh
git clone git@github.com:shahzadlone/zenbook-duo-linux.git
```

Choose one clone method. For an existing checkout, open its actual directory,
check `git status --short --branch`, and fetch with `git fetch origin`. If it is
clean and on main, use `git pull --ff-only`. If there are local edits, commits or
divergence, let the agent reconcile them without discarding work. Do not clone
inside an existing checkout or replace its files with a downloaded ZIP.

## Enable pushes from the new machine

Reading the public repository and writing to it are separate. The new machine
needs its own GitHub authentication to push as an authorized account; logging
into Codex or Claude does not automatically configure Git.

For the HTTPS clone, GitHub CLI offers a browser login. On CachyOS, if `gh` is
missing, install `github-cli` with `sudo pacman -S --needed github-cli`, then run:

```sh
gh auth login --hostname github.com --git-protocol https --web
gh auth setup-git
gh auth status
```

Follow the browser flow for the account with write access. See [GitHub's
credential setup](https://docs.github.com/en/get-started/git-basics/caching-your-github-credentials-in-git)
and [GitHub CLI login](https://cli.github.com/manual/gh_auth_login).

Alternatively, configure a new SSH key on this laptop using [GitHub's SSH
guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).
For an existing HTTPS checkout, switch its remote only after SSH works:

```sh
git remote set-url origin git@github.com:shahzadlone/zenbook-duo-linux.git
```

Before the first commit, check `git config user.name` and `git config user.email`.
If unset, configure your preferred author name and GitHub-associated or GitHub
noreply email using `git config user.name "YOUR NAME"` and
`git config user.email "YOUR EMAIL"` inside the repository. These are placeholders
to replace, not credentials. The agent can perform the authorized commits and
pushes after setup. Authentication problems should not stop local diagnostics
and documentation; record any unpushed commit in the handoff.

## Confirm context and begin the hardware work

Codex discovers the repository's [AGENTS.md](../AGENTS.md). The checked-in
[CLAUDE.md](../CLAUDE.md) explicitly imports that same file for Claude. Launching
in the repository and using a README prompt directs either agent to the detailed
record. If it starts without reading the record, ask it to read those files first.
See [Codex instruction discovery](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
and [Claude imports](https://code.claude.com/docs/en/memory#import-additional-files).

The next agent should first report the verified machine, last known state,
pending logs and proposed next action. For the current laptop, the sequence is:

1. Verify native UX8407AA/CachyOS and collect the baseline.
2. Read the saved failed/current boot logs and establish recovery coverage.
3. Resolve or verify resolution of the reviewed rollback defect and check hooks.
4. Select applicable modules and dependencies, then apply and test in stages.
5. Update the journal, machine/module state, issues and handoff after each trial.

The detailed [handoff](handoff.md), [module assessment](research/burakgon-modules.md)
and [recording workflow](workflow.md) define these steps. No successful module
installation is assumed just because an agent has been launched.

Copy the saved previous/current boot logs into `logs/incoming/` using the file
manager. They are intentionally ignored by Git until reviewed, so copying them
to the older machine's checkout does not deliver them to the new laptop's clone.
Keep originals and let the local agent prepare reviewed evidence.

At the end of a session, ask the agent to save a checkpoint and update the exact
next action before rebooting or moving to another machine. The next session reads
the updated repository; continuity does not depend on an old chat being available.
