require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Core/Tunes"

SpiffBoySequencer={}
SpiffBoySequencer.__index=SpiffBoySequencer
local a=SpiffBoySequencer
local g=SpiffBoyChip
local b=SpiffBoy.Tunes

local j=1
local m=0
local n=0.25
local o=0.75

function a.new(d,e)
local c=setmetatable({},a)
c.chip=d
c.set=e
c.listener=nil
c.music=nil
c.effects={}
c.owners={}
c.channels={}
for f=1,g.VOICES do
c.channels[f]={note=nil,frame=0,period=nil,from=nil,duty=nil,code=nil}
end
c.musicLevel=j
c.effectLevel=j
return c
end

function a:tune(c)
local d=b.find(self.set,c)
if not d then
local e="no game"
if self.set then
e=self.set.id
end
error("SpiffBoy: "..e.." has no tune named "..tostring(c))
end
return d
end

function a:setMix(c,d)
self.musicLevel=SpiffBoy.clamp(c,0,j)
self.effectLevel=SpiffBoy.clamp(d,0,j)
if self.listener then
self.listener:onSequencerMix(self.musicLevel,self.effectLevel)
end
end

function a:mix()
return self.musicLevel,self.effectLevel
end

function a:writePeriod(d,e,f)
local c=b.REGISTERS[d]
local h,i=b.periodBytes(e)
self.chip:apply(c.low,h)
self.chip:apply(c.high,f+i)
end

function a:noteOn(h,c,k)
local e=self.chip
local d=self.channels[h]
local f=b.REGISTERS[h]
local l=b.scaleLevel(c.level,k)
local i=c.period
d.from=nil
if i and c.portamento>0 and d.period then
d.from=d.period
i=d.period
end
if h==g.WAVE then
e:applyWave(c.wave)
e:apply(f.dac,b.DAC_ON)
e:apply(f.level,b.waveCode(c.level,k)*b.WAVE_LEVEL_SHIFT)
elseif h==g.NOISE then
e:apply(f.envelope,b.envelopeByte(l,c.envelopeUp,c.envelopePeriod))
e:apply(f.code,c.codes[1])
e:apply(f.high,b.TRIGGER)
else
if c.sweep then
e:apply(f.sweep,c.sweep)
end
e:apply(f.duty,c.duties[1]*b.DUTY_SHIFT)
e:apply(f.envelope,b.envelopeByte(l,c.envelopeUp,c.envelopePeriod))
end
if i then
self:writePeriod(h,i,b.TRIGGER)
end
d.note=c
d.frame=0
d.period=i
d.duty=c.duties[1]
d.code=c.codes and c.codes[1]or nil
end

function a:applyEvent(c,d,e)
if d.off then
self:silence(c)
return
end
self:noteOn(c,d,e)
end

function a:silence(c)
local d=b.SILENCE[c]
self.chip:apply(d[1],d[2])
self.channels[c].note=nil
end

local function l(c,f)
if not c or f<c.delay then
return 0
end
local d=((f-c.delay)%c.speed)/c.speed
local e
if d<n then
e=4*d
elseif d<o then
e=2-4*d
else
e=4*d-4
end
return math.floor(c.depth*e+0.5)
end

function a:stepChannels()
for h=1,g.VOICES do
local d=self.channels[h]
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
e=SpiffBoy.clamp(e+l(c.vibrato,f),0,g.MAX_PERIOD)
if e~=d.period then
d.period=e
self:writePeriod(h,e,m)
end
end
if#c.duties>1 then
local e=c.duties[f%#c.duties+1]
if e~=d.duty then
d.duty=e
self.chip:apply(b.REGISTERS[h].duty,e*b.DUTY_SHIFT)
end
end
if c.codes and#c.codes>1 then
local e=c.codes[math.min(f+1,#c.codes)]
if e~=d.code then
d.code=e
self.chip:apply(b.REGISTERS[h].code,e)
end
end
end
end
end

local function h(k,d,e)
local f={name=k,tune=d,position=e,indexes={},last={}}
for p,i in pairs(d.tracks)do
local c=1
while c<=i.n and i.events[c].t<e do
c=c+1
end
f.indexes[p]=c
end
return f
end

function a:startMusic(c,e)
local f=self:tune(c)
for d=1,g.VOICES do
if not self.owners[d]then
self:silence(d)
end
end
self.music=h(c,f,e)
end

function a:play(c)
if self.listener then
self.listener:onSequencerPlay(c)
end
self:startMusic(c,0)
end

function a:resume(c,d)
self:startMusic(c,d)
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

function a:effect(c)
if self.listener then
self.listener:onSequencerEffect(c)
end
local d=self:tune(c)
local e=h(c,d,0)
for f,i in pairs(d.tracks)do
self.owners[f]=e
end
self.effects[#self.effects+1]=e
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

function a:applyDue(d,p,q)
local r=d.position
for e,f in pairs(d.tune.tracks)do
local c=d.indexes[e]
local i=f.events
while c<=f.n and i[c].t<=r do
local k=i[c]
d.last[e]=k
if self.owners[e]==p then
self:applyEvent(e,k,q)
end
c=c+1
end
d.indexes[e]=c
end
end

function a:restore(c)
self:silence(c)
local d=self.music
if d and d.last[c]then
self:applyEvent(c,d.last[c],self.musicLevel)
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
for f,i in pairs(c.tune.tracks)do
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
