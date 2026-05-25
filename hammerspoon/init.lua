-- ─────────────────────────────────────────────────────────────────
-- Hammerspoon config — Russian-layout-friendly Cmd shortcuts
-- ─────────────────────────────────────────────────────────────────
-- When the Cmd modifier is held, any Cyrillic character is silently
-- rewritten to its US-QWERTY equivalent in the same physical key
-- position. Result: Cmd+С (V key in Russian) is delivered to apps as
-- Cmd+V, fixing paste/copy/quit/etc. in any layout-aware app:
-- Kitty, VoiceInk, Slack, browsers — all of them.
--
-- No kext or system extension needed (DH-MacBook safe).
-- Requires: Accessibility permission (granted on first run).

local cyrillicToLatin = {
  -- lowercase row by row
  ["й"]="q", ["ц"]="w", ["у"]="e", ["к"]="r", ["е"]="t", ["н"]="y",
  ["г"]="u", ["ш"]="i", ["щ"]="o", ["з"]="p", ["х"]="[", ["ъ"]="]",
  ["ф"]="a", ["ы"]="s", ["в"]="d", ["а"]="f", ["п"]="g", ["р"]="h",
  ["о"]="j", ["л"]="k", ["д"]="l", ["ж"]=";", ["э"]="'",
  ["я"]="z", ["ч"]="x", ["с"]="c", ["м"]="v", ["и"]="b", ["т"]="n",
  ["ь"]="m", ["б"]=",", ["ю"]=".",
  -- uppercase
  ["Й"]="Q", ["Ц"]="W", ["У"]="E", ["К"]="R", ["Е"]="T", ["Н"]="Y",
  ["Г"]="U", ["Ш"]="I", ["Щ"]="O", ["З"]="P", ["Х"]="{", ["Ъ"]="}",
  ["Ф"]="A", ["Ы"]="S", ["В"]="D", ["А"]="F", ["П"]="G", ["Р"]="H",
  ["О"]="J", ["Л"]="K", ["Д"]="L", ["Ж"]=":", ["Э"]='"',
  ["Я"]="Z", ["Ч"]="X", ["С"]="C", ["М"]="V", ["И"]="B", ["Т"]="N",
  ["Ь"]="M", ["Б"]="<", ["Ю"]=">",
  -- ё / Ё on US backtick position
  ["ё"]="`", ["Ё"]="~",
}

local cmdLayoutFix = hs.eventtap.new(
  { hs.eventtap.event.types.keyDown },
  function(event)
    local flags = event:getFlags()
    -- Only rewrite when Cmd is held; leave normal Russian typing alone
    if not flags.cmd then
      return false
    end

    local chars = event:getCharacters(true)
    if not chars or chars == "" then
      return false
    end

    local replacement = cyrillicToLatin[chars]
    if not replacement then
      return false
    end

    -- Rewrite the unicode string in place. Don't consume the event —
    -- the system continues to dispatch it to the focused app, but with
    -- the Latin character so shortcut matching succeeds.
    event:setUnicodeString(replacement)
    return false
  end
)

cmdLayoutFix:start()

-- One-time notification on reload so we know Hammerspoon is live
hs.alert.show("Hammerspoon: Russian Cmd-shortcut fix active", 2)

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
