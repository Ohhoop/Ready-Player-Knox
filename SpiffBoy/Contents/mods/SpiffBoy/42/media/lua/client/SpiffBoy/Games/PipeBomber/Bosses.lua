require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Actors"

local e=SpiffBoy.PipeBomber.Zones.TILE
local b=SpiffBoy.PipeBomber.Actors

local a={}
SpiffBoy.PipeBomber.Bosses=a

a.KINDS={
inmate={hp=3,speed=0.375,charge=1.75,stun=60,points=2000},
worker={hp=4,speed=0.375,act="crates",every=300,crates=3,points=2500},
neighbour={hp=4,speed=0.375,act="spawn",every=360,spawn={"shambler"},cap=4,points=3000},
coach={hp=5,speed=0.5,act="spawn",every=420,spawn={"runner"},cap=3,points=3500},
golfer={hp=5,speed=0.5,shootEvery=120,shot="ball",points=4000},
farmer={hp=6,speed=0.5,throughCrates=true,windup=30,track=6,points=4500},
soldier={hp=6,speed=0.5,act="grenade",every=240,points=5000},
mother={hp=10,speed=0.25,act="spawn",every=300,spawn={"shambler","runner","cop","brute"},cap=5,shootEvery=200,shot="bile",points=20000,big=true},
}
a.HIT_TICKS=60
a.DYING_TICKS=120
a.SHOT_SPEED=2
a.SHOT_TOUCH=7
a.TOUCH=10
a.FRAMES={right=0,left=2,flash=4,fallen=5}
a.MOTHER_FRAMES={sway=0,flash=2,fallen=3}
a.MOTHER_SWAY=20

function a.new(kind,column,row,pace)
local c=a.KINDS[kind]
local d,f=(column-1)*e,(row-1)*e
return{
kind=kind,stats=c,x=d,y=f,tx=d,ty=f,speed=c.speed*pace,hp=c.hp,
flash=0,facing="left",walkTicks=0,state="walk",timer=0,dir=nil,
cooldown=c.every,shootCooldown=c.shootEvery,spawnIndex=0,
}
end

function a.closed(boss,column,row,world)
if boss.stats.throughCrates and world.grid:isCrate(column,row)and not world.grid:isHard(column,row)then
return world.bombs:at(column,row)~=nil
end
return world:closedToZombie(column,row)
end

function a.lineTo(column,row,world)
local c,d=world:survivorCell()
if c~=column and d~=row then
return nil
end
if c==column and d==row then
return nil
end
local h=c>column and 1 or(c<column and-1 or 0)
local i=d>row and 1 or(d<row and-1 or 0)
local f,g=column+h,row+i
while f~=c or g~=d do
if world:closedToZombie(f,g)then
return nil
end
f,g=f+h,g+i
end
for k,j in ipairs(b.DIRECTIONS)do
if j.dx==h and j.dy==i then
return j
end
end
return nil
end

function a.hit(boss)
if boss.state=="dying"or boss.flash>0 then
return false
end
boss.hp=boss.hp-1
boss.flash=a.HIT_TICKS
if boss.hp>0 then
return false
end
boss.state="dying"
boss.timer=a.DYING_TICKS
return true
end

local function i(boss,dir,world)
world:addShot(boss.stats.shot,boss.x+e/2,boss.y+e/2,dir.dx,dir.dy)
end

local function j(boss,column,row,world)
local c=boss.stats
boss.cooldown=boss.cooldown-1
if boss.cooldown>0 then
return
end
boss.cooldown=c.every
if c.act=="crates"then
world:layCrates(column,row,c.crates)
elseif c.act=="spawn"then
boss.spawnIndex=boss.spawnIndex%#c.spawn+1
world:callZombie(c.spawn[boss.spawnIndex],column,row,c.cap)
else
world:throwGrenade()
end
end

local function k(boss,column,row,world)
local d=boss.stats
local f=a.lineTo(column,row,world)
if d.charge and f then
boss.state="charge"
b.aim(boss,f)
return
end
if d.shot and f and boss.shootCooldown<=0 then
i(boss,f,world)
boss.shootCooldown=d.shootEvery
end
local g,h=world:survivorCell()
if d.windup and b.distanceTo(column,row,g,h)==1 then
boss.state="windup"
boss.timer=d.windup
boss.strikeColumn,boss.strikeRow=g,h
b.aim(boss,nil)
return
end
local c=b.openDirections(column,row,function(c,r)return a.closed(boss,c,r,world)end)
if#c==0 then
b.aim(boss,nil)
return
end
if d.track and b.distanceTo(column,row,g,h)<=d.track then
b.aim(boss,b.towards(c,column,row,g,h,world.random))
return
end
b.aim(boss,b.wander(boss,c,0.3,world.random))
end

local function f(boss,world)
if boss.x==boss.tx and boss.y==boss.ty then
local c,d=b.cellOf(boss)
if world:closedToZombie(c+boss.dir.dx,d+boss.dir.dy)then
boss.state="stunned"
boss.timer=boss.stats.stun
world:bossThud()
return
end
b.aim(boss,boss.dir)
end
b.advance(boss,boss.stats.charge)
end

function a.update(boss,world)
if boss.flash>0 then
boss.flash=boss.flash-1
end
if boss.shootCooldown and boss.shootCooldown>0 then
boss.shootCooldown=boss.shootCooldown-1
end
if boss.state=="dying"then
boss.timer=boss.timer-1
return
end
if boss.state=="stunned"then
boss.timer=boss.timer-1
if boss.timer<=0 then
boss.state="walk"
end
return
end
if boss.state=="windup"then
boss.timer=boss.timer-1
if boss.timer<=0 then
boss.state="walk"
world:strike(boss.strikeColumn,boss.strikeRow)
end
return
end
if boss.state=="charge"then
f(boss,world)
return
end
local c,d=b.cellOf(boss)
if boss.stats.act then
j(boss,c,d,world)
end
if boss.x==boss.tx and boss.y==boss.ty then
k(boss,c,d,world)
if boss.state~="walk"then
return
end
end
b.advance(boss,boss.speed)
end

function a.frame(boss,clock)
local d=boss.stats.big
local c=d and a.MOTHER_FRAMES or a.FRAMES
if boss.state=="dying"and boss.timer<a.DYING_TICKS/2 then
return c.fallen
elseif boss.flash>0 and math.floor(boss.flash/4)%2==0 then
return c.flash
end
if d then
return c.sway+math.floor(clock/a.MOTHER_SWAY)%2
end
return c[boss.facing]+math.floor(boss.walkTicks/b.STEP_TICKS)%2
end
