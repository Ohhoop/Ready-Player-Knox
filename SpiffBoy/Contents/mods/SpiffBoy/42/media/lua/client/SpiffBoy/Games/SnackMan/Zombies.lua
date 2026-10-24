require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Maze"
require"SpiffBoy/Games/SnackMan/Actors"
require"SpiffBoy/Games/SnackMan/Rules"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a=SpiffBoy.SnackMan.Maze
local o=SpiffBoy.SnackMan.Mover
local c=SpiffBoy.SnackMan.Rules
local e=a.DIRECTIONS

local b={}
b.__index=b
SpiffBoy.SnackMan.Zombies=b

b.PEN="pen"
b.LEAVE="leave"
b.WALK="walk"
b.EYES="eyes"
b.ENTER="enter"
b.CATCH=4

local j={
runner={x=a.COLUMNS-2,y=-2},
cop={x=3,y=-2},
woman={x=a.COLUMNS,y=a.ROWS+2},
shambler={x=1,y=a.ROWS+2},
}
local p=2
local q=0.25

local function r(slot,count)
local d=a.centre(a.PEN.left,a.PEN.y)
local f=a.centre(a.PEN.right,a.PEN.y)
if count<=1 then
return(d+f)/2
end
return d+(slot-1)*(f-d)/(count-1)
end

function b.new(kinds,horde,tuning)
local d=setmetatable({},b)
d.horde=horde
d.tuning=tuning
d.list={}
for f,g in ipairs(kinds)do
d.list[f]={kind=g,index=f,mover=o.new(a.OUTSIDE.x,a.OUTSIDE.y,"left")}
end
d:reset()
return d
end

function b:reset()
local h=#self.list-1
for g,d in ipairs(self.list)do
local f=d.mover
d.scared=false
d.eaten=false
if g==1 then
f:place(a.OUTSIDE.x,a.OUTSIDE.y,"left")
f.dir="left"
d.state=b.WALK
else
f:place(a.PEN.left,a.PEN.y,"up")
f.x=r(g-1,h)
d.homeX=f.x
d.state=b.PEN
d.bob=0
end
end
self.clock=0
self.phase=1
self.phaseTimer=c.SCHEDULE[1]
end

function b:scattering()
return not self.horde and self.phase<=#c.SCHEDULE and self.phase%2==1
end

function b:reverseAll()
for g,f in ipairs(self.list)do
local d=f.mover
if f.state==b.WALK and d.dir then
d.dir=e[d.dir].back
d.facing=d.dir
end
end
end

function b:scare()
for f,d in ipairs(self.list)do
if d.state~=b.EYES and d.state~=b.ENTER then
d.scared=true
end
end
self:reverseAll()
end

function b:calm()
for f,d in ipairs(self.list)do
d.scared=false
end
end

function b:target(zombie,hero)
local d,f=hero:tile()
if self.horde then
return d,f
end
local g=zombie.kind
if self:scattering()then
return j[g].x,j[g].y
end
local h=e[hero.facing]
if g=="cop"then
return d+h.dx*c.AHEAD,f+h.dy*c.AHEAD
elseif g=="woman"then
local i,k=self.list[1].mover:tile()
local l,m=d+h.dx*c.FLANK,f+h.dy*c.FLANK
return i+2*(l-i),k+2*(m-k)
end
return d,f
end

function b:choose(zombie,mover,maze,tx,ty,targetX,targetY,random,wander)
local g=e[mover.dir].back
local d={}
for i,f in ipairs(a.ORDER)do
local h=e[f]
if f~=g and maze:isOpen(tx+h.dx,ty+h.dy)then
d[#d+1]=f
end
end
if#d==0 then
return g
end
if zombie.scared or(wander>0 and random:chance(wander))then
return d[random:int(1,#d)]
end
local h,f=d[1],nil
for s,i in ipairs(d)do
local k=e[i]
local l,m=tx+k.dx-targetX,ty+k.dy-targetY
local n=l*l+m*m
if not f or n<f then
h,f=i,n
end
end
return h
end

function b:speedOf(zombie,maze)
local d=self.tuning
if zombie.state==b.EYES then
return c.EYES_SPEED
end
local f,g=zombie.mover:tile()
if maze:isTunnel(f,g)then
return d.tunnel
end
if zombie.scared then
return d.scared
end
if zombie.index==1 and not self.horde and maze.left<=c.ELROY_LEFT then
return d.zombie+c.ELROY_BONUS
end
if self.horde then
return d.zombie
end
return d.zombie*c.ROLES[zombie.kind].speed
end

local function k(mover,x,y,speed)
if mover.x~=x then
local f=math.min(speed,math.abs(x-mover.x))
local d=x>mover.x and 1 or-1
mover.x=mover.x+d*f
mover.facing=d>0 and"right"or"left"
return false
end
if mover.y~=y then
local f=math.min(speed,math.abs(y-mover.y))
local d=y>mover.y and 1 or-1
mover.y=mover.y+d*f
mover.facing=d>0 and"down"or"up"
return false
end
return true
end

function b:tickPen(zombie)
local d=zombie.mover
zombie.bob=zombie.bob+q
local h,f=a.centre(a.PEN.left,a.PEN.y)
d.y=f+math.floor(math.sin(zombie.bob)*p+0.5)
d.facing=math.cos(zombie.bob)>0 and"down"or"up"
if self.clock>=self.tuning.releases[zombie.index]then
zombie.state=b.LEAVE
local i,g=a.centre(a.PEN.left,a.PEN.y)
d.y=g
end
end

function b:tickOne(zombie,hero,maze,random)
local d=zombie.mover
local f=zombie.state
if f==b.PEN then
self:tickPen(zombie)
elseif f==b.LEAVE then
local g=a.centre(a.DOOR.x,a.DOOR.y)
local i,h=a.centre(a.OUTSIDE.x,a.OUTSIDE.y)
if k(d,g,h,c.PEN_SPEED)then
zombie.state=b.WALK
d.dir="left"
d.facing="left"
end
elseif f==b.ENTER then
local i,g=a.centre(a.PEN.left,a.PEN.y)
local h=a.centre(a.DOOR.x,a.DOOR.y)
if k(d,h,g,c.EYES_SPEED)then
zombie.eaten=false
zombie.state=b.LEAVE
end
else
local g=f==b.EYES
local h,i
if g then
h,i=a.OUTSIDE.x,a.OUTSIDE.y
else
h,i=self:target(zombie,hero)
end
local l=0
if not g then
l=self.horde and c.HORDE_WANDER or c.ROLES[zombie.kind].wander
end
d:advance(self:speedOf(zombie,maze),function(m,tx,ty)
if g and tx==a.OUTSIDE.x and ty==a.OUTSIDE.y then
return nil
end
return self:choose(zombie,m,maze,tx,ty,h,i,random,l)
end)
if g and not d.dir then
zombie.state=b.ENTER
end
end
end

function b:update(hero,maze,random,frightened)
self.clock=self.clock+1
if not frightened and self.phase<=#c.SCHEDULE then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=self.phase+1
self.phaseTimer=c.SCHEDULE[self.phase]or 0
if not self.horde then
self:reverseAll()
end
end
end
for f,d in ipairs(self.list)do
self:tickOne(d,hero,maze,random)
end
end

function b:knockOut(zombie)
zombie.scared=false
zombie.eaten=true
zombie.state=b.EYES
local d=zombie.mover
if not d.dir then
d.dir=d.facing
end
end
