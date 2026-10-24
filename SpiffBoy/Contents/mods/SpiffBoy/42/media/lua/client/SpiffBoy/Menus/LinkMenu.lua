require"ISUI/ISContextMenu"
require"ISUI/ISModalDialog"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Textures"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/HandheldAction"
require"SpiffBoy/Link/LinkState"
require"SpiffBoy/Link/LocalLink"
require"SpiffBoy/Link/NetworkLink"
require"SpiffBoy/Link/OfferCableAction"
require"SpiffBoy/Menus/CartridgeMenu"

SpiffBoy.LinkMenu=SpiffBoy.LinkMenu or{}
local a=SpiffBoy.LinkMenu
local b=SpiffBoy.Handheld
local f=SpiffBoy.LinkState

local k=350
local l=150
local m="YES"
local n="media/ui/SpiffBoy/Menus/link_cable.png"

local function c(option)
option.iconTexture=SpiffBoy.Textures.get(SpiffBoy.MOD_ID,n,false)
end

local function o(item)
return b.isConsole(item)and not b.hasCable(item)
end

function a.plug(playerObj,console,cable)
SpiffBoy.CartridgeMenu.queue(playerObj,console,{{action=SpiffBoyPlugCableAction,item=cable}})
end

function a.unplug(playerObj,console)
SpiffBoy.CartridgeMenu.queue(playerObj,console,{{action=SpiffBoyUnplugCableAction}})
end

function a.connect(playerObj,console,owner)
local d=SpiffBoyHandheldWindow.shownOn(console)
local e=d and d.poseAction
ISInventoryPaneContextMenu.transferIfNeeded(playerObj,console)
ISTimedActionQueue.add(SpiffBoyConnectCableAction:new(playerObj,console,owner:getOnlineID(),owner:getPlayerNum()))
if d then
d.poseAction=SpiffBoyPlayHandheldAction:new(playerObj,d)
ISTimedActionQueue.add(d.poseAction)
SpiffBoyPlayHandheldAction.finishFor(e)
end
end

function a.disconnect(playerObj,console)
SpiffBoy.CartridgeMenu.queue(playerObj,console,{{action=SpiffBoyDisconnectCableAction}})
end

function a.offer(playerObj,peer)
if isClient()then
SpiffBoy.NetworkLink.offer(playerObj,peer:getOnlineID())
return
end
SpiffBoy.LocalLink.offer(playerObj,peer)
end

function a.accept(playerObj,owner)
local d=b.consoleWithFreePort(playerObj)
if not d then
a.decline(playerObj,owner)
return
end
a.connect(playerObj,d,owner)
end

function a.decline(playerObj,owner)
if isClient()then
SpiffBoy.NetworkLink.decline(playerObj,owner:getOnlineID())
return
end
SpiffBoy.LocalLink.decline(playerObj,owner:getPlayerNum())
end

local function p(offer,button)
if button.internal==m then
a.accept(offer.player,offer.owner)
else
a.decline(offer.player,offer.owner)
end
end

function a.ask(playerObj,owner)
local e=playerObj:getPlayerNum()
local g={player=playerObj,owner=owner}
local d=ISModalDialog:new(0,0,k,l,getText("UI_SpiffBoy_OfferCable",b.characterName(owner)),true,g,p,e)
d:initialise()
d:addToUIManager()
d.moveWithMouse=true
if getJoypadData(e)then
d:centerOnScreen(e)
setJoypadFocus(e,d)
end
end

local function h(peer)
return b.consoleWithFreePort(peer)~=nil and f.of(peer:getPlayerNum())==nil
end

local function q(square,playerObj)
local e={}
local g=square:getMovingObjects()
for i=0,g:size()-1 do
local d=g:get(i)
if instanceof(d,"IsoPlayer")and d~=playerObj and not d:isDead()then
e[#e+1]=d
end
end
return e
end

local function r(playerNum,context,worldobjects,test)
if test then
return
end
local d=getSpecificPlayer(playerNum)
local i=worldobjects[1]
if not d or not i then
return
end
local j=i:getSquare()
if not j or f.of(playerNum)or not b.consoleWithCable(d)then
return
end
for s,e in ipairs(q(j,d))do
local g=context:addOption(getText("UI_SpiffBoy_ConnectCable",b.characterName(e)),d,a.offer,e)
c(g)
if not b.withinCableReach(d,e)then
SpiffBoy.CartridgeMenu.disable(g,getText("UI_SpiffBoy_CableTooFar"))
elseif e:isLocalPlayer()and not h(e)then
SpiffBoy.CartridgeMenu.disable(g,getText("UI_SpiffBoy_NoLinkableConsole"))
end
end
end

local function i(playerObj)
local d={}
if isClient()then
local e=getOnlinePlayers()
for g=0,e:size()-1 do
d[#d+1]=e:get(g)
end
else
for e=0,getNumActivePlayers()-1 do
d[#d+1]=getSpecificPlayer(e)
end
end
local g={}
for j,e in ipairs(d)do
if e and e~=playerObj and not e:isDead()and b.withinCableReach(playerObj,e)then
g[#g+1]=e
end
end
return g
end

function a.plugAndOffer(playerObj,console,cable,peer)
if b.hasCable(console)then
a.offer(playerObj,peer)
return
end
SpiffBoy.CartridgeMenu.queue(playerObj,console,{
{action=SpiffBoyPlugCableAction,item=cable},
{timedAction=SpiffBoyOfferCableAction:new(playerObj,console,peer)},
})
end

local function j(playerObj,console,cable,add)
for g,d in ipairs(i(playerObj))do
local e=add(getText("UI_SpiffBoy_ConnectCable",b.characterName(d)),playerObj,a.plugAndOffer,console,cable,d)
c(e)
if d:isLocalPlayer()and not h(d)then
SpiffBoy.CartridgeMenu.disable(e,getText("UI_SpiffBoy_NoLinkableConsole"))
end
end
end

function a.addOptions(context,playerObj,console,add)
local e=f.of(playerObj:getPlayerNum())
if e then
c(add(getText("UI_SpiffBoy_DisconnectCable",e.peerName),playerObj,a.disconnect,console))
return
end
local g=b.hasCable(console)
local d=nil
if g then
c(add(getText("UI_SpiffBoy_UnplugCable"),playerObj,a.unplug,console))
else
d=playerObj:getInventory():getFirstTypeRecurse(SpiffBoy.CABLE_ITEM)
if d then
c(add(getText("UI_SpiffBoy_PlugCable"),playerObj,a.plug,console,d))
end
end
if g or d then
j(playerObj,console,d,add)
end
end

function a.addPlugInConsoleOption(context,playerObj,cable,add)
local e=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local d=playerObj:getInventory():getAllEvalRecurse(o,ArrayList.new())
if d:size()==0 then
return
end
local g=getText("UI_SpiffBoy_PlugInConsole",e)
c(SpiffBoy.CartridgeMenu.addConsoleChoice(context,add,g,playerObj,d,a.plug,cable))
end

Events.OnFillWorldObjectContextMenu.Add(r)
