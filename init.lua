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

  -- if view is already readonly, make not readonly
  if CurView().Type.Readonly then
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
    "term", "reload", "open", "replace", "replaceAll", "eval", "run"
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

function onOpenFile(view)
-- function onViewOpen(view)
  -- if CurView().Type.Readonly then
    -- CurView().Type.Readonly = false
  -- end
-- messenger:Message(arg)
end