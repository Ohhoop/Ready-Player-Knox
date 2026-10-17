require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/DoubleRaccoon/Combat"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local e=SpiffBoy.DoubleRaccoon.Combat

local c={}
c.__index=c
SpiffBoy.DoubleRaccoon.Horde=c

local b={}
b.__index=b

c.KINDS={
shambler={hp=8,speed=0.35,damage=2,score=100},
woman={hp=6,speed=0.42,damage=2,score=100},
runner={hp=5,speed=0.8,damage=1,score=150},
cop={hp=12,speed=0.35,damage=3,score=200},
lumberjack={hp=70,speed=0.5,damage=5,charge=6,chargeEvery=3,windup=26,heavy=true,special="spin",score=5000,boss=true},
linebacker={hp=80,speed=0.55,damage=4,charge=7,chargeEvery=2,chargeSpeed=3.2,windup=22,heavy=true,special="charge",score=6000,boss=true},
riot={hp=90,speed=0.45,damage=5,charge=6,chargeEvery=4,chargeSpeed=2.4,windup=24,heavy=true,shield=true,special="charge",score=7000,boss=true},
evil={hp=100,speed=0.9,damage=3,charge=5,chargeEvery=3,chargeSpeed=3.4,windup=12,heavy=false,rest=18,special="charge",score=10000,boss=true},
}

local y=21
local z=24
local A=14
local B=10
local C=2
local m=3
local D=0.6
local i=20
local n=4
local E=20
local F=24
local o=7
local p=40
local G=80
local q=14
local H=2
local r=50
local I=2.5
local J=0.85
local K=12
local j=40
local L=2
local s=120
local M=6
local N=10
local O=2
local P=22
local Q=6
local R=16
local S=3.2
local t=48
local u=10
local T=6
local U=4
local V=10
local W=50
local X=10
local Y={"walk1","walk2","walk3","walk4"}
local Z={-1,1}
local v=8
local g={ticks=100,turn=4,reach=26,depth=8,whirl=16}
local d={chargeWindup=36,chargeDistance=150,recoverTicks=50,contact=16,contactDepth=8,reach=30,enterStop=40,roarTicks=40,shake=1}

function c.new()
local a=setmetatable({},c)
a.zombies={}
a.nextId=0
a.boss=nil
return a
end

function c:spawn(k,l,f)
self.nextId=self.nextId+1
local h=c.KINDS[k]
local a=setmetatable({},b)
a.id=self.nextId
a.kind=k
a.stats=h
a.isBoss=h.boss==true
a.hp=h.hp
a.facing=-l
a.x=l<0 and f.left-i or f.right+i
a.z=f.random:int(n,e.DEPTH-n)
a.height=0
a.vx=0
a.state="walk"
a.timer=0
a.cooldown=f.random:int(0,p)
a.clock=0
a.moving=true
a.attacks=0
a.slot=0
a.removed=false
if a.isBoss then
a.state="enter"
self.boss=a
end
self.zombies[#self.zombies+1]=a
return a
end

function c:aliveCount()
local a=0
for h,f in ipairs(self.zombies)do
if f.state~="dying"then
a=a+1
end
end
return a
end

local _={}
local k=nil

local function aa(a,f)
local h,l=math.abs(a.x-k.x),math.abs(f.x-k.x)
if h==l then
return a.id<f.id
end
return h<l
end

function c:assignSlots(l)
k=l
local a=_
for ac,w in ipairs(Z)do
local x=#a
local f=0
for ab,h in ipairs(self.zombies)do
if not h.isBoss and h.state~="dying"and e.sign(h.x-l.x)==w then
f=f+1
a[f]=h
end
end
for h=f+1,x do
a[h]=nil
end
table.sort(a,aa)
for h,ab in ipairs(a)do
ab.slot=h-1
end
end
end

function c:update(f,h)
self:assignSlots(f)
for l,a in ipairs(self.zombies)do
a:update(f,h,self)
end
for a=#self.zombies,1,-1 do
if self.zombies[a].removed then
if self.zombies[a]==self.boss then
self.boss=nil
end
table.remove(self.zombies,a)
end
end
end

function c:strike(h,l,w,x,ab,ac,ad)
local a=0
for ae,f in ipairs(self.zombies)do
if f:hittable()and e.inFront(h,f,l,w,x)and f:takeHit(ab,ac,h.facing,ad)then
a=a+1
end
end
return a
end

function c:grabTarget(h)
local l,f=nil,nil
for x,a in ipairs(self.zombies)do
if not a.isBoss and a:hittable()and e.inFront(h,a,O,P,Q)then
local w=math.abs(a.x-h.x)
if not f or w<f then
l,f=a,w
end
end
end
return l
end

function c:throw(a,f,h)
a.state="thrown"
a.vx=f*S
a.travel=0
a.height=u
h:addScore(W)
end

function c:killAll(f)
for h,a in ipairs(self.zombies)do
if a.state~="dying"then
a:die(a.facing*-1,f)
end
end
end

function b:hittable()
local a=self.state
return a~="dying"and a~="held"and a~="thrown"and a~="down"and a~="rise"and a~="enter"
end

local function l(a,f)
return math.max(1,math.floor(a*f.difficulty.damage+0.5))
end

function b:update(h,f,w)
self.clock=self.clock+1
if self.cooldown>0 then
self.cooldown=self.cooldown-1
end
local a=self.state
if a=="walk"then
self:chase(h,f)
elseif a=="windup"then
self:tickWindup(h,f)
elseif a=="held"then
self:followHolder(h)
elseif a=="thrown"then
self:fly(f,w)
elseif a=="down"or a=="dying"then
self:tickFallen(f)
elseif a=="enter"then
self:tickEnter(f)
elseif a=="chargeWindup"then
self:tickChargeWindup()
elseif a=="charge"then
self:tickCharge(h,f)
elseif a=="spin"then
self:tickSpin(h,f)
elseif a=="bite"then
self.timer=self.timer-1
if self.timer<=0 then
self.state="walk"
end
else
self.timer=self.timer-1
if self.timer<=0 then
self.state="walk"
end
end
end

function b:chase(f,ab)
local a=e.sign(self.x-f.x)
if a==0 then
a=1
end
local ac=self.isBoss and z or y+self.slot*A
local h=f.x+a*ac
local w=f.z
local x=self.stats.speed
local ad,ae=self.x,self.z
self.x=e.approach(self.x,h,x)
self.z=e.approach(self.z,w,x*D)
self.moving=self.x~=ad or self.z~=ae
self.facing=-a
if self.slot==0 and math.abs(self.x-h)<=m and math.abs(self.z-w)<=m and self.cooldown==0 then
self.attacks=self.attacks+1
if self.isBoss and self.attacks%self.stats.chargeEvery==0 then
self.state="chargeWindup"
self.timer=d.chargeWindup
ab:effect("roar")
else
self.state="windup"
self.timer=self.isBoss and self.stats.windup or E
end
end
end

function b:tickWindup(f,a)
self.timer=self.timer-1
if self.timer>0 then
return
end
local h=self.isBoss and d.reach or F
if e.inFront(self,f,0,h,o)then
f:hurt(l(self.stats.damage,a),self.isBoss and self.stats.heavy,self.x,a)
end
self.state="bite"
self.timer=B
if self.stats.rest then
self.cooldown=a.random:int(self.stats.rest,self.stats.rest*2)
else
self.cooldown=a.random:int(p,G)
end
end

function b:followHolder(a)
self.x=a.x+a.facing*R
self.z=a.z
self.facing=-a.facing
end

function b:fly(f,h)
self.x=self.x+self.vx
self.travel=self.travel+math.abs(self.vx)
self.height=math.max(0,u*(1-self.travel/t))
for w,a in ipairs(h.zombies)do
if a~=self and a:hittable()and math.abs(a.x-self.x)<=V and math.abs(a.z-self.z)<=o then
a:takeHit(U,true,e.sign(self.vx),f)
end
end
if self.travel>=t then
self.height=0
self.state="walk"
self:takeHit(T,true,e.sign(self.vx),f)
f:effect("down")
end
end

function b:tickFallen(a)
self.x=self.x+self.vx
self.vx=self.vx*J
self.timer=self.timer-1
if self.timer>0 then
return
end
if self.state=="dying"then
self.removed=true
return
end
self.state="rise"
self.timer=K
end

function b:release()
if self.state=="held"then
self.state="hurt"
self.timer=q
end
end

function b:grab(a)
self.state="held"
self:followHolder(a)
end

function b:blocks(a)
return self.stats.shield==true and self.state=="walk"and self.facing==-a
end

function b:takeHit(h,w,a,f)
if self:blocks(a)then
self.x=self.x+a*C
f:spark(self.x-a*8,self.z,self.height)
f:effect("clang")
return false
end
self.hp=self.hp-h
f:addScore(N)
f:spark(self.x-a*4,self.z,self.height)
if self.hp<=0 then
self:die(a,f)
elseif self.isBoss then
if self.state~="charge"and self.state~="chargeWindup"and self.state~="spin"then
self.state="hurt"
self.timer=M
end
elseif w then
self.state="down"
self.timer=r
self.vx=a*I
self.height=0
else
self.state="hurt"
self.timer=q
self.x=self.x+a*H
self.facing=-a
end
return true
end

function b:die(f,a)
self.state="dying"
self.timer=self.isBoss and s or j
self.vx=f*L
self.height=0
a:addScore(self.stats.score)
a:effect(self.isBoss and"bossDie"or"die")
end

function b:tickEnter(a)
local f=a.right-d.enterStop
if self.x>f then
self.x=self.x-self.stats.speed
self.moving=true
return
end
self.moving=false
self.timer=self.timer+1
if self.timer==1 then
a:effect("roar")
end
if self.timer>=d.roarTicks then
self.state="walk"
self.timer=0
end
end

function b:tickChargeWindup()
self.timer=self.timer-1
if self.timer>0 then
return
end
if self.stats.special=="spin"then
self.state="spin"
self.timer=g.ticks
self.spinFacing=self.facing
return
end
self.state="charge"
self.vx=self.facing*self.stats.chargeSpeed
self.travel=0
end

function b:tickSpin(a,f)
self.timer=self.timer-1
self.moving=false
if math.floor(self.timer/g.turn)%2==0 then
self.facing=self.spinFacing
else
self.facing=-self.spinFacing
end
if self.timer%g.whirl==0 then
f:effect("whoosh")
end
if math.abs(a.x-self.x)<=g.reach and math.abs(a.z-self.z)<=g.depth then
a:hurt(l(self.stats.charge,f),true,self.x,f)
end
if self.timer<=0 then
self.facing=e.sign(a.x-self.x)
if self.facing==0 then
self.facing=self.spinFacing
end
self.state="recover"
self.timer=d.recoverTicks
self.cooldown=d.recoverTicks
end
end

function b:tickCharge(f,a)
self.x=self.x+self.vx
self.travel=self.travel+math.abs(self.vx)
self.moving=true
if math.abs(f.x-self.x)<=d.contact and math.abs(f.z-self.z)<=d.contactDepth then
f:hurt(l(self.stats.charge,a),true,self.x-self.vx*4,a)
end
if self.travel>=d.chargeDistance or self.x<a.left+i or self.x>a.right-i then
self.state="recover"
self.timer=d.recoverTicks
self.cooldown=d.recoverTicks
end
end

function b:frame()
local a=self.state
if a=="windup"then
return"grab",0
elseif a=="chargeWindup"then
return"grab",(self.clock%2)*d.shake*2-d.shake
elseif a=="charge"or a=="spin"then
return"charge",0
elseif a=="bite"then
return"bite",0
elseif a=="hurt"or a=="held"or a=="rise"or a=="recover"then
return"hurt",0
elseif a=="thrown"then
return"fall",0
elseif a=="down"then
return self.timer>r-v and"fall"or"down",0
elseif a=="dying"then
local f=self.isBoss and s or j
return self.timer>f-v and"fall"or"down",0
end
if self.moving then
return Y[math.floor(self.clock/X)%4+1],0
end
return"walk1",0
end

function b:blinking()
return self.state=="dying"and self.timer<j/2 and math.floor(self.timer/3)%2==1
end
