require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"

local c=SpiffBoy.PipeBomber.Zones.TILE

local a={}
SpiffBoy.PipeBomber.Actors=a

a.SPEED=0.75
a.SPEED_STEP=0.25
a.MAX_SPEED=3
a.MAX_RANGE=6
a.MAX_COUNT=6
a.TOUCH=8
a.STEP_TICKS=8
a.SAFE_TICKS=150
a.DYING={hurt=30,kneel=24,lying=66}
a.ZOMBIE_DYING={fall=16,remains=30}
a.FLASH_TICKS=40
a.SURVIVOR_FRAMES={down=0,up=3,right=6,left=9,hurt=12,kneel=13,lying=14,cheer=15}
a.ZOMBIE_FRAMES={right=0,left=2,fall=4,remains=5}
a.WALK_CYCLE={0,1,0,2}
a.ZOMBIES={
shambler={speed=0.375,hp=1,turn=0.2,points=100},
runner={speed=0.875,hp=1,turn=0.5,points=200},
cop={speed=0.5,hp=1,turn=0.2,points=300,track=6},
brute={speed=0.25,hp=2,turn=0.15,points=400},
}
a.DIRECTIONS={
{dx=0,dy=-1,facing="up"},
{dx=0,dy=1,facing="down"},
{dx=-1,dy=0,facing="left"},
{dx=1,dy=0,facing="right"},
}

function a.cellOf(b)
return math.floor(b.x/c+0.5)+1,math.floor(b.y/c+0.5)+1
end

local function k(d,b,h,f,i)
local g=math.floor(b/c+0.5)
local j=g*c
local n=h>0 and math.floor(d/c)+1 or math.ceil(d/c)-1
if b~=j then
if i(n,g)then
return d,b,false
end
local e=math.min(f,math.abs(j-b))
if j>b then
b=b+e
else
b=b-e
end
f=f-e
if f<=0 then
return d,b,true
end
end
local e=d+h*f
if h>0 then
local l=math.ceil(d/c)
local m=math.ceil(e/c)
if m>l and i(m,g)then
e=l*c
end
else
local l=math.floor(d/c)
local m=math.floor(e/c)
if m<l and i(m,g)then
e=l*c
end
end
return e,b,e~=d
end

function a.walk(b,e,h,f,g)
local d
if e~=0 then
b.x,b.y,d=k(b.x,b.y,e,f,function(i,j)return g(i+1,j+1)end)
else
b.y,b.x,d=k(b.y,b.x,h,f,function(i,j)return g(j+1,i+1)end)
end
return d
end

function a.newSurvivor(b,d)
return{
x=(b-1)*c,y=(d-1)*c,facing="down",walkTicks=0,moving=false,
state="alive",timer=0,safe=a.SAFE_TICKS,
}
end

function a.killSurvivor(b)
b.state="dying"
b.timer=a.DYING.hurt+a.DYING.kneel+a.DYING.lying
end

function a.survivorFrame(b)
local d=a.SURVIVOR_FRAMES
if b.state=="dying"then
local e=b.timer
if e>a.DYING.kneel+a.DYING.lying then
return d.hurt
elseif e>a.DYING.lying then
return d.kneel
end
return d.lying
elseif b.state=="cheer"then
return d.cheer
end
local e=d[b.facing]
if not b.moving then
return e
end
local f=a.WALK_CYCLE
return e+f[math.floor(b.walkTicks/a.STEP_TICKS)%#f+1]
end

function a.newZombie(d,g,h,i)
local b=a.ZOMBIES[d]
local e,f=(g-1)*c,(h-1)*c
return{
kind=d,stats=b,x=e,y=f,tx=e,ty=f,speed=b.speed*i,
hp=b.hp,flash=0,facing="right",walkTicks=0,state="walk",timer=0,dir=nil,
}
end

function a.openDirections(e,f,g)
local b={}
for h,d in ipairs(a.DIRECTIONS)do
if not g(e+d.dx,f+d.dy)then
b[#b+1]=d
end
end
return b
end

function a.towards(g,h,i,j,l,m)
local b,d={},nil
for n,e in ipairs(g)do
local f=math.abs(h+e.dx-j)+math.abs(i+e.dy-l)
if not d or f<d then
b,d={e},f
elseif f==d then
b[#b+1]=e
end
end
return b[m:int(1,#b)]
end

function a.wander(d,e,h,g)
if d.dir then
for f,b in ipairs(e)do
if b==d.dir and not g:chance(h)then
return b
end
end
end
local b={}
for j,f in ipairs(e)do
local i=d.dir and f.dx==-d.dir.dx and f.dy==-d.dir.dy
if not i then
b[#b+1]=f
end
end
if#b==0 then
b=e
end
return b[g:int(1,#b)]
end

function a.advance(b,d)
local e,f=b.tx-b.x,b.ty-b.y
b.x=b.x+SpiffBoy.clamp(e,-d,d)
b.y=b.y+SpiffBoy.clamp(f,-d,d)
if e~=0 or f~=0 then
b.walkTicks=b.walkTicks+1
end
return b.x==b.tx and b.y==b.ty
end

function a.aim(b,d)
b.dir=d
if not d then
return
end
b.tx=b.x+d.dx*c
b.ty=b.y+d.dy*c
if d.dx~=0 then
b.facing=d.facing
end
end

function a.updateZombie(b,d)
if b.flash>0 then
b.flash=b.flash-1
end
if b.state=="dying"then
b.timer=b.timer-1
return
end
if b.x==b.tx and b.y==b.ty then
local e,f=a.cellOf(b)
local g=a.openDirections(e,f,function(g,h)return d:closedToZombie(g,h)end)
if#g==0 then
a.aim(b,nil)
return
end
local h,i=d:survivorCell()
local j=b.stats.track
if j and a.distanceTo(e,f,h,i)<=j then
a.aim(b,a.towards(g,e,f,h,i,d.random))
else
a.aim(b,a.wander(b,g,b.stats.turn,d.random))
end
end
a.advance(b,b.speed)
end

function a.distanceTo(b,d,e,f)
return math.abs(b-e)+math.abs(d-f)
end

function a.hitZombie(b)
if b.state=="dying"or b.flash>0 then
return false
end
b.hp=b.hp-1
if b.hp>0 then
b.flash=a.FLASH_TICKS
return false
end
b.state="dying"
b.timer=a.ZOMBIE_DYING.fall+a.ZOMBIE_DYING.remains
return true
end

function a.zombieFrame(b)
local d=a.ZOMBIE_FRAMES
if b.state=="dying"then
if b.timer>a.ZOMBIE_DYING.remains then
return d.fall
end
return d.remains
end
return d[b.facing]+math.floor(b.walkTicks/a.STEP_TICKS)%2
end

function a.touch(b,d)
return math.abs(b.x-d.x)<a.TOUCH and math.abs(b.y-d.y)<a.TOUCH
end
