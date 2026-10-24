require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Maze"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a=SpiffBoy.SnackMan.Maze
local c=a.DIRECTIONS
local e=a.TILE

local b={}
b.__index=b
SpiffBoy.SnackMan.Mover=b

function b.new(x,y,facing)
local d=setmetatable({},b)
d:place(x,y,facing)
return d
end

function b:place(x,y,facing)
self.x,self.y=a.centre(x,y)
self.dir=nil
self.facing=facing
self.distance=0
end

function b:tile()
return a.tileAt(self.x,self.y)
end

function b:shift(distance)
local d=c[self.dir]
self.x=self.x+d.dx*distance
self.y=self.y+d.dy*distance
if self.x<0 then
self.x=self.x+a.WIDTH
elseif self.x>=a.WIDTH then
self.x=self.x-a.WIDTH
end
self.distance=self.distance+distance
end

function b:toCentre()
local f=c[self.dir]
local g,h=self:tile()
local i,j=a.centre(g,h)
local d=(i-self.x)*f.dx+(j-self.y)*f.dy
if d<0 then
return e+d
end
return d
end

function b:advance(distance,decide)
while distance>0 and self.dir do
local d=self:toCentre()
if d==0 then
local f,g=self:tile()
local h,i=a.centre(f,g)
self.x,self.y=h,i
self.dir=decide(self,f,g)
if self.dir then
self.facing=self.dir
self:shift(math.min(distance,e))
distance=distance-math.min(distance,e)
end
elseif d>distance then
self:shift(distance)
distance=0
else
self:shift(d)
distance=distance-d
local f,g=self:tile()
self.x,self.y=a.centre(f,g)
end
end
end

local d=setmetatable({},{__index=b})
d.__index=d
SpiffBoy.SnackMan.Hero=d

function d.new(maze)
local f=setmetatable(b.new(maze.start.x,maze.start.y,"left"),d)
f.want="left"
f.pause=0
return f
end

local function j(input)
if not input then
return nil
end
local g=input.pressed
for h,f in ipairs(a.ORDER)do
if g[f]then
return f
end
end
local h=input.held
for i,f in ipairs(a.ORDER)do
if h[f]then
return f
end
end
return nil
end

function d:update(input,maze,speed)
local f=j(input)
if f then
self.want=f
end
if self.pause>0 then
self.pause=self.pause-1
return
end
if self.dir and self.want==c[self.dir].back then
self.dir=self.want
self.facing=self.dir
end
if not self.dir then
local h,i=self:tile()
local g=c[self.want]
if maze:isOpen(h+g.dx,i+g.dy)then
self.dir=self.want
self.facing=self.dir
end
end
local g=self.want
self:advance(speed,function(mover,tx,ty)
local h=c[g]
if maze:isOpen(tx+h.dx,ty+h.dy)then
return g
end
local i=c[mover.dir]
if maze:isOpen(tx+i.dx,ty+i.dy)then
return mover.dir
end
return nil
end)
end
