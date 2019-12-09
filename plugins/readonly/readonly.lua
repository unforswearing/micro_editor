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
    BindKey("Altr", "readonly.readonlyBuffer")
    MakeCommand("readonly", "readonly.readonlyBuffer", 0)

    -- display status
    messenger:Message("Normal Buffer - File unlocked")
    do return end
  end

  -- block commands that reload runtime files and any editing commands
  -- that could break the readonly status of the buffer
  local commands = {
    "term", "reload", "open", "replace",
    "replaceAll", "eval", "run", "set",
    "setlocal", "bind", "plugin"
  }

  for _, comm in ipairs(commands) do
    MakeCommand(comm, "readonly.doNothing", 0)
  end

  -- if the buffer is not readonly, make it readonly
  CurView().Type.Readonly = true
  messenger:Error("READONLY - file is locked for editing")
end

-- Alt+r works in iTerm on MacOs if Option is set to Esc+ in the 'Keys' menu
BindKey("Altr", "readonly.readonlyBuffer")
MakeCommand("readonly", "readonly.readonlyBuffer", 0)
