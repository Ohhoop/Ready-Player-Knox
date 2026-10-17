require"SpiffBoy/Core/Core"

SpiffBoy.Audio=SpiffBoy.Audio or{}
local b=SpiffBoy.Audio

local d=8
local a=0

function b.beginFrame()
a=0
end

function b.playSound(c)
if type(c)~="string"or a>=d then
return
end
a=a+1
getSoundManager():playUISound(c)
end
