require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/WornHeadphones"

local a=SpiffBoy.WornHeadphones

local function e(c,d)
if type(d)~="table"then
return
end
local b=d.type
if b~=nil and not(a.isWornType(b)and a.isCarried(c,b))then
return
end
if a.apply(c,b)then
sendHumanVisual(c)
end
end

SpiffBoy.Commands.fromClient(a.COMMAND,e)
