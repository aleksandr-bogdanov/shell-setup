# Theme switcher — fluently swap palettes across the whole shell stack
# Usage: theme <name>    e.g. `theme latte`, `theme nord-light`, `theme onehalflight`
#        theme           prints the list of available themes
#        themepick       fzf-driven picker

theme() {
  local t="$1"
  local THEME_DIR="$HOME/.config/theme"
  mkdir -p "$THEME_DIR"

  # ── Per-theme palette data ────────────────────────────
  local kitty_theme bat_theme vivid_theme delta_syntax fzf_colors
  local bottom_built_in autosuggest_fg
  # Palette vars used by syntax-highlighting + per-tool configs
  local p_text p_blue p_green p_red p_mauve p_peach p_yellow p_teal p_comment p_subtle

  case "$t" in
    nord-light|nord)
      kitty_theme="nord-light"
      bat_theme="ansi"
      vivid_theme="one-light"
      delta_syntax="ansi"
      bottom_built_in="nord-light"
      fzf_colors="bg+:#d8dee9,bg:#eceff4,spinner:#bf616a,hl:#bf616a,fg:#2e3440,header:#bf616a,info:#b48ead,pointer:#b48ead,marker:#a3be8c,fg+:#2e3440,prompt:#5e81ac,hl+:#bf616a,selected-bg:#d8dee9,border:#d8dee9,label:#2e3440"
      p_text="#2e3440"; p_blue="#5e81ac"; p_green="#a3be8c"; p_red="#bf616a"
      p_mauve="#b48ead"; p_peach="#d08770"; p_yellow="#ebcb8b"; p_teal="#88c0d0"
      p_comment="#4c566a"; p_subtle="#81a1c1"
      autosuggest_fg="#4c566a"
      ;;
    catppuccin-latte|latte|cat)
      kitty_theme="latte"
      bat_theme="Catppuccin Latte"
      vivid_theme="catppuccin-latte"
      delta_syntax="Catppuccin Latte"
      bottom_built_in=""
      fzf_colors="bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39,fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78,marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39,selected-bg:#bcc0cc,border:#ccd0da,label:#4c4f69"
      p_text="#4c4f69"; p_blue="#1e66f5"; p_green="#40a02b"; p_red="#d20f39"
      p_mauve="#8839ef"; p_peach="#fe640b"; p_yellow="#df8e1d"; p_teal="#179299"
      p_comment="#6c6f85"; p_subtle="#7287fd"
      autosuggest_fg="#9ca0b0"
      ;;
    onehalflight|ohl|one)
      kitty_theme="onehalflight"
      bat_theme="OneHalfLight"
      vivid_theme="one-light"
      delta_syntax="OneHalfLight"
      bottom_built_in=""
      fzf_colors="bg+:#e5e5e6,bg:#fafafa,spinner:#a626a4,hl:#e45649,fg:#383a42,header:#e45649,info:#a626a4,pointer:#a626a4,marker:#50a14f,fg+:#383a42,prompt:#a626a4,hl+:#e45649,selected-bg:#d8d8d8,border:#d8d8d8,label:#383a42"
      p_text="#383a42"; p_blue="#0184bc"; p_green="#50a14f"; p_red="#e45649"
      p_mauve="#a626a4"; p_peach="#c18401"; p_yellow="#c18401"; p_teal="#0997b3"
      p_comment="#a0a1a7"; p_subtle="#0997b3"
      autosuggest_fg="#a0a1a7"
      ;;
    ""|-h|--help|list)
      echo "Available themes:"
      echo "  nord-light       (aliases: nord)"
      echo "  catppuccin-latte (aliases: latte, cat)"
      echo "  onehalflight     (aliases: ohl, one)"
      echo ""
      echo "Usage: theme <name>     themepick   # fzf-driven picker"
      return 0
      ;;
    *)
      echo "Unknown theme: $t" >&2
      echo "Run 'theme list' to see available themes." >&2
      return 1
      ;;
  esac

  # ── 1. Kitty: hot-swap palette + reload config for non-palette items ─
  if [[ -S /tmp/kitty ]]; then
    kitty @ --to unix:/tmp/kitty set-colors -a -c "$HOME/.config/kitty/themes/${kitty_theme}.conf" 2>/dev/null
  fi
  if [[ -f "$HOME/.config/kitty/kitty.conf" ]]; then
    /usr/bin/sed -i '' "s|^include themes/.*\.conf|include themes/${kitty_theme}.conf|" "$HOME/.config/kitty/kitty.conf"
    # Reload full config for tab-bar / titlebar / bell colors
    [[ -S /tmp/kitty ]] && kitty @ --to unix:/tmp/kitty load-config 2>/dev/null
  fi

  # ── 2. Git delta ──────────────────────────────────
  git config --global delta.syntax-theme "$delta_syntax" 2>/dev/null

  # ── 3. Bottom ─────────────────────────────────────
  if [[ -n "$bottom_built_in" ]]; then
    cat > "$HOME/.config/bottom/bottom.toml" <<EOF
[flags]
theme = "${bottom_built_in}"
EOF
  else
    case "$kitty_theme" in
      latte)
        cat > "$HOME/.config/bottom/bottom.toml" <<'EOF'
[styles.cpu]
all_entry_color = "#dc8a78"
avg_entry_color = "#e64553"
cpu_core_colors = ["#d20f39","#fe640b","#df8e1d","#40a02b","#209fb5","#8839ef"]
[styles.memory]
ram_color = "#40a02b"
cache_color = "#d20f39"
swap_color = "#fe640b"
[styles.network]
rx_color = "#40a02b"
tx_color = "#d20f39"
[styles.tables]
headers = {color = "#dc8a78"}
[styles.graphs]
graph_color = "#6c6f85"
legend_text = {color = "#6c6f85"}
[styles.widgets]
border_color = "#acb0be"
selected_border_color = "#ea76cb"
widget_title = {color = "#dd7878"}
text = {color = "#4c4f69"}
selected_text = {color = "#dce0e8", bg_color = "#8839ef"}
disabled_text = {color = "#eff1f5"}
EOF
        ;;
      onehalflight)
        cat > "$HOME/.config/bottom/bottom.toml" <<'EOF'
[flags]
theme = "default-light"
[styles.cpu]
all_entry_color = "#a626a4"
avg_entry_color = "#e45649"
cpu_core_colors = ["#0184bc","#50a14f","#c18401","#a626a4","#e45649","#0997b3"]
[styles.memory]
ram_color   = "#0184bc"
cache_color = "#e45649"
swap_color  = "#c18401"
[styles.tables]
headers = { color = "#a626a4" }
[styles.widgets]
border_color          = "#d8d8d8"
selected_border_color = "#0184bc"
widget_title          = { color = "#0184bc" }
text                  = { color = "#383a42" }
selected_text         = { color = "#fafafa", bg_color = "#0184bc" }
disabled_text         = { color = "#a0a1a7" }
EOF
        ;;
    esac
  fi

  # ── 4. Tealdeer ───────────────────────────────────
  # tealdeer wants `foreground = { rgb = { r = N, g = N, b = N } }`
  _hex2rgb() { printf "{ rgb = { r = %d, g = %d, b = %d } }" $((16#${1:1:2})) $((16#${1:3:2})) $((16#${1:5:2})); }
  cat > "$HOME/.config/tealdeer/config.toml" <<EOF
[display]
compact = false
use_pager = false
[style.command_name]
foreground = $(_hex2rgb $p_blue)
bold = true
[style.example_text]
foreground = $(_hex2rgb $p_text)
[style.example_code]
foreground = $(_hex2rgb $p_mauve)
[style.example_variable]
foreground = $(_hex2rgb $p_red)
italic = true
[style.description]
foreground = $(_hex2rgb $p_comment)
EOF
  unfunction _hex2rgb

  # ── 5. Lazygit ────────────────────────────────────
  cat > "$HOME/.config/lazygit/config.yml" <<EOF
gui:
  theme:
    activeBorderColor:    ["${p_mauve}", bold]
    inactiveBorderColor:  ["${p_comment}"]
    optionsTextColor:     ["${p_blue}"]
    selectedLineBgColor:  ["${autosuggest_fg}"]
    selectedRangeBgColor: ["${autosuggest_fg}"]
    cherryPickedCommitBgColor: ["${autosuggest_fg}"]
    cherryPickedCommitFgColor: ["${p_mauve}"]
    unstagedChangesColor: ["${p_red}"]
    defaultFgColor:       ["${p_text}"]
  authorColors:
    "*": "${p_subtle}"
EOF

  # ── 6. zsh env vars + syntax-highlighting + autosuggest (persist for new shells) ──
  cat > "$THEME_DIR/active.zsh" <<EOF
# Auto-generated by 'theme' — current: ${kitty_theme}
export BAT_THEME="${bat_theme}"
export LS_COLORS="\$(vivid generate ${vivid_theme})"
export FZF_DEFAULT_OPTS="--color=${fzf_colors}"

# zsh-autosuggestions ghost-text color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=${autosuggest_fg}'

# zsh-syntax-highlighting palette
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=${p_text}'
ZSH_HIGHLIGHT_STYLES[command]='fg=${p_green}'
ZSH_HIGHLIGHT_STYLES[alias]='fg=${p_green}'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=${p_teal}'
ZSH_HIGHLIGHT_STYLES[function]='fg=${p_blue}'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=${p_peach},underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=${p_red},bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=${p_comment},italic'
ZSH_HIGHLIGHT_STYLES[path]='fg=${p_blue},underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=${p_peach}'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=${p_peach}'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=${p_yellow}'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=${p_subtle}'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=${p_mauve}'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=${p_red},bold'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=${p_teal},underline'
ZSH_HIGHLIGHT_STYLES[assign]='fg=${p_yellow}'
EOF

  # Apply env vars to current shell too
  source "$THEME_DIR/active.zsh"

  echo "✓ Theme: $kitty_theme (Kitty hot-swapped + reloaded; current shell env updated; new tabs inherit)"
  echo "  → For zsh-syntax-highlighting / autosuggestions colors to take effect, run: exec zsh"
}

# fzf-driven picker
themepick() {
  if ! command -v fzf >/dev/null; then
    echo "fzf not installed" >&2
    return 1
  fi
  local choice
  choice=$(printf "nord-light\ncatppuccin-latte\nonehalflight\n" | fzf --prompt="Theme: " --height=10 --border)
  [[ -n "$choice" ]] && theme "$choice"
}
