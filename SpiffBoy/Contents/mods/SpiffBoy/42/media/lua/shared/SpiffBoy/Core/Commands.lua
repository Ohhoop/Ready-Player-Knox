require"SpiffBoy/Core/Core"

SpiffBoy.COMMAND_SAVE_HANDHELD="saveHandheld"
SpiffBoy.COMMAND_CHIP="chip"
SpiffBoy.CHIP_EVENT_ON="on"
SpiffBoy.CHIP_EVENT_OFF="off"
SpiffBoy.CHIP_EVENT_VOLUME="vol"
SpiffBoy.CHIP_EVENT_PLAY="play"
SpiffBoy.CHIP_EVENT_STOP="stop"
SpiffBoy.CHIP_EVENT_EFFECT="fx"
SpiffBoy.CHIP_EVENT_WRITE="w"
SpiffBoy.CHIP_EVENT_WAVE="wave"
SpiffBoy.CHIP_EVENT_BEAT="beat"
SpiffBoy.CHIP_EVENT_MIX="mix"
SpiffBoy.CHIP_EVENT_FREEZE="freeze"
SpiffBoy.CHIP_MAX_EVENTS=64
SpiffBoy.CHIP_MAX_STRING=64
SpiffBoy.TUNE_NAME_MAX=32
SpiffBoy.COMMAND_LINK="link"
SpiffBoy.LINK_CONNECTED="connected"
SpiffBoy.LINK_DISCONNECTED="disconnected"
SpiffBoy.LINK_REFUSED="refused"
SpiffBoy.LINK_DISCONNECT="disconnect"
SpiffBoy.LINK_OFFER="offer"
SpiffBoy.LINK_DECLINE="decline"
SpiffBoy.LINK_DATA="data"
SpiffBoy.LINK_STATE="state"
SpiffBoy.LINK_MESSAGE_MAX=16
SpiffBoy.LINK_MESSAGES_PER_TICK=4
SpiffBoy.LINK_BATCH_MAX=24
SpiffBoy.LINK_REFUSALS={CableTooFar=true,CableTaken=true,NoCable=true,PortBusy=true,NoLinkableConsole=true,CableDeclined=true}

SpiffBoy.Commands=SpiffBoy.Commands or{}
local a=SpiffBoy.Commands

local e={}
local f={}

function SpiffBoy.isInteger(value)
return type(value)=="number"and value==math.floor(value)
end

function SpiffBoy.isFinite(value)
return type(value)=="number"and value==value and math.abs(value)<math.huge
end

function SpiffBoy.listItem(list,index)
return list[index]
end

function SpiffBoy.listCount(list)
if type(list)~="table"or not SpiffBoy.isInteger(list.n)or list.n<0 then
return 0
end
return list.n
end

function SpiffBoy.wireList(items)
local b={n=#items}
for c=1,#items do
b[c]=items[c]
end
return b
end

local function g(value,maxLength)
return type(value)=="string"and string.len(value)<=maxLength
end

local j={
cartridge=function(value)
return g(value,SpiffBoy.CHIP_MAX_STRING)
end,
name=function(value)
return g(value,SpiffBoy.TUNE_NAME_MAX)
end,
unit=function(value)
return SpiffBoy.isFinite(value)and value>=0 and value<=1
end,
byte=function(value)
return SpiffBoy.isInteger(value)and value>=0 and value<=SpiffBoy.BYTE_MAX
end,
count=function(value)
return SpiffBoy.isInteger(value)and value>=0
end,
flag=function(value)
return type(value)=="boolean"
end,
}

local k={
[SpiffBoy.CHIP_EVENT_ON]={{"c","cartridge"},{"v","unit"}},
[SpiffBoy.CHIP_EVENT_OFF]={},
[SpiffBoy.CHIP_EVENT_VOLUME]={{"v","unit"}},
[SpiffBoy.CHIP_EVENT_PLAY]={{"n","name"}},
[SpiffBoy.CHIP_EVENT_STOP]={},
[SpiffBoy.CHIP_EVENT_EFFECT]={{"n","name"}},
[SpiffBoy.CHIP_EVENT_WRITE]={{"r","byte"},{"v","byte"}},
[SpiffBoy.CHIP_EVENT_WAVE]={{"n","name"}},
[SpiffBoy.CHIP_EVENT_MIX]={{"m","unit"},{"f","unit"}},
[SpiffBoy.CHIP_EVENT_BEAT]={{"c","cartridge"},{"v","unit"},{"n","name",true},{"p","count"},{"m","unit"},{"f","unit"},{"z","flag"}},
[SpiffBoy.CHIP_EVENT_FREEZE]={},
}

function SpiffBoy.cleanChipEvent(event)
if type(event)~="table"or not SpiffBoy.isInteger(event.t)then
return nil
end
local b=k[event.k]
if not b then
return nil
end
local h={t=event.t,k=event.k}
for l=1,#b do
local c=b[l]
local i,m,n=c[1],c[2],c[3]
local d=event[i]
if d==nil then
if not n then
return nil
end
else
if not j[m](d)then
return nil
end
h[i]=d
end
end
return h
end

function SpiffBoy.isLinkMessage(value)
if type(value)~="string"then
return false
end
local b=string.len(value)
if b<1 or b>SpiffBoy.LINK_MESSAGE_MAX then
return false
end
for c=1,b do
if string.byte(value,c)>SpiffBoy.BYTE_MAX then
return false
end
end
return true
end

function SpiffBoy.cleanLinkMessages(list)
local b=SpiffBoy.listCount(list)
if b<1 or b>SpiffBoy.LINK_BATCH_MAX then
return nil
end
local c={}
for d=1,b do
local h=SpiffBoy.listItem(list,d)
if not SpiffBoy.isLinkMessage(h)then
return nil
end
c[d]=h
end
return c
end

function a.fromClient(command,handler)
e[command]=handler
end

function a.fromServer(command,handler)
f[command]=handler
end

function a.onClientCommand(module,command,player,args)
if module~=SpiffBoy.COMMAND_MODULE or not player then
return
end
local b=e[command]
if b then
b(player,args)
end
end

function a.onServerCommand(module,command,args)
if module~=SpiffBoy.COMMAND_MODULE then
return
end
local b=f[command]
if b then
b(args)
end
end
