require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Core/Tunes"

SpiffBoySequencer={}
SpiffBoySequencer.__index=SpiffBoySequencer
local a=SpiffBoySequencer
local g=SpiffBoyChip
local b=SpiffBoy.Tunes

local h=1
local k=0
local l=0.25
local m=0.75

function a.new(chip,set)
local c=setmetatable({},a)
c.chip=chip
c.set=set
c.listener=nil
c.music=nil
c.effects={}
c.owners={}
c.channels={}
for d=1,g.VOICES do
c.channels[d]={note=nil,frame=0,period=nil,from=nil,duty=nil,code=nil}
end
c.musicLevel=h
c.effectLevel=h
return c
end

function a:tune(name)
local c=b.find(self.set,name)
if not c then
local d="no game"
if self.set then
d=self.set.id
end
error("SpiffBoy: "..d.." has no tune named "..tostring(name))
end
return c
end

function a:setMix(music,effects)
self.musicLevel=SpiffBoy.clamp(music,0,h)
self.effectLevel=SpiffBoy.clamp(effects,0,h)
if self.listener then
self.listener:onSequencerMix(self.musicLevel,self.effectLevel)
end
end

function a:mix()
return self.musicLevel,self.effectLevel
end

function a:writePeriod(voice,period,flags)
local c=b.REGISTERS[voice]
local d,e=b.periodBytes(period)
self.chip:apply(c.low,d)
self.chip:apply(c.high,flags+e)
end

function a:noteOn(voice,note,gain)
local d=self.chip
local c=self.channels[voice]
local e=b.REGISTERS[voice]
local i=b.scaleLevel(note.level,gain)
local f=note.period
c.from=nil
if f and note.portamento>0 and c.period then
c.from=c.period
f=c.period
end
if voice==g.WAVE then
d:applyWave(note.wave)
d:apply(e.dac,b.DAC_ON)
d:apply(e.level,b.waveCode(note.level,gain)*b.WAVE_LEVEL_SHIFT)
elseif voice==g.NOISE then
d:apply(e.envelope,b.envelopeByte(i,note.envelopeUp,note.envelopePeriod))
d:apply(e.code,note.codes[1])
d:apply(e.high,b.TRIGGER)
else
if note.sweep then
d:apply(e.sweep,note.sweep)
end
d:apply(e.duty,note.duties[1]*b.DUTY_SHIFT)
d:apply(e.envelope,b.envelopeByte(i,note.envelopeUp,note.envelopePeriod))
end
if f then
self:writePeriod(voice,f,b.TRIGGER)
end
c.note=note
c.frame=0
c.period=f
c.duty=note.duties[1]
c.code=note.codes and note.codes[1]or nil
end

function a:applyEvent(voice,event,gain)
if event.off then
self:silence(voice)
return
end
self:noteOn(voice,event,gain)
end

function a:silence(voice)
local c=b.SILENCE[voice]
self.chip:apply(c[1],c[2])
self.channels[voice].note=nil
end

local function n(vibrato,frame)
if not vibrato or frame<vibrato.delay then
return 0
end
local c=((frame-vibrato.delay)%vibrato.speed)/vibrato.speed
local d
if c<l then
d=4*c
elseif c<m then
d=2-4*c
else
d=4*c-4
end
return math.floor(vibrato.depth*d+0.5)
end

function a:stepChannels()
for i=1,g.VOICES do
local d=self.channels[i]
local c=d.note
if c then
local f=d.frame+1
d.frame=f
if c.period then
local e=c.period
if c.periods then
e=c.periods[math.floor(f/c.arpeggioSpeed)%#c.periods+1]
end
if d.from and f<c.portamento then
e=math.floor(d.from+(e-d.from)*f/c.portamento+0.5)
end
e=SpiffBoy.clamp(e+n(c.vibrato,f),0,g.MAX_PERIOD)
if e~=d.period then
d.period=e
self:writePeriod(i,e,k)
end
end
if#c.duties>1 then
local e=c.duties[f%#c.duties+1]
if e~=d.duty then
d.duty=e
self.chip:apply(b.REGISTERS[i].duty,e*b.DUTY_SHIFT)
end
end
if c.codes and#c.codes>1 then
local e=c.codes[math.min(f+1,#c.codes)]
if e~=d.code then
d.code=e
self.chip:apply(b.REGISTERS[i].code,e)
end
end
end
end
end

local function i(name,tune,position)
local d={name=name,tune=tune,position=position,indexes={},last={}}
for f,e in pairs(tune.tracks)do
local c=1
while c<=e.n and e.events[c].t<position do
c=c+1
end
d.indexes[f]=c
end
return d
end

function a:startMusic(name,position)
local d=self:tune(name)
for c=1,g.VOICES do
if not self.owners[c]then
self:silence(c)
end
end
self.music=i(name,d,position)
end

function a:play(name)
if self.listener then
self.listener:onSequencerPlay(name)
end
self:startMusic(name,0)
end

function a:resume(name,position)
self:startMusic(name,position)
end

function a:stop()
if self.listener then
self.listener:onSequencerStop()
end
self:endMusic()
end

function a:endMusic()
if not self.music then
return
end
for c,d in pairs(self.music.tune.tracks)do
if not self.owners[c]then
self:silence(c)
end
end
self.music=nil
end

function a:effect(name)
if self.listener then
self.listener:onSequencerEffect(name)
end
local c=self:tune(name)
local d=i(name,c,0)
for e,f in pairs(c.tracks)do
self.owners[e]=d
end
self.effects[#self.effects+1]=d
end

function a:isPlaying()
return self.music~=nil
end

function a:state()
if not self.music then
return nil,0
end
return self.music.name,self.music.position
end

function a:applyDue(playback,owner,gain)
local o=playback.position
for d,e in pairs(playback.tune.tracks)do
local c=playback.indexes[d]
local f=e.events
while c<=e.n and f[c].t<=o do
local j=f[c]
playback.last[d]=j
if self.owners[d]==owner then
self:applyEvent(d,j,gain)
end
c=c+1
end
playback.indexes[d]=c
end
end

function a:restore(voice)
self:silence(voice)
local c=self.music
if c and c.last[voice]then
self:applyEvent(voice,c.last[voice],self.musicLevel)
end
end

function a:stepMusic()
local c=self.music
if not c then
return
end
self:applyDue(c,nil,self.musicLevel)
c.position=c.position+1
local d=c.tune
if c.position<d.length then
return
end
if not d.loop then
self:endMusic()
return
end
c.position=c.position-(d.length-d.loopStart)
for e,f in pairs(d.tracks)do
c.indexes[e]=f.loopIndex
end
end

function a:stepEffects()
local e=self.effects
local d=1
while d<=#e do
local c=e[d]
self:applyDue(c,c,self.effectLevel)
c.position=c.position+1
if c.position>=c.tune.length then
for f,j in pairs(c.tune.tracks)do
if self.owners[f]==c then
self.owners[f]=nil
self:restore(f)
end
end
table.remove(e,d)
else
d=d+1
end
end
end

function a:step()
self:stepChannels()
self:stepMusic()
self:stepEffects()
end
