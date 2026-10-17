if isClient()and not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"

local e=50

local function f(a,b)
if SpiffBoy.Handheld.getCartridge(a)or ZombRand(100)>=e then
return
end
local c=b[ZombRand(#b)+1]
SpiffBoy.Handheld.setCartridge(a,SpiffBoy.Handheld.newRecord(c.item,{}))
SpiffBoy.trace("console spawned with "..c.id.." in "..tostring(a:getContainer()and a:getContainer():getType()))
end

local function g(i,j,a)
if not instanceof(a,"ItemContainer")then
return
end
local b=SpiffBoy.Cartridges.lootable()
if#b==0 then
return
end
local c=a:getItems()
for h=0,c:size()-1 do
local d=c:get(h)
if SpiffBoy.Handheld.isConsole(d)then
f(d,b)
end
end
end

Events.OnFillContainer.Add(g)
