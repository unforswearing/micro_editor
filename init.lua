local micro  = import("micro")
local buffer = import("micro/buffer")
local config = import("micro/config")
local shell = import("micro/shell")

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

-- preview markdown with frogmouth
-- https://github.com/Textualize/frogmouth
-- code below was originally written to use `glow`
-- https://github.com/charmbracelet/glow
-- but the preview did not work correctly with the interactive shell.
-- from https://github.com/micro-editor/micro/issues/2994#issuecomment-4679853093
function previewMarkdown()
    config.MakeCommand("fm", function(bp)
        bp:Save()
        shell.RunInteractiveShell(
          'frogmouth "' .. bp.Buf.Path .. '"',
          false,
          false
        )
    end, config.NoComplete)
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
  previewMarkdown()
  -- -- -- -- -- -- -- --

  config.MakeCommand("settings", settingsFile, config.NoComplete)
  config.MakeCommand("bindings", bindingsFile, config.NoComplete)
  config.MakeCommand("initfile", initFile, config.NoComplete)

  return true
end
