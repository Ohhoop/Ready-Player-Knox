require"SpiffBoy/Games/Lanterways/Base"

local d=SpiffBoy.Lanterways

local a={}
d.Skills=a

a.LIST={
kindle={cost=3,target="enemy",kind="magic",power=16,element="flame",fx="flame"},
flare={cost=4,target="enemies",kind="status",status="blind",chance=0.6,fx="flash"},
warmglow={cost=4,target="ally",kind="heal",power=34,fx="heal"},
wicklash={cost=5,target="enemy",kind="physical",power=1.5,element="flame",fx="flame"},
steadyflame={cost=8,target="allies",kind="buff",status="atkUp",fx="buff"},
blazeroad={cost=12,target="enemies",kind="magic",power=44,element="flame",fx="flame"},
dawnbreak={cost=18,target="enemy",kind="magic",power=120,element="flame",fx="flame"},
passingpeal={cost=11,target="enemies",kind="magic",power=50,element="sound",fx="ring"},
oath={bright=true,target="enemies",kind="magic",power=90,element="flame",healParty=0.4,fx="flame"},

tastetest={cost=2,target="ally",kind="heal",power=28,fx="heal"},
peppertoss={cost=3,target="enemy",kind="physical",power=0.6,status="blind",chance=0.8,fx="dust"},
heartystew={cost=7,target="allies",kind="heal",power=28,fx="heal"},
tenderize={cost=5,target="enemy",kind="physical",power=1.2,status="defDown",chance=1,fx="hit"},
secondhelping={cost=10,target="fallen",kind="revive",power=0.5,fx="heal"},
feast={cost=16,target="allies",kind="heal",power=80,cure=true,fx="heal"},
castiron={cost=10,target="enemy",kind="physical",power=2.6,fx="hit"},
banquet={bright=true,target="allies",kind="heal",power=0.6,ratio=true,revive=true,fx="heal"},

survey={cost=1,target="enemy",kind="survey",fx="flash"},
pinpoint={cost=4,target="enemy",kind="physical",power=1.1,crit=true,fx="hit"},
shortcut={cost=6,target="allies",kind="buff",status="spdUp",fx="buff"},
triangulate={cost=7,target="random",kind="physical",power=0.8,hits=3,fx="hit"},
fogreading={cost=8,target="enemies",kind="status",status="defDown",chance=0.9,fx="dust"},
truenorth={cost=9,target="ally",kind="buff",status="atkUp",also="spdUp",cure=true,fx="buff"},
sextantstorm={cost=15,target="enemies",kind="physical",power=1.3,fx="hit"},
perfectchart={bright=true,target="enemies",kind="physical",power=1.2,status="defDown",also="atkDown",chance=1,partyStatus="spdUp",fx="dust"},

shieldwall={cost=5,target="allies",kind="buff",status="defUp",fx="buff"},
holdtheline={cost=3,target="self",kind="buff",status="taunt",fx="buff"},
lanternsmash={cost=5,target="enemy",kind="physical",power=1.3,status="stun",chance=0.4,fx="hit"},
rally={cost=6,target="ally",kind="heal",power=40,cure=true,fx="heal"},
brand={cost=7,target="enemy",kind="physical",power=1.7,element="flame",fx="flame"},
bulwark={cost=10,target="allies",kind="buff",status="defUp",also="resUp",fx="buff"},
judgement={cost=14,target="enemy",kind="physical",power=3.0,fx="hit"},
lastlamp={bright=true,target="allies",kind="heal",power=0.5,ratio=true,partyStatus="defUp",fx="heal"},

chime={cost=6,target="allies",kind="heal",power=32,fx="ring"},
toll={cost=8,target="enemies",kind="magic",power=32,element="sound",status="stun",chance=0.25,fx="ring"},
lull={cost=6,target="enemies",kind="status",status="sleep",chance=0.55,fx="ring"},
clearpeal={cost=5,target="allies",kind="cure",fx="ring"},
resonance={cost=10,target="allies",kind="buff",status="magUp",also="resUp",fx="ring"},
knell={cost=14,target="enemy",kind="magic",power=100,element="sound",fx="ring"},
carillon={cost=20,target="enemies",kind="magic",power=80,element="sound",fx="ring"},
passagesong={bright=true,target="enemies",kind="magic",power=110,element="sound",reviveParty=0.5,fx="ring"},

drain={cost=4,target="enemy",kind="magic",power=26,element="murk",drain=true,fx="murk"},
veil={cost=7,target="allies",kind="buff",status="veil",fx="murk"},
soften={cost=5,target="enemy",kind="status",status="defDown",also="resDown",chance=1,fx="murk"},
still={cost=8,target="enemy",kind="status",status="stun",chance=0.8,fx="murk"},
engulf={cost=11,target="enemies",kind="magic",power=50,element="murk",fx="murk"},
undertow={cost=15,target="enemy",kind="magic",power=110,element="murk",drain=true,fx="murk"},
manyasone={bright=true,target="enemies",kind="magic",power=120,element="murk",fx="murk"},

mothswarm={cost=4,target="random",kind="physical",power=0.55,hits=3,fx="moth"},
dusting={cost=4,target="enemy",kind="status",status="sleep",chance=0.8,fx="moth"},
glowmoths={cost=8,target="allies",kind="buff",status="regen",fx="moth"},
sootmoths={cost=7,target="enemies",kind="status",status="soot",chance=0.65,fx="moth"},
moonwing={cost=10,target="allies",kind="heal",power=50,fx="moth"},
stormwing={cost=14,target="random",kind="physical",power=0.75,hits=5,fx="moth"},
snare={cost=3,target="enemy",kind="steal",fx="moth"},
thousandwings={bright=true,target="enemies",kind="physical",power=1.4,hits=2,status="blind",also="soot",chance=0.8,fx="moth"},

bite={target="enemy",kind="physical",power=1.2,fx="hit"},
peck={target="enemy",kind="physical",power=0.8,status="blind",chance=0.3,fx="hit"},
sting={target="enemy",kind="physical",power=0.9,status="soot",chance=0.4,fx="hit"},
mist={target="enemies",kind="status",status="blind",chance=0.35,fx="murk"},
spore={target="enemies",kind="status",status="sleep",chance=0.3,fx="dust"},
snuff={target="enemy",kind="drainSp",power=6,fx="murk"},
soak={target="enemies",kind="magic",power=18,element="murk",fx="murk"},
cinder={target="enemy",kind="magic",power=26,element="flame",fx="flame"},
cinderstorm={target="enemies",kind="magic",power=30,element="flame",fx="flame"},
roar={target="enemies",kind="status",status="atkDown",chance=0.6,fx="ring"},
slam={target="enemies",kind="physical",power=0.8,fx="hit"},
crush={target="enemy",kind="physical",power=1.8,fx="hit"},
harden={target="self",kind="buff",status="defUp",fx="buff"},
mend={target="self",kind="heal",power=60,fx="heal"},
glare={target="enemies",kind="magic",power=40,element="flame",status="blind",chance=0.3,fx="flash"},
stillwave={target="enemies",kind="status",status="stun",chance=0.3,fx="murk"},
clang={target="enemies",kind="magic",power=34,element="sound",status="stun",chance=0.2,fx="ring"},
smother={target="enemy",kind="magic",power=60,element="murk",fx="murk"},
tidepull={target="enemies",kind="magic",power=50,element="murk",fx="murk"},
kindling={target="enemies",kind="magic",power=70,element="flame",fx="flame"},
everglow={target="enemies",kind="magic",power=95,element="flame",status="stun",chance=0.15,fx="flash"},
hardenall={target="enemies",kind="status",status="spdDown",chance=0.7,fx="flash"},
command={target="self",kind="buff",status="atkUp",fx="buff"},
oldsnuff={target="enemies",kind="drainSp",power=5,fx="murk"},
flee={target="self",kind="flee",fx="dust"},

lampandbell={duo={"pell","hobb"},target="enemies",kind="magic",power=70,elements={"flame","sound"},fx="ring"},
northlight={duo={"pell","ottilie"},target="allies",kind="heal",power=0.5,ratio=true,partyStatus="atkUp",partyAlso="spdUp",fx="heal"},
greywings={duo={"hush","nim"},target="random",kind="magic",power=45,element="murk",hits=4,status="sleep",chance=0.25,fx="moth"},
messhall={duo={"ines","bram"},target="allies",kind="heal",power=0.4,ratio=true,cure=true,partyStatus="defUp",fx="heal"},
deepchart={duo={"ottilie","hush"},target="enemies",kind="magic",power=80,element="murk",status="defDown",also="resDown",chance=1,fx="murk"},
}

a.DUOS={"lampandbell","northlight","greywings","messhall","deepchart"}
a.DUO_GLOW=50
a.BOND_NEEDED=30
a.BOND_CAP=99

for c,b in pairs(a.LIST)do
b.id=c
b.cost=b.cost or 0
end

function a.get(b)
return a.LIST[b]
end

function a.usableInField(c)
local b=c.kind
return not c.bright and(b=="heal"or b=="cure"or b=="revive")
end
