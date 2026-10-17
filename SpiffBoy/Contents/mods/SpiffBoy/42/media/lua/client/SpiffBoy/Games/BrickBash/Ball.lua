require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Field"
require"SpiffBoy/Games/BrickBash/Paddle"
require"SpiffBoy/Games/BrickBash/Music"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local c=SpiffBoy.BrickBash.Field
local e=SpiffBoy.BrickBash.Paddle
local f=SpiffBoy.BrickBash.Music

local a={}
a.__index=a
SpiffBoy.BrickBash.Ball=a

a.SIZE=5

local b=a.SIZE
local p=4
local q=60
local r=8
local i=66
local k=22
local s=1
local t={1,3,4}

function a.new(g,h)
local d=setmetatable({},a)
d.speed=h
d.vx=0
d.vy=0
d:stick(g,p)
return d
end

function a:stick(d,g)
self.stuck=true
self.offset=g
self:follow(d)
end

function a:follow(d)
self.x=d.x+self.offset-b/2
self.y=e.TOP-b
end

function a:aim(g)
local d=math.rad(SpiffBoy.clamp(g,-i,i))
self.vx=self.speed*math.sin(d)
self.vy=-self.speed*math.cos(d)
end

local function l(h,d)
local j,m=d:edges()
local n=(m-j)/2
local g=(h.x+b/2-d.x)/n
g=SpiffBoy.clamp(g,-1,1)
return g*q+d.vx*r
end

function a:launch(d)
self.stuck=false
self:aim(l(self,d))
end

function a:setSpeed(d)
if not self.stuck then
local g=d/self.speed
self.vx=self.vx*g
self.vy=self.vy*g
end
self.speed=d
end

local function u(d,v)
local m=math.rad(v)
local n,o=math.cos(m),math.sin(m)
local j=d.vx*n-d.vy*o
local g=d.vx*o+d.vy*n
local h=d.speed*math.cos(math.rad(i))
if math.abs(g)<h then
local w=g<0 and-1 or 1
local x=j<0 and-1 or 1
g=w*h
j=x*math.sqrt(d.speed*d.speed-h*h)
end
return j,g
end

function a:split()
local d={}
for j,h in ipairs({-k,k})do
local g=setmetatable({x=self.x,y=self.y,speed=self.speed,stuck=false,offset=0},a)
g.vx,g.vy=u(self,h)
d[#d+1]=g
end
return d
end

function a:bouncePlank(d,g)
local h,j=d:edges()
if self.vy<=0 or self.y+b<e.TOP or self.y+b>e.TOP+e.HEIGHT then
return
end
if self.x+b<=h or self.x>=j then
return
end
self.y=e.TOP-b
if d.glued then
self:stick(d,self.x+b/2-d.x)
g:effect(f.STICK)
return
end
g:ballReturned(self)
self:aim(l(self,d))
g:effect(f.PLANK)
end

function a:escapeOverlap(d,j)
local g,h=d:overlap(self.x,self.y,b,b)
if not g then
return
end
local n,m=d:cellPosition(g,h)
if self.y+b/2<m+c.CELL_H/2 then
self.vy=-math.abs(self.vy)
else
self.vy=math.abs(self.vy)
end
d:strike(g,h,j)
end

function a:moveAxis(g,h,j,d)
self.x=self.x+g
self.y=self.y+h
if self.x<c.LEFT then
self.x=c.LEFT
self.vx=math.abs(self.vx)
d:effect(f.WALL)
return true
elseif self.x+b>c.RIGHT then
self.x=c.RIGHT-b
self.vx=-math.abs(self.vx)
d:effect(f.WALL)
return true
elseif self.y<c.TOP then
self.y=c.TOP
self.vy=math.abs(self.vy)
d:effect(f.WALL)
return true
end
local m,n=j:overlap(self.x,self.y,b,b)
if not m then
return false
end
self.x=self.x-g
self.y=self.y-h
if g~=0 then
self.vx=-self.vx
else
self.vy=-self.vy
end
j:strike(m,n,d)
return true
end

function a:update(j,g,d)
if self.stuck then
self:follow(j)
return false
end
self:escapeOverlap(g,d)
local h=math.ceil(self.speed/s)
for m=1,h do
self:moveAxis(self.vx/h,0,g,d)
self:moveAxis(0,self.vy/h,g,d)
self:bouncePlank(j,d)
if self.stuck then
return false
end
end
return self.y>=c.BOTTOM
end

function a:draw(d,g)
d:layers(g,0,b,b,math.floor(self.x),math.floor(self.y),t)
end
