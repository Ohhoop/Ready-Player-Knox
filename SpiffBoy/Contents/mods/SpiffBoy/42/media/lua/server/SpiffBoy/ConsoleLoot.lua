if isClient()and not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Core/Sandbox"

local b=1000000

local function f(a,d)
if SpiffBoy.Handheld.getCartridge(a)or ZombRand(100)>=SpiffBoy.Sandbox.consoleCartridgeChance()then
return
end
local c=SpiffBoy.Cartridges.pickWeighted(d,ZombRand(b)/b)
SpiffBoy.Handheld.setCartridge(a,SpiffBoy.Handheld.newRecord(c.item,{}))
SpiffBoy.trace("console spawned with "..c.id.." in "..tostring(a:getContainer()and a:getContainer():getType()))
end

local function g(i,j,a)
if not instanceof(a,"ItemContainer")then
return
end
local c=SpiffBoy.Cartridges.lootable()
if#c==0 then
return
end
local d=a:getItems()
for h=0,d:size()-1 do
local e=d:get(h)
if SpiffBoy.Handheld.isConsole(e)then
f(e,c)
end
end
end

Events.OnFillContainer.Add(g)
