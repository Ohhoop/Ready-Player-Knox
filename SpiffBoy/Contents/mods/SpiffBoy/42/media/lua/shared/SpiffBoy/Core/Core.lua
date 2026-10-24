require"luautils"
require"SpiffBoy/Core/Random"

SpiffBoy=SpiffBoy or{}

SpiffBoy.API_VERSION=1
SpiffBoy.COMMAND_MODULE="SpiffBoy"
SpiffBoy.MOD_ID="SpiffBoy"
SpiffBoy.MOD_DATA_KEY="SpiffBoy"
SpiffBoy.CONSOLE_ITEM="Base.VideoGame"
SpiffBoy.BATTERY_ITEM="Base.Battery"
SpiffBoy.CABLE_ITEM="SpiffBoy.LinkCable"
SpiffBoy.TICK_RATE=60
SpiffBoy.TICK_MS=1000/SpiffBoy.TICK_RATE
SpiffBoy.MAX_FRAME_MS=100
SpiffBoy.HEAR_DISTANCE=20
SpiffBoy.HEAR_LEVELS=1
SpiffBoy.BYTE_MAX=255

local a="-DEV"

function SpiffBoy.isDevBuild()
return luautils.stringEnds(SpiffBoy.MOD_ID,a)
end

local b={[5]=2,[20]=4,[40]=6}
local c=1

function SpiffBoy.consoleRate()
return b[getGameTime():getTrueMultiplier()]or c
end

function SpiffBoy.log(message)
print("SpiffBoy: "..tostring(message))
end

function SpiffBoy.trace(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log(message)
end
end

function SpiffBoy.clamp(value,low,high)
return math.max(low,math.min(high,value))
end

function SpiffBoy.withinHearing(listener,source)
if math.abs(math.floor(listener:getZ())-math.floor(source:getZ()))>SpiffBoy.HEAR_LEVELS then
return false
end
local d=math.abs(listener:getX()-source:getX())
local e=math.abs(listener:getY()-source:getY())
return math.max(d,e)<=SpiffBoy.HEAR_DISTANCE
end

function SpiffBoy.newSeed()
return(getTimestampMs()%(SpiffBoyRandom.MODULUS-1))+1
end
