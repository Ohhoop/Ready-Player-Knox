require"ISUI/ISInventoryPaneContextMenu"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Handheld/ConsoleStatus"
require"SpiffBoy/Handheld/OpenHandheldAction"
require"SpiffBoy/UI/HandheldWindow"
require"SpiffBoy/Menus/CartridgeMenu"
require"SpiffBoy/Menus/HeadphonesMenu"
require"SpiffBoy/Menus/LinkMenu"

local j="Item_Battery"
local k="ContextMenu_ShowCraftRecipesUsed"

local function e(context,label,target,onSelect,...)
return context:insertOptionBefore(getText(k),label,target,onSelect,...)
end

local c=SpiffBoy.CartridgeMenu

local function l(option,textKey)
c.disable(option,getText(textKey))
end

local function m(playerObj,console)
SpiffBoyOpenHandheldAction.playFor(playerObj,console)
end

local function n(playerObj,console,battery)
c.queue(playerObj,console,{{action=SpiffBoyInsertBatteryAction,item=battery}})
end

local function o(playerObj,console)
local a=SpiffBoyHandheldWindow.runningOn(console)
if a then
a:persistHardware()
end
c.queue(playerObj,console,{{action=SpiffBoyRemoveBatteryAction}})
end

local function f(items,predicate)
for b,a in ipairs(ISInventoryPane.getActualItems(items))do
if predicate(a)then
return a
end
end
return nil
end

local function p(items)
return f(items,SpiffBoy.Handheld.isConsole)
end

local function q(items)
return f(items,SpiffBoy.Cartridges.isCartridge)
end

local function r(item)
return SpiffBoy.Handheld.isConsole(item)and SpiffBoy.Handheld.getCartridge(item)==nil
end

local function s(item)
return SpiffBoy.Handheld.isBattery(item)and item:getCurrentUsesFloat()>0
end

local function t(context,playerObj,console)
local b=e(context,getText("UI_SpiffBoy_PlayHandheld"),playerObj,m,console)
local a=SpiffBoyHandheldWindow.playability(console,playerObj:getPlayerNum())
if a then
l(b,"UI_SpiffBoy_"..a)
end
end

local function u(window)
window:turnOff()
end

local function v(context,console)
if SpiffBoy.ConsoleStatus.isSwitchedOn(console)then
e(context,getText("ContextMenu_Turn_Off"),SpiffBoyHandheldWindow.runningOn(console),u)
end
end

local function w(context)
return function(label,target,onSelect,...)
return e(context,label,target,onSelect,...)
end
end

local function x(context,playerObj,console,battery)
if battery~=nil then
local a=e(context,getText("ContextMenu_Remove_Battery"),playerObj,o,console)
a.iconTexture=getTexture(j)
return
end
local b=playerObj:getInventory():getAllEvalRecurse(s,ArrayList.new())
if b:size()==0 then
return
end
local g=e(context,getText("UI_SpiffBoy_InsertBattery"),playerObj,nil)
g.iconTexture=getTexture(j)
local h=c.subMenu(context,g)
for i=0,b:size()-1 do
local a=b:get(i)
local y=h:addOption(a:getName(),playerObj,n,console,a)
local d=ISInventoryPaneContextMenu.addToolTip()
d:setName(a:getName())
d.description=getText("IGUI_RemainingPercent",luautils.round(math.ceil(a:getCurrentUsesFloat()*100),0))
y.toolTip=d
end
end

local function y(context,playerObj,cartridge,add)
local a=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local b=playerObj:getInventory():getAllEvalRecurse(r,ArrayList.new())
local d=getText("UI_SpiffBoy_InsertInConsole",a)
local g=c.addConsoleChoice(context,add,d,playerObj,b,c.insert,cartridge)
if b:size()==0 then
c.disable(g,getText("UI_SpiffBoy_NoFreeConsole",a))
end
end

local function z(items)
return f(items,SpiffBoy.Handheld.isHeadphones)
end

local function A(items)
return f(items,SpiffBoy.Handheld.isCable)
end

local function B(playerNum,context,items)
local a=getSpecificPlayer(playerNum)
if not a then
return
end
local d=w(context)
local g=q(items)
if g and g:isInPlayerInventory()then
y(context,a,g,d)
end
local h=z(items)
if h and h:isInPlayerInventory()then
SpiffBoy.HeadphonesMenu.addPlugInConsoleOption(context,a,h,d)
end
local i=A(items)
if i and i:isInPlayerInventory()then
SpiffBoy.LinkMenu.addPlugInConsoleOption(context,a,i,d)
end
local b=p(items)
if not b or not b:isInPlayerInventory()then
return
end
t(context,a,b)
v(context,b)
c.addOptions(context,a,b,d,false)
x(context,a,b,SpiffBoy.Handheld.getBattery(b))
SpiffBoy.HeadphonesMenu.addOptions(context,a,b,d)
SpiffBoy.LinkMenu.addOptions(context,a,b,d)
end

Events.OnFillInventoryObjectContextMenu.Add(B)
