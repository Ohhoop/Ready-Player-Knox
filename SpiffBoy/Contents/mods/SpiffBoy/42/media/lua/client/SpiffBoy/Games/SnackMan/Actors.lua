require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Maze"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a=SpiffBoy.SnackMan.Maze
local d=a.DIRECTIONS
local f=a.TILE

local b={}
b.__index=b
SpiffBoy.SnackMan.Mover=b

function b.new(e,g,h)
local c=setmetatable({},b)
c:place(e,g,h)
return c
end

function b:place(c,e,g)
self.x,self.y=a.centre(c,e)
self.dir=nil
self.facing=g
self.distance=0
end

function b:tile()
return a.tileAt(self.x,self.y)
end

function b:shift(c)
local e=d[self.dir]
self.x=self.x+e.dx*c
self.y=self.y+e.dy*c
if self.x<0 then
self.x=self.x+a.WIDTH
elseif self.x>=a.WIDTH then
self.x=self.x-a.WIDTH
end
self.distance=self.distance+c
end

function b:toCentre()
local e=d[self.dir]
local g,h=self:tile()
local i,j=a.centre(g,h)
local c=(i-self.x)*e.dx+(j-self.y)*e.dy
if c<0 then
return f+c
end
return c
end

function b:advance(c,i)
while c>0 and self.dir do
local e=self:toCentre()
if e==0 then
local g,h=self:tile()
local j,k=a.centre(g,h)
self.x,self.y=j,k
self.dir=i(self,g,h)
if self.dir then
self.facing=self.dir
self:shift(math.min(c,f))
c=c-math.min(c,f)
end
elseif e>c then
self:shift(c)
c=0
else
self:shift(e)
c=c-e
local g,h=self:tile()
self.x,self.y=a.centre(g,h)
end
end
end

local c=setmetatable({},{__index=b})
c.__index=c
SpiffBoy.SnackMan.Hero=c

function c.new(g)
local e=setmetatable(b.new(g.start.x,g.start.y,"left"),c)
e.want="left"
e.pause=0
return e
end

local function n(e)
if not e then
return nil
end
local h=e.pressed
for i,g in ipairs(a.ORDER)do
if h[g]then
return g
end
end
local i=e.held
for j,g in ipairs(a.ORDER)do
if i[g]then
return g
end
end
return nil
end

function c:update(o,e,p)
local g=n(o)
if g then
self.want=g
end
if self.pause>0 then
self.pause=self.pause-1
return
end
if self.dir and self.want==d[self.dir].back then
self.dir=self.want
self.facing=self.dir
end
if not self.dir then
local i,j=self:tile()
local h=d[self.want]
if e:isOpen(i+h.dx,j+h.dy)then
self.dir=self.want
self.facing=self.dir
end
end
local h=self.want
self:advance(p,function(i,j,k)
local l=d[h]
if e:isOpen(j+l.dx,k+l.dy)then
return h
end
local m=d[i.dir]
if e:isOpen(j+m.dx,k+m.dy)then
return i.dir
end
return nil
end)
end
