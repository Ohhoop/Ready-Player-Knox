require"ISUI/ISContextMenu"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Menus/CartridgeMenu"

SpiffBoy.HeadphonesMenu=SpiffBoy.HeadphonesMenu or{}
local a=SpiffBoy.HeadphonesMenu

local function h(b)
local c=SpiffBoy.Handheld
return c.isConsole(b)and c.getHeadphones(b)==nil
end

function a.plug(b,c,d)
SpiffBoy.CartridgeMenu.queue(b,c,{{action=SpiffBoyPlugHeadphonesAction,item=d}})
end

function a.unplug(b,c)
SpiffBoy.CartridgeMenu.queue(b,c,{{action=SpiffBoyUnplugHeadphonesAction}})
end

local function i(g)
local c=g:getInventory():getAllEvalRecurse(SpiffBoy.Handheld.isHeadphones,ArrayList.new())
local b={}
local d={}
for j=0,c:size()-1 do
local e=c:get(j)
local f=e:getFullType()
if not d[f]then
d[f]=true
b[#b+1]=e
end
end
return b
end

function a.addOptions(j,b,c,e)
local f=SpiffBoy.Handheld.getHeadphones(c)
if f then
local d=e(getText("UI_SpiffBoy_UnplugHeadphones"),b,a.unplug,c)
d.iconTexture=getScriptManager():FindItem(f):getNormalTexture()
return
end
local d=i(b)
if#d==0 then
return
end
if#d==1 then
local g=d[1]
e(getText("UI_SpiffBoy_PlugItem",getItemNameFromFullType(g:getFullType())),b,a.plug,c,g)
return
end
local k=e(getText("UI_SpiffBoy_PlugHeadphones"),b,nil)
local l=SpiffBoy.CartridgeMenu.subMenu(j,k)
for m,g in ipairs(d)do
l:addOption(getItemNameFromFullType(g:getFullType()),b,a.plug,c,g)
end
end

function a.addPlugInConsoleOption(d,b,e,f)
local g=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local c=b:getInventory():getAllEvalRecurse(h,ArrayList.new())
if c:size()==0 then
return
end
local j=getText("UI_SpiffBoy_PlugInConsole",g)
SpiffBoy.CartridgeMenu.addConsoleChoice(d,f,j,b,c,a.plug,e)
end
