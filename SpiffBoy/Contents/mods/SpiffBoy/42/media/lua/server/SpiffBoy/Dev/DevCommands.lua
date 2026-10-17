require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Dev/DevItems"

local a=SpiffBoy.DevItems

local function d(b,c)
if not SpiffBoy.isDevBuild()or type(c)~="table"then
return
end
if not b:getRole():hasCapability(Capability.AddItem)then
SpiffBoy.log("dev spawn refused for "..tostring(b:getUsername()))
return
end
if not a.isDevice(c.device)then
return
end
local e,f=a.give(b,c.device)
sendServerCommand(b,SpiffBoy.COMMAND_MODULE,a.COMMAND_SPAWNED,{device=c.device,added=e,skipped=f})
end

SpiffBoy.Commands.fromClient(a.COMMAND_SPAWN,d)
