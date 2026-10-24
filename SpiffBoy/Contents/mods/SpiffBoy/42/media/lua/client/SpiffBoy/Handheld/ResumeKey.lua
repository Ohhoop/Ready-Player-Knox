require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/KeyBinds"
require"SpiffBoy/UI/HandheldWindow"

local b=SpiffBoy.KeyBinds

local function c(playerObj)
if ISTimedActionQueue.isPlayerDoingAction(playerObj)then
return false
end
local a=playerObj:getVehicle()
if a then
return not a:isDriver(playerObj)
end
return not playerObj:isPlayerMoving()
end

local function d(key)
if isGamePaused()or not getCore():isKey(b.BINDS.resume.id,key)then
return
end
for e,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.hidden and a.switchOn and a.playerObj:getJoypadBind()<0 and c(a.playerObj)then
a:reveal()
end
end
end

Events.OnKeyStartPressed.Add(d)
