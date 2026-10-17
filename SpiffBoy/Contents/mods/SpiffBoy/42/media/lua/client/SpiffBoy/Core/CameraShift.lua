require"SpiffBoy/Core/Core"

SpiffBoy.CameraShift=SpiffBoy.CameraShift or{}
local f=SpiffBoy.CameraShift

local i=0.018
local w="dragCamera"
local x=0
local y=150
local j=-1
local k=1
local c=0
local z=0.001
local A=0.015
local B=1.5

local g=nil
local a=nil

local function C()
if not g then
g=DebugChunkState.new()
end
return g
end

local function l(b,d)
C():fromLua2(w,-b,-d)
end

local function D(h,n,o)
local b=h:getX()
local d=h:getY()
local e=h:getZ()
local p=IsoUtils.XToScreen(b,d,e,0)
local q=IsoUtils.YToScreen(b,d,e,0)
local r=IsoUtils.XToScreen(b+1,d,e,0)-p
local s=IsoUtils.XToScreen(b,d+1,e,0)-p
local t=IsoUtils.YToScreen(b+1,d,e,0)-q
local u=IsoUtils.YToScreen(b,d+1,e,0)-q
local m=r*u-s*t
if m==0 then
return 0,0
end
return(n*u-s*o)/m,(r*o-t*n)/m
end

local function E(b)
local d=getCore()
while d:getNextZoom(b,k)~=d:getNextZoom(b,c)do
d:doZoomScroll(b,k)
end
local e={d:getNextZoom(b,c)}
while d:getNextZoom(b,j)~=d:getNextZoom(b,c)do
d:doZoomScroll(b,j)
e[#e+1]=d:getNextZoom(b,c)
end
return e
end

local function m(e,b)
local h=getCore()
local d=h:getNextZoom(e,c)
if d==b then
return
end
if b<d then
setZoomLevels(d,b)
h:doZoomScroll(e,j)
else
setZoomLevels(b,d)
h:doZoomScroll(e,k)
end
end

local function e(b)
m(b.playerNum,b.zoomTo)
setZoomLevels(unpack(b.levels))
b.zooming=false
end

function f.begin(o,s,t)
local b=o:getPlayerNum()
if b~=x then
return
end
if a and a.zooming then
e(a)
end
local u=getCore()
local d=u:getNextZoom(b,c)
local n=E(b)
local h=n[#n]
m(b,d)
local p=math.abs(d-h)>=z
local q=i
local r=a and a.progress or 0
if p then
local v=B*math.max(d,h)*math.abs(math.log(h/d))
q=math.min(i,A/v)
r=0
end
a={
player=o,
playerNum=b,
screenTargetX=s,
screenTargetY=t,
progress=r,
step=q,
levels=n,
zoomFrom=d,
zoomTo=h,
zooming=p,
closing=false,
ticks=0,
}
end

function f.finish()
if not a then
return
end
if a.zooming then
e(a)
end
a.step=i
a.closing=true
end

function f.reset()
if a and a.zooming then
e(a)
end
a=nil
if g then
l(0,0)
end
end

local function F()
if not a then
return
end
local s=a.player
if s:isDead()then
f.reset()
return
end
if a.settled and not a.closing then
return
end
if a.closing then
a.progress=a.progress-a.step
if a.progress<=0 then
f.reset()
return
end
elseif a.progress<1 then
a.progress=math.min(1,a.progress+a.step)
end
local d=a.progress
local h=d*d*(3-2*d)
local n=h
local b=a.playerNum
if a.zooming then
m(b,a.zoomFrom*(a.zoomTo/a.zoomFrom)^h)
local o=1-d
n=1-o*o*o
if d>=1 then
e(a)
end
end
local o=IsoCamera.getScreenWidth(b)
local p=IsoCamera.getScreenHeight(b)
if o<=0 or p<=0 then
return
end
local G=IsoCamera.getOffscreenWidth(b)/o
local H=IsoCamera.getOffscreenHeight(b)/p
local t=(IsoCamera.getScreenLeft(b)+o/2-a.screenTargetX)*G*n
local u=(IsoCamera.getScreenTop(b)+p/2-a.screenTargetY)*H*n
local q,r=D(s,t,u)
l(q,r)
a.ticks=a.ticks+1
if SpiffBoy.isDevBuild()and a.ticks<=y then
SpiffBoy.log("camera shift tick "..tostring(a.ticks).." zoom "..tostring(getCore():getZoom(b)).." aim "..tostring(getCore():getNextZoom(b,c)).." progress "..tostring(a.progress).." eased "..tostring(h).." pixels "..tostring(t)..","..tostring(u).." world "..tostring(q)..","..tostring(r))
end
if d>=1 and not a.closing then
local v=getCore()
a.settled=v:getZoom(b)==v:getNextZoom(b,c)
if a.settled and SpiffBoy.isDevBuild()then
SpiffBoy.log("camera shift settled at tick "..tostring(a.ticks).." world "..tostring(q)..","..tostring(r))
end
end
end

local function b()
a=nil
l(0,0)
end

Events.OnTickEvenPaused.Add(F)
Events.OnGameStart.Add(b)
