require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"

SpiffBoy.WornHeadphones=SpiffBoy.WornHeadphones or{}
local a=SpiffBoy.WornHeadphones
local b=SpiffBoy.Handheld

a.COMMAND="wornHeadphones"

function a.isWornType(itemType)
for d,c in pairs(b.HEADPHONES)do
if c.worn==itemType then
return true
end
end
return false
end

function a.isCarried(character,wornType)
local c=character:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for e=0,c:size()-1 do
local d=b.getHeadphones(c:get(e))
if d and b.HEADPHONES[d].worn==wornType then
return true
end
end
return false
end

function a.apply(character,wornType)
local c=character:getHumanVisual()
local d=false
for g,f in pairs(b.HEADPHONES)do
local e=f.worn
if e~=wornType and c:hasBodyVisualFromItemType(e)then
c:removeBodyVisualFromItemType(e)
d=true
end
end
if wornType and not c:hasBodyVisualFromItemType(wornType)then
c:addBodyVisualFromItemType(wornType)
d=true
end
if d then
character:resetModelNextFrame()
end
return d
end
