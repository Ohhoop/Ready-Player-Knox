require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Link/Links"
require"SpiffBoy/Link/LinkState"

SpiffBoy.LocalLink=SpiffBoy.LocalLink or{}
local d=SpiffBoy.LocalLink
local b=SpiffBoy.Handheld
local g=SpiffBoy.LinkState

local o=1000
local i=1
local j=2

local a={}
local k=0

local function f(playerNum)
return SpiffBoyHandheldWindow.forPlayer(playerNum)
end

local function c(player,reason,name)
HaloTextHelper.addText(player,getText("UI_SpiffBoy_"..reason,name),"",HaloTextHelper.getColorRed())
end

local function l(playerNum)
local e=a[playerNum]
if not e then
return
end
a[playerNum]=nil
a[e.peer]=nil
for n,h in ipairs({playerNum,e.peer})do
g.clear(h)
local m=f(h)
if m then
m.channel:onDisconnected()
end
end
end

function d.offer(owner,peer)
local e,h=owner:getPlayerNum(),peer:getPlayerNum()
if a[e]then
c(owner,"CableTaken")
return
end
if not b.consoleWithCable(owner)then
c(owner,"NoCable")
return
end
if not b.withinCableReach(owner,peer)then
c(owner,"CableTooFar")
return
end
if a[h]or not b.consoleWithFreePort(peer)then
c(owner,"NoLinkableConsole")
return
end
SpiffBoy.LinkMenu.ask(peer,owner)
end

function d.decline(peer,ownerNum)
local e=getSpecificPlayer(ownerNum)
if e then
c(e,"CableDeclined",b.characterName(peer))
end
end

function d.connect(guest,console,ownerId,ownerNum)
local h=getSpecificPlayer(ownerNum)
if not h then
return
end
local e=guest:getPlayerNum()
if a[e]or b.hasCable(console)then
c(guest,"PortBusy")
return
end
if a[ownerNum]then
c(guest,"CableTaken")
return
end
local m=b.consoleWithCable(h)
if not m then
c(guest,"NoCable")
return
end
if not b.withinCableReach(guest,h)then
c(guest,"CableTooFar")
return
end
a[ownerNum]={peer=e,console=m:getID(),seat=i}
a[e]={peer=ownerNum,console=console:getID(),seat=j}
g.set(ownerNum,b.characterName(guest),i,nil,e)
g.set(e,b.characterName(h),j,nil,ownerNum)
for q,p in ipairs({ownerNum,e})do
local n=f(p)
if n then
n.channel:onConnected()
end
end
if not f(e)then
SpiffBoyHandheldWindow.open(guest,console)
end
end

function d.disconnect(character,console)
local e=character:getPlayerNum()
local h=a[e]
if h and h.console==console:getID()then
l(e)
end
end

function d.sendData(playerObj,sequence,messages)
local e=a[playerObj:getPlayerNum()]
local h=e and f(e.peer)
if h then
h.channel:onData(sequence,messages)
end
end

function d.sendState(playerObj,cartridge,on)
local e=a[playerObj:getPlayerNum()]
local h=e and f(e.peer)
if h then
h.channel:onState(cartridge,on)
end
end

local function n(playerNum,link)
local e=getSpecificPlayer(playerNum)
local h=getSpecificPlayer(link.peer)
if not e or not h or e:isDead()or h:isDead()or not b.withinCableReach(e,h)then
return false
end
local m=e:getInventory():getItemWithIDRecursiv(link.console)
if not m then
return false
end
return link.seat~=i or b.hasCable(m)
end

local function p()
local h=getTimestampMs()
if h<k then
return
end
k=h+o
local e=nil
for m,q in pairs(a)do
if not n(m,q)then
e=e or{}
e[#e+1]=m
end
end
if e then
for m=1,#e do
l(e[m])
end
end
end

local function e()
for h in pairs(a)do
g.clear(h)
end
a={}
end

if not isClient()then
SpiffBoy.Links.install(d)
end

Events.OnTick.Add(p)
Events.OnGameStart.Add(e)
