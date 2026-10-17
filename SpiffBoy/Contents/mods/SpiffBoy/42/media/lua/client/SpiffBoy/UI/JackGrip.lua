require"ISUI/ISPanel"

SpiffBoyJackGrip=ISPanel:derive("SpiffBoyJackGrip")

function SpiffBoyJackGrip:new(b)
local a=ISPanel:new(0,0,1,1)
setmetatable(a,self)
self.__index=self
a.window=b
a.shown=false
a.background=false
a.border=false
a.keepOnScreen=false
return a
end

function SpiffBoyJackGrip:onMouseDown(a,b)
return true
end

function SpiffBoyJackGrip:onMouseUp(a,b)
return true
end

function SpiffBoyJackGrip:onRightMouseDown(a,b)
return true
end

function SpiffBoyJackGrip:onRightMouseUp(a,b)
if not isGamePaused()then
self.window:openJackMenu()
end
return true
end
