local t = import("time")

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local d = t.Now()
d = tostring(d)

rd = string.match(d, '%d%d ')
rd = trim(rd)

--[[
function run()
  messenger:Message(rd)
end
--]]

--[[ --]]
function switchTheme()
  local goos = import("os")

  user = goos.Hostname()
  if (user == 'unforswearing.local') then
    homescheme = 'ryuuko'
    SetOption("colorscheme", homescheme)

    messenger:Message('Theme switched to "' .. homescheme .. '"')
  end
end

MakeCommand("switchtheme", "switchtheme.switchTheme", 0)
BindKey("Altw", "switchtheme.switchTheme")

