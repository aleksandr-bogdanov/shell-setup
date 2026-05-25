# Learn to sh again

A daily-trainable guide to living in the terminal without reaching for
Finder, Activity Monitor, GitHub Desktop, or the browser for every
little thing.

**How to use this doc:**

1. Read it top-to-bottom once.
2. Pick a *Level* per day. Drill those 5–10 commands until they're
   automatic. **Cover the right column with your hand, recite from the
   description.**
3. Move on to the next Level only when the previous one stops
   requiring conscious thought.
4. Once you've finished Level 8, re-read the "When you'd open ____, do
   this instead" table every morning for a week.

This is muscle memory work. It takes ~2 weeks of daily drill to feel
fluent. The reward: you stop context-switching to a GUI a dozen times
a day.

---

## Level 0 — Just survive

Bare minimum to open the terminal and not panic.

| What you want | How |
|---|---|
| Open a new terminal tab | `Cmd+T` |
| Split the terminal pane vertically | `Cmd+D` |
| Split horizontally | `Cmd+Shift+D` |
| Jump between splits | `Cmd+←/→/↑/↓` |
| Close a split | `Cmd+Shift+W` |
| Close the whole tab | `Cmd+W` (kills all splits!) |
| Zoom one split to fullscreen / unzoom | `Cmd+Shift+Enter` |
| Scroll back through output | mouse wheel, or `Cmd+J/K` (line) / `Cmd+U/I` (page) |
| Jump to **the previous shell prompt** in scrollback | `Cmd+Shift+J` / `Cmd+Shift+K` |
| Reload Kitty config | `Cmd+Shift+R` |

**Drill prompt:** open Kitty, split it 3 ways with `Cmd+D` and
`Cmd+Shift+D`, run `ls` in each, bounce between them with `Cmd+←/→`,
close two with `Cmd+Shift+W`.

---

## Level 1 — Stop typing paths

The single highest-payoff habit: never type a directory path again.

| What you want | How |
|---|---|
| Jump to a frequent dir | `z fragment` — fuzzy-matches your most-visited dirs |
| Jump using multiple words | `z foo bar` — dir matching both "foo" AND "bar" |
| Open an fzf picker over all your visited dirs | `zi` |
| Open the fuzzy directory picker (any subdir of current) | `Alt+C` |
| Open the fuzzy file picker (paste path into current command) | `Ctrl+T` |
| Search through your shell history | `Ctrl+R` then type fragments |
| Walk history matching a fragment you started typing | type, then `↑/↓` |
| Accept a grey ghost-text suggestion | `→` (right arrow) |

**Drill prompt:**

```
cd ~/IdeaProjects/whenful      # do once today to seed zoxide
cd ~                            # back home
z whe                           # back instantly
zi                              # see your top dirs interactively
Ctrl+R then "git"               # fuzzy-find a past git command
```

**Mental model rewrite:** stop thinking "what's the path?" and start
thinking "what's the *fragment*?" `z whe` always wins over typing
`~/IdeaProjects/whenful`.

---

## Level 2 — Stop opening Finder

Finder is a slow tab-bar nightmare. You have two replacements:

### Quick file listing (instead of opening a Finder window to glance)

| What you want | How |
|---|---|
| List files (color-coded, git-aware) | `ls` |
| List with details (size, date, git status, permissions) | `ll` |
| Include hidden files | `la` |
| Tree view, 2 levels deep, skipping `.gitignore`d | `lt` |
| Filter to one extension | `ls *.tsx` |
| Just the dirs | `ls -D` |
| Sort by size | `ls -s` (or `ll -s`) |
| Sort by modified time | `ll -snew` (newest first) |

### Full TUI file manager (instead of clicking through Finder)

| What you want | How |
|---|---|
| Open Yazi here | `yazi` (or in Kitty: `Cmd+Shift+Y` opens a split with Yazi) |
| Move down/up | `j` / `k` |
| Enter dir / parent dir | `l` / `h` |
| Search inside current dir | `/` then type |
| Preview a file | just navigate to it — preview pane is automatic |
| Open file in `$EDITOR` | `Enter` |
| Yank / cut / paste | `y` / `x` / `p` |
| Delete to trash | `d` |
| Bookmark current dir | `m` then a letter (e.g. `mp` for "projects") |
| Jump to bookmark | `'` then the letter (e.g. `'p`) |
| Quit Yazi | `q` |

**Drill prompt:** `cd ~ && yazi`. Navigate to `~/IdeaProjects/whenful/src`
without using the mouse. Preview 5 files. Bookmark with `mp`. Quit. Run
yazi again, jump back with `'p`.

---

## Level 3 — Stop reading garbage

`cat`'s output is plaintext from 1971. You have prettier replacements.

| What you want | How |
|---|---|
| Pretty syntax-highlighted file view | `cat file.py` (aliased to `bat --paging=never`) |
| Paged view with line numbers + git markers | `bat file.py` (no alias) |
| Diff between two files, syntax-highlighted | `bat --diff old new` |
| Show whitespace + non-printing chars (debug invisible chars) | `bat -A file.txt` |
| Render a markdown file beautifully | `glow README.md` |
| Interactive picker over all `.md` in current dir | `glow .` |
| Pretty git diff (already wired into git) | `git diff` |
| Pretty git log with patch | `git log -p` (paged through delta — `n`/`N` jump hunks) |
| Pretty `git show` | `git show HEAD` |

**Drill prompt:**

```
cat ~/.zshrc          # see colored zsh + line numbers + git gutter
glow README.md        # in any repo — see markdown rendered
git diff              # in a dirty repo — see delta output
```

---

## Level 4 — Find things fast

Stop using Finder's search, stop opening "Find in files" in your editor.

| What you want | How |
|---|---|
| Search a string across the whole project (respects `.gitignore`) | `rg "TODO"` |
| Case-insensitive | `rg -i "useState"` |
| Only Python files | `rg -t py "def main"` |
| Show 3 lines before + 3 after each match | `rg -B 3 -A 3 "import"` |
| List filenames only (no match line) | `rg -l "claude"` |
| Count matches per file | `rg -c "TODO"` |
| Find a file by name fragment | `fd readme` |
| All Markdown files in project | `fd -e md` |
| Multiple extensions | `fd -e ts -e tsx` |
| Include hidden + gitignored files | `fd -H "config"` |
| Run a command on each match | `fd -e py -x wc -l` |
| Combine fd + fzf into a custom file picker | `fd -e tsx \| fzf` |
| Open the picked file in your editor | `$EDITOR $(fd -e tsx \| fzf)` |

**Drill prompt:**

```
cd ~/IdeaProjects/whenful
rg "TODO"                              # see every TODO in the project
rg -l "useState" | head                # files using useState
fd -e tsx                              # all TSX files
$EDITOR $(fd -e tsx | fzf)             # pick a TSX file and edit it
```

**Mental model rewrite:** stop opening editor → Cmd+P → type filename.
Start typing `fd fragment` or `rg "pattern"` in the terminal — it's
faster and shows you context the editor can't.

---

## Level 5 — System awareness

Stop opening Activity Monitor.

| What you want | How |
|---|---|
| Live process / CPU / memory / network monitor | `btm` |
| Modern `ps` — see what processes are running | `procs` |
| Filter processes by name | `procs node` |
| Tree view of process hierarchy | `procs --tree` |
| What's eating my disk? (visual bars) | `dust ~/` |
| Interactive disk explorer (navigate to find the culprit) | `ncdu ~/` |
| How much free space per disk? | `duf` |
| Real-time "who's using my network bandwidth" | `sudo bandwhich` |
| Ping with a real-time graph | `gping google.com` |
| Compare two hosts on the same graph | `gping cloudflare.com 1.1.1.1` |

**Drill prompt:**

```
btm                              # look around for 30s, q to quit
dust ~/                          # find the biggest dir in your home
procs claude                     # see Claude Code processes
sudo bandwhich                   # see what's using net right now, q to quit
```

---

## Level 6 — Git without leaving terminal

GitHub Desktop is for amateurs.

### `lazygit` — the TUI

`lazygit` opens a split-pane TUI showing files, branches, commits,
stashes. Everything keyboard-driven.

| What you want | How (inside lazygit) |
|---|---|
| Open lazygit in current repo | `lazygit` |
| **See all keybindings for the current panel** | `?` |
| Cycle panels (files → branches → commits → stashes) | `Tab` |
| Stage a file | `Space` on the file |
| Stage individual hunks within a file | `Enter` on the file, then `Space` on hunks |
| Commit | `c` (opens a text editor for the message) |
| Quick commit (no editor) | `C` (capital) |
| Push | `P` |
| Pull | `p` |
| Switch to a branch | navigate to branches panel (`Tab`×N), then `Space` on the branch |
| Rebase the current branch on another | branches panel, `r` |
| Cherry-pick a commit | commits panel, `c` |
| Open the current line on GitHub | `o` |
| Quit | `q` (also Esc/Cmd+W) |

**Drill prompt:** in any repo with uncommitted changes, run `lazygit`,
hit `?` to see help, stage with `Space`, commit with `c`, quit with `q`.
Do this every time you'd reach for GitHub Desktop. The first week feels
slow; by week three you'll laugh at GitHub Desktop's loading times.

### Inline git from the shell (already enhanced with delta)

| What you want | How |
|---|---|
| See uncommitted changes | `git diff` |
| See staged changes | `git diff --staged` |
| See history with diffs | `git log -p` |
| Jump to next/prev hunk in paged output | `n` / `N` |
| See one specific commit | `git show <sha>` |
| See changes between branches | `git diff main...feature-branch` |
| 3-way merge conflict markers (much more readable) | already on via `merge.conflictstyle = zdiff3` |

---

## Level 7 — Smart text manipulation

`sed` is hostile. You have `sd`.

| What you want | How |
|---|---|
| Replace text in one file (in place) | `sd "old" "new" file.txt` |
| Pipe through replace | `echo "hi world" \| sd "world" "earth"` |
| Preview before writing (dry run) | `sd -p "old" "new" *.md` |
| Replace in many files | `fd -e md -x sd "old" "new"` |
| Regex with capture groups | `sd "(\d+)" "\$1ms" log.txt` |
| Search + sed-style replace across project | `rg "TODO" -l \| xargs sd "TODO" "DONE"` |

**Drill prompt:** make a `/tmp/test.md` with some "TODO"s, then:

```
sd "TODO" "DONE" /tmp/test.md
cat /tmp/test.md
```

---

## Level 8 — Per-project bliss + theme switching

### direnv (per-project env vars)

The trick: when you `cd` into a project, environment variables for
that project auto-load. When you leave, they unload.

```bash
cd ~/IdeaProjects/whenful
echo 'dotenv .env' > .envrc      # one-time: tell direnv to read .env
direnv allow                      # one-time: approve this dir
# Now every cd into here auto-loads the .env file
cd ~
echo $DATABASE_URL                # empty
cd ~/IdeaProjects/whenful
echo $DATABASE_URL                # loaded from .env
```

**Security note:** direnv only runs `.envrc` files you've explicitly
`direnv allow`-ed. If you clone a sus repo and `cd` in, you'll see a
"blocked" warning until you allow it. Read the `.envrc` first — it's
just bash.

### Theme switching

The whole stack switches palette in one command.

| What you want | How |
|---|---|
| Switch to Catppuccin Latte | `theme cat` (or `theme latte`) |
| Switch to Nord Light | `theme nord` |
| Switch to OneHalfLight | `theme one` |
| List available themes | `theme list` |
| fzf-driven theme picker | `themepick` |

When you switch:
- Kitty's 16-color palette hot-swaps in **all open windows**
- bat / fd / eza / ls / fzf / delta / lazygit / btm / tldr all update
- zsh-syntax-highlighting + autosuggestions colors update (run `exec
  zsh` in pre-existing shells to pick them up)

---

## Level 9 — Quick reference (stop opening the browser)

Stop opening MDN, Stack Overflow, or man pages for routine "how do I…"
questions.

| What you want | How |
|---|---|
| Concise practical examples for any tool | `tldr <tool>` |
| Update the tldr cheatsheet cache | `tldr --update` |
| Render any local Markdown beautifully | `glow file.md` |
| Render Markdown from a URL | `glow https://raw.githubusercontent.com/.../README.md` |
| One-liner search of past commands | `Ctrl+R` |
| What was the absolute path of that file I touched yesterday? | `Ctrl+R` then a fragment of the path |
| What was the *full* command I ran 2 days ago? | `Ctrl+R`, fuzzy fragment, scroll |

**Drill prompt:**

```
tldr tar             # what man should have been
tldr ffmpeg          # the 10 actually-useful invocations
tldr git rebase      # without the 800-line warning
glow README.md       # in any repo
```

---

## When you'd open _____, do this instead

| Reach for… | Do this instead |
|---|---|
| **Finder** | `yazi` (TUI), or `ls` / `lt` / `eza` in the shell |
| **Activity Monitor** | `btm` (rich), `procs` (filterable), `procs --watch` (auto-refresh) |
| **GitHub Desktop** | `lazygit` |
| **VS Code "Find in Files"** | `rg "pattern"` |
| **VS Code "Go to File"** | `fd fragment` or `fzf` |
| **Disk Utility "Get Info"** | `dust ~/` (visual), `ncdu ~/` (interactive), `duf` (per-disk) |
| **Network Utility / iStat for ping** | `gping host` |
| **Network Utility / iStat for bandwidth** | `sudo bandwhich` |
| **Quick Look on a README** | `glow README.md` |
| **Quick Look on a code file** | `bat path/to/file.py` |
| **`open` to view a Markdown file in a browser** | `glow file.md` |
| **Opening MDN for "how do I curl…"** | `tldr curl` |
| **Opening browser for a man page** | `tldr <tool>` |
| **Pasting from clipboard manager** | `Cmd+V` in terminal, or `pbpaste \| <command>` for stdin |
| **Copying terminal output to send a colleague** | select with mouse (copy is automatic — `copy_on_select clipboard`) |
| **Editing a config file in Finder** | `$EDITOR ~/.config/foo/bar.toml` from the terminal |
| **Restarting a daemon by clicking icons** | `brew services restart foo` |

---

## Quick reference card

### Kitty (terminal)

```
Cmd+T              new tab
Cmd+W              close tab (kills all splits!)
Cmd+1..9           switch to tab N
Cmd+Shift+T        rename current tab
Cmd+Option+←/→     move tab left/right
Cmd+D              split right
Cmd+Shift+D        split down
Cmd+←/→/↑/↓        focus next split
Cmd+Shift+←/→/↑/↓  resize active split
Cmd+Shift+W        close active split
Cmd+Shift+Enter    zoom split to fullscreen / unzoom
Cmd+Shift+J/K      jump to next/prev shell prompt
Cmd+Shift+F        open scrollback in less
Cmd+F              search scrollback (less overlay)
Cmd+= / - / 0      font size up / down / reset
Cmd+,              edit Kitty config
Cmd+Shift+R        reload Kitty config
Cmd+Shift+P        hint mode — pick URL/path from screen
Cmd+Shift+B        broadcast input to all panes in tab
Cmd+Shift+Y        spawn Yazi in vertical split
```

### Shell (zsh + plugins)

```
↑ / ↓              walk history matching what you've typed
Ctrl+R             fzf history search
Ctrl+T             fzf file picker (pastes path into command)
Alt+C              fzf directory `cd`
→                  accept grey ghost-text suggestion (autosuggestions)
Ctrl+→             accept one word of ghost-text
Tab                completion (zsh built-in)
Ctrl+W             delete previous word
Ctrl+U             delete to start of line
Ctrl+K             delete to end of line
Ctrl+A / Ctrl+E    jump to start / end of line
```

### Commands you'll type 100x/week

```
z fragment         jump to frequent dir
ls / ll / la / lt  modern ls (lt = tree)
cat file           pretty cat (= bat)
bat file           full bat with pager
rg "pattern"       fast recursive grep
fd "fragment"      find files by name
git diff           pretty diff (delta)
git log -p         pretty log with diffs
lazygit            git TUI
yazi               file manager TUI
btm                system monitor
tldr <tool>        concise examples
glow file.md       render markdown
theme <name>       swap palette across whole stack
exec zsh           reload current shell (apply theme styles)
```

---

## A 14-day plan (suggestion)

| Day | Focus |
|---|---|
| 1–2 | Level 0 + Level 1 — Kitty splits + `z` |
| 3 | Level 2 — `ll` + `yazi` |
| 4 | Level 3 — `bat`, `glow` |
| 5 | Level 4 — `rg`, `fd` |
| 6 | Level 5 — `btm`, `dust`, `procs` |
| 7 | Rest. Re-read the "When you'd open" table. |
| 8–9 | Level 6 — `lazygit` (this one takes practice) |
| 10 | Level 7 — `sd` + combos with `rg`/`fd` |
| 11 | Level 8 — direnv + theme switching |
| 12 | Level 9 — `tldr` becomes default |
| 13 | Re-read the whole doc end-to-end |
| 14 | Walk through the "When you'd open" table once. Move on. |

After 14 days the muscle memory is real. You'll stop reaching for the
mouse most of the time. The remaining 10% — image viewing, video, Figma,
Spotify — stays GUI. That's fine.
