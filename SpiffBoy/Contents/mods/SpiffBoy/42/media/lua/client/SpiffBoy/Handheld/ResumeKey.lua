require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/KeyBinds"
require"SpiffBoy/UI/HandheldWindow"

local c=SpiffBoy.KeyBinds

local function d(a)
if ISTimedActionQueue.isPlayerDoingAction(a)then
return false
end
local b=a:getVehicle()
if b then
return not b:isDriver(a)
end
return not a:isPlayerMoving()
end

local function b(e)
if isGamePaused()or not getCore():isKey(c.BINDS.resume.id,e)then
return
end
for f,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.hidden and a.switchOn and a.playerObj:getJoypadBind()<0 and d(a.playerObj)then
a:reveal()
end
end
end

Events.OnKeyStartPressed.Add(b)
