require"SpiffBoy/Core/CameraShift"
require"SpiffBoy/UI/HandheldWindow"

local c=0
local d="first"

local e=SpiffBoy.CameraShift.begin
local f=SpiffBoyHandheldWindow.holdZoomIn

local function a(g)
local b=Viewpoint and Viewpoint.View
return g==c and b~=nil and b.next()~=d
end

function SpiffBoy.CameraShift.begin(b,g,h)
if a(b:getPlayerNum())then
return
end
e(b,g,h)
end

function SpiffBoyHandheldWindow:holdZoomIn()
if a(self.playerNum)then
return
end
f(self)
end
