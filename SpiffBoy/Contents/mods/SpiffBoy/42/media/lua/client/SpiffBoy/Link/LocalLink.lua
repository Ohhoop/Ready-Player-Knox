require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Link/Links"
require"SpiffBoy/Link/LinkState"

SpiffBoy.LocalLink=SpiffBoy.LocalLink or{}
local e=SpiffBoy.LocalLink
local b=SpiffBoy.Handheld
local i=SpiffBoy.LinkState

local r=1000
local k=1
local m=2

local a={}
local n=0

local function h(c)
return SpiffBoyHandheldWindow.forPlayer(c)
end

local function c(d,f,g)
HaloTextHelper.addText(d,getText("UI_SpiffBoy_"..f,g),"",HaloTextHelper.getColorRed())
end

local function o(d)
local f=a[d]
if not f then
return
end
a[d]=nil
a[f.peer]=nil
for l,g in ipairs({d,f.peer})do
i.clear(g)
local j=h(g)
if j then
j.channel:onDisconnected()
end
end
end

function e.offer(d,f)
local g,j=d:getPlayerNum(),f:getPlayerNum()
if a[g]then
c(d,"CableTaken")
return
end
if not b.consoleWithCable(d)then
c(d,"NoCable")
return
end
if not b.withinCableReach(d,f)then
c(d,"CableTooFar")
return
end
if a[j]or not b.consoleWithFreePort(f)then
c(d,"NoLinkableConsole")
return
end
SpiffBoy.LinkMenu.ask(f,d)
end

function e.decline(f,g)
local d=getSpecificPlayer(g)
if d then
c(d,"CableDeclined",b.characterName(f))
end
end

function e.connect(d,l,t,f)
local j=getSpecificPlayer(f)
if not j then
return
end
local g=d:getPlayerNum()
if a[g]or b.hasCable(l)then
c(d,"PortBusy")
return
end
if a[f]then
c(d,"CableTaken")
return
end
local p=b.consoleWithCable(j)
if not p then
c(d,"NoCable")
return
end
if not b.withinCableReach(d,j)then
c(d,"CableTooFar")
return
end
a[f]={peer=g,console=p:getID(),seat=k}
a[g]={peer=f,console=l:getID(),seat=m}
i.set(f,b.characterName(d),k,nil,g)
i.set(g,b.characterName(j),m,nil,f)
for u,s in ipairs({f,g})do
local q=h(s)
if q then
q.channel:onConnected()
end
end
if not h(g)then
SpiffBoyHandheldWindow.open(d,l)
end
end

function e.disconnect(g,j)
local d=g:getPlayerNum()
local f=a[d]
if f and f.console==j:getID()then
o(d)
end
end

function e.sendData(g,j,l)
local d=a[g:getPlayerNum()]
local f=d and h(d.peer)
if f then
f.channel:onData(j,l)
end
end

function e.sendState(g,j,l)
local d=a[g:getPlayerNum()]
local f=d and h(d.peer)
if f then
f.channel:onState(j,l)
end
end

local function l(p,f)
local d=getSpecificPlayer(p)
local g=getSpecificPlayer(f.peer)
if not d or not g or d:isDead()or g:isDead()or not b.withinCableReach(d,g)then
return false
end
local j=d:getInventory():getItemWithIDRecursiv(f.console)
if not j then
return false
end
return f.seat~=k or b.hasCable(j)
end

local function j()
local f=getTimestampMs()
if f<n then
return
end
n=f+r
local d=nil
for g,p in pairs(a)do
if not l(g,p)then
d=d or{}
d[#d+1]=g
end
end
if d then
for g=1,#d do
o(d[g])
end
end
end

local function d()
for f in pairs(a)do
i.clear(f)
end
a={}
end

if not isClient()then
SpiffBoy.Links.install(e)
end

Events.OnTick.Add(j)
Events.OnGameStart.Add(d)
