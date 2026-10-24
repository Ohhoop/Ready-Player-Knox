require"SpiffBoy/Core/Random"
require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Roster"
require"SpiffBoy/Games/QuickStart/Kart"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Brain"

local j=SpiffBoy.QuickStart
local k=j.Fixed
local o=j.Tracks
local H=j.Roster
local c=j.Kart
local f=j.Items
local p=j.Brain

local d={}
j.Race=d

local g=math.floor
local h=k.UNIT
local y=k.FINE

d.MODE_GP="gp"
d.MODE_VS="vs"
d.MODE_TT="tt"
d.MODE_BATTLE="battle"

d.TIMING={
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

local e=d.TIMING

local function u(track,kind)
local a={}
for i,b in ipairs(track.objects)do
if b.kind==kind then
a[#a+1]={x=b.x*h,y=b.y*h,wait=0}
end
end
return a
end

local function v(track,place)
local b=track.waypoints
local i=#b
local t=g((place-1)/2)
local m=1+t*e.gridGap
local l=(i-m)%i+1
local a,n=b[l],b[l%i+1]
local q=k.atan2(n.y-a.y,n.x-a.x)
local r=g(q/y)
local s=((place-1)%2==0)and-e.gridSide or e.gridSide
local w=a.x-g(k.sin(r)*s/k.ONE)
local x=a.y+g(k.cos(r)*s/k.ONE)
return w*h,x*h,q,l,-m
end

function d.new(params)
local b=o.load(params.track,params.cc.mirrored)
local a={
mode=params.mode,battle=params.mode==d.MODE_BATTLE,track=b,cc=params.cc,
random=SpiffBoyRandom.new(params.seed),tick=0,phase="intro",phaseTick=0,raceTick=0,
karts={},minds={},seats={},
crates=params.mode==d.MODE_TT and{}or u(b,"crate"),
money=(params.mode==d.MODE_BATTLE or params.mode==d.MODE_TT)and{}or u(b,"money"),
hazards={},shots={},helicopter=nil,storm=0,events={},finishOrder={},items=true,inputs={},
lapTimes={},ghost=nil,humanRank=1,seatPrev={},
}
for i,m in ipairs(params.grid)do
local q,r,s,n,t
if a.battle then
local l=b.spawns[i]
q,r=l.x*h,l.y*h
local w=b.extent/2
s=k.atan2(w-l.y,w-l.x)
n,t=1,0
else
q,r,s,n,t=v(b,i)
end
local l=c.new(m.driver,q,r,s,params.cc)
l.wp,l.progress,l.lastSafe=n,t,n
l.seat=m.seat
a.karts[i]=l
a.lapTimes[i]={}
if m.seat then
a.seats[m.seat]=i
else
a.minds[i]=p.new(a.random,params.cc)
end
end
if params.mode==d.MODE_TT then
local i=a.karts[1]
i.item,i.itemCount=f.COFFEE3,3
end
if params.ghost then
local m,n,q,l,r=v(b,1)
local i=c.new(params.ghost.driver,m,n,q,params.cc)
i.wp,i.progress,i.lastSafe=l,r,l
i.item,i.itemCount=f.COFFEE3,3
a.ghost={kart=i,reader=params.ghost.reader}
end
if params.skipIntro then
a.phase="countdown"
end
return a
end

local function z(world,kart)
local m=world.track.waypoints
local b=#m
local q,r=g(kart.x/h),g(kart.y/h)
local i,n=kart.wp,nil
for w=-2,e.lapSearch do
local a=j.wrapIndex(kart.wp+w,b)
local l,s=m[a].x-q,m[a].y-r
local t=l*l+s*s
if not n or t<n then
i,n=a,t
end
end
local a=i-kart.wp
if a>b/2 then
a=a-b
elseif a<-b/2 then
a=a+b
end
kart.progress=kart.progress+a
kart.wp=i
if o.surfaceAt(world.track,q,r)~=o.WATER and kart.z==0 then
kart.lastSafe=i
end
local l=g(kart.progress/b)+1
if l>kart.lap and l>=2 then
local s=world.lapTimes[kart.place]
s[#s+1]=world.raceTick
world.events[#world.events+1]={kind="lap",kart=kart.place,lap=l}
end
kart.lap=math.max(1,l)
end

local function A(world,kart)
local a=world.track.waypoints
local b=a[kart.wp%#a+1]
local i,l=b.x-g(kart.x/h),b.y-g(kart.y/h)
return i*i+l*l
end

local m
local n={}

local function B(a,b)
local i,l=m[a],m[b]
if i.out~=l.out then
return not i.out
end
if i.out then
if i.outTick~=l.outTick then
return i.outTick>l.outTick
end
return a<b
end
if i.cans~=l.cans then
return i.cans>l.cans
end
if i.hits~=l.hits then
return i.hits<l.hits
end
return a<b
end

local function C(a,b)
local i,l=m[a],m[b]
if i.finished~=l.finished then
return i.finished
end
if i.finished then
return i.finishTick<l.finishTick or(i.finishTick==l.finishTick and a<b)
end
if i.progress~=l.progress then
return i.progress>l.progress
end
if n[a]~=n[b]then
return n[a]<n[b]
end
return a<b
end

local function q(world)
local b={}
for a=1,#world.karts do
b[a]=a
end
local a=world.karts
m=a
if world.battle then
table.sort(b,B)
else
for i=1,#a do
n[i]=A(world,a[i])
end
table.sort(b,C)
end
m=nil
for i,l in ipairs(b)do
a[l].rank=i
end
world.order=b
local i=#a
for r,l in pairs(world.seats)do
i=math.min(i,a[l].rank)
end
world.humanRank=i
end

local function w(world,seatBits)
local b=world.inputs
for a,i in ipairs(world.karts)do
if i.seat and not i.finished then
b[a]=seatBits[i.seat]or 0
else
if not world.minds[a]then
world.minds[a]=p.new(world.random,world.cc)
end
b[a]=p.think(world,a,world.minds[a])
end
end
return b
end

local function D(world,place)
local a=world.karts[place]
a.finished=true
a.finishTick=world.raceTick
world.finishOrder[#world.finishOrder+1]=place
world.events[#world.events+1]={kind="finish",kart=place}
end

local function E(world)
if world.battle then
local a=0
for i,b in ipairs(world.karts)do
if not b.out then
a=a+1
end
end
return a<=1 or world.raceTick>=e.battleTicks
end
local a=0
for i,b in pairs(world.seats)do
a=a+1
if not world.karts[b].finished then
return false
end
end
if a==0 then
for i,b in ipairs(world.karts)do
if not b.finished then
return false
end
end
end
return true
end

local function F(world)
local b=world.ghost
local i=b.reader:next()
local a=b.kart
local l=a.bits
c.step(a,i,world.track,{},0)
if c.has(i,c.B)and not c.has(l,c.B)and a.item then
a.boost=math.max(a.boost,f.TUNING.coffeeBoost)
a.itemCount=a.itemCount-1
if a.itemCount<=0 then
a.item=nil
end
end
end

local function G(world,seatBits)
world.phaseTick=world.phaseTick+1
local r=e.countdown-world.phaseTick
local x=w(world,seatBits)
for a,b in pairs(world.minds)do
x[a]=r<=b.startAt and c.UP or 0
end
local b={}
for a,i in ipairs(world.karts)do
b[a]={kart=i,bits=x[a],place=a}
end
if world.ghost then
b[#b+1]={kart=world.ghost.kart,bits=world.ghost.reader:next(),place=0}
end
for I,s in ipairs(b)do
local t,i=s.kart,s.place
local l=c.countdown(t,s.bits,r)
if l then
local a=i==0 and{}or world.events
if l>e.startEarly then
c.startSpin(t,e.stallTicks)
a[#a+1]={kind="stall",kart=i}
elseif l>=c.TUNING.startWindow[2]and l<=c.TUNING.startWindow[1]then
c.boostFor(t,c.TUNING.startBoost,a,i)
a[#a+1]={kind="quickstart",kart=i}
end
end
end
for i,a in ipairs(e.lights)do
if world.phaseTick==a then
world.events[#world.events+1]={kind="light"}
end
end
if r<=0 then
world.phase="race"
world.events[#world.events+1]={kind="go"}
end
end

local function l(world,seatBits)
world.raceTick=world.raceTick+1
local s=w(world,seatBits)
for b,a in ipairs(world.karts)do
a.place=b
if not a.out then
local i,r=s[b],a.bits
c.step(a,i,world.track,world.events,b)
if c.has(i,c.UP)and not c.has(r,c.UP)then
a.upTap=world.raceTick
end
if world.items and a.respawn==0 and a.spin==0 then
if c.has(i,c.B)and not c.has(r,c.B)then
local t=world.raceTick-a.upTap<=f.TUNING.comboTicks
f.use(world,b,c.has(i,c.DOWN),t)
end
end
if not world.battle then
z(world,a)
if not a.finished and a.progress>=e.laps*#world.track.waypoints then
D(world,b)
end
end
end
end
for a=1,#world.karts do
for r=a+1,#world.karts do
local b,i=world.karts[a],world.karts[r]
if c.collide(b,i)then
if b.invincible>0 and i.invincible==0 then
f.hit(world,r,f.TUNING.spinTicks)
elseif i.invincible>0 and b.invincible==0 then
f.hit(world,a,f.TUNING.spinTicks)
end
end
end
end
if world.items then
f.step(world)
end
if world.ghost then
F(world)
end
q(world)
if world.phase=="race"and E(world)then
world.phase="finish"
world.phaseTick=0
world.events[#world.events+1]={kind="done"}
end
end

function d.step(world,seatBits)
world.tick=world.tick+1
local a=world.events
for b=#a,1,-1 do
a[b]=nil
end
local i=world.seatPrev
world.seatPrev={}
for b,r in pairs(seatBits)do
world.seatPrev[b]=r
end
if world.phase=="intro"then
world.phaseTick=world.phaseTick+1
local b=false
for r,s in pairs(seatBits)do
if c.has(s,c.A)and not c.has(i[r]or 0,c.A)then
b=true
end
end
if b or world.phaseTick>=e.intro then
world.phase="countdown"
world.phaseTick=0
end
q(world)
elseif world.phase=="countdown"then
G(world,seatBits)
q(world)
elseif world.phase=="race"then
l(world,seatBits)
elseif world.phase=="finish"then
world.phaseTick=world.phaseTick+1
l(world,seatBits)
if world.phaseTick>=e.afterFinish then
world.phase="done"
end
end
end

function d.skipIntro(world)
if world.phase=="intro"then
world.phase="countdown"
world.phaseTick=0
end
end

function d.finishTimes(world)
local i={}
local r=e.laps*#world.track.waypoints
local s=0
for I,t in ipairs(world.order)do
local b=world.karts[t]
local a
if b.finished then
a=b.finishTick
else
local x=SpiffBoy.clamp(b.progress,1,r-1)
a=math.max(world.raceTick+1,g(world.raceTick*r/x))
end
a=math.max(a,s+1)
i[t]=a
s=a
end
return i
end

function d.lapOf(kart)
return math.min(e.laps,math.max(1,kart.lap))
end

function d.checksum(world)
local a=world.tick%65521
for i,b in ipairs(world.karts)do
a=(a*31+b.x%65521+b.y%65521*7+b.heading*3+(b.item or 0)*11+b.rank)%65521
end
a=(a+#world.shots*13+#world.hazards*17)%65521
return a
end
