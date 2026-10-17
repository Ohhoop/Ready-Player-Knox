require"SpiffBoy/Core/Core"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local a={}
a.__index=a
SpiffBoy.StreetBiter.Stage=a

a.ARENA=360
a.VIEW=180
a.GROUND_Y=104
a.FAR_Y=16
a.MID_Y=50

local e=360
local f={height=40,speed=0.5}
local g={height=54,speed=1}
local h={width=180,height=16}
local i={1,2,3,4}

function a.new(c,d)
local b=setmetatable({},a)
b.far=c(d.."_far")
b.mid=c(d.."_mid")
b.ground=c(d.."_ground")
return b
end

local function c(d,j,k,l,o,m)
local n=o%k
local b=math.min(a.VIEW,k-n)
d:layers(j,n,b,l,0,m,i)
if b<a.VIEW then
d:layers(j,0,a.VIEW-b,l,b,m,i)
end
end

function a:draw(b,d)
c(b,self.far,e,f.height,math.floor(d*f.speed),a.FAR_Y)
c(b,self.mid,e,g.height,math.floor(d*g.speed),a.MID_Y)
c(b,self.ground,h.width,h.height,math.floor(d),a.GROUND_Y)
end
