require"SpiffBoy/Core/Core"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local b={}
b.__index=b
SpiffBoy.DoubleRaccoon.Scenery=b

local c=180
b.GROUND_Y=62

local h=360
local k={width=180,height=58}
local p=90

function b.new(d,e)
local a=setmetatable({},b)
a.spec=e
a.layers={}
for g,f in ipairs(e.layers)do
a.layers[g]={texture=d(f.art),alt=f.alt and d(f.alt)}
end
a.props={}
for f,g in ipairs(e.props)do
a.props[f]=d(g.art)
end
a.ground=d(e.ground.art)
a.front=d(e.front.art)
return a
end

local function e(g,i,j,l,q,a,d,m,n)
if d<=a then
return
end
local o=(q+a)%j
local f=math.min(d-a,j-o)
g:layers(i,o,f,l,a,m,n)
if f<d-a then
g:layers(i,0,d-a-f,l,a+f,m,n)
end
end

local function m(a,d)
return math.floor(a*d)
end

function b:drawBack(d,f)
local i=self.spec
for n,a in ipairs(i.layers)do
local g=self.layers[n]
local j=m(f,a.speed)
if g.alt then
local l=SpiffBoy.clamp(a.altFrom-f,0,c)
e(d,g.texture,h,a.height,j,0,l,a.y,a.shades)
e(d,g.alt,h,a.height,j,l,c,a.y,a.shades)
else
e(d,g.texture,h,a.height,j,0,c,a.y,a.shades)
end
end
for j,a in ipairs(i.props)do
local g=math.floor((a.at-f)*a.speed)+p-math.floor(a.width/2)
if g<c and g+a.width>0 then
d:layers(self.props[j],0,a.width,a.height,g,b.GROUND_Y+2-a.height,a.shades)
end
end
e(d,self.ground,k.width,k.height,f,0,c,b.GROUND_Y,i.ground.shades)
end

function b:drawFront(f,g)
local a=self.spec.front
for j,i in ipairs(a.at)do
local d=math.floor((i-g)*a.speed)
if d>-a.width and d<c then
f:layers(self.front,0,a.width,a.height,d,0,a.shades)
end
end
end
