require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Fighter"
require"SpiffBoy/Games/StreetBiter/Brain"
require"SpiffBoy/Games/StreetBiter/Match"
require"SpiffBoy/Games/StreetBiter/Stage"
require"SpiffBoy/Games/StreetBiter/Link"
require"SpiffBoy/Games/StreetBiter/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyStreetBiterGame=SpiffBoyGameBase:derive("SpiffBoyStreetBiterGame")

local a=SpiffBoyStreetBiterGame
local e=SpiffBoy.StreetBiter
local c=e.Roster
local i=e.Brain
local n=e.Match
local r=e.Stage
local g=e.Link
local b=e.Music

local j=SpiffBoy.Cartridges.SHADES[4]
local k=SpiffBoy.Cartridges.SHADES[1]
local s=SpiffBoy.GameTexts.of("StreetBiter")
a.gameText=s

local t=120
local u=150
local o=90
local v=150
local w=3
local x=4
local y=3
local z=2000000000
local p={up=false,down=false,left=false,right=false,a=false,b=false}

a.MODE_TITLE="title"
a.MODE_OPTIONS="options"
a.MODE_WAITING="waiting"
a.MODE_SELECT="select"
a.MODE_VERSUS="versus"
a.MODE_FIGHT="fight"
a.MODE_RESULT="result"
a.MODE_CONTINUE="continue"
a.MODE_OVER="over"
a.MODE_ENDING="ending"

a.PAUSE_MENU="menu"
a.PAUSE_MOVES="moves"
a.PAUSE_OPTIONS="options"

local A={{-1,0},{1,0},{0,-1},{0,1}}

local function q(d,f,h,l)
for B,m in ipairs(A)do
d:textCentre(f,h+m[1],l+m[2],j.r,j.g,j.b,1)
end
d:textCentre(f,h,l,k.r,k.g,k.b,1)
end
a.haloCentre=q

local function B(h)
local d,f=h.held,h.pressed
return{
up=d.up or f.up,down=d.down or f.down,left=d.left or f.left,
right=d.right or f.right,a=d.a or f.a,b=d.b or f.b,
}
end

function a:init()
local d=self.context.art
self.sheets={}
for h,f in ipairs(c.LIST)do
self.sheets[f.id]={d(f.id),d(f.id.."2")}
end
self.effects=d("effects")
self.portraits=d("portraits")
self.logo=d("logo")
self.stages={}
self:readChoices()
self.port=g.new(self.link)
self.clock=0
self.twoPlayer=false
self.paused=false
self:openTitle()
end

function a:stageOf(d)
if not self.stages[d]then
self.stages[d]=r.new(self.context.art,d)
end
return self.stages[d]
end

function a:applyMusic()
self.sequencer:setMix(self.options.music and 1 or 0,1)
end

function a:keepMusic(d)
if not self.sequencer:isPlaying()then
self.sequencer:play(d)
end
end

function a:effect(d)
self.sequencer:effect(d)
end

function a:level()
return i.LEVELS[self.setup.difficulty]
end

function a:myFighter()
return c.LIST[self.myChoice]
end

function a:mySide()
if self.twoPlayer and self.port:seat()==2 then
return 2
end
return 1
end

function a:tick(f,h)
self.clock=self.clock+1
self:pollLink()
local d=f[1]
if self.mode==a.MODE_FIGHT then
self:tickFight(d)
else
self:tickMenu(d)
end
end

function a:pollLink()
local h=self.port
local m=h:poll(self.clock)
local d=self.mode
local C=d==a.MODE_WAITING or d==a.MODE_SELECT and self.twoPlayer or d==a.MODE_VERSUS and self.twoPlayer or d==a.MODE_FIGHT and self.twoPlayer or d==a.MODE_RESULT and self.twoPlayer
if C and not h:isConnected()then
self:openTitle()
return
end
for D,f in ipairs(m)do
local l=f.kind
d=self.mode
if d==a.MODE_WAITING and l==g.KIND_HELLO then
h:hello()
self:openSelect(true)
elseif d==a.MODE_SELECT and self.twoPlayer and l==g.KIND_CHOICE then
if f.index>=1 and f.index<=c.COUNT then
self.peerChoice=f.index
if self.myChoice then
self:openVersus()
end
end
elseif d==a.MODE_VERSUS and self.twoPlayer and l==g.KIND_START and not h:leads()then
self:createLinkedMatch(f.delay)
end
end
end

function a:openTitle()
self.mode=a.MODE_TITLE
self.menuIndex=1
self.twoPlayer=false
self.paused=false
self.match=nil
self.port:reset()
self.sequencer:stop()
end

function a:openWaiting()
self.mode=a.MODE_WAITING
self.twoPlayer=true
self.port:reset()
self.port:forgetMeasure()
self.port:hello()
end

function a:openSelect(d)
self.mode=a.MODE_SELECT
self.twoPlayer=d
self.cursor=self.cursor or 1
self.myChoice=nil
self.peerChoice=nil
self.match=nil
self.paused=false
self.sequencer:stop()
end

function a:startRun(d)
self.myChoice=d
self.ladder=c.ladder(d)
self.ladderIndex=1
self:openVersus()
end

function a:pairing()
if self.twoPlayer then
if self.port:seat()==1 then
return c.LIST[self.myChoice],c.LIST[self.peerChoice]
end
return c.LIST[self.peerChoice],c.LIST[self.myChoice]
end
return c.LIST[self.myChoice],c.LIST[self.ladder[self.ladderIndex]]
end

function a:openVersus()
self.mode=a.MODE_VERSUS
self.versusTimer=t
self.paused=false
self.sequencer:stop()
self:effect(b.CONFIRM)
local h,d=self:pairing()
self.matchArt={sheets=self.sheets,effects=self.effects,stage=self:stageOf(d.stage)}
if not self.twoPlayer then
local f=i.settings(self:level(),self.ladderIndex-1)
self.match=n.new(h,d,i.new(f,self.random),self:level().damage)
return
end
self.match=nil
if self.port:leads()then
self.port:nextMatch()
local f=self.port:delay()
self.port:sendStart(self.random:int(1,z),f)
self:createLinkedMatch(f)
end
end

function a:createLinkedMatch(d)
local f,h=self:pairing()
self.match=n.new(f,h,nil,1)
self.delay=d
self.simTick=0
self.frame=0
self.prefillTick=0
self.sentTick=d-1
end

function a:openFight()
self.mode=a.MODE_FIGHT
self.paused=false
self.pauseScreen=a.PAUSE_MENU
self.pauseIndex=1
self.sequencer:stop()
end

function a:prefill()
local d=0
while self.prefillTick<self.delay and d<w do
self.port:sendInput(self.prefillTick,p)
self.prefillTick=self.prefillTick+1
d=d+1
end
return d
end

function a:pause()
self.paused=true
self.pauseScreen=a.PAUSE_MENU
self.pauseIndex=1
self:effect(b.PAUSE)
end

function a:resume()
self.paused=false
self:effect(b.CONFIRM)
end

function a:tickFight(d)
if self.paused then
self:tickPause(d)
return
end
if d and d.pressed.start and not self.twoPlayer then
self:pause()
return
end
local f=p
if d then
f=B(d)
end
if self.twoPlayer then
self:tickLinkedFight(f)
else
self.match:tick(f,nil)
end
self:hearMatch()
if self.match:isOver()then
self:endFight()
end
end

function a:tickLinkedFight(C)
local d=self.port
local f=self:prefill()
self.frame=self.frame+1
local D=self.frame-1+self.delay
while self.sentTick<D and f<x and self.prefillTick>=self.delay do
self.sentTick=self.sentTick+1
d:sendInput(self.sentTick,C)
f=f+1
end
local h=0
while h<y and self.simTick<self.frame and not self.match:isOver()do
local l=d:localInput(self.simTick)
local m=d:remoteInput(self.simTick)
if not l or not m then
break
end
if d:seat()==1 then
self.match:tick(l,m)
else
self.match:tick(m,l)
end
self.simTick=self.simTick+1
h=h+1
end
end

function a:hearMatch()
local h=self:mySide()
for l,f in ipairs(self.match:takeEvents())do
local d=f.kind
if d=="swing"then
self:effect(f.special and b.SPECIAL or b.WHOOSH)
elseif d=="jump"then
self:effect(b.JUMP)
elseif d=="thud"then
self:effect(b.THUD)
elseif d=="projectile"then
self:effect(b.PROJECTILE)
elseif d=="block"then
self:effect(b.BLOCK)
elseif d=="hit"then
self:effect(f.heavy and b.HIT_HEAVY or b.HIT_LIGHT)
elseif d=="ko"then
self.sequencer:stop()
self:effect(b.KO_HIT)
elseif d=="round"then
self.sequencer:stop()
self:effect(b.ROUND)
elseif d=="fight"then
self.sequencer:play(b.STAGE[self.match.definitions[2].stage])
elseif d=="roundEnd"then
self.sequencer:stop()
if f.winner==h then
self.sequencer:play(b.WIN)
elseif f.winner~=nil or f.double then
self.sequencer:play(b.LOSE)
end
end
end
end

function a:endFight()
local d=self.match.result.winner
self.mode=a.MODE_RESULT
if self.twoPlayer then
self.resultTimer=u
if d==nil then
self.resultText="Draw"
elseif d==self:mySide()then
self.resultText="YouWin"
else
self.resultText="YouLose"
end
return
end
if d==1 then
self.resultTimer=o
self.resultText="Wins"
self.resultName=self:myFighter().name
return
end
self.resultTimer=o
self.resultText="Wins"
self.resultName=self.match.definitions[2].name
if d==nil then
self.resultName=nil
self.resultText="Draw"
end
end

function a:leaveResult()
if self.twoPlayer then
self:openSelect(true)
return
end
if self.match.result.winner==1 then
self.ladderIndex=self.ladderIndex+1
if self.ladderIndex>#self.ladder then
self:openEnding()
else
self:openVersus()
end
return
end
self.mode=a.MODE_CONTINUE
self.continueCount=9
self.continueTimer=60
self.continueYes=true
self.sequencer:stop()
self.sequencer:play(b.CONTINUE)
end

function a:openEnding()
self.mode=a.MODE_ENDING
self.endingTimer=0
self.sequencer:stop()
self.sequencer:play(b.ENDING)
end

function a:gameOver()
self.mode=a.MODE_OVER
self.overTimer=v
self.sequencer:stop()
self.sequencer:play(b.OVER)
end

function a:draw(d)
if self.mode==a.MODE_FIGHT then
self.match:draw(d,self.matchArt,q)
if self.paused then
self:drawPause(d)
end
return
end
self:drawMenu(d)
end

require"SpiffBoy/Games/StreetBiter/Menus"
