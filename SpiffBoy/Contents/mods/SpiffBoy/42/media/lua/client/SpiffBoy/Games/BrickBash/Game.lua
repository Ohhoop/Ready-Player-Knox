require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/BrickBash/Rounds"
require"SpiffBoy/Games/BrickBash/Field"
require"SpiffBoy/Games/BrickBash/Paddle"
require"SpiffBoy/Games/BrickBash/Ball"
require"SpiffBoy/Games/BrickBash/Items"
require"SpiffBoy/Games/BrickBash/Records"
require"SpiffBoy/Games/BrickBash/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyBrickBashGame=SpiffBoyGameBase:derive("SpiffBoyBrickBashGame")

local a=SpiffBoyBrickBashGame
local f=SpiffBoy.BrickBash
local p=f.Rounds
local l=f.Field
local D=f.Paddle
local E=f.Ball
local j=f.Items
local u=f.Records
local e=f.Music

local d=SpiffBoy.Cartridges.SHADES[4]
local q=SpiffBoy.Cartridges.SHADES[1]
local F=SpiffBoy.Cartridges.SCREEN_WIDTH
local g=SpiffBoy.GameTexts.of("BrickBash")
a.gameText=g

a.MODES={{key="c",text="ModeA",endless=false},{key="e",text="ModeB",endless=true}}

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_INITIALS="initials"

local r="build"
local m="intro"
local v="play"
local w="lost"
local s="clear"
local t="allClear"
local z="over"

local G={1,2,3,4}
local h={x=4,y=16,width=172,height=104,shades={3}}
local n={x=0,y=12,width=180,height=108}
local b={headX=3,headY=2,livesX=14,digitsY=3,scoreX=90,scoreDigits=6,iconX=150,iconY=2,roundRight=177,roundDigits=2,cell=10,height=8,headShades={1,2,3},iconShades={1,3}}
local i={y=54,height=38,first=57,second=73}
local H=3
local I=9
local J=3
local K=1.1
local L=0.05
local M=1.9
local N=0.02
local O=0.5
local P=0.75
local Q=100
local A=120
local B=90
local R=150
local C=480
local S=180
local T=120

function a:trace(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("BrickBash: "..message)
end
end

function a:init()
local c=self.context.art
self.art={
bricks=c("bricks"),
ball=c("ball"),
planks=c("planks"),
spiffo=c("spiffo"),
items=c("items"),
burst=c("burst"),
frame=c("frame"),
backdrops=c("backdrops"),
hud=c("hud"),
logo=c("logo"),
digits=c("digits"),
batter=c("batter"),
ballpark=c("ballpark"),
}
self.records=u.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
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
self.save.records=u.write(self.records)
self:persist()
end

function a:tick(inputs,tick)
self.clock=self.clock+1
local c=inputs[1]
if self.mode==a.MODE_RUN then
self:tickRun(c)
else
self:tickMenu(c)
end
end

function a:startRun()
self.playMode=a.MODES[self.setup.mode]
self.modeKey=self.playMode.key
self.lives=H
self.score=0
self.mode=a.MODE_RUN
self:startRound(1)
end

function a:serve()
self.speed=self.baseSpeed
self.balls={E.new(self.paddle,self.speed)}
self.items:clear()
self.paused=false
end

function a:startRound(number)
self.round=number
local c=p.definition(self.playMode.endless,number,self.random)
self.field=l.new(c)
self.backdrop=p.backdropOf(number)
self.paddle=D.new()
self.items=j.new()
self.baseSpeed=math.min(M,K+(number-1)*L)
self:serve()
self.phase=r
self.phaseTimer=self.field:buildTicks()
self.landed=0
self.sequencer:stop()
self.sequencer:play(e.START)
self:trace("round "..number.." mode "..self.modeKey.." bricks "..self.field.remaining.." lives "..self.lives.." score "..self.score)
end

function a:addScore(points)
self.score=self.score+points
end

function a:brickBroken(x,y)
if#self.balls==1 then
self.items:maybeDrop(self.random,x,y)
end
end

function a:applySpeed()
for k,c in ipairs(self.balls)do
c:setSpeed(self.speed)
end
end

function a:ballReturned(ball)
self.speed=math.min(self.baseSpeed+O,self.speed+N)
self:applySpeed()
end

function a:launchBalls()
local c=false
for o,k in ipairs(self.balls)do
if k.stuck then
k:launch(self.paddle)
c=true
end
end
if c then
self:effect(e.LAUNCH)
end
end

function a:splitBalls()
self:launchBalls()
local c=#self.balls
for k=1,c do
for x,o in ipairs(self.balls[k]:split())do
if#self.balls<J then
self.balls[#self.balls+1]=o
end
end
end
end

function a:applyItem(kind)
self:addScore(Q)
self:trace("caught "..kind)
if kind==j.LIFE then
self.lives=math.min(I,self.lives+1)
self:effect(e.LIFE)
return
end
self:effect(e.CATCH)
if kind==j.WIDE then
self.paddle:setPower(true,false)
self:launchBalls()
elseif kind==j.GLUE then
self.paddle:setPower(false,true)
elseif kind==j.SLOW then
self.speed=self.baseSpeed*P
self:applySpeed()
else
self:splitBalls()
end
end

function a:loseBall()
self.lives=self.lives-1
self.paddle.letGo=B
self.items:clear()
self.phase=w
self.phaseTimer=B
self.sequencer:stop()
self.sequencer:play(e.LOSE)
self:trace("ball lost on round "..self.round..", lives "..self.lives)
end

function a:roundClear()
self.balls={}
self.items:clear()
self.phase=s
self.phaseTimer=R
self.sequencer:stop()
self.sequencer:play(e.CLEAR)
end

function a:nextRound()
if not self.playMode.endless and self.round>=p.CAMPAIGN_LENGTH then
self.phase=t
self.phaseTimer=C
self.sequencer:stop()
self.sequencer:play(e.ALL_CLEAR)
self:trace("campaign cleared, score "..self.score)
return
end
self:startRound(self.round+1)
end

function a:gameOver()
self.phase=z
self.phaseTimer=T
self.sequencer:stop()
self.sequencer:play(e.OVER)
self:trace("game over on round "..self.round..", score "..self.score)
end

function a:tickPlay(input)
local c=self:chosenTrack()
if c then
self:keepMusic(c)
end
self.paddle:update(input)
if input and input.pressed.a then
self:launchBalls()
end
self.field:update()
for k=#self.balls,1,-1 do
if self.balls[k]:update(self.paddle,self.field,self)then
table.remove(self.balls,k)
end
end
local k=self.items:update(self.paddle)
if k then
self:applyItem(k)
end
if self.field.remaining<=0 then
self:roundClear()
elseif#self.balls==0 then
self:loseBall()
end
end

function a:steerPaddle(input)
self.paddle:update(input)
for k,c in ipairs(self.balls)do
c:follow(self.paddle)
end
end

function a:tickRun(input)
local c=self.phase
if c==r then
self:steerPaddle(input)
self.phaseTimer=self.phaseTimer-1
local k=self.field:landedRows(self.field:buildTicks()-self.phaseTimer)
if k>self.landed then
self.landed=k
self:effect(e.BRICK)
end
if self.phaseTimer<=0 then
self.phase=m
self.phaseTimer=A
end
elseif c==m then
self:steerPaddle(input)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=v
end
elseif c==v then
if input and input.pressed.start then
self.paused=not self.paused
self:effect(e.CONFIRM)
end
if not self.paused then
self:tickPlay(input)
end
elseif c==w then
self.paddle.letGo=math.max(self.paddle.letGo-1,0)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
if self.lives>0 then
self.paddle:reset()
self:serve()
self.phase=m
self.phaseTimer=A
else
self:gameOver()
end
end
elseif c==s then
self.field:update()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextRound()
end
elseif c==t then
self.phaseTimer=self.phaseTimer-1
local k=input and(input.pressed.a or input.pressed.start)and self.phaseTimer<C-S
if k or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:drawHud(screen)
local c=self.art
screen:layers(c.hud,0,b.cell,b.height,b.headX,b.headY,b.headShades)
screen:number(self.lives,b.livesX,b.digitsY,c.digits,"left",1,1)
screen:number(self.score,b.scoreX,b.digitsY,c.digits,"centre",b.scoreDigits,1)
screen:layers(c.hud,b.cell,b.cell,b.height,b.iconX,b.iconY,b.iconShades)
screen:number(self.round,b.roundRight,b.digitsY,c.digits,"right",b.roundDigits,1)
end

local function k(screen,first,second)
screen:rect(l.LEFT,i.y,l.RIGHT-l.LEFT,i.height,q.r,q.g,q.b,1)
local c=F/2
if second then
screen:textCentre(first,c,i.first,d.r,d.g,d.b,1)
screen:textCentre(second,c,i.second,d.r,d.g,d.b,1)
return
end
screen:textCentre(first,c,math.floor((i.first+i.second)/2),d.r,d.g,d.b,1)
end

function a:drawRun(screen)
local c=self.art
screen:clear(d.r,d.g,d.b)
screen:layers(c.backdrops,(self.backdrop-1)*h.width,h.width,h.height,h.x,h.y,h.shades)
screen:layers(c.frame,0,n.width,n.height,n.x,n.y,G)
if self.phase==r then
self.field:drawBuilding(screen,c.bricks,self.field:buildTicks()-self.phaseTimer)
else
self.field:draw(screen,c.bricks,c.burst)
end
self.items:draw(screen,c.items)
self.paddle:draw(screen,c.planks,c.spiffo)
for x,o in ipairs(self.balls)do
o:draw(screen,c.ball)
end
self:drawHud(screen)
local o=self.phase
if o==m then
k(screen,g("Round",self.round),g("Ready"))
elseif self.paused then
k(screen,getText("UI_SpiffBoy_Paused"))
elseif o==s then
k(screen,g("RoundClear"))
elseif o==t then
k(screen,g("AllClear"),g("Score").." "..tostring(self.score))
elseif o==z then
k(screen,g("GameOver"))
end
end

function a:draw(screen)
if self.mode==a.MODE_RUN then
self:drawRun(screen)
else
self:drawMenu(screen)
end
end

require"SpiffBoy/Games/BrickBash/Menus"
