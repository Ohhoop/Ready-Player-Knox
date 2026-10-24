require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/DoubleRaccoon/Combat"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local f=SpiffBoy.DoubleRaccoon.Combat

local d={}
d.__index=d
SpiffBoy.DoubleRaccoon.Horde=d

local c={}
c.__index=c

d.KINDS={
shambler={hp=8,speed=0.35,damage=2,score=100},
woman={hp=6,speed=0.42,damage=2,score=100},
runner={hp=5,speed=0.8,damage=1,score=150},
cop={hp=12,speed=0.35,damage=3,score=200},
lumberjack={hp=70,speed=0.5,damage=5,charge=6,chargeEvery=3,windup=26,heavy=true,special="spin",score=5000,boss=true},
linebacker={hp=80,speed=0.55,damage=4,charge=7,chargeEvery=2,chargeSpeed=3.2,windup=22,heavy=true,special="charge",score=6000,boss=true},
riot={hp=90,speed=0.45,damage=5,charge=6,chargeEvery=4,chargeSpeed=2.4,windup=24,heavy=true,shield=true,special="charge",score=7000,boss=true},
evil={hp=100,speed=0.9,damage=3,charge=5,chargeEvery=3,chargeSpeed=3.4,windup=12,heavy=false,rest=18,special="charge",score=10000,boss=true},
}

local x=21
local y=24
local z=14
local A=10
local B=2
local l=3
local C=0.6
local h=20
local m=4
local D=20
local E=24
local n=7
local o=40
local F=80
local p=14
local G=2
local q=50
local H=2.5
local I=0.85
local J=12
local j=40
local K=2
local r=120
local L=6
local M=10
local N=2
local O=22
local P=6
local Q=16
local R=3.2
local s=48
local t=10
local S=6
local T=4
local U=10
local V=50
local W=10
local X={"walk1","walk2","walk3","walk4"}
local Y={-1,1}
local u=8
local g={ticks=100,turn=4,reach=26,depth=8,whirl=16}
local e={chargeWindup=36,chargeDistance=150,recoverTicks=50,contact=16,contactDepth=8,reach=30,enterStop=40,roarTicks=40,shake=1}

function d.new()
local a=setmetatable({},d)
a.zombies={}
a.nextId=0
a.boss=nil
return a
end

function d:spawn(kind,side,world)
self.nextId=self.nextId+1
local b=d.KINDS[kind]
local a=setmetatable({},c)
a.id=self.nextId
a.kind=kind
a.stats=b
a.isBoss=b.boss==true
a.hp=b.hp
a.facing=-side
a.x=side<0 and world.left-h or world.right+h
a.z=world.random:int(m,f.DEPTH-m)
a.height=0
a.vx=0
a.state="walk"
a.timer=0
a.cooldown=world.random:int(0,o)
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

function d:aliveCount()
local a=0
for i,b in ipairs(self.zombies)do
if b.state~="dying"then
a=a+1
end
end
return a
end

local Z={}
local k=nil

local function _(a,b)
local i,v=math.abs(a.x-k.x),math.abs(b.x-k.x)
if i==v then
return a.id<b.id
end
return i<v
end

function d:assignSlots(fighter)
k=fighter
local a=Z
for ab,v in ipairs(Y)do
local w=#a
local b=0
for aa,i in ipairs(self.zombies)do
if not i.isBoss and i.state~="dying"and f.sign(i.x-fighter.x)==v then
b=b+1
a[b]=i
end
end
for i=b+1,w do
a[i]=nil
end
table.sort(a,_)
for i,aa in ipairs(a)do
aa.slot=i-1
end
end
end

function d:update(fighter,world)
self:assignSlots(fighter)
for b,a in ipairs(self.zombies)do
a:update(fighter,world,self)
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

function d:strike(fighter,near,far,depth,damage,knock,world)
local a=0
for i,b in ipairs(self.zombies)do
if b:hittable()and f.inFront(fighter,b,near,far,depth)and b:takeHit(damage,knock,fighter.facing,world)then
a=a+1
end
end
return a
end

function d:grabTarget(fighter)
local i,b=nil,nil
for w,a in ipairs(self.zombies)do
if not a.isBoss and a:hittable()and f.inFront(fighter,a,N,O,P)then
local v=math.abs(a.x-fighter.x)
if not b or v<b then
i,b=a,v
end
end
end
return i
end

function d:throw(zombie,facing,world)
zombie.state="thrown"
zombie.vx=facing*R
zombie.travel=0
zombie.height=t
world:addScore(V)
end

function d:killAll(world)
for b,a in ipairs(self.zombies)do
if a.state~="dying"then
a:die(a.facing*-1,world)
end
end
end

function c:hittable()
local a=self.state
return a~="dying"and a~="held"and a~="thrown"and a~="down"and a~="rise"and a~="enter"
end

local function b(damage,world)
return math.max(1,math.floor(damage*world.difficulty.damage+0.5))
end

function c:update(fighter,world,horde)
self.clock=self.clock+1
if self.cooldown>0 then
self.cooldown=self.cooldown-1
end
local a=self.state
if a=="walk"then
self:chase(fighter,world)
elseif a=="windup"then
self:tickWindup(fighter,world)
elseif a=="held"then
self:followHolder(fighter)
elseif a=="thrown"then
self:fly(world,horde)
elseif a=="down"or a=="dying"then
self:tickFallen(world)
elseif a=="enter"then
self:tickEnter(world)
elseif a=="chargeWindup"then
self:tickChargeWindup()
elseif a=="charge"then
self:tickCharge(fighter,world)
elseif a=="spin"then
self:tickSpin(fighter,world)
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

function c:chase(fighter,world)
local a=f.sign(self.x-fighter.x)
if a==0 then
a=1
end
local aa=self.isBoss and y or x+self.slot*z
local i=fighter.x+a*aa
local v=fighter.z
local w=self.stats.speed
local ab,ac=self.x,self.z
self.x=f.approach(self.x,i,w)
self.z=f.approach(self.z,v,w*C)
self.moving=self.x~=ab or self.z~=ac
self.facing=-a
if self.slot==0 and math.abs(self.x-i)<=l and math.abs(self.z-v)<=l and self.cooldown==0 then
self.attacks=self.attacks+1
if self.isBoss and self.attacks%self.stats.chargeEvery==0 then
self.state="chargeWindup"
self.timer=e.chargeWindup
world:effect("roar")
else
self.state="windup"
self.timer=self.isBoss and self.stats.windup or D
end
end
end

function c:tickWindup(fighter,world)
self.timer=self.timer-1
if self.timer>0 then
return
end
local a=self.isBoss and e.reach or E
if f.inFront(self,fighter,0,a,n)then
fighter:hurt(b(self.stats.damage,world),self.isBoss and self.stats.heavy,self.x,world)
end
self.state="bite"
self.timer=A
if self.stats.rest then
self.cooldown=world.random:int(self.stats.rest,self.stats.rest*2)
else
self.cooldown=world.random:int(o,F)
end
end

function c:followHolder(fighter)
self.x=fighter.x+fighter.facing*Q
self.z=fighter.z
self.facing=-fighter.facing
end

function c:fly(world,horde)
self.x=self.x+self.vx
self.travel=self.travel+math.abs(self.vx)
self.height=math.max(0,t*(1-self.travel/s))
for i,a in ipairs(horde.zombies)do
if a~=self and a:hittable()and math.abs(a.x-self.x)<=U and math.abs(a.z-self.z)<=n then
a:takeHit(T,true,f.sign(self.vx),world)
end
end
if self.travel>=s then
self.height=0
self.state="walk"
self:takeHit(S,true,f.sign(self.vx),world)
world:effect("down")
end
end

function c:tickFallen(world)
self.x=self.x+self.vx
self.vx=self.vx*I
self.timer=self.timer-1
if self.timer>0 then
return
end
if self.state=="dying"then
self.removed=true
return
end
self.state="rise"
self.timer=J
end

function c:release()
if self.state=="held"then
self.state="hurt"
self.timer=p
end
end

function c:grab(fighter)
self.state="held"
self:followHolder(fighter)
end

function c:blocks(facing)
return self.stats.shield==true and self.state=="walk"and self.facing==-facing
end

function c:takeHit(damage,knock,facing,world)
if self:blocks(facing)then
self.x=self.x+facing*B
world:spark(self.x-facing*8,self.z,self.height)
world:effect("clang")
return false
end
self.hp=self.hp-damage
world:addScore(M)
world:spark(self.x-facing*4,self.z,self.height)
if self.hp<=0 then
self:die(facing,world)
elseif self.isBoss then
if self.state~="charge"and self.state~="chargeWindup"and self.state~="spin"then
self.state="hurt"
self.timer=L
end
elseif knock then
self.state="down"
self.timer=q
self.vx=facing*H
self.height=0
else
self.state="hurt"
self.timer=p
self.x=self.x+facing*G
self.facing=-facing
end
return true
end

function c:die(facing,world)
self.state="dying"
self.timer=self.isBoss and r or j
self.vx=facing*K
self.height=0
world:addScore(self.stats.score)
world:effect(self.isBoss and"bossDie"or"die")
end

function c:tickEnter(world)
local a=world.right-e.enterStop
if self.x>a then
self.x=self.x-self.stats.speed
self.moving=true
return
end
self.moving=false
self.timer=self.timer+1
if self.timer==1 then
world:effect("roar")
end
if self.timer>=e.roarTicks then
self.state="walk"
self.timer=0
end
end

function c:tickChargeWindup()
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

function c:tickSpin(fighter,world)
self.timer=self.timer-1
self.moving=false
if math.floor(self.timer/g.turn)%2==0 then
self.facing=self.spinFacing
else
self.facing=-self.spinFacing
end
if self.timer%g.whirl==0 then
world:effect("whoosh")
end
if math.abs(fighter.x-self.x)<=g.reach and math.abs(fighter.z-self.z)<=g.depth then
fighter:hurt(b(self.stats.charge,world),true,self.x,world)
end
if self.timer<=0 then
self.facing=f.sign(fighter.x-self.x)
if self.facing==0 then
self.facing=self.spinFacing
end
self.state="recover"
self.timer=e.recoverTicks
self.cooldown=e.recoverTicks
end
end

function c:tickCharge(fighter,world)
self.x=self.x+self.vx
self.travel=self.travel+math.abs(self.vx)
self.moving=true
if math.abs(fighter.x-self.x)<=e.contact and math.abs(fighter.z-self.z)<=e.contactDepth then
fighter:hurt(b(self.stats.charge,world),true,self.x-self.vx*4,world)
end
if self.travel>=e.chargeDistance or self.x<world.left+h or self.x>world.right-h then
self.state="recover"
self.timer=e.recoverTicks
self.cooldown=e.recoverTicks
end
end

function c:frame()
local a=self.state
if a=="windup"then
return"grab",0
elseif a=="chargeWindup"then
return"grab",(self.clock%2)*e.shake*2-e.shake
elseif a=="charge"or a=="spin"then
return"charge",0
elseif a=="bite"then
return"bite",0
elseif a=="hurt"or a=="held"or a=="rise"or a=="recover"then
return"hurt",0
elseif a=="thrown"then
return"fall",0
elseif a=="down"then
return self.timer>q-u and"fall"or"down",0
elseif a=="dying"then
local i=self.isBoss and r or j
return self.timer>i-u and"fall"or"down",0
end
if self.moving then
return X[math.floor(self.clock/W)%4+1],0
end
return"walk1",0
end

function c:blinking()
return self.state=="dying"and self.timer<j/2 and math.floor(self.timer/3)%2==1
end
