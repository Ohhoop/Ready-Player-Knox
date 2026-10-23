require"SpiffBoy/Core/CameraShift"
require"SpiffBoy/UI/HandheldWindow"
require"SpiffBoy/Handheld/HandheldAction"

local d=0
local e="first"

local f=SpiffBoy.CameraShift.begin
local g=SpiffBoyHandheldWindow.holdZoomIn
local h=SpiffBoyHandheldAction.new

local function a(c)
local b=Viewpoint and Viewpoint.View
return c==d and b~=nil and b.next()~=e
end

function SpiffBoy.CameraShift.begin(b,c,i)
if a(b:getPlayerNum())then
return
end
f(b,c,i)
end

function SpiffBoyHandheldWindow:holdZoomIn()
if a(self.playerNum)then
return
end
g(self)
end

function SpiffBoyHandheldAction:new(b,i,j)
local c=h(self,b,i,j)
if a(b:getPlayerNum())then
c.stopOnAim=false
end
return c
end
