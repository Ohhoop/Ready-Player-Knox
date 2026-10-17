require"SpiffBoy/Core/Core"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local a={}
SpiffBoy.StreetBiter.Roster=a

a.FRAMES={
"idle1","idle2","idle3","walk1","walk2","walk3","walk4","crouch","jump","block","cblock",
"jabW","jab","straightW","straight","kickW","kick","highkickW","highkick","cpunchW","cpunch","ckickW","ckick",
"sweepW","sweep","jkick","throwW","throw","chargeW","charge","rising","raise","smash","lungeW","lunge",
"stompW","stomp","shockW","shock","hit","fall","down","win",
}
a.SHEET_FRAMES=22
a.FRAME_INDEX={}
for b,c in ipairs(a.FRAMES)do
a.FRAME_INDEX[c]=b
end
a.SHEETS={}
for b=1,#a.FRAMES,a.SHEET_FRAMES do
a.SHEETS[#a.SHEETS+1]={first=b,count=math.min(a.SHEET_FRAMES,#a.FRAMES-b+1)}
end

function a.cellOf(e,f)
local d=a.FRAME_INDEX[e]
local b=math.floor((d-1)/a.SHEET_FRAMES)+1
local c=d-a.SHEETS[b].first
if f<0 then
c=c+a.SHEETS[b].count
end
return b,c
end

a.LIST={
{
id="rusty",name="RUSTY",stage="station",speed=0.9,health=108,
specials={
{text="WrenchToss",motion="qcf",button="a",move="wrenchToss"},
{text="BullRush",motion="qcf",button="b",move="bullRush"},
},
chain={"jab","jab","highkick"},
},
{
id="pep",name="PEP",stage="gym",speed=1.2,health=92,
specials={
{text="FlipKick",motion="dp",button="b",move="flipKick"},
{text="Cartwheel",motion="qcb",button="a",move="cartwheel"},
},
chain={"kick","kick","jkick"},
},
{
id="earl",name="EARL",stage="barn",speed=1.0,health=100,
specials={
{text="ForkLunge",motion="qcf",button="a",move="forkLunge"},
{text="HayBale",motion="qcf",button="b",move="hayBale"},
},
chain={"cpunch","jab","straight"},
},
{
id="riff",name="RIFF",stage="bar",speed=1.1,health=96,
specials={
{text="GuitarSmash",motion="qcf",button="b",move="guitarSmash"},
{text="PowerSlide",motion="qcb",button="a",move="powerSlide"},
},
chain={"jab","kick","ckick"},
},
{
id="rot",name="ROT",stage="cemetery",speed=0.8,health=120,
specials={
{text="LungeBite",motion="qcf",button="a",move="lungeBite"},
{text="RottenSpit",motion="qcb",button="b",move="rottenSpit"},
},
chain={"jab","jab","jab"},
},
{
id="blaze",name="BLAZE",stage="firehouse",speed=0.95,health=104,
specials={
{text="HoseBlast",motion="qcf",button="a",move="hoseBlast"},
{text="AxeCleave",motion="qcf",button="b",move="axeCleave"},
},
chain={"kick","highkick"},
},
{
id="may",name="MAY",stage="hospital",speed=1.1,health=94,
specials={
{text="SyringeJab",motion="qcf",button="a",move="syringeJab"},
{text="DefibShock",motion="qcb",button="b",move="defibShock"},
},
chain={"jab","jab","ckick"},
},
{
id="warden",name="WARDEN",stage="prison",speed=0.9,health=112,
specials={
{text="BatonCharge",motion="qcf",button="a",move="batonCharge"},
{text="GroundStomp",motion="qcf",button="b",move="groundStomp"},
},
chain={"kick","kick","highkick"},
},
}

a.COUNT=#a.LIST
a.BOSS=a.COUNT

a.BY_ID={}
for c,b in ipairs(a.LIST)do
b.index=c
a.BY_ID[b.id]=b
end

a.STANDARD_CHAINS={{"jab","jab"},{"jab","kick"},{"ckick","sweep"}}
a.STANDARD_MOVES={
{text="Punch",move="jab"},{text="HeavyPunch",move="straight"},{text="Kick",move="kick"},{text="HighKick",move="highkick"},
{text="LowPunch",move="cpunch"},{text="LowKick",move="ckick"},{text="Sweep",move="sweep"},
}
a.STANDARD_EXTRAS={{text="JumpKick",move="jkick"},{text="Guard",input="4"},{text="LowGuard",input="1"}}

a.MOTIONS={
qcf={label={2,3,6},pattern={{2},{6}}},
qcb={label={2,1,4},pattern={{2},{4}}},
dp={label={6,2,3},pattern={{6},{2},{3,6}}},
}

function a.ladder(d)
local b={}
for c,e in ipairs(a.LIST)do
if c~=d and c~=a.BOSS then
b[#b+1]=c
end
end
if d~=a.BOSS then
b[#b+1]=a.BOSS
end
return b
end
