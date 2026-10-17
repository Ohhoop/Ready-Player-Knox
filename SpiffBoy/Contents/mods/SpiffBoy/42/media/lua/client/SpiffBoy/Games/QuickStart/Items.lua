require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Kart"

local o=SpiffBoy.QuickStart
local e=o.Fixed
local l=o.Tracks
local p=o.Kart

local a={}
o.Items=a

local c=math.floor
local g=e.UNIT
local m=e.FINE
local k=e.ONE

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

local function v(d,f)
if d==1 then
return a.RACE_ODDS[1]
end
if d==f then
return a.RACE_ODDS[5]
end
local h=(d-1)/(f-1)
if h<=0.34 then
return a.RACE_ODDS[2]
end
if h<=0.67 then
return a.RACE_ODDS[3]
end
return a.RACE_ODDS[4]
end

function a.roll(d,q)
local h=d.battle and a.BATTLE_ODDS or v(q,#d.karts)
local i=0
for j,f in ipairs(h)do
i=i+f[2]
end
local j=d.random:int(1,i)
local f=h[#h][1]
for r,n in ipairs(h)do
j=j-n[2]
if j<=0 then
f=n[1]
break
end
end
if(f==a.HELICOPTER and d.helicopter)or(f==a.THUNDER and d.storm>0)then
f=a.COFFEE3
end
return f
end

function a.hit(d,h,i)
local f=d.karts[h]
if not p.spinOut(f,i,d.events,h)then
return false
end
if d.battle then
f.cans=f.cans-1
d.events[#d.events+1]={kind="can",kart=h}
if f.cans<=0 then
f.out=true
f.outTick=d.tick
d.events[#d.events+1]={kind="out",kart=h}
end
end
return true
end

local function w(d,j)
local f=d.karts[j]
if d.battle then
local n,h=nil,nil
for q,i in ipairs(d.karts)do
if q~=j and not i.out then
local r,s=i.x-f.x,i.y-f.y
local t=r*r+s*s
if not h or t<h then
n,h=q,t
end
end
end
return n
end
for h,i in ipairs(d.karts)do
if i.rank==f.rank-1 then
return h
end
end
return nil
end

function a.use(f,h,q,x)
local d=f.karts[h]
local j=d.item
if not j or d.roulette>0 then
return
end
local r=c(d.heading/m)
local s,t=e.cos(r),e.sin(r)
local i=f.events
if j==a.GLASS then
if x and not q then
local u=b.glassReach*g+math.max(0,d.speed)*b.glassAir
local n=c(u/b.glassAir)
f.hazards[#f.hazards+1]={
kind="glass",x=d.x,y=d.y,life=b.glassLife,
vx=c(s*n/k),vy=c(t*n/k),air=b.glassAir,
}
i[#i+1]={kind="throw",kart=h}
else
f.hazards[#f.hazards+1]={kind="glass",x=d.x-c(s*b.glassDrop*g/k),y=d.y-c(t*b.glassDrop*g/k),life=b.glassLife,air=0}
i[#i+1]={kind="drop",kart=h}
end
elseif j==a.PIPEBOMB then
local n=q and e.wrapFine(d.heading+e.FINE_TURN/2)or d.heading
f.shots[#f.shots+1]={kind="pipebomb",x=d.x,y=d.y,heading=n,life=b.bombLife,bounces=0,owner=h,arm=b.arm}
i[#i+1]={kind="throw",kart=h}
elseif j==a.PISTOL then
local n=q and e.wrapFine(d.heading+e.FINE_TURN/2)or d.heading
f.shots[#f.shots+1]={kind="bullet",x=d.x,y=d.y,heading=n,life=b.bulletLife,owner=h,arm=b.arm,target=(not q)and w(f,h)or nil}
i[#i+1]={kind="shot",kart=h}
elseif j==a.HELICOPTER then
local n=nil
for y,u in ipairs(f.karts)do
if u.rank==1 and not u.finished then
n=y
end
end
if n then
f.helicopter={target=n,x=d.x,y=d.y,owner=h,horde=0}
i[#i+1]={kind="helicopter",kart=h}
end
elseif j==a.COFFEE or j==a.COFFEE3 then
p.boostFor(d,b.coffeeBoost,i,h)
elseif j==a.RIOT then
d.invincible=b.riotTicks
if d.spin>0 then
p.endSpin(d)
end
i[#i+1]={kind="riot",kart=h}
elseif j==a.THUNDER then
f.storm=b.thunderTicks
f.stormOwner=h
for u,n in ipairs(f.karts)do
if u~=h and n.invincible==0 then
n.slow=b.thunderTicks-c((#f.karts-n.rank)*10)
n.item,n.itemCount,n.roulette=nil,0,0
end
end
i[#i+1]={kind="thunder",kart=h}
end
d.itemCount=d.itemCount-1
if d.itemCount<=0 then
d.item,d.itemCount=nil,0
end
end

function a.give(f,h)
local d=f.karts[h]
if d.item or d.roulette>0 then
return
end
d.item=a.roll(f,d.rank)
d.itemCount=d.item==a.COFFEE3 and 3 or 1
d.roulette=b.roulette
f.events[#f.events+1]={kind="crate",kart=h}
end

local function h(d,n,q,f)
if d.respawn>0 or d.out or d.z>8*g then
return false
end
local i,j=d.x-n,d.y-q
return i*i+j*j<f*f
end

local function s(f,d)
d.life=d.life-1
if d.arm>0 then
d.arm=d.arm-1
end
local j=c(d.heading/m)
local i=d.x+c(e.cos(j)*b.bombSpeed/k)
local n=d.y+c(e.sin(j)*b.bombSpeed/k)
if l.surfaceAt(f.track,c(i/g),c(n/g))==l.WALL then
d.bounces=d.bounces+1
local r=l.surfaceAt(f.track,c(i/g),c(d.y/g))==l.WALL
local q=d.heading
if r then
d.heading=e.wrapFine(e.FINE_TURN/2-q)
else
d.heading=e.wrapFine(-q)
end
f.events[#f.events+1]={kind="bounce"}
else
d.x,d.y=i,n
end
for q,r in ipairs(f.karts)do
if(q~=d.owner or d.arm==0)and h(r,d.x,d.y,b.bombHit)then
a.hit(f,q,b.bombSpinTicks)
f.events[#f.events+1]={kind="boom",x=d.x,y=d.y}
return false
end
end
return d.life>0 and d.bounces<=b.bombBounces
end

local function t(f,d)
d.life=d.life-1
if d.arm>0 then
d.arm=d.arm-1
end
local i=d.target and f.karts[d.target]
if i and not i.out and i.respawn==0 then
local n=e.atan2(c((i.y-d.y)/g),c((i.x-d.x)/g))
local j=e.delta(c(d.heading/m),c(n/m))
j=SpiffBoy.clamp(j,-b.bulletTurn,b.bulletTurn)
d.heading=e.wrapFine(d.heading+j*m)
end
local n=c(d.heading/m)
d.x=d.x+c(e.cos(n)*b.bulletSpeed/k)
d.y=d.y+c(e.sin(n)*b.bulletSpeed/k)
if l.surfaceAt(f.track,c(d.x/g),c(d.y/g))==l.WALL then
return false
end
for j,q in ipairs(f.karts)do
if(j~=d.owner or d.arm==0)and h(q,d.x,d.y,b.bulletHit)then
a.hit(f,j,b.spinTicks)
f.events[#f.events+1]={kind="hit",kart=j}
return false
end
end
return d.life>0
end

local function u(f)
local d=f.helicopter
local i=f.karts[d.target]
if d.horde>0 then
d.horde=d.horde-1
if d.horde==0 then
f.helicopter=nil
end
return
end
local n,q=i.x-d.x,i.y-d.y
local j=e.length(c(n/g),c(q/g))*g
if j<=b.helicopterSpeed then
d.x,d.y=i.x,i.y
d.horde=b.hordeTicks
for r,x in ipairs(f.karts)do
if r~=d.owner and h(x,i.x,i.y,b.hordeReach)then
a.hit(f,r,b.hordeTicks)
end
end
f.events[#f.events+1]={kind="horde",kart=d.target}
return
end
d.x=d.x+c(n*b.helicopterSpeed/j)
d.y=d.y+c(q*b.helicopterSpeed/j)
end

function a.step(d)
for j=#d.hazards,1,-1 do
local f=d.hazards[j]
f.life=f.life-1
local i=f.life<=0
if f.air>0 then
f.x,f.y=f.x+f.vx,f.y+f.vy
f.air=f.air-1
elseif not i then
for n,q in ipairs(d.karts)do
if h(q,f.x,f.y,b.glassHit)then
a.hit(d,n,b.spinTicks)
i=true
break
end
end
end
if i then
table.remove(d.hazards,j)
end
end
for j=#d.shots,1,-1 do
local f=d.shots[j]
local i
if f.kind=="pipebomb"then
i=s(d,f)
else
i=t(d,f)
end
if not i then
table.remove(d.shots,j)
end
end
if d.helicopter then
u(d)
end
if d.storm>0 then
d.storm=d.storm-1
end
for n,f in ipairs(d.crates)do
if f.wait>0 then
f.wait=f.wait-1
else
for i,j in ipairs(d.karts)do
if h(j,f.x,f.y,b.pickup)then
f.wait=b.crateRespawn
a.give(d,i)
break
end
end
end
end
for n,f in ipairs(d.money)do
if f.wait>0 then
f.wait=f.wait-1
else
for j,i in ipairs(d.karts)do
if h(i,f.x,f.y,b.pickup)then
f.wait=b.moneyRespawn
if i.coins<p.TUNING.coinMax then
i.coins=i.coins+1
end
d.events[#d.events+1]={kind="money",kart=j}
break
end
end
end
end
for i,f in ipairs(d.karts)do
if f.roulette>0 then
f.roulette=f.roulette-1
end
end
end
