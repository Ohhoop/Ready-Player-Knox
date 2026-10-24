require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Core/Tunes"
require"SpiffBoy/Framework/GameTexts"

SpiffBoySerpentGame=SpiffBoyGameBase:derive("SpiffBoySerpentGame")

local c=8
local g=22
local j=15
local af=2
local z=g*j
local aR=3
local aS=11
local aT=7
local aU=4
local h=SpiffBoy.Cartridges.SHADES[4]
local a=SpiffBoy.Cartridges.SHADES[1]
local aV=9
local aW=3
local ag=5
local aX=120
local ah=0
local ai=1
local J=2
local aj=3
local ak=4
local aY={
[ah]={1,2,3},
[ai]={1,4},
[J]={1,2,3},
[aj]={1,4},
[ak]={1,2,3},
}
local S=12
local aZ={1}
local T={11,9,7}
local a_={"Slow","Normal","Fast"}
local a0={1,2,3}
local a1=2
local al=3
local a2=2
local a3={"Standard","Grove","Forest"}
local a4={1,2,3}
local am={
{},
{
{4,3},{5,3},{4,4},{5,4},{16,3},{17,3},{16,4},{17,4},
{4,10},{5,10},{4,11},{5,11},{16,10},{17,10},{16,11},{17,11},
},
{
{9,1},{3,2},{17,2},{6,4},{14,4},{20,5},{2,7},{14,8},
{19,8},{5,9},{12,10},{8,11},{16,11},{3,13},{10,13},{18,13},
},
}
local a5=5
local a6=360
local a7=120
local a8=16
local a9=6
local ba=5
local A={
{key="speed",text="Speed",texts=a_},
{key="walls",text="Walls"},
{key="growth",text="Growth",max=al},
{key="map",text="Map",texts=a3},
{key="bonus",text="BonusApple"},
{action="reset",text="ResetDefaults"},
}
local bb=28
local bc=14
local U=24
local an=168
local ao=50
local ap=3
local aq={{"up",0,-1},{"down",0,1},{"left",-1,0},{"right",1,0}}
local o="title"
local V="run"
local bd="initials"
local W="scores"
local K="options"
local X="confirm"
local L="settings"
local Y={
scores={text="EraseScores",back=K},
rules={text="ResetConfirm",back=L},
}
local Z=10
local r={"Play","HighScores","Options"}
local s={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local k=10
local be=44
local bf=26
local ar=24
local bg=98
local _=6
local as=1
local aa=8
local bh=4
local bi=30
local bj=150
local at=84
local au=32
local av=83
local bk=15
local bl=24
local bm={1,3}
local bn=56
local bo=18
local B=4
local M=15
local C=1
local aw=1
local bp=B+c+aw+C
local ab=9
local D=10
local bq=4
local br=112
local bs=-26
local bt=-22
local bu=38
local ax=46
local ay=-44
local bv=42
local az=15
local bw=4
local bx=24
local by=8
local bz=2
local bA=30
local bB=string.char(0x25B4)
local bC=string.char(0x25BE)
local N=4
local bD="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local bE=62
local E=3
local bF=30
local bG=20
local aA=12
local bH=2
local d=SpiffBoy.GameTexts.of("Serpent")
local m="title"
local aB="run"
local aC="start"
local aD="over"
local ac="eat"
local aE="lose"
local l="tick"
local f="confirm"
local aF="step"
local bI={"c","d","e","f","g","a","b",">c",">d",">e",">f"}
local bJ={[11]=76,[10]=84,[9]=92,[8]=104,[7]=116,[6]=128,[5]=140,[4]=154,[3]=168}

local ad={
[m]={
loop=true,
pulse1="t128 @2 v11 y0 q8 ~2,8,10 l4 o4 r1 r1 r1 r1 L"
.." a2 b4 >c4< | g2 e2 | a2. b8 >c8< | >d2.< r4"
.." | a2 b4 >c4< | g2 e4 d4 | f2 e4 d4 | e1"
.." | @1 >c2 d4 e4< | b2 g2 | >c2 d4 e4< | >d2.< r4"
.." | @2 a2 b4 >c4< | g2 e2 | f2 g+2 | a1",
pulse2={echo="pulse1",delay=8,drop=5},
wave="t128 @12 v3 l2 o2 a >e< | a >e< | a >e< | e b | L"
.." a >e< | c g | a >e< | g >d< | a >e< | c g | d e | a >e<"
.." | c g | g >d< | c g | g >d< | a >e< | c g | d e | a >e<",
noise="t128 l4 [r v3 y1 n80 r n80]4 L l8"
.." [r r v8 y2 n64 r r v4 y1 n80 v8 y2 n64 v4 y1 n80]8"
.." [v11 y1 n{48 80 113} r v8 y2 n64 r v11 y1 n{48 80 113} v4 y1 n80 v8 y2 n64 v4 y1 n80]7"
.." v11 y1 n{48 80 113} r v8 y2 n64 r v8 y2 n64 n64 v9 y2 n64 n64",
},
[aC]={
pulse1="t170 @2 v12 y2 l16 o4 e g b >e8 r16 <b16 >e4^8",
pulse2={echo="pulse1",delay=16,drop=4},
},
[aD]={
pulse1="t120 @2 v12 y2 ~2,10,6 l8 o5 e e d c <b4. a8 | g+2 a4 r4 | <a2",
pulse2="t120 @2 v8 y2 l8 o4 >c c< b a g+4. f8 | e2 f4 r4 | e2",
wave="t120 @0 v3 l4 o2 a a e e | e e f f | a2",
},
[ac]={
noise="t240 l16 v13 y1 n{32 48 64} r v11 y1 n{40 56 72} r v9 y1 n{48 64 80}",
pulse2="t240 @2 v10 y1 l16 o3 c r <a r f r",
},
[aE]={
pulse1="t120 @2 v13 y4 s4,-6 o5 g2",
pulse2="t120 @1 v10 y3 l16 o5 e d+ d c+ c <b b- a a- g g- f",
noise="t120 l2 v9 y3 n{32 64 96 113}",
},
[l]={pulse2="t240 @1 v9 y1 l16 o5 g"},
[f]={pulse2="t200 @2 v10 y2 l16 o5 c e g"},
}

for b=0,k do
ad[aF..b]={pulse2="t240 @2 v10 y1 l16 o5 "..bI[b+1]}
end

local F="v11 y1 n{48 80 113}"
local t="v8 y2 n64"
local aG="v4 y1 n80"
local aH=F.." r "..t.." r "..F.." r "..t.." r"
local e=F.." r "..t.." "..aG.." "..F.." r "..t.." "..aG
local bK=F.." r "..t.." r "..t.." n64 v9 y2 n64 n64"
local bL={
pulse1={
header="@2 v11 y0 q8 ~1,6,6 l4 o4 ",
bars={
"r1","r1",
"e4 g4 a2","b2 a4 g4","e4 g4 a2","b2. r4",
"e4 g4 a2","b2 >d4< b4","a2 g4 e4","d2. r4",
"@1 g4 a4 b2","@1 >c2< b4 a4","@1 g4 a4 b2","@1 a2. r4",
"g4 a4 b2",">c2 d4< b4","a2 g4 f+4","e2. r4",
},
},
pulse2={
header="@2 v5 y0 q8 x2 l1 o3 ",
bars={
"r","r",
"{egb}","{egb}","{egb}","{gb>d}",
"{egb}","{gb>d}","{ceg}","{df+a}",
"{gb>d}","{ceg}","{gb>d}","{ace}",
"{gb>d}","{gb>d}","{df+a}","{egb}",
},
},
wave={
header="@5 v3 l2 o2 ",
bars={
"e b","e b",
"e b","e b","e b","g >d<",
"e b","g >d<","c g","d a",
"g >d<","c g","g >d<","a >e<",
"g >d<","g >d<","d a","e b",
},
},
noise={
header="l8 ",
bars={
aH,aH,
e,e,e,e,
e,e,e,e,
e,e,e,e,
e,e,e,bK,
},
},
}
local aI=18
local bM=2

local function bN(tempo,bar)
local b={}
for n,i in pairs(bL)do
b[n]="t"..tostring(tempo).." "..i.header..i.bars[bar]
end
return b
end

for i,n in pairs(bJ)do
for b=1,aI do
ad[aB..i.."_"..b]=bN(n,b)
end
end

SpiffBoy.Tunes.register("Serpent",ad)

local function ae(start,foods)
return math.max(aW,start-math.floor(foods/ag))
end

local function aJ(save)
local i={speed=a1,walls=true,growth=1,map=1,bonus=false}
local b=save.rules
if type(b)~="table"then
return i
end
if SpiffBoy.isInteger(b.speed)and b.speed>=1 and b.speed<=#T then
i.speed=b.speed
end
if type(b.walls)=="boolean"then
i.walls=b.walls
end
if SpiffBoy.isInteger(b.growth)and b.growth>=1 and b.growth<=al then
i.growth=b.growth
end
if SpiffBoy.isInteger(b.map)and b.map>=1 and b.map<=#am then
i.map=b.map
end
if type(b.bonus)=="boolean"then
i.bonus=b.bonus
end
return i
end

local function aK(rules)
local b=a0[rules.speed]*rules.growth*a4[rules.map]
if rules.walls then
b=b*a2
end
return b
end

local function u(column,row)
return row*g+column
end

local function bO()
local b={}
for i=0,g-1 do
b[#b+1]={i,0}
end
for i=1,j-1 do
b[#b+1]={g-1,i}
end
for i=g-2,0,-1 do
b[#b+1]={i,j-1}
end
for i=j-2,1,-1 do
b[#b+1]={0,i}
end
return b
end

local G=bO()

local function aL(position)
local b=G[position%#G+1]
return b[1],b[2]
end

local function H(dead)
return dead and aj or ai
end

local function v(value,count)
return(value-1+count)%count+1
end

local function w(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function aM(index)
return string.sub(bD,index,index)
end

local function p(screen)
screen:clear(h.r,h.g,h.b)
end

local function q(screen,label,x,y)
screen:text(label,x,y,a.r,a.g,a.b,1)
end

local function i(screen,label,x,y)
screen:textCentre(label,x,y,a.r,a.g,a.b,1)
end

local function I(screen,x,y,width,height)
screen:rect(x,y,width,height,a.r,a.g,a.b,1)
end

local function bP(save)
local n={}
local x=save.scores
if type(x)~="table"then
return n
end
for y=1,Z do
local b=x[y]
if type(b)=="table"and type(b.score)=="number"and type(b.initials)=="string"then
n[#n+1]={initials=string.sub(b.initials,1,E),score=math.floor(b.score)}
end
end
return n
end

local function bQ(save)
local n={music=k,effects=k}
local x=save.options
if type(x)~="table"then
return n
end
for O,y in ipairs(s)do
local b=x[y.key]
if SpiffBoy.isInteger(b)and b>=0 and b<=k then
n[y.key]=b
end
end
return n
end

local function aN(list,score)
if score<=0 then
return nil
end
for b=1,#list do
if score>list[b].score then
return b
end
end
if#list<Z then
return#list+1
end
return nil
end

function SpiffBoySerpentGame:init()
self.tiles=self.context.art("tiles")
self.logo=self.context.art("logo")
self.wrench=self.context.art("wrench")
self.highScores=bP(self.save)
self.mix=bQ(self.save)
self.mixDirty=false
self.rules=aJ(self.save)
self.rulesDirty=false
self.menuIndex=1
self.menuColumn=0
self.optionIndex=1
self.settingIndex=1
self.mode=o
self.clock=0
self.score=0
self:resetParade()
self:applyMix()
self.sequencer:play(m)
end

function SpiffBoySerpentGame:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function SpiffBoySerpentGame:keepRunMusic()
if self.sequencer:isPlaying()then
return
end
self.runBar=self.runBar+1
if self.runBar>aI then
self.runBar=bM+1
end
self.sequencer:play(aB..self.stepTicks.."_"..self.runBar)
end

function SpiffBoySerpentGame:applyMix()
self.sequencer:setMix(self.mix.music/k,self.mix.effects/k)
end

function SpiffBoySerpentGame:openOptions()
self.optionIndex=1
self.mode=K
end

function SpiffBoySerpentGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self.mode=o
end

function SpiffBoySerpentGame:turnOption(delta)
local b=s[self.optionIndex]
if not b.key then
return
end
local n=SpiffBoy.clamp(self.mix[b.key]+delta,0,k)
if n==self.mix[b.key]then
return
end
self.mix[b.key]=n
self.mixDirty=true
self:applyMix()
self.sequencer:effect(aF..n)
end

function SpiffBoySerpentGame:tickOptions(input)
if not input then
return
end
local b=input.pressed
local n=w(b)
if n~=0 then
self.optionIndex=v(self.optionIndex+n,#s)
self.sequencer:effect(l)
end
if b.left then
self:turnOption(-1)
elseif b.right then
self:turnOption(1)
end
if b.b or b.start then
self.sequencer:effect(f)
self:closeOptions()
elseif b.a then
self.sequencer:effect(f)
if s[self.optionIndex].action then
self:openConfirm("scores")
else
self:closeOptions()
end
end
end

function SpiffBoySerpentGame:openSettings()
self.settingIndex=1
self.mode=L
end

function SpiffBoySerpentGame:closeSettings()
if self.rulesDirty then
local b=self.rules
self.save.rules={speed=b.speed,walls=b.walls,growth=b.growth,map=b.map,bonus=b.bonus}
self:persist()
self.rulesDirty=false
end
self.mode=o
end

function SpiffBoySerpentGame:resetRules()
self.rules=aJ({})
self.rulesDirty=true
end

function SpiffBoySerpentGame:turnSetting(delta)
local b=A[self.settingIndex]
local n=self.rules
if b.action then
return
end
if b.texts then
n[b.key]=v(n[b.key]+delta,#b.texts)
elseif b.max then
n[b.key]=v(n[b.key]+delta,b.max)
else
n[b.key]=not n[b.key]
end
self.rulesDirty=true
self.sequencer:effect(l)
end

function SpiffBoySerpentGame:tickSettings(input)
if not input then
return
end
local b=input.pressed
local n=w(b)
if n~=0 then
self.settingIndex=v(self.settingIndex+n,#A)
self.sequencer:effect(l)
end
if b.left then
self:turnSetting(-1)
elseif b.right then
self:turnSetting(1)
end
if b.b or b.start then
self.sequencer:effect(f)
self:closeSettings()
elseif b.a then
self.sequencer:effect(f)
if A[self.settingIndex].action then
self:openConfirm("rules")
else
self:closeSettings()
end
end
end

function SpiffBoySerpentGame:settingValue(setting)
if setting.action then
return nil
end
local b=self.rules[setting.key]
if setting.texts then
return d(setting.texts[b])
end
if setting.max then
return"+"..tostring(b)
end
if b then
return d("Yes")
end
return d("No")
end

function SpiffBoySerpentGame:openConfirm(kind)
self.confirmKind=kind
self.confirmYes=false
self.mode=X
end

function SpiffBoySerpentGame:acceptConfirm()
if self.confirmKind=="scores"then
self:clearScores()
else
self:resetRules()
end
end

function SpiffBoySerpentGame:clearScores()
self.highScores={}
self.flashRankIndex=nil
self.save.scores={}
self:persist()
end

function SpiffBoySerpentGame:tickConfirm(input)
if not input then
return
end
local b=input.pressed
if b.left or b.right or b.up or b.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(l)
end
if b.b then
self.sequencer:effect(f)
self.mode=Y[self.confirmKind].back
elseif b.a or b.start then
self.sequencer:effect(f)
if self.confirmYes then
self:acceptConfirm()
end
self.mode=Y[self.confirmKind].back
end
end

function SpiffBoySerpentGame:resetParade()
self.paradeHead=ab-1
self.paradeLength=ab
self.paradeDead=false
self.paradeTimer=0
self:spawnParadeApple()
end

function SpiffBoySerpentGame:spawnParadeApple()
local b=#G
local n=b-self.paradeLength
if n<=0 then
self.paradeApple=nil
return
end
self.paradeApple=(self.paradeHead+1+self.random:int(0,n-1))%b
end

function SpiffBoySerpentGame:stepParade()
if self.paradeDead then
return
end
self.paradeTimer=self.paradeTimer+1
if self.paradeTimer<ae(aV,self.paradeLength-ab)then
return
end
self.paradeTimer=0
local b=#G
if self.paradeLength>=b then
self.paradeDead=true
return
end
self.paradeHead=(self.paradeHead+1)%b
if self.paradeHead==self.paradeApple then
self.paradeLength=self.paradeLength+1
self:spawnParadeApple()
end
end

function SpiffBoySerpentGame:startRun()
self.cellX={}
self.cellY={}
self.occupied={}
for b=1,z do
self.cellX[b]=0
self.cellY[b]=0
self.occupied[b-1]=false
end
self.head=0
self.length=0
self.trees=am[self.rules.map]
for b=1,#self.trees do
self.occupied[u(self.trees[b][1],self.trees[b][2])]=true
end
for b=aR-1,0,-1 do
self:pushHead(aS-b,aT)
end
self.dirX,self.dirY=1,0
self.turnX={}
self.turnY={}
for b=1,ap do
self.turnX[b]=0
self.turnY[b]=0
end
self.turnCount=0
self.stepTicks=ae(T[self.rules.speed],0)
self.stepTimer=self.stepTicks
self.foods=0
self.growth=0
self.level=1
self.multiplier=aK(self.rules)
self.dead=false
self.deadTick=0
self.score=0
self.bonusX=nil
self.bonusY=nil
self.bonusTimer=0
self.mode=V
self.paused=false
self.runBar=0
self:resetParade()
self:spawnFood()
self.sequencer:play(aC)
end

function SpiffBoySerpentGame:ringIndex(back)
return((self.head-back-1+z)%z)+1
end

function SpiffBoySerpentGame:pushHead(column,row)
self.head=self.head%z+1
self.cellX[self.head]=column
self.cellY[self.head]=row
self.occupied[u(column,row)]=true
self.length=self.length+1
end

function SpiffBoySerpentGame:popTail()
local b=self:ringIndex(self.length-1)
self.occupied[u(self.cellX[b],self.cellY[b])]=false
self.length=self.length-1
end

function SpiffBoySerpentGame:spawnFood()
for x=1,ao do
local b=self.random:int(0,g-1)
local n=self.random:int(0,j-1)
if not self.occupied[u(b,n)]then
self.foodX,self.foodY=b,n
return
end
end
for b=0,z-1 do
if not self.occupied[b]then
self.foodX=b%g
self.foodY=math.floor(b/g)
return
end
end
self:die()
end

function SpiffBoySerpentGame:queueTurn(dx,dy)
local b=self.turnCount
if b>=ap then
return
end
local n,x=self.dirX,self.dirY
if b>0 then
n,x=self.turnX[b],self.turnY[b]
end
if(dx==n and dy==x)or(dx==-n and dy==-x)then
return
end
b=b+1
self.turnX[b]=dx
self.turnY[b]=dy
self.turnCount=b
end

function SpiffBoySerpentGame:steer(input)
local n=input.pressed
for x=1,#aq do
local b=aq[x]
if n[b[1]]then
self:queueTurn(b[2],b[3])
end
end
end

function SpiffBoySerpentGame:applyTurn()
local n=self.turnCount
if n==0 then
return
end
self.dirX,self.dirY=self.turnX[1],self.turnY[1]
for b=1,n-1 do
self.turnX[b]=self.turnX[b+1]
self.turnY[b]=self.turnY[b+1]
end
self.turnCount=n-1
end

function SpiffBoySerpentGame:spawnBonus()
for x=1,ao do
local b=self.random:int(0,g-1)
local n=self.random:int(0,j-1)
if not self.occupied[u(b,n)]and not(b==self.foodX and n==self.foodY)then
self.bonusX,self.bonusY=b,n
self.bonusTimer=a6
return
end
end
end

function SpiffBoySerpentGame:clearBonus()
self.bonusX=nil
self.bonusY=nil
self.bonusTimer=0
end

function SpiffBoySerpentGame:step()
self:applyTurn()
local b=self.cellX[self.head]+self.dirX
local n=self.cellY[self.head]+self.dirY
if b<0 or b>=g or n<0 or n>=j then
if self.rules.walls then
self:die()
return
end
b=(b+g)%g
n=(n+j)%j
end
local x=b==self.foodX and n==self.foodY
if x then
self.growth=self.growth+self.rules.growth
end
if self.growth>0 then
self.growth=self.growth-1
else
self:popTail()
end
if self.occupied[u(b,n)]then
self:die()
return
end
self:pushHead(b,n)
if self.bonusX and b==self.bonusX and n==self.bonusY then
self.score=self.score+ba*self.level*self.multiplier
self:clearBonus()
self.sequencer:effect(ac)
end
if x then
self.foods=self.foods+1
self.score=self.score+self.level*self.multiplier
self.stepTicks=ae(T[self.rules.speed],self.foods)
if self.foods%ag==0 then
self.level=self.level+1
end
self.sequencer:effect(ac)
self:spawnFood()
if self.rules.bonus and self.foods%a5==0 then
self:spawnBonus()
end
end
end

function SpiffBoySerpentGame:die()
self.dead=true
self.deadTick=0
self.sequencer:stop()
self.sequencer:effect(aE)
end

function SpiffBoySerpentGame:endRun()
self.sequencer:play(aD)
if aN(self.highScores,self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=bd
return
end
self.mode=o
end

function SpiffBoySerpentGame:tick(inputs,tick)
self.clock=self.clock+1
local b=inputs[1]
if self.mode==o then
self:keepMusic(m)
self:stepParade()
self:tickTitle(b)
elseif self.mode==W then
self:keepMusic(m)
self:stepParade()
self:tickScores(b)
elseif self.mode==K then
self:keepMusic(m)
self:stepParade()
self:tickOptions(b)
elseif self.mode==X then
self:keepMusic(m)
self:stepParade()
self:tickConfirm(b)
elseif self.mode==L then
self:keepMusic(m)
self:stepParade()
self:tickSettings(b)
elseif self.mode==V then
if not self.dead then
self:keepRunMusic()
end
self:tickRun(b)
else
self:keepMusic(m)
self:tickInitials(b)
end
end

function SpiffBoySerpentGame:tickTitle(input)
if not input then
return
end
local b=input.pressed
local x=w(b)
if x~=0 then
self.menuIndex=v(self.menuIndex+x,#r)
self.menuColumn=0
self.sequencer:effect(l)
end
if r[self.menuIndex]=="Play"and(b.left or b.right)then
self.menuColumn=1-self.menuColumn
self.sequencer:effect(l)
end
if b.a or b.start then
local n=r[self.menuIndex]
if n=="Play"and self.menuColumn==1 then
self.sequencer:effect(f)
self:openSettings()
elseif n=="Play"then
self:startRun()
elseif n=="Options"then
self.sequencer:effect(f)
self:openOptions()
else
self.sequencer:effect(f)
self:showScores(1)
end
end
end

function SpiffBoySerpentGame:tickScores(input)
if not input then
return
end
local b=input.pressed
local n=w(b)
if n~=0 then
self:scrollScores(n)
elseif b.a or b.b or b.start then
self.sequencer:effect(f)
self.mode=o
end
end

function SpiffBoySerpentGame:tickRun(input)
if self.dead then
self.deadTick=self.deadTick+1
if self.deadTick>=aX then
self:endRun()
end
return
end
if input and input.pressed.start then
self.paused=not self.paused
self.sequencer:effect(f)
end
if self.paused then
return
end
if self.bonusTimer>0 then
self.bonusTimer=self.bonusTimer-1
if self.bonusTimer==0 then
self:clearBonus()
end
end
if input then
self:steer(input)
end
self.stepTimer=self.stepTimer-1
if self.stepTimer<=0 then
self.stepTimer=self.stepTicks
self:step()
end
end

function SpiffBoySerpentGame:turnLetter(step)
local b=self.cursor
self.letters[b]=v(self.letters[b]-step,bE)
self.sequencer:effect(l)
end

function SpiffBoySerpentGame:repeatLetter(pressedStep,heldStep)
if pressedStep~=0 then
self:turnLetter(pressedStep)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=bx
return
end
if heldStep==0 or heldStep~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(heldStep)
self.letterRepeatTimer=math.max(bz,by-math.floor(self.letterHoldTicks/bA))
end
end

function SpiffBoySerpentGame:tickInitials(input)
if not input then
return
end
local b=input.pressed
local n=self.cursor
self:repeatLetter(w(b),w(input.held))
if b.left and n>1 then
self.cursor=n-1
elseif b.right and n<E then
self.cursor=n+1
end
if b.a or b.start then
self.sequencer:effect(f)
if self.cursor<E then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoySerpentGame:saveScore()
local b=""
for n=1,E do
b=b..aM(self.letters[n])
end
local n=aN(self.highScores,self.score)
table.insert(self.highScores,n,{initials=b,score=self.score})
while#self.highScores>Z do
table.remove(self.highScores)
end
self.save.scores=self.highScores
self:persist()
self:showScores(n)
self:flashRank(n)
end

function SpiffBoySerpentGame:scoresRows()
local b=self.screen:lineHeight()
local n=D+b+bq
return n,math.floor((br-n)/b)
end

function SpiffBoySerpentGame:clampScoresTop(first)
local n,b=self:scoresRows()
return SpiffBoy.clamp(first,1,#self.highScores-b+1)
end

function SpiffBoySerpentGame:flashRank(rank)
self.flashRankIndex=rank
self.flashUntil=self.clock+az*bw*2
end

function SpiffBoySerpentGame:isRankInverted(rank)
if rank~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/az)%2==1
end

function SpiffBoySerpentGame:showScores(rank)
self.mode=W
self.scoresTop=self:clampScoresTop(rank)
end

function SpiffBoySerpentGame:scrollScores(rows)
local b=self:clampScoresTop(self.scoresTop+rows)
if b~=self.scoresTop then
self.scoresTop=b
self.sequencer:effect(l)
end
end

function SpiffBoySerpentGame:blinkOn()
return math.floor(self.clock/bF)%2==0
end

function SpiffBoySerpentGame:draw(screen)
if self.mode==o then
self:drawTitle(screen)
elseif self.mode==W then
self:drawScores(screen)
elseif self.mode==K then
self:drawOptions(screen)
elseif self.mode==X then
self:drawConfirm(screen)
elseif self.mode==L then
self:drawSettings(screen)
elseif self.mode==V then
self:drawRun(screen)
else
self:drawInitials(screen)
end
end

function SpiffBoySerpentGame:drawTile(screen,frame,x,y)
screen:layers(self.tiles,frame*c,c,c,x,y,aY[frame])
end

function SpiffBoySerpentGame:drawCell(screen,frame,column,row)
self:drawTile(screen,frame,af+column*c,row*c)
end

function SpiffBoySerpentGame:drawSerpent(screen,length,dead,cellAt)
for b=length-1,0,-1 do
local x,y=cellAt(b)
local n=ah
if b==0 then
n=H(dead)
end
self:drawCell(screen,n,x,y)
end
end

function SpiffBoySerpentGame:drawParade(screen)
if self.paradeApple then
local b,n=aL(self.paradeApple)
self:drawCell(screen,J,b,n)
end
local b=self.paradeHead+#G
self:drawSerpent(screen,self.paradeLength,self.paradeDead,function(back)
return aL(b-back)
end)
end

function SpiffBoySerpentGame:drawTitle(screen)
p(screen)
self:drawParade(screen)
local n=screen.width/2
screen:layers(self.logo,0,av,bk,n-math.floor(av/2),bl,bm)
local y=screen:lineHeight()
local O=math.floor(self.clock/M)%(C+1)
for b=1,#r do
local P=d(r[b])
local x=bn+(b-1)*bo
local aQ=x+math.floor((y-c)/2)
local Q=screen:textWidth(P)
local R=n-math.floor(Q/2)
i(screen,P,n,x)
local aO=R-c-B-O
if r[b]=="Play"then
local aP=R+Q+bp
screen:layers(self.wrench,0,S,S,aP,x+math.floor((y-S)/2),aZ)
if self.menuColumn==1 then
aO=aP-c-aw-O
end
end
if b==self.menuIndex then
self:drawTile(screen,H(self.paradeDead),aO,aQ)
end
end
end

function SpiffBoySerpentGame:drawSettings(screen)
p(screen)
self:drawParade(screen)
local O=screen:lineHeight()
q(screen,d("Settings"),U,D)
screen:textRight("x"..tostring(aK(self.rules)),an,D,a.r,a.g,a.b,1)
local P=math.floor(self.clock/M)%(C+1)
for b=1,#A do
local x=A[b]
local n=bb+(b-1)*bc
q(screen,d(x.text),U,n)
local y=self:settingValue(x)
if y then
screen:textRight(y,an,n,a.r,a.g,a.b,1)
end
if b==self.settingIndex then
self:drawTile(screen,H(self.paradeDead),U-c-B-P,n+math.floor((O-c)/2))
end
end
end

function SpiffBoySerpentGame:drawScores(screen)
p(screen)
self:drawParade(screen)
local b=screen.width/2
local n=screen:lineHeight()
i(screen,d("HighScores"),b,D)
local x,aO=self:scoresRows()
if#self.highScores==0 then
i(screen,d("NoScores"),b,x+n)
return
end
local aP=math.min(#self.highScores,self.scoresTop+aO-1)
for y=self.scoresTop,aP do
local aQ=self.highScores[y]
local O=x+(y-self.scoresTop)*n
local P,Q,R=a.r,a.g,a.b
if self:isRankInverted(y)then
I(screen,b+ay,O,bv-ay,n)
P,Q,R=h.r,h.g,h.b
end
screen:textRight(tostring(y)..".",b+bs,O,P,Q,R,1)
screen:text(aQ.initials,b+bt,O,P,Q,R,1)
screen:textRight(tostring(aQ.score),b+bu,O,P,Q,R,1)
end
if self.scoresTop>1 then
q(screen,bB,b+ax,x)
end
if aP<#self.highScores then
q(screen,bC,b+ax,x+(aO-1)*n)
end
end

function SpiffBoySerpentGame:drawBar(screen,x,y,value)
local b=k*_+(k-1)*as
I(screen,x-1,y-1,b+2,aa+2)
screen:rect(x,y,b,aa,h.r,h.g,h.b,1)
for n=1,value do
I(screen,x+(n-1)*(_+as),y,_,aa)
end
end

function SpiffBoySerpentGame:drawOptions(screen)
p(screen)
self:drawParade(screen)
local y=screen.width/2
local O=screen:lineHeight()
i(screen,d("Options"),y,D)
local P=math.floor(self.clock/M)%(C+1)
for b=1,#s do
local n=s[b]
local x=be+(b-1)*bf
q(screen,d(n.text),ar,x)
if n.key then
self:drawBar(screen,bg,x+bh,self.mix[n.key])
end
if b==self.optionIndex then
self:drawTile(screen,H(self.paradeDead),ar-c-B-P,x+math.floor((O-c)/2))
end
end
end

function SpiffBoySerpentGame:drawConfirm(screen)
p(screen)
self:drawParade(screen)
local n=screen.width/2
local x=screen:lineHeight()
local y=screen:wrapText(d(Y[self.confirmKind].text),bj)
for b=1,#y do
i(screen,y[b],n,bi+(b-1)*x)
end
local Q=math.floor(self.clock/M)%(C+1)
local O={{text="No",x=n-au,chosen=not self.confirmYes},{text="Yes",x=n+au,chosen=self.confirmYes}}
for R=1,#O do
local b=O[R]
local P=d(b.text)
i(screen,P,b.x,at)
if b.chosen then
local aO=b.x-math.floor(screen:textWidth(P)/2)-c-B-Q
self:drawTile(screen,H(self.paradeDead),aO,at+math.floor((x-c)/2))
end
end
end

function SpiffBoySerpentGame:drawInitials(screen)
p(screen)
local x=screen.width/2
local n=screen:lineHeight()
local b=6
i(screen,d("NewHighScore"),x,b)
b=b+n+n/2
i(screen,tostring(self.score),x,b)
b=b+n*1.5
i(screen,d("EnterInitials"),x,b)
b=b+n*1.5
for y=1,E do
local O=x+(y-2)*bG
i(screen,aM(self.letters[y]),O,b)
if y==self.cursor and self:blinkOn()then
I(screen,O-aA/2,b+n+1,aA,bH)
end
end
end

function SpiffBoySerpentGame:drawBanner(screen,label)
local O=screen:lineHeight()
local b=screen:textWidth(label)+N*2
local n=O+N*2
local x=math.floor((screen.width-b)/2)
local y=math.floor((screen.height-n)/2)
I(screen,x-1,y-1,b+2,n+2)
screen:rect(x,y,b,n,h.r,h.g,h.b,1)
q(screen,label,x+N,y+N)
end

function SpiffBoySerpentGame:bonusVisible()
local b=a8
if self.bonusTimer<=a7 then
b=a9
end
return math.floor(self.bonusTimer/b)%2==0
end

function SpiffBoySerpentGame:drawRun(screen)
p(screen)
for b=1,#self.trees do
self:drawCell(screen,ak,self.trees[b][1],self.trees[b][2])
end
self:drawCell(screen,J,self.foodX,self.foodY)
if self.bonusX and self:bonusVisible()then
self:drawCell(screen,J,self.bonusX,self.bonusY)
end
self:drawSerpent(screen,self.length,self.dead,function(back)
local b=self:ringIndex(back)
return self.cellX[b],self.cellY[b]
end)
local b=tostring(self.score)
q(screen,string.rep("0",aU-string.len(b))..b,af+2,2)
if self.dead then
self:drawBanner(screen,d("GameOver"))
elseif self.paused then
self:drawBanner(screen,getText("UI_SpiffBoy_Paused"))
end
end
