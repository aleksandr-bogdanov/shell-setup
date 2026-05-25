# INSTALL — for an AI agent

This document is written for Claude Code (or any coding agent) tasked with
bootstrapping this shell setup on a fresh macOS machine.

## TL;DR

```bash
cd ~
git clone https://github.com/aleksandr-bogdanov/shell-setup.git
cd shell-setup
bash install.sh
```

That's the whole job. Everything else below is for when the installer fails
or the user wants you to verify state.

## Preconditions

- macOS (the installer hard-stops on non-Darwin)
- The user has admin rights for `sudo` (Homebrew needs it once)
- The user is online (brew downloads)

## What the installer does, step-by-step

1. **Homebrew** — installs if `brew` is not on PATH. Appends shellenv eval.
2. **`brew bundle`** — installs from `Brewfile`. Includes:
   - Cask: `kitty`, `font-lilex`, `font-lilex-nerd-font`
   - 20+ CLI tools (full list in Brewfile)
3. **Symlinks** — backs up any existing dotfile to `.bak-TIMESTAMP`, then
   symlinks from the repo into `~/` and `~/.config/`:
   - `~/.zshrc`
   - `~/.config/kitty/kitty.conf`
   - `~/.config/kitty/themes/` (whole dir)
   - `~/.config/starship.toml`
   - `~/.config/theme/theme.zsh`
4. **Active theme** — writes `~/.config/theme/active.zsh` with Catppuccin
   Latte defaults (env vars + zsh-syntax-highlighting palette).
5. **Git delta** — sets 7 global git config keys for delta as diff/pager.
6. **tldr** — pulls cheatsheet cache via `tldr --update`.
7. **Secrets** — copies `home/.zshenv.local.example` → `~/.zshenv.local`
   if it doesn't exist. User edits in their tokens.

## Verifying success

After `bash install.sh` finishes:

```bash
# Open a new Kitty window or `exec zsh` in current terminal, then:

theme list                      # should print 3 themes
which starship bat eza fd rg    # all should resolve
brew bundle check               # all formulas + casks installed
fc-list | grep -i 'lilex nerd'  # font installed
git config --get core.pager     # should print "delta"
```

If any of those fail, re-run `bash install.sh` (idempotent).

## Common pitfalls

### Kitty's existing config conflicts
The installer backs up old `~/.config/kitty/kitty.conf` to `.bak-<ts>`
before symlinking. If the user has unique tweaks (e.g., a PAI tab-color
hook), merge them manually from the backup into the repo's `kitty.conf`
or into a `kitty.conf.local` that the main config can `include`.

### Lilex Nerd Font doesn't render
Possible if Kitty was already running with an older font cached. Fully
quit Kitty (`Cmd+Q`) and reopen. Verify with `fc-list | grep -i lilex`.

### zsh plugins not coloring
The active theme's `ZSH_HIGHLIGHT_STYLES` are written to
`~/.config/theme/active.zsh`. If the user is in a pre-existing shell,
run `exec zsh` to re-source.

### Secrets file empty
`home/.zshenv.local.example` is the template. The installer copies it to
`~/.zshenv.local` only if that file doesn't exist. The user has to edit
it themselves; otherwise their old API-token shells will lose those env
vars after migration. Verify with `cat ~/.zshenv.local`.

### Symlink already exists pointing somewhere else
The installer detects this and `rm`s the old symlink before re-linking
to this repo. If the user had a previous dotfiles setup pointed at a
different path, that path will be detached — confirm with the user
before running on top of an existing dotfiles repo.

## Idempotency

The installer is safe to re-run. On every run:
- Existing real files (not symlinks) → backed up with timestamp suffix
- Existing symlinks → removed and re-pointed at the repo
- `brew bundle` → installs only what's missing
- Git config → overwrites (matches the repo's values)
- Active theme → overwrites (resets to Latte)

This is by design: re-running brings the machine back to a known state.

## Session-persistence subsystem

Added 2026-05-25. Reboot-survival pipeline:

- `bin/kitty-session-snapshot` parses `kitty @ ls --json`, finds the
  latest Claude Code session per cwd, and writes a Kitty session file at
  `~/.config/kitty/sessions/last.conf`.
- `LaunchAgents/wtf.alex.kitty-snapshot.plist` runs the snapshot every
  30s. Loaded with `launchctl bootstrap gui/$UID <plist>` (installer
  does this).
- `config/kitty/kitty.conf` has `startup_session
  ~/.config/kitty/sessions/last.conf` — Kitty replays the file at
  launch.
- On reboot: user opens Kitty (or it auto-launches via Login Items) →
  all tabs come back, each Claude Code chat resumes with full context
  via `claude --resume <id>`. The `pai` wrapper is detected and
  restored as `launch pai`.
- Plain shell tabs come back in their cwd, no command auto-run.
- Per-tab scrollback dumped to `~/.config/chats/scrollback/`.

To verify after install:
```bash
launchctl print "gui/$UID/wtf.alex.kitty-snapshot" | grep state
# state = active   (means the agent is loaded and scheduled)
ls /tmp/kitty-snapshot.log /tmp/kitty-snapshot.err
# both should exist after Kitty has been open for >30s
cat ~/.config/kitty/sessions/last.conf
# should show tabs as `new_tab ...` blocks
```

If `kitty @ ls` fails inside the script: the user's Kitty needs to be
launched with `listen_on unix:/tmp/kitty` (already in `kitty.conf`).
Verify with `ls -la /tmp/kitty` — should be a socket while Kitty runs.

If `kitty` binary isn't on PATH for the snapshot script: the installer
adds a symlink from `/Applications/kitty.app/Contents/MacOS/kitty` to
`/opt/homebrew/bin/kitty`. Re-run installer if missing.

## Hammerspoon (Cyrillic Cmd-shortcut fix)

Added 2026-05-25. Replaces per-app Russian-keymap mirrors with a
system-wide fix. No kext / no system extension — uses Accessibility API
only.

After install: user must open Hammerspoon once and grant Accessibility
permission via Settings → Privacy & Security → Accessibility. The
config (`hammerspoon/init.lua`) auto-watches itself for changes via
`pathwatcher` — edits reload without restart.

Verify: run `pgrep -x Hammerspoon` (should return a PID) and check the
menu-bar icon. With Russian layout active in Kitty, `Cmd+V` should
paste; without Hammerspoon, it would have done nothing.

## After install

Point the user to `docs/LEARN-TO-SH.md` for daily training exercises.
The setup is dead by itself — adoption requires building muscle memory.

## Customization the user is likely to ask for

- **Different default theme** — edit the `active.zsh` writeback in
  `install.sh` step 5 to use Nord Light or OneHalfLight, OR just have
  the user run `theme nord` once after install.
- **Add a new theme** — extend the `case` statement in
  `config/theme/theme.zsh`. Add the corresponding `themes/<name>.conf`
  to `config/kitty/themes/`.
- **Remove a tool** — comment out the relevant line in `Brewfile`, then
  remove any source/alias lines from `home/.zshrc`.
- **Edit the prompt** — `config/starship.toml`. Starship reads it on
  every prompt render; no reload needed.
- **Custom aliases** — append to `home/.zshrc` directly, OR create
  `~/.zshrc.local` and add `[ -f ~/.zshrc.local ] && source ~/.zshrc.local`
  to the bottom of `home/.zshrc` (recommended pattern for per-machine
  divergences).

## Removing this setup

```bash
# Restore backed-up dotfiles
for f in ~/.zshrc.bak-* ~/.config/kitty/kitty.conf.bak-*; do
  echo "Restore $f? (manual)"
done

# Uninstall tools (optional — they're benign to leave)
brew bundle cleanup --file=~/shell-setup/Brewfile --force
```

The repo itself just lives in `~/shell-setup/`. Delete the directory to
fully remove.
