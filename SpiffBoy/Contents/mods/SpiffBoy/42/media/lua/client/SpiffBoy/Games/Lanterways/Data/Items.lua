require"SpiffBoy/Games/Lanterways/Base"

local c=SpiffBoy.Lanterways

local a={}
c.Items=a

a.MAX_STACK=99

a.ORDER={
"bun","stew","pressedfeast","wickoil","glimmerdraught","salts","eyewash","charcoal","cleartonic",
"gingersnap","irontonic","quickstep","pepperpouch","sootbomb","lullabybox","rustdust","glimmerflask","brassbanger","fogwhistle",
"tinpole","brasspole","lamphook","gildedpole","dawnstaff",
"ladle","skillet","cleaver","copperpot","grandmapan",
"brassdividers","steeldividers","fogcalipers","starcompass","meridian",
"guardlantern","ironlantern","brandlantern","beacon",
"bronzebell","silverbell","stormbell","passagebell",
"paleshard","greyshard","duskshard","murkheart",
"silknet","moonnet","thousandnet",
"patchcoat","oilskin","surveyorcoat","greatcoat","mothcloak","dawncoat",
"kitchenapron","leatherapron","chefwhites","banquetapron",
"guardmail","wardenplate","beaconplate",
"belfryrobe","fogweave","tollrobe","murkmantle",
"candlestub","luckypenny","brassbutton","mothwing","eartrumpet","wardbell","clearlens","emberring","pocketsun",
"handbell","heartwick","passagescore","form12b","chart",
"emberhook","searskillet","fogneedle","belllantern","hollowshard","dozenet","crackedbell",
"farmermitts","murkpearl","vaultseal","oldwick","greenclapper","sergeantbadge","ashcrown",
"charcoallocket","sparktin","litmatch","mothlantern","earlybell",
"sparkjar","belltonic","veilash","mothjar","murkvial","dawnember","greatstew","glimmerbomb","oilcask","briarham",
"misthusk","fogpearl","gullfeather","crabshell","palefur",
"ringerplate","harbourapron",
"firstwick","drownedladle","lisslantern","ferryapron","olddividers","farrowbrooch",
"watchbell","nightlantern","mapmakercoat","ferryshard","shorenet","ferryoar",
}

a.DISPLAY={
"bun","briarham","stew","greatstew","pressedfeast","wickoil","oilcask","glimmerdraught","salts","dawnember","eyewash","charcoal","cleartonic",
"gingersnap","irontonic","quickstep","belltonic","veilash","mothjar","sparkjar",
"pepperpouch","sootbomb","lullabybox","rustdust","glimmerflask","glimmerbomb","brassbanger","murkvial","fogwhistle",
"tinpole","firstwick","brasspole","lamphook","emberhook","gildedpole","dawnstaff",
"ladle","drownedladle","skillet","cleaver","searskillet","copperpot","grandmapan",
"brassdividers","olddividers","steeldividers","fogneedle","fogcalipers","starcompass","meridian",
"guardlantern","nightlantern","belllantern","ironlantern","brandlantern","beacon",
"bronzebell","watchbell","silverbell","crackedbell","stormbell","passagebell",
"paleshard","hollowshard","greyshard","ferryshard","duskshard","murkheart",
"silknet","dozenet","shorenet","moonnet","thousandnet",
"patchcoat","oilskin","surveyorcoat","mapmakercoat","greatcoat","mothcloak","dawncoat",
"kitchenapron","leatherapron","ferryapron","chefwhites","harbourapron","banquetapron",
"guardmail","wardenplate","ringerplate","beaconplate",
"belfryrobe","fogweave","tollrobe","murkmantle",
"candlestub","luckypenny","brassbutton","farrowbrooch","farmermitts","murkpearl","clearlens","charcoallocket","vaultseal","mothwing","wardbell",
"oldwick","lisslantern","ferryoar","eartrumpet","greenclapper","emberring","pocketsun","sergeantbadge","sparktin","litmatch","mothlantern","earlybell","ashcrown",
"misthusk","fogpearl","gullfeather","crabshell","palefur",
"handbell","heartwick","passagescore","form12b","chart",
}

a.LIST={
bun={kind="use",price=12,effect="heal",power=50,target="ally"},
stew={kind="use",price=40,effect="heal",power=160,target="ally"},
pressedfeast={kind="use",price=220,effect="heal",power=300,target="allies"},
wickoil={kind="use",price=60,effect="sp",power=15,target="ally"},
glimmerdraught={kind="use",price=200,effect="sp",power=45,target="ally"},
salts={kind="use",price=90,effect="revive",power=0.3,target="fallen"},
eyewash={kind="use",price=8,effect="cure",status="blind",target="ally"},
charcoal={kind="use",price=8,effect="cure",status="soot",target="ally"},
cleartonic={kind="use",price=45,effect="cure",target="ally"},
gingersnap={kind="use",price=30,effect="buff",status="atkUp",target="ally",battle=true},
irontonic={kind="use",price=30,effect="buff",status="defUp",target="ally",battle=true},
quickstep={kind="use",price=30,effect="buff",status="spdUp",target="ally",battle=true},
pepperpouch={kind="use",price=20,effect="debuff",status="blind",chance=0.85,target="enemy",battle=true},
sootbomb={kind="use",price=25,effect="debuff",status="soot",chance=0.85,target="enemy",battle=true},
lullabybox={kind="use",price=35,effect="debuff",status="sleep",chance=0.7,target="enemies",battle=true},
rustdust={kind="use",price=30,effect="debuff",status="defDown",chance=1,target="enemy",battle=true},
glimmerflask={kind="use",price=40,effect="damage",power=70,element="flame",target="enemy",battle=true},
glimmerbomb={kind="use",price=260,effect="damage",power=120,element="flame",target="enemies",battle=true},
murkvial={kind="use",price=60,effect="damage",power=60,element="murk",target="enemy",battle=true},
brassbanger={kind="use",price=70,effect="damage",power=50,element="sound",status="stun",chance=0.3,target="enemies",battle=true},
fogwhistle={kind="use",price=20,effect="escape",target="none",battle=true},
sparkjar={kind="use",price=300,effect="glow",power=25,target="self",battle=true},
belltonic={kind="use",price=40,effect="buff",status="magUp",target="ally",battle=true},
veilash={kind="use",price=120,effect="buff",status="veil",target="allies",battle=true},
mothjar={kind="use",price=150,effect="buff",status="regen",target="allies",battle=true},
dawnember={kind="use",price=600,effect="revive",power=1,target="fallen"},
greatstew={kind="use",price=150,effect="heal",power=400,target="ally"},
oilcask={kind="use",price=400,effect="sp",power=30,target="allies"},
briarham={kind="use",price=50,effect="heal",power=120,target="ally"},

tinpole={kind="weapon",wield="wickpole",price=0,atk=4},
brasspole={kind="weapon",wield="wickpole",price=180,atk=11,mag=2},
lamphook={kind="weapon",wield="wickpole",price=620,atk=20,mag=5},
emberhook={kind="weapon",wield="wickpole",price=700,atk=17,mag=6,element="flame"},
gildedpole={kind="weapon",wield="wickpole",price=1500,atk=31,mag=9},
dawnstaff={kind="weapon",wield="wickpole",price=0,atk=44,mag=16},
ladle={kind="weapon",wield="cookware",price=0,atk=5},
skillet={kind="weapon",wield="cookware",price=200,atk=13,def=2},
cleaver={kind="weapon",wield="cookware",price=650,atk=23,crit=0.15},
searskillet={kind="weapon",wield="cookware",price=720,atk=20,element="flame"},
copperpot={kind="weapon",wield="cookware",price=1550,atk=32,def=6,onHit={"defDown",0.2}},
grandmapan={kind="weapon",wield="cookware",price=0,atk=46,def=8},
brassdividers={kind="weapon",wield="dividers",price=0,atk=8,spd=1},
steeldividers={kind="weapon",wield="dividers",price=600,atk=18,spd=2},
fogneedle={kind="weapon",wield="dividers",price=1700,atk=25,spd=3,element="murk"},
fogcalipers={kind="weapon",wield="dividers",price=1400,atk=28,spd=3},
starcompass={kind="weapon",wield="dividers",price=2400,atk=36,spd=5},
meridian={kind="weapon",wield="dividers",price=0,atk=45,spd=8},
guardlantern={kind="weapon",wield="lanternmace",price=0,atk=20},
belllantern={kind="weapon",wield="lanternmace",price=1200,atk=26,element="sound"},
ironlantern={kind="weapon",wield="lanternmace",price=1450,atk=30,def=3},
brandlantern={kind="weapon",wield="lanternmace",price=2500,atk=39,def=4},
beacon={kind="weapon",wield="lanternmace",price=0,atk=48,def=8},
bronzebell={kind="weapon",wield="handbell",price=0,atk=10,mag=14},
silverbell={kind="weapon",wield="handbell",price=1100,atk=14,mag=22},
crackedbell={kind="weapon",wield="handbell",price=1100,atk=16,mag=24,onHit={"stun",0.2}},
stormbell={kind="weapon",wield="handbell",price=2300,atk=18,mag=28},
passagebell={kind="weapon",wield="handbell",price=0,atk=22,mag=36},
paleshard={kind="weapon",wield="shard",price=0,atk=14,mag=10},
hollowshard={kind="weapon",wield="shard",price=1300,atk=18,mag=14,element="sound"},
greyshard={kind="weapon",wield="shard",price=1900,atk=22,mag=16},
duskshard={kind="weapon",wield="shard",price=2600,atk=30,mag=22},
murkheart={kind="weapon",wield="shard",price=0,atk=36,mag=32},
silknet={kind="weapon",wield="net",price=0,atk=18,spd=2},
dozenet={kind="weapon",wield="net",price=1500,atk=24,spd=3,onHit={"sleep",0.15}},
moonnet={kind="weapon",wield="net",price=2200,atk=28,spd=4},
thousandnet={kind="weapon",wield="net",price=0,atk=40,spd=7},

patchcoat={kind="armor",wear="coat",price=0,def=3,res=2},
oilskin={kind="armor",wear="coat",price=160,def=8,res=5,ward="murk"},
surveyorcoat={kind="armor",wear="coat",price=560,def=14,res=10,spd=1},
greatcoat={kind="armor",wear="coat",price=1350,def=21,res=15,ward="flame"},
mothcloak={kind="armor",wear="coat",price=2100,def=26,res=20,spd=2,ward="murk"},
dawncoat={kind="armor",wear="coat",price=0,def=34,res=26,spd=2,ward="flame"},
kitchenapron={kind="armor",wear="apron",price=0,def=5,res=2,hp=10},
leatherapron={kind="armor",wear="apron",price=220,def=11,res=5,hp=30,ward="flame"},
chefwhites={kind="armor",wear="apron",price=1200,def=22,res=14,hp=60,ward="flame"},
banquetapron={kind="armor",wear="apron",price=0,def=33,res=22,hp=120,ward="flame"},
harbourapron={kind="armor",wear="apron",price=2000,def=27,res=18,hp=90,ward="murk"},
guardmail={kind="armor",wear="plate",price=0,def=20,res=9},
ringerplate={kind="armor",wear="plate",price=2300,def=36,res=20,ward="sound"},
wardenplate={kind="armor",wear="plate",price=1700,def=30,res=15,ward="flame"},
beaconplate={kind="armor",wear="plate",price=0,def=42,res=24,ward="flame"},
belfryrobe={kind="armor",wear="robe",price=0,def=14,res=20,ward="sound"},
fogweave={kind="armor",wear="robe",price=1300,def=18,res=24,ward="murk"},
tollrobe={kind="armor",wear="robe",price=2200,def=24,res=32,ward="sound"},
murkmantle={kind="armor",wear="robe",price=0,def=30,res=40,ward="murk"},

candlestub={kind="charm",price=120,hp=25},
luckypenny={kind="charm",price=300,spd=4},
brassbutton={kind="charm",price=300,def=6},
mothwing={kind="charm",price=900,spd=8,guard="sleep"},
eartrumpet={kind="charm",price=700,res=12,ward="sound"},
wardbell={kind="charm",price=800,guard="sleep",res=10},
clearlens={kind="charm",price=600,guard="blind",atk=3},
emberring={kind="charm",price=1400,atk=10},
pocketsun={kind="charm",price=1600,mag=12,sp=10},
farmermitts={kind="charm",price=0,atk=6},
murkpearl={kind="charm",price=0,guard="blind",res=6},
vaultseal={kind="charm",price=0,def=12},
oldwick={kind="charm",price=0,sp=15,mag=6},
greenclapper={kind="charm",price=0,guard="stun",def=4},
sergeantbadge={kind="charm",price=0,atk=8,def=8},
ashcrown={kind="charm",price=0,atk=6,def=6,mag=6,res=6,spd=4},
charcoallocket={kind="charm",price=500,guard="soot"},
sparktin={kind="charm",price=0,glowHit=3},
litmatch={kind="charm",price=0,glowStart=25},
mothlantern={kind="charm",price=1200,regenStart=true},
earlybell={kind="charm",price=0,early=true,spd=2},

firstwick={kind="weapon",wield="wickpole",price=0,atk=8,mag=4,element="flame"},
drownedladle={kind="weapon",wield="cookware",price=0,atk=12,onHit={"defDown",0.15}},
lisslantern={kind="charm",price=0,sp=10,mag=8,guard="blind"},
ferryapron={kind="armor",wear="apron",price=0,def=18,res=12,hp=50,ward="murk"},
olddividers={kind="weapon",wield="dividers",price=0,atk=16,spd=2,element="murk"},
farrowbrooch={kind="charm",price=0,atk=4,def=4},
watchbell={kind="weapon",wield="handbell",price=0,atk=14,mag=20,onHit={"stun",0.15}},
nightlantern={kind="weapon",wield="lanternmace",price=0,atk=27,def=4,element="flame"},
mapmakercoat={kind="armor",wear="coat",price=0,def=18,res=14,spd=2,ward="murk"},
ferryshard={kind="weapon",wield="shard",price=0,atk=28,mag=26,element="murk"},
shorenet={kind="weapon",wield="net",price=0,atk=26,spd=4,onHit={"sleep",0.2}},
ferryoar={kind="charm",price=0,spd=6,glowStart=15},

misthusk={kind="loot",price=24},
fogpearl={kind="loot",price=80},
gullfeather={kind="loot",price=60},
crabshell={kind="loot",price=120},
palefur={kind="loot",price=200},

handbell={kind="key"},
heartwick={kind="key"},
passagescore={kind="key"},
form12b={kind="key"},
chart={kind="key"},
}

a.CODES={}
for d,b in ipairs(a.ORDER)do
local e=a.LIST[b]
e.id=b
e.code=d
a.CODES[d]=b
end

function a.get(b)
return a.LIST[b]
end

function a.isEquipment(b)
return b.kind=="weapon"or b.kind=="armor"or b.kind=="charm"
end

function a.fits(d,b)
if b.kind=="weapon"then
return b.wield==d.weapon
elseif b.kind=="armor"then
return c.Characters.canWear(d,b.wear)
end
return b.kind=="charm"
end

function a.sellPrice(b)
if not b.price or b.price<=0 or b.kind=="key"then
return 0
end
return math.floor(b.price/2)
end
