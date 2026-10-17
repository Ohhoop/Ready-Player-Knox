require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"

SpiffBoySpeaker={}
SpiffBoySpeaker.__index=SpiffBoySpeaker
local b=SpiffBoySpeaker

local i=0.25
local e=1
local c=0
local j=5000

function b.new(d)
local a=setmetatable({},b)
a.remote=d
a.clips={}
a.missing={}
a.channels={}
for f=1,SpiffBoyChip.VOICES do
a.channels[f]={emitter=FMODSoundEmitter.new(),ref=c,sound=nil,pitch=nil,gain=nil}
end
a.volume=e
a.distanceGain=e
a.endedLoops=0
a.traceStartMs=0
return a
end

function b:setVolume(a)
self.volume=SpiffBoy.clamp(a,0,e)
end

function b:setDistanceGain(a)
self.distanceGain=SpiffBoy.clamp(a,0,e)
end

function b:clipFor(d)
local a=self.clips[d]
if not a then
a=GameSounds.getSound(d):getRandomClip()
self.clips[d]=a
end
return a
end

function b:start(a,d)
local f=a.emitter:playClip(self:clipFor(d),nil)
if f==c then
if not self.missing[d]then
self.missing[d]=true
SpiffBoy.log("the loop "..d.." did not start")
end
return c
end
a.emitter:set3D(f,false)
a.pitch=nil
a.gain=nil
return f
end

function b:traceEndedLoop(d,f)
if not self.remote or not SpiffBoy.isDevBuild()then
return
end
local a=getTimestampMs()
if self.endedLoops==0 then
self.traceStartMs=a
SpiffBoy.log("remote speaker: voice "..tostring(d).." loop "..tostring(f).." stopped by itself")
end
self.endedLoops=self.endedLoops+1
if a-self.traceStartMs>=j then
SpiffBoy.log("remote speaker: "..tostring(self.endedLoops).." loops stopped by themselves in "..tostring(a-self.traceStartMs).." ms")
self.endedLoops=0
end
end

local function h(a,d,f)
if a.pitch~=d then
a.emitter:setPitch(a.ref,d)
a.pitch=d
end
if a.gain~=f then
a.emitter:setVolume(a.ref,f)
a.gain=f
end
end

function b:play(k)
local l=i*self.volume*self.distanceGain*getSoundManager():getSoundVolume()
for f=1,SpiffBoyChip.VOICES do
local d=k.voices[f]
local a=self.channels[f]
local g=a.emitter
if a.ref~=c and not g:isPlaying(a.ref)then
self:traceEndedLoop(f,a.sound)
a.ref=c
a.sound=nil
end
if d.on then
if d.sound~=a.sound then
if a.ref~=c then
g:stopSound(a.ref)
end
a.sound=d.sound
a.ref=self:start(a,d.sound)
end
if a.ref~=c then
h(a,d.pitch,d.gain*l)
end
elseif a.ref~=c then
h(a,a.pitch,0)
end
g:tick()
end
end

function b:silence()
for d=1,SpiffBoyChip.VOICES do
local a=self.channels[d]
a.emitter:stopAll()
a.ref=c
a.sound=nil
end
end

function b:destroy()
self:silence()
local a=getSoundManager()
for d=1,SpiffBoyChip.VOICES do
a:unregisterEmitter(self.channels[d].emitter)
end
end
