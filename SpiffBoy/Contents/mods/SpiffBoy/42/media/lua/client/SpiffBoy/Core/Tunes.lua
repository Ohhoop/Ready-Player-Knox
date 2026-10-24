require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.Tunes=SpiffBoy.Tunes or{}
local f=SpiffBoy.Tunes
local b=SpiffBoyChip
local z=SpiffBoy.ChipBank

f.VOICE_KEYS={pulse1=b.PULSE1,pulse2=b.PULSE2,wave=b.WAVE,noise=b.NOISE}
f.SILENCE={
[b.PULSE1]={b.NR12,0},
[b.PULSE2]={b.NR22,0},
[b.WAVE]={b.NR30,0},
[b.NOISE]={b.NR42,0},
}
f.REGISTERS={
[b.PULSE1]={sweep=b.NR10,duty=b.NR11,envelope=b.NR12,low=b.NR13,high=b.NR14},
[b.PULSE2]={duty=b.NR21,envelope=b.NR22,low=b.NR23,high=b.NR24},
[b.WAVE]={dac=b.NR30,level=b.NR32,low=b.NR33,high=b.NR34},
[b.NOISE]={envelope=b.NR42,code=b.NR43,high=b.NR44},
}
f.TRIGGER=0x80
f.DAC_ON=0x80
f.DUTY_SHIFT=64
f.LEVEL_SHIFT=16
f.WAVE_LEVEL_SHIFT=32
f.PERIOD_HIGH=256

local R=SpiffBoy.TICK_RATE
local S=240
local T=120
local U=4
local V=4
local W=15
local X=3
local Y=2
local Z=1
local o=8
local i=1
local j=64
local k=1
local l=8
local _=20
local aa=400
local A=b.MAX_LEVEL
local ab=3
local ac=7
local q=3
local B=16
local ad=7
local ae=7
local C=64
local D=65536
local E=8
local af=16
local ag=64
local ah=2
local ai=64
local aj=255
local ak=255
local F=32
local G=A
local r=12
local H={c=0,d=2,e=4,f=5,g=7,a=9,b=11}
local al=440
local am=4*r+9
local an=8
local ao=8
local ap=16
local I=1000000
local aq={[0]=0,[1]=0.25,[2]=0.5,[3]=1}
local ar=0.75
local as=0.375
local at=0.125
local au=1
local av=2
local aw=3
local ax={[b.PULSE1]=b.PULSE_CLOCK,[b.PULSE2]=b.PULSE_CLOCK,[b.WAVE]=b.WAVE_CLOCK}
local J={[b.PULSE1]=true,[b.PULSE2]=true}

local s={}

local function ay(index)
return al*2^((index-am)/r)
end

local function az(frequency,clock)
local a=b.MAX_PERIOD+1-math.floor(clock/frequency+0.5)
if a<0 or a>b.MAX_PERIOD then
return nil
end
return a
end

local function m(time)
return math.floor(time*I+0.5)/I
end

local function t(tempo,length,dots)
local d=R*S/tempo
local a=d/length
local c=a
for e=1,dots do
a=a/2
c=c+a
end
return c
end

function f.periodBytes(period)
return period%f.PERIOD_HIGH,math.floor(period/f.PERIOD_HIGH)
end

function f.envelopeByte(level,up,period)
local a=level*f.LEVEL_SHIFT+period
if up then
a=a+an
end
return a
end

function f.scaleLevel(level,gain)
return math.floor(level*gain+0.5)
end

function f.waveCode(level,gain)
local a=aq[level]*gain
if a>=ar then
return au
elseif a>=as then
return av
elseif a>=at then
return aw
end
return 0
end

local function aA(text,fail)
while true do
local a,d,e,g=string.find(text,"%[([^%[%]]*)%](%d+)")
if not a then
break
end
local c=tonumber(g)
if c<1 or c>C then
fail(a,"a group repeats between 1 and "..C.." times")
end
text=string.sub(text,1,a-1)..string.rep(e,c)..string.sub(text,d+1)
if string.len(text)>D then
fail(a,"the repeats expand past "..D.." characters")
end
end
if string.find(text,"[%[%]]")then
fail(string.find(text,"[%[%]]"),"a bracket is not closed or has no count")
end
return text
end

local function aB(voice)
local a=W
if voice==b.WAVE then
a=X
end
return{
voice=voice,
time=0,
tempo=T,
length=U,
dots=0,
octave=V,
level=a,
envelopePeriod=0,
envelopeUp=false,
duties={Y},
waveIndex=0,
sweepPeriod=0,
sweepNegate=false,
sweepShift=0,
gate=o,
arpeggioSpeed=Z,
vibrato=nil,
portamento=0,
sounding=false,
loopStart=nil,
events={},
}
end

local function aC(state)
if state.voice~=b.PULSE1 then
return nil
end
local a=state.sweepPeriod*ap+state.sweepShift
if state.sweepNegate then
a=a+ao
end
return a
end

local function u(state,periods,codes)
local a={
note=true,
tempo=state.tempo,
level=state.level,
envelopeUp=state.envelopeUp,
envelopePeriod=state.envelopePeriod,
duties=state.duties,
sweep=aC(state),
arpeggioSpeed=state.arpeggioSpeed,
vibrato=state.vibrato,
portamento=state.portamento,
codes=codes,
}
if periods then
a.period=periods[1]
if#periods>1 then
a.periods=periods
end
end
if state.voice==b.WAVE then
a.wave=z.WAVE_NAMES[state.waveIndex+1]
end
return a
end

local function K(state,event)
event.t=m(state.time)
local a=state.events
a[#a+1]=event
end

local function v(state)
if not state.sounding then
return
end
K(state,{off=true,tempo=state.tempo})
state.sounding=false
end

local function w(state,note,duration)
K(state,note)
state.sounding=true
if state.gate<o then
local a=duration*state.gate/o
state.time=state.time+a
v(state)
state.time=state.time+duration-a
return
end
state.time=state.time+duration
end

local function aD(label,key,voice,text)
local function d(position,message)
error("SpiffBoy: tune "..label..", voice "..key..", character "..tostring(position)..": "..message)
end
text=aA(text,d)
local c=aB(voice)
local aE=string.len(text)
local a=1

local function h()
return string.sub(text,a,a)
end

local function L()
local e=string.match(text,"^[ \t\r\n]*",a)
a=a+string.len(e)
end

local function M()
local e=string.match(text,"^%d+",a)
if not e then
return nil
end
a=a+string.len(e)
return tonumber(e)
end

local function x()
local e=string.match(text,"^%.*",a)
a=a+string.len(e)
return string.len(e)
end

local function g(low,high,what)
local e=M()
if not e or e<low or e>high then
d(a,what.." takes a number from "..low.." to "..high)
end
return e
end

local function N()
local e=M()
local n
if e then
if e<i or e>j then
d(a,"a length goes from "..i.." to "..j)
end
n=x()
else
e=c.length
n=x()
if n==0 then
n=c.dots
end
end
return t(c.tempo,e,n)
end

local function y()
local e=N()
while h()=="^"do
a=a+1
e=e+N()
end
return e
end

local function O(octave)
local P=h()
local p=H[P]
if not p then
return nil
end
a=a+1
local e=octave*r+p
local n=h()
if n=="+"or n=="#"then
e=e+1
a=a+1
elseif n=="-"then
e=e-1
a=a+1
end
return e
end

local function P(index)
local e=az(ay(index),ax[voice])
if not e then
d(a,"the note lies outside the range of the voice")
end
return e
end

local function aF()
local n={}
local e=c.octave
while true do
L()
local p=h()
if p=="}"then
a=a+1
break
elseif p==""then
d(a,"a chord is not closed")
elseif p=="<"then
a=a+1
e=e-1
elseif p==">"then
a=a+1
e=e+1
else
local Q=O(e)
if not Q then
d(a,"a chord holds notes only")
end
if e<k or e>l then
d(a,"the octave of a chord note lies outside "..k.." to "..l)
end
n[#n+1]=P(Q)
if#n>E then
d(a,"a chord holds at most "..E.." notes")
end
end
end
if#n==0 then
d(a,"a chord holds at least one note")
end
return n
end

local function aG()
if h()~="{"then
return{g(0,SpiffBoy.BYTE_MAX,"n")}
end
a=a+1
local e={}
while true do
L()
local n=h()
if n=="}"then
a=a+1
break
elseif n==""then
d(a,"a noise sequence is not closed")
end
e[#e+1]=g(0,SpiffBoy.BYTE_MAX,"a noise sequence")
if#e>F then
d(a,"a noise sequence holds at most "..F.." values")
end
end
if#e==0 then
d(a,"a noise sequence holds at least one value")
end
return e
end

local function aH()
local e=string.match(text,"^%d+",a)
if not e then
d(a,"@ takes one duty from 0 to "..q.." or a sequence of them")
end
a=a+string.len(e)
if string.len(e)>B then
d(a,"a duty sequence holds at most "..B.." steps")
end
local p={}
for n=1,string.len(e)do
local Q=tonumber(string.sub(e,n,n))
if Q>q then
d(a,"a duty goes from 0 to "..q)
end
p[n]=Q
end
return p
end

while a<=aE do
local e=h()
if e==" "or e=="\n"or e=="\r"or e=="\t"or e=="|"then
a=a+1
elseif H[e]then
if voice==b.NOISE then
d(a,"the noise voice plays register values written with n, not notes")
end
local n=O(c.octave)
local p=P(n)
local Q=y()
w(c,u(c,{p},nil),Q)
elseif e=="{"then
if voice==b.NOISE then
d(a,"the noise voice plays no chord")
end
a=a+1
local n=aF()
local p=y()
w(c,u(c,n,nil),p)
elseif e=="n"then
a=a+1
if voice~=b.NOISE then
d(a,"n plays a noise register value on the noise voice only")
end
local n=aG()
local p=t(c.tempo,c.length,c.dots)
w(c,u(c,nil,n),p)
elseif e=="r"then
a=a+1
local n=y()
v(c)
c.time=c.time+n
elseif e=="^"then
d(a,"a tie follows a note")
elseif e=="o"then
a=a+1
c.octave=g(k,l,"o")
elseif e=="<"then
a=a+1
if c.octave<=k then
d(a,"the octave cannot go below "..k)
end
c.octave=c.octave-1
elseif e==">"then
a=a+1
if c.octave>=l then
d(a,"the octave cannot go above "..l)
end
c.octave=c.octave+1
elseif e=="l"then
a=a+1
c.length=g(i,j,"l")
c.dots=x()
elseif e=="t"then
a=a+1
c.tempo=g(_,aa,"t")
elseif e=="v"then
a=a+1
if voice==b.WAVE then
c.level=g(0,ab,"v on the wave voice")
else
c.level=g(0,A,"v")
end
elseif e=="y"or e=="u"then
a=a+1
if voice==b.WAVE then
d(a,"the wave voice has no envelope")
end
c.envelopePeriod=g(0,ac,e)
c.envelopeUp=e=="u"
elseif e=="@"then
a=a+1
if voice==b.WAVE then
c.waveIndex=g(0,#z.WAVE_NAMES-1,"@ on the wave voice")
elseif voice==b.NOISE then
d(a,"the noise voice takes its register value from n")
else
c.duties=aH()
end
elseif e=="s"then
a=a+1
if voice~=b.PULSE1 then
d(a,"only the first pulse voice sweeps")
end
c.sweepPeriod=g(0,ad,"s")
c.sweepNegate=false
c.sweepShift=0
if h()==","then
a=a+1
if h()=="-"then
a=a+1
c.sweepNegate=true
end
c.sweepShift=g(0,ae,"the sweep shift")
end
elseif e=="q"then
a=a+1
c.gate=g(1,o,"q")
elseif e=="x"then
a=a+1
c.arpeggioSpeed=g(1,af,"x")
elseif e=="~"then
a=a+1
if voice==b.NOISE then
d(a,"the noise voice has no vibrato")
end
local n=g(0,ag,"~")
if n==0 then
c.vibrato=nil
else
if h()~=","then
d(a,"a vibrato takes a depth, a speed and an optional delay")
end
a=a+1
local Q=g(ah,ai,"the vibrato speed")
local p=0
if h()==","then
a=a+1
p=g(0,aj,"the vibrato delay")
end
c.vibrato={depth=n,speed=Q,delay=p}
end
elseif e=="p"then
a=a+1
if voice==b.NOISE then
d(a,"the noise voice has no portamento")
end
c.portamento=g(0,ak,"p")
elseif e=="L"then
a=a+1
c.loopStart=m(c.time)
else
d(a,"unknown command "..e)
end
end
v(c)
return c
end

local function x(event)
local a={}
for c,d in pairs(event)do
a[c]=d
end
return a
end

local function y(label,key,voice,definition,states,loop)
local c="SpiffBoy: tune "..label..", voice "..key..": "
if not J[voice]then
error(c.."only a pulse voice echoes")
end
local n=f.VOICE_KEYS[definition.echo]
local d=states[definition.echo]
if not J[n]or not d then
error(c.."an echo names a pulse voice written in the same tune")
end
if not SpiffBoy.isInteger(definition.delay)or definition.delay<i or definition.delay>j then
error(c.."an echo delay is a note length from "..i.." to "..j)
end
if not SpiffBoy.isInteger(definition.drop)or definition.drop<0 or definition.drop>G then
error(c.."an echo drop goes from 0 to "..G)
end
local h=m(d.time)
local e={}
local g=h
for p=1,#d.events do
local a=x(d.events[p])
local L=t(a.tempo,definition.delay,0)
a.t=m(a.t+L)
if a.note then
a.level=math.max(0,a.level-definition.drop)
a.sweep=nil
if voice==b.PULSE1 then
a.sweep=0
end
end
if not loop or a.t<h then
e[#e+1]=a
g=math.max(g,a.t)
end
end
return{voice=voice,events=e,time=g,loopStart=nil}
end

local function L(label,definition)
if type(definition)~="table"then
error("SpiffBoy: tune "..label.." needs a table")
end
local d={}
local h={}
for a,e in pairs(f.VOICE_KEYS)do
local c=definition[a]
if type(c)=="string"then
d[a]=aD(label,a,e,c)
elseif type(c)=="table"then
h[a]=c
elseif c~=nil then
error("SpiffBoy: tune "..label..", voice "..a.." needs a string or an echo table")
end
end
local n=definition.loop==true
for a,c in pairs(h)do
d[a]=y(label,a,f.VOICE_KEYS[a],c,d,n)
end
local a={loop=n,length=0,loopStart=0,tracks={}}
local e=nil
local p=false
for g,c in pairs(d)do
p=true
a.tracks[c.voice]={events=c.events,n=#c.events,loopIndex=1}
a.length=math.max(a.length,m(c.time))
if c.loopStart then
if e and c.loopStart~=a.loopStart then
error("SpiffBoy: tune "..label.." places its loop point at different times on "..e.." and "..g)
end
a.loopStart=c.loopStart
e=g
end
end
if not p then
error("SpiffBoy: tune "..label.." has no voice")
end
if a.length<=0 then
error("SpiffBoy: tune "..label.." lasts no time")
end
if a.loop and a.loopStart>=a.length then
error("SpiffBoy: tune "..label.." loops from its end")
end
for M,g in pairs(a.tracks)do
local c=1
while c<=g.n and g.events[c].t<a.loopStart do
c=c+1
end
g.loopIndex=c
end
return a
end

function f.register(id,definitions)
if type(id)~="string"or type(definitions)~="table"then
error("SpiffBoy: tunes are registered with a string id and a table of definitions")
end
local d=SpiffBoy.Cartridges.byId(id)
if not d then
error("SpiffBoy: tunes are registered under the id of a registered cartridge, and no cartridge has the id "..id)
end
if s[id]then
error("SpiffBoy: tunes are already registered under the id "..id.." of the cartridge of the mod "..d.mod)
end
local c={id=id,tunes={}}
for a,e in pairs(definitions)do
if type(a)~="string"or string.len(a)>SpiffBoy.TUNE_NAME_MAX then
error("SpiffBoy: tune names of "..id.." are strings of at most "..SpiffBoy.TUNE_NAME_MAX.." characters")
end
c.tunes[a]=L(id.."."..a,e)
end
s[id]=c
return c
end

function f.set(id)
return s[id]
end

function f.find(set,name)
if not set or type(name)~="string"then
return nil
end
return set.tunes[name]
end
