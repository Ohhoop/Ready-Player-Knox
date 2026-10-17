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
local b=SpiffBoy.Commands

local f={}
local g={}

function SpiffBoy.isInteger(a)
return type(a)=="number"and a==math.floor(a)
end

function SpiffBoy.isFinite(a)
return type(a)=="number"and a==a and math.abs(a)<math.huge
end

function SpiffBoy.listItem(a,c)
return a[c]
end

function SpiffBoy.listCount(a)
if type(a)~="table"or not SpiffBoy.isInteger(a.n)or a.n<0 then
return 0
end
return a.n
end

function SpiffBoy.wireList(a)
local c={n=#a}
for d=1,#a do
c[d]=a[d]
end
return c
end

local function h(a,c)
return type(a)=="string"and string.len(a)<=c
end

local k={
cartridge=function(a)
return h(a,SpiffBoy.CHIP_MAX_STRING)
end,
name=function(a)
return h(a,SpiffBoy.TUNE_NAME_MAX)
end,
unit=function(a)
return SpiffBoy.isFinite(a)and a>=0 and a<=1
end,
byte=function(a)
return SpiffBoy.isInteger(a)and a>=0 and a<=SpiffBoy.BYTE_MAX
end,
count=function(a)
return SpiffBoy.isInteger(a)and a>=0
end,
flag=function(a)
return type(a)=="boolean"
end,
}

local l={
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

function SpiffBoy.cleanChipEvent(a)
if type(a)~="table"or not SpiffBoy.isInteger(a.t)then
return nil
end
local c=l[a.k]
if not c then
return nil
end
local i={t=a.t,k=a.k}
for m=1,#c do
local d=c[m]
local j,n,o=d[1],d[2],d[3]
local e=a[j]
if e==nil then
if not o then
return nil
end
else
if not k[n](e)then
return nil
end
i[j]=e
end
end
return i
end

function SpiffBoy.isLinkMessage(a)
if type(a)~="string"then
return false
end
local c=string.len(a)
if c<1 or c>SpiffBoy.LINK_MESSAGE_MAX then
return false
end
for d=1,c do
if string.byte(a,d)>SpiffBoy.BYTE_MAX then
return false
end
end
return true
end

function SpiffBoy.cleanLinkMessages(c)
local a=SpiffBoy.listCount(c)
if a<1 or a>SpiffBoy.LINK_BATCH_MAX then
return nil
end
local d={}
for e=1,a do
local i=SpiffBoy.listItem(c,e)
if not SpiffBoy.isLinkMessage(i)then
return nil
end
d[e]=i
end
return d
end

function b.fromClient(a,c)
f[a]=c
end

function b.fromServer(a,c)
g[a]=c
end

function b.onClientCommand(d,e,a,i)
if d~=SpiffBoy.COMMAND_MODULE or not a then
return
end
local c=f[e]
if c then
c(a,i)
end
end

function b.onServerCommand(c,d,e)
if c~=SpiffBoy.COMMAND_MODULE then
return
end
local a=g[d]
if a then
a(e)
end
end
