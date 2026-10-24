require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"

local e=SpiffBoy.PipeBomber.Zones.TILE

local d={}
SpiffBoy.PipeBomber.Actors=d

d.SPEED=0.75
d.SPEED_STEP=0.25
d.MAX_SPEED=3
d.MAX_RANGE=6
d.MAX_COUNT=6
d.TOUCH=8
d.STEP_TICKS=8
d.SAFE_TICKS=150
d.DYING={hurt=30,kneel=24,lying=66}
d.ZOMBIE_DYING={fall=16,remains=30}
d.FLASH_TICKS=40
d.SURVIVOR_FRAMES={down=0,up=3,right=6,left=9,hurt=12,kneel=13,lying=14,cheer=15}
d.ZOMBIE_FRAMES={right=0,left=2,fall=4,remains=5}
d.WALK_CYCLE={0,1,0,2}
d.ZOMBIES={
shambler={speed=0.375,hp=1,turn=0.2,points=100},
runner={speed=0.875,hp=1,turn=0.5,points=200},
cop={speed=0.5,hp=1,turn=0.2,points=300,track=6},
brute={speed=0.25,hp=2,turn=0.15,points=400},
}
d.DIRECTIONS={
{dx=0,dy=-1,facing="up"},
{dx=0,dy=1,facing="down"},
{dx=-1,dy=0,facing="left"},
{dx=1,dy=0,facing="right"},
}

function d.cellOf(actor)
return math.floor(actor.x/e+0.5)+1,math.floor(actor.y/e+0.5)+1
end

local function g(along,across,sign,speed,closed)
local b=math.floor(across/e+0.5)
local c=b*e
local i=sign>0 and math.floor(along/e)+1 or math.ceil(along/e)-1
if across~=c then
if closed(i,b)then
return along,across,false
end
local a=math.min(speed,math.abs(c-across))
if c>across then
across=across+a
else
across=across-a
end
speed=speed-a
if speed<=0 then
return along,across,true
end
end
local a=along+sign*speed
if sign>0 then
local f=math.ceil(along/e)
local h=math.ceil(a/e)
if h>f and closed(h,b)then
a=f*e
end
else
local f=math.floor(along/e)
local h=math.floor(a/e)
if h<f and closed(h,b)then
a=f*e
end
end
return a,across,a~=along
end

function d.walk(actor,dx,dy,speed,closed)
local c
if dx~=0 then
actor.x,actor.y,c=g(actor.x,actor.y,dx,speed,function(a,b)return closed(a+1,b+1)end)
else
actor.y,actor.x,c=g(actor.y,actor.x,dy,speed,function(a,b)return closed(b+1,a+1)end)
end
return c
end

function d.newSurvivor(column,row)
return{
x=(column-1)*e,y=(row-1)*e,facing="down",walkTicks=0,moving=false,
state="alive",timer=0,safe=d.SAFE_TICKS,
}
end

function d.killSurvivor(survivor)
survivor.state="dying"
survivor.timer=d.DYING.hurt+d.DYING.kneel+d.DYING.lying
end

function d.survivorFrame(survivor)
local a=d.SURVIVOR_FRAMES
if survivor.state=="dying"then
local b=survivor.timer
if b>d.DYING.kneel+d.DYING.lying then
return a.hurt
elseif b>d.DYING.lying then
return a.kneel
end
return a.lying
elseif survivor.state=="cheer"then
return a.cheer
end
local b=a[survivor.facing]
if not survivor.moving then
return b
end
local c=d.WALK_CYCLE
return b+c[math.floor(survivor.walkTicks/d.STEP_TICKS)%#c+1]
end

function d.newZombie(kind,column,row,pace)
local a=d.ZOMBIES[kind]
local b,c=(column-1)*e,(row-1)*e
return{
kind=kind,stats=a,x=b,y=c,tx=b,ty=c,speed=a.speed*pace,
hp=a.hp,flash=0,facing="right",walkTicks=0,state="walk",timer=0,dir=nil,
}
end

function d.openDirections(column,row,closed)
local a={}
for c,b in ipairs(d.DIRECTIONS)do
if not closed(column+b.dx,row+b.dy)then
a[#a+1]=b
end
end
return a
end

function d.towards(open,column,row,goalColumn,goalRow,random)
local a,b={},nil
for h,c in ipairs(open)do
local f=math.abs(column+c.dx-goalColumn)+math.abs(row+c.dy-goalRow)
if not b or f<b then
a,b={c},f
elseif f==b then
a[#a+1]=c
end
end
return a[random:int(1,#a)]
end

function d.wander(walker,open,turn,random)
if walker.dir then
for b,a in ipairs(open)do
if a==walker.dir and not random:chance(turn)then
return a
end
end
end
local a={}
for f,b in ipairs(open)do
local c=walker.dir and b.dx==-walker.dir.dx and b.dy==-walker.dir.dy
if not c then
a[#a+1]=b
end
end
if#a==0 then
a=open
end
return a[random:int(1,#a)]
end

function d.advance(walker,speed)
local a,b=walker.tx-walker.x,walker.ty-walker.y
walker.x=walker.x+SpiffBoy.clamp(a,-speed,speed)
walker.y=walker.y+SpiffBoy.clamp(b,-speed,speed)
if a~=0 or b~=0 then
walker.walkTicks=walker.walkTicks+1
end
return walker.x==walker.tx and walker.y==walker.ty
end

function d.aim(walker,dir)
walker.dir=dir
if not dir then
return
end
walker.tx=walker.x+dir.dx*e
walker.ty=walker.y+dir.dy*e
if dir.dx~=0 then
walker.facing=dir.facing
end
end

function d.updateZombie(zombie,world)
if zombie.flash>0 then
zombie.flash=zombie.flash-1
end
if zombie.state=="dying"then
zombie.timer=zombie.timer-1
return
end
if zombie.x==zombie.tx and zombie.y==zombie.ty then
local a,b=d.cellOf(zombie)
local c=d.openDirections(a,b,function(c,r)return world:closedToZombie(c,r)end)
if#c==0 then
d.aim(zombie,nil)
return
end
local f,h=world:survivorCell()
local i=zombie.stats.track
if i and d.distanceTo(a,b,f,h)<=i then
d.aim(zombie,d.towards(c,a,b,f,h,world.random))
else
d.aim(zombie,d.wander(zombie,c,zombie.stats.turn,world.random))
end
end
d.advance(zombie,zombie.speed)
end

function d.distanceTo(c1,r1,c2,r2)
return math.abs(c1-c2)+math.abs(r1-r2)
end

function d.hitZombie(zombie)
if zombie.state=="dying"or zombie.flash>0 then
return false
end
zombie.hp=zombie.hp-1
if zombie.hp>0 then
zombie.flash=d.FLASH_TICKS
return false
end
zombie.state="dying"
zombie.timer=d.ZOMBIE_DYING.fall+d.ZOMBIE_DYING.remains
return true
end

function d.zombieFrame(zombie)
local a=d.ZOMBIE_FRAMES
if zombie.state=="dying"then
if zombie.timer>d.ZOMBIE_DYING.remains then
return a.fall
end
return a.remains
end
return a[zombie.facing]+math.floor(zombie.walkTicks/d.STEP_TICKS)%2
end

function d.touch(a,b)
return math.abs(a.x-b.x)<d.TOUCH and math.abs(a.y-b.y)<d.TOUCH
end
