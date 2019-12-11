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
    -- messenger:Message(msg)
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
    messenger:Message("Updated Plugins")
  end

  -- close readable file
  rfile:close()
  return true
end

-- the three config binding functions below can be combined
-- and deduped to shorten / simplify this process
function microbindings()
  bindingspath = configDir .. "/bindings.json"

  messenger:Message("opening " .. bindingspath)
  bindingsfile = NewBufferFromFile(bindingspath)
  HandleCommand("hsplit " .. bindingspath)
  return true
end

function microinit()
  initpath = configDir .. "/init.lua"

  messenger:Message("opening " .. initpath)
  initfile = NewBufferFromFile(initpath)
  HandleCommand("hsplit " .. initpath)
  return true
end

function microsettings()
  settingspath = configDir .. "/settings.json"

  messenger:Message("opening " .. settingspath)
  settingsfile = NewBufferFromFile(settingspath)
  HandleCommand("hsplit " .. settingspath)
  return true
end

-- the above commands should mabe be included in the function below
function setConfigBindings()
  -- add commands to open various micro config files
  MakeCommand("bindings", "init.microbindings", 0)
  MakeCommand("settings", "init.microsettings", 0)
  MakeCommand("init", "init.microinit", 0)
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

  messenger:Message(msg)
end

--[[
  Main command runner uses onView() trigger to load custom
  stuff to be usable in the current buffer
--]]

function onViewOpen(view)
  messenger:Message("Editing " .. view.Buf.path)

  -- set bindings to easily open micro config files
  setConfigBindings()

  -- use 'savecursor' to turn this option off in the current buffer
  -- MakeCommand("savecursor", "init.optionToggleSaveCursor")

  -- update plugins
  updatePlugins()

  -- switch theme depending on computer
  HandleCommand("switchtheme")

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

  -- dont show the save message
  messenger:Message(" ")
  BindKey("Esc", "CursorLeft")

  function onCursorStart(view)
    BindKey("Esc", "command:term")
    return false
  end
  return true
end


function onUndo(view)
  view:Save(true)

  -- dont show the save message
  messenger:Message(" ")

  return false
end


-- add command that uses onSave() to make a commit (if in a git dir)
-- every time the file is saved. This may not be the best idea performance
-- wise, but it may be useful for work stuff