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

local B=512
local s=SpiffBoy.TICK_RATE
local C=64
local t=256
local D=16384
local E=8
local F=8
local G=0x77
local H=0xF3
local I=0x80
local J=e.WAVE_NAMES[1]
local K=2
local L={[0]=0,[1]=1,[2]=0.5,[3]=0.25}
local M={[0]=0.5,1,2,3,4,5,6,7}
local u=15
local N=7
local v=2
local O=0.5
local P=math.log(2)
local Q=8
local R={[0]=true,[2]=true,[4]=true,[6]=true}
local S={[2]=true,[6]=true}
local T=7

local function c(value,shift,count)
return math.floor(value/2^shift)%2^count
end

local function d(value,bit)
return c(value,bit,1)==1
end

local function w(kind)
local b=C
if kind==a.WAVE then
b=t
end
return{
kind=kind,
maxLength=b,
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
duty=K,
sweepPeriod=0,
sweepNegate=false,
sweepShift=0,
sweepTimer=0,
sweepEnabled=false,
shadow=0,
volumeCode=0,
wave=J,
shift=0,
width=u,
divisor=0,
family=nil,
band=nil,
}
end

local function x()
return{on=false,sound=nil,pitch=1,gain=0}
end

local function l(voice)
local b=math.floor(voice.shadow/2^voice.sweepShift)
if voice.sweepNegate then
return voice.shadow-b
end
return voice.shadow+b
end

local function m(period)
if period==0 then
return E
end
return period
end

local function y(voice)
if voice.dac then
voice.enabled=true
end
if voice.length==0 then
voice.length=voice.maxLength
end
voice.envTimer=m(voice.envPeriod)
voice.level=voice.envInitial
if voice.kind==a.PULSE1 then
voice.shadow=voice.period
voice.sweepTimer=m(voice.sweepPeriod)
voice.sweepEnabled=voice.sweepPeriod~=0 or voice.sweepShift~=0
if voice.sweepShift~=0 and l(voice)>a.MAX_PERIOD then
voice.enabled=false
end
end
end

local function U(voice)
if not voice.lengthEnabled or voice.length==0 then
return
end
voice.length=voice.length-1
if voice.length==0 then
voice.enabled=false
end
end

local function V(voice)
voice.sweepTimer=voice.sweepTimer-1
if voice.sweepTimer>0 then
return
end
voice.sweepTimer=m(voice.sweepPeriod)
if not voice.sweepEnabled or voice.sweepPeriod==0 then
return
end
local b=l(voice)
if b>a.MAX_PERIOD then
voice.enabled=false
return
end
if voice.sweepShift==0 then
return
end
voice.shadow=b
voice.period=b
if l(voice)>a.MAX_PERIOD then
voice.enabled=false
end
end

local function W(voice)
if voice.envPeriod==0 then
return
end
voice.envTimer=voice.envTimer-1
if voice.envTimer>0 then
return
end
voice.envTimer=voice.envPeriod
if voice.envUp and voice.level<a.MAX_LEVEL then
voice.level=voice.level+1
elseif not voice.envUp and voice.level>0 then
voice.level=voice.level-1
end
end

local function X(voice,value)
voice.sweepPeriod=c(value,4,3)
voice.sweepNegate=d(value,3)
voice.sweepShift=c(value,0,3)
end

local function n(voice,value)
if voice.kind~=a.NOISE then
voice.duty=c(value,6,2)
end
voice.length=voice.maxLength-c(value,0,6)
end

local function o(voice,value)
voice.envInitial=c(value,4,4)
voice.envUp=d(value,3)
voice.envPeriod=c(value,0,3)
voice.dac=c(value,3,5)~=0
if not voice.dac then
voice.enabled=false
end
end

local function p(voice,value)
voice.period=voice.period-voice.period%256+value
end

local function q(voice,value)
voice.period=voice.period%256+c(value,0,3)*256
voice.lengthEnabled=d(value,6)
if d(value,7)then
y(voice)
end
end

local function Y(voice,value)
voice.dac=d(value,7)
if not voice.dac then
voice.enabled=false
end
end

local function Z(voice,value)
voice.length=t-value
end

local function _(voice,value)
voice.volumeCode=c(value,5,2)
end

local function aa(voice,value)
voice.shift=c(value,4,4)
voice.width=u
if d(value,3)then
voice.width=N
end
voice.divisor=c(value,0,3)
end

local function ab(voice,value)
voice.lengthEnabled=d(value,6)
if d(value,7)then
y(voice)
end
end

local function ac(chip,value)
chip.master=(math.max(c(value,4,3),c(value,0,3))+1)/F
end

local function ad(chip,value)
for b=1,a.VOICES do
chip.pan[b]=d(value,b-1)or d(value,b+3)
end
end

local function ae(chip,value)
chip:setPower(d(value,7))
end

local z={
[a.NR10]={voice=a.PULSE1,write=X},
[a.NR11]={voice=a.PULSE1,write=n},
[a.NR12]={voice=a.PULSE1,write=o},
[a.NR13]={voice=a.PULSE1,write=p},
[a.NR14]={voice=a.PULSE1,write=q},
[a.NR21]={voice=a.PULSE2,write=n},
[a.NR22]={voice=a.PULSE2,write=o},
[a.NR23]={voice=a.PULSE2,write=p},
[a.NR24]={voice=a.PULSE2,write=q},
[a.NR30]={voice=a.WAVE,write=Y},
[a.NR31]={voice=a.WAVE,write=Z},
[a.NR32]={voice=a.WAVE,write=_},
[a.NR33]={voice=a.WAVE,write=p},
[a.NR34]={voice=a.WAVE,write=q},
[a.NR41]={voice=a.NOISE,write=n},
[a.NR42]={voice=a.NOISE,write=o},
[a.NR43]={voice=a.NOISE,write=aa},
[a.NR44]={voice=a.NOISE,write=ab},
[a.NR50]={write=ac},
[a.NR51]={write=ad},
[a.NR52]={write=ae},
}

function a.isRegister(register)
return z[register]~=nil
end

function a.new()
local b=setmetatable({},a)
b.state={}
b.voices={}
b.pan={}
for f=1,a.VOICES do
b.state[f]=w(f)
b.voices[f]=x()
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
self.state[b]=w(b)
self.state[b].wave=f
self.pan[b]=false
self.voices[b]=x()
end
self.master=0
self.frame=0
self.frameAccumulator=0
end

function a:setPower(on)
if on==self.power then
return
end
self.power=on
self:clear()
end

function a:boot()
self:apply(a.NR52,I)
self:apply(a.NR50,G)
self:apply(a.NR51,H)
end

function a:halt()
self:apply(a.NR52,0)
end

function a:write(register,value)
if not a.isRegister(register)then
error("SpiffBoy: no sound register "..tostring(register))
end
if not SpiffBoy.isInteger(value)or value<0 or value>SpiffBoy.BYTE_MAX then
error("SpiffBoy: sound register value out of range: "..tostring(value))
end
if self.listener then
self.listener:onChipWrite(register,value)
end
self:apply(register,value)
end

function a:apply(register,value)
if not self.power and register~=a.NR52 then
return
end
local b=z[register]
if b.voice then
b.write(self.state[b.voice],value)
else
b.write(self,value)
end
end

function a:loadWave(name)
if not e.WAVE[name]then
error("SpiffBoy: no wave table named "..tostring(name))
end
if self.listener then
self.listener:onChipWave(name)
end
self:applyWave(name)
end

function a:applyWave(name)
self.state[a.WAVE].wave=name
end

function a:clockFrame()
local b=self.frame
self.frame=(b+1)%Q
if R[b]then
for f=1,a.VOICES do
U(self.state[f])
end
end
if S[b]then
V(self.state[a.PULSE1])
end
if b==T then
for f=1,a.VOICES do
W(self.state[f])
end
end
end

function a:render(index)
local b=self.state[index]
local i=self.voices[index]
i.on=false
if not self.power or not b.enabled or not b.dac or not self.pan[index]then
return
end
local f,j,g,k,r
if b.kind==a.NOISE then
if b.shift>a.MAX_NOISE_SHIFT then
return
end
f=a.NOISE_CLOCK/M[b.divisor]/2^(b.shift+1)
j=b.level/a.MAX_LEVEL
g=e.NOISE[b.width]
k=e.NOISE_BASE
r=e.NOISE_BANDS
else
local h=a.PULSE_CLOCK
if b.kind==a.WAVE then
h=a.WAVE_CLOCK
j=L[b.volumeCode]
g=e.WAVE[b.wave]
else
j=b.level/a.MAX_LEVEL
g=e.PULSE[b.duty]
end
f=h/(a.MAX_PERIOD+1-b.period)
if f>D then
return
end
k=e.TONE_BASE
r=e.TONE_BANDS
end
if j<=0 then
return
end
local h=nil
if b.family==g and b.band then
local A=f/(k*2^b.band)
if A>=O and A<v then
h=b.band
end
end
if not h then
h=SpiffBoy.clamp(math.floor(math.log(f/k)/P),0,r-1)
end
b.family=g
b.band=h
i.on=true
i.sound=g[h+1]
i.pitch=math.min(v,f/(k*2^h))
i.gain=j*self.master
end

function a:step()
if self.power then
self.frameAccumulator=self.frameAccumulator+B
while self.frameAccumulator>=s do
self.frameAccumulator=self.frameAccumulator-s
self:clockFrame()
end
end
for b=1,a.VOICES do
self:render(b)
end
end
