require"SpiffBoy/Core/Runtime"
require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Art"
require"SpiffBoy/Games/QuickStart/Road"
require"SpiffBoy/Games/QuickStart/Roster"
require"SpiffBoy/Games/QuickStart/Race"
require"SpiffBoy/Games/QuickStart/Hud"
require"SpiffBoy/Games/QuickStart/Items"

local d=SpiffBoy.QuickStart
local g=d.Fixed
local l=d.Atlas
local e=d.Road
local B=d.Roster
local v=d.Race
local x=d.Hud
local r=d.Items

local k={}
d.View=k

local c=math.floor
local b=g.UNIT
local s=g.FINE
local m=d.SHADES
local p=d.WIDTH

k.TUNING={
hudReserve=60,
bannerReserve=40,
cameraLag=3,
bannerTicks=80,
bannerSlide=20,
bannerY=24,
bannerPad=6,
bannerStrip=6,
bannerWave=2,
bannerWaveLength=36,
bannerWaveSpeed=0.3,
effectTicks=18,
rainShade=2,
rainSpeed=3,
flameBack=3,
flameLift=0,
cansLift=9,
}

local a=k.TUNING

function k.new(f)
return{place=f,angle=nil,effects={},banner=nil,bannerTicks=0,clock=0}
end

local function t(f,h)
f.banner=d.gameText(h)
f.bannerTicks=a.bannerTicks
end

local function y(f,h,i,j,n)
f.effects[#f.effects+1]={name=h,x=i,y=j,lift=n or 0,age=0}
end

function k.react(h,j,n)
for o,f in ipairs(n)do
if f.kart==h.place then
if f.kind=="quickstart"then
t(h,"QuickStartBanner")
elseif f.kind=="lap"and f.lap==v.TIMING.laps then
t(h,"FinalLap")
elseif f.kind=="finish"then
t(h,"Finish")
h.placeShown=true
elseif f.kind=="out"then
t(h,"Out")
end
end
if f.kind=="boom"then
y(h,"boom",c(f.x/b),c(f.y/b),2)
elseif f.kind=="splash"or f.kind=="spin"or f.kind=="horde"then
local i=j.karts[f.kart]
y(h,f.kind=="splash"and"splash"or"puff",c(i.x/b),c(i.y/b),2)
end
end
end

local function C(f,h)
local u=h.track
if h.phase=="intro"and not h.battle then
local j=u.waypoints
local n=#j
local o=c(h.phaseTick*n/v.TIMING.intro)%n+1
local i,q=j[o],j[(o+3)%n+1]
local w=c(g.atan2(q.y-i.y,q.x-i.x)/s)
return e.cameraBehind(i.x,i.y,w)
end
local i=h.karts[f.place]
local j=c(i.heading/s)
if not f.angle or h.phase~="race"and h.phase~="finish"then
f.angle=j
elseif i.spin==0 then
f.angle=g.wrap(f.angle+c(g.delta(f.angle,j)/a.cameraLag))
end
return e.cameraBehind(i.x/b,i.y/b,f.angle)
end

local function z(n,h,A,f,o,D)
if f.respawn>0 then
return
end
local i,j=f.x/b,f.y/b
local u=c(f.heading/s)
local w=e.frameOf(h,i,j,u)
if D and f.drift~=0 then
w=d.wrapIndex(w+f.drift,8)
end
local q=f.z/b
if q>0 then
e.add(n,h,"shadow",i,j,0,1,o)
end
e.add(n,h,B.artOf(f.driver),i,j,q,w,o)
if f.boost>0 then
local E=g.cos(u)*a.flameBack/g.ONE
local F=g.sin(u)*a.flameBack/g.ONE
e.add(n,h,"flame",i-E,j-F,q+a.flameLift,f.boost%3+1,o)
end
if A.battle and not f.out then
e.add(n,h,"gascans",i,j,q+a.cansLift,f.cans,o)
end
end

local function D(n,f,i)
local h=e.newScene()
local q=n.clock
e.addDecor(h,i,f.track)
local u=c(q/6)%8+1
for o,j in ipairs(f.crates)do
if j.wait==0 then
e.add(h,i,"crate",j.x/b,j.y/b,1,u,1)
end
end
for o,j in ipairs(f.money)do
if j.wait==0 then
e.add(h,i,"money",j.x/b,j.y/b,2,u,1)
end
end
for A,j in ipairs(f.hazards)do
local o=0
if j.air>0 then
local w=r.TUNING.glassAir-j.air
o=c(4*r.TUNING.glassPeak*w*j.air/(r.TUNING.glassAir*r.TUNING.glassAir))
end
e.add(h,i,"glass",j.x/b,j.y/b,o,1,2)
end
for o,j in ipairs(f.shots)do
if j.kind=="pipebomb"then
e.add(h,i,"pipebomb",j.x/b,j.y/b,2,u,2)
else
e.add(h,i,"bullet",j.x/b,j.y/b,3,1,2)
end
end
local o=f.helicopter
if o then
e.add(h,i,"helicopter",o.x/b,o.y/b,26,u,2)
if o.horde>0 then
local j=f.karts[o.target]
local w=c((o.horde-d.Items.TUNING.hordeTicks/2)/4)
e.add(h,i,"horde",j.x/b+w,j.y/b,0,c(q/8)%4+1,2)
end
end
if f.ghost and q%2==0 then
z(h,i,f,f.ghost.kart,2,false)
end
for A,w in ipairs(f.karts)do
local j=A==n.place
if not(j and w.invincible>0 and q%4<2)then
z(h,i,f,w,j and 4 or 3,j)
end
end
for w=#n.effects,1,-1 do
local j=n.effects[w]
j.age=j.age+1
local A=l[j.name].steps[1].frames
local E=math.min(A,c(j.age*A/a.effectTicks)+1)
e.add(h,i,j.name,j.x,j.y,j.lift,E,2)
if j.age>=a.effectTicks then
table.remove(n.effects,w)
end
end
local j=f.karts[n.place]
if j.drift~=0 and j.z==0 then
local w=c(j.heading/s)
local A=j.x/b-g.cos(w)*5/g.ONE
local E=j.y/b-g.sin(w)*5/g.ONE
local F=j.driftCharge>=d.Kart.TUNING.driftLevels[1]and"spark"or"puff"
e.add(h,i,F,A,E,0,c(q/3)%2+1,4)
end
return h
end

local function A(j,n,o)
local f=l.light_wide
local i=1
for h,q in ipairs(v.TIMING.lights)do
if o.phaseTick>=q then
i=h+1
end
end
local h=x.LAYOUT
local q=h.slotX+c(h.slotSize/2)-c(f.frame/2)
j:layers(n("light_wide"),(i-1)*f.frame,f.frame,f.h,q,h.slotY+h.slotSize,f.shades)
end

local function E(h,i,j)
local f=l.rain
local n=(j.clock*a.rainSpeed)%(f.h/2)
h:sheet(i("rain"),0,n,f.w,f.h/2,0,e.HORIZON-20,1,a.rainShade)
end

local function w(f,h)
return c(a.bannerWave*math.sin(2*math.pi*h/a.bannerWaveLength-f.clock*a.bannerWaveSpeed)+0.5)
end

local function F(i,h)
local G=i:textWidth(h.banner)
local f=G+2*a.bannerPad
local H=i:lineHeight()+2
local j=c((p-f)/2)
local n=a.bannerTicks-h.bannerTicks
local o=j
if n<a.bannerSlide then
local q=n/a.bannerSlide
o=c(-f+(j+f)*(1-(1-q)*(1-q)))
elseif n>a.bannerTicks-a.bannerSlide then
local q=(n-(a.bannerTicks-a.bannerSlide))/a.bannerSlide
o=c(j+(p-j)*q*q)
end
local q=m[d.INK]
for u=0,f-1,a.bannerStrip do
i:rect(o+u,a.bannerY+w(h,u),math.min(a.bannerStrip,f-u),H,q.r,q.g,q.b,1)
end
local u=m[d.PAPER]
i:text(h.banner,o+a.bannerPad,a.bannerY+1+w(h,c(f/2)),u.r,u.g,u.b,1)
end

local function G(h,H,I)
local i=l.placedigits.glyphs[tostring(I.rank)]
if not i then
return
end
local f,j=i[2],l.placedigits.h
local n,o=c((p-f)/2),40
local q=m[d.INK]
h:rect(n-4,o-4,f+8,j+8,q.r,q.g,q.b,1)
local u=m[d.PAPER]
h:rect(n-3,o-3,f+6,j+6,u.r,u.g,u.b,1)
h:sheet(H("placedigits"),i[1],0,f,j,n,o,1,d.INK)
end

function k.drawBare(f,h,j,i,o)
f.clock=f.clock+1
local n=C(f,i)
e.draw(h,i.track,n,j,l)
local q=D(f,i,n)
e.drawScene(h,q,j,SpiffBoyScreen.MAX_CALLS-h.calls-o)
if i.karts[f.place].slow>0 then
E(h,j,f)
end
end

function k.draw(f,i,j,h)
local u=h.karts[f.place]
local n=a.hudReserve
if f.bannerTicks>0 or h.phase=="intro"then
n=n+a.bannerReserve
end
k.drawBare(f,i,j,h,n)
if h.phase=="countdown"then
A(i,j,h)
end
if h.phase=="intro"then
local H=d.gameText("Track_"..h.track.id)
local o=m[d.INK]
i:rect(0,92,p,18,o.r,o.g,o.b,1)
local q=m[d.PAPER]
i:textCentre(H,p/2,93,q.r,q.g,q.b,1)
return
end
x.draw(i,j,h,u,f.clock)
if f.bannerTicks>0 then
f.bannerTicks=f.bannerTicks-1
F(i,f)
elseif f.placeShown and not h.battle then
G(i,j,u)
end
end
