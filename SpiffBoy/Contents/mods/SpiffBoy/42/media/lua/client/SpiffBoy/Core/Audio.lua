require"SpiffBoy/Core/Core"

SpiffBoy.Audio=SpiffBoy.Audio or{}
local b=SpiffBoy.Audio

local c=8
local a=0

function b.beginFrame()
a=0
end

function b.playSound(name)
if type(name)~="string"or a>=c then
return
end
a=a+1
getSoundManager():playUISound(name)
end
