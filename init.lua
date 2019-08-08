-- automatically update plugins, checking once per day
function updatePlugins()
  -- get home path to avoid hardcoding
  home = os.getenv("HOME")

  -- todays date as a two character string prepended with "00"
  today = tostring(os.date("00%d"))

  -- path to file containing string of last update
  filepath = home .. "/.config/micro/update_plugins.info"

  -- open a readable version of the file
  rfile = io.open(filepath, "r+")

  if not rfile then
    -- this should actually create the file if it doesn't exist
    msg = 'no file exists at ' .. filepath
    io.stderr:write(msg)
    messenger:Message(msg)
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

function onViewOpen(view)
  -- if (somehow) the readonlyBuffer = false when when micro re/starts
  -- show the 'READONLY' warning in the gutter. this shouldn't ever trigger
  -- if CurView().Type.Readonly then doNothing() end

  -- update plugins
  updatePlugins()

  -- switch theme depending on computer
  HandleCommand("switchtheme")

  -- return focus to cursor
  return true
end


































