require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Kart"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Tracks"

local j=SpiffBoy.QuickStart
local d=j.Fixed
local f=j.Kart
local m=j.Items
local t=j.Tracks

local k={}
j.Brain=k

local b=math.floor
local e=d.UNIT
local i=d.FINE

k.TUNING={
lookAhead=3,
deadZone=3,
laneSpread=8,
behindBonus=2,
aheadMalus=5,
itemChance=30,
bombHold=240,
glassReach=40*256,
bombReach=80*256,
stuckTicks=70,
reverseTicks=40,
rescueTicks=360,
probe=14,
probeAngle=96,
}

local c=k.TUNING

function k.new(random,ccEntry)
return{lane=random:int(-c.laneSpread,c.laneSpread),base=ccEntry.ai,held=0,stuck=0,reverse=0,roam=1,startAt=random:int(4,30),best=-1000000,trapped=0}
end

local function n(kart,x,y)
local g=d.atan2(y-b(kart.y/e),x-b(kart.x/e))
local a=d.delta(b(kart.heading/i),b(g/i))
if a>c.deadZone then
return 1,a
elseif a<-c.deadZone then
return-1,a
end
return 0,a
end

local function q(world,kart,distance,turn)
local a=b(kart.heading/i)+turn
local g=b(kart.x/e)+b(d.cos(a)*distance/d.ONE)
local h=b(kart.y/e)+b(d.sin(a)*distance/d.ONE)
return t.surfaceAt(world.track,g,h)==t.WALL
end

local function x(world,kart,steer)
if not q(world,kart,c.probe,0)then
return steer
end
local a=not q(world,kart,c.probe,-c.probeAngle)
local g=not q(world,kart,c.probe,c.probeAngle)
if g and not a then
return 1
elseif a and not g then
return-1
elseif steer==0 then
return 1
end
return steer
end

local function y(world,kart)
local h,g=nil,nil
for r,a in ipairs(world.crates)do
if a.wait==0 then
local l,o=a.x-kart.x,a.y-kart.y
local p=l*l+o*o
if not g or p<g then
h,g=a,p
end
end
end
return h
end

local function z(world,kart,mind)
local g=world.track.waypoints
local h=#g
local l=(kart.wp+c.lookAhead-1)%h+1
local r=l%h+1
local a,o=g[l],g[r]
local p=b(d.atan2(o.y-a.y,o.x-a.x)/i)
return a.x-b(d.sin(p)*mind.lane/d.ONE),a.y+b(d.cos(p)*mind.lane/d.ONE)
end

local function r(world,index,reach,behind,halfAngle)
local g=world.karts[index]
local p=b(g.heading/i)
for s,a in ipairs(world.karts)do
if s~=index and not a.out and a.respawn==0 then
local h,l=a.x-g.x,a.y-g.y
if h*h+l*l<reach*reach then
local u=b(d.atan2(b(l/e),b(h/e))/i)
local o=math.abs(d.delta(p,u))
if behind and o>512-halfAngle then
return true
end
if not behind and o<halfAngle then
return true
end
end
end
end
return false
end

local function A(world,index,mind,delta)
local g=world.karts[index]
if not g.item or g.roulette>0 then
mind.held=0
return nil
end
mind.held=mind.held+1
if world.random:int(1,c.itemChance)~=1 then
return nil
end
local a=g.item
if a==m.GLASS then
if r(world,index,c.glassReach,true,128)or mind.held>c.bombHold then
return"back"
end
elseif a==m.PIPEBOMB then
if r(world,index,c.bombReach,false,24)then
return"forward"
end
if r(world,index,c.glassReach,true,64)or mind.held>c.bombHold then
return"back"
end
elseif a==m.COFFEE or a==m.COFFEE3 then
if math.abs(delta)<12 then
return"forward"
end
else
return"forward"
end
return nil
end

function k.think(world,index,mind)
local a=world.karts[index]
if a.out then
return 0
end
if not world.battle then
local h=world.humanRank
local g=mind.base
if a.rank>h then
g=g+c.behindBonus
elseif a.rank<h then
g=g-c.aheadMalus
end
a.topScale=g
else
a.topScale=mind.base
end
local g,l
if world.battle then
local h,o=nil,nil
for w,p in ipairs(world.karts)do
if w~=index and not p.out then
local s,u=p.x-a.x,p.y-a.y
local v=s*s+u*u
if not o or v<o then
h,o=p,v
end
end
end
local s=not a.item and y(world,a)
if s then
g,l=n(a,b(s.x/e),b(s.y/e))
elseif h and o<(160*e)*(160*e)then
g,l=n(a,b(h.x/e),b(h.y/e))
else
local u=world.track.targets
local p=u[mind.roam]
g,l=n(a,p.x,p.y)
local v,w=p.x-b(a.x/e),p.y-b(a.y/e)
if v*v+w*w<24*24 then
mind.roam=world.random:int(1,#u)
end
end
else
local h,o=z(world,a,mind)
g,l=n(a,h,o)
end
g=x(world,a,g)
if math.abs(a.speed)<40 and a.respawn==0 and a.spin==0 and world.phase~="countdown"then
mind.stuck=mind.stuck+1
if mind.stuck>c.stuckTicks then
mind.reverse,mind.stuck=c.reverseTicks,0
end
else
mind.stuck=0
end
if not world.battle and world.phase~="countdown"and a.respawn==0 then
if a.progress>mind.best then
mind.best,mind.trapped=a.progress,0
else
mind.trapped=mind.trapped+1
if mind.trapped>c.rescueTicks then
mind.trapped=0
a.respawn=f.TUNING.respawnTicks
world.events[#world.events+1]={kind="rescue",kart=index}
end
end
end
local h
if mind.reverse>0 then
mind.reverse=mind.reverse-1
h=f.DOWN+(g==1 and f.LEFT or 0)+(g==-1 and f.RIGHT or 0)
else
h=f.UP+(g==1 and f.RIGHT or 0)+(g==-1 and f.LEFT or 0)
end
local o=A(world,index,mind,l)
if o=="forward"then
h=f.with(h,f.B)
elseif o=="back"then
h=f.with(f.with(h,f.B),f.DOWN)
end
return h
end
