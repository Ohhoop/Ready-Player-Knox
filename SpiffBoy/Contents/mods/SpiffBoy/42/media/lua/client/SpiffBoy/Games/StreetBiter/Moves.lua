require"SpiffBoy/Core/Core"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local a={}
SpiffBoy.StreetBiter.Moves=a

a.GUARD_MID="mid"
a.GUARD_LOW="low"
a.GUARD_OVERHEAD="overhead"
a.GUARD_NONE="none"

a.NORMALS={
jab={name="jab",frame="jabW",strike="jab",input="A",startup=3,active=3,recovery=7,near=-5,far=35,low=26,high=42,damage=5,hitstun=12,blockstun=8,push=4,guard="mid"},
straight={name="straight",frame="straightW",strike="straight",input="6A",startup=6,active=4,recovery=12,near=-2,far=40,low=26,high=44,damage=10,hitstun=18,blockstun=12,push=6,guard="mid"},
kick={name="kick",frame="kickW",strike="kick",input="B",startup=5,active=4,recovery=10,near=0,far=40,low=21,high=40,damage=7,hitstun=14,blockstun=10,push=5,guard="mid"},
highkick={name="highkick",frame="highkickW",strike="highkick",input="6B",startup=8,active=5,recovery=14,near=0,far=42,low=30,high=58,damage=12,hitstun=20,blockstun=14,push=8,guard="mid"},
cpunch={name="cpunch",frame="cpunchW",strike="cpunch",input="2A",startup=4,active=4,recovery=9,near=-2,far=28,low=12,high=54,damage=7,hitstun=14,blockstun=9,push=3,guard="mid",crouch=true},
ckick={name="ckick",frame="ckickW",strike="ckick",input="2B",startup=5,active=4,recovery=11,near=0,far=40,low=0,high=16,damage=8,hitstun=14,blockstun=10,push=4,guard="low",crouch=true},
sweep={name="sweep",frame="sweepW",strike="sweep",input="3B",startup=8,active=5,recovery=18,near=0,far=47,low=0,high=12,damage=11,hitstun=20,blockstun=14,push=6,guard="low",knockdown=true,crouch=true},
jkick={name="jkick",frame="jump",strike="jkick",input="8B",startup=4,active=10,recovery=2,near=0,far=35,low=-14,high=26,damage=10,hitstun=18,blockstun=12,push=4,guard="overhead",air=true},
}

a.SPECIALS={
wrenchToss={name="wrenchToss",frame="throwW",strike="throw",startup=10,active=2,recovery=16,guard="mid",projectile={kind="wrench",speed=3.5,damage=12,hitstun=16,blockstun=12,chip=2,push=6,height=33,guard="mid"}},
bullRush={name="bullRush",frame="chargeW",strike="charge",startup=8,active=16,recovery=14,dash=4,near=0,far=30,low=9,high=49,damage=16,hitstun=20,blockstun=16,chip=3,push=10,knockdown=true,guard="mid"},
flipKick={name="flipKick",frame="crouch",strike="rising",startup=4,active=10,recovery=22,rise=2.6,invulnerable=8,near=-5,far=28,low=0,high=66,damage=14,hitstun=20,blockstun=12,chip=3,push=6,knockdown=true,guard="mid"},
cartwheel={name="cartwheel",frame="jump",strike="jkick",startup=6,active=14,recovery=10,dash=4.5,hop=1.4,near=0,far=33,low=7,high=47,damage=9,hitstun=16,blockstun=12,chip=2,push=6,guard="overhead"},
forkLunge={name="forkLunge",frame="lungeW",strike="lunge",startup=9,active=6,recovery=18,near=12,far=63,low=23,high=40,damage=13,hitstun=20,blockstun=14,chip=2,push=12,guard="mid"},
hayBale={name="hayBale",frame="throwW",strike="throw",startup=14,active=2,recovery=20,guard="mid",projectile={kind="bale",speed=2,damage=10,hitstun=20,blockstun=14,chip=2,push=8,height=23,knockdown=true,guard="mid"}},
guitarSmash={name="guitarSmash",frame="raise",strike="smash",startup=14,active=5,recovery=16,near=0,far=40,low=19,high=58,damage=15,hitstun=22,blockstun=16,chip=3,push=8,knockdown=true,guard="overhead"},
powerSlide={name="powerSlide",frame="sweepW",strike="sweep",startup=6,active=14,recovery=12,dash=4.5,near=0,far=40,low=0,high=14,damage=10,hitstun=18,blockstun=14,chip=2,push=6,knockdown=true,guard="low"},
lungeBite={name="lungeBite",frame="chargeW",strike="charge",startup=10,active=10,recovery=16,dash=3,near=0,far=26,low=16,high=51,damage=14,hitstun=26,blockstun=0,chip=0,push=4,guard="none"},
rottenSpit={name="rottenSpit",frame="throwW",strike="throw",startup=8,active=2,recovery=14,guard="mid",projectile={kind="spit",speed=3,range=64,damage=8,hitstun=14,blockstun=10,chip=1,push=4,height=37,guard="mid"}},
hoseBlast={name="hoseBlast",frame="chargeW",strike="charge",startup=8,active=14,recovery=16,near=12,far=68,low=21,high=44,damage=9,hitstun=16,blockstun=12,chip=2,push=16,guard="mid",stream=true},
axeCleave={name="axeCleave",frame="raise",strike="smash",startup=16,active=5,recovery=18,near=0,far=40,low=12,high=61,damage=16,hitstun=24,blockstun=16,chip=3,push=8,knockdown=true,guard="overhead"},
syringeJab={name="syringeJab",frame="throwW",strike="throw",startup=4,active=4,recovery=10,near=5,far=44,low=26,high=40,damage=8,hitstun=22,blockstun=10,chip=1,push=3,guard="mid"},
defibShock={name="defibShock",frame="shockW",strike="shock",startup=10,active=6,recovery=20,near=0,far=33,low=9,high=54,damage=14,hitstun=40,blockstun=14,chip=3,push=6,guard="mid"},
batonCharge={name="batonCharge",frame="chargeW",strike="charge",startup=6,active=16,recovery=14,dash=3.5,armour=16,near=0,far=33,low=14,high=51,damage=15,hitstun=20,blockstun=16,chip=3,push=10,knockdown=true,guard="mid"},
groundStomp={name="groundStomp",frame="stompW",strike="stomp",startup=12,active=2,recovery=20,guard="mid",projectile={kind="wave",speed=2.5,damage=12,hitstun=20,blockstun=14,chip=2,push=8,height=0,knockdown=true,guard="low"}},
}

a.PROJECTILES={
wrench={cells={1,2},spin=6,half=7,tall=5},
bale={cells={3},spin=1,half=8,tall=6},
spit={cells={4,5},spin=8,half=4,tall=3},
wave={cells={8},spin=1,half=8,tall=6},
}

function a.length(b)
return b.startup+b.active+b.recovery
end

function a.isActive(b,c)
return c>b.startup and c<=b.startup+b.active
end

function a.normalFor(b,c,e)
if e then
return"jkick"
end
local d=b==6 or b==3 or b==9
local f=b==1 or b==2 or b==3
if f then
if c=="b"then
if b==3 then
return"sweep"
end
return"ckick"
end
return"cpunch"
end
if c=="a"then
return d and"straight"or"jab"
end
return d and"highkick"or"kick"
end
