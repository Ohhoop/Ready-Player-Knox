require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Link/LinkState"

SpiffBoy.NetworkLink=SpiffBoy.NetworkLink or{}
local e=SpiffBoy.NetworkLink
local g=SpiffBoy.LinkState

local j=SpiffBoy.COMMAND_MODULE
local k={[1]=true,[2]=true}

local function l(c)
for b=0,getNumActivePlayers()-1 do
local a=getSpecificPlayer(b)
if a and a:getOnlineID()==c then
return b,a
end
end
return nil
end

local function f(a,b)
sendClientCommand(a,j,SpiffBoy.COMMAND_LINK,b)
end

function e.offer(a,b)
f(a,{k=SpiffBoy.LINK_OFFER,p=b})
end

function e.decline(a,b)
f(a,{k=SpiffBoy.LINK_DECLINE,p=b})
end

function e.sendData(a,b,c)
f(a,{k=SpiffBoy.LINK_DATA,s=b,e=SpiffBoy.wireList(c)})
end

function e.sendState(a,b,c)
f(a,{k=SpiffBoy.LINK_STATE,c=b,o=c})
end

local function m(a,d,b)
if SpiffBoyHandheldWindow.forPlayer(d)or not SpiffBoy.isInteger(b)then
return
end
local c=a:getInventory():getItemWithIDRecursiv(b)
if c then
SpiffBoyHandheldWindow.open(a,c)
end
end

local function n(a)
if type(a)~="table"or not SpiffBoy.isInteger(a.me)then
return
end
local c,h=l(a.me)
if not c then
return
end
local b=SpiffBoyHandheldWindow.forPlayer(c)
local d=a.k
if d==SpiffBoy.LINK_OFFER then
if SpiffBoy.isInteger(a.p)and type(a.n)=="string"then
local i=getPlayerByOnlineID(a.p)
if i then
SpiffBoy.LinkMenu.ask(h,i)
end
end
elseif d==SpiffBoy.LINK_CONNECTED then
if SpiffBoy.isInteger(a.p)and k[a.s]and type(a.n)=="string"then
g.set(c,a.n,a.s,a.p,nil)
if b then
b.channel:onConnected()
end
m(h,c,a.c)
end
elseif d==SpiffBoy.LINK_DISCONNECTED then
g.clear(c)
if b then
b.channel:onDisconnected()
end
elseif d==SpiffBoy.LINK_REFUSED then
if SpiffBoy.LINK_REFUSALS[a.r]and(a.n==nil or type(a.n)=="string")then
HaloTextHelper.addText(h,getText("UI_SpiffBoy_"..a.r,a.n),"",HaloTextHelper.getColorRed())
if SpiffBoy.isDevBuild()then
SpiffBoy.log("link refused: "..a.r)
end
end
elseif d==SpiffBoy.LINK_DATA then
local i=SpiffBoy.cleanLinkMessages(a.e)
if b and g.of(c)and i and SpiffBoy.isInteger(a.s)then
b.channel:onData(a.s,i)
end
elseif d==SpiffBoy.LINK_STATE then
local i=a.c
if b and(i==nil or type(i)=="string")and type(a.o)=="boolean"then
b.channel:onState(i,a.o)
end
end
end

SpiffBoy.Commands.fromServer(SpiffBoy.COMMAND_LINK,n)
