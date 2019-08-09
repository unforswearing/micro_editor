--[[
local t = import("time")

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local d = t.Now()
d = tostring(d)

rd = string.match(d, '%d%d ')
rd = trim(rd)

function run()
  messenger:Message(rd)
end
--]]

function switchTheme()
  local goos = import("os")

  user = goos.Hostname()
  if (user == 'unforswearing.local') then
    local homescheme = 'ryuuko'
    SetOption("colorscheme", homescheme)

    if not GetOption("colorscheme") == homescheme then
      messenger:Message('Theme switched to "' .. homescheme .. '"')
    end
  end
end

MakeCommand("switchtheme", "switchtheme.switchTheme", 0)
BindKey("Altw", "switchtheme.switchTheme")

