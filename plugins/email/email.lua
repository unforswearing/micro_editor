function shellcheck()
    local buf = CurView().Buf -- The current buffer
    if buf:FileType() == "shell" then
        HandleShellCommand("shellcheck --color=always -f gcc " .. buf.Path, true, true) -- the first true means don't run it in the background
    end
end
