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

local function c(a)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("remote speaker: "..a)
end
end

local function q(g)
local a=nil
for l=0,getNumActivePlayers()-1 do
local b=getSpecificPlayer(l)
if b then
local k=math.sqrt((g:getX()-b:getX())^2+(g:getY()-b:getY())^2)
if a==nil or k<a then
a=k
end
end
end
return a
end

local function r(g)
local a=getPlayerByOnlineID(g)
if not a then
return nil
end
local b=q(a)
if not b then
return nil
end
return math.floor(b*10+0.5)/10
end

local function D(a)
if a==nil or a>=p then
return 0
end
if a<=j then
return 1
end
return 1-(a-j)/(p-j)
end

local function k(a)
return SpiffBoy.Cartridges.get(a.c)
end

local function s(a,b)
return a.sequencer~=nil and o.find(a.sequencer.set,b)~=nil
end

local function t(a,b,g)
a.definition=b
a.frozen=false
a.chip:boot()
a.sequencer=SpiffBoySequencer.new(a.chip,o.set(b.id))
a.speaker:setVolume(g)
end

local function E(a)
a.frozen=false
a.chip:halt()
a.sequencer=nil
a.definition=nil
end

local function F(g,a)
local b=g.sequencer
if a.n==nil then
if b:isPlaying()then
b:stop()
end
return
end
if not s(g,a.n)then
return
end
local l,m=b:state()
local u=l~=a.n or math.abs(m-a.p)>y
c("beat of "..tostring(g.id)..": console "..tostring(a.n).." at "..tostring(a.p)..", mirror "..tostring(l).." at "..tostring(m)..", resync "..tostring(u))
if u then
b:resume(a.n,a.p)
end
end

local function u(g)
return function(a,b)
if s(a,b.n)then
g(a.sequencer,b.n)
end
end
end

local G={
[SpiffBoy.CHIP_EVENT_ON]=function(g,a)
local b=k(a)
if b then
t(g,b,a.v)
end
end,
[SpiffBoy.CHIP_EVENT_OFF]=function(a,b)
c("off received from "..tostring(a.id))
E(a)
end,
[SpiffBoy.CHIP_EVENT_VOLUME]=function(a,b)
a.speaker:setVolume(b.v)
end,
[SpiffBoy.CHIP_EVENT_PLAY]=u(SpiffBoySequencer.play),
[SpiffBoy.CHIP_EVENT_STOP]=function(a,b)
c("music stop received from "..tostring(a.id))
if a.sequencer then
a.sequencer:stop()
end
end,
[SpiffBoy.CHIP_EVENT_EFFECT]=u(SpiffBoySequencer.effect),
[SpiffBoy.CHIP_EVENT_WRITE]=function(b,a)
if b.sequencer and n.isRegister(a.r)then
b.chip:apply(a.r,a.v)
end
end,
[SpiffBoy.CHIP_EVENT_WAVE]=function(a,b)
if a.sequencer and w.WAVE[b.n]then
a.chip:applyWave(b.n)
end
end,
[SpiffBoy.CHIP_EVENT_MIX]=function(a,b)
if a.sequencer then
a.sequencer:setMix(b.m,b.f)
end
end,
[SpiffBoy.CHIP_EVENT_FREEZE]=function(a,b)
c("freeze received from "..tostring(a.id))
if a.sequencer then
a.frozen=true
end
end,
[SpiffBoy.CHIP_EVENT_BEAT]=function(b,a)
local g=k(a)
if not g then
return
end
if not b.sequencer then
t(b,g,a.v)
else
b.speaker:setVolume(a.v)
end
b.sequencer:setMix(a.m,a.f)
b.frozen=a.z
F(b,a)
end,
}

local function H(b,a)
if a.k~=SpiffBoy.CHIP_EVENT_ON and a.k~=SpiffBoy.CHIP_EVENT_BEAT then
return nil
end
if not k(a)then
return nil
end
local g={
id=b,
chip=n.new(),
speaker=SpiffBoySpeaker.new(true),
sequencer=nil,
definition=nil,
queue={},
tick=a.t-i,
clock=SpiffBoyClock.new(),
frozen=false,
lastSeenMs=0,
resyncs=0,
resyncTraceMs=0,
}
d[b]=g
e=e+1
c("opened for "..tostring(b)..", cartridge "..tostring(a.c)..", distance "..tostring(r(b)))
return g
end

local function I(a,b)
a.queue[#a.queue+1]=b
if b.t-a.tick>x or b.t<a.tick then
a.resyncs=a.resyncs+1
local g=getTimestampMs()
if g-a.resyncTraceMs>=C then
c("clock of "..tostring(a.id).." moved from "..tostring(a.tick).." to "..tostring(b.t-i)..", "..tostring(a.resyncs).." moves since the last line")
a.resyncTraceMs=g
a.resyncs=0
end
a.tick=b.t-i
end
end

local function J(a)
local b=a.queue
while#b>0 and b[1].t<=a.tick do
local g=table.remove(b,1)
G[g.k](a,g)
end
end

local function K(a,g)
local b=d[a]
if not b then
return
end
c("closed for "..tostring(a)..": "..g..", distance "..tostring(r(a)))
b.speaker:destroy()
d[a]=nil
e=e-1
end

function h.handle(a)
if type(a)~="table"or not SpiffBoy.isInteger(a.id)then
return
end
local l=SpiffBoy.listCount(a.e)
if l>B then
return
end
local b=d[a.id]
for m=1,l do
local g=SpiffBoy.cleanChipEvent(SpiffBoy.listItem(a.e,m))
if g then
if not b then
b=H(a.id,g)
end
if b then
I(b,g)
end
end
end
if b then
b.lastSeenMs=getTimestampMs()
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
