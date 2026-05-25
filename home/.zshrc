# ─── PATH + environment ────────────────────────────────────
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Java (OpenJDK via Homebrew, if installed)
if [ -d "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home" ]; then
  export JAVA_HOME="/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# bun + local bin
export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"

# ─── Aliases ───────────────────────────────────────────────
alias tf="terraform"

# ─── Secrets (kept out of git via ~/.zshenv.local) ─────────
# Copy ~/.zshenv.local.example to ~/.zshenv.local and fill in your tokens.
[ -f "$HOME/.zshenv.local" ] && source "$HOME/.zshenv.local"

# ─── PAI shell functions (optional — only if PAI is installed) ─
if [ -d "$HOME/.claude/PAI" ]; then
  opencode() {
    if [ -x "$HOME/.local/bin/opencode" ]; then
      "$HOME/.local/bin/opencode" "$@"
    elif [ -x "$HOME/.opencode/tools/opencode" ]; then
      "$HOME/.opencode/tools/opencode" "$@"
    else
      command opencode "$@"
    fi
  }

  pai() {
    if [ -x "$HOME/.bun/bin/bun" ]; then
      "$HOME/.bun/bin/bun" run "$HOME/.claude/PAI/Tools/pai.ts" "$@"
    else
      bun run "$HOME/.claude/PAI/Tools/pai.ts" "$@"
    fi
  }
fi

# ─── Shell upgrades ────────────────────────────────────────

# Theme switcher — MUST be sourced before plugins so they pick up palette vars
source "$HOME/.config/theme/theme.zsh"
[ -f "$HOME/.config/theme/active.zsh" ] && source "$HOME/.config/theme/active.zsh"

# Starship — cross-shell prompt
eval "$(starship init zsh)"

# zsh-autosuggestions — grey ghost-text completion from history
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zoxide — smart `cd` via frecency. `z foo` jumps to most-used dir matching foo.
eval "$(zoxide init zsh)"

# fzf — fuzzy finder. Adds Ctrl+R (history), Ctrl+T (files), Alt+C (dirs)
source <(fzf --zsh)

# bat alias (BAT_THEME managed by `theme` switcher)
alias cat='bat --paging=never'

# direnv — auto-loads .envrc per directory. Each new .envrc needs `direnv allow`.
eval "$(direnv hook zsh)"

# eza — modern ls with git status + Nerd Font icons
alias ls='eza --git --icons=auto'
alias ll='eza -lh --git --icons=auto'
alias la='eza -lah --git --icons=auto'
alias lt='eza --tree --level=2 --git-ignore --icons=auto'

# zsh-syntax-highlighting — live green/red command coloring as you type
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-history-substring-search — type a fragment, ↑/↓ to walk matching history
# MUST come AFTER zsh-syntax-highlighting
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
