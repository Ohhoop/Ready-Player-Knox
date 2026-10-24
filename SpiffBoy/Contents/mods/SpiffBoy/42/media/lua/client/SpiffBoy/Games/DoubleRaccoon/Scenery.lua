require"SpiffBoy/Core/Core"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local b={}
b.__index=b
SpiffBoy.DoubleRaccoon.Scenery=b

local c=180
b.GROUND_Y=62

local f=360
local i={width=180,height=58}
local k=90

function b.new(art,spec)
local a=setmetatable({},b)
a.spec=spec
a.layers={}
for e,d in ipairs(spec.layers)do
a.layers[e]={texture=art(d.art),alt=d.alt and art(d.alt)}
end
a.props={}
for d,e in ipairs(spec.props)do
a.props[d]=art(e.art)
end
a.ground=art(spec.ground.art)
a.front=art(spec.front.art)
return a
end

local function d(screen,texture,width,height,offset,left,right,y,shades)
if right<=left then
return
end
local e=(offset+left)%width
local a=math.min(right-left,width-e)
screen:layers(texture,e,a,height,left,y,shades)
if a<right-left then
screen:layers(texture,0,right-left-a,height,left+a,y,shades)
end
end

local function l(camera,speed)
return math.floor(camera*speed)
end

function b:drawBack(screen,camera)
local g=self.spec
for m,a in ipairs(g.layers)do
local e=self.layers[m]
local h=l(camera,a.speed)
if e.alt then
local j=SpiffBoy.clamp(a.altFrom-camera,0,c)
d(screen,e.texture,f,a.height,h,0,j,a.y,a.shades)
d(screen,e.alt,f,a.height,h,j,c,a.y,a.shades)
else
d(screen,e.texture,f,a.height,h,0,c,a.y,a.shades)
end
end
for h,a in ipairs(g.props)do
local e=math.floor((a.at-camera)*a.speed)+k-math.floor(a.width/2)
if e<c and e+a.width>0 then
screen:layers(self.props[h],0,a.width,a.height,e,b.GROUND_Y+2-a.height,a.shades)
end
end
d(screen,self.ground,i.width,i.height,camera,0,c,b.GROUND_Y,g.ground.shades)
end

function b:drawFront(screen,camera)
local a=self.spec.front
for h,g in ipairs(a.at)do
local e=math.floor((g-camera)*a.speed)
if e>-a.width and e<c then
screen:layers(self.front,0,a.width,a.height,e,0,a.shades)
end
end
end
