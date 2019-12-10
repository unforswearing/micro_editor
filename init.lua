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

function deleteToEnd()
  HandleCommand("SelectToEndOfLine")
end

--[[
  Main command runner uses onView() trigger to load custom
  stuff to be usable in the current buffer
--]]

function onViewOpen(view)
  messenger:Message("Editing " .. view.Buf.path)

  -- set bindings to easily open micro config files
  setConfigBindings()

  -- update plugins
  updatePlugins()

  -- switch theme depending on computer
  HandleCommand("switchtheme")

  -- return focus to cursor
  return true
end