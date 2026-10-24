require"SpiffBoy/Games/Lanterways/Base"

local d=SpiffBoy.Lanterways

local a={}
d.Characters=a

a.STATS={"hp","sp","atk","def","mag","res","spd"}

a.LIST={
{
id="pell",code="P",class="lamplighter",weapon="wickpole",armor={"coat"},
base={hp=38,sp=10,atk=9,def=7,mag=8,res=7,spd=8},
growth={hp=9.5,sp=2.2,atk=2.1,def=1.7,mag=2.0,res=1.6,spd=1.4},
start={weapon="tinpole",armor="patchcoat"},
skills={{1,"kindle"},{3,"flare"},{6,"warmglow"},{10,"wicklash"},{14,"steadyflame"},{19,"blazeroad"},{22,"dawnbreak"}},
taught={{flag="peal",skill="passingpeal"}},
bright="oath",
},
{
id="bram",code="B",class="cook",weapon="cookware",armor={"apron"},
base={hp=52,sp=8,atk=10,def=9,mag=6,res=6,spd=5},
growth={hp=12,sp=1.8,atk=2.2,def=2.1,mag=1.5,res=1.4,spd=0.9},
start={weapon="ladle",armor="kitchenapron"},
skills={{1,"tastetest"},{4,"peppertoss"},{7,"heartystew"},{11,"tenderize"},{15,"secondhelping"},{20,"feast"},{23,"castiron"}},
taught={},
bright="banquet",
},
{
id="ottilie",code="O",class="surveyor",weapon="dividers",armor={"coat"},
base={hp=34,sp=10,atk=9,def=6,mag=7,res=7,spd=11},
growth={hp=8.5,sp=2.0,atk=2.2,def=1.5,mag=1.6,res=1.6,spd=1.9},
start={weapon="brassdividers",armor="oilskin"},
skills={{1,"survey"},{5,"pinpoint"},{8,"shortcut"},{12,"triangulate"},{16,"fogreading"},{21,"truenorth"},{23,"sextantstorm"}},
taught={},
bright="perfectchart",
},
{
id="ines",code="I",class="warden",weapon="lanternmace",armor={"plate"},
base={hp=50,sp=8,atk=11,def=12,mag=4,res=8,spd=6},
growth={hp=12.5,sp=1.6,atk=2.3,def=2.5,mag=1.0,res=1.8,spd=1.0},
start={weapon="guardlantern",armor="guardmail"},
skills={{1,"shieldwall"},{1,"lanternsmash"},{1,"rally"},{14,"holdtheline"},{17,"brand"},{20,"bulwark"},{23,"judgement"}},
taught={},
bright="lastlamp",
},
{
id="hobb",code="H",class="ringer",weapon="handbell",armor={"robe"},
base={hp=32,sp=14,atk=5,def=6,mag=11,res=10,spd=6},
growth={hp=8,sp=2.8,atk=1.2,def=1.4,mag=2.5,res=2.2,spd=1.1},
start={weapon="bronzebell",armor="belfryrobe"},
skills={{1,"chime"},{1,"toll"},{1,"lull"},{18,"clearpeal"},{20,"resonance"},{21,"knell"},{24,"carillon"}},
taught={},
bright="passagesong",
},
{
id="hush",code="U",class="fogborn",weapon="shard",armor={"robe"},
base={hp=36,sp=12,atk=7,def=7,mag=10,res=11,spd=9},
growth={hp=9,sp=2.4,atk=1.6,def=1.6,mag=2.4,res=2.3,spd=1.6},
start={weapon="paleshard",armor="fogweave"},
skills={{1,"drain"},{1,"veil"},{14,"soften"},{15,"still"},{17,"engulf"},{21,"undertow"}},
taught={},
bright="manyasone",
},
{
id="nim",code="N",class="mothherd",weapon="net",armor={"coat"},
base={hp=30,sp=12,atk=8,def=5,mag=9,res=8,spd=12},
growth={hp=7.5,sp=2.3,atk=1.9,def=1.3,mag=2.1,res=1.8,spd=2.0},
start={weapon="silknet",armor="mothcloak"},
skills={{1,"mothswarm"},{1,"dusting"},{1,"snare"},{14,"glowmoths"},{15,"sootmoths"},{18,"moonwing"},{22,"stormwing"}},
taught={},
bright="thousandwings",
},
}

a.BY_ID={}
a.BY_CODE={}
for c,b in ipairs(a.LIST)do
b.index=c
a.BY_ID[b.id]=b
a.BY_CODE[b.code]=b
end

function a.toNext(level)
return math.floor(10*level*level+15*level)
end

function a.statAt(character,stat,level)
local b=character.base[stat]+character.growth[stat]*(level-1)
if stat=="hp"then
b=b+(level-1)*(level-1)*0.12
end
return math.floor(b)
end

function a.skillsAt(character,level,flags)
local b={}
for e,c in ipairs(character.skills)do
if c[1]<=level then
b[#b+1]=c[2]
end
end
for e,c in ipairs(character.taught)do
if flags[c.flag]then
b[#b+1]=c.skill
end
end
return b
end

function a.canWear(character,kind)
for c,b in ipairs(character.armor)do
if b==kind then
return true
end
end
return false
end
