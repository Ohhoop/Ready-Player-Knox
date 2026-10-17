require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Characters"

local e=SpiffBoy.Lanterways

local b={}
e.Enemies=b

b.SIZES={s={24,24},m={32,32},l={48,44},b={64,56}}
b.LEVEL_CAP=99
b.BOSS_GOLD=20

b.LIST={
mistmite={level=1,size="s",beast=true,acts={{"attack",3}},weak="flame",drop={"misthusk",0.5},rare={"candlestub",0.05}},
sootcrow={level=2,size="s",beast=true,spd=1.4,def=0.7,acts={{"attack",3},{"peck",2}},weak="sound",drop={"gullfeather",0.4},rare={"clearlens",0.04}},
fogfin={level=2,size="s",beast=true,hp=1.2,acts={{"attack",3},{"bite",1}},weak="flame",resist="murk",drop={"fogpearl",0.4}},
wickmoth={level=3,size="s",beast=true,hp=0.8,spd=1.3,acts={{"attack",2},{"snuff",2}},weak="flame",drop={"wickoil",0.12}},
rootcrawler={level=4,size="m",beast=true,hp=1.4,def=1.3,spd=0.7,acts={{"attack",3},{"crush",1}},weak="flame",drop={"misthusk",0.6}},
wicklouse={level=4,size="s",beast=true,hp=0.8,spd=1.2,acts={{"attack",2},{"sting",2}},drop={"charcoal",0.25}},
grubswarm={level=5,size="m",beast=true,hp=1.1,acts={{"attack",2},{"spore",1}},weak="flame",resist="phys",drop={"misthusk",0.6}},
snuffer={level=5,size="m",acts={{"attack",3},{"snuff",1},{"mist",1}},drop={"pepperpouch",0.3}},
gorse={level=5,size="l",boss=6,atk=1.15,acts={{"attack",3},{"crush",2},{"roar",1,{unless="atkDown",foe=true}}},drop={"farmermitts",1},parts={{kind="arm",x=43,y=22}}},
fenhopper={level=6,size="s",beast=true,spd=1.3,acts={{"attack",3},{"bite",1}},weak="sound",drop={"misthusk",0.5}},
briarhog={level=7,size="m",beast=true,hp=1.4,atk=1.15,acts={{"attack",2},{"crush",1}},drop={"briarham",0.4}},
driftjelly={level=7,size="s",beast=true,def=0.6,res=1.5,acts={{"sting",3},{"soak",1}},weak="flame",resist="murk",drop={"fogpearl",0.5}},
gullwraith={level=8,size="m",beast=true,spd=1.3,acts={{"attack",2},{"peck",2},{"mist",1}},weak="sound",drop={"gullfeather",0.6}},
tidecrab={level=8,size="m",beast=true,def=1.8,hp=1.2,spd=0.7,acts={{"attack",2},{"harden",1,{unless="defUp"}},{"crush",1},{"mend",2,{below=0.4}}},weak="sound",drop={"crabshell",0.5},rare={"irontonic",0.1}},
shoal={level=9,size="m",beast=true,hp=1.2,acts={{"attack",2},{"soak",2}},weak="flame",resist="murk",drop={"fogpearl",0.7}},
murkmaw={level=9,size="b",boss=8,acts={{"attack",2},{"soak",2},{"bite",2},{"tidepull",1}},acts2={{"attack",2},{"bite",2},{"tidepull",3}},weak="flame",resist="murk",drop={"murkpearl",1},parts={{kind="eye",x=19,y=18},{kind="jaw",x=47,y=42}}},
lampwright={level=10,size="m",def=1.5,res=0.7,acts={{"attack",2},{"cinder",2}},weak="sound",resist="flame",drop={"wickoil",0.2}},
sootwraith={level=11,size="m",beast=true,def=0.6,res=1.4,acts={{"attack",1},{"smother",1},{"mist",1}},weak="flame",resist="phys",drop={"charcoal",0.3}},
vaultrat={level=10,size="s",spd=1.4,hp=0.8,acts={{"attack",3},{"sting",1}},drop={"bun",0.4}},
cinderimp={level=11,size="s",mag=1.4,acts={{"attack",1},{"cinder",2}},resist="flame",weak="murk",drop={"glimmerflask",0.25}},
vaultwarden={level=12,size="b",boss=8,def=1.3,acts={{"attack",2},{"slam",2},{"cinderstorm",1},{"harden",1,{unless="defUp"}}},acts2={{"attack",2},{"slam",2},{"cinderstorm",2}},weak="sound",resist="flame",drop={"vaultseal",1},parts={{kind="eye",x=34,y=12},{kind="arm",x=57,y=34}}},
scaldling={level=12,size="s",beast=true,acts={{"attack",2},{"cinder",1}},weak="murk",drop={"wickoil",0.3}},
palehound={level=13,size="m",beast=true,spd=1.3,atk=1.1,acts={{"attack",3},{"bite",2}},weak="flame",drop={"palefur",0.6},rare={"quickstep",0.1}},
driftmaw={level=14,size="m",beast=true,hp=1.3,acts={{"attack",2},{"smother",1},{"stillwave",1}},resist="murk",weak="sound",drop={"fogpearl",1}},
lanterneel={level=14,size="m",beast=true,mag=1.3,acts={{"attack",1},{"glare",2}},weak="murk",resist="flame",drop={"wickoil",0.3},rare={"pocketsun",0.04}},
stilledmass={level=15,size="b",boss=9,acts={{"attack",2},{"smother",2},{"stillwave",1},{"slam",2}},acts2={{"smother",2},{"stillwave",2},{"slam",2}},weak="sound",drop={"mothwing",1},parts={{kind="arm",x=8,y=38}}},
snufferveteran={level=15,size="m",acts={{"attack",3},{"snuff",1},{"oldsnuff",1}},drop={"salts",0.3},rare={"luckypenny",0.05}},
hesk={level=16,size="l",boss=8,spd=1.2,acts={{"attack",2},{"oldsnuff",1},{"mist",1},{"crush",2}},drop={"oldwick",1},parts={{kind="arm",x=41,y=18}}},
belfrybat={level=16,size="s",beast=true,spd=1.5,hp=0.8,acts={{"attack",2},{"peck",2},{"clang",1}},weak="flame",drop={"gullfeather",0.5}},
rustrat={level=16,size="s",acts={{"attack",2},{"sting",2}},weak="flame",drop={"rustdust",0.3}},
clapperimp={level=17,size="m",acts={{"attack",1},{"clang",2}},resist="sound",weak="murk",drop={"belltonic",0.25}},
verdigris={level=18,size="b",boss=9,acts={{"attack",2},{"clang",2},{"bite",2},{"roar",1,{unless="atkDown",foe=true}}},acts2={{"attack",2},{"clang",3},{"bite",2}},resist="sound",weak="flame",drop={"greenclapper",1},parts={{kind="jaw",x=59,y=18},{kind="shell",x=14,y=28}}},
kindledguard={level=19,size="m",def=1.3,acts={{"attack",3},{"harden",1,{unless="defUp"}},{"command",1,{unless="atkUp"}}},weak="murk",drop={"irontonic",0.25},rare={"sparkjar",0.05}},
lampgolem={level=20,size="l",hp=2.2,atk=1.2,spd=0.6,acts={{"attack",2},{"slam",1},{"glare",1},{"mend",2,{below=0.3}}},weak="sound",resist="flame",drop={"glimmerdraught",0.2},rare={"emberring",0.03}},
glarewisp={level=19,size="s",mag=1.3,spd=1.4,acts={{"glare",2},{"cinder",1}},weak="murk",resist="flame",drop={"sparkjar",0.1}},
ashhound={level=20,size="m",beast=true,spd=1.3,atk=1.15,acts={{"attack",3},{"bite",2},{"cinder",1}},weak="murk",drop={"palefur",0.5}},
brask={level=20,size="l",boss=8,atk=1.15,acts={{"attack",3},{"crush",2},{"command",1,{unless="atkUp"}},{"roar",1,{unless="atkDown",foe=true}}},weak="murk",drop={"sergeantbadge",1},parts={{kind="arm",x=44,y=14},{kind="shell",x=24,y=24}}},
ashgrave={level=21,size="l",boss=8,mag=1.2,acts={{"attack",2},{"kindling",2},{"glare",1},{"hardenall",1,{unless="spdDown",foe=true}}},acts2={{"kindling",3},{"glare",1},{"hardenall",1}},weak="sound",resist="flame",drop={"ashcrown",1},parts={{kind="core",x=40,y=8}}},
everlamp={level=22,size="b",boss=9,mag=1.25,acts={{"everglow",2},{"kindling",2},{"slam",1},{"hardenall",1,{unless="spdDown",foe=true}}},acts2={{"everglow",3},{"kindling",2},{"slam",1}},weak="murk",resist="flame",parts={{kind="shell",x=20,y=22},{kind="core",x=32,y=20}}},

gildedmite={level=8,size="s",hp=0.5,def=3,spd=2.5,gold=900,acts={{"flee",1},{"attack",1}},weak="flame",drop={"luckypenny",0.3}},
lostwarden={level=12,size="m",acts={{"attack",2},{"kindle",2}},weak="murk",resist="flame",drop={"clearlens",0.5},rare={"pocketsun",0.1}},
hollowwarden={level=20,size="l",boss=6,mag=1.2,acts={{"attack",2},{"kindle",2},{"glare",1}},acts2={{"kindling",2},{"glare",2}},weak="murk",resist="flame",parts={{kind="core",x=39,y=4}}},
kettlewraith={level=19,size="l",boss=6,mag=1.2,acts={{"attack",2},{"cinder",2},{"smother",1}},acts2={{"cinderstorm",2},{"smother",1}},weak="sound",resist="flame",parts={{kind="jaw",x=43,y=24}}},
currenteater={level=20,size="b",boss=6,acts={{"attack",2},{"tidepull",2},{"bite",1}},acts2={{"tidepull",3},{"crush",1}},weak="flame",resist="murk",parts={{kind="jaw",x=47,y=38}}},
firstcaptain={level=21,size="l",boss=6,def=1.3,acts={{"attack",3},{"crush",1},{"harden",1,{unless="defUp"}},{"command",1,{unless="atkUp"}}},acts2={{"attack",2},{"crush",2},{"slam",1}},weak="murk",parts={{kind="shell",x=5,y=24}}},
hollowsleeper={level=21,size="b",boss=6,acts={{"smother",2},{"stillwave",1},{"slam",1}},acts2={{"smother",2},{"stillwave",2},{"mend",1,{below=0.25}}},weak="sound",resist="murk",parts={{kind="eye",x=32,y=26}}},
oldmoth={level=20,size="l",boss=6,spd=1.3,acts={{"attack",2},{"spore",1},{"mist",1},{"bite",1}},acts2={{"attack",2},{"spore",2},{"glare",1}},weak="flame",parts={{kind="legs",x=12,y=36}}},
drownedbell={level=21,size="b",boss=6,mag=1.2,acts={{"clang",3},{"slam",1},{"roar",1,{unless="atkDown",foe=true}}},acts2={{"clang",3},{"stillwave",1}},weak="murk",resist="sound",parts={{kind="jaw",x=32,y=50}}},
rootmother={level=28,size="b",boss=10,acts={{"attack",2},{"crush",2},{"spore",1},{"mend",1,{below=0.3}}},acts2={{"crush",3},{"spore",1},{"roar",1}},weak="flame",parts={{kind="arm",x=14,y=10},{kind="core",x=32,y=22}}},
leviathan={level=30,size="b",boss=12,acts={{"attack",2},{"tidepull",2},{"smother",1},{"stillwave",1}},acts2={{"tidepull",3},{"smother",2},{"bite",1}},weak="sound",resist="murk",parts={{kind="eye",x=55,y=10},{kind="jaw",x=58,y=20}}},
}

b.ORDER={
"mistmite","sootcrow","fogfin","wickmoth","rootcrawler","wicklouse","grubswarm","snuffer","gorse",
"fenhopper","briarhog","driftjelly","gullwraith","tidecrab","shoal","murkmaw",
"lampwright","sootwraith","vaultrat","cinderimp","vaultwarden",
"scaldling","palehound","driftmaw","lanterneel","stilledmass","snufferveteran","hesk",
"belfrybat","rustrat","clapperimp","verdigris",
"kindledguard","lampgolem","glarewisp","ashhound","brask","ashgrave","everlamp",
"gildedmite","lostwarden","hollowwarden","kettlewraith","currenteater","firstcaptain","hollowsleeper","oldmoth","drownedbell",
"rootmother","leviathan",
}

local function g(h,a,i)
local c=SpiffBoy.clamp(a.level+i,1,b.LEVEL_CAP)
local d=a.boss or 1
local f=math.floor((4+3*c+0.3*c*c)*(d>1 and b.BOSS_GOLD or 1))
if a.gold then
f=a.gold
elseif a.beast then
f=0
end
return{
id=h,
level=c,
size=a.size,
hp=math.floor((12+7*c+0.18*c*c)*(a.hp or 1)*d),
atk=math.floor((5+2.4*c)*(a.atk or 1)),
def=math.floor((2+1.5*c)*(a.def or 1)),
mag=math.floor((2+1.6*c)*(a.mag or 1)),
res=math.floor((2+1.3*c)*(a.res or 1)),
spd=math.floor((5+1.2*c)*(a.spd or 1)),
xp=math.floor(e.Characters.toNext(c)/10*(d>1 and 6 or 1)),
gold=f,
acts=a.acts,
acts2=a.acts2,
weak=a.weak,
resist=a.resist,
drop=a.drop,
rare=a.rare,
parts=a.parts,
boss=d>1,
}
end

b.STATS={}

function b.get(c,d)
local f=b.LIST[c]
if not f then
return nil
end
local a=b.STATS[d]
if not a then
a={}
b.STATS[d]=a
end
if not a[c]then
a[c]=g(c,f,d)
end
return a[c]
end

function b.indexOf(a)
return e.indexOf(b.ORDER,a)
end
