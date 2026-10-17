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

local l="Item_Battery"
local m="ContextMenu_ShowCraftRecipesUsed"

local function f(a,b,c,d,...)
return a:insertOptionBefore(getText(m),b,c,d,...)
end

local d=SpiffBoy.CartridgeMenu

local function n(a,b)
d.disable(a,getText(b))
end

local function o(a,b)
SpiffBoyOpenHandheldAction.playFor(a,b)
end

local function p(a,b,c)
d.queue(a,b,{{action=SpiffBoyInsertBatteryAction,item=c}})
end

local function q(c,a)
local b=SpiffBoyHandheldWindow.runningOn(a)
if b then
b:persistHardware()
end
d.queue(c,a,{{action=SpiffBoyRemoveBatteryAction}})
end

local function g(b,c)
for e,a in ipairs(ISInventoryPane.getActualItems(b))do
if c(a)then
return a
end
end
return nil
end

local function r(a)
return g(a,SpiffBoy.Handheld.isConsole)
end

local function s(a)
return g(a,SpiffBoy.Cartridges.isCartridge)
end

local function t(a)
return SpiffBoy.Handheld.isConsole(a)and SpiffBoy.Handheld.getCartridge(a)==nil
end

local function u(a)
return SpiffBoy.Handheld.isBattery(a)and a:getCurrentUsesFloat()>0
end

local function v(e,a,b)
local h=f(e,getText("UI_SpiffBoy_PlayHandheld"),a,o,b)
local c=SpiffBoyHandheldWindow.playability(b,a:getPlayerNum())
if c then
n(h,"UI_SpiffBoy_"..c)
end
end

local function w(a)
a:turnOff()
end

local function x(b,a)
if SpiffBoy.ConsoleStatus.isSwitchedOn(a)then
f(b,getText("ContextMenu_Turn_Off"),SpiffBoyHandheldWindow.runningOn(a),w)
end
end

local function y(a)
return function(b,c,e,...)
return f(a,b,c,e,...)
end
end

local function z(c,a,i,k)
if k~=nil then
local b=f(c,getText("ContextMenu_Remove_Battery"),a,q,i)
b.iconTexture=getTexture(l)
return
end
local e=a:getInventory():getAllEvalRecurse(u,ArrayList.new())
if e:size()==0 then
return
end
local j=f(c,getText("UI_SpiffBoy_InsertBattery"),a,nil)
j.iconTexture=getTexture(l)
local A=d.subMenu(c,j)
for B=0,e:size()-1 do
local b=e:get(B)
local C=A:addOption(b:getName(),a,p,i,b)
local h=ISInventoryPaneContextMenu.addToolTip()
h:setName(b:getName())
h.description=getText("IGUI_RemainingPercent",luautils.round(math.ceil(b:getCurrentUsesFloat()*100),0))
C.toolTip=h
end
end

local function A(e,a,h,i)
local b=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local c=a:getInventory():getAllEvalRecurse(t,ArrayList.new())
local j=getText("UI_SpiffBoy_InsertInConsole",b)
local k=d.addConsoleChoice(e,i,j,a,c,d.insert,h)
if c:size()==0 then
d.disable(k,getText("UI_SpiffBoy_NoFreeConsole",b))
end
end

local function B(a)
return g(a,SpiffBoy.Handheld.isHeadphones)
end

local function C(a)
return g(a,SpiffBoy.Handheld.isCable)
end

local function D(E,a,h)
local b=getSpecificPlayer(E)
if not b then
return
end
local e=y(a)
local i=s(h)
if i and i:isInPlayerInventory()then
A(a,b,i,e)
end
local j=B(h)
if j and j:isInPlayerInventory()then
SpiffBoy.HeadphonesMenu.addPlugInConsoleOption(a,b,j,e)
end
local k=C(h)
if k and k:isInPlayerInventory()then
SpiffBoy.LinkMenu.addPlugInConsoleOption(a,b,k,e)
end
local c=r(h)
if not c or not c:isInPlayerInventory()then
return
end
v(a,b,c)
x(a,c)
d.addOptions(a,b,c,e,false)
z(a,b,c,SpiffBoy.Handheld.getBattery(c))
SpiffBoy.HeadphonesMenu.addOptions(a,b,c,e)
SpiffBoy.LinkMenu.addOptions(a,b,c,e)
end

Events.OnFillInventoryObjectContextMenu.Add(D)
