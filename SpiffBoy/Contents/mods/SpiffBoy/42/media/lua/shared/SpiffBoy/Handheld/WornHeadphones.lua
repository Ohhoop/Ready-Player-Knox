require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"

SpiffBoy.WornHeadphones=SpiffBoy.WornHeadphones or{}
local a=SpiffBoy.WornHeadphones
local b=SpiffBoy.Handheld

a.COMMAND="wornHeadphones"

function a.isWornType(c)
for e,d in pairs(b.HEADPHONES)do
if d.worn==c then
return true
end
end
return false
end

function a.isCarried(e,f)
local c=e:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for g=0,c:size()-1 do
local d=b.getHeadphones(c:get(g))
if d and b.HEADPHONES[d].worn==f then
return true
end
end
return false
end

function a.apply(g,c)
local d=g:getHumanVisual()
local e=false
for i,h in pairs(b.HEADPHONES)do
local f=h.worn
if f~=c and d:hasBodyVisualFromItemType(f)then
d:removeBodyVisualFromItemType(f)
e=true
end
end
if c and not d:hasBodyVisualFromItemType(c)then
d:addBodyVisualFromItemType(c)
e=true
end
if e then
g:resetModelNextFrame()
end
return e
end
