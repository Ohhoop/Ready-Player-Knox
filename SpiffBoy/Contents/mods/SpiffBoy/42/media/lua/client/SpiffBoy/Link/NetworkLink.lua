require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Link/LinkState"

SpiffBoy.NetworkLink=SpiffBoy.NetworkLink or{}
local d=SpiffBoy.NetworkLink
local f=SpiffBoy.LinkState

local i=SpiffBoy.COMMAND_MODULE
local j={[1]=true,[2]=true}

local function k(onlineId)
for b=0,getNumActivePlayers()-1 do
local a=getSpecificPlayer(b)
if a and a:getOnlineID()==onlineId then
return b,a
end
end
return nil
end

local function e(playerObj,args)
sendClientCommand(playerObj,i,SpiffBoy.COMMAND_LINK,args)
end

function d.offer(playerObj,peerId)
e(playerObj,{k=SpiffBoy.LINK_OFFER,p=peerId})
end

function d.decline(playerObj,ownerId)
e(playerObj,{k=SpiffBoy.LINK_DECLINE,p=ownerId})
end

function d.sendData(playerObj,sequence,messages)
e(playerObj,{k=SpiffBoy.LINK_DATA,s=sequence,e=SpiffBoy.wireList(messages)})
end

function d.sendState(playerObj,cartridge,on)
e(playerObj,{k=SpiffBoy.LINK_STATE,c=cartridge,o=on})
end

local function l(player,playerNum,consoleId)
if SpiffBoyHandheldWindow.forPlayer(playerNum)or not SpiffBoy.isInteger(consoleId)then
return
end
local a=player:getInventory():getItemWithIDRecursiv(consoleId)
if a then
SpiffBoyHandheldWindow.open(player,a)
end
end

local function m(args)
if type(args)~="table"or not SpiffBoy.isInteger(args.me)then
return
end
local b,g=k(args.me)
if not b then
return
end
local a=SpiffBoyHandheldWindow.forPlayer(b)
local c=args.k
if c==SpiffBoy.LINK_OFFER then
if SpiffBoy.isInteger(args.p)and type(args.n)=="string"then
local h=getPlayerByOnlineID(args.p)
if h then
SpiffBoy.LinkMenu.ask(g,h)
end
end
elseif c==SpiffBoy.LINK_CONNECTED then
if SpiffBoy.isInteger(args.p)and j[args.s]and type(args.n)=="string"then
f.set(b,args.n,args.s,args.p,nil)
if a then
a.channel:onConnected()
end
l(g,b,args.c)
end
elseif c==SpiffBoy.LINK_DISCONNECTED then
f.clear(b)
if a then
a.channel:onDisconnected()
end
elseif c==SpiffBoy.LINK_REFUSED then
if SpiffBoy.LINK_REFUSALS[args.r]and(args.n==nil or type(args.n)=="string")then
HaloTextHelper.addText(g,getText("UI_SpiffBoy_"..args.r,args.n),"",HaloTextHelper.getColorRed())
if SpiffBoy.isDevBuild()then
SpiffBoy.log("link refused: "..args.r)
end
end
elseif c==SpiffBoy.LINK_DATA then
local h=SpiffBoy.cleanLinkMessages(args.e)
if a and f.of(b)and h and SpiffBoy.isInteger(args.s)then
a.channel:onData(args.s,h)
end
elseif c==SpiffBoy.LINK_STATE then
local h=args.c
if a and(h==nil or type(h)=="string")and type(args.o)=="boolean"then
a.channel:onState(h,args.o)
end
end
end

SpiffBoy.Commands.fromServer(SpiffBoy.COMMAND_LINK,m)
