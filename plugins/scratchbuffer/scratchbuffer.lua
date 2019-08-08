
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

MakeCommand("scratch", "scratchbuffer.scratchBuffer", 0)
