require"ActionManager"
require"Entity/TimedActions/ISHandcraftAction"
require"SpiffBoy/Handheld/Handheld"

SpiffBoy.Salvage=SpiffBoy.Salvage or{}
local c=SpiffBoy.Salvage
local a=SpiffBoy.Handheld

c.CABLE_PART="Base.ElectricWire"

function c.partsOf(b)
if a.isConsole(b)then
return a.partsInside(b)
end
if a.isCable(b)then
local d=a.newItem(c.CABLE_PART)
if d then
return{d}
end
end
return{}
end

local function g(f)
local b={}
local d=f:getAllConsumedItems()
for h=0,d:size()-1 do
local e=d:get(h)
if e:getContainer()==nil then
b[#b+1]=e
end
end
return b
end

local function h(b)
for d=1,#b do
if not a.isCable(b[d])then
return false
end
end
return true
end

local function i(b)
local e=b:getContainer()
if e then
e:Remove(b)
sendRemoveItemFromContainer(e,b)
return
end
local d=b:getWorldItem()
if d then
local f=d:getSquare()
f:transmitRemoveItemFromSquare(d)
f:removeWorldObject(d)
b:setWorldItem(nil)
end
end

local function f(d)
local b=ArrayList.new()
d:getCreatedOutputItems(b)
for e=0,b:size()-1 do
i(b:get(e))
end
end

local j=ISHandcraftAction.performRecipe

function ISHandcraftAction:performRecipe()
j(self)
local d=self.logic and self.logic:getRecipeData()
if not d then
return
end
local b=g(d)
if#b==0 then
return
end
if h(b)then
f(self.logic)
end
for k=1,#b do
local e=c.partsOf(b[k])
for l=1,#e do
Actions.addOrDropItem(self.character,e[l])
end
end
end
