require"ISUI/ISContextMenu"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Menus/CartridgeMenu"

SpiffBoy.HeadphonesMenu=SpiffBoy.HeadphonesMenu or{}
local a=SpiffBoy.HeadphonesMenu

local function g(item)
local b=SpiffBoy.Handheld
return b.isConsole(item)and b.getHeadphones(item)==nil
end

function a.plug(playerObj,console,headphones)
SpiffBoy.CartridgeMenu.queue(playerObj,console,{{action=SpiffBoyPlugHeadphonesAction,item=headphones}})
end

function a.unplug(playerObj,console)
SpiffBoy.CartridgeMenu.queue(playerObj,console,{{action=SpiffBoyUnplugHeadphonesAction}})
end

local function h(playerObj)
local c=playerObj:getInventory():getAllEvalRecurse(SpiffBoy.Handheld.isHeadphones,ArrayList.new())
local b={}
local d={}
for i=0,c:size()-1 do
local e=c:get(i)
local f=e:getFullType()
if not d[f]then
d[f]=true
b[#b+1]=e
end
end
return b
end

function a.addOptions(context,playerObj,console,add)
local c=SpiffBoy.Handheld.getHeadphones(console)
if c then
local b=add(getText("UI_SpiffBoy_UnplugHeadphones"),playerObj,a.unplug,console)
b.iconTexture=getScriptManager():FindItem(c):getNormalTexture()
return
end
local b=h(playerObj)
if#b==0 then
return
end
if#b==1 then
local d=b[1]
add(getText("UI_SpiffBoy_PlugItem",getItemNameFromFullType(d:getFullType())),playerObj,a.plug,console,d)
return
end
local e=add(getText("UI_SpiffBoy_PlugHeadphones"),playerObj,nil)
local f=SpiffBoy.CartridgeMenu.subMenu(context,e)
for i,d in ipairs(b)do
f:addOption(getItemNameFromFullType(d:getFullType()),playerObj,a.plug,console,d)
end
end

function a.addPlugInConsoleOption(context,playerObj,headphones,add)
local c=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local b=playerObj:getInventory():getAllEvalRecurse(g,ArrayList.new())
if b:size()==0 then
return
end
local d=getText("UI_SpiffBoy_PlugInConsole",c)
SpiffBoy.CartridgeMenu.addConsoleChoice(context,add,d,playerObj,b,a.plug,headphones)
end
