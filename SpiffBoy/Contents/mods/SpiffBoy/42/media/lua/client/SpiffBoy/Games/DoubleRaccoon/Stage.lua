require"SpiffBoy/Core/Core"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local a={}
a.__index=a
SpiffBoy.DoubleRaccoon.Stage=a

a.VIEW=180
a.WAVE_GAP=40
a.DIFFICULTIES={
{key="e",text="Easy",lives=5,damage=0.6,extra=-1},
{key="n",text="Normal",lives=3,damage=1,extra=0},
{key="h",text="Hard",lives=3,damage=1.4,extra=1},
}

a.FOREST={
name="Stage1",
number=1,
length=1440,
music="forest",
scenery={
layers={
{art="forest_sky",y=2,height=14,speed=0.05,shades={3}},
{art="forest_far",y=14,height=34,speed=0.15,shades={3}},
{art="forest_mid_dense",alt="forest_mid_sparse",altFrom=900,y=10,height=52,speed=0.4,shades={1,2,3}},
{art="forest_near",y=48,height=16,speed=0.7,shades={1,2}},
},
props={{art="louisville_sign",at=1300,width=58,height=39,speed=0.7,shades={1,3,4}}},
ground={art="forest_ground",shades={2,3}},
front={art="forest_trunk",width=14,height=120,speed=1.3,shades={1,2},at={330,700,1010,1420,1720}},
},
zones={
{at=150,waves={{"shambler","shambler"},{"shambler","woman"}}},
{at=440,waves={{"woman","shambler"},{"runner","shambler","woman"}}},
{at=740,waves={{"runner","runner"},{"shambler","cop"},{"woman","runner"}}},
{at=1020,waves={{"cop","shambler"},{"runner","woman","cop"}}},
},
items={
{kind="chips",x=380,z=30},
{kind="bat",x=620,z=18},
{kind="tin",x=960,z=36},
{kind="pan",x=1150,z=24},
{kind="chips",x=1240,z=40},
},
boss={at=1260,kind="lumberjack"},
}

a.SUBURBS={
name="Stage2",
number=2,
length=1600,
music="suburbs",
scenery={
layers={
{art="suburbs_sky",y=2,height=14,speed=0.05,shades={3}},
{art="suburbs_far",y=12,height=36,speed=0.15,shades={2,3}},
{art="suburbs_mid",y=12,height=50,speed=0.4,shades={1,2,3,4}},
{art="suburbs_near",y=46,height=18,speed=0.7,shades={1,2,4}},
},
props={},
ground={art="suburbs_ground",shades={1,2,3}},
front={art="suburbs_pole",width=26,height=120,speed=1.3,shades={1,2},at={300,640,980,1330,1700}},
},
zones={
{at=160,waves={{"woman","shambler"},{"runner","woman"}}},
{at=470,waves={{"shambler","runner","woman"},{"cop","shambler"}}},
{at=790,waves={{"runner","runner"},{"woman","cop","shambler"},{"runner","woman"}}},
{at=1110,waves={{"cop","runner"},{"shambler","woman","runner"},{"cop","cop"}}},
},
items={
{kind="pan",x=300,z=26},
{kind="chips",x=600,z=40},
{kind="bat",x=900,z=20},
{kind="tin",x=1240,z=34},
{kind="chips",x=1380,z=16},
},
boss={at=1420,kind="linebacker"},
}

a.DOWNTOWN={
name="Stage3",
number=3,
length=1760,
music="downtown",
scenery={
layers={
{art="downtown_sky",y=0,height=30,speed=0.05,shades={3}},
{art="downtown_far",y=4,height=44,speed=0.15,shades={2,3}},
{art="downtown_mid",y=8,height=54,speed=0.4,shades={1,2,3,4}},
{art="downtown_near",y=44,height=20,speed=0.7,shades={1,2,3,4}},
},
props={},
ground={art="downtown_ground",shades={1,2,3}},
front={art="downtown_lamp",width=24,height=120,speed=1.3,shades={1,2},at={320,700,1080,1460,1880}},
},
zones={
{at=160,waves={{"cop","shambler"},{"runner","woman","shambler"}}},
{at=480,waves={{"runner","runner","woman"},{"cop","cop"}}},
{at=820,waves={{"shambler","cop","runner"},{"woman","woman","runner"},{"cop","shambler"}}},
{at=1140,waves={{"runner","cop"},{"runner","runner","woman"},{"cop","shambler","cop"}}},
{at=1400,waves={{"woman","runner","cop"},{"runner","cop","runner"}}},
},
items={
{kind="bat",x=260,z=30},
{kind="chips",x=640,z=18},
{kind="axe",x=1000,z=36},
{kind="tin",x=1300,z=24},
{kind="pan",x=1480,z=40},
{kind="chips",x=1540,z=20},
},
boss={at=1580,kind="riot"},
}

a.HEART={
name="Stage4",
number=4,
length=1760,
music="heart",
finalMusic=true,
scenery={
layers={
{art="heart_sky",y=0,height=22,speed=0.05,shades={3}},
{art="heart_far",y=0,height=48,speed=0.15,shades={2,3}},
{art="heart_mid",y=6,height=56,speed=0.4,shades={1,2,3}},
{art="heart_near",y=44,height=20,speed=0.7,shades={1,2,3}},
},
props={{art="spiffos_sign",at=1600,width=43,height=44,speed=0.7,shades={1,2,3,4}}},
ground={art="heart_ground",shades={1,2,3}},
front={art="heart_girder",width=22,height=120,speed=1.3,shades={1,2},at={340,760,1120,1500,1900}},
},
zones={
{at=160,waves={{"runner","cop","woman"},{"shambler","runner","cop"}}},
{at=500,waves={{"cop","cop","runner"},{"runner","runner","woman"},{"shambler","cop"}}},
{at=840,waves={{"runner","woman","runner"},{"cop","shambler","cop"},{"runner","runner"}}},
{at=1180,waves={{"cop","runner","cop"},{"woman","runner","runner","shambler"}}},
{at=1420,waves={{"runner","cop","runner"},{"cop","cop","woman","runner"}}},
},
items={
{kind="tin",x=300,z=30},
{kind="axe",x=620,z=20},
{kind="chips",x=980,z=38},
{kind="bat",x=1100,z=16},
{kind="tin",x=1340,z=28},
{kind="pan",x=1500,z=40},
{kind="tin",x=1560,z=18},
},
boss={at=1580,kind="evil"},
}

a.LIST={a.FOREST,a.SUBURBS,a.DOWNTOWN,a.HEART}

function a.wavesFor(zone,difficulty)
local c={}
for f,d in ipairs(zone.waves)do
local b={}
for e=1,#d do
b[e]=d[e]
end
if difficulty.extra<0 and#b>1 then
table.remove(b)
elseif difficulty.extra>0 then
b[#b+1]="shambler"
end
c[#c+1]=b
end
return c
end

function a.new(definition,difficulty)
local b=setmetatable({},a)
b.definition=definition
b.difficulty=difficulty
b.zoneIndex=1
b.locked=false
b.waves=nil
b.waveIndex=0
b.waveTimer=0
return b
end

function a:cameraLimit()
local b=self.definition
if self.locked then
return self:currentZone().at
end
local c=b.zones[self.zoneIndex]
if c then
return c.at
end
return b.boss.at
end

function a:currentZone()
return self.definition.zones[self.zoneIndex]
end

function a:reach(camera)
local b=self:currentZone()
if self.locked or not b or camera<b.at then
return false
end
self.locked=true
self.waves=a.wavesFor(b,self.difficulty)
self.waveIndex=0
self.waveTimer=0
return true
end

function a:nextWave(alive)
if not self.locked or self.waveIndex>=#self.waves then
return nil
end
if self.waveIndex>0 and alive>1 then
self.waveTimer=0
return nil
end
self.waveTimer=self.waveTimer+1
if self.waveIndex>0 and self.waveTimer<a.WAVE_GAP then
return nil
end
self.waveTimer=0
self.waveIndex=self.waveIndex+1
return self.waves[self.waveIndex]
end

function a:release(alive)
if not self.locked or self.waveIndex<#self.waves or alive>0 then
return false
end
self.locked=false
self.zoneIndex=self.zoneIndex+1
return true
end

function a:atBoss(camera)
return not self.locked and self.zoneIndex>#self.definition.zones and camera>=self.definition.boss.at
end
