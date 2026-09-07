local micro  = import("micro")
local buffer = import("micro/buffer")
local config = import("micro/config")

local configDir = config.ConfigDir

-- 9/6/2026:
-- The micro plugin syntax must have changed between versions, and most
-- of the previous init.lua code no longer seems to work (see init.lua.bkp)
-- I will enventually try to recreate the init.lua file once I figure out
-- the new syntax, for now this is a minimal init file.

function onViewOpen(view)
  micro.InfoBar():Message("Editing " .. view.Buf.path)
  return true
end

function onUndo(view)
  view:Save()

  return false
end

function init()
  return true
end
