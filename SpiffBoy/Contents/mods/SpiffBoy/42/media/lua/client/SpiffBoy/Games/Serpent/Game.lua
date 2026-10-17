require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Core/Tunes"
require"SpiffBoy/Framework/GameTexts"

SpiffBoySerpentGame=SpiffBoyGameBase:derive("SpiffBoySerpentGame")

local c=8
local g=22
local j=15
local ag=2
local x=g*j
local aS=3
local aT=11
local aU=7
local aV=4
local h=SpiffBoy.Cartridges.SHADES[4]
local a=SpiffBoy.Cartridges.SHADES[1]
local aW=9
local aX=3
local ah=5
local aY=120
local ai=0
local aj=1
local I=2
local ak=3
local al=4
local aZ={
[ai]={1,2,3},
[aj]={1,4},
[I]={1,2,3},
[ak]={1,4},
[al]={1,2,3},
}
local T=12
local a_={1}
local U={11,9,7}
local a0={"Slow","Normal","Fast"}
local a1={1,2,3}
local a2=2
local am=3
local a3=2
local a4={"Standard","Grove","Forest"}
local a5={1,2,3}
local an={
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
local a6=5
local a7=360
local a8=120
local a9=16
local ba=6
local bb=5
local y={
{key="speed",text="Speed",texts=a0},
{key="walls",text="Walls"},
{key="growth",text="Growth",max=am},
{key="map",text="Map",texts=a4},
{key="bonus",text="BonusApple"},
{action="reset",text="ResetDefaults"},
}
local bc=28
local bd=14
local V=24
local ao=168
local ap=50
local aq=3
local ar={{"up",0,-1},{"down",0,1},{"left",-1,0},{"right",1,0}}
local o="title"
local W="run"
local be="initials"
local X="scores"
local J="options"
local Y="confirm"
local K="settings"
local Z={
scores={text="EraseScores",back=J},
rules={text="ResetConfirm",back=K},
}
local _=10
local r={"Play","HighScores","Options"}
local s={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local k=10
local bf=44
local bg=26
local as=24
local bh=98
local aa=6
local at=1
local ab=8
local bi=4
local bj=30
local bk=150
local au=84
local av=32
local aw=83
local bl=15
local bm=24
local bn={1,3}
local bo=56
local bp=18
local z=4
local L=15
local A=1
local ax=1
local bq=z+c+ax+A
local ac=9
local B=10
local br=4
local bs=112
local bt=-26
local bu=-22
local bv=38
local ay=46
local az=-44
local bw=42
local aA=15
local bx=4
local by=24
local bz=8
local bA=2
local bB=30
local bC=string.char(0x25B4)
local bD=string.char(0x25BE)
local M=4
local bE="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local bF=62
local C=3
local bG=30
local bH=20
local aB=12
local bI=2
local d=SpiffBoy.GameTexts.of("Serpent")
local m="title"
local aC="run"
local aD="start"
local aE="over"
local ad="eat"
local aF="lose"
local l="tick"
local f="confirm"
local aG="step"
local bJ={"c","d","e","f","g","a","b",">c",">d",">e",">f"}
local bK={[11]=76,[10]=84,[9]=92,[8]=104,[7]=116,[6]=128,[5]=140,[4]=154,[3]=168}

local ae={
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
[aD]={
pulse1="t170 @2 v12 y2 l16 o4 e g b >e8 r16 <b16 >e4^8",
pulse2={echo="pulse1",delay=16,drop=4},
},
[aE]={
pulse1="t120 @2 v12 y2 ~2,10,6 l8 o5 e e d c <b4. a8 | g+2 a4 r4 | <a2",
pulse2="t120 @2 v8 y2 l8 o4 >c c< b a g+4. f8 | e2 f4 r4 | e2",
wave="t120 @0 v3 l4 o2 a a e e | e e f f | a2",
},
[ad]={
noise="t240 l16 v13 y1 n{32 48 64} r v11 y1 n{40 56 72} r v9 y1 n{48 64 80}",
pulse2="t240 @2 v10 y1 l16 o3 c r <a r f r",
},
[aF]={
pulse1="t120 @2 v13 y4 s4,-6 o5 g2",
pulse2="t120 @1 v10 y3 l16 o5 e d+ d c+ c <b b- a a- g g- f",
noise="t120 l2 v9 y3 n{32 64 96 113}",
},
[l]={pulse2="t240 @1 v9 y1 l16 o5 g"},
[f]={pulse2="t200 @2 v10 y2 l16 o5 c e g"},
}

for b=0,k do
ae[aG..b]={pulse2="t240 @2 v10 y1 l16 o5 "..bJ[b+1]}
end

local D="v11 y1 n{48 80 113}"
local t="v8 y2 n64"
local aH="v4 y1 n80"
local aI=D.." r "..t.." r "..D.." r "..t.." r"
local e=D.." r "..t.." "..aH.." "..D.." r "..t.." "..aH
local bL=D.." r "..t.." r "..t.." n64 v9 y2 n64 n64"
local bM={
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
aI,aI,
e,e,e,e,
e,e,e,e,
e,e,e,e,
e,e,e,bL,
},
},
}
local aJ=18
local bN=2

local function bO(n,p)
local b={}
for q,i in pairs(bM)do
b[q]="t"..tostring(n).." "..i.header..i.bars[p]
end
return b
end

for i,n in pairs(bK)do
for b=1,aJ do
ae[aC..i.."_"..b]=bO(n,b)
end
end

SpiffBoy.Tunes.register("Serpent",ae)

local function af(b,i)
return math.max(aX,b-math.floor(i/ah))
end

local function aK(n)
local i={speed=a2,walls=true,growth=1,map=1,bonus=false}
local b=n.rules
if type(b)~="table"then
return i
end
if SpiffBoy.isInteger(b.speed)and b.speed>=1 and b.speed<=#U then
i.speed=b.speed
end
if type(b.walls)=="boolean"then
i.walls=b.walls
end
if SpiffBoy.isInteger(b.growth)and b.growth>=1 and b.growth<=am then
i.growth=b.growth
end
if SpiffBoy.isInteger(b.map)and b.map>=1 and b.map<=#an then
i.map=b.map
end
if type(b.bonus)=="boolean"then
i.bonus=b.bonus
end
return i
end

local function aL(b)
local i=a1[b.speed]*b.growth*a5[b.map]
if b.walls then
i=i*a3
end
return i
end

local function u(b,i)
return i*g+b
end

local function bP()
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

local E=bP()

local function aM(i)
local b=E[i%#E+1]
return b[1],b[2]
end

local function F(b)
return b and ak or aj
end

local function v(i,b)
return(i-1+b)%b+1
end

local function w(b)
if b.up then
return-1
elseif b.down then
return 1
end
return 0
end

local function aN(b)
return string.sub(bE,b,b)
end

local function p(b)
b:clear(h.r,h.g,h.b)
end

local function q(b,i,n,G)
b:text(i,n,G,a.r,a.g,a.b,1)
end

local function i(b,n,G,H)
b:textCentre(n,G,H,a.r,a.g,a.b,1)
end

local function G(b,n,H,N,O)
b:rect(n,H,N,O,a.r,a.g,a.b,1)
end

local function bQ(N)
local n={}
local H=N.scores
if type(H)~="table"then
return n
end
for O=1,_ do
local b=H[O]
if type(b)=="table"and type(b.score)=="number"and type(b.initials)=="string"then
n[#n+1]={initials=string.sub(b.initials,1,C),score=math.floor(b.score)}
end
end
return n
end

local function bR(O)
local n={music=k,effects=k}
local H=O.options
if type(H)~="table"then
return n
end
for P,N in ipairs(s)do
local b=H[N.key]
if SpiffBoy.isInteger(b)and b>=0 and b<=k then
n[N.key]=b
end
end
return n
end

local function aO(b,n)
if n<=0 then
return nil
end
for H=1,#b do
if n>b[H].score then
return H
end
end
if#b<_ then
return#b+1
end
return nil
end

function SpiffBoySerpentGame:init()
self.tiles=self.context.art("tiles")
self.logo=self.context.art("logo")
self.wrench=self.context.art("wrench")
self.highScores=bQ(self.save)
self.mix=bR(self.save)
self.mixDirty=false
self.rules=aK(self.save)
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

function SpiffBoySerpentGame:keepMusic(b)
if not self.sequencer:isPlaying()then
self.sequencer:play(b)
end
end

function SpiffBoySerpentGame:keepRunMusic()
if self.sequencer:isPlaying()then
return
end
self.runBar=self.runBar+1
if self.runBar>aJ then
self.runBar=bN+1
end
self.sequencer:play(aC..self.stepTicks.."_"..self.runBar)
end

function SpiffBoySerpentGame:applyMix()
self.sequencer:setMix(self.mix.music/k,self.mix.effects/k)
end

function SpiffBoySerpentGame:openOptions()
self.optionIndex=1
self.mode=J
end

function SpiffBoySerpentGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self.mode=o
end

function SpiffBoySerpentGame:turnOption(H)
local b=s[self.optionIndex]
if not b.key then
return
end
local n=SpiffBoy.clamp(self.mix[b.key]+H,0,k)
if n==self.mix[b.key]then
return
end
self.mix[b.key]=n
self.mixDirty=true
self:applyMix()
self.sequencer:effect(aG..n)
end

function SpiffBoySerpentGame:tickOptions(n)
if not n then
return
end
local b=n.pressed
local H=w(b)
if H~=0 then
self.optionIndex=v(self.optionIndex+H,#s)
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
self.mode=K
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
self.rules=aK({})
self.rulesDirty=true
end

function SpiffBoySerpentGame:turnSetting(H)
local b=y[self.settingIndex]
local n=self.rules
if b.action then
return
end
if b.texts then
n[b.key]=v(n[b.key]+H,#b.texts)
elseif b.max then
n[b.key]=v(n[b.key]+H,b.max)
else
n[b.key]=not n[b.key]
end
self.rulesDirty=true
self.sequencer:effect(l)
end

function SpiffBoySerpentGame:tickSettings(n)
if not n then
return
end
local b=n.pressed
local H=w(b)
if H~=0 then
self.settingIndex=v(self.settingIndex+H,#y)
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
if y[self.settingIndex].action then
self:openConfirm("rules")
else
self:closeSettings()
end
end
end

function SpiffBoySerpentGame:settingValue(b)
if b.action then
return nil
end
local n=self.rules[b.key]
if b.texts then
return d(b.texts[n])
end
if b.max then
return"+"..tostring(n)
end
if n then
return d("Yes")
end
return d("No")
end

function SpiffBoySerpentGame:openConfirm(b)
self.confirmKind=b
self.confirmYes=false
self.mode=Y
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

function SpiffBoySerpentGame:tickConfirm(n)
if not n then
return
end
local b=n.pressed
if b.left or b.right or b.up or b.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(l)
end
if b.b then
self.sequencer:effect(f)
self.mode=Z[self.confirmKind].back
elseif b.a or b.start then
self.sequencer:effect(f)
if self.confirmYes then
self:acceptConfirm()
end
self.mode=Z[self.confirmKind].back
end
end

function SpiffBoySerpentGame:resetParade()
self.paradeHead=ac-1
self.paradeLength=ac
self.paradeDead=false
self.paradeTimer=0
self:spawnParadeApple()
end

function SpiffBoySerpentGame:spawnParadeApple()
local b=#E
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
if self.paradeTimer<af(aW,self.paradeLength-ac)then
return
end
self.paradeTimer=0
local b=#E
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
for b=1,x do
self.cellX[b]=0
self.cellY[b]=0
self.occupied[b-1]=false
end
self.head=0
self.length=0
self.trees=an[self.rules.map]
for b=1,#self.trees do
self.occupied[u(self.trees[b][1],self.trees[b][2])]=true
end
for b=aS-1,0,-1 do
self:pushHead(aT-b,aU)
end
self.dirX,self.dirY=1,0
self.turnX={}
self.turnY={}
for b=1,aq do
self.turnX[b]=0
self.turnY[b]=0
end
self.turnCount=0
self.stepTicks=af(U[self.rules.speed],0)
self.stepTimer=self.stepTicks
self.foods=0
self.growth=0
self.level=1
self.multiplier=aL(self.rules)
self.dead=false
self.deadTick=0
self.score=0
self.bonusX=nil
self.bonusY=nil
self.bonusTimer=0
self.mode=W
self.paused=false
self.runBar=0
self:resetParade()
self:spawnFood()
self.sequencer:play(aD)
end

function SpiffBoySerpentGame:ringIndex(b)
return((self.head-b-1+x)%x)+1
end

function SpiffBoySerpentGame:pushHead(b,n)
self.head=self.head%x+1
self.cellX[self.head]=b
self.cellY[self.head]=n
self.occupied[u(b,n)]=true
self.length=self.length+1
end

function SpiffBoySerpentGame:popTail()
local b=self:ringIndex(self.length-1)
self.occupied[u(self.cellX[b],self.cellY[b])]=false
self.length=self.length-1
end

function SpiffBoySerpentGame:spawnFood()
for H=1,ap do
local b=self.random:int(0,g-1)
local n=self.random:int(0,j-1)
if not self.occupied[u(b,n)]then
self.foodX,self.foodY=b,n
return
end
end
for b=0,x-1 do
if not self.occupied[b]then
self.foodX=b%g
self.foodY=math.floor(b/g)
return
end
end
self:die()
end

function SpiffBoySerpentGame:queueTurn(n,H)
local b=self.turnCount
if b>=aq then
return
end
local N,O=self.dirX,self.dirY
if b>0 then
N,O=self.turnX[b],self.turnY[b]
end
if(n==N and H==O)or(n==-N and H==-O)then
return
end
b=b+1
self.turnX[b]=n
self.turnY[b]=H
self.turnCount=b
end

function SpiffBoySerpentGame:steer(n)
local H=n.pressed
for N=1,#ar do
local b=ar[N]
if H[b[1]]then
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
for H=1,ap do
local b=self.random:int(0,g-1)
local n=self.random:int(0,j-1)
if not self.occupied[u(b,n)]and not(b==self.foodX and n==self.foodY)then
self.bonusX,self.bonusY=b,n
self.bonusTimer=a7
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
local H=b==self.foodX and n==self.foodY
if H then
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
self.score=self.score+bb*self.level*self.multiplier
self:clearBonus()
self.sequencer:effect(ad)
end
if H then
self.foods=self.foods+1
self.score=self.score+self.level*self.multiplier
self.stepTicks=af(U[self.rules.speed],self.foods)
if self.foods%ah==0 then
self.level=self.level+1
end
self.sequencer:effect(ad)
self:spawnFood()
if self.rules.bonus and self.foods%a6==0 then
self:spawnBonus()
end
end
end

function SpiffBoySerpentGame:die()
self.dead=true
self.deadTick=0
self.sequencer:stop()
self.sequencer:effect(aF)
end

function SpiffBoySerpentGame:endRun()
self.sequencer:play(aE)
if aO(self.highScores,self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=be
return
end
self.mode=o
end

function SpiffBoySerpentGame:tick(n,H)
self.clock=self.clock+1
local b=n[1]
if self.mode==o then
self:keepMusic(m)
self:stepParade()
self:tickTitle(b)
elseif self.mode==X then
self:keepMusic(m)
self:stepParade()
self:tickScores(b)
elseif self.mode==J then
self:keepMusic(m)
self:stepParade()
self:tickOptions(b)
elseif self.mode==Y then
self:keepMusic(m)
self:stepParade()
self:tickConfirm(b)
elseif self.mode==K then
self:keepMusic(m)
self:stepParade()
self:tickSettings(b)
elseif self.mode==W then
if not self.dead then
self:keepRunMusic()
end
self:tickRun(b)
else
self:keepMusic(m)
self:tickInitials(b)
end
end

function SpiffBoySerpentGame:tickTitle(H)
if not H then
return
end
local b=H.pressed
local N=w(b)
if N~=0 then
self.menuIndex=v(self.menuIndex+N,#r)
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

function SpiffBoySerpentGame:tickScores(n)
if not n then
return
end
local b=n.pressed
local H=w(b)
if H~=0 then
self:scrollScores(H)
elseif b.a or b.b or b.start then
self.sequencer:effect(f)
self.mode=o
end
end

function SpiffBoySerpentGame:tickRun(b)
if self.dead then
self.deadTick=self.deadTick+1
if self.deadTick>=aY then
self:endRun()
end
return
end
if b and b.pressed.start then
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
if b then
self:steer(b)
end
self.stepTimer=self.stepTimer-1
if self.stepTimer<=0 then
self.stepTimer=self.stepTicks
self:step()
end
end

function SpiffBoySerpentGame:turnLetter(n)
local b=self.cursor
self.letters[b]=v(self.letters[b]-n,bF)
self.sequencer:effect(l)
end

function SpiffBoySerpentGame:repeatLetter(b,n)
if b~=0 then
self:turnLetter(b)
self.letterHoldStep=b
self.letterHoldTicks=0
self.letterRepeatTimer=by
return
end
if n==0 or n~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(n)
self.letterRepeatTimer=math.max(bA,bz-math.floor(self.letterHoldTicks/bB))
end
end

function SpiffBoySerpentGame:tickInitials(H)
if not H then
return
end
local b=H.pressed
local n=self.cursor
self:repeatLetter(w(b),w(H.held))
if b.left and n>1 then
self.cursor=n-1
elseif b.right and n<C then
self.cursor=n+1
end
if b.a or b.start then
self.sequencer:effect(f)
if self.cursor<C then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoySerpentGame:saveScore()
local b=""
for n=1,C do
b=b..aN(self.letters[n])
end
local n=aO(self.highScores,self.score)
table.insert(self.highScores,n,{initials=b,score=self.score})
while#self.highScores>_ do
table.remove(self.highScores)
end
self.save.scores=self.highScores
self:persist()
self:showScores(n)
self:flashRank(n)
end

function SpiffBoySerpentGame:scoresRows()
local b=self.screen:lineHeight()
local n=B+b+br
return n,math.floor((bs-n)/b)
end

function SpiffBoySerpentGame:clampScoresTop(b)
local H,n=self:scoresRows()
return SpiffBoy.clamp(b,1,#self.highScores-n+1)
end

function SpiffBoySerpentGame:flashRank(b)
self.flashRankIndex=b
self.flashUntil=self.clock+aA*bx*2
end

function SpiffBoySerpentGame:isRankInverted(b)
if b~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/aA)%2==1
end

function SpiffBoySerpentGame:showScores(b)
self.mode=X
self.scoresTop=self:clampScoresTop(b)
end

function SpiffBoySerpentGame:scrollScores(n)
local b=self:clampScoresTop(self.scoresTop+n)
if b~=self.scoresTop then
self.scoresTop=b
self.sequencer:effect(l)
end
end

function SpiffBoySerpentGame:blinkOn()
return math.floor(self.clock/bG)%2==0
end

function SpiffBoySerpentGame:draw(b)
if self.mode==o then
self:drawTitle(b)
elseif self.mode==X then
self:drawScores(b)
elseif self.mode==J then
self:drawOptions(b)
elseif self.mode==Y then
self:drawConfirm(b)
elseif self.mode==K then
self:drawSettings(b)
elseif self.mode==W then
self:drawRun(b)
else
self:drawInitials(b)
end
end

function SpiffBoySerpentGame:drawTile(n,b,H,N)
n:layers(self.tiles,b*c,c,c,H,N,aZ[b])
end

function SpiffBoySerpentGame:drawCell(b,n,H,N)
self:drawTile(b,n,ag+H*c,N*c)
end

function SpiffBoySerpentGame:drawSerpent(H,N,O,P)
for b=N-1,0,-1 do
local Q,R=P(b)
local n=ai
if b==0 then
n=F(O)
end
self:drawCell(H,n,Q,R)
end
end

function SpiffBoySerpentGame:drawParade(b)
if self.paradeApple then
local n,H=aM(self.paradeApple)
self:drawCell(b,I,n,H)
end
local n=self.paradeHead+#E
self:drawSerpent(b,self.paradeLength,self.paradeDead,function(H)
return aM(n-H)
end)
end

function SpiffBoySerpentGame:drawTitle(b)
p(b)
self:drawParade(b)
local H=b.width/2
b:layers(self.logo,0,aw,bl,H-math.floor(aw/2),bm,bn)
local O=b:lineHeight()
local P=math.floor(self.clock/L)%(A+1)
for n=1,#r do
local Q=d(r[n])
local N=bo+(n-1)*bp
local aR=N+math.floor((O-c)/2)
local R=b:textWidth(Q)
local S=H-math.floor(R/2)
i(b,Q,H,N)
local aP=S-c-z-P
if r[n]=="Play"then
local aQ=S+R+bq
b:layers(self.wrench,0,T,T,aQ,N+math.floor((O-T)/2),a_)
if self.menuColumn==1 then
aP=aQ-c-ax-P
end
end
if n==self.menuIndex then
self:drawTile(b,F(self.paradeDead),aP,aR)
end
end
end

function SpiffBoySerpentGame:drawSettings(b)
p(b)
self:drawParade(b)
local P=b:lineHeight()
q(b,d("Settings"),V,B)
b:textRight("x"..tostring(aL(self.rules)),ao,B,a.r,a.g,a.b,1)
local Q=math.floor(self.clock/L)%(A+1)
for n=1,#y do
local N=y[n]
local H=bc+(n-1)*bd
q(b,d(N.text),V,H)
local O=self:settingValue(N)
if O then
b:textRight(O,ao,H,a.r,a.g,a.b,1)
end
if n==self.settingIndex then
self:drawTile(b,F(self.paradeDead),V-c-z-Q,H+math.floor((P-c)/2))
end
end
end

function SpiffBoySerpentGame:drawScores(b)
p(b)
self:drawParade(b)
local n=b.width/2
local H=b:lineHeight()
i(b,d("HighScores"),n,B)
local N,aP=self:scoresRows()
if#self.highScores==0 then
i(b,d("NoScores"),n,N+H)
return
end
local aQ=math.min(#self.highScores,self.scoresTop+aP-1)
for O=self.scoresTop,aQ do
local aR=self.highScores[O]
local P=N+(O-self.scoresTop)*H
local Q,R,S=a.r,a.g,a.b
if self:isRankInverted(O)then
G(b,n+az,P,bw-az,H)
Q,R,S=h.r,h.g,h.b
end
b:textRight(tostring(O)..".",n+bt,P,Q,R,S,1)
b:text(aR.initials,n+bu,P,Q,R,S,1)
b:textRight(tostring(aR.score),n+bv,P,Q,R,S,1)
end
if self.scoresTop>1 then
q(b,bC,n+ay,N)
end
if aQ<#self.highScores then
q(b,bD,n+ay,N+(aP-1)*H)
end
end

function SpiffBoySerpentGame:drawBar(b,n,H,O)
local N=k*aa+(k-1)*at
G(b,n-1,H-1,N+2,ab+2)
b:rect(n,H,N,ab,h.r,h.g,h.b,1)
for P=1,O do
G(b,n+(P-1)*(aa+at),H,aa,ab)
end
end

function SpiffBoySerpentGame:drawOptions(b)
p(b)
self:drawParade(b)
local O=b.width/2
local P=b:lineHeight()
i(b,d("Options"),O,B)
local Q=math.floor(self.clock/L)%(A+1)
for n=1,#s do
local H=s[n]
local N=bf+(n-1)*bg
q(b,d(H.text),as,N)
if H.key then
self:drawBar(b,bh,N+bi,self.mix[H.key])
end
if n==self.optionIndex then
self:drawTile(b,F(self.paradeDead),as-c-z-Q,N+math.floor((P-c)/2))
end
end
end

function SpiffBoySerpentGame:drawConfirm(b)
p(b)
self:drawParade(b)
local H=b.width/2
local N=b:lineHeight()
local O=b:wrapText(d(Z[self.confirmKind].text),bk)
for n=1,#O do
i(b,O[n],H,bj+(n-1)*N)
end
local R=math.floor(self.clock/L)%(A+1)
local P={{text="No",x=H-av,chosen=not self.confirmYes},{text="Yes",x=H+av,chosen=self.confirmYes}}
for S=1,#P do
local n=P[S]
local Q=d(n.text)
i(b,Q,n.x,au)
if n.chosen then
local aP=n.x-math.floor(b:textWidth(Q)/2)-c-z-R
self:drawTile(b,F(self.paradeDead),aP,au+math.floor((N-c)/2))
end
end
end

function SpiffBoySerpentGame:drawInitials(n)
p(n)
local N=n.width/2
local H=n:lineHeight()
local b=6
i(n,d("NewHighScore"),N,b)
b=b+H+H/2
i(n,tostring(self.score),N,b)
b=b+H*1.5
i(n,d("EnterInitials"),N,b)
b=b+H*1.5
for O=1,C do
local P=N+(O-2)*bH
i(n,aN(self.letters[O]),P,b)
if O==self.cursor and self:blinkOn()then
G(n,P-aB/2,b+H+1,aB,bI)
end
end
end

function SpiffBoySerpentGame:drawBanner(b,P)
local Q=b:lineHeight()
local n=b:textWidth(P)+M*2
local H=Q+M*2
local N=math.floor((b.width-n)/2)
local O=math.floor((b.height-H)/2)
G(b,N-1,O-1,n+2,H+2)
b:rect(N,O,n,H,h.r,h.g,h.b,1)
q(b,P,N+M,O+M)
end

function SpiffBoySerpentGame:bonusVisible()
local b=a9
if self.bonusTimer<=a8 then
b=ba
end
return math.floor(self.bonusTimer/b)%2==0
end

function SpiffBoySerpentGame:drawRun(b)
p(b)
for n=1,#self.trees do
self:drawCell(b,al,self.trees[n][1],self.trees[n][2])
end
self:drawCell(b,I,self.foodX,self.foodY)
if self.bonusX and self:bonusVisible()then
self:drawCell(b,I,self.bonusX,self.bonusY)
end
self:drawSerpent(b,self.length,self.dead,function(H)
local n=self:ringIndex(H)
return self.cellX[n],self.cellY[n]
end)
local n=tostring(self.score)
q(b,string.rep("0",aV-string.len(n))..n,ag+2,2)
if self.dead then
self:drawBanner(b,d("GameOver"))
elseif self.paused then
self:drawBanner(b,getText("UI_SpiffBoy_Paused"))
end
end
