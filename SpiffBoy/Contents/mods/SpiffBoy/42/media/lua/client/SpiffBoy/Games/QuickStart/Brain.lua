require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Kart"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Tracks"

local l=SpiffBoy.QuickStart
local f=l.Fixed
local h=l.Kart
local o=l.Items
local w=l.Tracks

local m={}
l.Brain=m

local b=math.floor
local g=f.UNIT
local k=f.FINE

m.TUNING={
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

local d=m.TUNING

function m.new(a,c)
return{lane=a:int(-d.laneSpread,d.laneSpread),base=c.ai,held=0,stuck=0,reverse=0,roam=1,startAt=a:int(4,30),best=-1000000,trapped=0}
end

local function p(c,e,i)
local j=f.atan2(i-b(c.y/g),e-b(c.x/g))
local a=f.delta(b(c.heading/k),b(j/k))
if a>d.deadZone then
return 1,a
elseif a<-d.deadZone then
return-1,a
end
return 0,a
end

local function t(i,a,c,j)
local e=b(a.heading/k)+j
local n=b(a.x/g)+b(f.cos(e)*c/f.ONE)
local q=b(a.y/g)+b(f.sin(e)*c/f.ONE)
return w.surfaceAt(i.track,n,q)==w.WALL
end

local function A(a,c,e)
if not t(a,c,d.probe,0)then
return e
end
local i=not t(a,c,d.probe,-d.probeAngle)
local j=not t(a,c,d.probe,d.probeAngle)
if j and not i then
return 1
elseif i and not j then
return-1
elseif e==0 then
return 1
end
return e
end

local function B(r,e)
local i,c=nil,nil
for s,a in ipairs(r.crates)do
if a.wait==0 then
local j,n=a.x-e.x,a.y-e.y
local q=j*j+n*n
if not c or q<c then
i,c=a,q
end
end
end
return i
end

local function C(r,s,e)
local c=r.track.waypoints
local i=#c
local j=(s.wp+d.lookAhead-1)%i+1
local u=j%i+1
local a,n=c[j],c[u]
local q=b(f.atan2(n.y-a.y,n.x-a.x)/k)
return a.x-b(f.sin(q)*e.lane/f.ONE),a.y+b(f.cos(q)*e.lane/f.ONE)
end

local function u(j,n,q,r,s)
local c=j.karts[n]
local x=b(c.heading/k)
for y,a in ipairs(j.karts)do
if y~=n and not a.out and a.respawn==0 then
local e,i=a.x-c.x,a.y-c.y
if e*e+i*i<q*q then
local z=b(f.atan2(b(i/g),b(e/g))/k)
local v=math.abs(f.delta(x,z))
if r and v>512-s then
return true
end
if not r and v<s then
return true
end
end
end
end
return false
end

local function D(a,e,c,n)
local j=a.karts[e]
if not j.item or j.roulette>0 then
c.held=0
return nil
end
c.held=c.held+1
if a.random:int(1,d.itemChance)~=1 then
return nil
end
local i=j.item
if i==o.GLASS then
if u(a,e,d.glassReach,true,128)or c.held>d.bombHold then
return"back"
end
elseif i==o.PIPEBOMB then
if u(a,e,d.bombReach,false,24)then
return"forward"
end
if u(a,e,d.glassReach,true,64)or c.held>d.bombHold then
return"back"
end
elseif i==o.COFFEE or i==o.COFFEE3 then
if math.abs(n)<12 then
return"forward"
end
else
return"forward"
end
return nil
end

function m.think(e,q,c)
local a=e.karts[q]
if a.out then
return 0
end
if not e.battle then
local j=e.humanRank
local i=c.base
if a.rank>j then
i=i+d.behindBonus
elseif a.rank<j then
i=i-d.aheadMalus
end
a.topScale=i
else
a.topScale=c.base
end
local i,n
if e.battle then
local j,r=nil,nil
for z,s in ipairs(e.karts)do
if z~=q and not s.out then
local v,x=s.x-a.x,s.y-a.y
local y=v*v+x*x
if not r or y<r then
j,r=s,y
end
end
end
local v=not a.item and B(e,a)
if v then
i,n=p(a,b(v.x/g),b(v.y/g))
elseif j and r<(160*g)*(160*g)then
i,n=p(a,b(j.x/g),b(j.y/g))
else
local x=e.track.targets
local s=x[c.roam]
i,n=p(a,s.x,s.y)
local y,z=s.x-b(a.x/g),s.y-b(a.y/g)
if y*y+z*z<24*24 then
c.roam=e.random:int(1,#x)
end
end
else
local j,r=C(e,a,c)
i,n=p(a,j,r)
end
i=A(e,a,i)
if math.abs(a.speed)<40 and a.respawn==0 and a.spin==0 and e.phase~="countdown"then
c.stuck=c.stuck+1
if c.stuck>d.stuckTicks then
c.reverse,c.stuck=d.reverseTicks,0
end
else
c.stuck=0
end
if not e.battle and e.phase~="countdown"and a.respawn==0 then
if a.progress>c.best then
c.best,c.trapped=a.progress,0
else
c.trapped=c.trapped+1
if c.trapped>d.rescueTicks then
c.trapped=0
a.respawn=h.TUNING.respawnTicks
e.events[#e.events+1]={kind="rescue",kart=q}
end
end
end
local j
if c.reverse>0 then
c.reverse=c.reverse-1
j=h.DOWN+(i==1 and h.LEFT or 0)+(i==-1 and h.RIGHT or 0)
else
j=h.UP+(i==1 and h.RIGHT or 0)+(i==-1 and h.LEFT or 0)
end
local r=D(e,q,c,n)
if r=="forward"then
j=h.with(j,h.B)
elseif r=="back"then
j=h.with(h.with(j,h.B),h.DOWN)
end
return j
end
