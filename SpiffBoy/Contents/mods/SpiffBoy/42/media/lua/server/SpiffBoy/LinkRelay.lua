if not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Link/Links"

SpiffBoy.LinkRelay=SpiffBoy.LinkRelay or{}
local j=SpiffBoy.LinkRelay
local a=SpiffBoy.Handheld

local r=SpiffBoy.COMMAND_MODULE
local s=1000
local t=1000
local u=40
local k=1
local n=2

local b={}
local o={}
local p=0

local function e(c,d)
d.me=c:getOnlineID()
sendServerCommand(c,r,SpiffBoy.COMMAND_LINK,d)
end

local function d(c,f,g)
e(c,{k=SpiffBoy.LINK_REFUSED,r=f,n=g})
end

local function h(c)
local f=b[c]
if not f then
return
end
b[c]=nil
b[f.peer]=nil
for l,i in ipairs({c,f.peer})do
local g=getPlayerByOnlineID(i)
if g then
e(g,{k=SpiffBoy.LINK_DISCONNECTED})
end
end
end

local function v(c,g)
if not SpiffBoy.isInteger(g.p)then
return
end
local f=getPlayerByOnlineID(g.p)
if not f or f==c then
return
end
local i=c:getOnlineID()
if b[i]then
d(c,"CableTaken")
return
end
if not a.consoleWithCable(c)then
d(c,"NoCable")
return
end
if not a.withinCableReach(c,f)then
d(c,"CableTooFar")
return
end
if b[g.p]or not a.consoleWithFreePort(f)then
d(c,"NoLinkableConsole")
return
end
e(f,{k=SpiffBoy.LINK_OFFER,p=i,n=a.characterName(c)})
end

local function w(g,c)
if not SpiffBoy.isInteger(c.p)then
return
end
local f=getPlayerByOnlineID(c.p)
if f then
d(f,"CableDeclined",a.characterName(g))
end
end

function j.connect(c,l,f,q)
local g=getPlayerByOnlineID(f)
if not g then
return
end
local i=c:getOnlineID()
if b[i]or a.hasCable(l)then
d(c,"PortBusy")
return
end
if b[f]then
d(c,"CableTaken")
return
end
local m=a.consoleWithCable(g)
if not m then
d(c,"NoCable")
return
end
if not a.withinCableReach(c,g)then
d(c,"CableTooFar")
return
end
b[f]={peer=i,console=m:getID(),seat=k}
b[i]={peer=f,console=l:getID(),seat=n}
e(g,{k=SpiffBoy.LINK_CONNECTED,p=i,n=a.characterName(c),s=k})
e(c,{k=SpiffBoy.LINK_CONNECTED,p=f,n=a.characterName(g),s=n,c=l:getID()})
end

function j.disconnect(g,i)
local c=g:getOnlineID()
local f=b[c]
if f and f.console==i:getID()then
h(c)
end
end

local function x(i)
local f=i:getOnlineID()
local g=getTimestampMs()
local c=o[f]
if not c or g-c.startMs>=t then
c={startMs=g,count=0}
o[f]=c
end
c.count=c.count+1
return c.count<=u
end

local function y(g,c)
if type(c)~="table"or not x(g)then
return
end
local f=c.k
if f==SpiffBoy.LINK_OFFER then
v(g,c)
return
end
if f==SpiffBoy.LINK_DECLINE then
w(g,c)
return
end
local l=g:getOnlineID()
if f==SpiffBoy.LINK_DISCONNECT then
h(l)
return
end
local q=b[l]
if not q then
return
end
local m=getPlayerByOnlineID(q.peer)
if not m then
h(l)
return
end
if f==SpiffBoy.LINK_DATA then
local i=SpiffBoy.cleanLinkMessages(c.e)
if i and SpiffBoy.isInteger(c.s)then
e(m,{k=SpiffBoy.LINK_DATA,s=c.s,e=SpiffBoy.wireList(i)})
end
return
end
if f==SpiffBoy.LINK_STATE then
local i=c.c
if(i==nil or(type(i)=="string"and string.len(i)<=SpiffBoy.CHIP_MAX_STRING))and type(c.o)=="boolean"then
e(m,{k=SpiffBoy.LINK_STATE,c=i,o=c.o})
end
end
end

local function l(m,c)
local f=getPlayerByOnlineID(m)
local g=getPlayerByOnlineID(c.peer)
if not f or not g or not a.withinCableReach(f,g)then
return false
end
local i=f:getInventory():getItemWithIDRecursiv(c.console)
if not i then
return false
end
return c.seat~=k or a.hasCable(i)
end

local function i()
local f=getTimestampMs()
if f<p then
return
end
p=f+s
local c=nil
for g,m in pairs(b)do
if not l(g,m)then
c=c or{}
c[#c+1]=g
end
end
if c then
for g=1,#c do
h(c[g])
end
end
end

SpiffBoy.Links.install(j)
SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_LINK,y)

Events.OnTick.Add(i)
