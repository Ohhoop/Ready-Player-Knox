require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"

SpiffBoy.ConsoleStatus=SpiffBoy.ConsoleStatus or{}
local a=SpiffBoy.ConsoleStatus

local g=1000

local b=0

function a.charge(console)
local c=SpiffBoyHandheldWindow.runningOn(console)
if c then
return math.max(0,c.battery or 0)
end
return SpiffBoy.Handheld.getBattery(console)or 0
end

function a.isSwitchedOn(console)
local c=SpiffBoyHandheldWindow.runningOn(console)
return c~=nil and c.switchOn
end

function a.displayName(console)
local c=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
if not a.isSwitchedOn(console)then
return c
end
return getText("IGUI_ClothingNaming",getText("Tooltip_activated"),c)
end

function a.refreshName(console)
local c=a.displayName(console)
if console:getName()~=c then
console:setName(c)
end
end

local function h()
local c=getTimestampMs()
if c<b then
return
end
b=c+g
for i=0,getNumActivePlayers()-1 do
local d=getSpecificPlayer(i)
if d then
local e=d:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for j=0,e:size()-1 do
local f=e:get(j)
a.refreshName(f)
SpiffBoy.Handheld.refreshWeight(f)
end
end
end
end

Events.OnTickEvenPaused.Add(h)
