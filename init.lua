local micro  = import("micro")
local buffer = import("micro/buffer")
local config = import("micro/config")
local os = import("os")
local shell = import("micro/shell")

local configDir = config.ConfigDir

-- micro.CurPane():HandleCommand(CMD)
-- micro.InfoBar():Message(MSG)
-- config.MakeCommand("CMD_NAME", CMDFUNC, config.NoComplete)
--
-- local bp = micro.CurPane()
-- bp:HandleCommand("vivifyMaybe")
--
-- if bp.Buf.Type.Kind == buffer.BTDefault then [...]

--[[
9/6/2026:

The micro plugin syntax must have changed between versions, and most
of the previous init.lua code no longer seems to work (see init.lua.bkp)
I will enventually try to recreate the init.lua file once I figure out
the new syntax, for now this is a minimal init file.
--]]

--[[

Ideas / Todo
  - function to back up current file (file.txt -> file.bkp.txt)
    - similar to: github.com/micro-editor/micro/discussions/2976#discussioncomment-7313861
  - function / command to autosave
--]]

-- this is unused
function onViewOpen(bp)
  return true
end

-- automatically save files on undo
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

function wordCount(bp)
  local util = import("micro/util")
  local utf8 = import("unicode/utf8")
	-- Buffer of selection/whole document
	local buffer
	--Get active cursor (to get selection)
	local cursor = bp.Buf:GetActiveCursor()
	--If cursor exists and there is selection, convert selection byte[] to string
	if cursor and cursor:HasSelection() then
		buffer = util.String(cursor:GetSelection())
	else
	--no selection, convert whole buffer byte[] to string
    	buffer = util.String(bp.Buf:Bytes())
    end
    --length of the buffer/selection (string), utf8 friendly
	charCount = utf8.RuneCountInString(buffer)
	--Get word/line count using gsub's number of substitutions
	-- number of substitutions, pattern: %S+ (more than one non-whitespace characters)
	local _ , wordCount = buffer:gsub("%S+","")
	-- number of substitutions, pattern: \n (number of newline characters)
	local _, lineCount = buffer:gsub("\n", "")
	--add one to line count (since we're counting separators not lines above)
	lineCount = lineCount + 1
	--display the message
	micro.InfoBar():Message("Lines:" .. lineCount .. "  Words:"..wordCount.."  Characters:"..charCount)
end

-- # init #############################################################

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

  -- Edit settings, bindings, and init.lua from within micro:
  config.MakeCommand("settings", settingsFile, config.NoComplete)
  config.MakeCommand("bindings", bindingsFile, config.NoComplete)
  config.MakeCommand("initfile", initFile, config.NoComplete)

  config.MakeCommand("wc", wordCount, config.NoComplete)

  return true
end
