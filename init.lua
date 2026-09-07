local micro  = import("micro")
local buffer = import("micro/buffer")
local config = import("micro/config")

local configDir = config.ConfigDir

-- micro.CurPane():HandleCommand(CMD)
-- micro.InfoBar():Message(MSG)
-- config.MakeCommand("CMD_NAME", CMDFUNC, config.NoComplete)

-- 9/6/2026:
-- The micro plugin syntax must have changed between versions, and most
-- of the previous init.lua code no longer seems to work (see init.lua.bkp)
-- I will enventually try to recreate the init.lua file once I figure out
-- the new syntax, for now this is a minimal init file.

function onViewOpen(bp)
  return true
end

function onUndo(bp)
  bp:Save()
  return false
end

function init()
  -- open settings.json inside micro using the "settings" command
  function settingsFile()
    buf = buffer.NewBufferFromFile(configDir .. "/settings.json")
    micro.CurPane():HSplitIndex(buf, true)
  end
  -- -- -- -- -- -- -- --

  -- open settings.json inside micro using the "settings" command
  function bindingsFile()
    buf = buffer.NewBufferFromFile(configDir .. "/bindings.json")
    micro.CurPane():HSplitIndex(buf, true)
  end
  -- -- -- -- -- -- -- --

  -- open settings.json inside micro using the "settings" command
  function initFile()
    buf = buffer.NewBufferFromFile(configDir .. "/init.lua")
    micro.CurPane():HSplitIndex(buf, true)
  end
  -- -- -- -- -- -- -- --

  config.MakeCommand("settings", settingsFile, config.NoComplete)
  config.MakeCommand("bindings", bindingsFile, config.NoComplete)
  config.MakeCommand("initfile", initFile, config.NoComplete)

  return true
end
