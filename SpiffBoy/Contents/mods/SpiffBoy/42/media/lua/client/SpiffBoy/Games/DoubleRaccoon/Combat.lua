require"SpiffBoy/Core/Core"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local a={}
SpiffBoy.DoubleRaccoon.Combat=a

a.DEPTH=50

function a.inFront(b,c,e,f,g)
local d=(c.x-b.x)*b.facing
return d>=e and d<=f and math.abs(c.z-b.z)<=g
end

function a.approach(b,c,d)
if b<c then
return math.min(b+d,c)
end
return math.max(b-d,c)
end

function a.sign(b)
if b<0 then
return-1
elseif b>0 then
return 1
end
return 0
end

function a.clampDepth(b)
return SpiffBoy.clamp(b,0,a.DEPTH)
end
