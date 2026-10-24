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

local j={
{hero=0.75,heroBat=0.85,zombie=0.70,scared=0.45,tunnel=0.40},
{hero=0.85,heroBat=0.90,zombie=0.80,scared=0.50,tunnel=0.45},
{hero=0.90,heroBat=0.95,zombie=0.85,scared=0.55,tunnel=0.50},
}
local k={
{0,0,240,480},
{0,0,150,300},
{0,0,60,120},
}
local l={180,120,90}
local g=#SpiffBoy.SnackMan.Layouts
local m=0.03
local n=0.12
local o=0.02
local p=0.06
local q=7
local r=1
local s=60

local function t(level)
if level<=1 then
return 1
elseif level<=4 then
return 2
end
return 3
end

function a.level(level,horde,count)
local d=t(level)
local b=j[d]
local h=math.floor((level-1)/g)
local e=math.min(n,h*m)
local i=math.min(p,h*o)
local f={}
for c=1,count do
if horde then
f[c]=(c-1)*l[d]
else
f[c]=k[d][c]
end
end
local c=b.zombie+e
if horde then
c=c*a.HORDE_SPEED
end
return{
hero=b.hero+i,
heroBat=b.heroBat+i,
zombie=c,
scared=b.scared+e,
tunnel=b.tunnel+e,
batTicks=math.max(r,q-level)*s,
releases=f,
}
end

function a.kinds(level,horde)
if not horde then
return a.CLASSIC_KINDS
end
local b={}
local c=math.min(a.HORDE_MAX,a.HORDE_START+level-1)
for d=1,c do
b[d]=a.HORDE_KIND
end
return b
end

function a.mazeOf(level)
return(level-1)%g+1
end
