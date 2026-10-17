require"SpiffBoy/Core/Core"

SpiffBoyClock={}
SpiffBoyClock.__index=SpiffBoyClock

local a=SpiffBoy.TICK_MS
local d=SpiffBoy.MAX_FRAME_MS

function SpiffBoyClock.new()
local b=setmetatable({},SpiffBoyClock)
b.accumulator=0
return b
end

function SpiffBoyClock:reset()
self.accumulator=0
end

function SpiffBoyClock:advance(e,b)
self.accumulator=math.min(self.accumulator+e*b,d*b)
local c=math.floor(self.accumulator/a)
self.accumulator=self.accumulator-c*a
return c
end
