require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/Rows"
require"SpiffBoy/Games/Lanterways/Maps/MurkSea"
require"SpiffBoy/Games/Lanterways/Music"

local c=SpiffBoy.Lanterways
local f=c.Maps
local i=c.MapRows
local j=c.Music
local e=c.MurkSea.sites

local function a(name,fields)
local b=e[name]
if not b then
error("Lanterways: no place named "..name.." on the Murk Sea")
end
local d=fields or{}
d.x,d.y=b.x,b.y
return d
end

local function b(name,to,tx,ty,dir,when)
return a(name,{to=to,tx=tx,ty=ty,dir=dir,when=when})
end

local function d(name,region)
local g=e[name]
return{kind="watchlight",x=g.x,y=g.y,w=2,h=3,door=1,to="watch"..region,tx=5,ty=14,dir="up",region=region,flag="w_"..region}
end

f.murksea={
rows=i.murksea,
place="murksea",
banner="murksea",
music=j.ROAD,
back="fog",
fog=true,
chunk={w=25,h=18},
objects={
d("riveWatch","rive"),
d("eastWatch","east"),
d("coastWatch","coast"),
d("tideWatch","tide"),
d("spireWatch","spire"),
},
lamps={
a("landingLamp",{flag="l_landing"}),
a("spurLamp1",{flag="l_spur1"}),
a("spurLamp2",{flag="l_spur2"}),
a("spurLamp3",{flag="l_spur3",when={min=3,flags={"l_spur1","l_spur2"}},lockedText="LampSpurLocked",script="spur_last"}),
a("lampSpurnorth",{flag="l_spurnorth"}),
a("lampSpursouth",{flag="l_spursouth"}),
a("lampKnoll",{flag="l_knoll"}),
a("lampCairn",{flag="l_cairn"}),
a("stairLamp",{flag="l_stair"}),
a("lampMossbank",{flag="l_mossbank"}),
a("lampRivehill",{flag="l_rivehill"}),
a("lampLowmarsh",{flag="l_lowmarsh"}),
a("lampHollowrest",{flag="l_hollowrest"}),
a("lampReedbed",{flag="l_reedbed"}),
a("lampFrostcap",{flag="l_frostcap"}),
a("lampHornet",{flag="l_hornet"}),
a("lampLanternrock",{flag="l_lanternrock"}),
a("lampGullnest",{flag="l_gullnest"}),
a("lampSaltflat",{flag="l_saltflat"}),
a("lampFoam",{flag="l_foam"}),
a("lampShoalend",{flag="l_shoalend"}),
a("lampEelrock",{flag="l_eelrock"}),
a("lampCinder",{flag="l_cinder"}),
a("lampEmbercap",{flag="l_embercap"}),
a("eastLandingLamp",{flag="l_eastlanding"}),
a("lampOrchard",{flag="l_orchard"}),
a("eastsideLamp",{flag="l_eastside"}),
a("reachLamp",{flag="l_farrow"}),
a("lampNutshell",{flag="l_nutshell"}),
a("rocksLamp",{flag="l_rocks"}),
a("lampHarbour",{flag="l_harbour"}),
a("lampWreck",{flag="l_wreck"}),
a("lampFarshoal",{flag="l_farshoal"}),
a("tideLamp1",{flag="l_tide1"}),
a("tideLamp2",{flag="l_tide2"}),
a("tideLamp3",{flag="l_tide3"}),
a("tideLamp4",{flag="l_tide4"}),
a("lampCapital",{flag="l_capital"}),
a("lampAshpoint",{flag="l_ashpoint"}),
a("spireLamp1",{flag="l_spire1"}),
a("spireLamp2",{flag="l_spire2"}),
},
chests={
a("spurChest",{flag="c_spur1",item="bun",count=2}),
a("eastsideChest1",{flag="c_east1",item="salts",count=1}),
a("eastsideChest2",{flag="c_east2",gold=80}),
a("chestEast3",{flag="c_east3",item="glimmerflask",count=2}),
a("southChest1",{flag="c_south1",item="wickoil",count=1}),
a("southChest2",{flag="c_south2",gold=150}),
a("southChest3",{flag="c_south3",item="quickstep",count=2}),
a("tideChest1",{flag="c_tide1",item="lullabybox",count=2}),
a("tideChest2",{flag="c_tide2",item="stew",count=2}),
a("spireChest",{flag="c_spireway1",item="pressedfeast",count=1}),
a("uniqueWick",{flag="c_u1",item="firstwick"}),
a("uniqueLadle",{flag="c_u2",item="drownedladle"}),
a("uniqueLissLantern",{flag="c_u3",item="lisslantern"}),
a("uniqueFerryApron",{flag="c_u4",item="ferryapron"}),
a("unique5",{flag="c_u5",item="olddividers"}),
a("unique6",{flag="c_u6",item="farrowbrooch"}),
a("unique7",{flag="c_u7",item="watchbell"}),
a("unique8",{flag="c_u8",item="nightlantern"}),
a("unique9",{flag="c_u9",item="mapmakercoat"}),
a("unique10",{flag="c_u10",item="ferryshard"}),
a("unique11",{flag="c_u11",item="shorenet"}),
a("unique12",{flag="c_u12",item="ferryoar"}),
},
notes={
a("pageBook3",{page="book3"}),
a("pageBook4",{page="book4"}),
a("pageBook7",{page="book7"}),
a("pageBook10",{page="book10"}),
a("pageBook12",{page="book12"}),
a("pageBook13",{page="book13"}),
a("pageBook17",{page="book17"}),
a("pageBook22",{page="book22"}),
},
echoes={
a("echoFirstFlame",{echo="firstflame"}),
a("echoDrownedVillage",{echo="drownedvillage"}),
a("echoLissLeaves",{echo="lissleaves"}),
a("echoTwoFriends",{echo="twofriends"}),
a("echoFirstSnuff",{echo="firstsnuff"}),
a("echoOneBell",{echo="onebell"}),
a("echoBraskLeaves",{echo="braskleaves"}),
a("echoTheVote",{echo="thevote"}),
a("echoSoftVoice",{echo="softvoice"}),
a("echoLastFerry",{echo="lastferry"}),
},
npcs={
a("snufferSpawn",{id="snuffer",sprite="snuffer",dir="left",show={max=2}}),
a("ferryman",{id="ferryman",sprite="elder",dir="down",show={notFlag="q_ferry"},talk="quest_ferryman"}),
a("ferryDock",{id="ferrydock",sprite="elder",dir="down",show={flag="q_ferry"},talk="quest_ferry_ride"}),
a("farshoalLanding",{id="ferryback",sprite="elder",dir="down",show={flag="q_ferry"},talk="quest_ferry_back"}),
a("wispChild",{id="wispchild",sprite="kid",dir="down",show={notFlag="q_wisp1"},talk="quest_wisp"}),
a("courier",{id="courier",sprite="woman",dir="down",show={notFlag="q_courier"},talk="quest_courier"}),
a("deserter",{id="deserter",sprite="snuffer",dir="down",show={min=8,notFlag="q_deserter1"},talk="quest_deserter"}),
a("cartographer",{id="cartographer",sprite="woman",dir="down",show={min=9},talk="quest_cartographer"}),
a("merchantStuck",{id="merchant",sprite="grocer",dir="down",show={min=9,notFlag="q_merchant"},talk="quest_merchant"}),
a("merchantShop",{id="merchantshop",sprite="grocer",dir="down",show={flag="q_merchant"},talk="shop_murksea"}),
},
events={
a("snufferZone",{when={min=2,max=2},script="spur_snuffer"}),
a("riveCard",{when={min=4,notFlag="ch2"},script="chapter2"}),
a("coastCard",{when={min=7,notFlag="ch3"},script="chapter3"}),
{x=e.murkmaw.x-6,y=e.murkmaw.y-6,w=13,h=13,when={min=9,max=9},script="murkmaw_fight"},
a("chartCoin",{when={member="ottilie",notFlag="c_tide3"},script="chart_coin"}),
a("spireCard",{when={min=19,notFlag="ch8"},script="chapter8"}),
a("sunkenGate",{when={max=16},script="sealed_sunken"}),
a("surveyGate",{when={max=16},script="sealed_survey"}),
a("farrowGate",{when={max=16},script="sealed_farrow"}),
},
encounters={
zones={
start={rate=120,when={min=3},troops={{"mistmite"},{"mistmite","mistmite"},{"sootcrow"}},rares={{"gildedmite"}}},
rive={rate=120,troops={{"mistmite","mistmite"},{"sootcrow"},{"mistmite","sootcrow"},{"fogfin"}},rares={{"gildedmite"}}},
east={rate=120,troops={
{"mistmite","mistmite"},{"sootcrow"},{"fogfin","mistmite"},{"wickmoth","sootcrow"},{"fogfin","fogfin"},{"mistmite","sootcrow","mistmite"},
},late={when={min=17},troops={
{"palehound"},{"palehound","fogfin"},{"driftmaw"},{"lanterneel","sootcrow"},
}},rares={{"gildedmite"}}},
coast={rate=112,troops={
{"fenhopper","fenhopper"},{"briarhog"},{"driftjelly","fenhopper"},{"sootcrow","sootcrow","fenhopper"},{"briarhog","driftjelly"},
},late={when={min=17},troops={
{"palehound","fenhopper"},{"driftmaw","driftjelly"},{"gullwraith","palehound"},
}},rares={{"gildedmite"}}},
tide={rate=96,troops={
{"gullwraith","gullwraith"},{"tidecrab"},{"shoal","driftjelly"},{"gullwraith","shoal"},{"tidecrab","driftjelly","gullwraith"},
},late={when={min=17},troops={
{"driftmaw","shoal"},{"lanterneel","gullwraith"},{"palehound","palehound"},
}},rares={{"gildedmite"},{"lostwarden"}}},
spire={rate=112,when={min=19},troops={
{"kindledguard","kindledguard"},{"glarewisp","ashhound"},{"lampgolem"},{"ashhound","ashhound"},{"kindledguard","glarewisp","glarewisp"},
},rares={{"gildedmite"},{"lostwarden"}}},
},
},
warps={
b("tallowbyNorthGate","tallowby",34,8,"left"),
b("tallowbySouthGate","tallowby",34,19,"left"),
b("wickWestGate","wickhollow",1,14,"right"),
b("wickSouthGate","wickhollow",20,25,"up"),
b("brassWestGate","brassmouth",1,20,"right"),
b("brassEastGate","brassmouth",42,12,"left"),
b("capitalWestGate","glimmerhold",1,17,"right"),
b("capitalEastGate","glimmerhold",42,17,"left"),
b("farrowGate","farrow",1,10,"right",{min=17}),
b("sunkenGate","sunkenroad",1,7,"right",{min=17}),
b("surveyGate","drownedsurvey",14,1,"down",{min=17}),
b("spireGate","spire",17,38,"up"),
},
}

for k,g in ipairs(c.MurkSea.extraLamps)do
local h=f.murksea.lamps
h[#h+1]=a(g.site,{flag=g.flag})
end
