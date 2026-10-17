require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Actors"

local h=SpiffBoy.PipeBomber.Zones.TILE
local c=SpiffBoy.PipeBomber.Actors

local b={}
SpiffBoy.PipeBomber.Bosses=b

b.KINDS={
inmate={hp=3,speed=0.375,charge=1.75,stun=60,points=2000},
worker={hp=4,speed=0.375,act="crates",every=300,crates=3,points=2500},
neighbour={hp=4,speed=0.375,act="spawn",every=360,spawn={"shambler"},cap=4,points=3000},
coach={hp=5,speed=0.5,act="spawn",every=420,spawn={"runner"},cap=3,points=3500},
golfer={hp=5,speed=0.5,shootEvery=120,shot="ball",points=4000},
farmer={hp=6,speed=0.5,throughCrates=true,windup=30,track=6,points=4500},
soldier={hp=6,speed=0.5,act="grenade",every=240,points=5000},
mother={hp=10,speed=0.25,act="spawn",every=300,spawn={"shambler","runner","cop","brute"},cap=5,shootEvery=200,shot="bile",points=20000,big=true},
}
b.HIT_TICKS=60
b.DYING_TICKS=120
b.SHOT_SPEED=2
b.SHOT_TOUCH=7
b.TOUCH=10
b.FRAMES={right=0,left=2,flash=4,fallen=5}
b.MOTHER_FRAMES={sway=0,flash=2,fallen=3}
b.MOTHER_SWAY=20

function b.new(d,g,i,j)
local a=b.KINDS[d]
local e,f=(g-1)*h,(i-1)*h
return{
kind=d,stats=a,x=e,y=f,tx=e,ty=f,speed=a.speed*j,hp=a.hp,
flash=0,facing="left",walkTicks=0,state="walk",timer=0,dir=nil,
cooldown=a.every,shootCooldown=a.shootEvery,spawnIndex=0,
}
end

function b.closed(f,a,d,e)
if f.stats.throughCrates and e.grid:isCrate(a,d)and not e.grid:isHard(a,d)then
return e.bombs:at(a,d)~=nil
end
return e:closedToZombie(a,d)
end

function b.lineTo(a,d,m)
local e,f=m:survivorCell()
if e~=a and f~=d then
return nil
end
if e==a and f==d then
return nil
end
local j=e>a and 1 or(e<a and-1 or 0)
local k=f>d and 1 or(f<d and-1 or 0)
local g,i=a+j,d+k
while g~=e or i~=f do
if m:closedToZombie(g,i)then
return nil
end
g,i=g+j,i+k
end
for n,l in ipairs(c.DIRECTIONS)do
if l.dx==j and l.dy==k then
return l
end
end
return nil
end

function b.hit(a)
if a.state=="dying"or a.flash>0 then
return false
end
a.hp=a.hp-1
a.flash=b.HIT_TICKS
if a.hp>0 then
return false
end
a.state="dying"
a.timer=b.DYING_TICKS
return true
end

local function m(a,d,e)
e:addShot(a.stats.shot,a.x+h/2,a.y+h/2,d.dx,d.dy)
end

local function n(a,f,g,e)
local d=a.stats
a.cooldown=a.cooldown-1
if a.cooldown>0 then
return
end
a.cooldown=d.every
if d.act=="crates"then
e:layCrates(f,g,d.crates)
elseif d.act=="spawn"then
a.spawnIndex=a.spawnIndex%#d.spawn+1
e:callZombie(d.spawn[a.spawnIndex],f,g,d.cap)
else
e:throwGrenade()
end
end

local function o(a,f,g,e)
local d=a.stats
local i=b.lineTo(f,g,e)
if d.charge and i then
a.state="charge"
c.aim(a,i)
return
end
if d.shot and i and a.shootCooldown<=0 then
m(a,i,e)
a.shootCooldown=d.shootEvery
end
local j,k=e:survivorCell()
if d.windup and c.distanceTo(f,g,j,k)==1 then
a.state="windup"
a.timer=d.windup
a.strikeColumn,a.strikeRow=j,k
c.aim(a,nil)
return
end
local l=c.openDirections(f,g,function(l,p)return b.closed(a,l,p,e)end)
if#l==0 then
c.aim(a,nil)
return
end
if d.track and c.distanceTo(f,g,j,k)<=d.track then
c.aim(a,c.towards(l,f,g,j,k,e.random))
return
end
c.aim(a,c.wander(a,l,0.3,e.random))
end

local function g(a,d)
if a.x==a.tx and a.y==a.ty then
local e,f=c.cellOf(a)
if d:closedToZombie(e+a.dir.dx,f+a.dir.dy)then
a.state="stunned"
a.timer=a.stats.stun
d:bossThud()
return
end
c.aim(a,a.dir)
end
c.advance(a,a.stats.charge)
end

function b.update(a,d)
if a.flash>0 then
a.flash=a.flash-1
end
if a.shootCooldown and a.shootCooldown>0 then
a.shootCooldown=a.shootCooldown-1
end
if a.state=="dying"then
a.timer=a.timer-1
return
end
if a.state=="stunned"then
a.timer=a.timer-1
if a.timer<=0 then
a.state="walk"
end
return
end
if a.state=="windup"then
a.timer=a.timer-1
if a.timer<=0 then
a.state="walk"
d:strike(a.strikeColumn,a.strikeRow)
end
return
end
if a.state=="charge"then
g(a,d)
return
end
local e,f=c.cellOf(a)
if a.stats.act then
n(a,e,f,d)
end
if a.x==a.tx and a.y==a.ty then
o(a,e,f,d)
if a.state~="walk"then
return
end
end
c.advance(a,a.speed)
end

function b.frame(a,f)
local e=a.stats.big
local d=e and b.MOTHER_FRAMES or b.FRAMES
if a.state=="dying"and a.timer<b.DYING_TICKS/2 then
return d.fallen
elseif a.flash>0 and math.floor(a.flash/4)%2==0 then
return d.flash
end
if e then
return d.sway+math.floor(f/b.MOTHER_SWAY)%2
end
return d[a.facing]+math.floor(a.walkTicks/c.STEP_TICKS)%2
end
