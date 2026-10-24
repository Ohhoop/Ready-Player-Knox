require"ISUI/ISUIElement"

SpiffBoyZoomLock=ISUIElement:derive("SpiffBoyZoomLock")

local d=1

local a=nil
local b=0

function SpiffBoyZoomLock:new()
local c=ISUIElement:new(0,0,d,d)
setmetatable(c,self)
self.__index=self
c.wantMouseEvents=false
return c
end

function SpiffBoyZoomLock:onMouseWheel(del)
return true
end

function SpiffBoyZoomLock:onMouseDown(x,y)
return false
end

function SpiffBoyZoomLock:onMouseUp(x,y)
return false
end

function SpiffBoyZoomLock:onRightMouseDown(x,y)
return false
end

function SpiffBoyZoomLock:onRightMouseUp(x,y)
return false
end

function SpiffBoyZoomLock.engage()
b=b+1
if a then
return
end
a=SpiffBoyZoomLock:new()
a:initialise()
a:addToUIManager()
a:backMost()
a:setCapture(true)
end

function SpiffBoyZoomLock.release()
if b==0 then
return
end
b=b-1
if b>0 or not a then
return
end
a:setCapture(false)
a:removeFromUIManager()
a=nil
end
