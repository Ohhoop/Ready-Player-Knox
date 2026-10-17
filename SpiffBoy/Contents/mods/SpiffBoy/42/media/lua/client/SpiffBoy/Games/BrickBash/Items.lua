require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Field"
require"SpiffBoy/Games/BrickBash/Paddle"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local h=SpiffBoy.BrickBash.Field
local d=SpiffBoy.BrickBash.Paddle

local a={}
a.__index=a
SpiffBoy.BrickBash.Items=a

a.WIDE="wide"
a.SLOW="slow"
a.MULTI="multi"
a.LIFE="life"
a.GLUE="glue"

local c={width=12,height=10}
local i={wide=0,slow=1,multi=2,life=3,glue=4}
local f={{kind=a.WIDE,weight=3},{kind=a.SLOW,weight=3},{kind=a.MULTI,weight=3},{kind=a.GLUE,weight=3},{kind=a.LIFE,weight=1}}
local j=6
local k=0.6
local l={1,2,3,4}

function a.new()
local b=setmetatable({},a)
b.falling={}
return b
end

local function m(n)
local b=0
for g,e in ipairs(f)do
b=b+e.weight
end
local e=n:int(1,b)
for o,g in ipairs(f)do
e=e-g.weight
if e<=0 then
return g.kind
end
end
end

function a:maybeDrop(b,e,g)
if#self.falling>0 or b:int(1,j)~=1 then
return
end
self.falling[1]={kind=m(b),x=e-c.width/2,y=g-c.height/2}
end

function a:update(n)
local g=nil
for e=#self.falling,1,-1 do
local b=self.falling[e]
b.y=b.y+k
local o,p=n:edges()
local q=b.y+c.height>=d.TOP and b.y<=d.TOP+d.HEIGHT and b.x+c.width>o and b.x<p
if q then
g=b.kind
table.remove(self.falling,e)
elseif b.y>=h.BOTTOM then
table.remove(self.falling,e)
end
end
return g
end

function a:clear()
self.falling={}
end

function a:draw(e,g)
for n,b in ipairs(self.falling)do
e:layers(g,i[b.kind]*c.width,c.width,c.height,math.floor(b.x),math.floor(b.y),l)
end
end
