require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Sandbox"

SpiffBoy.Mood=SpiffBoy.Mood or{}
local a=SpiffBoy.Mood

a.BOREDOM_PER_SECOND=0.04
a.UNHAPPINESS_PER_SECOND=0.02

function a.applySecond(c)
if not SpiffBoy.Sandbox.playingEasesMood()then
return
end
local b=c:getStats()
b:remove(CharacterStat.BOREDOM,a.BOREDOM_PER_SECOND)
b:remove(CharacterStat.UNHAPPINESS,a.UNHAPPINESS_PER_SECOND)
end
