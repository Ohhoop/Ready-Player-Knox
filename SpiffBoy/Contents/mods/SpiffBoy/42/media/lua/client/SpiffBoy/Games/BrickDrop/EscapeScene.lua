require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/BrickDrop/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local g=SpiffBoy.BrickDrop.Music

local a={}
a.__index=a
SpiffBoy.BrickDrop.EscapeScene=a

a.FOOT="foot"
a.TRUCK="truck"
a.RADIO="radio"

local d=SpiffBoy.Cartridges.SHADES[4]
local e=SpiffBoy.Cartridges.SHADES[1]
local k=SpiffBoy.Cartridges.SHADES[3]
local f=SpiffBoy.Cartridges.SCREEN_WIDTH
local A=SpiffBoy.Cartridges.SCREEN_HEIGHT
local l={1,2,3,4}
local h=180
local m=44
local n=44
local u={3}
local B=0.3
local i=n+m
local v=i+12
local C=i+18
local o=8
local p=24
local j=22
local D=16
local q=18
local w=22
local E=3
local F=2
local G=3
local H=2
local I=2
local J=6
local K=10
local L=1.2
local M=640
local N=150
local O=0.35
local P=120
local Q=0.4
local R=14
local S=36
local x=24
local T=70
local U=2.5
local V=420
local W=8
local X=360
local Y=0.06
local Z=0.03
local r=34
local _=15
local aa=10
local ab=1.1
local ac=3
local y=30
local ad=45
local ae=SpiffBoy.GameTexts.of("BrickDrop")

function a.new(s,t,c,z)
local b=setmetatable({},a)
b.kind=s
b.sequencer=t
b.score=z
b.skyline=c("skyline")
b.tick=0
b.scroll=0
b.speed=U
if s==a.FOOT then
b.mechanic=c("mechanic")
b.spear=c("spear")
b.courier=c("courier")
b.zombie=c("zombie")
b.speed=L
b.runners={fighter=84,mechanic=108,courier=132}
b.horde={{x=20},{x=40},{x=58}}
b.caught=nil
t:play(g.FLIGHT)
else
b.truck=c("truck")
b.helicopter=c("helicopter")
b.truckX=T
b.truckSpeed=0
b.helicopterX=nil
t:play(s==a.RADIO and g.ESCAPED or g.TRUCK)
end
return b
end

function a:tickFoot()
local b=self.runners
if not self.caught and self.tick>=N then
b.fighter=b.fighter-O
local c=self.horde[#self.horde]
if b.fighter<=c.x+q/2 then
self.caught={x=b.fighter,tick=self.tick}
c.eating=true
c.x=b.fighter+2
self.sequencer:effect(g.CHOMP)
end
end
if self.caught then
self.caught.x=self.caught.x-self.speed
for s=1,#self.horde do
local c=self.horde[s]
if c.eating then
c.x=c.x-self.speed
elseif self.tick-self.caught.tick>=P then
c.x=c.x-Q
end
end
end
end

function a:tickTruck()
if self.kind~=a.RADIO or self.tick<X then
return
end
self.truckSpeed=self.truckSpeed+Y
self.truckX=self.truckX+self.truckSpeed
self.speed=math.max(0,self.speed-Z)
if self.truckX>f and not self.helicopterX then
self.helicopterX=-r
end
if self.helicopterX then
self.helicopterX=self.helicopterX+ab
end
end

function a:finished()
if self.sequencer:isPlaying()then
return false
end
if self.kind==a.FOOT then
return self.tick>=M
end
if self.kind==a.TRUCK then
return self.tick>=V
end
return self.helicopterX~=nil and self.helicopterX>f
end

function a:advance(b)
self.tick=self.tick+1
self.scroll=self.scroll+self.speed
if self.kind==a.FOOT then
self:tickFoot()
else
self:tickTruck()
end
if b and self.tick>ad and(b.pressed.a or b.pressed.start)then
self.sequencer:stop()
return true
end
return self:finished()
end

function a:drawBackground(b)
b:clear(d.r,d.g,d.b)
local c=math.floor(self.scroll*B)%h
b:layers(self.skyline,0,h,m,-c,n,u)
b:layers(self.skyline,0,h,m,h-c,n,u)
b:rect(0,i,f,A-i,k.r,k.g,k.b,1)
local s=math.floor(self.scroll)%(o*2)
for t=-s,f,o*2 do
b:rect(t,C,o,1,d.r,d.g,d.b,1)
end
end

local function b(t,z,af,c,s,ag)
t:layers(z,af*c,c,s,math.floor(ag),v-s,l)
end

function a:drawFoot(c)
local s=math.floor(self.tick/J)%2
for z=1,#self.horde do
local t=self.horde[z]
if t.eating then
b(c,self.zombie,I+math.floor(self.tick/R)%2,q,w,t.x)
end
end
if self.caught then
b(c,self.spear,F,p,j,self.caught.x)
else
b(c,self.spear,G+s,p,j,self.runners.fighter)
end
for t=1,#self.horde do
local z=self.horde[t]
if not z.eating then
b(c,self.zombie,math.floor(self.tick/K+t)%2,q,w,z.x)
end
end
b(c,self.mechanic,E+s,p,j,self.runners.mechanic)
b(c,self.courier,H+1-s,D,j,self.runners.courier)
end

function a:drawTruck(c)
local s=math.floor(self.tick/W)%2
if self.speed==0 then
s=0
end
c:layers(self.truck,0,S,x,math.floor(self.truckX),v-x-s,l)
if self.helicopterX then
local z=math.floor(self.tick/ac)%2
c:layers(self.helicopter,z*r,r,_,math.floor(self.helicopterX),aa,l)
local t=f/2
c:textCentre(ae("Escaped"),t,y,e.r,e.g,e.b,1)
c:textCentre(tostring(self.score),t,y+c:lineHeight(),e.r,e.g,e.b,1)
end
end

function a:draw(c)
self:drawBackground(c)
if self.kind==a.FOOT then
self:drawFoot(c)
else
self:drawTruck(c)
end
end
