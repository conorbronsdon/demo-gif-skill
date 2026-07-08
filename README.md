# demo-gif

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)

A Claude Code skill that adds a demo GIF to a repo's README. Point it at a CLI tool, a TUI, a web app, or a library and it picks a recording method, generates a reproducible recording script, renders it, shrinks the file, and drops in the right markdown.

The goal is to make "add a demo gif to this README" a one-prompt task instead of a 45-minute detour into screen recording software, hand-tuned ffmpeg flags, and a 30 MB file nobody wants to commit.

## What it does

1. Looks at the repo and figures out what kind of demo fits: terminal recording for a CLI or TUI, browser recording for a web app, a REPL/example script for a library.
2. Writes a recording script instead of eyeballing a screen capture. Terminal demos use [vhs](https://github.com/charmbracelet/vhs) `.tape` files, which are plain text and re-runnable, so the demo can be regenerated later when the tool changes. Web demos use a Playwright script.
3. Renders it, then optimizes: frame rate, width, and lossy compression tuned to land under 8 MB.
4. Embeds it in the README with real alt text, committed to the repo instead of pointed at an external image host.

## Install

Copy the skill folder into your project's skills directory:

```bash
cp -r demo-gif-skill /path/to/your-project/.claude/skills/demo-gif
```

Or, if you're using Claude Code's plugin system, install it as a plugin per your plugin marketplace's normal flow and point it at this repo.

Either way, once it's in place, Claude Code will pick it up automatically when a prompt matches (see below). No extra configuration needed.

## Usage

Drop it into a Claude Code session in the target repo and ask for what you want:

- "Add a demo gif to this README"
- "Record a demo of the CLI and put it at the top of the README"
- "This repo needs a demo showing the login flow"

Claude Code reads `SKILL.md`, works out whether the repo is a CLI, TUI, web app, or library, and walks the recording → render → optimize → embed pipeline. It'll ask if it's genuinely unsure what to demo (which screen, which flow), but otherwise it should get to a working GIF without much back and forth.

## Requirements

You need at least one of these installed, depending on what you're demoing:

- **Terminal demos:** [vhs](https://github.com/charmbracelet/vhs) (`brew install vhs`, `scoop install charmbracelet/tap/vhs`, `go install github.com/charmbracelet/vhs@latest`, or Docker). vhs itself shells out to `ttyd` and `ffmpeg`, so those need to be on PATH too. No vhs available? Fall back to [asciinema](https://asciinema.org/) + [agg](https://github.com/asciinema/agg) — covered in `references/tape-cookbook.md`.
- **Web app demos:** [Playwright](https://playwright.dev/) (`npm install -D @playwright/test`) plus [ffmpeg](https://ffmpeg.org/) for the video-to-GIF conversion.
- **Optimization:** [gifsicle](https://www.lcdf.org/gifsicle/) for the final size pass. Optional: [gifski](https://gif.ski/) as an alternative GIF encoder for image-heavy content.

None of these are bundled. The skill tells you what's missing and how to install it if a command fails.

## What's in here

```
demo-gif-skill/
├── SKILL.md                    # the skill itself — core flow and decision logic
├── references/
│   ├── tape-cookbook.md        # full vhs .tape command reference + patterns
│   └── web-capture.md          # Playwright recording + ffmpeg GIF conversion recipes
├── examples/
│   ├── cli-demo.tape           # complete, adaptable vhs example
│   └── web-demo.spec.ts        # complete, adaptable Playwright example
├── LICENSE
└── README.md
```

`SKILL.md` is what Claude Code actually loads and follows. The `references/` files are pulled in as needed for the deeper command syntax so the main skill file stays short. `examples/` are working starting points, not templates to fill in blanks on — copy one, adapt the parts specific to your tool.

## Notes on the approach

Screen-recording software gets you a GIF once. A `.tape` file or a Playwright script gets you a GIF you can regenerate every time the tool's output changes, which is the actual problem with demo GIFs going stale in READMEs. That reproducibility is the whole reason this skill defaults to vhs and Playwright instead of "record your screen and trim it in an editor."

The size targets and flag choices in `SKILL.md` and the reference docs were checked against the tools' actual documentation (and, where the tool was available locally, against real `--help` output) rather than assumed. If a flag has since changed in a newer release, `vhs validate`, `ffmpeg -h filter=<name>`, and `gifsicle --help` are the fastest way to confirm current behavior.

## License

MIT. See `LICENSE`.
