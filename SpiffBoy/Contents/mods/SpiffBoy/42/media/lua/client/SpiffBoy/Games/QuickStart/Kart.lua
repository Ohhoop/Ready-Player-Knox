require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Roster"

local n=SpiffBoy.QuickStart
local f=n.Fixed
local g=n.Tracks
local w=n.Roster

local e={}
n.Kart=e

local d=math.floor
local h=f.UNIT
local z=f.FINE
local s=f.ONE
local i=f.divide

e.TUNING={
accelTicks=110,
launch=100,
brake=12,
coast=3,
reverse=30,
turn=140,
turnFull=15,
turnAtTop=75,
steerRise=18,
steerFall=30,
driftTurn=35,
grip=50,
driftGrip=12,
driftSteer=35,
driftLevels={40,90},
driftBoosts={20,40},
boostTop=160,
padBoost=30,
riotTop=120,
thunderTop=70,
offroad=55,
mud=45,
coinTop=1,
coinMax=10,
hop=230,
ramp=560,
gravity=31,
rampShare=40,
spinTicks=60,
spinRate=900,
respawnTicks=90,
bounce=40,
scrape=85,
bumpTurn=60,
radius=4*256,
startWindow={20,6},
startBoost=40,
}

local c=e.TUNING

function e.new(driverIndex,x,y,heading,cc)
local a=w.statsOf(driverIndex)
return{
driver=driverIndex,stats=a,cc=cc,
x=x,y=y,heading=heading,moveAngle=heading,speed=0,z=0,vz=0,
drift=0,driftCharge=0,boost=0,spin=0,spinTotal=0,spinBase=heading,invincible=0,slow=0,
coins=0,item=nil,itemCount=0,roulette=0,bits=0,steerLevel=0,
progress=0,wp=1,lap=1,finished=false,finishTick=nil,rank=1,
respawn=0,lastSafe=1,cans=3,out=false,hits=0,startCharge=0,upTap=-1000,
topScale=100,
}
end

e.UP=1
e.DOWN=2
e.LEFT=4
e.RIGHT=8
e.A=16
e.B=32

local function j(bits,flag)
return d(bits/flag)%2==1
end
e.has=j

function e.with(bits,flag)
if j(bits,flag)then
return bits
end
return bits+flag
end

function e.topSpeed(kart,surface)
local a=d(kart.cc.top*kart.stats.top/100*kart.topScale/100)
a=a+d(a*kart.coins*c.coinTop/100)
if kart.boost>0 then
return d(a*c.boostTop/100)
end
if kart.invincible>0 then
a=d(a*c.riotTop/100)
elseif kart.slow>0 then
a=d(a*c.thunderTop/100)
end
if surface==g.OFFROAD and kart.z==0 then
return d(a*c.offroad*kart.stats.offroad/10000)
end
if surface==g.MUD and kart.z==0 then
return d(a*c.mud*kart.stats.offroad/10000)
end
return a
end

function e.startSpin(kart,ticks)
kart.spin=ticks
kart.spinTotal=ticks
kart.spinBase=kart.moveAngle
kart.steerLevel=0
end

function e.endSpin(kart)
kart.spin=0
kart.heading=kart.spinBase
kart.moveAngle=kart.spinBase
end

local function A(kart)
kart.spin=kart.spin-1
if kart.spin==0 then
e.endSpin(kart)
return
end
local a=math.max(1,d((kart.spinTotal*c.spinRate+f.FINE_TURN/2)/f.FINE_TURN))
local b=kart.spinTotal-kart.spin
kart.heading=f.wrapFine(kart.spinBase+d(f.FINE_TURN*a*b/kart.spinTotal))
end

function e.spinOut(kart,ticks,events,index)
if kart.invincible>0 or kart.respawn>0 then
return false
end
e.startSpin(kart,ticks)
kart.drift,kart.driftCharge,kart.boost=0,0,0
kart.speed=d(kart.speed/3)
kart.coins=math.max(0,kart.coins-2)
kart.hits=kart.hits+1
events[#events+1]={kind="spin",kart=index}
return true
end

function e.boostFor(kart,ticks,events,index)
kart.boost=math.max(kart.boost,ticks)
events[#events+1]={kind="boost",kart=index}
end

function e.placeBack(kart,track)
local b=track.waypoints
local a=b[kart.lastSafe]
local k=b[kart.lastSafe%#b+1]
kart.x,kart.y=a.x*h,a.y*h
kart.heading=f.atan2(k.y-a.y,k.x-a.x)
kart.moveAngle=kart.heading
kart.speed,kart.z,kart.vz,kart.drift,kart.driftCharge,kart.spin=0,0,0,0,0,0
end

local function B(kart,share)
local a=f.deltaFine(kart.moveAngle,kart.heading)
local b=i(a*share,100)
if b==0 and a~=0 then
b=a>0 and 1 or-1
end
kart.moveAngle=f.wrapFine(kart.moveAngle+b)
end

local function C(kart,bits,previous,surface,events,index)
local a=e.topSpeed(kart,surface)
if kart.spin>0 then
A(kart)
kart.speed=d(kart.speed*92/100)
return
end
local t=d(kart.cc.top*kart.stats.accel/100/c.accelTicks)+1
local u=SpiffBoy.clamp(d((a-kart.speed)*100/math.max(1,a)),0,100)
local l=t+d(t*u*c.launch/10000)
if j(bits,e.UP)or kart.boost>0 then
if kart.speed<a then
kart.speed=math.min(a,kart.speed+l)
else
kart.speed=math.max(a,kart.speed-l)
end
elseif j(bits,e.DOWN)then
kart.speed=math.max(-d(a*c.reverse/100),kart.speed-c.brake)
elseif kart.speed>0 then
kart.speed=math.max(0,kart.speed-c.coast)
elseif kart.speed<0 then
kart.speed=math.min(0,kart.speed+c.coast)
end
if kart.speed>a then
kart.speed=math.max(a,kart.speed-l*2)
end
local m=(j(bits,e.RIGHT)and 1 or 0)-(j(bits,e.LEFT)and 1 or 0)
local o=j(bits,e.A)
local v=o and not j(previous,e.A)
if v and kart.z==0 then
kart.vz=c.hop
events[#events+1]={kind="hop",kart=index}
end
if kart.drift==0 and o and kart.z>0 and m~=0 and kart.speed>d(a/2)then
kart.drift=m
kart.driftCharge=0
end
if kart.drift~=0 and(not o or kart.speed<d(a/3))then
local b=0
for k,p in ipairs(c.driftLevels)do
if kart.driftCharge>=p then
b=k
end
end
if b>0 then
e.boostFor(kart,c.driftBoosts[b],events,index)
end
kart.drift,kart.driftCharge=0,0
end
local k=m*100
if kart.steerLevel<k then
local b=kart.steerLevel<0 and c.steerFall or c.steerRise
kart.steerLevel=math.min(k,kart.steerLevel+b)
elseif kart.steerLevel>k then
local b=kart.steerLevel>0 and c.steerFall or c.steerRise
kart.steerLevel=math.max(k,kart.steerLevel-b)
end
local p=d(math.abs(kart.speed)*100/math.max(1,a))
local q
if p<c.turnFull then
q=d(p*100/c.turnFull)
else
q=math.max(c.turnAtTop,100-d((p-c.turnFull)*(100-c.turnAtTop)/(100-c.turnFull)))
end
local r=d(c.turn*kart.stats.turn/100*q/100)
local b
if kart.drift~=0 then
kart.driftCharge=kart.driftCharge+1
b=kart.drift*d(r*c.driftTurn/100)+i(r*c.driftSteer/100*kart.steerLevel,100)
else
b=i(r*kart.steerLevel,100)
end
if kart.speed<0 then
b=-b
end
kart.heading=f.wrapFine(kart.heading+b)
B(kart,kart.drift~=0 and c.driftGrip or c.grip)
end

local function t(kart,track,x,y)
local r=g.surfaceAt(track,d(kart.x/h),d(kart.y/h))==g.WALL
if not r and g.surfaceAt(track,d(x/h),d(y/h))==g.WALL then
return"wall"
end
local b=g.solidsNear(track,x,y)
for u=1,#b do
local a=b[u]
local k,l=x-a.x,y-a.y
local m=a.radius+c.radius
local o=k*k+l*l
if o<m*m then
local p,q=kart.x-a.x,kart.y-a.y
if p*p+q*q>=o then
return a
end
end
end
return nil
end

local function x(kart,track,obstacle,vx,vy)
if obstacle=="wall"then
local a=g.surfaceAt(track,d((kart.x+vx)/h),d(kart.y/h))==g.WALL
local b=g.surfaceAt(track,d(kart.x/h),d((kart.y+vy)/h))==g.WALL
if not a and not b then
a,b=true,true
end
local k=a and-i(vx*c.bounce,100)or i(vx*c.scrape,100)
local l=b and-i(vy*c.bounce,100)or i(vy*c.scrape,100)
return k,l
end
local a,b=kart.x-obstacle.x,kart.y-obstacle.y
local k=math.max(1,a*a+b*b)
local l=vx*a+vy*b
local m,o=i(l*a,k),i(l*b,k)
local p,q=vx-m,vy-o
return i(p*c.scrape,100)-i(m*c.bounce,100),i(q*c.scrape,100)-i(o*c.bounce,100)
end

local function y(kart,track,events,index)
local m=d(kart.moveAngle/z)
local k=d(f.cos(m)*kart.speed/s)
local l=d(f.sin(m)*kart.speed/s)
local o=t(kart,track,kart.x+k,kart.y+l)
if o then
local a,b=x(kart,track,o,k,l)
local p=f.length(a,b)
if kart.speed>=0 then
kart.moveAngle=f.atan2(b,a)
kart.speed=p
local q=f.deltaFine(kart.heading,kart.moveAngle)
if math.abs(q)<f.FINE_TURN/4 then
kart.heading=f.wrapFine(kart.heading+i(q*c.bumpTurn,100))
end
else
kart.moveAngle=f.atan2(-b,-a)
kart.speed=-p
end
events[#events+1]={kind="bump",kart=index}
if not t(kart,track,kart.x+a,kart.y+b)then
kart.x,kart.y=kart.x+a,kart.y+b
end
else
kart.x,kart.y=kart.x+k,kart.y+l
end
local a=g.surfaceAt(track,d(kart.x/h),d(kart.y/h))
if kart.vz~=0 or kart.z>0 then
kart.z=kart.z+kart.vz
kart.vz=kart.vz-c.gravity
if kart.z<=0 then
kart.z,kart.vz=0,0
events[#events+1]={kind="land",kart=index}
end
end
if a==g.RAMP and kart.z==0 and kart.speed>d(kart.cc.top*c.rampShare/100)then
kart.vz=c.ramp
kart.z=1
events[#events+1]={kind="ramp",kart=index}
end
if a==g.BOOST and kart.z==0 then
e.boostFor(kart,c.padBoost,events,index)
end
if a==g.WATER and kart.z==0 and kart.respawn==0 then
kart.respawn=c.respawnTicks
kart.speed=0
events[#events+1]={kind="splash",kart=index}
end
return a
end

function e.step(kart,bits,track,events,index)
local a=kart.bits
kart.bits=bits
if kart.boost>0 then
kart.boost=kart.boost-1
end
if kart.invincible>0 then
kart.invincible=kart.invincible-1
end
if kart.slow>0 then
kart.slow=kart.slow-1
end
if kart.respawn>0 then
kart.respawn=kart.respawn-1
if kart.respawn==0 then
e.placeBack(kart,track)
end
return
end
local b=g.surfaceAt(track,d(kart.x/h),d(kart.y/h))
C(kart,bits,a,b,events,index)
y(kart,track,events,index)
end

function e.countdown(kart,bits,ticksLeft)
kart.bits=bits
if j(bits,e.UP)then
kart.startCharge=kart.startCharge+1
else
kart.startCharge=0
end
if ticksLeft==0 then
local a=kart.startCharge
kart.startCharge=0
return a
end
return nil
end

function e.collide(a,b)
if a.respawn>0 or b.respawn>0 or a.out or b.out then
return false
end
local k,l=b.x-a.x,b.y-a.y
local p=c.radius*2
local D=k*k+l*l
if D>=p*p or math.abs(a.z-b.z)>6*h then
return false
end
local m=math.max(1,f.length(k,l))
local u=p-m
local q,o=a.stats.weight,b.stats.weight
if a.invincible>0 then
q=q+10
end
if b.invincible>0 then
o=o+10
end
local r=d(u*o/(q+o))
local v=u-r
a.x=a.x-d(k*r/m)
a.y=a.y-d(l*r/m)
b.x=b.x+d(k*v/m)
b.y=b.y+d(l*v/m)
return true
end
