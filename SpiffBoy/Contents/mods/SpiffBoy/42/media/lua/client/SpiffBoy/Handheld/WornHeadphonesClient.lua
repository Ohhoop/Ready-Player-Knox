require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/WornHeadphones"

local a=SpiffBoy.WornHeadphones

function a.wear(playerObj,wornType)
local b=a.apply(playerObj,wornType)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("worn headphones "..tostring(wornType)..", changed "..tostring(b))
end
if isClient()then
sendClientCommand(playerObj,SpiffBoy.COMMAND_MODULE,a.COMMAND,{type=wornType})
end
end

local function b(playerNum,playerObj)
a.wear(playerObj,nil)
end

Events.OnCreatePlayer.Add(b)
