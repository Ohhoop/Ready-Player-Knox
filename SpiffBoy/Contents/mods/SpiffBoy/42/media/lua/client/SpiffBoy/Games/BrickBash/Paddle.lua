require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Field"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local d=SpiffBoy.BrickBash.Field

local a={}
a.__index=a
SpiffBoy.BrickBash.Paddle=a

a.TOP=112
a.HEIGHT=5
a.NORMAL_WIDTH=24
a.WIDE_WIDTH=36

local e=2
local f=(d.LEFT+d.RIGHT)/2
local h=36
local b={width=20,height=4,top=4,hold=0,open=1}
local g={1,2,3,4}

function a.new()
local c=setmetatable({},a)
c.x=f
c.vx=0
c.wide=false
c.glued=false
c.letGo=0
return c
end

function a:width()
if self.wide then
return a.WIDE_WIDTH
end
return a.NORMAL_WIDTH
end

function a:edges()
local c=self:width()/2
return self.x-c,self.x+c
end

function a:clamp()
local c=self:width()/2
self.x=SpiffBoy.clamp(self.x,d.LEFT+c,d.RIGHT-c)
end

function a:update(c)
local i=self.x
if c and c.held.left then
self.x=self.x-e
elseif c and c.held.right then
self.x=self.x+e
end
self:clamp()
self.vx=self.x-i
if self.letGo>0 then
self.letGo=self.letGo-1
end
end

function a:setPower(c,i)
self.wide=c
self.glued=i
self:clamp()
end

function a:reset()
self.x=f
self.vx=0
self.wide=false
self.glued=false
end

function a:draw(c,i,j)
local k=math.floor(self.x-self:width()/2)
local l=(self.wide and 1 or 0)+(self.glued and 2 or 0)
local m=self.letGo>0 and b.open or b.hold
c:layers(j,m*b.width,b.width,b.height,math.floor(self.x-b.width/2),a.TOP+b.top,g)
c:layers(i,l*h,self:width(),a.HEIGHT,k,a.TOP,g)
end
