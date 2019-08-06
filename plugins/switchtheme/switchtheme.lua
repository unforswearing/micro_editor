local t = import("time")
local d = t.Now()

messenger:Message(type(d))
-- for k,v in pairs(d) do print(k,v) end

--[[
function switchTheme()
  local goos = import("os")
  messenger:Message(goos.Hostname())

  if (user == 'unforswearing.local') then
    SetOption("colorscheme", 'ryuuko')
  end
end
--]]

-- shellcheck is going to be a plugin
-- require "shellcheck"

-- this is here for no real reason
-- BindKey("F5", "init.shellcheck")
-- MakeCommand("shellcheck", "init.shellcheck", 0)

