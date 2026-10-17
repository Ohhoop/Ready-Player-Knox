require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.DevItems=SpiffBoy.DevItems or{}
local a=SpiffBoy.DevItems

a.HANDHELD="Handheld"
a.BATTERY="Battery"
a.EMPTY_BATTERY="Empty Battery"
a.HEADPHONES="Headphones"
a.CABLE="Link Cable"
a.COMMAND_SPAWN="devSpawn"
a.COMMAND_SPAWNED="devSpawned"
a.DEVICES={
{id=a.HANDHELD,title=a.HANDHELD},
{id=a.BATTERY,title=a.BATTERY},
{id=a.EMPTY_BATTERY,title=a.EMPTY_BATTERY},
{id=a.HEADPHONES,title=a.HEADPHONES},
{id=a.CABLE,title=a.CABLE},
}

local i=0.01
local j="Base.Headphones"

local d={}
for c,b in ipairs(a.DEVICES)do
d[b.id]=b
end

function a.device(b)
return d[b]
end

function a.isDevice(b)
return d[b]~=nil
end

local function k(c)
local b={}
if c==a.BATTERY then
b[#b+1]=instanceItem(SpiffBoy.BATTERY_ITEM)
return b
end
if c==a.HEADPHONES then
b[#b+1]=instanceItem(j)
return b
end
if c==a.CABLE then
b[#b+1]=instanceItem(SpiffBoy.CABLE_ITEM)
return b
end
if c==a.EMPTY_BATTERY then
local e=instanceItem(SpiffBoy.BATTERY_ITEM)
e:setUsedDelta(i)
b[#b+1]=e
return b
end
b[#b+1]=instanceItem(SpiffBoy.CONSOLE_ITEM)
for f,e in ipairs(SpiffBoy.Cartridges.all())do
b[#b+1]=instanceItem(e.item)
end
b[#b+1]=instanceItem(SpiffBoy.BATTERY_ITEM)
return b
end

function a.give(c,h)
if not SpiffBoy.isDevBuild()or not c or not a.isDevice(h)then
return 0,0
end
local e=c:getInventory()
local f,g=0,0
for l,b in ipairs(k(h))do
if b and e:hasRoomFor(c,b)then
e:AddItem(b)
if isServer()then
sendAddItemToContainer(e,b)
end
f=f+1
else
g=g+1
end
end
return f,g
end
