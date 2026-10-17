require"SpiffBoy/Core/Core"

SpiffBoy.PipeBomber=SpiffBoy.PipeBomber or{}

local a={}
SpiffBoy.PipeBomber.Zones=a

a.TILE=12
a.LEVELS=4
a.PASSWORD_LENGTH=4

a.DIFFICULTIES={
{key="e",text="Easy",lives=5,seconds=240,extra=-1,pace=0.9},
{key="n",text="Normal",lives=3,seconds=180,extra=0,pace=1},
{key="h",text="Hard",lives=3,seconds=150,extra=1,pace=1.1},
}

a.LIST={
{key="rosewood",name="Zone1",columns=15,rows=9,crates=0.36,kinds={"shambler"},boss="inmate"},
{key="muldraugh",name="Zone2",columns=15,rows=9,crates=0.40,kinds={"shambler","runner"},boss="worker",password="QZTB"},
{key="marchridge",name="Zone3",columns=21,rows=11,crates=0.40,kinds={"shambler","runner","cop"},boss="neighbour",password="MPKR"},
{key="westpoint",name="Zone4",columns=21,rows=11,crates=0.42,kinds={"shambler","runner","cop","brute"},boss="coach",password="DWSN"},
{key="riverside",name="Zone5",columns=21,rows=11,crates=0.42,kinds={"runner","cop","shambler","brute"},boss="golfer",password="GFHX"},
{key="ekron",name="Zone6",columns=25,rows=13,crates=0.44,kinds={"cop","brute","runner","shambler"},boss="farmer",password="TLBC"},
{key="base",name="Zone7",columns=25,rows=13,crates=0.44,kinds={"brute","cop","runner","cop"},boss="soldier",password="VNRJ"},
{key="louisville",name="Zone8",columns=25,rows=13,crates=0.46,kinds={"runner","brute","cop","runner"},boss="mother",password="XKPZ"},
}

a.BOSS_CRATES=0.14
a.BASE_ZOMBIES=3
a.BOSS_MINIONS={0,0,1,1,2,2,2,3}
a.PERMANENT={"range","count","speed"}
a.TEMPORARY={"detonator","kick","pass","vest"}
a.SPECIAL={"aerosol","molotov"}

function a.zombieCount(b,c,d)
return math.max(2,a.BASE_ZOMBIES+math.floor(b/2)+c-1+d.extra)
end

function a.zombieKinds(b,e)
local c={}
for d=1,e do
c[d]=b.kinds[(d-1)%#b.kinds+1]
end
return c
end

function a.levelBonuses(d,b)
local c={
a.PERMANENT[b:int(1,#a.PERMANENT)],
a.PERMANENT[b:int(1,#a.PERMANENT)],
a.TEMPORARY[b:int(1,#a.TEMPORARY)],
}
if d>=2 then
c[#c+1]=a.SPECIAL[b:int(1,#a.SPECIAL)]
end
return c
end

function a.zoneOfPassword(c)
for b=2,#a.LIST do
if a.LIST[b].password==c then
return b
end
end
return nil
end

function a.layoutSeed(b,c)
return 7919*b+104729*c+1
end
