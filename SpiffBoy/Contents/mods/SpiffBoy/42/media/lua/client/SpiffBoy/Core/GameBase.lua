require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Random"
require"SpiffBoy/Core/SaveData"

SpiffBoyGameBase={}
SpiffBoyGameBase.__index=SpiffBoyGameBase

function SpiffBoyGameBase:derive(b)
local a={}
a.__index=a
a.Type=b
setmetatable(a,self)
return a
end

function SpiffBoyGameBase:new(c,b)
local a=setmetatable({},self)
a.screen=c.view
a.context=b
a.random=SpiffBoyRandom.new(b.seed)
a.save=SpiffBoy.SaveData.clean(b.save)
a.chip=b.chip
a.sequencer=b.sequencer
a.link=b.link
a:init()
return a
end

function SpiffBoyGameBase:persist()
self.context.persist(self.save)
end

function SpiffBoyGameBase:init()
end

function SpiffBoyGameBase:tick(a,b)
end

function SpiffBoyGameBase:draw(a)
end
