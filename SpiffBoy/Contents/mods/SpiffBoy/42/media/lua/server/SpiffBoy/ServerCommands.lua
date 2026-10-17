require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/SaveData"
require"SpiffBoy/Handheld/Handheld"

local m=SpiffBoy.COMMAND_MODULE
local n=1000
local o=40
local p=5000
local q=1000
local r=10

local i={}
local j={}
local e={}

local function s(a,b,c)
sendServerCommand(a,m,b,c)
end

local function k(a)
if SpiffBoy.isFinite(a)then
return a
end
return nil
end

local function t(d)
local b=d:getOnlineID()
local c=getTimestampMs()
local a=j[b]
if not a or c-a.startMs>=q then
a={startMs=c,count=0}
j[b]=a
end
a.count=a.count+1
return a.count<=r
end

local function u(b,a)
if type(a)~="table"or not SpiffBoy.isInteger(a.itemId)then
return
end
if not t(b)then
SpiffBoy.trace("save of player "..tostring(b:getOnlineID()).." refused by the rate")
return
end
if a.save~=nil then
local c=SpiffBoy.SaveData.check(a.save)
if c then
SpiffBoy.log("save of player "..tostring(b:getOnlineID()).." refused: "..c)
return
end
end
local c=b:getInventory():getItemWithIDRecursiv(a.itemId)
if not c or not SpiffBoy.Handheld.isConsole(c)then
return
end
SpiffBoy.Handheld.applySaved(c,a.save,k(a.battery),k(a.volume))
syncItemModData(b,c)
end

local function v(d)
local b=d:getOnlineID()
local c=getTimestampMs()
local a=i[b]
if not a or c-a.startMs>=n then
a={startMs=c,count=0}
i[b]=a
end
a.count=a.count+1
return a.count<=o
end

local function c(g,f,h)
if not SpiffBoy.isDevBuild()then
return
end
local b=g:getOnlineID()
local d=getTimestampMs()
local a=e[b]
if not a then
a={startMs=d,relayed=0,listeners=0,size=0,rate=0,empty=0}
e[b]=a
end
a[f]=a[f]+1
a.listeners=a.listeners+(h or 0)
if d-a.startMs>=p then
SpiffBoy.log("chip relay: player "..tostring(b).." in "..tostring(d-a.startMs).." ms, relayed "..a.relayed.." to "..a.listeners.." listeners in all, refused size "..a.size..", rate "..a.rate..", empty "..a.empty)
e[b]=nil
end
end

local function w(a,b)
if type(b)~="table"or not SpiffBoy.isInteger(b.t)then
return
end
local f=SpiffBoy.listCount(b.e)
if f<1 or f>SpiffBoy.CHIP_MAX_EVENTS then
c(a,"size")
return
end
if not v(a)then
c(a,"rate")
return
end
local d={}
for h=1,f do
local g=SpiffBoy.cleanChipEvent(SpiffBoy.listItem(b.e,h))
if g then
d[#d+1]=g
end
end
if#d==0 then
c(a,"empty")
return
end
local x={id=a:getOnlineID(),t=b.t,e=SpiffBoy.wireList(d)}
local l=getOnlinePlayers()
local g=0
for y=0,l:size()-1 do
local h=l:get(y)
if h~=a and SpiffBoy.withinHearing(h,a)then
s(h,SpiffBoy.COMMAND_CHIP,x)
g=g+1
end
end
c(a,"relayed",g)
end

SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_SAVE_HANDHELD,u)
SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_CHIP,w)

Events.OnClientCommand.Add(SpiffBoy.Commands.onClientCommand)
