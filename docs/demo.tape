# Records docs/demo.gif for the README. Shows the skill's core loop: write a
# small .tape and check the rendered output's file size against the skill's
# own <8MB budget (see SKILL.md Step 4).
#
# Two things this tape deliberately does NOT do, both discovered while
# building this demo and filed as fixes in SKILL.md's failure modes:
#
# 1. It does not invoke `vhs` live inside the recorded shell. vhs's own
#    recorded bash session does not have `vhs` on PATH (confirmed on this
#    Windows/vhs-0.11.0 setup: `vhs validate ...` inside a recording fails
#    with "bash: vhs: command not found" even though vhs is on PATH in the
#    invoking terminal — vhs launches ttyd's shell with a minimal
#    environment, not the caller's full PATH).
# 2. Separately, actually nesting a full `vhs <file>.tape` render inside
#    another vhs recording (tried before discovering #1) reproducibly
#    crashes vhs's browser-automation layer: `panic: write tcp ...: use of
#    closed network connection` in go-rod — the inner and outer chromedp
#    sessions collide.
#
# docs/sample.gif is therefore pre-rendered for real (`vhs docs/sample.tape`,
# run separately, before this recording) and committed alongside this tape,
# so the size `ls -la` shows below is a real, reproducible, checkable number
# — not a live nested render, but not fabricated either.
#
# No further optimization pass on docs/demo.gif below: gifsicle isn't
# installed on the machine this was hardened on, and the ffmpeg two-pass
# palette substitute (SKILL.md's "no gifsicle" fallback) was tried on this
# recording and made the file bigger (126KB direct vhs output vs 175KB after
# an mp4 round-trip + palettegen/paletteuse) — re-encoding a short,
# mostly-static terminal clip through video loses more than it gains. vhs's
# direct GIF output was already ~65x under the 8MB budget, so it's used as-is.
#
# Regenerate: vhs docs/demo.tape   (run from repo root; needs docs/sample.gif
# already rendered — see docs/sample.tape's own header for that command)
Output docs/demo.gif

Require cat
Require ls

Set Shell "bash"
Set FontSize 20
Set FontFamily "Consolas"
Set Width 1000
Set Height 560
Set Theme "Dracula"
Set Padding 20
Set WindowBar Colorful
Set TypingSpeed 55ms

Hide
Type "clear"
Enter
Sleep 300ms
Show

Type "cat docs/sample.tape"
Sleep 500ms
Enter
Sleep 5s

Type "ls -la docs/sample.gif"
Sleep 500ms
Enter
Sleep 4500ms
