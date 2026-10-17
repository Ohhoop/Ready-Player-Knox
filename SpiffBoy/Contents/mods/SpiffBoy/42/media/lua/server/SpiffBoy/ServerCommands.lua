require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/SaveData"
require"SpiffBoy/Handheld/Handheld"

local l=SpiffBoy.COMMAND_MODULE
local m=1000
local n=40
local o=5000

local i={}
local e={}

local function p(a,b,c)
sendServerCommand(a,l,b,c)
end

local function j(a)
if SpiffBoy.isFinite(a)then
return a
end
return nil
end

local function q(a)
if type(a)=="table"then
return a
end
return nil
end

local function r(c,a)
if type(a)~="table"or not SpiffBoy.isInteger(a.itemId)then
return
end
local b=c:getInventory():getItemWithIDRecursiv(a.itemId)
if not b or not SpiffBoy.Handheld.isConsole(b)then
return
end
SpiffBoy.Handheld.applySaved(b,q(a.save),j(a.battery),j(a.volume))
syncItemModData(c,b)
end

local function s(d)
local b=d:getOnlineID()
local c=getTimestampMs()
local a=i[b]
if not a or c-a.startMs>=m then
a={startMs=c,count=0}
i[b]=a
end
a.count=a.count+1
return a.count<=n
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
if d-a.startMs>=o then
SpiffBoy.log("chip relay: player "..tostring(b).." in "..tostring(d-a.startMs).." ms, relayed "..a.relayed.." to "..a.listeners.." listeners in all, refused size "..a.size..", rate "..a.rate..", empty "..a.empty)
e[b]=nil
end
end

local function t(a,b)
if type(b)~="table"or not SpiffBoy.isInteger(b.t)then
return
end
local f=SpiffBoy.listCount(b.e)
if f<1 or f>SpiffBoy.CHIP_MAX_EVENTS then
c(a,"size")
return
end
if not s(a)then
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
local u={id=a:getOnlineID(),t=b.t,e=SpiffBoy.wireList(d)}
local k=getOnlinePlayers()
local g=0
for v=0,k:size()-1 do
local h=k:get(v)
if h~=a and SpiffBoy.withinHearing(h,a)then
p(h,SpiffBoy.COMMAND_CHIP,u)
g=g+1
end
end
c(a,"relayed",g)
end

SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_SAVE_HANDHELD,r)
SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_CHIP,t)

Events.OnClientCommand.Add(SpiffBoy.Commands.onClientCommand)
