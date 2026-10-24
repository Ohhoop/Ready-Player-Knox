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
local j=d.Atlas
local e=d.Road
local z=d.Roster
local s=d.Race
local v=d.Hud
local o=d.Items

local i={}
d.View=i

local c=math.floor
local b=g.UNIT
local p=g.FINE
local k=d.SHADES
local m=d.WIDTH

i.TUNING={
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

local a=i.TUNING

function i.new(place)
return{place=place,angle=nil,effects={},banner=nil,bannerTicks=0,clock=0}
end

local function q(view,key)
view.banner=d.gameText(key)
view.bannerTicks=a.bannerTicks
end

local function w(view,name,x,y,lift)
view.effects[#view.effects+1]={name=name,x=x,y=y,lift=lift or 0,age=0}
end

function i.react(view,world,events)
for l,f in ipairs(events)do
if f.kart==view.place then
if f.kind=="quickstart"then
q(view,"QuickStartBanner")
elseif f.kind=="lap"and f.lap==s.TIMING.laps then
q(view,"FinalLap")
elseif f.kind=="finish"then
q(view,"Finish")
view.placeShown=true
elseif f.kind=="out"then
q(view,"Out")
end
end
if f.kind=="boom"then
w(view,"boom",c(f.x/b),c(f.y/b),2)
elseif f.kind=="splash"or f.kind=="spin"or f.kind=="horde"then
local h=world.karts[f.kart]
w(view,f.kind=="splash"and"splash"or"puff",c(h.x/b),c(h.y/b),2)
end
end
end

local function A(view,world)
local t=world.track
if world.phase=="intro"and not world.battle then
local h=t.waypoints
local l=#h
local n=c(world.phaseTick*l/s.TIMING.intro)%l+1
local f,r=h[n],h[(n+3)%l+1]
local u=c(g.atan2(r.y-f.y,r.x-f.x)/p)
return e.cameraBehind(f.x,f.y,u)
end
local f=world.karts[view.place]
local h=c(f.heading/p)
if not view.angle or world.phase~="race"and world.phase~="finish"then
view.angle=h
elseif f.spin==0 then
view.angle=g.wrap(view.angle+c(g.delta(view.angle,h)/a.cameraLag))
end
return e.cameraBehind(f.x/b,f.y/b,view.angle)
end

local function x(scene,camera,world,kart,priority,own)
if kart.respawn>0 then
return
end
local f,h=kart.x/b,kart.y/b
local n=c(kart.heading/p)
local r=e.frameOf(camera,f,h,n)
if own and kart.drift~=0 then
r=d.wrapIndex(r+kart.drift,8)
end
local l=kart.z/b
if l>0 then
e.add(scene,camera,"shadow",f,h,0,1,priority)
end
e.add(scene,camera,z.artOf(kart.driver),f,h,l,r,priority)
if kart.boost>0 then
local t=g.cos(n)*a.flameBack/g.ONE
local u=g.sin(n)*a.flameBack/g.ONE
e.add(scene,camera,"flame",f-t,h-u,l+a.flameLift,kart.boost%3+1,priority)
end
if world.battle and not kart.out then
e.add(scene,camera,"gascans",f,h,l+a.cansLift,kart.cans,priority)
end
end

local function B(view,world,camera)
local f=e.newScene()
local n=view.clock
e.addDecor(f,camera,world.track)
local r=c(n/6)%8+1
for l,h in ipairs(world.crates)do
if h.wait==0 then
e.add(f,camera,"crate",h.x/b,h.y/b,1,r,1)
end
end
for l,h in ipairs(world.money)do
if h.wait==0 then
e.add(f,camera,"money",h.x/b,h.y/b,2,r,1)
end
end
for u,h in ipairs(world.hazards)do
local l=0
if h.air>0 then
local t=o.TUNING.glassAir-h.air
l=c(4*o.TUNING.glassPeak*t*h.air/(o.TUNING.glassAir*o.TUNING.glassAir))
end
e.add(f,camera,"glass",h.x/b,h.y/b,l,1,2)
end
for l,h in ipairs(world.shots)do
if h.kind=="pipebomb"then
e.add(f,camera,"pipebomb",h.x/b,h.y/b,2,r,2)
else
e.add(f,camera,"bullet",h.x/b,h.y/b,3,1,2)
end
end
local l=world.helicopter
if l then
e.add(f,camera,"helicopter",l.x/b,l.y/b,26,r,2)
if l.horde>0 then
local h=world.karts[l.target]
local t=c((l.horde-d.Items.TUNING.hordeTicks/2)/4)
e.add(f,camera,"horde",h.x/b+t,h.y/b,0,c(n/8)%4+1,2)
end
end
if world.ghost and n%2==0 then
x(f,camera,world,world.ghost.kart,2,false)
end
for u,t in ipairs(world.karts)do
local h=u==view.place
if not(h and t.invincible>0 and n%4<2)then
x(f,camera,world,t,h and 4 or 3,h)
end
end
for t=#view.effects,1,-1 do
local h=view.effects[t]
h.age=h.age+1
local u=j[h.name].steps[1].frames
local y=math.min(u,c(h.age*u/a.effectTicks)+1)
e.add(f,camera,h.name,h.x,h.y,h.lift,y,2)
if h.age>=a.effectTicks then
table.remove(view.effects,t)
end
end
local h=world.karts[view.place]
if h.drift~=0 and h.z==0 then
local t=c(h.heading/p)
local u=h.x/b-g.cos(t)*5/g.ONE
local y=h.y/b-g.sin(t)*5/g.ONE
local C=h.driftCharge>=d.Kart.TUNING.driftLevels[1]and"spark"or"puff"
e.add(f,camera,C,u,y,0,c(n/3)%2+1,4)
end
return f
end

local function C(screen,art,world)
local f=j.light_wide
local l=1
for h,n in ipairs(s.TIMING.lights)do
if world.phaseTick>=n then
l=h+1
end
end
local h=v.LAYOUT
local n=h.slotX+c(h.slotSize/2)-c(f.frame/2)
screen:layers(art("light_wide"),(l-1)*f.frame,f.frame,f.h,n,h.slotY+h.slotSize,f.shades)
end

local function D(screen,art,view)
local f=j.rain
local h=(view.clock*a.rainSpeed)%(f.h/2)
screen:sheet(art("rain"),0,h,f.w,f.h/2,0,e.HORIZON-20,1,a.rainShade)
end

local function y(view,across)
return c(a.bannerWave*math.sin(2*math.pi*across/a.bannerWaveLength-view.clock*a.bannerWaveSpeed)+0.5)
end

local function E(screen,view)
local u=screen:textWidth(view.banner)
local f=u+2*a.bannerPad
local F=screen:lineHeight()+2
local h=c((m-f)/2)
local l=a.bannerTicks-view.bannerTicks
local n=h
if l<a.bannerSlide then
local r=l/a.bannerSlide
n=c(-f+(h+f)*(1-(1-r)*(1-r)))
elseif l>a.bannerTicks-a.bannerSlide then
local r=(l-(a.bannerTicks-a.bannerSlide))/a.bannerSlide
n=c(h+(m-h)*r*r)
end
local r=k[d.INK]
for t=0,f-1,a.bannerStrip do
screen:rect(n+t,a.bannerY+y(view,t),math.min(a.bannerStrip,f-t),F,r.r,r.g,r.b,1)
end
local t=k[d.PAPER]
screen:text(view.banner,n+a.bannerPad,a.bannerY+1+y(view,c(f/2)),t.r,t.g,t.b,1)
end

local function F(screen,art,kart)
local h=j.placedigits.glyphs[tostring(kart.rank)]
if not h then
return
end
local f,l=h[2],j.placedigits.h
local n,r=c((m-f)/2),40
local t=k[d.INK]
screen:rect(n-4,r-4,f+8,l+8,t.r,t.g,t.b,1)
local u=k[d.PAPER]
screen:rect(n-3,r-3,f+6,l+6,u.r,u.g,u.b,1)
screen:sheet(art("placedigits"),h[1],0,f,l,n,r,1,d.INK)
end

function i.drawBare(view,screen,art,world,reserve)
view.clock=view.clock+1
local f=A(view,world)
e.draw(screen,world.track,f,art,j)
local h=B(view,world,f)
e.drawScene(screen,h,art,SpiffBoyScreen.MAX_CALLS-screen.calls-reserve)
if world.karts[view.place].slow>0 then
D(screen,art,view)
end
end

function i.draw(view,screen,art,world)
local n=world.karts[view.place]
local f=a.hudReserve
if view.bannerTicks>0 or world.phase=="intro"then
f=f+a.bannerReserve
end
i.drawBare(view,screen,art,world,f)
if world.phase=="countdown"then
C(screen,art,world)
end
if world.phase=="intro"then
local r=d.gameText("Track_"..world.track.id)
local h=k[d.INK]
screen:rect(0,92,m,18,h.r,h.g,h.b,1)
local l=k[d.PAPER]
screen:textCentre(r,m/2,93,l.r,l.g,l.b,1)
return
end
v.draw(screen,art,world,n,view.clock)
if view.bannerTicks>0 then
view.bannerTicks=view.bannerTicks-1
E(screen,view)
elseif view.placeShown and not world.battle then
F(screen,art,n)
end
end
