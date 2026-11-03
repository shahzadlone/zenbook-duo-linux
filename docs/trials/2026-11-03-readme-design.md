# README visual design checkpoint

- Date: 2026-11-03, America/Toronto.
- Environment: preparation host, not the target laptop.
- Scope: README presentation and original decorative media.
- Hardware/configuration changes: none.

## Design and assets

Two 2172 × 724 PNG illustrations use a midnight-blue/cyan palette, a dual-screen
Zenbook Duo-style laptop and Linux Tux. The cover uses studio-render styling;
the field-guide image uses technical-sketch styling. They are concept art, not
hardware evidence. Both outputs were copied unchanged into `assets/artwork/`,
with final prompts, dimensions and SHA-256 hashes in its generation manifest.
Three small local SVG badges label the chosen software stack.

The README adds navigation and two entry paths. Claude's alternative setup and
both complete AI prompts use native GitHub-supported details/summary disclosure.
Existing prompt heading links remain intact. Session-specific reminders and
local maintenance details were not reintroduced.

## Validation

- GitHub's Markdown API rendered the README successfully. A local preview used
  that HTML with a GitHub-style stylesheet; this is not a screenshot of the live
  repository page.
- Reviewed desktop dark (1080 px) and mobile light (390 px) in Chromium. All five
  images loaded; document width equaled viewport width in both layouts.
- All three disclosures started collapsed, opened on summary clicks, and exposed
  the full two prompts. Their rendered text lengths were 1891 and 2484 characters.
- Compared all nine original fenced command/prompt blocks against the preceding
  commit: content and order were preserved exactly.
- Checked local HTML/Markdown references, image alternative text, SVG structure,
  navigation targets and artwork checksums. Repository consistency and whitespace
  checks passed.

The first anchor check treated the Markdown API's absence of generated heading
IDs as missing links. GitHub adds those at the repository-page layer; the local
preview supplied equivalent heading IDs before checking navigation. The first
code-block comparison also required a correction to handle indented Markdown
fences. Neither finding required changing the setup commands or prompts.

A first CLI screenshot requested a 430 px window but Chromium used a 500 px
viewport. That capture was discarded as a mobile check. The final review used
explicit device-metric emulation at 390 px and verified the actual viewport.

## Cleanup

No Rust build ran; no Rust cache was created or retained. Generated source images
remain in the image tool's output directory as required by the tool. Preview
captures and the browser report stay in ignored `.local/readme-preview/`.
Removed the three inactive task-owned browser profiles after their processes
exited, reclaiming 41,521,523 bytes. The preview HTTP server was stopped.
