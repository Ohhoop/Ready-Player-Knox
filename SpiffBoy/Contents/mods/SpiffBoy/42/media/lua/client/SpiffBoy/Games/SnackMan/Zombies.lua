require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Maze"
require"SpiffBoy/Games/SnackMan/Actors"
require"SpiffBoy/Games/SnackMan/Rules"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a=SpiffBoy.SnackMan.Maze
local s=SpiffBoy.SnackMan.Mover
local c=SpiffBoy.SnackMan.Rules
local f=a.DIRECTIONS

local b={}
b.__index=b
SpiffBoy.SnackMan.Zombies=b

b.PEN="pen"
b.LEAVE="leave"
b.WALK="walk"
b.EYES="eyes"
b.ENTER="enter"
b.CATCH=4

local k={
runner={x=a.COLUMNS-2,y=-2},
cop={x=3,y=-2},
woman={x=a.COLUMNS,y=a.ROWS+2},
shambler={x=1,y=a.ROWS+2},
}
local t=2
local u=0.25

local function v(h,e)
local d=a.centre(a.PEN.left,a.PEN.y)
local g=a.centre(a.PEN.right,a.PEN.y)
if e<=1 then
return(d+g)/2
end
return d+(h-1)*(g-d)/(e-1)
end

function b.new(g,h,i)
local d=setmetatable({},b)
d.horde=h
d.tuning=i
d.list={}
for e,j in ipairs(g)do
d.list[e]={kind=j,index=e,mover=s.new(a.OUTSIDE.x,a.OUTSIDE.y,"left")}
end
d:reset()
return d
end

function b:reset()
local h=#self.list-1
for g,d in ipairs(self.list)do
local e=d.mover
d.scared=false
d.eaten=false
if g==1 then
e:place(a.OUTSIDE.x,a.OUTSIDE.y,"left")
e.dir="left"
d.state=b.WALK
else
e:place(a.PEN.left,a.PEN.y,"up")
e.x=v(g-1,h)
d.homeX=e.x
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
for g,e in ipairs(self.list)do
local d=e.mover
if e.state==b.WALK and d.dir then
d.dir=f[d.dir].back
d.facing=d.dir
end
end
end

function b:scare()
for e,d in ipairs(self.list)do
if d.state~=b.EYES and d.state~=b.ENTER then
d.scared=true
end
end
self:reverseAll()
end

function b:calm()
for e,d in ipairs(self.list)do
d.scared=false
end
end

function b:target(m,i)
local d,e=i:tile()
if self.horde then
return d,e
end
local g=m.kind
if self:scattering()then
return k[g].x,k[g].y
end
local h=f[i.facing]
if g=="cop"then
return d+h.dx*c.AHEAD,e+h.dy*c.AHEAD
elseif g=="woman"then
local j,l=self.list[1].mover:tile()
local n,o=d+h.dx*c.FLANK,e+h.dy*c.FLANK
return j+2*(n-j),l+2*(o-l)
end
return d,e
end

function b:choose(w,x,y,g,h,z,A,i,j)
local l=f[x.dir].back
local d={}
for n,e in ipairs(a.ORDER)do
local m=f[e]
if e~=l and y:isOpen(g+m.dx,h+m.dy)then
d[#d+1]=e
end
end
if#d==0 then
return l
end
if w.scared or(j>0 and i:chance(j))then
return d[i:int(1,#d)]
end
local m,e=d[1],nil
for B,n in ipairs(d)do
local o=f[n]
local p,q=g+o.dx-z,h+o.dy-A
local r=p*p+q*q
if not e or r<e then
m,e=n,r
end
end
return m
end

function b:speedOf(d,g)
local e=self.tuning
if d.state==b.EYES then
return c.EYES_SPEED
end
local h,i=d.mover:tile()
if g:isTunnel(h,i)then
return e.tunnel
end
if d.scared then
return e.scared
end
if d.index==1 and not self.horde and g.left<=c.ELROY_LEFT then
return e.zombie+c.ELROY_BONUS
end
if self.horde then
return e.zombie
end
return e.zombie*c.ROLES[d.kind].speed
end

local function l(d,e,g,h)
if d.x~=e then
local j=math.min(h,math.abs(e-d.x))
local i=e>d.x and 1 or-1
d.x=d.x+i*j
d.facing=i>0 and"right"or"left"
return false
end
if d.y~=g then
local j=math.min(h,math.abs(g-d.y))
local i=g>d.y and 1 or-1
d.y=d.y+i*j
d.facing=i>0 and"down"or"up"
return false
end
return true
end

function b:tickPen(d)
local e=d.mover
d.bob=d.bob+u
local i,g=a.centre(a.PEN.left,a.PEN.y)
e.y=g+math.floor(math.sin(d.bob)*t+0.5)
e.facing=math.cos(d.bob)>0 and"down"or"up"
if self.clock>=self.tuning.releases[d.index]then
d.state=b.LEAVE
local j,h=a.centre(a.PEN.left,a.PEN.y)
e.y=h
end
end

function b:tickOne(d,q,m,r)
local e=d.mover
local g=d.state
if g==b.PEN then
self:tickPen(d)
elseif g==b.LEAVE then
local h=a.centre(a.DOOR.x,a.DOOR.y)
local j,i=a.centre(a.OUTSIDE.x,a.OUTSIDE.y)
if l(e,h,i,c.PEN_SPEED)then
d.state=b.WALK
e.dir="left"
e.facing="left"
end
elseif g==b.ENTER then
local j,h=a.centre(a.PEN.left,a.PEN.y)
local i=a.centre(a.DOOR.x,a.DOOR.y)
if l(e,i,h,c.EYES_SPEED)then
d.eaten=false
d.state=b.LEAVE
end
else
local h=g==b.EYES
local i,j
if h then
i,j=a.OUTSIDE.x,a.OUTSIDE.y
else
i,j=self:target(d,q)
end
local n=0
if not h then
n=self.horde and c.HORDE_WANDER or c.ROLES[d.kind].wander
end
e:advance(self:speedOf(d,m),function(w,o,p)
if h and o==a.OUTSIDE.x and p==a.OUTSIDE.y then
return nil
end
return self:choose(d,w,m,o,p,i,j,r,n)
end)
if h and not e.dir then
d.state=b.ENTER
end
end
end

function b:update(d,e,g,h)
self.clock=self.clock+1
if not h and self.phase<=#c.SCHEDULE then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=self.phase+1
self.phaseTimer=c.SCHEDULE[self.phase]or 0
if not self.horde then
self:reverseAll()
end
end
end
for j,i in ipairs(self.list)do
self:tickOne(i,d,e,g)
end
end

function b:knockOut(d)
d.scared=false
d.eaten=true
d.state=b.EYES
local e=d.mover
if not e.dir then
e.dir=e.facing
end
end
