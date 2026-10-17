require"ISUI/ISInventoryPaneContextMenu"
require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Handheld/PlayHandheldAction"

SpiffBoy.CartridgeMenu=SpiffBoy.CartridgeMenu or{}
local a=SpiffBoy.CartridgeMenu

function a.disable(b,d)
b.notAvailable=true
local c=ISInventoryPaneContextMenu.addToolTip()
c.description=d
b.toolTip=c
end

function a.subMenu(b,d)
local c=ISContextMenu:getNew(b)
c:setAlwaysOnTop(b.javaObject:isAlwaysOnTop())
b:addSubMenu(d,c)
return c
end

function a.addConsoleChoice(j,e,f,c,b,g,h)
if b:size()==1 then
return e(f,c,g,b:get(0),h)
end
local d=e(f,c,nil)
if b:size()==0 then
return d
end
local k=a.subMenu(j,d)
for l=0,b:size()-1 do
local i=b:get(l)
k:addOption(i:getDisplayName(),c,g,i,h)
end
return d
end

local function h(b)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("cartridge menu: "..b)
end
end

function a.queue(c,f,e)
local b=SpiffBoyHandheldWindow.shownOn(f)
local g=b and b.poseAction
local i={}
for d=1,#e do
local j=e[d]
i[d]=(j.timedAction or j.action).Type
end
h("queue "..table.concat(i,", ")..", window shown "..tostring(b~=nil)..", pose running "..tostring(g~=nil and g.action~=nil)..", queue length before "..tostring(#ISTimedActionQueue.getTimedActionQueue(c).queue))
ISInventoryPaneContextMenu.transferIfNeeded(c,f)
for j=1,#e do
local d=e[j]
if d.timedAction then
ISTimedActionQueue.add(d.timedAction)
else
if d.item then
ISInventoryPaneContextMenu.transferIfNeeded(c,d.item)
end
ISTimedActionQueue.add(d.action:new(c,f,d.item))
end
end
if b then
b.poseAction=SpiffBoyPlayHandheldAction:new(c,b)
ISTimedActionQueue.add(b.poseAction)
SpiffBoyPlayHandheldAction.finishFor(g)
end
h("queue length after "..tostring(#ISTimedActionQueue.getTimedActionQueue(c).queue))
end

function a.insert(d,c,e)
local b={}
if SpiffBoy.Handheld.getCartridge(c)then
b[#b+1]={action=SpiffBoyRemoveCartridgeAction}
end
b[#b+1]={action=SpiffBoyInsertCartridgeAction,item=e}
a.queue(d,c,b)
end

function a.remove(b,c)
a.queue(b,c,{{action=SpiffBoyRemoveCartridgeAction}})
end

function a.addOptions(i,b,c,e,j)
local k=SpiffBoy.Handheld.getCartridge(c)
if k then
e(getText("UI_SpiffBoy_RemoveCartridge"),b,a.remove,c)
if not j then
return
end
end
local d=b:getInventory():getAllEvalRecurse(SpiffBoy.Cartridges.isCartridge,ArrayList.new())
local f=e(getText("UI_SpiffBoy_InsertCartridge"),b,nil)
if d:size()==0 then
a.disable(f,getText("UI_SpiffBoy_NoCartridgeInInventory"))
return
end
local l=a.subMenu(i,f)
for m=0,d:size()-1 do
local g=d:get(m)
local n=SpiffBoy.Cartridges.get(g:getFullType())
l:addOption(n.title,b,a.insert,c,g)
end
end
