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

local a=SpiffBoyDoubleRaccoonGame
local o=SpiffBoy.DoubleRaccoon
local aw=o.Combat
local i=o.Stage
local J=o.Scenery
local A=o.Fighter
local K=o.Horde
local L=o.Records
local k=o.Music

local c=SpiffBoy.Cartridges.SHADES[4]
local d=SpiffBoy.Cartridges.SHADES[1]
local M=SpiffBoy.Cartridges.SHADES
local l=SpiffBoy.Cartridges.SCREEN_WIDTH
local B=SpiffBoy.Cartridges.SCREEN_HEIGHT
local n=SpiffBoy.GameTexts.of("DoubleRaccoon")
a.gameText=n

local t=J.GROUND_Y+4
local r={1,2,3,4}
local Z={3}
local m={width=52,height=50,anchor=26}
local C={width=65,height=62,anchor=32}
local _={idle1=1,idle2=2,walk1=3,walk2=4,walk3=5,walk4=6,jab=7,cross=8,kick=9,hurt=10,swing1=11,swing2=12,hold=13,throw=14,elbow=15,pickup=16,down=17,fall=18}
local aa=18
local ab={index={walk1=1,walk2=2,walk3=3,walk4=4,grab=5,bite=6,hurt=7,fall=8,down=9,charge=5},count=9}
local ac={index={walk1=1,walk2=2,walk3=3,walk4=4,grab=5,bite=6,hurt=7,fall=8,down=9,charge=10},count=10}
local N={
lumberjack={sheet="boss_lumberjack",frame=C},
linebacker={sheet="boss_linebacker",frame=C},
riot={sheet="boss_riot",frame=C},
evil={sheet="boss_evil",frame=m},
}
local e={cell=32,grip=16,gripLeft=15,angles=3,count=9,order={bat=0,pan=1,axe=2},upright=2,flat=1,restFlat={bat=true}}
local ad={
idle1={32,38,2},idle2={32,39,2},walk1={20,37,2},walk2={25,39,2},walk3={32,37,2},walk4={27,39,2},
jab={43,29,1},cross={32,32,2},kick={31,31,2},hurt={22,29,2},swing1={21,20,3},swing2={40,32,1},
hold={39,30,1},throw={37,21,2},elbow={32,32,2},pickup={34,47,1},
}
local u={chips=0,tin=12,width=12,height=10}
local D={width=18,height=5}
local ae=40
local E=24
local af=-30
local ag=40
local ah=70
local ai=10
local aj=6
local ak=8
local al=3
local am=150
local b={ticks=150,drop=30,develop=50,left=5,top=4,width=170,height=113,margin=6,imageHeight=72,shadow=4,stageY=79,nameY=95}
local an=180
local F=15
local ao=240
local O=600
local ap=180
local s={y=20,height=42,title=4,score=22}
local aq=150
local ar=9
local as=60
local at=100
local P={{-1,0},{1,0},{0,-1},{0,1}}
local h={headX=3,headY=3,livesX=14,textY=-3,barX=26,barY=3,barWidth=50,barHeight=6,bossX=124,bossY=14,scoreX=177}

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_CONTINUE="continue"
a.MODE_INITIALS="initials"

local G="photo"
local Q="intro"
local R="play"
local H="clear"
local S="over"
local I="ending"

local function T(f)
f:clear(c.r,c.g,c.b)
end

local function v(f,g,j,p)
for w,q in ipairs(P)do
f:textCentre(g,j+q[1],p+q[2],c.r,c.g,c.b,1)
end
f:textCentre(g,j,p,d.r,d.g,d.b,1)
end

local function U(f,g,j,p)
for w,q in ipairs(P)do
f:textRight(g,j+q[1],p+q[2],c.r,c.g,c.b,1)
end
f:textRight(g,j,p,d.r,d.g,d.b,1)
end
a.haloCentre=v

function a:init()
local f=self.context.art
self.spiffo=f("spiffo")
self.bandArt={}
for j,g in ipairs(i.DIFFICULTIES)do
self.bandArt[g.key]=f("spiffo_"..g.key)
end
self.selectSpiffo=f("select_spiffo")
self.headbands=f("headbands")
self.selectStage=f("select_stage")
self.zombieSheets={}
for g,j in pairs(K.KINDS)do
if j.boss then
self.zombieSheets[g]=f(N[g].sheet)
else
self.zombieSheets[g]=f("zombie_"..g)
end
end
self.weapons=f("weapons")
self.food=f("food")
self.shadow=f("shadow")
self.hudHead=f("hud_head")
self.logo=f("logo")
self.titleHead=f("title_head")
self.sceneries={}
for g,j in ipairs(i.LIST)do
self.sceneries[g]=J.new(f,j.scenery)
end
self.records=L.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
end

function a:applyMix()
self.sequencer:setMix(self.mix.music/k.MIX_STEPS,self.mix.effects/k.MIX_STEPS)
end

function a:keepMusic(f)
if not self.sequencer:isPlaying()then
self.sequencer:play(f)
end
end

function a:persistRecords()
self.save.records=L.write(self.records)
self:persist()
end

function a:chosenDifficulty()
return i.DIFFICULTIES[self.setup.difficulty]
end

function a:tick(g,j)
self.clock=self.clock+1
local f=g[1]
if self.mode==a.MODE_RUN then
self:tickRun(f)
else
self:tickMenu(f)
end
end

function a:startRun()
self.difficulty=self:chosenDifficulty()
self.difficultyKey=self.difficulty.key
self.fighterArt=self.bandArt[self.difficultyKey]
self.lives=self.difficulty.lives
self.score=0
self.mode=a.MODE_RUN
self:startStage(1)
end

function a:startStage(j)
local f=i.LIST[j]
self.stageIndex=j
self.definition=f
self.scenery=self.sceneries[j]
self.stage=i.new(f,self.difficulty)
self.horde=K.new()
self.fighter=A.new(af,E)
self.camera=0
self.left=0
self.right=i.VIEW
self.items={}
for q,g in ipairs(f.items)do
local p=A.WEAPONS[g.kind]
self.items[#self.items+1]={kind=g.kind,x=g.x,z=g.z,durability=p and p.durability or 0}
end
self.sparks={}
self.goTimer=0
self.bossStarted=false
self.paused=false
self.phase=G
self.phaseTimer=b.ticks
self.sequencer:stop()
self.music=k.STAGE[f.music]
end

function a:effect(f)
self.sequencer:effect(f)
end

function a:addScore(f)
self.score=self.score+f
end

function a:spark(f,g,j)
self.sparks[#self.sparks+1]={x=f,z=g,height=j,timer=ak}
end

function a:itemAt(f)
for j,g in ipairs(self.items)do
if math.abs(g.x-f.x)<=ai and math.abs(g.z-f.z)<=aj then
return j
end
end
return nil
end

function a:takeItem(g)
local f=self:itemAt(g)
if not f then
return nil
end
return table.remove(self.items,f)
end

function a:dropWeapon(f,g,j,p)
self.items[#self.items+1]={kind=f,x=j,z=p,durability=g}
end

function a:lifeLost()
self.lives=self.lives-1
if self.lives>0 then
self.fighter:respawn()
return
end
self.sequencer:stop()
self.mode=a.MODE_CONTINUE
self.continueCount=ar
self.continueTimer=as
self.continueYes=true
end

function a:continueRun()
self.score=0
self.lives=self.difficulty.lives
self.mode=a.MODE_RUN
self:startStage(self.stageIndex)
end

function a:nextStage()
if self.stageIndex<#i.LIST then
self:startStage(self.stageIndex+1)
return
end
self.phase=I
self.phaseTimer=O
self.sequencer:stop()
self.sequencer:play(k.ENDING)
end

function a:tickClear()
self.horde:update(self.fighter,self)
local f=self.stageIndex==#i.LIST
local g=f and self.camera+l/2 or self.camera+i.VIEW+ag
self.fighter:walkTo(g,self.fighter.z)
self.phaseTimer=self.phaseTimer-1
local j=f or self.fighter.x-self.camera>=i.VIEW+m.anchor
if j and self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextStage()
end
end

function a:tickEnding(f)
self.horde:update(self.fighter,self)
self.fighter:walkTo(self.camera+l/2,E)
self.phaseTimer=self.phaseTimer-1
local g=f and(f.pressed.a or f.pressed.start)and self.phaseTimer<O-ap
if g or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
end

function a:gameOver()
self.mode=a.MODE_RUN
self.phase=S
self.phaseTimer=aq
self.sequencer:play(k.OVER)
end

function a:tickRun(g)
local f=self.phase
if f==G then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer==b.ticks-b.develop then
self:effect(k.SHUTTER)
end
if self.phaseTimer<=0 then
self.phase=Q
self.phaseTimer=am
end
elseif f==Q then
self.fighter:walkTo(ae,E)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=R
end
elseif f==R then
if g and g.pressed.start then
self.paused=not self.paused
self:effect(k.CONFIRM)
end
if not self.paused then
self:tickFight(g)
end
elseif f==H then
self:tickClear()
elseif f==I then
self:tickEnding(g)
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:tickFight(j)
if not self.bossStarted then
self:keepMusic(self.music)
elseif self.definition.finalMusic then
self:keepMusic(k.FINAL)
else
self:keepMusic(k.BOSS)
end
self.fighter:update(j,self)
if self.mode~=a.MODE_RUN then
return
end
self:moveCamera()
self:runZones()
self.horde:update(self.fighter,self)
self:checkBoss()
for g=#self.sparks,1,-1 do
local f=self.sparks[g]
f.timer=f.timer-1
if f.timer<=0 then
table.remove(self.sparks,g)
end
end
if self.goTimer>0 then
self.goTimer=self.goTimer-1
if self.goTimer%(F*2)==F*2-1 then
self:effect(k.GO)
end
end
end

function a:moveCamera()
local f=math.min(self.stage:cameraLimit(),self.definition.length-i.VIEW)
local g=math.min(self.fighter.x-ah,f)
self.camera=math.max(self.camera,math.floor(g))
self.left=self.camera
self.right=self.camera+i.VIEW
end

function a:runZones()
local f=self.stage
f:reach(self.camera)
local g=f:nextWave(self.horde:aliveCount())
if g then
for j,p in ipairs(g)do
local q=j%2==0 and-1 or 1
self.horde:spawn(p,q,self)
end
end
if f:release(self.horde:aliveCount())then
self.goTimer=an
end
end

function a:checkBoss()
if not self.bossStarted then
if self.stage:atBoss(self.camera)then
self.bossStarted=true
self.horde:spawn(self.definition.boss.kind,1,self)
self.sequencer:stop()
self.goTimer=0
end
return
end
local f=self.horde.boss
if not f or f.state=="dying"then
self.horde:killAll(self)
self:addScore(self.fighter.hp*at)
self.phase=H
self.phaseTimer=ao
self.sequencer:stop()
self.sequencer:play(k.CLEAR)
end
end

function a:screenX(f)
return math.floor(f-self.camera)
end

function a:drawShadow(f,g,j)
f:layers(self.shadow,0,D.width,D.height,self:screenX(g)-D.width/2,t+j-2,Z)
end

function a:drawItem(g,f)
local j=self:screenX(f.x)
local p=t+f.z
local q=e.order[f.kind]
if q then
g:layers(self.weapons,q*e.angles*e.cell,e.cell,e.cell,j-e.grip,p-e.grip-2,r)
else
g:layers(self.food,u[f.kind],u.width,u.height,j-u.width/2,p-u.height,r)
end
end

function a:drawFighter(w)
local f=self.fighter
if f:blinking()then
return
end
local x=f:frame()
local y=f.facing<0
local X=_[x]-1+(y and aa or 0)
local z=self:screenX(f.x)-m.anchor
local V=t+math.floor(f.z)-(m.height-1)
w:layers(self.fighterArt,X*m.width,m.width,m.height,z,V,r)
local g=ad[x]
if f.weapon and g then
local j=g[3]
if j==e.upright and e.restFlat[f.weapon]then
j=e.flat
end
local p=e.order[f.weapon]*e.angles+j-1
local q=g[1]
local W=e.grip
if y then
p=p+e.count
q=m.width-1-q
W=e.gripLeft
end
w:layers(self.weapons,p*e.cell,e.cell,e.cell,z+q-W,V+g[2]-e.grip,r)
end
end

function a:drawZombie(p,f)
if f:blinking()then
return
end
local q,w=f:frame()
local g=f.isBoss and N[f.kind].frame or m
local j=f.isBoss and ac or ab
local x=self.zombieSheets[f.kind]
local y=j.index[q]-1+(f.facing<0 and j.count or 0)
local z=self:screenX(f.x)-g.anchor+w
local V=t+math.floor(f.z)-(g.height-1)-math.floor(f.height)
p:layers(x,y*g.width,g.width,g.height,z,V,r)
end

local au={}
local w=nil

local function av(g,f)
if g.z~=f.z then
return g.z<f.z
end
if g==w or f==w then
return f==w
end
return g.id<f.id
end

function a:drawActors(g)
for j,f in ipairs(self.items)do
self:drawItem(g,f)
end
local f=au
local z=#f
f[1]=self.fighter
local j=1
for q,p in ipairs(self.horde.zombies)do
j=j+1
f[j]=p
end
for p=j+1,z do
f[p]=nil
end
w=self.fighter
table.sort(f,av)
for q,p in ipairs(f)do
self:drawShadow(g,p.x,p.z)
end
for q,p in ipairs(f)do
if p==self.fighter then
self:drawFighter(g)
else
self:drawZombie(g,p)
end
end
for V,p in ipairs(self.sparks)do
local x=self:screenX(p.x)
local y=t+math.floor(p.z)-30-math.floor(p.height)
local q=al+math.floor(p.timer/3)
g:rect(x-q,y,q*2+1,1,d.r,d.g,d.b,1)
g:rect(x,y-q,1,q*2+1,d.r,d.g,d.b,1)
end
end

local function V(f,g,j,p,q,x)
f:rect(g,j,p,q,d.r,d.g,d.b,1)
f:rect(g+1,j+1,p-2,q-2,c.r,c.g,c.b,1)
f:rect(g+1,j+1,math.floor((p-2)*x),q-2,d.r,d.g,d.b,1)
end

function a:drawHud(f)
f:layers(self.hudHead,0,9,8,h.headX,h.headY,r)
v(f,tostring(self.lives),h.livesX+4,h.textY)
V(f,h.barX,h.barY,h.barWidth,h.barHeight,self.fighter.hp/A.MAX_HP)
U(f,tostring(self.score),h.scoreX,h.textY)
local g=self.horde.boss
if g and g.state~="enter"then
V(f,h.bossX,h.bossY,h.barWidth,h.barHeight,math.max(0,g.hp)/g.stats.hp)
end
end

function a:drawRun(f)
if self.phase==G then
self:drawPhoto(f)
return
end
T(f)
self.scenery:drawBack(f,self.camera)
self:drawActors(f)
self.scenery:drawFront(f,self.camera)
self:drawHud(f)
local g=l/2
if self.paused then
v(f,getText("UI_SpiffBoy_Paused"),g,44)
elseif self.phase==H then
v(f,n("StageClear"),g,44)
elseif self.phase==S then
v(f,n("GameOver"),g,44)
elseif self.phase==I then
f:rect(0,s.y,l,s.height,d.r,d.g,d.b,1)
f:textCentre(n("Ending"),g,s.y+s.title,c.r,c.g,c.b,1)
f:textCentre(n("Score").." "..tostring(self.score),g,s.y+s.score,c.r,c.g,c.b,1)
elseif self.goTimer>0 and math.floor(self.goTimer/F)%2==0 then
U(f,n("Go"),l-6,30)
end
end

function a:drawPhoto(f)
local W=b.ticks-self.phaseTimer
local p=b.top-math.max(0,math.floor((b.drop-W)*(b.top+b.height)/b.drop))
local q=b.left
local x=q+b.width
local y=p+b.height
local z=p+b.margin
local X=z+b.imageHeight
local g=M[1]
local j=M[2]
if W>=b.develop then
T(f)
self.scenery:drawBack(f,0)
else
f:clear(g.r,g.g,g.b)
f:rect(q+b.margin,z,b.width-b.margin*2,b.imageHeight,j.r,j.g,j.b,1)
end
f:rect(0,0,l,math.max(0,p),g.r,g.g,g.b,1)
f:rect(0,0,q,B,g.r,g.g,g.b,1)
f:rect(x,0,l-x,B,g.r,g.g,g.b,1)
f:rect(0,y,l,B-y,g.r,g.g,g.b,1)
f:rect(x,p+b.shadow,b.shadow,b.height,j.r,j.g,j.b,1)
f:rect(q+b.shadow,y,b.width,b.shadow,j.r,j.g,j.b,1)
f:rect(q,p,b.width,b.margin,c.r,c.g,c.b,1)
f:rect(q,z,b.margin,b.imageHeight,c.r,c.g,c.b,1)
f:rect(x-b.margin,z,b.margin,b.imageHeight,c.r,c.g,c.b,1)
f:rect(q,X,b.width,y-X,c.r,c.g,c.b,1)
local Y=l/2
f:textCentre(n("Stage",self.definition.number),Y,p+b.stageY,j.r,j.g,j.b,1)
f:textCentre(n(self.definition.name),Y,p+b.nameY,d.r,d.g,d.b,1)
end

function a:draw(f)
if self.mode==a.MODE_RUN then
self:drawRun(f)
else
self:drawMenu(f)
end
end

require"SpiffBoy/Games/DoubleRaccoon/Menus"
