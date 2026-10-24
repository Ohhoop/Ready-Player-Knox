if not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Link/Links"

SpiffBoy.LinkRelay=SpiffBoy.LinkRelay or{}
local h=SpiffBoy.LinkRelay
local a=SpiffBoy.Handheld

local p=SpiffBoy.COMMAND_MODULE
local q=1000
local r=1000
local s=40
local i=1
local l=2

local b={}
local m={}
local n=0

local function d(player,args)
args.me=player:getOnlineID()
sendServerCommand(player,p,SpiffBoy.COMMAND_LINK,args)
end

local function c(player,reason,name)
d(player,{k=SpiffBoy.LINK_REFUSED,r=reason,n=name})
end

local function f(id)
local e=b[id]
if not e then
return
end
b[id]=nil
b[e.peer]=nil
for k,j in ipairs({id,e.peer})do
local g=getPlayerByOnlineID(j)
if g then
d(g,{k=SpiffBoy.LINK_DISCONNECTED})
end
end
end

local function t(owner,args)
if not SpiffBoy.isInteger(args.p)then
return
end
local e=getPlayerByOnlineID(args.p)
if not e or e==owner then
return
end
local g=owner:getOnlineID()
if b[g]then
c(owner,"CableTaken")
return
end
if not a.consoleWithCable(owner)then
c(owner,"NoCable")
return
end
if not a.withinCableReach(owner,e)then
c(owner,"CableTooFar")
return
end
if b[args.p]or not a.consoleWithFreePort(e)then
c(owner,"NoLinkableConsole")
return
end
d(e,{k=SpiffBoy.LINK_OFFER,p=g,n=a.characterName(owner)})
end

local function u(peer,args)
if not SpiffBoy.isInteger(args.p)then
return
end
local e=getPlayerByOnlineID(args.p)
if e then
c(e,"CableDeclined",a.characterName(peer))
end
end

function h.connect(guest,console,ownerId,ownerNum)
local e=getPlayerByOnlineID(ownerId)
if not e then
return
end
local g=guest:getOnlineID()
if b[g]or a.hasCable(console)then
c(guest,"PortBusy")
return
end
if b[ownerId]then
c(guest,"CableTaken")
return
end
local j=a.consoleWithCable(e)
if not j then
c(guest,"NoCable")
return
end
if not a.withinCableReach(guest,e)then
c(guest,"CableTooFar")
return
end
b[ownerId]={peer=g,console=j:getID(),seat=i}
b[g]={peer=ownerId,console=console:getID(),seat=l}
d(e,{k=SpiffBoy.LINK_CONNECTED,p=g,n=a.characterName(guest),s=i})
d(guest,{k=SpiffBoy.LINK_CONNECTED,p=ownerId,n=a.characterName(e),s=l,c=console:getID()})
end

function h.disconnect(character,console)
local e=character:getOnlineID()
local g=b[e]
if g and g.console==console:getID()then
f(e)
end
end

local function v(player)
local g=player:getOnlineID()
local j=getTimestampMs()
local e=m[g]
if not e or j-e.startMs>=r then
e={startMs=j,count=0}
m[g]=e
end
e.count=e.count+1
return e.count<=s
end

local function w(player,args)
if type(args)~="table"or not v(player)then
return
end
local e=args.k
if e==SpiffBoy.LINK_OFFER then
t(player,args)
return
end
if e==SpiffBoy.LINK_DECLINE then
u(player,args)
return
end
local j=player:getOnlineID()
if e==SpiffBoy.LINK_DISCONNECT then
f(j)
return
end
local o=b[j]
if not o then
return
end
local k=getPlayerByOnlineID(o.peer)
if not k then
f(j)
return
end
if e==SpiffBoy.LINK_DATA then
local g=SpiffBoy.cleanLinkMessages(args.e)
if g and SpiffBoy.isInteger(args.s)then
d(k,{k=SpiffBoy.LINK_DATA,s=args.s,e=SpiffBoy.wireList(g)})
end
return
end
if e==SpiffBoy.LINK_STATE then
local g=args.c
if(g==nil or(type(g)=="string"and string.len(g)<=SpiffBoy.CHIP_MAX_STRING))and type(args.o)=="boolean"then
d(k,{k=SpiffBoy.LINK_STATE,c=g,o=args.o})
end
end
end

local function k(id,link)
local e=getPlayerByOnlineID(id)
local g=getPlayerByOnlineID(link.peer)
if not e or not g or not a.withinCableReach(e,g)then
return false
end
local j=e:getInventory():getItemWithIDRecursiv(link.console)
if not j then
return false
end
return link.seat~=i or a.hasCable(j)
end

local function o()
local g=getTimestampMs()
if g<n then
return
end
n=g+q
local e=nil
for j,x in pairs(b)do
if not k(j,x)then
e=e or{}
e[#e+1]=j
end
end
if e then
for j=1,#e do
f(e[j])
end
end
end

SpiffBoy.Links.install(h)
SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_LINK,w)

Events.OnTick.Add(o)
