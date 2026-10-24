require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Art"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Race"

local b=SpiffBoy.QuickStart
local d=b.Atlas
local p=b.Items
local j=b.Race
local i=b.Fixed

local c={}
b.Hud=c

local e=math.floor
local q=b.SHADES
local r=60

c.LAYOUT={
slotX=82,slotY=2,slotSize=18,
lapX=3,lapY=3,
timeX=177,timeY=3,
rankX=172,rankY=106,
moneyX=3,moneyY=112,
miniX=2,miniY=16,miniSize=32,
glyphGap=1,
}

local a=c.LAYOUT

local function f(screen,shade,x,y,w,h)
local g=q[shade]
screen:rect(x,y,w,h,g.r,g.g,g.b,1)
end

function c.width(text)
local l=d.font.glyphs
local g=0
for h=1,#text do
local k=l[string.sub(text,h,h)]
if k then
g=g+k[2]+a.glyphGap
end
end
return math.max(0,g-a.glyphGap)
end

function c.text(screen,art,text,x,y,shade)
local k=d.font.glyphs
local l=art("font")
for h=1,#text do
local g=k[string.sub(text,h,h)]
if g then
screen:sheet(l,g[1],0,g[2],d.font.h,x,y,1,shade)
x=x+g[2]+a.glyphGap
end
end
end

function c.label(screen,art,text,x,y)
local g=c.width(text)
f(screen,b.PAPER,x-1,y-1,g+2,d.font.h+2)
c.text(screen,art,text,x,y,b.INK)
end

function c.time(ticks)
local g=e(ticks*100/r)
local h=e(g/6000)
local k=e(g/100)%60
return string.format("%d'%02d\"%02d",h,k,g%100)
end

local function s(screen,art,kart,clock)
f(screen,b.INK,a.slotX,a.slotY,a.slotSize+2,a.slotSize+2)
f(screen,b.PAPER,a.slotX+1,a.slotY+1,a.slotSize,a.slotSize)
local g=kart.item
if not g then
return
end
if kart.roulette>0 then
g=e(clock/4)%#p.KEYS+1
end
local h=d.icons
screen:layers(art("icons"),(g-1)*16,16,h.h,a.slotX+2,a.slotY+2,h.shades)
if kart.roulette==0 and kart.itemCount>1 then
c.label(screen,art,"x"..kart.itemCount,a.slotX+a.slotSize+4,a.slotY+12)
end
end

local function t(screen,art,kart)
local g=d.bigdigits.glyphs[tostring(kart.rank)]
if not g then
return
end
f(screen,b.INK,a.rankX-g[2]-2,a.rankY-2,g[2]+4,d.bigdigits.h+4)
screen:sheet(art("bigdigits"),g[1],0,g[2],d.bigdigits.h,a.rankX-g[2],a.rankY,1,b.PAPER)
end

local function k(entry,kart)
local g=a.miniX+e((kart.x/i.UNIT-entry.x)*a.miniSize/entry.span)
local h=a.miniY+e((kart.y/i.UNIT-entry.y)*a.miniSize/entry.span)
return g,h
end

local function h(screen,entry,kart,size,shade)
local g,l=k(entry,kart)
f(screen,shade,g-e(size/2),l-e(size/2),size,size)
end

local function l(screen,art,entry,kart,name)
local g=d[name]
local m,n=k(entry,kart)
local o=b.mod(e((e(kart.heading/i.FINE)+i.TURN/16)/(i.TURN/8)),8)
screen:sheet(art(name),o*g.frame,0,g.frame,g.h,m-e(g.frame/2),n-e(g.h/2),1,b.INK)
end

local function m(screen,art,name)
local g=d[name]
f(screen,b.INK,a.miniX-1,a.miniY-1,a.miniSize+2,a.miniSize+2)
f(screen,b.PAPER,a.miniX,a.miniY,a.miniSize,a.miniSize)
screen:sheet(art(name),0,0,a.miniSize,a.miniSize,a.miniX,a.miniY,1,b.MID)
return g
end

local function u(screen,art,world,kart)
local n=m(screen,art,"minimap_"..world.track.id)
for o,g in ipairs(world.karts)do
if g~=kart and not g.out then
l(screen,art,n,g,"miniarrow")
end
end
l(screen,art,n,kart,"ownarrow")
end

local function v(screen,art,world,kart)
local n=world.track
local g=m(screen,art,"minimap_"..n.id..(n.mirrored and"_mirror"or""))
if world.ghost then
h(screen,g,world.ghost.kart,2,b.DARK)
end
for w,o in ipairs(world.karts)do
if o~=kart then
h(screen,g,o,2,b.INK)
end
end
h(screen,g,kart,4,b.INK)
h(screen,g,kart,2,b.PAPER)
end

function c.draw(screen,art,world,kart,clock)
s(screen,art,kart,clock)
if world.battle then
local o=math.max(0,j.TIMING.battleTicks-world.raceTick)
local n=c.time(o)
c.label(screen,art,n,a.timeX-c.width(n),a.timeY)
local g=0
for x,w in ipairs(world.karts)do
if not w.out then
g=g+1
end
end
c.label(screen,art,tostring(g).."/"..tostring(#world.karts),a.lapX,a.lapY)
u(screen,art,world,kart)
return
end
local g=tostring(j.lapOf(kart)).."/"..tostring(j.TIMING.laps)
f(screen,b.PAPER,a.lapX-1,a.lapY-1,9+c.width(g)+1,d.flag.h+2)
screen:sheet(art("flag"),0,0,d.flag.w,d.flag.h,a.lapX,a.lapY,1,b.INK)
c.text(screen,art,g,a.lapX+9,a.lapY+1,b.INK)
local w=kart.finished and kart.finishTick or world.raceTick
local n=c.time(w)
c.label(screen,art,n,a.timeX-c.width(n),a.timeY)
v(screen,art,world,kart)
if world.mode~=j.MODE_TT then
local o="x"..tostring(kart.coins)
f(screen,b.PAPER,a.moneyX-1,a.moneyY-1,9+c.width(o)+1,d.bill.h+2)
screen:sheet(art("bill"),0,0,d.bill.w,d.bill.h,a.moneyX,a.moneyY,1,b.DARK)
c.text(screen,art,o,a.moneyX+9,a.moneyY,b.INK)
t(screen,art,kart)
end
end
