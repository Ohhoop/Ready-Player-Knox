require"SpiffBoy/UI/JackGrip"

SpiffBoyCartridgeGrip=SpiffBoyJackGrip:derive("SpiffBoyCartridgeGrip")

function SpiffBoyCartridgeGrip:onRightMouseUp(x,y)
if not isGamePaused()then
self.window:openCartridgeMenu()
end
return true
end
