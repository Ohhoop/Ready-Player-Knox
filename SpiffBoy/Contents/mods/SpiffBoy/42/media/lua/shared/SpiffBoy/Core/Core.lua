require"luautils"
require"SpiffBoy/Core/Random"

SpiffBoy=SpiffBoy or{}

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

local c="-DEV"

function SpiffBoy.isDevBuild()
return luautils.stringEnds(SpiffBoy.MOD_ID,c)
end

local d={[5]=2,[20]=4,[40]=6}
local e=1

function SpiffBoy.consoleRate()
return d[getGameTime():getTrueMultiplier()]or e
end

function SpiffBoy.log(a)
print("SpiffBoy: "..tostring(a))
end

function SpiffBoy.trace(a)
if SpiffBoy.isDevBuild()then
SpiffBoy.log(a)
end
end

function SpiffBoy.clamp(a,b,f)
return math.max(b,math.min(f,a))
end

function SpiffBoy.withinHearing(a,b)
if math.abs(math.floor(a:getZ())-math.floor(b:getZ()))>SpiffBoy.HEAR_LEVELS then
return false
end
local f=math.abs(a:getX()-b:getX())
local g=math.abs(a:getY()-b:getY())
return math.max(f,g)<=SpiffBoy.HEAR_DISTANCE
end

function SpiffBoy.newSeed()
return(getTimestampMs()%(SpiffBoyRandom.MODULUS-1))+1
end
