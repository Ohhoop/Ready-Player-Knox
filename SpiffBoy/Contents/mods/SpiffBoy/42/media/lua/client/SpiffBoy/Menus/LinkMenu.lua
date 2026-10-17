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
local h=SpiffBoy.LinkState

local l=350
local m=150
local n="YES"
local o="media/ui/SpiffBoy/Menus/link_cable.png"

local function c(d)
d.iconTexture=SpiffBoy.Textures.get(o,false)
end

local function p(d)
return b.isConsole(d)and not b.hasCable(d)
end

function a.plug(d,e,f)
SpiffBoy.CartridgeMenu.queue(d,e,{{action=SpiffBoyPlugCableAction,item=f}})
end

function a.unplug(d,e)
SpiffBoy.CartridgeMenu.queue(d,e,{{action=SpiffBoyUnplugCableAction}})
end

function a.connect(e,f,g)
local d=SpiffBoyHandheldWindow.shownOn(f)
local i=d and d.poseAction
ISInventoryPaneContextMenu.transferIfNeeded(e,f)
ISTimedActionQueue.add(SpiffBoyConnectCableAction:new(e,f,g:getOnlineID(),g:getPlayerNum()))
if d then
d.poseAction=SpiffBoyPlayHandheldAction:new(e,d)
ISTimedActionQueue.add(d.poseAction)
SpiffBoyPlayHandheldAction.finishFor(i)
end
end

function a.disconnect(d,e)
SpiffBoy.CartridgeMenu.queue(d,e,{{action=SpiffBoyDisconnectCableAction}})
end

function a.offer(d,e)
if isClient()then
SpiffBoy.NetworkLink.offer(d,e:getOnlineID())
return
end
SpiffBoy.LocalLink.offer(d,e)
end

function a.accept(d,e)
local f=b.consoleWithFreePort(d)
if not f then
a.decline(d,e)
return
end
a.connect(d,f,e)
end

function a.decline(d,e)
if isClient()then
SpiffBoy.NetworkLink.decline(d,e:getOnlineID())
return
end
SpiffBoy.LocalLink.decline(d,e:getPlayerNum())
end

local function q(d,e)
if e.internal==n then
a.accept(d.player,d.owner)
else
a.decline(d.player,d.owner)
end
end

function a.ask(f,g)
local e=f:getPlayerNum()
local i={player=f,owner=g}
local d=ISModalDialog:new(0,0,l,m,getText("UI_SpiffBoy_OfferCable",b.characterName(g)),true,i,q,e)
d:initialise()
d:addToUIManager()
d.moveWithMouse=true
if getJoypadData(e)then
d:centerOnScreen(e)
setJoypadFocus(e,d)
end
end

local function i(d)
return b.consoleWithFreePort(d)~=nil and h.of(d:getPlayerNum())==nil
end

local function r(g,j)
local e={}
local f=g:getMovingObjects()
for k=0,f:size()-1 do
local d=f:get(k)
if instanceof(d,"IsoPlayer")and d~=j and not d:isDead()then
e[#e+1]=d
end
end
return e
end

local function s(g,t,u,v)
if v then
return
end
local d=getSpecificPlayer(g)
local j=u[1]
if not d or not j then
return
end
local k=j:getSquare()
if not k or h.of(g)or not b.consoleWithCable(d)then
return
end
for w,e in ipairs(r(k,d))do
local f=t:addOption(getText("UI_SpiffBoy_ConnectCable",b.characterName(e)),d,a.offer,e)
c(f)
if not b.withinCableReach(d,e)then
SpiffBoy.CartridgeMenu.disable(f,getText("UI_SpiffBoy_CableTooFar"))
elseif e:isLocalPlayer()and not i(e)then
SpiffBoy.CartridgeMenu.disable(f,getText("UI_SpiffBoy_NoLinkableConsole"))
end
end
end

local function t(g)
local d={}
if isClient()then
local e=getOnlinePlayers()
for f=0,e:size()-1 do
d[#d+1]=e:get(f)
end
else
for e=0,getNumActivePlayers()-1 do
d[#d+1]=getSpecificPlayer(e)
end
end
local f={}
for j,e in ipairs(d)do
if e and e~=g and not e:isDead()and b.withinCableReach(g,e)then
f[#f+1]=e
end
end
return f
end

function a.plugAndOffer(d,e,g,f)
if b.hasCable(e)then
a.offer(d,f)
return
end
SpiffBoy.CartridgeMenu.queue(d,e,{
{action=SpiffBoyPlugCableAction,item=g},
{timedAction=SpiffBoyOfferCableAction:new(d,e,f)},
})
end

local function u(e,g,j,k)
for v,d in ipairs(t(e))do
local f=k(getText("UI_SpiffBoy_ConnectCable",b.characterName(d)),e,a.plugAndOffer,g,j,d)
c(f)
if d:isLocalPlayer()and not i(d)then
SpiffBoy.CartridgeMenu.disable(f,getText("UI_SpiffBoy_NoLinkableConsole"))
end
end
end

function a.addOptions(v,d,e,g)
local j=h.of(d:getPlayerNum())
if j then
c(g(getText("UI_SpiffBoy_DisconnectCable",j.peerName),d,a.disconnect,e))
return
end
local k=b.hasCable(e)
local f=nil
if k then
c(g(getText("UI_SpiffBoy_UnplugCable"),d,a.unplug,e))
else
f=d:getInventory():getFirstTypeRecurse(SpiffBoy.CABLE_ITEM)
if f then
c(g(getText("UI_SpiffBoy_PlugCable"),d,a.plug,e,f))
end
end
if k or f then
u(d,e,f,g)
end
end

function a.addPlugInConsoleOption(f,d,g,j)
local k=getItemNameFromFullType(SpiffBoy.CONSOLE_ITEM)
local e=d:getInventory():getAllEvalRecurse(p,ArrayList.new())
if e:size()==0 then
return
end
local v=getText("UI_SpiffBoy_PlugInConsole",k)
c(SpiffBoy.CartridgeMenu.addConsoleChoice(f,j,v,d,e,a.plug,g))
end

Events.OnFillWorldObjectContextMenu.Add(s)
