# shell-setup

A reproducible macOS shell stack. One command on a fresh machine, you get
**Kitty + Catppuccin Latte theme + 20+ modern CLI tools + Lilex Nerd Font +
zsh plugins + a unified theme switcher**.

This is what `~/.zshrc` should look like in 2026 — written once, version-
controlled, transplantable to any new Mac.

## What's in the box

| Layer | Tools |
|---|---|
| **Terminal** | Kitty (Lilex Nerd Font Mono, 50k scrollback, splits, Russian-keymap mirrors) |
| **Prompt** | Starship (with `[time]`, `[jobs]`, `[cmd_duration]` overrides + Catppuccin tuning) |
| **Visual feedback** | zsh-syntax-highlighting (green-on-valid, red-on-invalid), zsh-autosuggestions (grey ghost-text), zsh-history-substring-search (↑/↓ fragment match) |
| **Navigation** | zoxide (`z foo`), fzf (Ctrl+R / Ctrl+T / Alt+C) |
| **Files** | bat (pretty cat), eza (pretty ls + icons), fd (sane find), ripgrep (fast grep), sd (sane sed) |
| **Git** | lazygit (TUI), delta (pretty diff with line numbers + zdiff3 merges) |
| **System** | bottom (`btm`), dust (visual du), duf (pretty df), ncdu (interactive du), procs (modern ps), bandwhich (live bandwidth) |
| **Reference** | tealdeer (`tldr`), glow (markdown), gping (graphical ping) |
| **Per-project env** | direnv (auto-loads `.envrc`) |
| **Theme switching** | Custom `theme <name>` function — swaps the entire stack at once across 4 baked-in themes (Mocha, Latte, OneHalfLight, Nord Light) |
| **Session persistence** | `kitty-session-snapshot` writes a Kitty session file every 30s via launchd. On reboot, Kitty replays the file — every Claude Code tab `--resume`s its last session in the same cwd. Plain shell tabs come back in their cwd. Scrollback snapshotted to `~/.config/chats/scrollback/`. |
| **Cyrillic-friendly Cmd shortcuts** | Hammerspoon (`~/.hammerspoon/init.lua`) rewrites Cmd+Cyrillic → Cmd+Latin system-wide. No kext / no system extension — DH-managed-Mac safe. Replaces the per-app Russian-mirror hacks. |

## Install on a fresh Mac

```bash
cd ~
git clone https://github.com/aleksandr-bogdanov/shell-setup.git
cd shell-setup
bash install.sh
```

The installer:
1. Installs Homebrew (if missing)
2. `brew bundle` — installs all CLI tools + casks (Kitty, fonts)
3. Symlinks `home/.zshrc` and `config/*` into `~/` and `~/.config/`
4. Sets Catppuccin Latte as the default theme
5. Configures git delta as the diff viewer
6. Pulls tldr cheatsheet cache

Reboot Kitty (or open a fresh window) and you're done.

## Secrets

This repo never contains API tokens. The shell sources `~/.zshenv.local`
(gitignored) if it exists. After install, edit it:

```bash
cp home/.zshenv.local.example ~/.zshenv.local
$EDITOR ~/.zshenv.local
```

## Theme switching

```
theme list                  # see options
theme cat                   # Catppuccin Latte (default)
theme nord                  # Nord Light
theme one                   # OneHalfLight
theme mocha                 # (would need re-add — currently this stack ships 3 light + Mocha file)
themepick                   # fzf-driven picker
```

Each `theme <name>` call updates Kitty colors (hot-swap + reload), bat,
LS_COLORS via vivid, fzf, delta, bottom, tealdeer, lazygit, zsh syntax
highlighting, autosuggestions — all in one shot.

## Adopt the workflow

Read [docs/LEARN-TO-SH.md](docs/LEARN-TO-SH.md) — a progressive daily-
training guide that teaches you the muscle memory for everything installed
above. Designed to be re-read every day until the keystrokes are
automatic.

## Layout

```
shell-setup/
├── README.md
├── INSTALL.md              # for AI agents bootstrapping a fresh machine
├── install.sh              # the installer
├── Brewfile                # `brew bundle` package list
├── docs/
│   └── LEARN-TO-SH.md      # daily-training howto
├── home/
│   ├── .zshrc              # the canonical shell config
│   └── .zshenv.local.example
├── config/
│   ├── kitty/
│   │   ├── kitty.conf
│   │   └── themes/         # mocha, latte, nord-light, onehalflight
│   ├── starship.toml
│   └── theme/
│       └── theme.zsh       # the `theme` switcher function
├── hammerspoon/
│   └── init.lua            # Cyrillic-Cmd remap (system-wide)
├── bin/
│   └── kitty-session-snapshot   # auto-restore script
└── LaunchAgents/
    └── wtf.alex.kitty-snapshot.plist   # 30s snapshot agent
```

## Status

Personal config. Use as a base; fork and tune. The theme switcher
function is the centerpiece — extend it to add more palettes.

## Credits

Standing on the shoulders of:
- [sharkdp/bat](https://github.com/sharkdp/bat), [eza-community/eza](https://github.com/eza-community/eza),
  [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep), [sharkdp/fd](https://github.com/sharkdp/fd)
- [starship/starship](https://github.com/starship/starship), [kovidgoyal/kitty](https://github.com/kovidgoyal/kitty)
- [catppuccin](https://github.com/catppuccin), [nord-theme](https://github.com/nordtheme),
  [sonph/onehalf](https://github.com/sonph/onehalf)
- [junegunn/fzf](https://github.com/junegunn/fzf), [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide)
- [dandavison/delta](https://github.com/dandavison/delta), [jesseduffield/lazygit](https://github.com/jesseduffield/lazygit)
