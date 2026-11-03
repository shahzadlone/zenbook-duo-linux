# UX8406 family: planning only

The older working computer was identified as **UX8406MA** in the earlier session summary. It was running Windows with WSL and hosted the tools used to prepare the USB and this repository. No native Linux installation, repartitioning or Duo hardware patch was performed on it in the recorded workflow. Reconfirm DMI locally before acting.

Keep **2024 UX8406MA**, **2025 UX8406CA**, and **2026 UX8407AA** distinct. A marketing name or year alone does not establish USB IDs, sensor firmware, audio layout, GPU driver or dock behavior. UX481/UX482 are separate designs again.

## Candidate routes

- Zakstam's project explicitly lists UX8406MA and UX8406CA, with GNOME/KDE/niri/Hyprland Wayland support and apt/dnf/pacman installers. Its claims require local validation. Its 2026 kernel preparation is separate from its UX8406 runtime support.
- Cceelen's packages have a particularly useful UX8406-focused structure: thermal guard, lower-screen control, HID-BPF keyboard support, and GNOME-specific keys/rotation. Hardware testing is reported on **UX8406CA + Fedora 44 + GNOME 50**. UX8406MA is explicitly not hardware-tested there; package-container success is not hardware validation.
- Burakgon's reviewed code targets UX8407 hardware and must not be forced onto UX8406. The Ubuntu 2026 fork's kernel patches are not automatically appropriate either.

## Before choosing a distribution

Collect the exact product/board, BIOS, CPU/GPU, keyboard USB and Bluetooth IDs, disk layout, existing OS, desktop preference and ownership of any installed Duo service. Test a live image's networking, input and graphics. Ask for that machine's storage plan and backups when repartitioning is actually proposed; the 2026 erase approval does not transfer.

Do not preselect Fedora or CachyOS solely because one was used on the other laptop. Match the model, preferred desktop, package availability, support maturity and required fixes. Record the selected route in a new machine-specific state file before installation.
