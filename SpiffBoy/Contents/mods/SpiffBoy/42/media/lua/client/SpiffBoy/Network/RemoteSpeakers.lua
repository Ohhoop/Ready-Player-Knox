require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/Clock"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Core/Speaker"
require"SpiffBoy/Core/Sequencer"
require"SpiffBoy/Core/Tunes"

SpiffBoy.RemoteSpeakers=SpiffBoy.RemoteSpeakers or{}
local h=SpiffBoy.RemoteSpeakers
local n=SpiffBoyChip
local o=SpiffBoy.Tunes
local w=SpiffBoy.ChipBank

local i=12
local x=60
local y=30
local z=6000
local A=SpiffBoy.MAX_FRAME_MS
local B=SpiffBoy.CHIP_MAX_EVENTS

local C=1000
local j=2
local p=SpiffBoy.HEAR_DISTANCE

local d={}
local e=0
local f=nil

local function c(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("remote speaker: "..message)
end
end

local function q(source)
local a=nil
for k=0,getNumActivePlayers()-1 do
local b=getSpecificPlayer(k)
if b then
local g=math.sqrt((source:getX()-b:getX())^2+(source:getY()-b:getY())^2)
if a==nil or g<a then
a=g
end
end
end
return a
end

local function r(id)
local a=getPlayerByOnlineID(id)
if not a then
return nil
end
local b=q(a)
if not b then
return nil
end
return math.floor(b*10+0.5)/10
end

local function D(distance)
if distance==nil or distance>=p then
return 0
end
if distance<=j then
return 1
end
return 1-(distance-j)/(p-j)
end

local function k(event)
return SpiffBoy.Cartridges.get(event.c)
end

local function s(mirror,name)
return mirror.sequencer~=nil and o.find(mirror.sequencer.set,name)~=nil
end

local function t(mirror,definition,volume)
mirror.definition=definition
mirror.frozen=false
mirror.chip:boot()
mirror.sequencer=SpiffBoySequencer.new(mirror.chip,o.set(definition.id))
mirror.speaker:setVolume(volume)
end

local function E(mirror)
mirror.frozen=false
mirror.chip:halt()
mirror.sequencer=nil
mirror.definition=nil
end

local function F(mirror,event)
local a=mirror.sequencer
if event.n==nil then
if a:isPlaying()then
a:stop()
end
return
end
if not s(mirror,event.n)then
return
end
local b,g=a:state()
local l=b~=event.n or math.abs(g-event.p)>y
c("beat of "..tostring(mirror.id)..": console "..tostring(event.n).." at "..tostring(event.p)..", mirror "..tostring(b).." at "..tostring(g)..", resync "..tostring(l))
if l then
a:resume(event.n,event.p)
end
end

local function u(method)
return function(mirror,event)
if s(mirror,event.n)then
method(mirror.sequencer,event.n)
end
end
end

local G={
[SpiffBoy.CHIP_EVENT_ON]=function(mirror,event)
local a=k(event)
if a then
t(mirror,a,event.v)
end
end,
[SpiffBoy.CHIP_EVENT_OFF]=function(mirror,event)
c("off received from "..tostring(mirror.id))
E(mirror)
end,
[SpiffBoy.CHIP_EVENT_VOLUME]=function(mirror,event)
mirror.speaker:setVolume(event.v)
end,
[SpiffBoy.CHIP_EVENT_PLAY]=u(SpiffBoySequencer.play),
[SpiffBoy.CHIP_EVENT_STOP]=function(mirror,event)
c("music stop received from "..tostring(mirror.id))
if mirror.sequencer then
mirror.sequencer:stop()
end
end,
[SpiffBoy.CHIP_EVENT_EFFECT]=u(SpiffBoySequencer.effect),
[SpiffBoy.CHIP_EVENT_WRITE]=function(mirror,event)
if mirror.sequencer and n.isRegister(event.r)then
mirror.chip:apply(event.r,event.v)
end
end,
[SpiffBoy.CHIP_EVENT_WAVE]=function(mirror,event)
if mirror.sequencer and w.WAVE[event.n]then
mirror.chip:applyWave(event.n)
end
end,
[SpiffBoy.CHIP_EVENT_MIX]=function(mirror,event)
if mirror.sequencer then
mirror.sequencer:setMix(event.m,event.f)
end
end,
[SpiffBoy.CHIP_EVENT_FREEZE]=function(mirror,event)
c("freeze received from "..tostring(mirror.id))
if mirror.sequencer then
mirror.frozen=true
end
end,
[SpiffBoy.CHIP_EVENT_BEAT]=function(mirror,event)
local a=k(event)
if not a then
return
end
if not mirror.sequencer then
t(mirror,a,event.v)
else
mirror.speaker:setVolume(event.v)
end
mirror.sequencer:setMix(event.m,event.f)
mirror.frozen=event.z
F(mirror,event)
end,
}

local function H(id,event)
if event.k~=SpiffBoy.CHIP_EVENT_ON and event.k~=SpiffBoy.CHIP_EVENT_BEAT then
return nil
end
if not k(event)then
return nil
end
local a={
id=id,
chip=n.new(),
speaker=SpiffBoySpeaker.new(true),
sequencer=nil,
definition=nil,
queue={},
tick=event.t-i,
clock=SpiffBoyClock.new(),
frozen=false,
lastSeenMs=0,
resyncs=0,
resyncTraceMs=0,
}
d[id]=a
e=e+1
c("opened for "..tostring(id)..", cartridge "..tostring(event.c)..", distance "..tostring(r(id)))
return a
end

local function I(mirror,event)
mirror.queue[#mirror.queue+1]=event
if event.t-mirror.tick>x or event.t<mirror.tick then
mirror.resyncs=mirror.resyncs+1
local a=getTimestampMs()
if a-mirror.resyncTraceMs>=C then
c("clock of "..tostring(mirror.id).." moved from "..tostring(mirror.tick).." to "..tostring(event.t-i)..", "..tostring(mirror.resyncs).." moves since the last line")
mirror.resyncTraceMs=a
mirror.resyncs=0
end
mirror.tick=event.t-i
end
end

local function J(mirror)
local a=mirror.queue
while#a>0 and a[1].t<=mirror.tick do
local b=table.remove(a,1)
G[b.k](mirror,b)
end
end

local function K(id,reason)
local a=d[id]
if not a then
return
end
c("closed for "..tostring(id)..": "..reason..", distance "..tostring(r(id)))
a.speaker:destroy()
d[id]=nil
e=e-1
end

function h.handle(args)
if type(args)~="table"or not SpiffBoy.isInteger(args.id)then
return
end
local g=SpiffBoy.listCount(args.e)
if g>B then
return
end
local a=d[args.id]
for l=1,g do
local b=SpiffBoy.cleanChipEvent(SpiffBoy.listItem(args.e,l))
if b then
if not a then
a=H(args.id,b)
end
if a then
I(a,b)
end
end
end
if a then
a.lastSeenMs=getTimestampMs()
end
end

function h.update()
if e==0 then
f=nil
return
end
local g=getTimestampMs()
local v=0
if f then
v=math.min(g-f,A)
end
f=g
local L=isGamePaused()
local M=SpiffBoy.consoleRate()
local b=nil
for l,a in pairs(d)do
local m=getPlayerByOnlineID(l)
if not m or g-a.lastSeenMs>z then
b=b or{}
if not m then
b[#b+1]={id=l,reason="player not found"}
else
b[#b+1]={id=l,reason="nothing received for "..tostring(g-a.lastSeenMs).." ms"}
end
else
if not L then
local N=a.clock:advance(v,M)
for O=1,N do
a.tick=a.tick+1
J(a)
if not a.frozen then
if a.sequencer then
a.sequencer:step()
end
a.chip:step()
end
end
end
a.speaker:setDistanceGain(D(q(m)))
a.speaker:play(a.chip)
end
end
if b then
for a=1,#b do
K(b[a].id,b[a].reason)
end
end
end

Events.OnTick.Add(h.update)
