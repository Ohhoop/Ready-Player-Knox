require"SpiffBoy/UI/JackGrip"

SpiffBoyLinkGrip=SpiffBoyJackGrip:derive("SpiffBoyLinkGrip")

function SpiffBoyLinkGrip:onRightMouseUp(x,y)
if not isGamePaused()then
self.window:openLinkMenu()
end
return true
end
