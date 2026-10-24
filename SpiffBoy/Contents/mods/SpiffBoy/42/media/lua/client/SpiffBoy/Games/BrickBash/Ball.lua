require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Field"
require"SpiffBoy/Games/BrickBash/Paddle"
require"SpiffBoy/Games/BrickBash/Music"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local c=SpiffBoy.BrickBash.Field
local d=SpiffBoy.BrickBash.Paddle
local e=SpiffBoy.BrickBash.Music

local a={}
a.__index=a
SpiffBoy.BrickBash.Ball=a

a.SIZE=5

local b=a.SIZE
local o=4
local p=60
local q=8
local h=66
local j=22
local r=1
local s={1,3,4}

function a.new(paddle,speed)
local f=setmetatable({},a)
f.speed=speed
f.vx=0
f.vy=0
f:stick(paddle,o)
return f
end

function a:stick(paddle,offset)
self.stuck=true
self.offset=offset
self:follow(paddle)
end

function a:follow(paddle)
self.x=paddle.x+self.offset-b/2
self.y=d.TOP-b
end

function a:aim(degrees)
local f=math.rad(SpiffBoy.clamp(degrees,-h,h))
self.vx=self.speed*math.sin(f)
self.vy=-self.speed*math.cos(f)
end

local function k(ball,paddle)
local g,i=paddle:edges()
local l=(i-g)/2
local f=(ball.x+b/2-paddle.x)/l
f=SpiffBoy.clamp(f,-1,1)
return f*p+paddle.vx*q
end

function a:launch(paddle)
self.stuck=false
self:aim(k(self,paddle))
end

function a:setSpeed(speed)
if not self.stuck then
local f=speed/self.speed
self.vx=self.vx*f
self.vy=self.vy*f
end
self.speed=speed
end

local function t(ball,degrees)
local l=math.rad(degrees)
local m,n=math.cos(l),math.sin(l)
local i=ball.vx*m-ball.vy*n
local f=ball.vx*n+ball.vy*m
local g=ball.speed*math.cos(math.rad(h))
if math.abs(f)<g then
local u=f<0 and-1 or 1
local v=i<0 and-1 or 1
f=u*g
i=v*math.sqrt(ball.speed*ball.speed-g*g)
end
return i,f
end

function a:split()
local f={}
for l,i in ipairs({-j,j})do
local g=setmetatable({x=self.x,y=self.y,speed=self.speed,stuck=false,offset=0},a)
g.vx,g.vy=t(self,i)
f[#f+1]=g
end
return f
end

function a:bouncePlank(paddle,world)
local f,g=paddle:edges()
if self.vy<=0 or self.y+b<d.TOP or self.y+b>d.TOP+d.HEIGHT then
return
end
if self.x+b<=f or self.x>=g then
return
end
self.y=d.TOP-b
if paddle.glued then
self:stick(paddle,self.x+b/2-paddle.x)
world:effect(e.STICK)
return
end
world:ballReturned(self)
self:aim(k(self,paddle))
world:effect(e.PLANK)
end

function a:escapeOverlap(field,world)
local f,g=field:overlap(self.x,self.y,b,b)
if not f then
return
end
local l,i=field:cellPosition(f,g)
if self.y+b/2<i+c.CELL_H/2 then
self.vy=-math.abs(self.vy)
else
self.vy=math.abs(self.vy)
end
field:strike(f,g,world)
end

function a:moveAxis(dx,dy,field,world)
self.x=self.x+dx
self.y=self.y+dy
if self.x<c.LEFT then
self.x=c.LEFT
self.vx=math.abs(self.vx)
world:effect(e.WALL)
return true
elseif self.x+b>c.RIGHT then
self.x=c.RIGHT-b
self.vx=-math.abs(self.vx)
world:effect(e.WALL)
return true
elseif self.y<c.TOP then
self.y=c.TOP
self.vy=math.abs(self.vy)
world:effect(e.WALL)
return true
end
local f,g=field:overlap(self.x,self.y,b,b)
if not f then
return false
end
self.x=self.x-dx
self.y=self.y-dy
if dx~=0 then
self.vx=-self.vx
else
self.vy=-self.vy
end
field:strike(f,g,world)
return true
end

function a:update(paddle,field,world)
if self.stuck then
self:follow(paddle)
return false
end
self:escapeOverlap(field,world)
local f=math.ceil(self.speed/r)
for g=1,f do
self:moveAxis(self.vx/f,0,field,world)
self:moveAxis(0,self.vy/f,field,world)
self:bouncePlank(paddle,world)
if self.stuck then
return false
end
end
return self.y>=c.BOTTOM
end

function a:draw(screen,texture)
screen:layers(texture,0,b,b,math.floor(self.x),math.floor(self.y),s)
end
