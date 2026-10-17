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
local g=SpiffBoy.BrickBash
local q=g.Rounds
local m=g.Field
local D=g.Paddle
local E=g.Ball
local k=g.Items
local v=g.Records
local e=g.Music

local d=SpiffBoy.Cartridges.SHADES[4]
local r=SpiffBoy.Cartridges.SHADES[1]
local F=SpiffBoy.Cartridges.SCREEN_WIDTH
local h=SpiffBoy.GameTexts.of("BrickBash")
a.gameText=h

a.MODES={{key="c",text="ModeA",endless=false},{key="e",text="ModeB",endless=true}}

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_INITIALS="initials"

local s="build"
local n="intro"
local w="play"
local x="lost"
local t="clear"
local u="allClear"
local y="over"

local G={1,2,3,4}
local i={x=4,y=16,width=172,height=104,shades={3}}
local o={x=0,y=12,width=180,height=108}
local b={headX=3,headY=2,livesX=14,digitsY=3,scoreX=90,scoreDigits=6,iconX=150,iconY=2,roundRight=177,roundDigits=2,cell=10,height=8,headShades={1,2,3},iconShades={1,3}}
local j={y=54,height=38,first=57,second=73}
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
local z=120
local A=90
local R=150
local B=480
local S=180
local T=120

function a:trace(c)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("BrickBash: "..c)
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
self.records=v.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self:openTitle()
end

function a:keepMusic(c)
if not self.sequencer:isPlaying()then
self.sequencer:play(c)
end
end

function a:effect(c)
self.sequencer:effect(c)
end

function a:persistRecords()
self.save.records=v.write(self.records)
self:persist()
end

function a:tick(f,l)
self.clock=self.clock+1
local c=f[1]
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

function a:startRound(c)
self.round=c
local f=q.definition(self.playMode.endless,c,self.random)
self.field=m.new(f)
self.backdrop=q.backdropOf(c)
self.paddle=D.new()
self.items=k.new()
self.baseSpeed=math.min(M,K+(c-1)*L)
self:serve()
self.phase=s
self.phaseTimer=self.field:buildTicks()
self.landed=0
self.sequencer:stop()
self.sequencer:play(e.START)
self:trace("round "..c.." mode "..self.modeKey.." bricks "..self.field.remaining.." lives "..self.lives.." score "..self.score)
end

function a:addScore(c)
self.score=self.score+c
end

function a:brickBroken(c,f)
if#self.balls==1 then
self.items:maybeDrop(self.random,c,f)
end
end

function a:applySpeed()
for f,c in ipairs(self.balls)do
c:setSpeed(self.speed)
end
end

function a:ballReturned(c)
self.speed=math.min(self.baseSpeed+O,self.speed+N)
self:applySpeed()
end

function a:launchBalls()
local c=false
for l,f in ipairs(self.balls)do
if f.stuck then
f:launch(self.paddle)
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
for f=1,c do
for p,l in ipairs(self.balls[f]:split())do
if#self.balls<J then
self.balls[#self.balls+1]=l
end
end
end
end

function a:applyItem(c)
self:addScore(Q)
self:trace("caught "..c)
if c==k.LIFE then
self.lives=math.min(I,self.lives+1)
self:effect(e.LIFE)
return
end
self:effect(e.CATCH)
if c==k.WIDE then
self.paddle:setPower(true,false)
self:launchBalls()
elseif c==k.GLUE then
self.paddle:setPower(false,true)
elseif c==k.SLOW then
self.speed=self.baseSpeed*P
self:applySpeed()
else
self:splitBalls()
end
end

function a:loseBall()
self.lives=self.lives-1
self.paddle.letGo=A
self.items:clear()
self.phase=x
self.phaseTimer=A
self.sequencer:stop()
self.sequencer:play(e.LOSE)
self:trace("ball lost on round "..self.round..", lives "..self.lives)
end

function a:roundClear()
self.balls={}
self.items:clear()
self.phase=t
self.phaseTimer=R
self.sequencer:stop()
self.sequencer:play(e.CLEAR)
end

function a:nextRound()
if not self.playMode.endless and self.round>=q.CAMPAIGN_LENGTH then
self.phase=u
self.phaseTimer=B
self.sequencer:stop()
self.sequencer:play(e.ALL_CLEAR)
self:trace("campaign cleared, score "..self.score)
return
end
self:startRound(self.round+1)
end

function a:gameOver()
self.phase=y
self.phaseTimer=T
self.sequencer:stop()
self.sequencer:play(e.OVER)
self:trace("game over on round "..self.round..", score "..self.score)
end

function a:tickPlay(c)
local f=self:chosenTrack()
if f then
self:keepMusic(f)
end
self.paddle:update(c)
if c and c.pressed.a then
self:launchBalls()
end
self.field:update()
for l=#self.balls,1,-1 do
if self.balls[l]:update(self.paddle,self.field,self)then
table.remove(self.balls,l)
end
end
local l=self.items:update(self.paddle)
if l then
self:applyItem(l)
end
if self.field.remaining<=0 then
self:roundClear()
elseif#self.balls==0 then
self:loseBall()
end
end

function a:steerPaddle(c)
self.paddle:update(c)
for l,f in ipairs(self.balls)do
f:follow(self.paddle)
end
end

function a:tickRun(c)
local f=self.phase
if f==s then
self:steerPaddle(c)
self.phaseTimer=self.phaseTimer-1
local l=self.field:landedRows(self.field:buildTicks()-self.phaseTimer)
if l>self.landed then
self.landed=l
self:effect(e.BRICK)
end
if self.phaseTimer<=0 then
self.phase=n
self.phaseTimer=z
end
elseif f==n then
self:steerPaddle(c)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self.phase=w
end
elseif f==w then
if c and c.pressed.start then
self.paused=not self.paused
self:effect(e.CONFIRM)
end
if not self.paused then
self:tickPlay(c)
end
elseif f==x then
self.paddle.letGo=math.max(self.paddle.letGo-1,0)
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
if self.lives>0 then
self.paddle:reset()
self:serve()
self.phase=n
self.phaseTimer=z
else
self:gameOver()
end
end
elseif f==t then
self.field:update()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextRound()
end
elseif f==u then
self.phaseTimer=self.phaseTimer-1
local l=c and(c.pressed.a or c.pressed.start)and self.phaseTimer<B-S
if l or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:drawHud(c)
local f=self.art
c:layers(f.hud,0,b.cell,b.height,b.headX,b.headY,b.headShades)
c:number(self.lives,b.livesX,b.digitsY,f.digits,"left",1,1)
c:number(self.score,b.scoreX,b.digitsY,f.digits,"centre",b.scoreDigits,1)
c:layers(f.hud,b.cell,b.cell,b.height,b.iconX,b.iconY,b.iconShades)
c:number(self.round,b.roundRight,b.digitsY,f.digits,"right",b.roundDigits,1)
end

local function l(c,p,C)
c:rect(m.LEFT,j.y,m.RIGHT-m.LEFT,j.height,r.r,r.g,r.b,1)
local f=F/2
if C then
c:textCentre(p,f,j.first,d.r,d.g,d.b,1)
c:textCentre(C,f,j.second,d.r,d.g,d.b,1)
return
end
c:textCentre(p,f,math.floor((j.first+j.second)/2),d.r,d.g,d.b,1)
end

function a:drawRun(c)
local f=self.art
c:clear(d.r,d.g,d.b)
c:layers(f.backdrops,(self.backdrop-1)*i.width,i.width,i.height,i.x,i.y,i.shades)
c:layers(f.frame,0,o.width,o.height,o.x,o.y,G)
if self.phase==s then
self.field:drawBuilding(c,f.bricks,self.field:buildTicks()-self.phaseTimer)
else
self.field:draw(c,f.bricks,f.burst)
end
self.items:draw(c,f.items)
self.paddle:draw(c,f.planks,f.spiffo)
for C,p in ipairs(self.balls)do
p:draw(c,f.ball)
end
self:drawHud(c)
local p=self.phase
if p==n then
l(c,h("Round",self.round),h("Ready"))
elseif self.paused then
l(c,getText("UI_SpiffBoy_Paused"))
elseif p==t then
l(c,h("RoundClear"))
elseif p==u then
l(c,h("AllClear"),h("Score").." "..tostring(self.score))
elseif p==y then
l(c,h("GameOver"))
end
end

function a:draw(c)
if self.mode==a.MODE_RUN then
self:drawRun(c)
else
self:drawMenu(c)
end
end

require"SpiffBoy/Games/BrickBash/Menus"
