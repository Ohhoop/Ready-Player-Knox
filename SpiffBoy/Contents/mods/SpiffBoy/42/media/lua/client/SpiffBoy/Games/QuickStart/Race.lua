require"SpiffBoy/Core/Random"
require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Roster"
require"SpiffBoy/Games/QuickStart/Kart"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Brain"

local i=SpiffBoy.QuickStart
local j=i.Fixed
local p=i.Tracks
local J=i.Roster
local b=i.Kart
local f=i.Items
local q=i.Brain

local c={}
i.Race=c

local g=math.floor
local h=j.UNIT
local z=j.FINE

c.MODE_GP="gp"
c.MODE_VS="vs"
c.MODE_TT="tt"
c.MODE_BATTLE="battle"

c.TIMING={
intro=300,
countdown=180,
lights={30,90,150},
laps=3,
afterFinish=180,
battleTicks=10800,
gridGap=3,
gridSide=10,
lapSearch=8,
startEarly=45,
stallTicks=40,
}

local d=c.TIMING

local function v(k,l)
local a={}
for m,e in ipairs(k.objects)do
if e.kind==l then
a[#a+1]={x=e.x*h,y=e.y*h,wait=0}
end
end
return a
end

local function w(u,m)
local e=u.waypoints
local k=#e
local x=g((m-1)/2)
local n=1+x*d.gridGap
local l=(k-n)%k+1
local a,o=e[l],e[l%k+1]
local r=j.atan2(o.y-a.y,o.x-a.x)
local s=g(r/z)
local t=((m-1)%2==0)and-d.gridSide or d.gridSide
local y=a.x-g(j.sin(s)*t/j.ONE)
local A=a.y+g(j.cos(s)*t/j.ONE)
return y*h,A*h,r,l,-n
end

function c.new(a)
local k=p.load(a.track,a.cc.mirrored)
local e={
mode=a.mode,battle=a.mode==c.MODE_BATTLE,track=k,cc=a.cc,
random=SpiffBoyRandom.new(a.seed),tick=0,phase="intro",phaseTick=0,raceTick=0,
karts={},minds={},seats={},
crates=a.mode==c.MODE_TT and{}or v(k,"crate"),
money=(a.mode==c.MODE_BATTLE or a.mode==c.MODE_TT)and{}or v(k,"money"),
hazards={},shots={},helicopter=nil,storm=0,events={},finishOrder={},items=true,inputs={},
lapTimes={},ghost=nil,humanRank=1,seatPrev={},
}
for l,n in ipairs(a.grid)do
local r,s,t,o,u
if e.battle then
local m=k.spawns[l]
r,s=m.x*h,m.y*h
local x=k.extent/2
t=j.atan2(x-m.y,x-m.x)
o,u=1,0
else
r,s,t,o,u=w(k,l)
end
local m=b.new(n.driver,r,s,t,a.cc)
m.wp,m.progress,m.lastSafe=o,u,o
m.seat=n.seat
e.karts[l]=m
e.lapTimes[l]={}
if n.seat then
e.seats[n.seat]=l
else
e.minds[l]=q.new(e.random,a.cc)
end
end
if a.mode==c.MODE_TT then
local l=e.karts[1]
l.item,l.itemCount=f.COFFEE3,3
end
if a.ghost then
local n,o,r,m,s=w(k,1)
local l=b.new(a.ghost.driver,n,o,r,a.cc)
l.wp,l.progress,l.lastSafe=m,s,m
l.item,l.itemCount=f.COFFEE3,3
e.ghost={kart=l,reader=a.ghost.reader}
end
if a.skipIntro then
e.phase="countdown"
end
return e
end

local function A(k,a)
local o=k.track.waypoints
local l=#o
local s,t=g(a.x/h),g(a.y/h)
local m,r=a.wp,nil
for y=-2,d.lapSearch do
local e=i.wrapIndex(a.wp+y,l)
local n,u=o[e].x-s,o[e].y-t
local x=n*n+u*u
if not r or x<r then
m,r=e,x
end
end
local e=m-a.wp
if e>l/2 then
e=e-l
elseif e<-l/2 then
e=e+l
end
a.progress=a.progress+e
a.wp=m
if p.surfaceAt(k.track,s,t)~=p.WATER and a.z==0 then
a.lastSafe=m
end
local n=g(a.progress/l)+1
if n>a.lap and n>=2 then
local u=k.lapTimes[a.place]
u[#u+1]=k.raceTick
k.events[#k.events+1]={kind="lap",kart=a.place,lap=n}
end
a.lap=math.max(1,n)
end

local function B(n,a)
local e=n.track.waypoints
local k=e[a.wp%#e+1]
local l,m=k.x-g(a.x/h),k.y-g(a.y/h)
return l*l+m*m
end

local k
local l={}

local function C(m,n)
local a,e=k[m],k[n]
if a.out~=e.out then
return not a.out
end
if a.out then
if a.outTick~=e.outTick then
return a.outTick>e.outTick
end
return m<n
end
if a.cans~=e.cans then
return a.cans>e.cans
end
if a.hits~=e.hits then
return a.hits<e.hits
end
return m<n
end

local function D(e,m)
local a,n=k[e],k[m]
if a.finished~=n.finished then
return a.finished
end
if a.finished then
return a.finishTick<n.finishTick or(a.finishTick==n.finishTick and e<m)
end
if a.progress~=n.progress then
return a.progress>n.progress
end
if l[e]~=l[m]then
return l[e]<l[m]
end
return e<m
end

local function r(a)
local m={}
for e=1,#a.karts do
m[e]=e
end
local e=a.karts
k=e
if a.battle then
table.sort(m,C)
else
for n=1,#e do
l[n]=B(a,e[n])
end
table.sort(m,D)
end
k=nil
for n,o in ipairs(m)do
e[o].rank=n
end
a.order=m
local n=#e
for s,o in pairs(a.seats)do
n=math.min(n,e[o].rank)
end
a.humanRank=n
end

local function x(a,o)
local m=a.inputs
for e,n in ipairs(a.karts)do
if n.seat and not n.finished then
m[e]=o[n.seat]or 0
else
if not a.minds[e]then
a.minds[e]=q.new(a.random,a.cc)
end
m[e]=q.think(a,e,a.minds[e])
end
end
return m
end

local function E(a,e)
local m=a.karts[e]
m.finished=true
m.finishTick=a.raceTick
a.finishOrder[#a.finishOrder+1]=e
a.events[#a.events+1]={kind="finish",kart=e}
end

local function F(a)
if a.battle then
local e=0
for n,m in ipairs(a.karts)do
if not m.out then
e=e+1
end
end
return e<=1 or a.raceTick>=d.battleTicks
end
local e=0
for n,m in pairs(a.seats)do
e=e+1
if not a.karts[m].finished then
return false
end
end
if e==0 then
for n,m in ipairs(a.karts)do
if not m.finished then
return false
end
end
end
return true
end

local function G(e)
local m=e.ghost
local n=m.reader:next()
local a=m.kart
local o=a.bits
b.step(a,n,e.track,{},0)
if b.has(n,b.B)and not b.has(o,b.B)and a.item then
a.boost=math.max(a.boost,f.TUNING.coffeeBoost)
a.itemCount=a.itemCount-1
if a.itemCount<=0 then
a.item=nil
end
end
end

local function H(a,I)
a.phaseTick=a.phaseTick+1
local s=d.countdown-a.phaseTick
local y=x(a,I)
for e,m in pairs(a.minds)do
y[e]=s<=m.startAt and b.UP or 0
end
local m={}
for e,n in ipairs(a.karts)do
m[e]={kart=n,bits=y[e],place=e}
end
if a.ghost then
m[#m+1]={kart=a.ghost.kart,bits=a.ghost.reader:next(),place=0}
end
for K,t in ipairs(m)do
local u,n=t.kart,t.place
local o=b.countdown(u,t.bits,s)
if o then
local e=n==0 and{}or a.events
if o>d.startEarly then
b.startSpin(u,d.stallTicks)
e[#e+1]={kind="stall",kart=n}
elseif o>=b.TUNING.startWindow[2]and o<=b.TUNING.startWindow[1]then
b.boostFor(u,b.TUNING.startBoost,e,n)
e[#e+1]={kind="quickstart",kart=n}
end
end
end
for n,e in ipairs(d.lights)do
if a.phaseTick==e then
a.events[#a.events+1]={kind="light"}
end
end
if s<=0 then
a.phase="race"
a.events[#a.events+1]={kind="go"}
end
end

local function o(a,t)
a.raceTick=a.raceTick+1
local u=x(a,t)
for m,e in ipairs(a.karts)do
e.place=m
if not e.out then
local n,s=u[m],e.bits
b.step(e,n,a.track,a.events,m)
if b.has(n,b.UP)and not b.has(s,b.UP)then
e.upTap=a.raceTick
end
if a.items and e.respawn==0 and e.spin==0 then
if b.has(n,b.B)and not b.has(s,b.B)then
local y=a.raceTick-e.upTap<=f.TUNING.comboTicks
f.use(a,m,b.has(n,b.DOWN),y)
end
end
if not a.battle then
A(a,e)
if not e.finished and e.progress>=d.laps*#a.track.waypoints then
E(a,m)
end
end
end
end
for e=1,#a.karts do
for s=e+1,#a.karts do
local m,n=a.karts[e],a.karts[s]
if b.collide(m,n)then
if m.invincible>0 and n.invincible==0 then
f.hit(a,s,f.TUNING.spinTicks)
elseif n.invincible>0 and m.invincible==0 then
f.hit(a,e,f.TUNING.spinTicks)
end
end
end
end
if a.items then
f.step(a)
end
if a.ghost then
G(a)
end
r(a)
if a.phase=="race"and F(a)then
a.phase="finish"
a.phaseTick=0
a.events[#a.events+1]={kind="done"}
end
end

function c.step(a,e)
a.tick=a.tick+1
local m=a.events
for n=#m,1,-1 do
m[n]=nil
end
local s=a.seatPrev
a.seatPrev={}
for n,t in pairs(e)do
a.seatPrev[n]=t
end
if a.phase=="intro"then
a.phaseTick=a.phaseTick+1
local n=false
for t,u in pairs(e)do
if b.has(u,b.A)and not b.has(s[t]or 0,b.A)then
n=true
end
end
if n or a.phaseTick>=d.intro then
a.phase="countdown"
a.phaseTick=0
end
r(a)
elseif a.phase=="countdown"then
H(a,e)
r(a)
elseif a.phase=="race"then
o(a,e)
elseif a.phase=="finish"then
a.phaseTick=a.phaseTick+1
o(a,e)
if a.phaseTick>=d.afterFinish then
a.phase="done"
end
end
end

function c.skipIntro(a)
if a.phase=="intro"then
a.phase="countdown"
a.phaseTick=0
end
end

function c.finishTimes(e)
local n={}
local s=d.laps*#e.track.waypoints
local t=0
for I,u in ipairs(e.order)do
local m=e.karts[u]
local a
if m.finished then
a=m.finishTick
else
local y=SpiffBoy.clamp(m.progress,1,s-1)
a=math.max(e.raceTick+1,g(e.raceTick*s/y))
end
a=math.max(a,t+1)
n[u]=a
t=a
end
return n
end

function c.lapOf(a)
return math.min(d.laps,math.max(1,a.lap))
end

function c.checksum(m)
local a=m.tick%65521
for n,e in ipairs(m.karts)do
a=(a*31+e.x%65521+e.y%65521*7+e.heading*3+(e.item or 0)*11+e.rank)%65521
end
a=(a+#m.shots*13+#m.hazards*17)%65521
return a
end
