require"SpiffBoy/UI/JackGrip"

SpiffBoyCartridgeGrip=SpiffBoyJackGrip:derive("SpiffBoyCartridgeGrip")

function SpiffBoyCartridgeGrip:onRightMouseUp(a,b)
if not isGamePaused()then
self.window:openCartridgeMenu()
end
return true
end
