require"SpiffBoy/Core/Core"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local a={}
SpiffBoy.DoubleRaccoon.Combat=a

a.DEPTH=50

function a.inFront(attacker,target,near,far,depth)
local b=(target.x-attacker.x)*attacker.facing
return b>=near and b<=far and math.abs(target.z-attacker.z)<=depth
end

function a.approach(value,target,step)
if value<target then
return math.min(value+step,target)
end
return math.max(value-step,target)
end

function a.sign(value)
if value<0 then
return-1
elseif value>0 then
return 1
end
return 0
end

function a.clampDepth(z)
return SpiffBoy.clamp(z,0,a.DEPTH)
end
