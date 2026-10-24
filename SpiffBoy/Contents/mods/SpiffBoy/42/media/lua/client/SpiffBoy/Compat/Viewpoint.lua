require"SpiffBoy/Core/CameraShift"
require"SpiffBoy/UI/HandheldWindow"
require"SpiffBoy/Handheld/HandheldAction"

local c=0
local d="first"

local e=SpiffBoy.CameraShift.begin
local f=SpiffBoyHandheldWindow.holdZoomIn
local g=SpiffBoyHandheldAction.new

local function a(playerNum)
local b=Viewpoint and Viewpoint.View
return playerNum==c and b~=nil and b.next()~=d
end

function SpiffBoy.CameraShift.begin(playerObj,screenTargetX,screenTargetY)
if a(playerObj:getPlayerNum())then
return
end
e(playerObj,screenTargetX,screenTargetY)
end

function SpiffBoyHandheldWindow:holdZoomIn()
if a(self.playerNum)then
return
end
f(self)
end

function SpiffBoyHandheldAction:new(character,console,item)
local b=g(self,character,console,item)
if a(character:getPlayerNum())then
b.stopOnAim=false
end
return b
end
