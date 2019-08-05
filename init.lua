-- shellcheck is going to be a plugin
require "shellcheck"

-- this is here for no real reason
function shellcheck()
    shellcheck.exec()
end

-- BindKey("F5", "init.shellcheck")
MakeCommand("shellcheck", "init.shellcheck", 0)

-- standin function for blocked readonlyBuffer commands
function doNothing()
  messenger:Error("READONLY - blocked command")
  do return end
end

-- this could turn into a "Visual" editing mode
-- where all editing commands work (find, replace, etc),
-- but no new text can be entered into the file
function readonlyBuffer()
  -- how to handle interactive shell, reload, other commands
  -- that reloads options / current file
  local isReadonly = CurView().Type.Readonly

  -- if view is already readonly, make not readonly
  if isReadonly then
    -- can't set the value via the isReadonly reference
    CurView().Type.Readonly = false

    -- reload to restore the blocked commands
    Reload()

    -- the binding and command seem to be lost
    -- when the Reload() command is called above
    BindKey("Altr", "init.readonlyBuffer")
    MakeCommand("readonly", "init.readonlyBuffer", 0)

    -- display status
    messenger:Message("Normal Buffer - File unlocked")
    do return end
  end

  -- block commands that reload runtime files and any editing commands
  -- that could break the readonly status of the buffer
  local commands = {
    "term", "reload", "open", "replace", "replaceAll", "eval", "run",
    "set", "setlocal", "bind", "plugin"
  }

  for _, comm in ipairs(commands) do
    MakeCommand(comm, "init.doNothing", 0)
  end

  -- if the buffer is not readonly, make it readonly
  CurView().Type.Readonly = true
  messenger:Error("READONLY - file is locked for editing")
end

-- Alt+r works in iTerm on MacOs if Option is set to Esc+ in the 'Keys' menu
BindKey("Altr", "init.readonlyBuffer")
MakeCommand("readonly", "init.readonlyBuffer", 0)

-- scratch buffer, maybe eventually like readonlyBuffer.
function scratchBuffer()
  if CurView().Type.Scratch then
    CurView().Type.Scratch = false
    messenger:Message("Normal Buffer")
    do return end
  end

  CurView().Type.Scratch = true
  messenger:Message("Scratch Buffer")
end

MakeCommand("scratch", "init.scratchBuffer", 0)

-- automatically update plugins, checking once per day
function updatePlugins()
  -- get home path to avoid hardcoding
  home = os.getenv("HOME")
  -- todays date as a two character string prepended with "00"
  today = tostring(os.date("00%d"))

  -- path to file containing string of last update
  filepath = home .. "/.config/micro/plugin_update.info"

  -- open a readable version of the file
  rfile = io.open(filepath, "r+")
  lastupdate = rfile:read "*a"

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
  if CurView().Type.Readonly then doNothing() end

  -- update plugins
  updatePlugins()

  -- return focus to cursor
  return true
end


































