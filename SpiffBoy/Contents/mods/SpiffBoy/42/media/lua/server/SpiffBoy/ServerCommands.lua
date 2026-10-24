require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/SaveData"
require"SpiffBoy/Handheld/Handheld"

local k=SpiffBoy.COMMAND_MODULE
local l=1000
local m=40
local n=5000
local o=1000
local p=10

local g={}
local h={}
local d={}

local function q(player,command,args)
sendServerCommand(player,k,command,args)
end

local function i(value)
if SpiffBoy.isFinite(value)then
return value
end
return nil
end

local function r(player)
local b=player:getOnlineID()
local c=getTimestampMs()
local a=h[b]
if not a or c-a.startMs>=o then
a={startMs=c,count=0}
h[b]=a
end
a.count=a.count+1
return a.count<=p
end

local function s(player,args)
if type(args)~="table"or not SpiffBoy.isInteger(args.itemId)then
return
end
if not r(player)then
SpiffBoy.trace("save of player "..tostring(player:getOnlineID()).." refused by the rate")
return
end
if args.save~=nil then
local a=SpiffBoy.SaveData.check(args.save)
if a then
SpiffBoy.log("save of player "..tostring(player:getOnlineID()).." refused: "..a)
return
end
end
local a=player:getInventory():getItemWithIDRecursiv(args.itemId)
if not a or not SpiffBoy.Handheld.isConsole(a)then
return
end
SpiffBoy.Handheld.applySaved(a,args.save,i(args.battery),i(args.volume))
syncItemModData(player,a)
end

local function t(player)
local b=player:getOnlineID()
local c=getTimestampMs()
local a=g[b]
if not a or c-a.startMs>=l then
a={startMs=c,count=0}
g[b]=a
end
a.count=a.count+1
return a.count<=m
end

local function b(player,outcome,listeners)
if not SpiffBoy.isDevBuild()then
return
end
local c=player:getOnlineID()
local e=getTimestampMs()
local a=d[c]
if not a then
a={startMs=e,relayed=0,listeners=0,size=0,rate=0,empty=0}
d[c]=a
end
a[outcome]=a[outcome]+1
a.listeners=a.listeners+(listeners or 0)
if e-a.startMs>=n then
SpiffBoy.log("chip relay: player "..tostring(c).." in "..tostring(e-a.startMs).." ms, relayed "..a.relayed.." to "..a.listeners.." listeners in all, refused size "..a.size..", rate "..a.rate..", empty "..a.empty)
d[c]=nil
end
end

local function u(player,args)
if type(args)~="table"or not SpiffBoy.isInteger(args.t)then
return
end
local c=SpiffBoy.listCount(args.e)
if c<1 or c>SpiffBoy.CHIP_MAX_EVENTS then
b(player,"size")
return
end
if not t(player)then
b(player,"rate")
return
end
local a={}
for f=1,c do
local e=SpiffBoy.cleanChipEvent(SpiffBoy.listItem(args.e,f))
if e then
a[#a+1]=e
end
end
if#a==0 then
b(player,"empty")
return
end
local v={id=player:getOnlineID(),t=args.t,e=SpiffBoy.wireList(a)}
local j=getOnlinePlayers()
local e=0
for w=0,j:size()-1 do
local f=j:get(w)
if f~=player and SpiffBoy.withinHearing(f,player)then
q(f,SpiffBoy.COMMAND_CHIP,v)
e=e+1
end
end
b(player,"relayed",e)
end

SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_SAVE_HANDHELD,s)
SpiffBoy.Commands.fromClient(SpiffBoy.COMMAND_CHIP,u)

Events.OnClientCommand.Add(SpiffBoy.Commands.onClientCommand)
