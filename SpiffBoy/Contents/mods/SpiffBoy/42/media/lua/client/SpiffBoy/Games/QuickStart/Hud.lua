require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Art"
require"SpiffBoy/Games/QuickStart/Items"
require"SpiffBoy/Games/QuickStart/Race"

local b=SpiffBoy.QuickStart
local d=b.Atlas
local t=b.Items
local l=b.Race
local k=b.Fixed

local c={}
b.Hud=c

local f=math.floor
local u=b.SHADES
local v=60

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

local function h(g,i,j,m,n,o)
local e=u[i]
g:rect(j,m,n,o,e.r,e.g,e.b,1)
end

function c.width(g)
local m=d.font.glyphs
local e=0
for i=1,#g do
local j=m[string.sub(g,i,i)]
if j then
e=e+j[2]+a.glyphGap
end
end
return math.max(0,e-a.glyphGap)
end

function c.text(m,n,i,g,o,p)
local q=d.font.glyphs
local r=n("font")
for j=1,#i do
local e=q[string.sub(i,j,j)]
if e then
m:sheet(r,e[1],0,e[2],d.font.h,g,o,1,p)
g=g+e[2]+a.glyphGap
end
end
end

function c.label(e,m,g,i,j)
local n=c.width(g)
h(e,b.PAPER,i-1,j-1,n+2,d.font.h+2)
c.text(e,m,g,i,j,b.INK)
end

function c.time(g)
local e=f(g*100/v)
local i=f(e/6000)
local j=f(e/100)%60
return string.format("%d'%02d\"%02d",i,j,e%100)
end

local function w(g,j,e,n)
h(g,b.INK,a.slotX,a.slotY,a.slotSize+2,a.slotSize+2)
h(g,b.PAPER,a.slotX+1,a.slotY+1,a.slotSize,a.slotSize)
local i=e.item
if not i then
return
end
if e.roulette>0 then
i=f(n/4)%#t.KEYS+1
end
local m=d.icons
g:layers(j("icons"),(i-1)*16,16,m.h,a.slotX+2,a.slotY+2,m.shades)
if e.roulette==0 and e.itemCount>1 then
c.label(g,j,"x"..e.itemCount,a.slotX+a.slotSize+4,a.slotY+12)
end
end

local function x(g,i,j)
local e=d.bigdigits.glyphs[tostring(j.rank)]
if not e then
return
end
h(g,b.INK,a.rankX-e[2]-2,a.rankY-2,e[2]+4,d.bigdigits.h+4)
g:sheet(i("bigdigits"),e[1],0,e[2],d.bigdigits.h,a.rankX-e[2],a.rankY,1,b.PAPER)
end

local function o(e,g)
local i=a.miniX+f((g.x/k.UNIT-e.x)*a.miniSize/e.span)
local j=a.miniY+f((g.y/k.UNIT-e.y)*a.miniSize/e.span)
return i,j
end

local function m(g,i,j,e,n)
local p,q=o(i,j)
h(g,n,p-f(e/2),q-f(e/2),e,e)
end

local function p(j,n,q,g,i)
local e=d[i]
local r,s=o(q,g)
local y=b.mod(f((f(g.heading/k.FINE)+k.TURN/16)/(k.TURN/8)),8)
j:sheet(n(i),y*e.frame,0,e.frame,e.h,r-f(e.frame/2),s-f(e.h/2),1,b.INK)
end

local function q(e,i,g)
local j=d[g]
h(e,b.INK,a.miniX-1,a.miniY-1,a.miniSize+2,a.miniSize+2)
h(e,b.PAPER,a.miniX,a.miniY,a.miniSize,a.miniSize)
e:sheet(i(g),0,0,a.miniSize,a.miniSize,a.miniX,a.miniY,1,b.MID)
return j
end

local function y(e,g,j,n)
local r=q(e,g,"minimap_"..j.track.id)
for s,i in ipairs(j.karts)do
if i~=n and not i.out then
p(e,g,r,i,"miniarrow")
end
end
p(e,g,r,n,"ownarrow")
end

local function z(e,s,g,j)
local n=g.track
local i=q(e,s,"minimap_"..n.id..(n.mirrored and"_mirror"or""))
if g.ghost then
m(e,i,g.ghost.kart,2,b.DARK)
end
for A,r in ipairs(g.karts)do
if r~=j then
m(e,i,r,2,b.INK)
end
end
m(e,i,j,4,b.INK)
m(e,i,j,2,b.PAPER)
end

function c.draw(e,g,i,j,A)
w(e,g,j,A)
if i.battle then
local s=math.max(0,l.TIMING.battleTicks-i.raceTick)
local r=c.time(s)
c.label(e,g,r,a.timeX-c.width(r),a.timeY)
local n=0
for C,B in ipairs(i.karts)do
if not B.out then
n=n+1
end
end
c.label(e,g,tostring(n).."/"..tostring(#i.karts),a.lapX,a.lapY)
y(e,g,i,j)
return
end
local n=tostring(l.lapOf(j)).."/"..tostring(l.TIMING.laps)
h(e,b.PAPER,a.lapX-1,a.lapY-1,9+c.width(n)+1,d.flag.h+2)
e:sheet(g("flag"),0,0,d.flag.w,d.flag.h,a.lapX,a.lapY,1,b.INK)
c.text(e,g,n,a.lapX+9,a.lapY+1,b.INK)
local B=j.finished and j.finishTick or i.raceTick
local r=c.time(B)
c.label(e,g,r,a.timeX-c.width(r),a.timeY)
z(e,g,i,j)
if i.mode~=l.MODE_TT then
local s="x"..tostring(j.coins)
h(e,b.PAPER,a.moneyX-1,a.moneyY-1,9+c.width(s)+1,d.bill.h+2)
e:sheet(g("bill"),0,0,d.bill.w,d.bill.h,a.moneyX,a.moneyY,1,b.DARK)
c.text(e,g,s,a.moneyX+9,a.moneyY,b.INK)
x(e,g,j)
end
end
