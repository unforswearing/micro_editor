local micro  = import("micro")
local buffer = import("micro/buffer")
local config = import("micro/config")

local configDir = config.ConfigDir

-- automatically update plugins, checking once per day
function updatePlugins()
  -- todays date as a two character string prepended with "00"
  today = tostring(os.date("00%d"))

  -- path to file containing string of last update
  filepath = configDir .. "update_plugins.info"

  -- open a readable version of the file
  rfile = io.open(filepath, "r+")
  if not rfile then
    -- this should actually create the file if it doesn't exist
    msg = 'no file exists at ' .. filepath
    -- io.stderr:write(msg)
    --  micro.InfoBar():Message(msg)
    return false
  end

  lastupdate = assert(rfile:read "*a")

  -- if the file doesn't exist or the last update was before today
  if not lastupdate or lastupdate ~= today then
    HandleCommand("plugin update")

    -- open writable file, set updated date string, close file
    wfile = io.open(filepath, "w+")
    wfile:write(today)
    wfile:close()

    -- tell me that plugins were updated
     micro.InfoBar():Message("Updated Plugins")
  end

  -- close readable file
  rfile:close()
  return true
end

-- the three config binding functions below can be combined
-- and deduped to shorten / simplify this process
function microbindings(bp)
  bindingspath = configDir .. "/bindings.json"

  micro.InfoBar():Message("opening " .. bindingspath)
  bindingsfile = buffer.NewBufferFromFile(bindingspath)
  bp:OpenBuffer(bindingsfile)
  -- micro.HandleCommand("hsplit " .. bindingspath)
  -- micro.hsplit(bindingspath)
  return true
end

function microinit()
  initpath = configDir .. "/init.lua"

  micro.InfoBar():Message("opening " .. initpath)
  initfile = buffer.NewBufferFromFile(initpath)
  config.HandleCommand("hsplit " .. initpath)
  return true
end

function microsettings()
  settingspath = configDir .. "/settings.json"

  micro.InfoBar():Message("opening " .. settingspath)
  settingsfile = buffer.NewBufferFromFile(settingspath)
  HandleCommand("hsplit " .. settingspath)
  return true
end

-- the above commands should mabe be included in the function below
function setConfigBindings()
  -- add commands to open various micro config files
  config.MakeCommand("bindings", microbindings, config.NoComplete)
  config.MakeCommand("settings", microsettings, config.NoComplete)
  config.MakeCommand("init", microinit, config.NoComplete)
end

-- savecursor is true in settings.json, but it might get annoying
-- use ctrl-r 'savecursor' to toggle it off
function optionToggleSaveCursor()
  -- SetOption(option, value string)
  cursoropt = GetOption("savecursor")

  if cursoropt then
    SetOption("savecursor", "false")
    msg = "Option 'savecursor' is off"
  else
    msg = "Option 'savecursor' is on"
  end

   micro.InfoBar():Message(msg)
end

--[[
  Main command runner uses onView() trigger to load custom
  stuff to be usable in the current buffer
--]]

function onViewOpen(view)
   micro.InfoBar():Message("Editing " .. view.Buf.path)

  -- set bindings to easily open micro config files
  -- setConfigBindings(config)

  -- use 'savecursor' to turn this option off in the current buffer
  -- MakeCommand("savecursor", "init.optionToggleSaveCursor")

  -- update plugins
  -- updatePlugins()

  -- switch theme depending on computer
  -- HandleCommand("switchtheme")

  -- return focus to cursor
  return true
end


-- when all text is selected via alt-a:
-- 1) save the file in case something happens
-- 2) rebind the escape key to something that will move the cursor
--    (this breaks the selection)
-- 3) rebind the esc key to 'command:term'
-- TODO: return the cursor to the position before the select all.
--       not sure how to do this yet / need more research
function onSelectAll(view)
  view:Save(true)

  -- dont show the save messagef
   micro.InfoBar():Message(" ")
  BindKey("Esc", "CursorLeft")

  function onCursorStart(view)
    BindKey("Esc", "command:term")
    return false
  end
  return true
end


function onUndo(view)
  view:Save()

  return false
end


-- add command that uses onSave() to make a commit (if in a git dir)
-- every time the file is saved. This may not be the best idea performance
-- wise, but it may be useful for work stuff

function init()
  setConfigBindings()
end
