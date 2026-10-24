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
local G=p.Hero
local q=p.Zombies
local H=p.Records
local g=p.Music

local I=SpiffBoy.Cartridges.SHADES
local k=I[4]
local b=I[1]
local s=SpiffBoy.Cartridges.SCREEN_WIDTH
local r=SpiffBoy.GameTexts.of("SnackMan")
a.gameText=r

local m={1,2,3,4}
local U={1,2,3}
local V={1}
local A={1,2,3}
local e={x=2,y=3}
local d={size=16,half=8}
local J={right=0,left=1,up=2,down=3}
local W=8
local B={normal=0,flash=2,eyes=4}
local X=3
local K=10
local n=10
local L=7
local Y=10
local o={width=5,height=12,reach=7,swing=50,speed=0.35}
local M={up=0,right=90,down=180,left=270}
local Z=2
local _=2
local N={width=8,height=6}
local h={x=129,textX=132,right=178,labelY=2,scoreY=18,livesY=40,livesStep=10,livesShown=4,foodY=104,foodStep=12,foodShown=4}
local C={lineY=66,lineHeight=18}
local c={card=150,travel=70,ready=120,caught=45,deathFrame=15,deathTail=40,clear=150,clearHide=30,clearBlink=15,over=180,whack=30,popup=60}
local aa=4
local l={y=18,width=180,height=84,band=18,nameY=103,levelY=1,drop=30}
local u={width=7,height=9,tipX=3}

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_INITIALS="initials"

local D="card"
local v="ready"
local E="play"
local O="caught"
local w="dying"
local z="clear"
local t="over"

local function F(screen,label,x,y)
screen:textCentre(label,x,y,k.r,k.g,k.b,1)
end

function a:init()
local i=self.context.art
self.mazeArt={}
for x=1,j.COUNT do
self.mazeArt[x]=i("maze_"..x)
end
self.survivor=i("survivor")
self.zombieArt={}
for y,x in ipairs(f.CLASSIC_KINDS)do
self.zombieArt[x]=i("zombie_"..x)
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
self.records=H.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
end

function a:applyMix()
self.sequencer:setMix(self.mix.music/g.MIX_STEPS,self.mix.effects/g.MIX_STEPS)
end

function a:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function a:effect(name)
self.sequencer:effect(name)
end

function a:persistRecords()
self.save.records=H.write(self.records)
self:persist()
end

function a:chosenMode()
return f.MODES[self.setup.mode]
end

function a:tick(inputs,tick)
self.clock=self.clock+1
local i=inputs[1]
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
local x=f.kinds(self.level,self.playMode.horde)
self.tuning=f.level(self.level,self.playMode.horde,#x)
self.hero=G.new(self.maze)
self.zombies=q.new(x,self.playMode.horde,self.tuning)
self.foodShown=false
self.foodTimer=0
self.foodsServed=0
self.batTimer=0
self.batChain=0
self.freeze=0
self.popup=nil
self.paused=false
self.chomp=1
self.phase=D
self.phaseTimer=c.card
self.sequencer:stop()
if SpiffBoy.isDevBuild()then
SpiffBoy.log("SnackMan: level "..self.level.." maze "..i.." zombies "..#x.." chips "..self.maze.total)
end
end

function a:resetActors()
self.hero=G.new(self.maze)
self.zombies:reset()
self.batTimer=0
self.batChain=0
self.foodShown=false
self.freeze=0
self.popup=nil
end

function a:addScore(points)
self.score=self.score+points
if not self.extraGiven and self.score>=f.EXTRA_LIFE then
self.extraGiven=true
self.lives=self.lives+1
self:effect(g.LIFE)
end
end

function a:showPoints(points,x,y)
self.popup={text=tostring(points),x=x,y=y,timer=c.popup}
end

function a:tickRun(input)
local i=self.phase
if i==E then
if input and input.pressed.start then
self.paused=not self.paused
self:effect(g.CONFIRM)
end
if not self.paused then
self:tickPlay(input)
end
return
end
self.phaseTimer=self.phaseTimer-1
if i==D then
if self.phaseTimer<=0 then
self.phase=v
self.phaseTimer=c.ready
if self.firstReady then
self.sequencer:play(g.START)
end
end
elseif i==v then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.firstReady=false
self.phase=E
self.sequencer:play(g.PLAY)
end
elseif i==O then
if self.phaseTimer<=0 then
self.phase=w
self.phaseTimer=c.deathFrame*4+c.deathTail
self.sequencer:stop()
self:effect(g.DEATH)
end
elseif i==w then
if self.phaseTimer<=0 then
self:lifeLost()
end
elseif i==z then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.level=self.level+1
self:startLevel()
end
elseif i==t then
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:lifeLost()
self.lives=self.lives-1
if self.lives>0 then
self:resetActors()
self.phase=v
self.phaseTimer=c.ready
return
end
self.phase=t
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
local P=self.hero
local i,x=P:tile()
local y=self.maze:eat(i,x)
if y=="."then
self:addScore(f.CHIP_POINTS)
P.pause=1
self:effect(g.CHOMP[self.chomp])
self.chomp=3-self.chomp
elseif y=="o"then
self:addScore(f.BAT_POINTS)
self:takeBat()
end
if y then
local Q=self.foodsServed+1
local R=f.FOOD_AT[Q]
if R and self.maze:eaten()>=math.floor(self.maze.total*R)then
self.foodsServed=Q
self.foodShown=true
self.foodTimer=f.FOOD_TICKS
end
end
if self.foodShown and i==j.FOOD.x and x==j.FOOD.y then
local Q=f.FOOD_POINTS[self.mazeIndex]
self.foodShown=false
self:addScore(Q)
self:effect(g.FOOD)
local R,S=j.centre(i,x)
self:showPoints(Q,R,S)
end
end

function a:whack(zombie)
self.zombies:knockOut(zombie)
self.batChain=self.batChain+1
local i=f.ZOMBIE_POINTS*math.floor(2^(self.batChain-1))
self:addScore(i)
self:showPoints(i,zombie.mover.x,zombie.mover.y)
self.freeze=c.whack
self:effect(g.WHACK)
end

function a:checkTouch()
local x=self.hero
for P,i in ipairs(self.zombies.list)do
if i.state==q.WALK then
local y=i.mover
if math.abs(y.x-x.x)<q.CATCH and math.abs(y.y-x.y)<q.CATCH then
if i.scared then
self:whack(i)
else
self.phase=O
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

function a:tickPlay(input)
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
local i=self.batTimer>0 and self.tuning.heroBat or self.tuning.hero
self.hero:update(input,self.maze,i)
self:eatHere()
if self.maze.left==0 then
self.phase=z
self.phaseTimer=c.clear
self.sequencer:stop()
self.sequencer:play(g.CLEAR)
return
end
self.zombies:update(self.hero,self.maze,self.random,self.batTimer>0)
self:checkTouch()
end

local function P(x,y)
return e.x+math.floor(x)-d.half,e.y+math.floor(y)-d.half
end

function a:drawMaze(screen)
local i=U
if self.phase==z and self.phaseTimer<c.clear-c.clearHide and math.floor(self.phaseTimer/c.clearBlink)%2==0 then
i=V
end
screen:layers(self.mazeArt[self.mazeIndex],0,j.WIDTH,j.HEIGHT,e.x,e.y,i)
end

function a:drawChips(screen)
local y=self.maze
local i=j.TILE
for Q=1,j.ROWS do
local R,T=y:chipRuns(Q)
for S=1,T do
local x,ab=R[S*2-1],R[S*2]
screen:sheet(self.chips,(x-1)*i,0,(ab-x+1)*i,Z,e.x+(x-1)*i,e.y+(Q-1)*i+_,1,1)
end
end
if self.phase==E and math.floor(self.clock/Y)%3==0 then
return
end
for Q,x in ipairs(y.bats)do
if y:hasBat(x.x,x.y)then
screen:layers(self.batIcon,0,L,L,e.x+(x.x-1)*i,e.y+(x.y-1)*i-1,A)
end
end
end

function a:drawHero(screen)
local i=self.hero
local x,y=P(i.x,i.y)
if self.phase==w then
local Q=c.deathFrame*4+c.deathTail-self.phaseTimer
local R=W+math.min(3,math.floor(Q/c.deathFrame))
screen:layers(self.survivor,R*d.size,d.size,d.size,x,y,m)
return
end
local ab=math.floor(i.distance/X)%2
local ac=J[i.facing]*2+ab
screen:layers(self.survivor,ac*d.size,d.size,d.size,x,y,m)
if self.batTimer>0 then
local Q=M[i.facing]+math.sin(self.clock*o.speed)*o.swing
local R=math.rad(M[i.facing])
local S=e.x+i.x+math.sin(R)*o.reach
local T=e.y+i.y-math.cos(R)*o.reach
screen:rotated(self.batOutline,S,T,Q,o.width,o.height,1,1)
screen:rotated(self.batBarrel,S,T,Q,o.width,o.height,1,3)
end
end

function a:drawZombie(screen,zombie)
local i=zombie.mover
local x,y=P(i.x,i.y)
local Q=J[i.facing]
if zombie.state==q.EYES or zombie.state==q.ENTER then
screen:layers(self.fright,(B.eyes+Q)*d.size,d.size,d.size,x,y,m)
return
end
local R=math.floor(self.clock/K)%2
if zombie.scared and self.batTimer>0 then
local S=B.normal
if self.batTimer<f.FLASH_TICKS and math.floor(self.batTimer/K)%2==0 then
S=B.flash
end
screen:layers(self.fright,(S+R)*d.size,d.size,d.size,x,y,m)
return
end
screen:layers(self.zombieArt[zombie.kind],(Q*2+R)*d.size,d.size,d.size,x,y,m)
end

function a:drawFood(screen)
if not self.foodShown then
return
end
local i,x=j.centre(j.FOOD.x,j.FOOD.y)
screen:layers(self.food,(self.mazeIndex-1)*n,n,n,e.x+i-n/2,e.y+x-n/2,A)
end

function a:drawPanel(screen)
screen:rect(h.x,0,s-h.x,screen.height,k.r,k.g,k.b,1)
screen:rect(h.x,0,1,screen.height,b.r,b.g,b.b,1)
screen:text(r("Score"),h.textX,h.labelY,b.r,b.g,b.b,1)
screen:textRight(tostring(self.score),h.right,h.scoreY,b.r,b.g,b.b,1)
local x=math.min(h.livesShown,self.lives-1)
for i=1,x do
screen:layers(self.life,0,N.width,N.height,h.textX+(i-1)*h.livesStep,h.livesY,m)
end
local y=math.max(1,self.level-h.foodShown+1)
for i=y,self.level do
local Q=h.right-(self.level-i+1)*h.foodStep+2
screen:layers(self.food,(f.mazeOf(i)-1)*n,n,n,Q,h.foodY,A)
end
end

function a:drawBand(screen,label)
screen:rect(e.x,C.lineY,j.WIDTH,C.lineHeight,b.r,b.g,b.b,1)
F(screen,label,e.x+j.WIDTH/2,C.lineY+1)
end

local function Q(index)
local i=p.Layouts[index].town
return i.x,i.y
end

function a:drawCard(screen)
screen:clear(k.r,k.g,k.b)
screen:layers(self.knoxMap,0,l.width,l.height,0,l.y,m)
local x=math.min(1,(c.card-self.phaseTimer)/c.travel)
local y,i=Q(self.mazeIndex)
if self.level>1 then
local R,S=Q(f.mazeOf(self.level-1))
y=R+(y-R)*x
i=S+(i-S)*x
else
i=i-l.drop*(1-x)
end
screen:layers(self.pin,0,u.width,u.height,math.floor(y)-u.tipX,l.y+math.floor(i)-u.height,m)
screen:rect(0,0,s,l.band,b.r,b.g,b.b,1)
F(screen,r("Level",self.level),s/2,l.levelY)
screen:rect(0,l.y+l.height,s,screen.height-l.y-l.height,b.r,b.g,b.b,1)
F(screen,r("Maze"..self.mazeIndex),s/2,l.nameY)
end

function a:drawRun(screen)
if self.phase==D then
self:drawCard(screen)
return
end
screen:clear(k.r,k.g,k.b)
self:drawMaze(screen)
self:drawChips(screen)
self:drawFood(screen)
local i=self.phase
local x=i~=w and i~=t and not(i==z and self.phaseTimer<c.clear-c.clearHide)
if x then
for R,y in ipairs(self.zombies.list)do
self:drawZombie(screen,y)
end
end
if self.freeze>0 and self.popup then
screen:textCentre(self.popup.text,e.x+self.popup.x,e.y+self.popup.y-d.half,b.r,b.g,b.b,1)
elseif i~=t then
self:drawHero(screen)
if self.popup then
local y=math.floor((c.popup-self.popup.timer)/(c.popup/aa))
screen:textCentre(self.popup.text,e.x+self.popup.x,e.y+self.popup.y-d.half-y,b.r,b.g,b.b,1)
end
end
self:drawPanel(screen)
if i==v then
self:drawBand(screen,r("Ready"))
elseif i==t then
self:drawBand(screen,r("GameOver"))
elseif self.paused then
self:drawBand(screen,getText("UI_SpiffBoy_Paused"))
end
end

function a:draw(screen)
if self.mode==a.MODE_RUN then
self:drawRun(screen)
else
self:drawMenu(screen)
end
end

require"SpiffBoy/Games/SnackMan/Menus"
