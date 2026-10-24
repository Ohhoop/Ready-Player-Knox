require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/DoubleRaccoon/Combat"
require"SpiffBoy/Games/DoubleRaccoon/Stage"
require"SpiffBoy/Games/DoubleRaccoon/Scenery"
require"SpiffBoy/Games/DoubleRaccoon/Fighter"
require"SpiffBoy/Games/DoubleRaccoon/Horde"
require"SpiffBoy/Games/DoubleRaccoon/Records"
require"SpiffBoy/Games/DoubleRaccoon/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyDoubleRaccoonGame=SpiffBoyGameBase:derive("SpiffBoyDoubleRaccoonGame")

local c=SpiffBoyDoubleRaccoonGame
local n=SpiffBoy.DoubleRaccoon
local av=n.Combat
local i=n.Stage
local J=n.Scenery
local A=n.Fighter
local K=n.Horde
local L=n.Records
local j=n.Music

local e=SpiffBoy.Cartridges.SHADES[4]
local f=SpiffBoy.Cartridges.SHADES[1]
local M=SpiffBoy.Cartridges.SHADES
local k=SpiffBoy.Cartridges.SCREEN_WIDTH
local B=SpiffBoy.Cartridges.SCREEN_HEIGHT
local m=SpiffBoy.GameTexts.of("DoubleRaccoon")
c.gameText=m

local s=J.GROUND_Y+4
local q={1,2,3,4}
local Y={3}
local l={width=52,height=50,anchor=26}
local C={width=65,height=62,anchor=32}
local Z={idle1=1,idle2=2,walk1=3,walk2=4,walk3=5,walk4=6,jab=7,cross=8,kick=9,hurt=10,swing1=11,swing2=12,hold=13,throw=14,elbow=15,pickup=16,down=17,fall=18}
local _=18
local aa={index={walk1=1,walk2=2,walk3=3,walk4=4,grab=5,bite=6,hurt=7,fall=8,down=9,charge=5},count=9}
local ab={index={walk1=1,walk2=2,walk3=3,walk4=4,grab=5,bite=6,hurt=7,fall=8,down=9,charge=10},count=10}
local N={
lumberjack={sheet="boss_lumberjack",frame=C},
linebacker={sheet="boss_linebacker",frame=C},
riot={sheet="boss_riot",frame=C},
evil={sheet="boss_evil",frame=l},
}
local g={cell=32,grip=16,gripLeft=15,angles=3,count=9,order={bat=0,pan=1,axe=2},upright=2,flat=1,restFlat={bat=true}}
local ac={
idle1={32,38,2},idle2={32,39,2},walk1={20,37,2},walk2={25,39,2},walk3={32,37,2},walk4={27,39,2},
jab={43,29,1},cross={32,32,2},kick={31,31,2},hurt={22,29,2},swing1={21,20,3},swing2={40,32,1},
hold={39,30,1},throw={37,21,2},elbow={32,32,2},pickup={34,47,1},
}
local t={chips=0,tin=12,width=12,height=10}
local D={width=18,height=5}
local ad=40
local E=24
local ae=-30
local af=40
local ag=70
local ah=10
local ai=6
local aj=8
local ak=3
local al=150
local d={ticks=150,drop=30,develop=50,left=5,top=4,width=170,height=113,margin=6,imageHeight=72,shadow=4,stageY=79,nameY=95}
local am=180
local F=15
local an=240
local O=600
local ao=180
local r={y=20,height=42,title=4,score=22}
local ap=150
local aq=9
local ar=60
local as=100
local P={{-1,0},{1,0},{0,-1},{0,1}}
local h={headX=3,headY=3,livesX=14,textY=-3,barX=26,barY=3,barWidth=50,barHeight=6,bossX=124,bossY=14,scoreX=177}

c.MODE_TITLE="title"
c.MODE_SETUP="setup"
c.MODE_OPTIONS="options"
c.MODE_CONFIRM="confirm"
c.MODE_SCORES="scores"
c.MODE_RUN="run"
c.MODE_CONTINUE="continue"
c.MODE_INITIALS="initials"

local G="photo"
local Q="intro"
local R="play"
local H="clear"
local S="over"
local I="ending"

local function T(screen)
screen:clear(e.r,e.g,e.b)
end

local function u(screen,label,x,y)
for b,a in ipairs(P)do
screen:textCentre(label,x+a[1],y+a[2],e.r,e.g,e.b,1)
end
screen:textCentre(label,x,y,f.r,f.g,f.b,1)
end

local function U(screen,label,x,y)
for b,a in ipairs(P)do
screen:textRight(label,x+a[1],y+a[2],e.r,e.g,e.b,1)
end
screen:textRight(label,x,y,f.r,f.g,f.b,1)
end
c.haloCentre=u

function c:init()
local a=self.context.art
self.spiffo=a("spiffo")
self.bandArt={}
for o,b in ipairs(i.DIFFICULTIES)do
self.bandArt[b.key]=a("spiffo_"..b.key)
end
self.selectSpiffo=a("select_spiffo")
self.headbands=a("headbands")
self.selectStage=a("select_stage")
self.zombieSheets={}
for b,o in pairs(K.KINDS)do
if o.boss then
self.zombieSheets[b]=a(N[b].sheet)
else
self.zombieSheets[b]=a("zombie_"..b)
end
end
self.weapons=a("weapons")
self.food=a("food")
self.shadow=a("shadow")
self.hudHead=a("hud_head")
self.logo=a("logo")
self.titleHead=a("title_head")
self.sceneries={}
for b,o in ipairs(i.LIST)do
self.sceneries[b]=J.new(a,o.scenery)
end
self.records=L.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
end

function c:applyMix()
self.sequencer:setMix(self.mix.music/j.MIX_STEPS,self.mix.effects/j.MIX_STEPS)
end

function c:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function c:persistRecords()
self.save.records=L.write(self.records)
self:persist()
end

function c:chosenDifficulty()
return i.DIFFICULTIES[self.setup.difficulty]
end

function c:tick(inputs,tick)
self.clock=self.clock+1
local a=inputs[1]
if self.mode==c.MODE_RUN then
self:tickRun(a)
else
self:tickMenu(a)
end
end

function c:startRun()
self.difficulty=self:chosenDifficulty()
self.difficultyKey=self.difficulty.key
self.fighterArt=self.bandArt[self.difficultyKey]
self.lives=self.difficulty.lives
self.score=0
self.mode=c.MODE_RUN
self:startStage(1)
end

function c:startStage(index)
local a=i.LIST[index]
self.stageIndex=index
self.definition=a
self.scenery=self.sceneries[index]
self.stage=i.new(a,self.difficulty)
self.horde=K.new()
self.fighter=A.new(ae,E)
self.camera=0
self.left=0
self.right=i.VIEW
self.items={}
for p,b in ipairs(a.items)do
local o=A.WEAPONS[b.kind]
self.items[#self.items+1]={kind=b.kind,x=b.x,z=b.z,durability=o and o.durability or 0}
end
self.sparks={}
self.goTimer=0
self.bossStarted=false
self.paused=false
self.phase=G
self.phaseTimer=d.ticks
self.sequencer:stop()
self.music=j.STAGE[a.music]
end

function c:effect(name)
self.sequencer:effect(name)
end

function c:addScore(points)
self.score=self.score+points
end

function c:spark(x,z,height)
self.sparks[#self.sparks+1]={x=x,z=z,height=height,timer=aj}
end

function c:itemAt(fighter)
for b,a in ipairs(self.items)do
if math.abs(a.x-fighter.x)<=ah and math.abs(a.z-fighter.z)<=ai then
return b
end
end
return nil
end

function c:takeItem(fighter)
local a=self:itemAt(fighter)
if not a then
return nil
end
return table.remove(self.items,a)
end

function c:dropWeapon(kind,durability,x,z)
self.items[#self.items+1]={kind=kind,x=x,z=z,durability=durability}
end

function c:lifeLost()
self.lives=self.lives-1
if self.lives>0 then
self.fighter:respawn()
return
end
self.sequencer:stop()
self.mode=c.MODE_CONTINUE
self.continueCount=aq
self.continueTimer=ar
self.continueYes=true
end

function c:continueRun()
self.score=0
self.lives=self.difficulty.lives
self.mode=c.MODE_RUN
self:startStage(self.stageIndex)
end

function c:nextStage()
if self.stageIndex<#i.LIST then
self:startStage(self.stageIndex+1)
return
end
self.phase=I
self.phaseTimer=O
self.sequencer:stop()
self.sequencer:play(j.ENDING)
end

function c:tickClear()
self.horde:update(self.fighter,self)
local a=self.stageIndex==#i.LIST
local b=a and self.camera+k/2 or self.camera+i.VIEW+af
self.fighter:walkTo(b,self.fighter.z)
self.phaseTimer=self.phaseTimer-1
local o=a or self.fighter.x-self.camera>=i.VIEW+l.anchor
if o and self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextStage()
end
end

function c:tickEnding(input)
self.horde:update(self.fighter,self)
self.fighter:walkTo(self.camera+k/2,E)
self.phaseTimer=self.phaseTimer-1
local a=input and(input.pressed.a or input.pressed.start)and self.phaseTimer<O-ao
if a or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
end

function c:gameOver()
self.mode=c.MODE_RUN
self.phase=S
self.phaseTimer=ap
self.sequencer:play(j.OVER)
end

function c:tickRun(input)
local a=self.phase
if a==G then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer==d.ticks-d.develop then
self:effect(j.SHUTTER)
end
if self.phaseTimer<=0 then
self.phase=Q
self.phaseTimer=al
end
elseif a==Q then
self.fighter:walkTo(ad,E)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=R
end
elseif a==R then
if input and input.pressed.start then
self.paused=not self.paused
self:effect(j.CONFIRM)
end
if not self.paused then
self:tickFight(input)
end
elseif a==H then
self:tickClear()
elseif a==I then
self:tickEnding(input)
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function c:tickFight(input)
if not self.bossStarted then
self:keepMusic(self.music)
elseif self.definition.finalMusic then
self:keepMusic(j.FINAL)
else
self:keepMusic(j.BOSS)
end
self.fighter:update(input,self)
if self.mode~=c.MODE_RUN then
return
end
self:moveCamera()
self:runZones()
self.horde:update(self.fighter,self)
self:checkBoss()
for b=#self.sparks,1,-1 do
local a=self.sparks[b]
a.timer=a.timer-1
if a.timer<=0 then
table.remove(self.sparks,b)
end
end
if self.goTimer>0 then
self.goTimer=self.goTimer-1
if self.goTimer%(F*2)==F*2-1 then
self:effect(j.GO)
end
end
end

function c:moveCamera()
local a=math.min(self.stage:cameraLimit(),self.definition.length-i.VIEW)
local b=math.min(self.fighter.x-ag,a)
self.camera=math.max(self.camera,math.floor(b))
self.left=self.camera
self.right=self.camera+i.VIEW
end

function c:runZones()
local a=self.stage
a:reach(self.camera)
local b=a:nextWave(self.horde:aliveCount())
if b then
for o,p in ipairs(b)do
local v=o%2==0 and-1 or 1
self.horde:spawn(p,v,self)
end
end
if a:release(self.horde:aliveCount())then
self.goTimer=am
end
end

function c:checkBoss()
if not self.bossStarted then
if self.stage:atBoss(self.camera)then
self.bossStarted=true
self.horde:spawn(self.definition.boss.kind,1,self)
self.sequencer:stop()
self.goTimer=0
end
return
end
local a=self.horde.boss
if not a or a.state=="dying"then
self.horde:killAll(self)
self:addScore(self.fighter.hp*as)
self.phase=H
self.phaseTimer=an
self.sequencer:stop()
self.sequencer:play(j.CLEAR)
end
end

function c:screenX(x)
return math.floor(x-self.camera)
end

function c:drawShadow(screen,x,z)
screen:layers(self.shadow,0,D.width,D.height,self:screenX(x)-D.width/2,s+z-2,Y)
end

function c:drawItem(screen,item)
local a=self:screenX(item.x)
local b=s+item.z
local o=g.order[item.kind]
if o then
screen:layers(self.weapons,o*g.angles*g.cell,g.cell,g.cell,a-g.grip,b-g.grip-2,q)
else
screen:layers(self.food,t[item.kind],t.width,t.height,a-t.width/2,b-t.height,q)
end
end

function c:drawFighter(screen)
local a=self.fighter
if a:blinking()then
return
end
local w=a:frame()
local x=a.facing<0
local W=Z[w]-1+(x and _ or 0)
local y=self:screenX(a.x)-l.anchor
local z=s+math.floor(a.z)-(l.height-1)
screen:layers(self.fighterArt,W*l.width,l.width,l.height,y,z,q)
local b=ac[w]
if a.weapon and b then
local o=b[3]
if o==g.upright and g.restFlat[a.weapon]then
o=g.flat
end
local p=g.order[a.weapon]*g.angles+o-1
local v=b[1]
local V=g.grip
if x then
p=p+g.count
v=l.width-1-v
V=g.gripLeft
end
screen:layers(self.weapons,p*g.cell,g.cell,g.cell,y+v-V,z+b[2]-g.grip,q)
end
end

function c:drawZombie(screen,zombie)
if zombie:blinking()then
return
end
local o,p=zombie:frame()
local a=zombie.isBoss and N[zombie.kind].frame or l
local b=zombie.isBoss and ab or aa
local v=self.zombieSheets[zombie.kind]
local w=b.index[o]-1+(zombie.facing<0 and b.count or 0)
local x=self:screenX(zombie.x)-a.anchor+p
local y=s+math.floor(zombie.z)-(a.height-1)-math.floor(zombie.height)
screen:layers(v,w*a.width,a.width,a.height,x,y,q)
end

local at={}
local v=nil

local function au(a,b)
if a.z~=b.z then
return a.z<b.z
end
if a==v or b==v then
return b==v
end
return a.id<b.id
end

function c:drawActors(screen)
for b,a in ipairs(self.items)do
self:drawItem(screen,a)
end
local a=at
local y=#a
a[1]=self.fighter
local b=1
for p,o in ipairs(self.horde.zombies)do
b=b+1
a[b]=o
end
for o=b+1,y do
a[o]=nil
end
v=self.fighter
table.sort(a,au)
for p,o in ipairs(a)do
self:drawShadow(screen,o.x,o.z)
end
for p,o in ipairs(a)do
if o==self.fighter then
self:drawFighter(screen)
else
self:drawZombie(screen,o)
end
end
for z,o in ipairs(self.sparks)do
local w=self:screenX(o.x)
local x=s+math.floor(o.z)-30-math.floor(o.height)
local p=ak+math.floor(o.timer/3)
screen:rect(w-p,x,p*2+1,1,f.r,f.g,f.b,1)
screen:rect(w,x-p,1,p*2+1,f.r,f.g,f.b,1)
end
end

local function z(screen,x,y,width,height,share)
screen:rect(x,y,width,height,f.r,f.g,f.b,1)
screen:rect(x+1,y+1,width-2,height-2,e.r,e.g,e.b,1)
screen:rect(x+1,y+1,math.floor((width-2)*share),height-2,f.r,f.g,f.b,1)
end

function c:drawHud(screen)
screen:layers(self.hudHead,0,9,8,h.headX,h.headY,q)
u(screen,tostring(self.lives),h.livesX+4,h.textY)
z(screen,h.barX,h.barY,h.barWidth,h.barHeight,self.fighter.hp/A.MAX_HP)
U(screen,tostring(self.score),h.scoreX,h.textY)
local a=self.horde.boss
if a and a.state~="enter"then
z(screen,h.bossX,h.bossY,h.barWidth,h.barHeight,math.max(0,a.hp)/a.stats.hp)
end
end

function c:drawRun(screen)
if self.phase==G then
self:drawPhoto(screen)
return
end
T(screen)
self.scenery:drawBack(screen,self.camera)
self:drawActors(screen)
self.scenery:drawFront(screen,self.camera)
self:drawHud(screen)
local a=k/2
if self.paused then
u(screen,getText("UI_SpiffBoy_Paused"),a,44)
elseif self.phase==H then
u(screen,m("StageClear"),a,44)
elseif self.phase==S then
u(screen,m("GameOver"),a,44)
elseif self.phase==I then
screen:rect(0,r.y,k,r.height,f.r,f.g,f.b,1)
screen:textCentre(m("Ending"),a,r.y+r.title,e.r,e.g,e.b,1)
screen:textCentre(m("Score").." "..tostring(self.score),a,r.y+r.score,e.r,e.g,e.b,1)
elseif self.goTimer>0 and math.floor(self.goTimer/F)%2==0 then
U(screen,m("Go"),k-6,30)
end
end

function c:drawPhoto(screen)
local V=d.ticks-self.phaseTimer
local o=d.top-math.max(0,math.floor((d.drop-V)*(d.top+d.height)/d.drop))
local p=d.left
local w=p+d.width
local x=o+d.height
local y=o+d.margin
local W=y+d.imageHeight
local a=M[1]
local b=M[2]
if V>=d.develop then
T(screen)
self.scenery:drawBack(screen,0)
else
screen:clear(a.r,a.g,a.b)
screen:rect(p+d.margin,y,d.width-d.margin*2,d.imageHeight,b.r,b.g,b.b,1)
end
screen:rect(0,0,k,math.max(0,o),a.r,a.g,a.b,1)
screen:rect(0,0,p,B,a.r,a.g,a.b,1)
screen:rect(w,0,k-w,B,a.r,a.g,a.b,1)
screen:rect(0,x,k,B-x,a.r,a.g,a.b,1)
screen:rect(w,o+d.shadow,d.shadow,d.height,b.r,b.g,b.b,1)
screen:rect(p+d.shadow,x,d.width,d.shadow,b.r,b.g,b.b,1)
screen:rect(p,o,d.width,d.margin,e.r,e.g,e.b,1)
screen:rect(p,y,d.margin,d.imageHeight,e.r,e.g,e.b,1)
screen:rect(w-d.margin,y,d.margin,d.imageHeight,e.r,e.g,e.b,1)
screen:rect(p,W,d.width,x-W,e.r,e.g,e.b,1)
local X=k/2
screen:textCentre(m("Stage",self.definition.number),X,o+d.stageY,b.r,b.g,b.b,1)
screen:textCentre(m(self.definition.name),X,o+d.nameY,f.r,f.g,f.b,1)
end

function c:draw(screen)
if self.mode==c.MODE_RUN then
self:drawRun(screen)
else
self:drawMenu(screen)
end
end

require"SpiffBoy/Games/DoubleRaccoon/Menus"
