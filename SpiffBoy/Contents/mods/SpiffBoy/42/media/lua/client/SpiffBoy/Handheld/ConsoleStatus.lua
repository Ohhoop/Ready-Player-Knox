require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"

SpiffBoy.ConsoleStatus=SpiffBoy.ConsoleStatus or{}
local a=SpiffBoy.ConsoleStatus

local g=1000

local c=0

function a.charge(b)
local d=SpiffBoyHandheldWindow.runningOn(b)
if d then
return math.max(0,d.battery or 0)
end
return SpiffBoy.Handheld.getBattery(b)or 0
end

function a.isSwitchedOn(d)
local b=SpiffBoyHandheldWindow.runningOn(d)
return b~=nil and b.switchOn
end

function a.displayName(d)
local b=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
if not a.isSwitchedOn(d)then
return b
end
return getText("IGUI_ClothingNaming",getText("Tooltip_activated"),b)
end

function a.refreshName(b)
local d=a.displayName(b)
if b:getName()~=d then
b:setName(d)
end
end

local function h()
local b=getTimestampMs()
if b<c then
return
end
c=b+g
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
