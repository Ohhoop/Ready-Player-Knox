require"ActionManager"
require"Entity/TimedActions/ISHandcraftAction"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Core/Sandbox"

SpiffBoy.Salvage=SpiffBoy.Salvage or{}
local a=SpiffBoy.Salvage
local b=SpiffBoy.Handheld

SpiffBoyRecipes=SpiffBoyRecipes or{}

function SpiffBoyRecipes.canDismantle(c,d)
return SpiffBoy.Sandbox.dismantling()
end

function a.partsOf(c)
if b.isConsole(c)then
return b.partsInside(c)
end
return{}
end

local g=ISHandcraftAction.performRecipe

function ISHandcraftAction:performRecipe()
g(self)
local c=self.logic and self.logic:getRecipeData()
if not c then
return
end
local d=c:getAllConsumedItems()
for h=0,d:size()-1 do
local e=d:get(h)
if e:getContainer()==nil then
local f=a.partsOf(e)
for i=1,#f do
Actions.addOrDropItem(self.character,f[i])
end
end
end
end
