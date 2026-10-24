require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Random"
require"SpiffBoy/Core/SaveData"

SpiffBoyGameBase={}
SpiffBoyGameBase.__index=SpiffBoyGameBase

function SpiffBoyGameBase:derive(name)
local a={}
a.__index=a
a.Type=name
setmetatable(a,self)
return a
end

function SpiffBoyGameBase:new(runtime,context)
local a=setmetatable({},self)
a.screen=runtime.view
a.context=context
a.random=SpiffBoyRandom.new(context.seed)
a.save=SpiffBoy.SaveData.clean(context.save)
a.chip=context.chip
a.sequencer=context.sequencer
a.link=context.link
a:init()
return a
end

function SpiffBoyGameBase:persist()
local a=SpiffBoy.SaveData.check(self.save)
if a then
error("SpiffBoy: the game "..tostring(self.context.definition.id).." cannot save, "..a)
end
self.context.persist(self.save)
end

function SpiffBoyGameBase:init()
end

function SpiffBoyGameBase:tick(inputs,tick)
end

function SpiffBoyGameBase:draw(screen)
end
