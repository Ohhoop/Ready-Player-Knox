require"SpiffBoy/UI/JackGrip"

SpiffBoyLinkGrip=SpiffBoyJackGrip:derive("SpiffBoyLinkGrip")

function SpiffBoyLinkGrip:onRightMouseUp(a,b)
if not isGamePaused()then
self.window:openLinkMenu()
end
return true
end
