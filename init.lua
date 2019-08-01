function shellcheck()
    local buf = CurView().Buf -- The current buffer
    if buf:FileType() == "shell" then
      -- the first true means don't run it in the background
      HandleShellCommand("shellcheck --color=always -f gcc " .. buf.Path, true, true)
    end
end

-- BindKey("F5", "init.shellcheck")
MakeCommand("shellcheck", "init.shellcheck", 0)


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

    -- display status
    messenger:Message("File unlocked")
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

BindKey("Altr", "init.readonlyBuffer")
MakeCommand("readonly", "init.readonlyBuffer", 0)

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
  if CurView().Type.Readonly then doNothing() end
  updatePlugins()
  return true
end


































