require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Kart"

local m=SpiffBoy.QuickStart
local e=m.Fixed
local j=m.Tracks
local n=m.Kart

local a={}
m.Items=a

local c=math.floor
local f=e.UNIT
local k=e.FINE
local i=e.ONE

a.GLASS=1
a.PIPEBOMB=2
a.PISTOL=3
a.HELICOPTER=4
a.COFFEE=5
a.COFFEE3=6
a.RIOT=7
a.THUNDER=8

a.KEYS={"BrokenGlass","PipeBomb","Pistol","Helicopter","CoffeeCup","CoffeeCups","RiotGear","Thunderstorm"}

a.TUNING={
roulette=50,
crateRespawn=150,
moneyRespawn=600,
pickup=7*256,
glassLife=2400,
glassHit=6*256,
glassDrop=10,
glassReach=48,
glassAir=24,
glassPeak=18,
comboTicks=12,
bombSpeed=700,
bombLife=420,
bombBounces=4,
bombHit=6*256,
bulletSpeed=820,
bulletTurn=7,
bulletLife=360,
bulletHit=6*256,
arm=20,
helicopterSpeed=900,
hordeTicks=110,
hordeReach=30*256,
coffeeBoost=40,
riotTicks=450,
thunderTicks=240,
spinTicks=60,
bombSpinTicks=80,
}

local b=a.TUNING

a.RACE_ODDS={
{{a.GLASS,45},{a.PIPEBOMB,30},{a.COFFEE,25}},
{{a.GLASS,25},{a.PIPEBOMB,30},{a.PISTOL,25},{a.COFFEE,20}},
{{a.PIPEBOMB,15},{a.PISTOL,30},{a.COFFEE,25},{a.COFFEE3,20},{a.RIOT,10}},
{{a.PISTOL,20},{a.COFFEE3,30},{a.RIOT,25},{a.THUNDER,10},{a.HELICOPTER,15}},
{{a.COFFEE3,30},{a.RIOT,30},{a.THUNDER,20},{a.HELICOPTER,20}},
}
a.BATTLE_ODDS={{a.GLASS,25},{a.PIPEBOMB,30},{a.PISTOL,25},{a.COFFEE,10},{a.RIOT,10}}

local function s(rank,count)
if rank==1 then
return a.RACE_ODDS[1]
end
if rank==count then
return a.RACE_ODDS[5]
end
local d=(rank-1)/(count-1)
if d<=0.34 then
return a.RACE_ODDS[2]
end
if d<=0.67 then
return a.RACE_ODDS[3]
end
return a.RACE_ODDS[4]
end

function a.roll(world,rank)
local g=world.battle and a.BATTLE_ODDS or s(rank,#world.karts)
local h=0
for l,d in ipairs(g)do
h=h+d[2]
end
local l=world.random:int(1,h)
local d=g[#g][1]
for p,o in ipairs(g)do
l=l-o[2]
if l<=0 then
d=o[1]
break
end
end
if(d==a.HELICOPTER and world.helicopter)or(d==a.THUNDER and world.storm>0)then
d=a.COFFEE3
end
return d
end

function a.hit(world,index,ticks)
local d=world.karts[index]
if not n.spinOut(d,ticks,world.events,index)then
return false
end
if world.battle then
d.cans=d.cans-1
world.events[#world.events+1]={kind="can",kart=index}
if d.cans<=0 then
d.out=true
d.outTick=world.tick
world.events[#world.events+1]={kind="out",kart=index}
end
end
return true
end

local function t(world,index)
local d=world.karts[index]
if world.battle then
local l,g=nil,nil
for o,h in ipairs(world.karts)do
if o~=index and not h.out then
local p,q=h.x-d.x,h.y-d.y
local r=p*p+q*q
if not g or r<g then
l,g=o,r
end
end
end
return l
end
for g,h in ipairs(world.karts)do
if h.rank==d.rank-1 then
return g
end
end
return nil
end

function a.use(world,index,backward,tapped)
local d=world.karts[index]
local h=d.item
if not h or d.roulette>0 then
return
end
local o=c(d.heading/k)
local p,q=e.cos(o),e.sin(o)
local g=world.events
if h==a.GLASS then
if tapped and not backward then
local r=b.glassReach*f+math.max(0,d.speed)*b.glassAir
local l=c(r/b.glassAir)
world.hazards[#world.hazards+1]={
kind="glass",x=d.x,y=d.y,life=b.glassLife,
vx=c(p*l/i),vy=c(q*l/i),air=b.glassAir,
}
g[#g+1]={kind="throw",kart=index}
else
world.hazards[#world.hazards+1]={kind="glass",x=d.x-c(p*b.glassDrop*f/i),y=d.y-c(q*b.glassDrop*f/i),life=b.glassLife,air=0}
g[#g+1]={kind="drop",kart=index}
end
elseif h==a.PIPEBOMB then
local l=backward and e.wrapFine(d.heading+e.FINE_TURN/2)or d.heading
world.shots[#world.shots+1]={kind="pipebomb",x=d.x,y=d.y,heading=l,life=b.bombLife,bounces=0,owner=index,arm=b.arm}
g[#g+1]={kind="throw",kart=index}
elseif h==a.PISTOL then
local l=backward and e.wrapFine(d.heading+e.FINE_TURN/2)or d.heading
world.shots[#world.shots+1]={kind="bullet",x=d.x,y=d.y,heading=l,life=b.bulletLife,owner=index,arm=b.arm,target=(not backward)and t(world,index)or nil}
g[#g+1]={kind="shot",kart=index}
elseif h==a.HELICOPTER then
local l=nil
for u,r in ipairs(world.karts)do
if r.rank==1 and not r.finished then
l=u
end
end
if l then
world.helicopter={target=l,x=d.x,y=d.y,owner=index,horde=0}
g[#g+1]={kind="helicopter",kart=index}
end
elseif h==a.COFFEE or h==a.COFFEE3 then
n.boostFor(d,b.coffeeBoost,g,index)
elseif h==a.RIOT then
d.invincible=b.riotTicks
if d.spin>0 then
n.endSpin(d)
end
g[#g+1]={kind="riot",kart=index}
elseif h==a.THUNDER then
world.storm=b.thunderTicks
world.stormOwner=index
for r,l in ipairs(world.karts)do
if r~=index and l.invincible==0 then
l.slow=b.thunderTicks-c((#world.karts-l.rank)*10)
l.item,l.itemCount,l.roulette=nil,0,0
end
end
g[#g+1]={kind="thunder",kart=index}
end
d.itemCount=d.itemCount-1
if d.itemCount<=0 then
d.item,d.itemCount=nil,0
end
end

function a.give(world,index)
local d=world.karts[index]
if d.item or d.roulette>0 then
return
end
d.item=a.roll(world,d.rank)
d.itemCount=d.item==a.COFFEE3 and 3 or 1
d.roulette=b.roulette
world.events[#world.events+1]={kind="crate",kart=index}
end

local function g(kart,x,y,reach)
if kart.respawn>0 or kart.out or kart.z>8*f then
return false
end
local d,h=kart.x-x,kart.y-y
return d*d+h*h<reach*reach
end

local function r(world,shot)
shot.life=shot.life-1
if shot.arm>0 then
shot.arm=shot.arm-1
end
local h=c(shot.heading/k)
local d=shot.x+c(e.cos(h)*b.bombSpeed/i)
local l=shot.y+c(e.sin(h)*b.bombSpeed/i)
if j.surfaceAt(world.track,c(d/f),c(l/f))==j.WALL then
shot.bounces=shot.bounces+1
local p=j.surfaceAt(world.track,c(d/f),c(shot.y/f))==j.WALL
local o=shot.heading
if p then
shot.heading=e.wrapFine(e.FINE_TURN/2-o)
else
shot.heading=e.wrapFine(-o)
end
world.events[#world.events+1]={kind="bounce"}
else
shot.x,shot.y=d,l
end
for o,p in ipairs(world.karts)do
if(o~=shot.owner or shot.arm==0)and g(p,shot.x,shot.y,b.bombHit)then
a.hit(world,o,b.bombSpinTicks)
world.events[#world.events+1]={kind="boom",x=shot.x,y=shot.y}
return false
end
end
return shot.life>0 and shot.bounces<=b.bombBounces
end

local function u(world,shot)
shot.life=shot.life-1
if shot.arm>0 then
shot.arm=shot.arm-1
end
local d=shot.target and world.karts[shot.target]
if d and not d.out and d.respawn==0 then
local l=e.atan2(c((d.y-shot.y)/f),c((d.x-shot.x)/f))
local h=e.delta(c(shot.heading/k),c(l/k))
h=SpiffBoy.clamp(h,-b.bulletTurn,b.bulletTurn)
shot.heading=e.wrapFine(shot.heading+h*k)
end
local l=c(shot.heading/k)
shot.x=shot.x+c(e.cos(l)*b.bulletSpeed/i)
shot.y=shot.y+c(e.sin(l)*b.bulletSpeed/i)
if j.surfaceAt(world.track,c(shot.x/f),c(shot.y/f))==j.WALL then
return false
end
for h,o in ipairs(world.karts)do
if(h~=shot.owner or shot.arm==0)and g(o,shot.x,shot.y,b.bulletHit)then
a.hit(world,h,b.spinTicks)
world.events[#world.events+1]={kind="hit",kart=h}
return false
end
end
return shot.life>0
end

local function v(world)
local d=world.helicopter
local h=world.karts[d.target]
if d.horde>0 then
d.horde=d.horde-1
if d.horde==0 then
world.helicopter=nil
end
return
end
local o,p=h.x-d.x,h.y-d.y
local l=e.length(c(o/f),c(p/f))*f
if l<=b.helicopterSpeed then
d.x,d.y=h.x,h.y
d.horde=b.hordeTicks
for q,w in ipairs(world.karts)do
if q~=d.owner and g(w,h.x,h.y,b.hordeReach)then
a.hit(world,q,b.hordeTicks)
end
end
world.events[#world.events+1]={kind="horde",kart=d.target}
return
end
d.x=d.x+c(o*b.helicopterSpeed/l)
d.y=d.y+c(p*b.helicopterSpeed/l)
end

function a.step(world)
for l=#world.hazards,1,-1 do
local d=world.hazards[l]
d.life=d.life-1
local h=d.life<=0
if d.air>0 then
d.x,d.y=d.x+d.vx,d.y+d.vy
d.air=d.air-1
elseif not h then
for o,p in ipairs(world.karts)do
if g(p,d.x,d.y,b.glassHit)then
a.hit(world,o,b.spinTicks)
h=true
break
end
end
end
if h then
table.remove(world.hazards,l)
end
end
for l=#world.shots,1,-1 do
local d=world.shots[l]
local h
if d.kind=="pipebomb"then
h=r(world,d)
else
h=u(world,d)
end
if not h then
table.remove(world.shots,l)
end
end
if world.helicopter then
v(world)
end
if world.storm>0 then
world.storm=world.storm-1
end
for o,d in ipairs(world.crates)do
if d.wait>0 then
d.wait=d.wait-1
else
for h,l in ipairs(world.karts)do
if g(l,d.x,d.y,b.pickup)then
d.wait=b.crateRespawn
a.give(world,h)
break
end
end
end
end
for o,d in ipairs(world.money)do
if d.wait>0 then
d.wait=d.wait-1
else
for l,h in ipairs(world.karts)do
if g(h,d.x,d.y,b.pickup)then
d.wait=b.moneyRespawn
if h.coins<n.TUNING.coinMax then
h.coins=h.coins+1
end
world.events[#world.events+1]={kind="money",kart=l}
break
end
end
end
end
for h,d in ipairs(world.karts)do
if d.roulette>0 then
d.roulette=d.roulette-1
end
end
end
