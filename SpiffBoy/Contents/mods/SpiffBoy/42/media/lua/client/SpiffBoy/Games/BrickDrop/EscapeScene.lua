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

local c=SpiffBoy.Cartridges.SHADES[4]
local d=SpiffBoy.Cartridges.SHADES[1]
local k=SpiffBoy.Cartridges.SHADES[3]
local e=SpiffBoy.Cartridges.SCREEN_WIDTH
local z=SpiffBoy.Cartridges.SCREEN_HEIGHT
local l={1,2,3,4}
local h=180
local m=44
local n=44
local s={3}
local A=0.3
local i=n+m
local t=i+12
local B=i+18
local o=8
local p=24
local j=22
local C=16
local q=18
local u=22
local D=3
local E=2
local F=3
local G=2
local H=2
local I=6
local J=10
local K=1.2
local L=640
local M=150
local N=0.35
local O=120
local P=0.4
local Q=14
local R=36
local v=24
local S=70
local T=2.5
local U=420
local V=8
local W=360
local X=0.06
local Y=0.03
local r=34
local Z=15
local _=10
local aa=1.1
local ab=3
local w=30
local ac=45
local ad=SpiffBoy.GameTexts.of("BrickDrop")

function a.new(kind,sequencer,art,score)
local b=setmetatable({},a)
b.kind=kind
b.sequencer=sequencer
b.score=score
b.skyline=art("skyline")
b.tick=0
b.scroll=0
b.speed=T
if kind==a.FOOT then
b.mechanic=art("mechanic")
b.spear=art("spear")
b.courier=art("courier")
b.zombie=art("zombie")
b.speed=K
b.runners={fighter=84,mechanic=108,courier=132}
b.horde={{x=20},{x=40},{x=58}}
b.caught=nil
sequencer:play(g.FLIGHT)
else
b.truck=art("truck")
b.helicopter=art("helicopter")
b.truckX=S
b.truckSpeed=0
b.helicopterX=nil
sequencer:play(kind==a.RADIO and g.ESCAPED or g.TRUCK)
end
return b
end

function a:tickFoot()
local b=self.runners
if not self.caught and self.tick>=M then
b.fighter=b.fighter-N
local f=self.horde[#self.horde]
if b.fighter<=f.x+q/2 then
self.caught={x=b.fighter,tick=self.tick}
f.eating=true
f.x=b.fighter+2
self.sequencer:effect(g.CHOMP)
end
end
if self.caught then
self.caught.x=self.caught.x-self.speed
for x=1,#self.horde do
local f=self.horde[x]
if f.eating then
f.x=f.x-self.speed
elseif self.tick-self.caught.tick>=O then
f.x=f.x-P
end
end
end
end

function a:tickTruck()
if self.kind~=a.RADIO or self.tick<W then
return
end
self.truckSpeed=self.truckSpeed+X
self.truckX=self.truckX+self.truckSpeed
self.speed=math.max(0,self.speed-Y)
if self.truckX>e and not self.helicopterX then
self.helicopterX=-r
end
if self.helicopterX then
self.helicopterX=self.helicopterX+aa
end
end

function a:finished()
if self.sequencer:isPlaying()then
return false
end
if self.kind==a.FOOT then
return self.tick>=L
end
if self.kind==a.TRUCK then
return self.tick>=U
end
return self.helicopterX~=nil and self.helicopterX>e
end

function a:advance(input)
self.tick=self.tick+1
self.scroll=self.scroll+self.speed
if self.kind==a.FOOT then
self:tickFoot()
else
self:tickTruck()
end
if input and self.tick>ac and(input.pressed.a or input.pressed.start)then
self.sequencer:stop()
return true
end
return self:finished()
end

function a:drawBackground(screen)
screen:clear(c.r,c.g,c.b)
local b=math.floor(self.scroll*A)%h
screen:layers(self.skyline,0,h,m,-b,n,s)
screen:layers(self.skyline,0,h,m,h-b,n,s)
screen:rect(0,i,e,z-i,k.r,k.g,k.b,1)
local f=math.floor(self.scroll)%(o*2)
for x=-f,e,o*2 do
screen:rect(x,B,o,1,c.r,c.g,c.b,1)
end
end

local function b(screen,texture,frame,width,height,x)
screen:layers(texture,frame*width,width,height,math.floor(x),t-height,l)
end

function a:drawFoot(screen)
local f=math.floor(self.tick/I)%2
for y=1,#self.horde do
local x=self.horde[y]
if x.eating then
b(screen,self.zombie,H+math.floor(self.tick/Q)%2,q,u,x.x)
end
end
if self.caught then
b(screen,self.spear,E,p,j,self.caught.x)
else
b(screen,self.spear,F+f,p,j,self.runners.fighter)
end
for x=1,#self.horde do
local y=self.horde[x]
if not y.eating then
b(screen,self.zombie,math.floor(self.tick/J+x)%2,q,u,y.x)
end
end
b(screen,self.mechanic,D+f,p,j,self.runners.mechanic)
b(screen,self.courier,G+1-f,C,j,self.runners.courier)
end

function a:drawTruck(screen)
local f=math.floor(self.tick/V)%2
if self.speed==0 then
f=0
end
screen:layers(self.truck,0,R,v,math.floor(self.truckX),t-v-f,l)
if self.helicopterX then
local y=math.floor(self.tick/ab)%2
screen:layers(self.helicopter,y*r,r,Z,math.floor(self.helicopterX),_,l)
local x=e/2
screen:textCentre(ad("Escaped"),x,w,d.r,d.g,d.b,1)
screen:textCentre(tostring(self.score),x,w+screen:lineHeight(),d.r,d.g,d.b,1)
end
end

function a:draw(screen)
self:drawBackground(screen)
if self.kind==a.FOOT then
self:drawFoot(screen)
else
self:drawTruck(screen)
end
end
