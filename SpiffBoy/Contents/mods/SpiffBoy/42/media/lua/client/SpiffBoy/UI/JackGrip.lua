require"ISUI/ISPanel"

SpiffBoyJackGrip=ISPanel:derive("SpiffBoyJackGrip")

function SpiffBoyJackGrip:new(window)
local a=ISPanel:new(0,0,1,1)
setmetatable(a,self)
self.__index=self
a.window=window
a.shown=false
a.background=false
a.border=false
a.keepOnScreen=false
return a
end

function SpiffBoyJackGrip:onMouseDown(x,y)
return true
end

function SpiffBoyJackGrip:onMouseUp(x,y)
return true
end

function SpiffBoyJackGrip:onRightMouseDown(x,y)
return true
end

function SpiffBoyJackGrip:onRightMouseUp(x,y)
if not isGamePaused()then
self.window:openJackMenu()
end
return true
end
