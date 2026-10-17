require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/ChipBank"

SpiffBoyChip={}
SpiffBoyChip.__index=SpiffBoyChip
local a=SpiffBoyChip
local e=SpiffBoy.ChipBank

a.NR10=0x10
a.NR11=0x11
a.NR12=0x12
a.NR13=0x13
a.NR14=0x14
a.NR21=0x16
a.NR22=0x17
a.NR23=0x18
a.NR24=0x19
a.NR30=0x1A
a.NR31=0x1B
a.NR32=0x1C
a.NR33=0x1D
a.NR34=0x1E
a.NR41=0x20
a.NR42=0x21
a.NR43=0x22
a.NR44=0x23
a.NR50=0x24
a.NR51=0x25
a.NR52=0x26
a.PULSE1=1
a.PULSE2=2
a.WAVE=3
a.NOISE=4
a.VOICES=4
a.MAX_PERIOD=2047
a.MAX_LEVEL=15
a.PULSE_CLOCK=131072
a.WAVE_CLOCK=65536
a.NOISE_CLOCK=524288
a.MAX_NOISE_SHIFT=13

local C=512
local t=SpiffBoy.TICK_RATE
local D=64
local u=256
local E=16384
local F=8
local G=8
local H=0x77
local I=0xF3
local J=0x80
local K=e.WAVE_NAMES[1]
local L=2
local M={[0]=0,[1]=1,[2]=0.5,[3]=0.25}
local N={[0]=0.5,1,2,3,4,5,6,7}
local v=15
local O=7
local w=2
local P=0.5
local Q=math.log(2)
local R=8
local S={[0]=true,[2]=true,[4]=true,[6]=true}
local T={[2]=true,[6]=true}
local U=7

local function c(b,d,f)
return math.floor(b/2^d)%2^f
end

local function d(b,f)
return c(b,f,1)==1
end

local function x(b)
local f=D
if b==a.WAVE then
f=u
end
return{
kind=b,
maxLength=f,
enabled=false,
dac=false,
length=0,
lengthEnabled=false,
period=0,
envInitial=0,
envUp=false,
envPeriod=0,
envTimer=0,
level=0,
duty=L,
sweepPeriod=0,
sweepNegate=false,
sweepShift=0,
sweepTimer=0,
sweepEnabled=false,
shadow=0,
volumeCode=0,
wave=K,
shift=0,
width=v,
divisor=0,
family=nil,
band=nil,
}
end

local function y()
return{on=false,sound=nil,pitch=1,gain=0}
end

local function l(b)
local f=math.floor(b.shadow/2^b.sweepShift)
if b.sweepNegate then
return b.shadow-f
end
return b.shadow+f
end

local function m(b)
if b==0 then
return F
end
return b
end

local function z(b)
if b.dac then
b.enabled=true
end
if b.length==0 then
b.length=b.maxLength
end
b.envTimer=m(b.envPeriod)
b.level=b.envInitial
if b.kind==a.PULSE1 then
b.shadow=b.period
b.sweepTimer=m(b.sweepPeriod)
b.sweepEnabled=b.sweepPeriod~=0 or b.sweepShift~=0
if b.sweepShift~=0 and l(b)>a.MAX_PERIOD then
b.enabled=false
end
end
end

local function V(b)
if not b.lengthEnabled or b.length==0 then
return
end
b.length=b.length-1
if b.length==0 then
b.enabled=false
end
end

local function W(b)
b.sweepTimer=b.sweepTimer-1
if b.sweepTimer>0 then
return
end
b.sweepTimer=m(b.sweepPeriod)
if not b.sweepEnabled or b.sweepPeriod==0 then
return
end
local f=l(b)
if f>a.MAX_PERIOD then
b.enabled=false
return
end
if b.sweepShift==0 then
return
end
b.shadow=f
b.period=f
if l(b)>a.MAX_PERIOD then
b.enabled=false
end
end

local function X(b)
if b.envPeriod==0 then
return
end
b.envTimer=b.envTimer-1
if b.envTimer>0 then
return
end
b.envTimer=b.envPeriod
if b.envUp and b.level<a.MAX_LEVEL then
b.level=b.level+1
elseif not b.envUp and b.level>0 then
b.level=b.level-1
end
end

local function Y(b,f)
b.sweepPeriod=c(f,4,3)
b.sweepNegate=d(f,3)
b.sweepShift=c(f,0,3)
end

local function n(b,f)
if b.kind~=a.NOISE then
b.duty=c(f,6,2)
end
b.length=b.maxLength-c(f,0,6)
end

local function o(b,f)
b.envInitial=c(f,4,4)
b.envUp=d(f,3)
b.envPeriod=c(f,0,3)
b.dac=c(f,3,5)~=0
if not b.dac then
b.enabled=false
end
end

local function p(b,f)
b.period=b.period-b.period%256+f
end

local function q(b,f)
b.period=b.period%256+c(f,0,3)*256
b.lengthEnabled=d(f,6)
if d(f,7)then
z(b)
end
end

local function Z(b,f)
b.dac=d(f,7)
if not b.dac then
b.enabled=false
end
end

local function _(b,f)
b.length=u-f
end

local function aa(b,f)
b.volumeCode=c(f,5,2)
end

local function ab(b,f)
b.shift=c(f,4,4)
b.width=v
if d(f,3)then
b.width=O
end
b.divisor=c(f,0,3)
end

local function ac(b,f)
b.lengthEnabled=d(f,6)
if d(f,7)then
z(b)
end
end

local function ad(f,b)
f.master=(math.max(c(b,4,3),c(b,0,3))+1)/G
end

local function ae(g,f)
for b=1,a.VOICES do
g.pan[b]=d(f,b-1)or d(f,b+3)
end
end

local function af(b,f)
b:setPower(d(f,7))
end

local A={
[a.NR10]={voice=a.PULSE1,write=Y},
[a.NR11]={voice=a.PULSE1,write=n},
[a.NR12]={voice=a.PULSE1,write=o},
[a.NR13]={voice=a.PULSE1,write=p},
[a.NR14]={voice=a.PULSE1,write=q},
[a.NR21]={voice=a.PULSE2,write=n},
[a.NR22]={voice=a.PULSE2,write=o},
[a.NR23]={voice=a.PULSE2,write=p},
[a.NR24]={voice=a.PULSE2,write=q},
[a.NR30]={voice=a.WAVE,write=Z},
[a.NR31]={voice=a.WAVE,write=_},
[a.NR32]={voice=a.WAVE,write=aa},
[a.NR33]={voice=a.WAVE,write=p},
[a.NR34]={voice=a.WAVE,write=q},
[a.NR41]={voice=a.NOISE,write=n},
[a.NR42]={voice=a.NOISE,write=o},
[a.NR43]={voice=a.NOISE,write=ab},
[a.NR44]={voice=a.NOISE,write=ac},
[a.NR50]={write=ad},
[a.NR51]={write=ae},
[a.NR52]={write=af},
}

function a.isRegister(b)
return A[b]~=nil
end

function a.new()
local b=setmetatable({},a)
b.state={}
b.voices={}
b.pan={}
for f=1,a.VOICES do
b.state[f]=x(f)
b.voices[f]=y()
b.pan[f]=false
end
b.power=false
b.master=0
b.frame=0
b.frameAccumulator=0
b.listener=nil
return b
end

function a:clear()
for b=1,a.VOICES do
local f=self.state[b].wave
self.state[b]=x(b)
self.state[b].wave=f
self.pan[b]=false
self.voices[b]=y()
end
self.master=0
self.frame=0
self.frameAccumulator=0
end

function a:setPower(b)
if b==self.power then
return
end
self.power=b
self:clear()
end

function a:boot()
self:apply(a.NR52,J)
self:apply(a.NR50,H)
self:apply(a.NR51,I)
end

function a:halt()
self:apply(a.NR52,0)
end

function a:write(f,b)
if not a.isRegister(f)then
error("SpiffBoy: no sound register "..tostring(f))
end
if not SpiffBoy.isInteger(b)or b<0 or b>SpiffBoy.BYTE_MAX then
error("SpiffBoy: sound register value out of range: "..tostring(b))
end
if self.listener then
self.listener:onChipWrite(f,b)
end
self:apply(f,b)
end

function a:apply(f,g)
if not self.power and f~=a.NR52 then
return
end
local b=A[f]
if b.voice then
b.write(self.state[b.voice],g)
else
b.write(self,g)
end
end

function a:loadWave(b)
if not e.WAVE[b]then
error("SpiffBoy: no wave table named "..tostring(b))
end
if self.listener then
self.listener:onChipWave(b)
end
self:applyWave(b)
end

function a:applyWave(b)
self.state[a.WAVE].wave=b
end

function a:clockFrame()
local b=self.frame
self.frame=(b+1)%R
if S[b]then
for f=1,a.VOICES do
V(self.state[f])
end
end
if T[b]then
W(self.state[a.PULSE1])
end
if b==U then
for f=1,a.VOICES do
X(self.state[f])
end
end
end

function a:render(r)
local b=self.state[r]
local i=self.voices[r]
i.on=false
if not self.power or not b.enabled or not b.dac or not self.pan[r]then
return
end
local f,j,g,k,s
if b.kind==a.NOISE then
if b.shift>a.MAX_NOISE_SHIFT then
return
end
f=a.NOISE_CLOCK/N[b.divisor]/2^(b.shift+1)
j=b.level/a.MAX_LEVEL
g=e.NOISE[b.width]
k=e.NOISE_BASE
s=e.NOISE_BANDS
else
local h=a.PULSE_CLOCK
if b.kind==a.WAVE then
h=a.WAVE_CLOCK
j=M[b.volumeCode]
g=e.WAVE[b.wave]
else
j=b.level/a.MAX_LEVEL
g=e.PULSE[b.duty]
end
f=h/(a.MAX_PERIOD+1-b.period)
if f>E then
return
end
k=e.TONE_BASE
s=e.TONE_BANDS
end
if j<=0 then
return
end
local h=nil
if b.family==g and b.band then
local B=f/(k*2^b.band)
if B>=P and B<w then
h=b.band
end
end
if not h then
h=SpiffBoy.clamp(math.floor(math.log(f/k)/Q),0,s-1)
end
b.family=g
b.band=h
i.on=true
i.sound=g[h+1]
i.pitch=math.min(w,f/(k*2^h))
i.gain=j*self.master
end

function a:step()
if self.power then
self.frameAccumulator=self.frameAccumulator+C
while self.frameAccumulator>=t do
self.frameAccumulator=self.frameAccumulator-t
self:clockFrame()
end
end
for b=1,a.VOICES do
self:render(b)
end
end
