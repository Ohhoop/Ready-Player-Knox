require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"

SpiffBoySpeaker={}
SpiffBoySpeaker.__index=SpiffBoySpeaker
local b=SpiffBoySpeaker

local i=0.25
local e=1
local c=0
local j=5000

function b.new(remote)
local a=setmetatable({},b)
a.remote=remote
a.clips={}
a.missing={}
a.channels={}
for d=1,SpiffBoyChip.VOICES do
a.channels[d]={emitter=FMODSoundEmitter.new(),ref=c,sound=nil,pitch=nil,gain=nil}
end
a.volume=e
a.distanceGain=e
a.endedLoops=0
a.traceStartMs=0
return a
end

function b:setVolume(value)
self.volume=SpiffBoy.clamp(value,0,e)
end

function b:setDistanceGain(value)
self.distanceGain=SpiffBoy.clamp(value,0,e)
end

function b:clipFor(name)
local a=self.clips[name]
if not a then
a=GameSounds.getSound(name):getRandomClip()
self.clips[name]=a
end
return a
end

function b:start(channel,sound)
local a=channel.emitter:playClip(self:clipFor(sound),nil)
if a==c then
if not self.missing[sound]then
self.missing[sound]=true
SpiffBoy.log("the loop "..sound.." did not start")
end
return c
end
channel.emitter:set3D(a,false)
channel.pitch=nil
channel.gain=nil
return a
end

function b:traceEndedLoop(voice,sound)
if not self.remote or not SpiffBoy.isDevBuild()then
return
end
local a=getTimestampMs()
if self.endedLoops==0 then
self.traceStartMs=a
SpiffBoy.log("remote speaker: voice "..tostring(voice).." loop "..tostring(sound).." stopped by itself")
end
self.endedLoops=self.endedLoops+1
if a-self.traceStartMs>=j then
SpiffBoy.log("remote speaker: "..tostring(self.endedLoops).." loops stopped by themselves in "..tostring(a-self.traceStartMs).." ms")
self.endedLoops=0
end
end

local function h(channel,pitch,gain)
if channel.pitch~=pitch then
channel.emitter:setPitch(channel.ref,pitch)
channel.pitch=pitch
end
if channel.gain~=gain then
channel.emitter:setVolume(channel.ref,gain)
channel.gain=gain
end
end

function b:play(chip)
local k=i*self.volume*self.distanceGain*getSoundManager():getSoundVolume()
for f=1,SpiffBoyChip.VOICES do
local d=chip.voices[f]
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
h(a,d.pitch,d.gain*k)
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
