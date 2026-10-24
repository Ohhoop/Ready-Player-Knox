require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/WornHeadphones"

local a=SpiffBoy.WornHeadphones

local function c(player,args)
if type(args)~="table"then
return
end
local b=args.type
if b~=nil and not(a.isWornType(b)and a.isCarried(player,b))then
return
end
if a.apply(player,b)then
sendHumanVisual(player)
end
end

SpiffBoy.Commands.fromClient(a.COMMAND,c)
