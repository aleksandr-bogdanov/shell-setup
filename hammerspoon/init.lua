-- ─────────────────────────────────────────────────────────────────
-- Hammerspoon — Russian-layout-friendly Cmd shortcuts (v2)
-- ─────────────────────────────────────────────────────────────────
-- v1 used event:setUnicodeString() alone — that changes what the focused
-- app sees as the character, but doesn't update the *keycode*. macOS
-- shortcut matching usually goes by keycode, so Cmd+С (cyrillic) was
-- being interpreted as "type the letter c" rather than "trigger Cmd+C
-- paste/copy" handler. v2 rewrites both the keycode AND the unicode
-- string so layout-aware apps (Kitty, VoiceInk, etc.) see the event as
-- if the US-QWERTY equivalent key had been pressed.
--
-- Requires Accessibility permission. No kext / no system extension.

-- Cyrillic char → US-QWERTY equivalent char (same physical key position)
local cyrillicToLatin = {
  ["й"]="q", ["ц"]="w", ["у"]="e", ["к"]="r", ["е"]="t", ["н"]="y",
  ["г"]="u", ["ш"]="i", ["щ"]="o", ["з"]="p", ["х"]="[", ["ъ"]="]",
  ["ф"]="a", ["ы"]="s", ["в"]="d", ["а"]="f", ["п"]="g", ["р"]="h",
  ["о"]="j", ["л"]="k", ["д"]="l", ["ж"]=";", ["э"]="'",
  ["я"]="z", ["ч"]="x", ["с"]="c", ["м"]="v", ["и"]="b", ["т"]="n",
  ["ь"]="m", ["б"]=",", ["ю"]=".",
  ["ё"]="`",
  -- Uppercase Cyrillic (same physical keys with shift)
  ["Й"]="q", ["Ц"]="w", ["У"]="e", ["К"]="r", ["Е"]="t", ["Н"]="y",
  ["Г"]="u", ["Ш"]="i", ["Щ"]="o", ["З"]="p", ["Х"]="[", ["Ъ"]="]",
  ["Ф"]="a", ["Ы"]="s", ["В"]="d", ["А"]="f", ["П"]="g", ["Р"]="h",
  ["О"]="j", ["Л"]="k", ["Д"]="l", ["Ж"]=";", ["Э"]="'",
  ["Я"]="z", ["Ч"]="x", ["С"]="c", ["М"]="v", ["И"]="b", ["Т"]="n",
  ["Ь"]="m", ["Б"]=",", ["Ю"]=".",
  ["Ё"]="`",
}

-- US-QWERTY physical keycodes (Apple HIToolbox kVK_ANSI_*)
local latinToKeyCode = {
  a=0,  s=1,  d=2,  f=3,  h=4,  g=5,  z=6,  x=7,  c=8,  v=9,  b=11,
  q=12, w=13, e=14, r=15, y=16, t=17,
  o=31, u=32, i=34, p=35, l=37, j=38, k=40, n=45, m=46,
  [";"]=41, ["'"]=39, [","]=43, ["."]=47, ["/"]=44, ["`"]=50,
  ["["]=33, ["]"]=30, ["-"]=27, ["="]=24,
}

local KEYCODE_PROP = hs.eventtap.event.properties.keyboardEventKeycode

local function rewriteIfCmdCyrillic(event)
  local flags = event:getFlags()
  -- Trigger only when Cmd is held (Cmd alone, Cmd+Shift, Cmd+Alt, etc.)
  if not flags.cmd then return false end

  local chars = event:getCharacters(true)
  if not chars or chars == "" then return false end

  local replacement = cyrillicToLatin[chars]
  if not replacement then return false end

  local keycode = latinToKeyCode[replacement]
  if not keycode then return false end

  -- Rewrite the keycode (this is the part that makes shortcut matching work)
  event:setProperty(KEYCODE_PROP, keycode)
  -- Also rewrite the unicode string so apps that DO look at characters
  -- see the right thing (and for the unlikely case the event leaks
  -- through as text input).
  event:setUnicodeString(replacement)

  return false  -- let the modified event propagate
end

local tap = hs.eventtap.new(
  { hs.eventtap.event.types.keyDown },
  rewriteIfCmdCyrillic
)
tap:start()

hs.alert.show("Hammerspoon: Cmd-shortcut fix v2 active (keycode + unicode rewrite)", 2)

-- ─── Reload config automatically when init.lua changes ─────────
local configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", function(files)
  for _, file in ipairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end)
configWatcher:start()
