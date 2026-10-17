require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/WornHeadphones"

local a=SpiffBoy.WornHeadphones

function a.wear(c,b)
local d=a.apply(c,b)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("worn headphones "..tostring(b)..", changed "..tostring(d))
end
if isClient()then
sendClientCommand(c,SpiffBoy.COMMAND_MODULE,a.COMMAND,{type=b})
end
end

local function b(d,c)
a.wear(c,nil)
end

Events.OnCreatePlayer.Add(b)
