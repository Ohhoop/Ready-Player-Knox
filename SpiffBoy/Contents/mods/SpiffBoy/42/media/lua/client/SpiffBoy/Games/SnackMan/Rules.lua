require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Layouts"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a={}
SpiffBoy.SnackMan.Rules=a

a.MODES={
{key="c",text="Classic",horde=false},
{key="h",text="Horde",horde=true},
}
a.CLASSIC_KINDS={"runner","cop","woman","shambler"}
a.ROLES={
runner={wander=0,speed=1},
cop={wander=0,speed=1},
woman={wander=0.5,speed=1},
shambler={wander=0.75,speed=0.8},
}
a.HORDE_KIND="shambler"
a.HORDE_START=3
a.HORDE_MAX=8
a.HORDE_SPEED=0.9
a.HORDE_WANDER=0.25
a.LIVES=3
a.EXTRA_LIFE=10000
a.CHIP_POINTS=10
a.BAT_POINTS=50
a.ZOMBIE_POINTS=200
a.FOOD_POINTS={100,300,500,700,1000,2000}
a.FOOD_AT={0.35,0.75}
a.FOOD_TICKS=570
a.EYES_SPEED=1.5
a.PEN_SPEED=0.5
a.ELROY_LEFT=20
a.ELROY_BONUS=0.05
a.FLASH_TICKS=120
a.AHEAD=4
a.FLANK=2
a.SCHEDULE={420,1200,420,1200,300,1200,300}

local l={
{hero=0.75,heroBat=0.85,zombie=0.70,scared=0.45,tunnel=0.40},
{hero=0.85,heroBat=0.90,zombie=0.80,scared=0.50,tunnel=0.45},
{hero=0.90,heroBat=0.95,zombie=0.85,scared=0.55,tunnel=0.50},
}
local m={
{0,0,240,480},
{0,0,150,300},
{0,0,60,120},
}
local n={180,120,90}
local h=#SpiffBoy.SnackMan.Layouts
local o=0.03
local p=0.12
local q=0.02
local r=0.06
local s=7
local t=1
local u=60

local function v(b)
if b<=1 then
return 1
elseif b<=4 then
return 2
end
return 3
end

function a.level(d,i,w)
local e=v(d)
local b=l[e]
local j=math.floor((d-1)/h)
local f=math.min(p,j*o)
local k=math.min(r,j*q)
local g={}
for c=1,w do
if i then
g[c]=(c-1)*n[e]
else
g[c]=m[e][c]
end
end
local c=b.zombie+f
if i then
c=c*a.HORDE_SPEED
end
return{
hero=b.hero+k,
heroBat=b.heroBat+k,
zombie=c,
scared=b.scared+f,
tunnel=b.tunnel+f,
batTicks=math.max(t,s-d)*u,
releases=g,
}
end

function a.kinds(c,d)
if not d then
return a.CLASSIC_KINDS
end
local b={}
local e=math.min(a.HORDE_MAX,a.HORDE_START+c-1)
for f=1,e do
b[f]=a.HORDE_KIND
end
return b
end

function a.mazeOf(b)
return(b-1)%h+1
end
