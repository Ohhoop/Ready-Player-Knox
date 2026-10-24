if isClient()and not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Core/Sandbox"

local a=1000000

local function e(console,cartridges)
if SpiffBoy.Handheld.getCartridge(console)or ZombRand(100)>=SpiffBoy.Sandbox.consoleCartridgeChance()then
return
end
local b=SpiffBoy.Cartridges.pickWeighted(cartridges,ZombRand(a)/a)
SpiffBoy.Handheld.setCartridge(console,SpiffBoy.Handheld.newRecord(b.item,{}))
SpiffBoy.trace("console spawned with "..b.id.." in "..tostring(console:getContainer()and console:getContainer():getType()))
end

local function f(roomName,containerType,container)
if not instanceof(container,"ItemContainer")then
return
end
local b=SpiffBoy.Cartridges.lootable()
if#b==0 then
return
end
local c=container:getItems()
for g=0,c:size()-1 do
local d=c:get(g)
if SpiffBoy.Handheld.isConsole(d)then
e(d,b)
end
end
end

Events.OnFillContainer.Add(f)
