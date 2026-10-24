require"ISUI/ISInventoryPaneContextMenu"
require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Handheld/PlayHandheldAction"

SpiffBoy.CartridgeMenu=SpiffBoy.CartridgeMenu or{}
local a=SpiffBoy.CartridgeMenu

function a.disable(option,text)
option.notAvailable=true
local b=ISInventoryPaneContextMenu.addToolTip()
b.description=text
option.toolTip=b
end

function a.subMenu(context,option)
local b=ISContextMenu:getNew(context)
b:setAlwaysOnTop(context.javaObject:isAlwaysOnTop())
context:addSubMenu(option,b)
return b
end

function a.addConsoleChoice(context,add,label,playerObj,consoles,onSelect,item)
if consoles:size()==1 then
return add(label,playerObj,onSelect,consoles:get(0),item)
end
local b=add(label,playerObj,nil)
if consoles:size()==0 then
return b
end
local d=a.subMenu(context,b)
for e=0,consoles:size()-1 do
local c=consoles:get(e)
d:addOption(c:getDisplayName(),playerObj,onSelect,c,item)
end
return b
end

local function e(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("cartridge menu: "..message)
end
end

function a.queue(playerObj,console,steps)
local b=SpiffBoyHandheldWindow.shownOn(console)
local d=b and b.poseAction
local f={}
for c=1,#steps do
local g=steps[c]
f[c]=(g.timedAction or g.action).Type
end
e("queue "..table.concat(f,", ")..", window shown "..tostring(b~=nil)..", pose running "..tostring(d~=nil and d.action~=nil)..", queue length before "..tostring(#ISTimedActionQueue.getTimedActionQueue(playerObj).queue))
ISInventoryPaneContextMenu.transferIfNeeded(playerObj,console)
for g=1,#steps do
local c=steps[g]
if c.timedAction then
ISTimedActionQueue.add(c.timedAction)
else
if c.item then
ISInventoryPaneContextMenu.transferIfNeeded(playerObj,c.item)
end
ISTimedActionQueue.add(c.action:new(playerObj,console,c.item))
end
end
if b then
b.poseAction=SpiffBoyPlayHandheldAction:new(playerObj,b)
ISTimedActionQueue.add(b.poseAction)
SpiffBoyPlayHandheldAction.finishFor(d)
end
e("queue length after "..tostring(#ISTimedActionQueue.getTimedActionQueue(playerObj).queue))
end

function a.insert(playerObj,console,cartridge)
local b={}
if SpiffBoy.Handheld.getCartridge(console)then
b[#b+1]={action=SpiffBoyRemoveCartridgeAction}
end
b[#b+1]={action=SpiffBoyInsertCartridgeAction,item=cartridge}
a.queue(playerObj,console,b)
end

function a.remove(playerObj,console)
a.queue(playerObj,console,{{action=SpiffBoyRemoveCartridgeAction}})
end

function a.addOptions(context,playerObj,console,add,allowSwap)
local f=SpiffBoy.Handheld.getCartridge(console)
if f then
add(getText("UI_SpiffBoy_RemoveCartridge"),playerObj,a.remove,console)
if not allowSwap then
return
end
end
local b=playerObj:getInventory():getAllEvalRecurse(SpiffBoy.Cartridges.isCartridge,ArrayList.new())
local c=add(getText("UI_SpiffBoy_InsertCartridge"),playerObj,nil)
if b:size()==0 then
a.disable(c,getText("UI_SpiffBoy_NoCartridgeInInventory"))
return
end
local g=a.subMenu(context,c)
for h=0,b:size()-1 do
local d=b:get(h)
local i=SpiffBoy.Cartridges.get(d:getFullType())
g:addOption(i.title,playerObj,a.insert,console,d)
end
end
