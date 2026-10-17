require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/SnackMan/Rules"
require"SpiffBoy/Games/SnackMan/Maze"
require"SpiffBoy/Games/SnackMan/Actors"
require"SpiffBoy/Games/SnackMan/Zombies"
require"SpiffBoy/Games/SnackMan/Records"
require"SpiffBoy/Games/SnackMan/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoySnackManGame=SpiffBoyGameBase:derive("SpiffBoySnackManGame")

local a=SpiffBoySnackManGame
local p=SpiffBoy.SnackMan
local f=p.Rules
local j=p.Maze
local I=p.Hero
local q=p.Zombies
local J=p.Records
local g=p.Music

local K=SpiffBoy.Cartridges.SHADES
local k=K[4]
local b=K[1]
local t=SpiffBoy.Cartridges.SCREEN_WIDTH
local r=SpiffBoy.GameTexts.of("SnackMan")
a.gameText=r

local m={1,2,3,4}
local V={1,2,3}
local W={1}
local z={1,2,3}
local e={x=2,y=3}
local d={size=16,half=8}
local L={right=0,left=1,up=2,down=3}
local X=8
local A={normal=0,flash=2,eyes=4}
local Y=3
local M=10
local n=10
local N=7
local Z=10
local o={width=5,height=12,reach=7,swing=50,speed=0.35}
local O={up=0,right=90,down=180,left=270}
local _=2
local aa=2
local P={width=8,height=6}
local h={x=129,textX=132,right=178,labelY=2,scoreY=18,livesY=40,livesStep=10,livesShown=4,foodY=104,foodStep=12,foodShown=4}
local B={lineY=66,lineHeight=18}
local c={card=150,travel=70,ready=120,caught=45,deathFrame=15,deathTail=40,clear=150,clearHide=30,clearBlink=15,over=180,whack=30,popup=60}
local ab=4
local l={y=18,width=180,height=84,band=18,nameY=103,levelY=1,drop=30}
local v={width=7,height=9,tipX=3}

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_INITIALS="initials"

local C="card"
local w="ready"
local D="play"
local Q="caught"
local x="dying"
local y="clear"
local u="over"

local function E(i,s,F,G)
i:textCentre(s,F,G,k.r,k.g,k.b,1)
end

function a:init()
local i=self.context.art
self.mazeArt={}
for s=1,j.COUNT do
self.mazeArt[s]=i("maze_"..s)
end
self.survivor=i("survivor")
self.zombieArt={}
for F,s in ipairs(f.CLASSIC_KINDS)do
self.zombieArt[s]=i("zombie_"..s)
end
self.fright=i("fright")
self.food=i("food")
self.batIcon=i("bat")
self.batOutline=i("bat_outline")
self.batBarrel=i("bat_barrel")
self.chips=i("chips")
self.life=i("life")
self.logo=i("logo")
self.receiptEdge=i("receipt_edge")
self.knoxMap=i("knox_map")
self.pin=i("pin")
self.aisles=i("aisles")
self.records=J.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
end

function a:applyMix()
self.sequencer:setMix(self.mix.music/g.MIX_STEPS,self.mix.effects/g.MIX_STEPS)
end

function a:keepMusic(i)
if not self.sequencer:isPlaying()then
self.sequencer:play(i)
end
end

function a:effect(i)
self.sequencer:effect(i)
end

function a:persistRecords()
self.save.records=J.write(self.records)
self:persist()
end

function a:chosenMode()
return f.MODES[self.setup.mode]
end

function a:tick(s,F)
self.clock=self.clock+1
local i=s[1]
if self.mode==a.MODE_RUN then
self:tickRun(i)
else
self:tickMenu(i)
end
end

function a:startRun()
self.playMode=self:chosenMode()
self.recordKey=self.playMode.key
self.lives=f.LIVES
self.score=0
self.extraGiven=false
self.level=1
self.mode=a.MODE_RUN
self.firstReady=true
self:startLevel()
SpiffBoy.trace("SnackMan: run started in mode "..self.recordKey)
end

function a:startLevel()
local i=f.mazeOf(self.level)
self.mazeIndex=i
self.maze=j.new(i)
local s=f.kinds(self.level,self.playMode.horde)
self.tuning=f.level(self.level,self.playMode.horde,#s)
self.hero=I.new(self.maze)
self.zombies=q.new(s,self.playMode.horde,self.tuning)
self.foodShown=false
self.foodTimer=0
self.foodsServed=0
self.batTimer=0
self.batChain=0
self.freeze=0
self.popup=nil
self.paused=false
self.chomp=1
self.phase=C
self.phaseTimer=c.card
self.sequencer:stop()
if SpiffBoy.isDevBuild()then
SpiffBoy.log("SnackMan: level "..self.level.." maze "..i.." zombies "..#s.." chips "..self.maze.total)
end
end

function a:resetActors()
self.hero=I.new(self.maze)
self.zombies:reset()
self.batTimer=0
self.batChain=0
self.foodShown=false
self.freeze=0
self.popup=nil
end

function a:addScore(i)
self.score=self.score+i
if not self.extraGiven and self.score>=f.EXTRA_LIFE then
self.extraGiven=true
self.lives=self.lives+1
self:effect(g.LIFE)
end
end

function a:showPoints(i,s,F)
self.popup={text=tostring(i),x=s,y=F,timer=c.popup}
end

function a:tickRun(s)
local i=self.phase
if i==D then
if s and s.pressed.start then
self.paused=not self.paused
self:effect(g.CONFIRM)
end
if not self.paused then
self:tickPlay(s)
end
return
end
self.phaseTimer=self.phaseTimer-1
if i==C then
if self.phaseTimer<=0 then
self.phase=w
self.phaseTimer=c.ready
if self.firstReady then
self.sequencer:play(g.START)
end
end
elseif i==w then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.firstReady=false
self.phase=D
self.sequencer:play(g.PLAY)
end
elseif i==Q then
if self.phaseTimer<=0 then
self.phase=x
self.phaseTimer=c.deathFrame*4+c.deathTail
self.sequencer:stop()
self:effect(g.DEATH)
end
elseif i==x then
if self.phaseTimer<=0 then
self:lifeLost()
end
elseif i==y then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.level=self.level+1
self:startLevel()
end
elseif i==u then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:lifeLost()
self.lives=self.lives-1
if self.lives>0 then
self:resetActors()
self.phase=w
self.phaseTimer=c.ready
return
end
self.phase=u
self.phaseTimer=c.over
self.sequencer:play(g.OVER)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("SnackMan: game over at level "..self.level.." with "..self.score)
end
end

function a:takeBat()
self.batTimer=self.tuning.batTicks
self.batChain=0
self.zombies:scare()
self:effect(g.BAT)
self.sequencer:play(g.FRIGHT)
end

function a:eatHere()
local G=self.hero
local i,s=G:tile()
local F=self.maze:eat(i,s)
if F=="."then
self:addScore(f.CHIP_POINTS)
G.pause=1
self:effect(g.CHOMP[self.chomp])
self.chomp=3-self.chomp
elseif F=="o"then
self:addScore(f.BAT_POINTS)
self:takeBat()
end
if F then
local H=self.foodsServed+1
local R=f.FOOD_AT[H]
if R and self.maze:eaten()>=math.floor(self.maze.total*R)then
self.foodsServed=H
self.foodShown=true
self.foodTimer=f.FOOD_TICKS
end
end
if self.foodShown and i==j.FOOD.x and s==j.FOOD.y then
local H=f.FOOD_POINTS[self.mazeIndex]
self.foodShown=false
self:addScore(H)
self:effect(g.FOOD)
local R,S=j.centre(i,s)
self:showPoints(H,R,S)
end
end

function a:whack(i)
self.zombies:knockOut(i)
self.batChain=self.batChain+1
local s=f.ZOMBIE_POINTS*math.floor(2^(self.batChain-1))
self:addScore(s)
self:showPoints(s,i.mover.x,i.mover.y)
self.freeze=c.whack
self:effect(g.WHACK)
end

function a:checkTouch()
local s=self.hero
for G,i in ipairs(self.zombies.list)do
if i.state==q.WALK then
local F=i.mover
if math.abs(F.x-s.x)<q.CATCH and math.abs(F.y-s.y)<q.CATCH then
if i.scared then
self:whack(i)
else
self.phase=Q
self.phaseTimer=c.caught
self.sequencer:stop()
if SpiffBoy.isDevBuild()then
SpiffBoy.log("SnackMan: caught by "..i.kind.." at level "..self.level..", "..self.maze.left.." chips left")
end
return
end
end
end
end
end

function a:tickPlay(i)
if self.popup then
self.popup.timer=self.popup.timer-1
if self.popup.timer<=0 then
self.popup=nil
end
end
if self.freeze>0 then
self.freeze=self.freeze-1
return
end
if self.batTimer>0 then
self.batTimer=self.batTimer-1
if self.batTimer==0 then
self.zombies:calm()
self.sequencer:play(g.PLAY)
end
end
if self.foodShown then
self.foodTimer=self.foodTimer-1
if self.foodTimer<=0 then
self.foodShown=false
end
end
local s=self.batTimer>0 and self.tuning.heroBat or self.tuning.hero
self.hero:update(i,self.maze,s)
self:eatHere()
if self.maze.left==0 then
self.phase=y
self.phaseTimer=c.clear
self.sequencer:stop()
self.sequencer:play(g.CLEAR)
return
end
self.zombies:update(self.hero,self.maze,self.random,self.batTimer>0)
self:checkTouch()
end

local function R(i,s)
return e.x+math.floor(i)-d.half,e.y+math.floor(s)-d.half
end

function a:drawMaze(s)
local i=V
if self.phase==y and self.phaseTimer<c.clear-c.clearHide and math.floor(self.phaseTimer/c.clearBlink)%2==0 then
i=W
end
s:layers(self.mazeArt[self.mazeIndex],0,j.WIDTH,j.HEIGHT,e.x,e.y,i)
end

function a:drawChips(G)
local F=self.maze
local i=j.TILE
for H=1,j.ROWS do
local S,U=F:chipRuns(H)
for T=1,U do
local s,ac=S[T*2-1],S[T*2]
G:sheet(self.chips,(s-1)*i,0,(ac-s+1)*i,_,e.x+(s-1)*i,e.y+(H-1)*i+aa,1,1)
end
end
if self.phase==D and math.floor(self.clock/Z)%3==0 then
return
end
for H,s in ipairs(F.bats)do
if F:hasBat(s.x,s.y)then
G:layers(self.batIcon,0,N,N,e.x+(s.x-1)*i,e.y+(s.y-1)*i-1,z)
end
end
end

function a:drawHero(s)
local i=self.hero
local F,G=R(i.x,i.y)
if self.phase==x then
local H=c.deathFrame*4+c.deathTail-self.phaseTimer
local S=X+math.min(3,math.floor(H/c.deathFrame))
s:layers(self.survivor,S*d.size,d.size,d.size,F,G,m)
return
end
local ac=math.floor(i.distance/Y)%2
local ad=L[i.facing]*2+ac
s:layers(self.survivor,ad*d.size,d.size,d.size,F,G,m)
if self.batTimer>0 then
local H=O[i.facing]+math.sin(self.clock*o.speed)*o.swing
local S=math.rad(O[i.facing])
local T=e.x+i.x+math.sin(S)*o.reach
local U=e.y+i.y-math.cos(S)*o.reach
s:rotated(self.batOutline,T,U,H,o.width,o.height,1,1)
s:rotated(self.batBarrel,T,U,H,o.width,o.height,1,3)
end
end

function a:drawZombie(s,i)
local F=i.mover
local G,H=R(F.x,F.y)
local S=L[F.facing]
if i.state==q.EYES or i.state==q.ENTER then
s:layers(self.fright,(A.eyes+S)*d.size,d.size,d.size,G,H,m)
return
end
local T=math.floor(self.clock/M)%2
if i.scared and self.batTimer>0 then
local U=A.normal
if self.batTimer<f.FLASH_TICKS and math.floor(self.batTimer/M)%2==0 then
U=A.flash
end
s:layers(self.fright,(U+T)*d.size,d.size,d.size,G,H,m)
return
end
s:layers(self.zombieArt[i.kind],(S*2+T)*d.size,d.size,d.size,G,H,m)
end

function a:drawFood(i)
if not self.foodShown then
return
end
local s,F=j.centre(j.FOOD.x,j.FOOD.y)
i:layers(self.food,(self.mazeIndex-1)*n,n,n,e.x+s-n/2,e.y+F-n/2,z)
end

function a:drawPanel(i)
i:rect(h.x,0,t-h.x,i.height,k.r,k.g,k.b,1)
i:rect(h.x,0,1,i.height,b.r,b.g,b.b,1)
i:text(r("Score"),h.textX,h.labelY,b.r,b.g,b.b,1)
i:textRight(tostring(self.score),h.right,h.scoreY,b.r,b.g,b.b,1)
local F=math.min(h.livesShown,self.lives-1)
for s=1,F do
i:layers(self.life,0,P.width,P.height,h.textX+(s-1)*h.livesStep,h.livesY,m)
end
local G=math.max(1,self.level-h.foodShown+1)
for s=G,self.level do
local H=h.right-(self.level-s+1)*h.foodStep+2
i:layers(self.food,(f.mazeOf(s)-1)*n,n,n,H,h.foodY,z)
end
end

function a:drawBand(i,s)
i:rect(e.x,B.lineY,j.WIDTH,B.lineHeight,b.r,b.g,b.b,1)
E(i,s,e.x+j.WIDTH/2,B.lineY+1)
end

local function H(s)
local i=p.Layouts[s].town
return i.x,i.y
end

function a:drawCard(i)
i:clear(k.r,k.g,k.b)
i:layers(self.knoxMap,0,l.width,l.height,0,l.y,m)
local F=math.min(1,(c.card-self.phaseTimer)/c.travel)
local G,s=H(self.mazeIndex)
if self.level>1 then
local S,T=H(f.mazeOf(self.level-1))
G=S+(G-S)*F
s=T+(s-T)*F
else
s=s-l.drop*(1-F)
end
i:layers(self.pin,0,v.width,v.height,math.floor(G)-v.tipX,l.y+math.floor(s)-v.height,m)
i:rect(0,0,t,l.band,b.r,b.g,b.b,1)
E(i,r("Level",self.level),t/2,l.levelY)
i:rect(0,l.y+l.height,t,i.height-l.y-l.height,b.r,b.g,b.b,1)
E(i,r("Maze"..self.mazeIndex),t/2,l.nameY)
end

function a:drawRun(i)
if self.phase==C then
self:drawCard(i)
return
end
i:clear(k.r,k.g,k.b)
self:drawMaze(i)
self:drawChips(i)
self:drawFood(i)
local s=self.phase
local F=s~=x and s~=u and not(s==y and self.phaseTimer<c.clear-c.clearHide)
if F then
for S,G in ipairs(self.zombies.list)do
self:drawZombie(i,G)
end
end
if self.freeze>0 and self.popup then
i:textCentre(self.popup.text,e.x+self.popup.x,e.y+self.popup.y-d.half,b.r,b.g,b.b,1)
elseif s~=u then
self:drawHero(i)
if self.popup then
local G=math.floor((c.popup-self.popup.timer)/(c.popup/ab))
i:textCentre(self.popup.text,e.x+self.popup.x,e.y+self.popup.y-d.half-G,b.r,b.g,b.b,1)
end
end
self:drawPanel(i)
if s==w then
self:drawBand(i,r("Ready"))
elseif s==u then
self:drawBand(i,r("GameOver"))
elseif self.paused then
self:drawBand(i,getText("UI_SpiffBoy_Paused"))
end
end

function a:draw(i)
if self.mode==a.MODE_RUN then
self:drawRun(i)
else
self:drawMenu(i)
end
end

require"SpiffBoy/Games/SnackMan/Menus"
