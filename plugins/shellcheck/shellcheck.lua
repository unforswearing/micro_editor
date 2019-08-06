-- a shellcheck plugin for micro editor

shellcheck = {}

function shellcheck.exec()
json = require "lunajson"

--[[
  TODO: build the shellcheck command, minus testfile
  testfile will be:
    DONE > buffer = CurView().Buf
  and make 'file' (instead of testfile):
    DONE > file = io.tmpfile()
    DONE > file = file:write(io.popen(shellcheck))
  and then decode json
    DONE > report = json.decode(file)
    DONE > -- report[1].line produces '15'
  finally, loop through report and start at item 0 below
--]]


-- local testfile = homedir .. "/Documents/Shared/Dotfiles/.bash_function/goto.bak"
local buffer = CurView().Buf
local testfile = buffer.Path

if not testfile then
  -- for testing, remove this when in use
  local homedir = os.getenv("HOME")
  local testfile = homedir .. "/Documents/Shared/Dotfiles/.bash_function/goto.bak"
end

local shellcheck = "shellcheck -f json " .. testfile

-- file = io.popen(shellcheck)
-- file = file:read "*a"
file = io.tmpfile()
file = file:write(io.popen(shellcheck))

for index, subtable in pairs(file) do
  print(index)
end
-- 0) set current buffer to "scratch" w/ warning msg
--    CurView().Type.Scratch = true
-- 1) loop through 'file' to get error txt and line number and column number
-- 2) goto line number and highlight error column(s)
-- 3) when cursor is under highlight, show shellcheck error message in gutter
--    - the message will appear when the cursor is under any highlighted character
-- 4) clear shellcheck when leaving scratch (must leave scratch to save)
--    - MakeCommand("shellcheck", ...)
--    - MakeCommand("exitshellcheck", ...)

print(json.decode(file)[1].line)

file:close()
end

return shellcheck.exec

