require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Chip"

SpiffBoy.Tunes=SpiffBoy.Tunes or{}
local f=SpiffBoy.Tunes
local b=SpiffBoyChip
local A=SpiffBoy.ChipBank

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

local T=SpiffBoy.TICK_RATE
local U=240
local V=120
local W=4
local X=4
local Y=15
local Z=3
local _=2
local aa=1
local q=8
local k=1
local l=64
local m=1
local n=8
local ab=20
local ac=400
local B=b.MAX_LEVEL
local ad=3
local ae=7
local s=3
local C=16
local af=7
local ag=7
local D=64
local E=65536
local F=8
local ah=16
local ai=64
local aj=2
local ak=64
local al=255
local am=255
local G=32
local H=B
local t=12
local I={c=0,d=2,e=4,f=5,g=7,a=9,b=11}
local an=440
local ao=4*t+9
local ap=8
local aq=8
local ar=16
local J=1000000
local as={[0]=0,[1]=0.25,[2]=0.5,[3]=1}
local at=0.75
local au=0.375
local av=0.125
local aw=1
local ax=2
local ay=3
local az={[b.PULSE1]=b.PULSE_CLOCK,[b.PULSE2]=b.PULSE_CLOCK,[b.WAVE]=b.WAVE_CLOCK}
local K={[b.PULSE1]=true,[b.PULSE2]=true}

local L={}

local function aA(a)
return an*2^((a-ao)/t)
end

local function aB(c,d)
local a=b.MAX_PERIOD+1-math.floor(d/c+0.5)
if a<0 or a>b.MAX_PERIOD then
return nil
end
return a
end

local function o(a)
return math.floor(a*J+0.5)/J
end

local function u(d,e,g)
local h=T*U/d
local a=h/e
local c=a
for i=1,g do
a=a/2
c=c+a
end
return c
end

function f.periodBytes(a)
return a%f.PERIOD_HIGH,math.floor(a/f.PERIOD_HIGH)
end

function f.envelopeByte(c,d,e)
local a=c*f.LEVEL_SHIFT+e
if d then
a=a+ap
end
return a
end

function f.scaleLevel(a,c)
return math.floor(a*c+0.5)
end

function f.waveCode(c,d)
local a=as[c]*d
if a>=at then
return aw
elseif a>=au then
return ax
elseif a>=av then
return ay
end
return 0
end

local function aC(a,d)
while true do
local c,g,h,i=string.find(a,"%[([^%[%]]*)%](%d+)")
if not c then
break
end
local e=tonumber(i)
if e<1 or e>D then
d(c,"a group repeats between 1 and "..D.." times")
end
a=string.sub(a,1,c-1)..string.rep(h,e)..string.sub(a,g+1)
if string.len(a)>E then
d(c,"the repeats expand past "..E.." characters")
end
end
if string.find(a,"[%[%]]")then
d(string.find(a,"[%[%]]"),"a bracket is not closed or has no count")
end
return a
end

local function aD(a)
local c=Y
if a==b.WAVE then
c=Z
end
return{
voice=a,
time=0,
tempo=V,
length=W,
dots=0,
octave=X,
level=c,
envelopePeriod=0,
envelopeUp=false,
duties={_},
waveIndex=0,
sweepPeriod=0,
sweepNegate=false,
sweepShift=0,
gate=q,
arpeggioSpeed=aa,
vibrato=nil,
portamento=0,
sounding=false,
loopStart=nil,
events={},
}
end

local function aE(a)
if a.voice~=b.PULSE1 then
return nil
end
local c=a.sweepPeriod*ar+a.sweepShift
if a.sweepNegate then
c=c+aq
end
return c
end

local function v(a,c,e)
local d={
note=true,
tempo=a.tempo,
level=a.level,
envelopeUp=a.envelopeUp,
envelopePeriod=a.envelopePeriod,
duties=a.duties,
sweep=aE(a),
arpeggioSpeed=a.arpeggioSpeed,
vibrato=a.vibrato,
portamento=a.portamento,
codes=e,
}
if c then
d.period=c[1]
if#c>1 then
d.periods=c
end
end
if a.voice==b.WAVE then
d.wave=A.WAVE_NAMES[a.waveIndex+1]
end
return d
end

local function M(a,c)
c.t=o(a.time)
local d=a.events
d[#d+1]=c
end

local function w(a)
if not a.sounding then
return
end
M(a,{off=true,tempo=a.tempo})
a.sounding=false
end

local function x(a,e,c)
M(a,e)
a.sounding=true
if a.gate<q then
local d=c*a.gate/q
a.time=a.time+d
w(a)
a.time=a.time+c-d
return
end
a.time=a.time+c
end

local function aF(aG,aH,h,j)
local function d(a,c)
error("SpiffBoy: tune "..aG..", voice "..aH..", character "..tostring(a)..": "..c)
end
j=aC(j,d)
local c=aD(h)
local aI=string.len(j)
local a=1

local function i()
return string.sub(j,a,a)
end

local function N()
local e=string.match(j,"^[ \t\r\n]*",a)
a=a+string.len(e)
end

local function O()
local e=string.match(j,"^%d+",a)
if not e then
return nil
end
a=a+string.len(e)
return tonumber(e)
end

local function y()
local e=string.match(j,"^%.*",a)
a=a+string.len(e)
return string.len(e)
end

local function g(p,r,z)
local e=O()
if not e or e<p or e>r then
d(a,z.." takes a number from "..p.." to "..r)
end
return e
end

local function P()
local e=O()
local p
if e then
if e<k or e>l then
d(a,"a length goes from "..k.." to "..l)
end
p=y()
else
e=c.length
p=y()
if p==0 then
p=c.dots
end
end
return u(c.tempo,e,p)
end

local function z()
local e=P()
while i()=="^"do
a=a+1
e=e+P()
end
return e
end

local function Q(R)
local S=i()
local r=I[S]
if not r then
return nil
end
a=a+1
local e=R*t+r
local p=i()
if p=="+"or p=="#"then
e=e+1
a=a+1
elseif p=="-"then
e=e-1
a=a+1
end
return e
end

local function R(p)
local e=aB(aA(p),az[h])
if not e then
d(a,"the note lies outside the range of the voice")
end
return e
end

local function aJ()
local p={}
local e=c.octave
while true do
N()
local r=i()
if r=="}"then
a=a+1
break
elseif r==""then
d(a,"a chord is not closed")
elseif r=="<"then
a=a+1
e=e-1
elseif r==">"then
a=a+1
e=e+1
else
local S=Q(e)
if not S then
d(a,"a chord holds notes only")
end
if e<m or e>n then
d(a,"the octave of a chord note lies outside "..m.." to "..n)
end
p[#p+1]=R(S)
if#p>F then
d(a,"a chord holds at most "..F.." notes")
end
end
end
if#p==0 then
d(a,"a chord holds at least one note")
end
return p
end

local function aK()
if i()~="{"then
return{g(0,SpiffBoy.BYTE_MAX,"n")}
end
a=a+1
local e={}
while true do
N()
local p=i()
if p=="}"then
a=a+1
break
elseif p==""then
d(a,"a noise sequence is not closed")
end
e[#e+1]=g(0,SpiffBoy.BYTE_MAX,"a noise sequence")
if#e>G then
d(a,"a noise sequence holds at most "..G.." values")
end
end
if#e==0 then
d(a,"a noise sequence holds at least one value")
end
return e
end

local function aL()
local e=string.match(j,"^%d+",a)
if not e then
d(a,"@ takes one duty from 0 to "..s.." or a sequence of them")
end
a=a+string.len(e)
if string.len(e)>C then
d(a,"a duty sequence holds at most "..C.." steps")
end
local r={}
for p=1,string.len(e)do
local S=tonumber(string.sub(e,p,p))
if S>s then
d(a,"a duty goes from 0 to "..s)
end
r[p]=S
end
return r
end

while a<=aI do
local e=i()
if e==" "or e=="\n"or e=="\r"or e=="\t"or e=="|"then
a=a+1
elseif I[e]then
if h==b.NOISE then
d(a,"the noise voice plays register values written with n, not notes")
end
local p=Q(c.octave)
local r=R(p)
local S=z()
x(c,v(c,{r},nil),S)
elseif e=="{"then
if h==b.NOISE then
d(a,"the noise voice plays no chord")
end
a=a+1
local p=aJ()
local r=z()
x(c,v(c,p,nil),r)
elseif e=="n"then
a=a+1
if h~=b.NOISE then
d(a,"n plays a noise register value on the noise voice only")
end
local p=aK()
local r=u(c.tempo,c.length,c.dots)
x(c,v(c,nil,p),r)
elseif e=="r"then
a=a+1
local p=z()
w(c)
c.time=c.time+p
elseif e=="^"then
d(a,"a tie follows a note")
elseif e=="o"then
a=a+1
c.octave=g(m,n,"o")
elseif e=="<"then
a=a+1
if c.octave<=m then
d(a,"the octave cannot go below "..m)
end
c.octave=c.octave-1
elseif e==">"then
a=a+1
if c.octave>=n then
d(a,"the octave cannot go above "..n)
end
c.octave=c.octave+1
elseif e=="l"then
a=a+1
c.length=g(k,l,"l")
c.dots=y()
elseif e=="t"then
a=a+1
c.tempo=g(ab,ac,"t")
elseif e=="v"then
a=a+1
if h==b.WAVE then
c.level=g(0,ad,"v on the wave voice")
else
c.level=g(0,B,"v")
end
elseif e=="y"or e=="u"then
a=a+1
if h==b.WAVE then
d(a,"the wave voice has no envelope")
end
c.envelopePeriod=g(0,ae,e)
c.envelopeUp=e=="u"
elseif e=="@"then
a=a+1
if h==b.WAVE then
c.waveIndex=g(0,#A.WAVE_NAMES-1,"@ on the wave voice")
elseif h==b.NOISE then
d(a,"the noise voice takes its register value from n")
else
c.duties=aL()
end
elseif e=="s"then
a=a+1
if h~=b.PULSE1 then
d(a,"only the first pulse voice sweeps")
end
c.sweepPeriod=g(0,af,"s")
c.sweepNegate=false
c.sweepShift=0
if i()==","then
a=a+1
if i()=="-"then
a=a+1
c.sweepNegate=true
end
c.sweepShift=g(0,ag,"the sweep shift")
end
elseif e=="q"then
a=a+1
c.gate=g(1,q,"q")
elseif e=="x"then
a=a+1
c.arpeggioSpeed=g(1,ah,"x")
elseif e=="~"then
a=a+1
if h==b.NOISE then
d(a,"the noise voice has no vibrato")
end
local p=g(0,ai,"~")
if p==0 then
c.vibrato=nil
else
if i()~=","then
d(a,"a vibrato takes a depth, a speed and an optional delay")
end
a=a+1
local S=g(aj,ak,"the vibrato speed")
local r=0
if i()==","then
a=a+1
r=g(0,al,"the vibrato delay")
end
c.vibrato={depth=p,speed=S,delay=r}
end
elseif e=="p"then
a=a+1
if h==b.NOISE then
d(a,"the noise voice has no portamento")
end
c.portamento=g(0,am,"p")
elseif e=="L"then
a=a+1
c.loopStart=o(c.time)
else
d(a,"unknown command "..e)
end
end
w(c)
return c
end

local function y(c)
local a={}
for d,e in pairs(c)do
a[d]=e
end
return a
end

local function z(p,r,g,c,N,O)
local d="SpiffBoy: tune "..p..", voice "..r..": "
if not K[g]then
error(d.."only a pulse voice echoes")
end
local P=f.VOICE_KEYS[c.echo]
local e=N[c.echo]
if not K[P]or not e then
error(d.."an echo names a pulse voice written in the same tune")
end
if not SpiffBoy.isInteger(c.delay)or c.delay<k or c.delay>l then
error(d.."an echo delay is a note length from "..k.." to "..l)
end
if not SpiffBoy.isInteger(c.drop)or c.drop<0 or c.drop>H then
error(d.."an echo drop goes from 0 to "..H)
end
local j=o(e.time)
local h={}
local i=j
for Q=1,#e.events do
local a=y(e.events[Q])
local R=u(a.tempo,c.delay,0)
a.t=o(a.t+R)
if a.note then
a.level=math.max(0,a.level-c.drop)
a.sweep=nil
if g==b.PULSE1 then
a.sweep=0
end
end
if not O or a.t<j then
h[#h+1]=a
i=math.max(i,a.t)
end
end
return{voice=g,events=h,time=i,loopStart=nil}
end

local function N(c,g)
if type(g)~="table"then
error("SpiffBoy: tune "..c.." needs a table")
end
local e={}
local j={}
for a,h in pairs(f.VOICE_KEYS)do
local d=g[a]
if type(d)=="string"then
e[a]=aF(c,a,h,d)
elseif type(d)=="table"then
j[a]=d
elseif d~=nil then
error("SpiffBoy: tune "..c..", voice "..a.." needs a string or an echo table")
end
end
local p=g.loop==true
for a,d in pairs(j)do
e[a]=z(c,a,f.VOICE_KEYS[a],d,e,p)
end
local a={loop=p,length=0,loopStart=0,tracks={}}
local h=nil
local r=false
for i,d in pairs(e)do
r=true
a.tracks[d.voice]={events=d.events,n=#d.events,loopIndex=1}
a.length=math.max(a.length,o(d.time))
if d.loopStart then
if h and d.loopStart~=a.loopStart then
error("SpiffBoy: tune "..c.." places its loop point at different times on "..h.." and "..i)
end
a.loopStart=d.loopStart
h=i
end
end
if not r then
error("SpiffBoy: tune "..c.." has no voice")
end
if a.length<=0 then
error("SpiffBoy: tune "..c.." lasts no time")
end
if a.loop and a.loopStart>=a.length then
error("SpiffBoy: tune "..c.." loops from its end")
end
for O,i in pairs(a.tracks)do
local d=1
while d<=i.n and i.events[d].t<a.loopStart do
d=d+1
end
i.loopIndex=d
end
return a
end

function f.register(a,e)
if type(a)~="string"or type(e)~="table"then
error("SpiffBoy: tunes are registered with a string id and a table of definitions")
end
local d={id=a,tunes={}}
for c,g in pairs(e)do
if type(c)~="string"or string.len(c)>SpiffBoy.TUNE_NAME_MAX then
error("SpiffBoy: tune names of "..a.." are strings of at most "..SpiffBoy.TUNE_NAME_MAX.." characters")
end
d.tunes[c]=N(a.."."..c,g)
end
L[a]=d
return d
end

function f.set(a)
return L[a]
end

function f.find(a,c)
if not a or type(c)~="string"then
return nil
end
return a.tunes[c]
end
