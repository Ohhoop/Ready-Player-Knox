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

local d=360
local e={height=40,speed=0.5}
local f={height=54,speed=1}
local g={width=180,height=16}
local h={1,2,3,4}

function a.new(art,name)
local b=setmetatable({},a)
b.far=art(name.."_far")
b.mid=art(name.."_mid")
b.ground=art(name.."_ground")
return b
end

local function c(screen,texture,width,height,offset,y)
local i=offset%width
local b=math.min(a.VIEW,width-i)
screen:layers(texture,i,b,height,0,y,h)
if b<a.VIEW then
screen:layers(texture,0,a.VIEW-b,height,b,y,h)
end
end

function a:draw(screen,camera)
c(screen,self.far,d,e.height,math.floor(camera*e.speed),a.FAR_Y)
c(screen,self.mid,d,f.height,math.floor(camera*f.speed),a.MID_Y)
c(screen,self.ground,g.width,g.height,math.floor(camera),a.GROUND_Y)
end
