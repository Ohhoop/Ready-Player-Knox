require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Roster"

local n=SpiffBoy.QuickStart
local e=n.Fixed
local f=n.Tracks
local y=n.Roster

local d={}
n.Kart=d

local c=math.floor
local g=e.UNIT
local z=e.FINE
local v=e.ONE
local h=e.divide

d.TUNING={
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

local b=d.TUNING

function d.new(i,j,k,a,l)
local m=y.statsOf(i)
return{
driver=i,stats=m,cc=l,
x=j,y=k,heading=a,moveAngle=a,speed=0,z=0,vz=0,
drift=0,driftCharge=0,boost=0,spin=0,spinTotal=0,spinBase=a,invincible=0,slow=0,
coins=0,item=nil,itemCount=0,roulette=0,bits=0,steerLevel=0,
progress=0,wp=1,lap=1,finished=false,finishTick=nil,rank=1,
respawn=0,lastSafe=1,cans=3,out=false,hits=0,startCharge=0,upTap=-1000,
topScale=100,
}
end

d.UP=1
d.DOWN=2
d.LEFT=4
d.RIGHT=8
d.A=16
d.B=32

local function j(a,i)
return c(a/i)%2==1
end
d.has=j

function d.with(a,i)
if j(a,i)then
return a
end
return a+i
end

function d.topSpeed(a,k)
local i=c(a.cc.top*a.stats.top/100*a.topScale/100)
i=i+c(i*a.coins*b.coinTop/100)
if a.boost>0 then
return c(i*b.boostTop/100)
end
if a.invincible>0 then
i=c(i*b.riotTop/100)
elseif a.slow>0 then
i=c(i*b.thunderTop/100)
end
if k==f.OFFROAD and a.z==0 then
return c(i*b.offroad*a.stats.offroad/10000)
end
if k==f.MUD and a.z==0 then
return c(i*b.mud*a.stats.offroad/10000)
end
return i
end

function d.startSpin(a,i)
a.spin=i
a.spinTotal=i
a.spinBase=a.moveAngle
a.steerLevel=0
end

function d.endSpin(a)
a.spin=0
a.heading=a.spinBase
a.moveAngle=a.spinBase
end

local function A(a)
a.spin=a.spin-1
if a.spin==0 then
d.endSpin(a)
return
end
local i=math.max(1,c((a.spinTotal*b.spinRate+e.FINE_TURN/2)/e.FINE_TURN))
local k=a.spinTotal-a.spin
a.heading=e.wrapFine(a.spinBase+c(e.FINE_TURN*i*k/a.spinTotal))
end

function d.spinOut(a,k,i,l)
if a.invincible>0 or a.respawn>0 then
return false
end
d.startSpin(a,k)
a.drift,a.driftCharge,a.boost=0,0,0
a.speed=c(a.speed/3)
a.coins=math.max(0,a.coins-2)
a.hits=a.hits+1
i[#i+1]={kind="spin",kart=l}
return true
end

function d.boostFor(a,k,i,l)
a.boost=math.max(a.boost,k)
i[#i+1]={kind="boost",kart=l}
end

function d.placeBack(a,m)
local k=m.waypoints
local i=k[a.lastSafe]
local l=k[a.lastSafe%#k+1]
a.x,a.y=i.x*g,i.y*g
a.heading=e.atan2(l.y-i.y,l.x-i.x)
a.moveAngle=a.heading
a.speed,a.z,a.vz,a.drift,a.driftCharge,a.spin=0,0,0,0,0,0
end

local function B(a,l)
local i=e.deltaFine(a.moveAngle,a.heading)
local k=h(i*l,100)
if k==0 and i~=0 then
k=i>0 and 1 or-1
end
a.moveAngle=e.wrapFine(a.moveAngle+k)
end

local function C(a,k,D,E,o,w)
local i=d.topSpeed(a,E)
if a.spin>0 then
A(a)
a.speed=c(a.speed*92/100)
return
end
local x=c(a.cc.top*a.stats.accel/100/b.accelTicks)+1
local F=SpiffBoy.clamp(c((i-a.speed)*100/math.max(1,i)),0,100)
local p=x+c(x*F*b.launch/10000)
if j(k,d.UP)or a.boost>0 then
if a.speed<i then
a.speed=math.min(i,a.speed+p)
else
a.speed=math.max(i,a.speed-p)
end
elseif j(k,d.DOWN)then
a.speed=math.max(-c(i*b.reverse/100),a.speed-b.brake)
elseif a.speed>0 then
a.speed=math.max(0,a.speed-b.coast)
elseif a.speed<0 then
a.speed=math.min(0,a.speed+b.coast)
end
if a.speed>i then
a.speed=math.max(i,a.speed-p*2)
end
local q=(j(k,d.RIGHT)and 1 or 0)-(j(k,d.LEFT)and 1 or 0)
local r=j(k,d.A)
local G=r and not j(D,d.A)
if G and a.z==0 then
a.vz=b.hop
o[#o+1]={kind="hop",kart=w}
end
if a.drift==0 and r and a.z>0 and q~=0 and a.speed>c(i/2)then
a.drift=q
a.driftCharge=0
end
if a.drift~=0 and(not r or a.speed<c(i/3))then
local l=0
for m,s in ipairs(b.driftLevels)do
if a.driftCharge>=s then
l=m
end
end
if l>0 then
d.boostFor(a,b.driftBoosts[l],o,w)
end
a.drift,a.driftCharge=0,0
end
local m=q*100
if a.steerLevel<m then
local l=a.steerLevel<0 and b.steerFall or b.steerRise
a.steerLevel=math.min(m,a.steerLevel+l)
elseif a.steerLevel>m then
local l=a.steerLevel>0 and b.steerFall or b.steerRise
a.steerLevel=math.max(m,a.steerLevel-l)
end
local s=c(math.abs(a.speed)*100/math.max(1,i))
local t
if s<b.turnFull then
t=c(s*100/b.turnFull)
else
t=math.max(b.turnAtTop,100-c((s-b.turnFull)*(100-b.turnAtTop)/(100-b.turnFull)))
end
local u=c(b.turn*a.stats.turn/100*t/100)
local l
if a.drift~=0 then
a.driftCharge=a.driftCharge+1
l=a.drift*c(u*b.driftTurn/100)+h(u*b.driftSteer/100*a.steerLevel,100)
else
l=h(u*a.steerLevel,100)
end
if a.speed<0 then
l=-l
end
a.heading=e.wrapFine(a.heading+l)
B(a,a.drift~=0 and b.driftGrip or b.grip)
end

local function s(i,k,l,m)
local x=f.surfaceAt(k,c(i.x/g),c(i.y/g))==f.WALL
if not x and f.surfaceAt(k,c(l/g),c(m/g))==f.WALL then
return"wall"
end
local o=f.solidsNear(k,l,m)
for D=1,#o do
local a=o[D]
local p,q=l-a.x,m-a.y
local r=a.radius+b.radius
local t=p*p+q*q
if t<r*r then
local u,w=i.x-a.x,i.y-a.y
if u*u+w*w>=t then
return a
end
end
end
return nil
end

local function x(a,p,o,i,k)
if o=="wall"then
local l=f.surfaceAt(p,c((a.x+i)/g),c(a.y/g))==f.WALL
local m=f.surfaceAt(p,c(a.x/g),c((a.y+k)/g))==f.WALL
if not l and not m then
l,m=true,true
end
local q=l and-h(i*b.bounce,100)or h(i*b.scrape,100)
local r=m and-h(k*b.bounce,100)or h(k*b.scrape,100)
return q,r
end
local l,m=a.x-o.x,a.y-o.y
local q=math.max(1,l*l+m*m)
local r=i*l+k*m
local t,u=h(r*l,q),h(r*m,q)
local w,D=i-t,k-u
return h(w*b.scrape,100)-h(t*b.bounce,100),h(D*b.scrape,100)-h(u*b.bounce,100)
end

local function D(a,o,i,k)
local r=c(a.moveAngle/z)
local p=c(e.cos(r)*a.speed/v)
local q=c(e.sin(r)*a.speed/v)
local t=s(a,o,a.x+p,a.y+q)
if t then
local l,m=x(a,o,t,p,q)
local u=e.length(l,m)
if a.speed>=0 then
a.moveAngle=e.atan2(m,l)
a.speed=u
local w=e.deltaFine(a.heading,a.moveAngle)
if math.abs(w)<e.FINE_TURN/4 then
a.heading=e.wrapFine(a.heading+h(w*b.bumpTurn,100))
end
else
a.moveAngle=e.atan2(-m,-l)
a.speed=-u
end
i[#i+1]={kind="bump",kart=k}
if not s(a,o,a.x+l,a.y+m)then
a.x,a.y=a.x+l,a.y+m
end
else
a.x,a.y=a.x+p,a.y+q
end
local l=f.surfaceAt(o,c(a.x/g),c(a.y/g))
if a.vz~=0 or a.z>0 then
a.z=a.z+a.vz
a.vz=a.vz-b.gravity
if a.z<=0 then
a.z,a.vz=0,0
i[#i+1]={kind="land",kart=k}
end
end
if l==f.RAMP and a.z==0 and a.speed>c(a.cc.top*b.rampShare/100)then
a.vz=b.ramp
a.z=1
i[#i+1]={kind="ramp",kart=k}
end
if l==f.BOOST and a.z==0 then
d.boostFor(a,b.padBoost,i,k)
end
if l==f.WATER and a.z==0 and a.respawn==0 then
a.respawn=b.respawnTicks
a.speed=0
i[#i+1]={kind="splash",kart=k}
end
return l
end

function d.step(a,k,i,l,m)
local o=a.bits
a.bits=k
if a.boost>0 then
a.boost=a.boost-1
end
if a.invincible>0 then
a.invincible=a.invincible-1
end
if a.slow>0 then
a.slow=a.slow-1
end
if a.respawn>0 then
a.respawn=a.respawn-1
if a.respawn==0 then
d.placeBack(a,i)
end
return
end
local p=f.surfaceAt(i,c(a.x/g),c(a.y/g))
C(a,k,o,p,l,m)
D(a,i,l,m)
end

function d.countdown(a,i,k)
a.bits=i
if j(i,d.UP)then
a.startCharge=a.startCharge+1
else
a.startCharge=0
end
if k==0 then
local l=a.startCharge
a.startCharge=0
return l
end
return nil
end

function d.collide(a,i)
if a.respawn>0 or i.respawn>0 or a.out or i.out then
return false
end
local k,l=i.x-a.x,i.y-a.y
local p=b.radius*2
local w=k*k+l*l
if w>=p*p or math.abs(a.z-i.z)>6*g then
return false
end
local m=math.max(1,e.length(k,l))
local t=p-m
local q,o=a.stats.weight,i.stats.weight
if a.invincible>0 then
q=q+10
end
if i.invincible>0 then
o=o+10
end
local r=c(t*o/(q+o))
local u=t-r
a.x=a.x-c(k*r/m)
a.y=a.y-c(l*r/m)
i.x=i.x+c(k*u/m)
i.y=i.y+c(l*u/m)
return true
end
