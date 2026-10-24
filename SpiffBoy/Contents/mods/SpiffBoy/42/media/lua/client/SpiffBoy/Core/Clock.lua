require"SpiffBoy/Core/Core"

SpiffBoyClock={}
SpiffBoyClock.__index=SpiffBoyClock

local a=SpiffBoy.TICK_MS
local c=SpiffBoy.MAX_FRAME_MS

function SpiffBoyClock.new()
local b=setmetatable({},SpiffBoyClock)
b.accumulator=0
return b
end

function SpiffBoyClock:reset()
self.accumulator=0
end

function SpiffBoyClock:advance(elapsedMs,rate)
self.accumulator=math.min(self.accumulator+elapsedMs*rate,c*rate)
local b=math.floor(self.accumulator/a)
self.accumulator=self.accumulator-b*a
return b
end
