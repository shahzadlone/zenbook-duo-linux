# Linux on ASUS Zenbook Duo

Installation guidance, tested results and troubleshooting for ASUS Zenbook Duo laptops, starting with the **2026 UX8407AA on CachyOS + KDE Plasma + Wayland**.

See the [machine profiles](machines/) for recorded configurations and test results, and the [installation journal](docs/journey/2026-11-03.md) for the documented journey.

## Which approach should I use?

| Laptop | Approach |
| --- | --- |
| 2026 UX8407AA, CachyOS, KDE Wayland | Start with the distribution's kernel, then select applicable [Burakgon modules](docs/research/burakgon-modules.md) based on actual hardware tests. |
| 2024/2025 UX8406 family or another distro | Confirm the exact model and software first; use the [project comparison](docs/research/project-comparison.md) to choose compatible fixes. The 2026 patches are not interchangeable with older models. |

Burakgon modules are individual fixes: some change configuration or add firmware, while others build replacement kernel drivers. Installing Linux does **not** automatically mean you need to patch the whole kernel. Check the [source-review findings](docs/research/source-review-findings.md) and hardware compatibility before selecting fixes.

## Install Codex on the CachyOS laptop

Open **Konsole** on the installed laptop. Run each step in order, stopping if a command reports an error.

1. Check that Git and curl are available:

   ```sh
   git --version
   curl --version
   ```

   If either is missing, install them on CachyOS:

   ```sh
   sudo pacman -S --needed git curl
   ```

2. Install Codex using the [official standalone Linux installer](https://learn.chatgpt.com/docs/codex/cli). Node.js is not needed:

   ```sh
   curl -fsSL https://chatgpt.com/codex/install.sh | sh
   ```

3. If your shell is **Fish**, add its location and verify it:

   ```fish
   fish_add_path "$HOME/.local/bin"
   codex --version
   ```

   For Bash instead, use `export PATH="$HOME/.local/bin:$PATH"` in the current terminal.

4. Clone this public repository, then start Codex inside it:

   ```sh
   cd ~
   git clone https://github.com/shahzadlone/zenbook-duo-linux.git
   cd zenbook-duo-linux
   codex
   ```

   Choose **Sign in with ChatGPT** and finish the browser sign-in. If the installer already opened Codex outside the repository, exit that session and launch it here.

5. Paste **Prompt 2** below on the installed Linux laptop. Use **Prompt 1** on a separate computer that will guide you through installing Linux.

If you already cloned the repository, open that folder instead of cloning again. See [agent setup](docs/agent-setup.md) for updating an existing checkout, GitHub push access, Bash/WSL setup and installation troubleshooting.

## Use Claude Code instead

Use the same repository and prompts. In Konsole, install the [official Claude Code CLI](https://code.claude.com/docs/en/setup):

```sh
curl -fsSL https://claude.ai/install.sh | bash
```

Then, in Fish:

```fish
fish_add_path "$HOME/.local/bin"
claude --version
cd ~/zenbook-duo-linux
claude
```

Clone the repository first if you skipped the Codex instructions. Follow Claude's sign-in flow; Claude access is separate from ChatGPT access. You only need one of these agents. [Additional setup details](docs/agent-setup.md).

## Prompt 1 — guide me from another computer

Use this on a preparation computer, including Windows with WSL. The agent guides you through work on the target laptop and records the results you return.

```text
Help me install and configure Linux on an ASUS Zenbook Duo, guiding me through
the process step by step. You are running on my preparation computer; your
terminal does not automatically control the laptop being installed.

Read AGENTS.md, docs/research/project-comparison.md, and any existing machine
profile, handoff and journal relevant to this target. Use the recorded lessons, but
verify current upstream documentation and compatibility before recommending fixes.

First establish the target laptop's exact model/year, current OS, desired Linux
distro/desktop, whether installation has already begun, backup status and whether
Windows should be kept. Reuse facts already established for this target. Do not
reinstall an already installed system or extend an old disk-erasure approval to
another machine. Distinguish commands for this computer from commands I must run
on the target. For a 2024/2025 model, create its own profile and choose compatible
fixes instead of assuming the UX8407AA approach applies.

Guide me through the remaining stages: image selection and checksum, USB creation,
firmware/boot, live hardware checks, disk/encryption choices, installation,
first boot and troubleshooting. Give a small actionable batch at a time, explain
what I should see, and wait for my results before dependent steps. If something
fails, capture the error and investigate it rather than assuming the cause.

Use docs/workflow.md and templates/experiment.md to record commands, returned
outputs, successes, failures, corrections and decisions. Separate proposed work
from work actually performed. Keep the relevant machine state, issues and handoff
current. Review logs before publication and push meaningful checkpoints to main
without overwriting work from the other computer. When native Linux is usable,
help me install an agent, clone this repository on it and continue with Prompt 2.
```

## Prompt 2 — finish setup locally on the Linux laptop

Use this **inside the repository on the installed Linux laptop** to continue configuration and troubleshooting from its existing state.

```text
Continue configuring this Zenbook Duo locally until its Linux setup is stable.
Read AGENTS.md, docs/open-issues.md, the relevant machine profile and state.json,
and its handoff and research before changing hardware settings. Treat findings
for other machines as reference material, not this machine's measured state.

Verify which machine and environment your terminal actually controls: DMI model,
distro, kernel, desktop/session, bootloader, encryption and mounts. If it is
WSL or live media, establish access to the installed target before applying fixes.

Inspect Git state and reconcile remote main while preserving local changes.
Collect a read-only baseline with bash scripts/collect-diagnostics.sh --sudo and
review available logs. Verify which fixes are already installed and compare the
measured state with the record. Investigate unresolved issues using full evidence;
a clean filtered log or a single successful boot does not establish a lasting fix.

For UX8407AA/CachyOS/KDE, use selected Burakgon modules appropriate to the actual
kernel and symptoms, using docs/research/burakgon-modules.md and the source-review
findings. For other models or distros, assess the compatible approach first.
Establish recovery, preserve boot/encryption settings and back up affected files.
Refresh upstream research and verify applicability, dependencies and rollback.
Implement needed fixes in attributable steps or necessary dependency groups.
Avoid blanket presets, competing runtimes and patches already included upstream.

Carry out the diagnostics and applicable reversible fixes within this setup task.
For actions requiring physical interaction or a reboot, save a checkpoint first
and give me clear instructions. Verify actual loaded drivers, initramfs/boot
entries and behavior, not just installer exit codes. Test both screens, rotation,
touch, keyboard dock/Bluetooth, brightness, audio, boot/login and suspend/resume;
record untested cases and power tradeoffs. Record failed trials and rollbacks too.

Follow docs/workflow.md and templates/experiment.md after every meaningful trial:
record exact commands, source commits, kernel, outputs, outcome and rollback;
update the machine/module ledger, issues, journal, evidence and handoff. Review
and redact logs before publishing, run repository checks, and commit/push to main
without overwriting concurrent work. Begin by summarizing the verified state,
missing evidence and the next concrete action, then continue the work.
```

## How the next agent gets context

Start the agent **in the cloned repository** and give it the appropriate prompt. Codex loads [AGENTS.md](AGENTS.md); [CLAUDE.md](CLAUDE.md) imports the same instructions for Claude Code. Those instructions direct the agent to the relevant machine record and require documentation of each trial. The repository carries context between sessions; earlier conversations are not automatically available. See [Codex instructions](https://learn.chatgpt.com/docs/agent-configuration/agents-md) and [Claude project instructions](https://code.claude.com/docs/en/memory).

## Installation record and troubleshooting

- [Installation journey](docs/journey/2026-11-03.md): research, USB preparation, installation, failures and recovery.
- [Current handoff](docs/handoff.md), [UX8407AA status](machines/ux8407aa-2026/README.md) and [open issues](docs/open-issues.md).
- [Research comparison](docs/research/project-comparison.md) and [module selection](docs/research/burakgon-modules.md).
- [Installer timeout](docs/troubleshooting/installer-keyring-timeout.md) and [graphics freeze](docs/troubleshooting/graphics-freeze.md).
- [Evidence](evidence/README.md) and [adding logs](logs/README.md).
- [Recording trials](docs/workflow.md) and [templates](templates/README.md).
