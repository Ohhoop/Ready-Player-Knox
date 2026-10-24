require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/DrTile/Board"
require"SpiffBoy/Games/DrTile/Records"
require"SpiffBoy/Games/DrTile/Music"
require"SpiffBoy/Games/DrTile/Window"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyDrTileGame=SpiffBoyGameBase:derive("SpiffBoyDrTileGame")

local h=SpiffBoy.DrTile.Board
local t=SpiffBoy.DrTile.Records
local a=SpiffBoy.DrTile.Music
local j=SpiffBoy.DrTile.Window

local d=SpiffBoy.Cartridges.SHADES[4]
local g=SpiffBoy.Cartridges.SHADES[1]
local u=SpiffBoy.Cartridges.SHADES[2]
local m=SpiffBoy.Cartridges.SCREEN_WIDTH
local c=SpiffBoy.GameTexts.of("DrTile")

local b=6
local D=8
local B=16
local i=68
local n=14
local k=D*b
local E=B*b
local F=3
local G=0
local r=3
local at=5
local Y=2
local au=12
local av=2
local aw=28
local a8=2

local a9=1
local ba=4
local bb=7
local bc=11
local ax={{1,3},{1,2,3},{1}}
local bd={{1,2,3},{1,2,3},{1,2}}
local be=3
local Z=16
local bf=256/Z*b
local _={1,3,1,2,3,1,3,1,2,3,1,3,2,1,2,1,1,2}
local bg={{1,2},{3,4,5},{6}}
local bh={{1,7},{8,9,10},{11}}
local bi={{1,12,13},{14,15,5},{16,13}}
local bj={17,18}

local ay=24
local bk=34
local bl={1,2,3}
local aa=1
local bm=2
local bn=3
local bo=4
local az=5
local aA=6
local aB=7
local bp={[aa]=true,[az]=true,[aA]=true,[aB]=true}
local bq=45
local br=2
local bs=15
local bt=3
local H=12
local bu=38
local aC=18
local bv=15
local bw=30
local bx=2
local aD=137
local aE=84
local ab=aD-1
local ac=aE-b
local aF=18
local by=24

local bz=i-1-r
local aG=i+k+1+r
local bA=math.floor(bz/2)
local aH=aG+math.floor((m-aG)/2)
local bB=4
local bC=18
local bD=40
local bE=54
local bF=76
local bG=90
local bH=4
local bI=18
local bJ=58

local aI={39,37,35,33,31,29,27,25,23,21,19,18,17,16,15,14,13,12,11,10,9,9,8,8,7,7,6,6,5,5,5,5,4,4,4,4,3}
local I={{text="Slow",step=1,score=100},{text="Medium",step=11,score=200},{text="Fast",step=21,score=300}}
local bK=10
local bL=2
local bM=12
local bN=5
local aJ={1,2,4,8,16,32}
local bO=18
local aK=7
local bP=90
local bQ=150
local aL=3
local bR=90
local bS=12
local bT=20
local bU=12
local bV=4
local bW=3
local bX=2
local bY=6
local bZ=5

local v="title"
local ad="setup"
local C="options"
local ae="confirm"
local af="scores"
local ag="run"
local aM="initials"

local ah="ready"
local J="throw"
local ai="fall"
local aj="clear"
local aN="settle"
local K="repaired"
local L="curtain"
local M="over"

local s={{key="a",text="ModeA"},{key="b",text="ModeB"}}
local N={"MusicA","MusicB","MusicOff"}
local b_=#N
local O={{key="mode",text="Mode"},{key="level",text="StartLevel"},{key="speed",text="Speed"},{key="music",text="Music"}}
local w={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local P={"Play","HighScores","Options"}

local b0=133
local aO=23
local b1=math.floor((m-b0)/2)
local aP=6
local b2={1,2,3}
local aQ=2
local z={{x=0,w=15},{x=20,w=15},{x=38,w=15},{x=56,w=3},{x=62,w=15},{x=80,w=15},{x=98,w=15},{x=116,w=15}}
local ak=20
local aR=10
local b3=20
local b4={{x=10,y=108,colour=1},{x=20,y=108,colour=2},{x=30,y=108,colour=3}}
local aS=148
local aT=84
local b5=40
local b6=16
local aU=4

local b7=8
local b8=22
local b9=13
local al=12
local aV=168
local ca=78
local aW=81
local cb=2
local cc=30
local cd=24
local ce=92
local am=5
local aX=1
local an=8
local cf=4
local cg=34
local ch=150
local ao=80
local aY=32
local aZ=23
local ci=114
local Q={score=26,prompt=52,letters=78}
local o={rank=-26,initials=-22,score=42,arrow=50,left=-44,right=46}
local ap={ticks=15,count=4}
local R=4
local cj=string.char(0x25B4)
local ck=string.char(0x25BE)
local cl="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local cm=62
local S=t.INITIALS_LENGTH
local cn=30
local co=20
local a_=12
local cp=2
local T={delay=24,start=8,min=2,speedup=30}
local p=a.MIX_STEPS

local function q(value,count)
return(value-1+count)%count+1
end

local function cq(value,count)
return(value+count)%count
end

local function A(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function aq(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function a0(index)
return string.sub(cl,index,index)
end

local function a1(screen)
screen:clear(d.r,d.g,d.b)
end

local function ar(screen,label,x,y)
screen:text(label,x,y,g.r,g.g,g.b,1)
end

local function e(screen,label,x,y)
screen:textCentre(label,x,y,g.r,g.g,g.b,1)
end

local function l(screen,x,y,width,height)
screen:rect(x,y,width,height,g.r,g.g,g.b,1)
end

local cr={{-1,0},{1,0},{0,-1},{0,1}}

local function cs(screen,label,x,y)
for U,f in ipairs(cr)do
screen:textCentre(label,x+f[1],y+f[2],d.r,d.g,d.b,1)
end
e(screen,label,x,y)
end

local function a2(step)
return aI[math.min(step,#aI)]
end

local function ct(save)
local x={mode=1,level=0,speed=1,music=1}
local f=save.setup
if type(f)~="table"then
return x
end
if SpiffBoy.isInteger(f.mode)and f.mode>=1 and f.mode<=#s then
x.mode=f.mode
end
if SpiffBoy.isInteger(f.level)and f.level>=0 and f.level<=h.MAX_LEVEL then
x.level=f.level
end
if SpiffBoy.isInteger(f.speed)and f.speed>=1 and f.speed<=#I then
x.speed=f.speed
end
if SpiffBoy.isInteger(f.music)and f.music>=1 and f.music<=#N then
x.music=f.music
end
return x
end

local function cu(save)
local x={music=p,effects=p}
local U=save.options
if type(U)~="table"then
return x
end
for V,y in ipairs(w)do
local f=y.key and U[y.key]
if SpiffBoy.isInteger(f)and f>=0 and f<=p then
x[y.key]=f
end
end
return x
end

function SpiffBoyDrTileGame:init()
self.cells=self.context.art("cells")
self.rows=self.context.art("rows")
self.logo=self.context.art("logo")
self.doctor=self.context.art("doctor")
self.giants=self.context.art("giants")
self.window=j.new(self.cells,(bc-1)*b,b)
self.records=t.read(self.save)
self.mix=cu(self.save)
self.mixDirty=false
self.setup=ct(self.save)
self.setupDirty=false
self.menuIndex=1
self.setupIndex=1
self.optionIndex=1
self.clock=0
self.score=0
self.mode=v
self.transition=0
self.introTick=0
self.introDone=false
self.partsHealed=0
self:applyMix()
end

function SpiffBoyDrTileGame:setMode(mode)
self.mode=mode
self.transition=j.TUBE_TICKS
end

function SpiffBoyDrTileGame:applyMix()
self.sequencer:setMix(self.mix.music/p,self.mix.effects/p)
end

function SpiffBoyDrTileGame:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function SpiffBoyDrTileGame:keepTrack()
if self.setup.music~=b_ then
self:keepMusic(a.TRACKS[self.setup.music])
end
end

function SpiffBoyDrTileGame:gameMode()
return s[self.setup.mode]
end

function SpiffBoyDrTileGame:persistRecords()
self.save.records=t.write(self.records)
self:persist()
end

function SpiffBoyDrTileGame:tick(inputs,tick)
self.clock=self.clock+1
if self.transition>0 then
self.transition=self.transition-1
end
local f=inputs[1]
if self.mode==ag then
self:tickRun(f)
elseif self.mode==aM then
self:keepMusic(a.TITLE)
self:tickInitials(f)
elseif self.mode==ad then
self:keepTrack()
self:tickSetup(f)
else
if self.introDone then
self:keepMusic(a.TITLE)
end
if self.mode==v then
self:tickTitle(f)
elseif self.mode==C then
self:tickOptions(f)
elseif self.mode==ae then
self:tickConfirm(f)
else
self:tickScores(f)
end
end
end

local function cv(tick)
if tick<ak then
return 0
end
return math.min(#z,math.floor((tick-ak)/aR)+1)
end

function SpiffBoyDrTileGame:tickIntro(input)
if input and(input.pressed.a or input.pressed.b or input.pressed.start)then
self:endIntro()
return
end
self.introTick=self.introTick+1
local f=cv(self.introTick)
if f>self.partsHealed then
self.partsHealed=f
self.sequencer:effect(a.HEAL)
end
if f==#z and self.introTick>=ak+(#z-1)*aR+b3 then
self:endIntro()
end
end

function SpiffBoyDrTileGame:endIntro()
self.introDone=true
self.partsHealed=#z
self.sequencer:play(a.TITLE)
end

function SpiffBoyDrTileGame:tickTitle(input)
if not self.introDone then
self:tickIntro(input)
return
end
if not input then
return
end
local f=input.pressed
local x=A(f)
if x~=0 then
self.menuIndex=q(self.menuIndex+x,#P)
self.sequencer:effect(a.TICK)
end
if f.a or f.start then
local y=P[self.menuIndex]
self.sequencer:effect(a.CONFIRM)
if y=="Play"then
self:openSetup()
elseif y=="Options"then
self:openOptions()
else
self:showScores(self.setup.mode,1)
end
end
end

function SpiffBoyDrTileGame:openSetup()
self.setupIndex=1
self:setMode(ad)
self.sequencer:stop()
end

function SpiffBoyDrTileGame:saveSetup()
if self.setupDirty then
local f=self.setup
self.save.setup={mode=f.mode,level=f.level,speed=f.speed,music=f.music}
self:persist()
self.setupDirty=false
end
end

function SpiffBoyDrTileGame:closeSetup()
self:saveSetup()
self.sequencer:stop()
self:setMode(v)
end

function SpiffBoyDrTileGame:turnSetup(delta)
local f=self.setup
local x=O[self.setupIndex].key
if x=="mode"then
f.mode=q(f.mode+delta,#s)
elseif x=="level"then
f.level=cq(f.level+delta,h.MAX_LEVEL+1)
elseif x=="speed"then
f.speed=q(f.speed+delta,#I)
else
f.music=q(f.music+delta,#N)
self.sequencer:stop()
end
self.setupDirty=true
self.sequencer:effect(a.TICK)
end

function SpiffBoyDrTileGame:tickSetup(input)
if not input then
return
end
local f=input.pressed
local x=A(f)
if x~=0 then
self.setupIndex=q(self.setupIndex+x,#O)
self.sequencer:effect(a.TICK)
end
local y=aq(f)
if y~=0 then
self:turnSetup(y)
end
if f.a or f.start then
self:saveSetup()
self:startRun()
elseif f.b then
self.sequencer:effect(a.CONFIRM)
self:closeSetup()
end
end

function SpiffBoyDrTileGame:openOptions()
self.optionIndex=1
self:setMode(C)
end

function SpiffBoyDrTileGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self:setMode(v)
end

function SpiffBoyDrTileGame:turnOption(delta)
local f=w[self.optionIndex]
if not f.key then
return
end
local x=SpiffBoy.clamp(self.mix[f.key]+delta,0,p)
if x==self.mix[f.key]then
return
end
self.mix[f.key]=x
self.mixDirty=true
self:applyMix()
self.sequencer:effect(a.STEP..x)
end

function SpiffBoyDrTileGame:tickOptions(input)
if not input then
return
end
local f=input.pressed
local x=A(f)
if x~=0 then
self.optionIndex=q(self.optionIndex+x,#w)
self.sequencer:effect(a.TICK)
end
local y=aq(f)
if y~=0 then
self:turnOption(y)
end
if f.b or f.start then
self.sequencer:effect(a.CONFIRM)
self:closeOptions()
elseif f.a then
self.sequencer:effect(a.CONFIRM)
if w[self.optionIndex].action then
self.confirmYes=false
self:setMode(ae)
else
self:closeOptions()
end
end
end

function SpiffBoyDrTileGame:tickConfirm(input)
if not input then
return
end
local f=input.pressed
if f.left or f.right or f.up or f.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(a.TICK)
end
if f.b then
self.sequencer:effect(a.CONFIRM)
self:setMode(C)
elseif f.a or f.start then
self.sequencer:effect(a.CONFIRM)
if self.confirmYes then
self.records=t.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self:setMode(C)
end
end

function SpiffBoyDrTileGame:pageRecords(page)
return self.records[s[page].key]
end

function SpiffBoyDrTileGame:scoresRows()
local f=self.screen:lineHeight()
return aZ,math.floor((ci-aZ)/f)
end

function SpiffBoyDrTileGame:clampScoresTop(page,first)
local x,f=self:scoresRows()
return SpiffBoy.clamp(first,1,#self:pageRecords(page)-f+1)
end

function SpiffBoyDrTileGame:showScores(page,rank)
self:setMode(af)
self.scoresPage=page
self.scoresTop=self:clampScoresTop(page,rank)
end

function SpiffBoyDrTileGame:flashRank(rank)
self.flashRankIndex=rank
self.flashUntil=self.clock+ap.ticks*ap.count*2
end

function SpiffBoyDrTileGame:isRankInverted(rank)
if rank~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/ap.ticks)%2==1
end

function SpiffBoyDrTileGame:tickScores(input)
if not input then
return
end
local f=input.pressed
local x=A(f)
local y=aq(f)
if x~=0 then
local U=self:clampScoresTop(self.scoresPage,self.scoresTop+x)
if U~=self.scoresTop then
self.scoresTop=U
self.sequencer:effect(a.TICK)
end
elseif y~=0 then
self.flashRankIndex=nil
self:showScores(q(self.scoresPage+y,#s),1)
self.sequencer:effect(a.TICK)
elseif f.a or f.b or f.start then
self.sequencer:effect(a.CONFIRM)
self:setMode(v)
end
end

function SpiffBoyDrTileGame:startRun()
self.modeKey=self:gameMode().key
self.startLevel=self.setup.level
self.level=self.startLevel
self.speed=I[self.setup.speed]
self.speedStep=self.speed.step
self.patches=0
self.score=0
self.repaired=0
self.sinceRise=0
self.paused=false
self.next={self:drawColour(),self:drawColour()}
self.piece={x=F,y=G,orientation=0,first=1,second=1}
self:setMode(ag)
self.sequencer:stop()
self.sequencer:play(a.START)
self:startLevelBoard()
end

function SpiffBoyDrTileGame:drawColour()
return self.random:int(1,h.COLOURS)
end

function SpiffBoyDrTileGame:startLevelBoard()
self.board=h.new(D,B)
self.board:fillGlitches(self.level,self.random)
self.kindLeft=nil
self.flinch={0,0,0}
self.adjustTimer=0
self:countGlitches()
self.phase=ah
self.phaseTimer=bP
end

function SpiffBoyDrTileGame:countGlitches()
local x=self.board:glitchCounts()
local y=0
for f=1,h.COLOURS do
if self.kindLeft and x[f]<self.kindLeft[f]then
self.flinch[f]=bw
end
y=y+x[f]
end
self.kindLeft=x
self.glitchesLeft=y
end

function SpiffBoyDrTileGame:endlessLevel()
return self.startLevel+math.floor(self.repaired/bT)
end

function SpiffBoyDrTileGame:riseInterval()
return math.max(bV,bU-math.floor(self.level/bW))
end

function SpiffBoyDrTileGame:riseCount()
return math.min(bY,bX+math.floor(self.level/bZ))
end

function SpiffBoyDrTileGame:throwPatch()
self.flying=self.next
self.next={self:drawColour(),self:drawColour()}
self.phase=J
self.phaseTimer=aF
self.sequencer:effect(a.THROW)
end

function SpiffBoyDrTileGame:spawn()
local f=self.piece
f.x=F
f.y=G
f.orientation=0
f.first=self.flying[1]
f.second=self.flying[2]
self.flying=nil
self.patches=self.patches+1
self.speedStep=self.speed.step+math.floor(self.patches/bK)
self.dropTimer=a2(self.speedStep)
self.softBlocked=true
self.repeatTimer=0
self.chainGlitches=0
self.chainStep=0
if not self.board:fits(F,G,0)then
self:topOut()
return
end
self.phase=ai
end

function SpiffBoyDrTileGame:shift(direction)
local f=self.piece
if self.board:fits(f.x+direction,f.y,f.orientation)then
f.x=f.x+direction
self.sequencer:effect(a.MOVE)
end
end

function SpiffBoyDrTileGame:rotate(direction)
local f=self.piece
local x=(f.orientation+direction+4)%4
if self.board:fits(f.x,f.y,x)then
f.orientation=x
self.sequencer:effect(a.ROTATE)
elseif h.isFlat(x)and self.board:fits(f.x-1,f.y,x)then
f.x=f.x-1
f.orientation=x
self.sequencer:effect(a.ROTATE)
end
end

function SpiffBoyDrTileGame:fall()
local f=self.piece
if self.board:fits(f.x,f.y+1,f.orientation)then
f.y=f.y+1
return true
end
self:lock()
return false
end

function SpiffBoyDrTileGame:lock()
local f=self.piece
if not self.board:place(f.x,f.y,f.orientation,f.first,f.second)then
self:topOut()
return
end
self.sequencer:effect(a.LOCK)
self:resolve()
end

function SpiffBoyDrTileGame:resolve()
local f,x=self.board:matches()
if x==0 then
self:endTurn()
return
end
self.clearSet=f
self.chainStep=self.chainStep+1
if self.chainStep==br then
self.adjustTimer=bq
end
self.phase=aj
self.phaseTimer=bO
self.sequencer:effect(a.POP..math.min(self.chainStep,a.POP_LEVELS))
end

function SpiffBoyDrTileGame:finishClear()
local f=self.board:remove(self.clearSet)
self.clearSet=nil
for x=1,f do
self.chainGlitches=self.chainGlitches+1
self.score=self.score+self.speed.score*aJ[math.min(self.chainGlitches,#aJ)]
end
self:countGlitches()
if self.modeKey=="b"then
self.repaired=self.repaired+f
self.level=self:endlessLevel()
end
self.phase=aN
self.phaseTimer=aK
end

function SpiffBoyDrTileGame:tickSettle()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer>0 then
return
end
self.phaseTimer=aK
if self.board:settle()then
return
end
self:resolve()
end

function SpiffBoyDrTileGame:endTurn()
if self.modeKey=="a"and self.glitchesLeft==0 then
self:repairGrid()
return
end
if self.modeKey=="b"then
self.sinceRise=self.sinceRise+1
if self.sinceRise>=self:riseInterval()then
self.sinceRise=0
if not self.board:rise(self:riseCount(),self.random)then
self:topOut()
return
end
self:countGlitches()
self.sequencer:effect(a.RISE)
end
end
self:throwPatch()
end

function SpiffBoyDrTileGame:repairGrid()
self.phase=K
self.phaseTimer=bQ
self.sequencer:stop()
self.sequencer:play(a.REPAIRED)
end

function SpiffBoyDrTileGame:topOut()
self.phase=L
self.curtainRow=B
self.phaseTimer=aL
self.sequencer:stop()
self.sequencer:effect(a.LOSE)
end

function SpiffBoyDrTileGame:tickRun(input)
if not self.paused then
self:tickReactions()
end
if self.phase==ah then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:throwPatch()
end
elseif self.phase==J then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:spawn()
end
elseif self.phase==ai then
self:tickFall(input)
elseif self.phase==aj then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:finishClear()
end
elseif self.phase==aN then
self:keepTrack()
self:tickSettle()
elseif self.phase==K then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.level=self.level+1
self:startLevelBoard()
end
elseif self.phase==L then
self:tickCurtain()
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function SpiffBoyDrTileGame:tickReactions()
for f=1,h.COLOURS do
if self.flinch[f]>0 then
self.flinch[f]=self.flinch[f]-1
end
end
if self.adjustTimer>0 then
self.adjustTimer=self.adjustTimer-1
end
end

function SpiffBoyDrTileGame:tickFall(input)
self:keepTrack()
if input and input.pressed.start then
self.paused=not self.paused
self.sequencer:effect(a.CONFIRM)
end
if self.paused then
return
end
if input then
self:control(input)
end
local f=input and input.held.down and not self.softBlocked
if f then
self.dropTimer=math.min(self.dropTimer,bL)
end
self.dropTimer=self.dropTimer-1
if self.dropTimer<=0 then
self.dropTimer=a2(self.speedStep)
self:fall()
end
end

function SpiffBoyDrTileGame:control(input)
local y,x=input.held,input.pressed
if not y.down then
self.softBlocked=false
end
local f=0
if y.left then
f=-1
elseif y.right then
f=1
end
if x.left or x.right then
self:shift(f)
self.repeatTimer=bM
elseif f~=0 then
self.repeatTimer=self.repeatTimer-1
if self.repeatTimer<=0 then
self:shift(f)
self.repeatTimer=bN
end
end
if x.a then
self:rotate(1)
end
if x.b then
self:rotate(-1)
end
end

function SpiffBoyDrTileGame:tickCurtain()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer>0 then
return
end
self.phaseTimer=aL
self.curtainRow=self.curtainRow-1
if self.curtainRow<=0 then
self.curtainRow=0
self.phase=M
self.phaseTimer=bR
self.sequencer:play(a.OVER)
end
end

function SpiffBoyDrTileGame:offerRecord()
if t.rankOf(self.records[self.modeKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.sequencer:stop()
self:setMode(aM)
return
end
self:openSetup()
end

function SpiffBoyDrTileGame:turnLetter(step)
local f=self.cursor
self.letters[f]=q(self.letters[f]-step,cm)
self.sequencer:effect(a.TICK)
end

function SpiffBoyDrTileGame:repeatLetter(pressedStep,heldStep)
if pressedStep~=0 then
self:turnLetter(pressedStep)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=T.delay
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
self.letterRepeatTimer=math.max(T.min,T.start-math.floor(self.letterHoldTicks/T.speedup))
end
end

function SpiffBoyDrTileGame:tickInitials(input)
if not input then
return
end
local f=input.pressed
local x=self.cursor
self:repeatLetter(A(f),A(input.held))
if f.left and x>1 then
self.cursor=x-1
elseif f.right and x<S then
self.cursor=x+1
end
if f.a or f.start then
self.sequencer:effect(a.CONFIRM)
if self.cursor<S then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoyDrTileGame:saveScore()
local f=""
for x=1,S do
f=f..a0(self.letters[x])
end
local x=t.insert(self.records[self.modeKey],f,self.score)
self:persistRecords()
self:showScores(self.setup.mode,x)
self:flashRank(x)
end

function SpiffBoyDrTileGame:blinkOn()
return math.floor(self.clock/cn)%2==0
end

function SpiffBoyDrTileGame:draw(screen)
self:drawScreen(screen)
if self.transition>0 then
j.drawTube(screen,self.transition)
end
end

function SpiffBoyDrTileGame:drawScreen(screen)
if self.mode==v then
self:drawTitle(screen)
elseif self.mode==ad then
self:drawSetup(screen)
elseif self.mode==C then
self:drawOptions(screen)
elseif self.mode==ae then
self:drawConfirm(screen)
elseif self.mode==af then
self:drawScores(screen)
elseif self.mode==ag then
self:drawRun(screen)
else
self:drawInitials(screen)
end
end

function SpiffBoyDrTileGame:drawCell(screen,frame,shades,x,y)
screen:layers(self.cells,(frame-1)*b,b,b,x,y,shades)
end

function SpiffBoyDrTileGame:glitchShifted()
return math.floor(self.clock/bS)%2==1
end

function SpiffBoyDrTileGame:drawGlitch(screen,kind,x,y)
local f=a9
if self:glitchShifted()then
f=ba
end
self:drawCell(screen,f+kind-1,ax[kind],x,y)
end

local function U(masks,layers,bit)
for f=1,#layers do
masks[layers[f]]=(masks[layers[f]]or 0)+bit
end
end

local a3={}

local function a4()
for f=1,#_ do
a3[f]=nil
end
return a3
end

function SpiffBoyDrTileGame:drawRowLayers(screen,masks,y)
for f=1,#_ do
local x=masks[f]
if x then
screen:sheet(self.rows,x%Z*k,(f-1)*bf+math.floor(x/Z)*b,k,b,i,y,1,_[f])
end
end
end

function SpiffBoyDrTileGame:drawTile(screen,kind,x,y)
self:drawCell(screen,bb+kind-1,bd[kind],x,y)
end

function SpiffBoyDrTileGame:drawPatch(screen,first,second,orientation,x,y,top)
local W,f,X,V=h.patchCells(0,0,orientation)
if y+f*b>=top then
self:drawTile(screen,first,x+W*b,y+f*b)
end
if y+V*b>=top then
self:drawTile(screen,second,x+X*b,y+V*b)
end
end

function SpiffBoyDrTileGame:drawDoctor(screen,frame,x,y)
screen:layers(self.doctor,(frame-1)*ay,ay,bk,x,y,bl)
end

local function cw(screen,label,x,y,colour)
screen:text(label,x,y,colour.r,colour.g,colour.b,1)
end

function SpiffBoyDrTileGame:drawLogo(screen)
for x=1,#z do
local f=z[x]
local y=b1+f.x
if x<=self.partsHealed then
screen:layers(self.logo,f.x,f.w+aQ,aO,y,aP,b2)
else
local X=math.max(1,math.ceil(f.w/b))
local as=math.ceil((aO-aQ)/b)
for V=0,as-1 do
for W=0,X-1 do
self:drawGlitch(screen,(x+V+W)%h.COLOURS+1,y+W*b,aP+V*b)
end
end
end
end
end

function SpiffBoyDrTileGame:drawTitle(screen)
a1(screen)
self:drawLogo(screen)
if not self.introDone then
return
end
for x,f in ipairs(b4)do
self:drawGlitch(screen,f.colour,f.x,f.y)
end
self:drawDoctor(screen,aa,aS,aT)
self:drawPatch(screen,1,3,0,aS-1,aT-b,0)
local f=m/2
for x=1,#P do
local y=c(P[x])
local V=b5+(x-1)*b6
if x==self.menuIndex then
local W=math.floor(screen:textWidth(y)/2)+aU
j.rowBar(screen,f-W,f+W,V)
screen:textCentre(y,f,V,d.r,d.g,d.b,1)
else
cs(screen,y,f,V)
end
end
end

function SpiffBoyDrTileGame:drawMenuRow(screen,label,value,y,chosen)
local f=g
if chosen then
j.rowBar(screen,j.ROW_LEFT,j.ROW_RIGHT,y)
f=d
end
cw(screen,label,al,y,f)
if value then
screen:textRight(value,aV,y,f.r,f.g,f.b,1)
end
end

function SpiffBoyDrTileGame:setupValue(key)
local f=self.setup
if key=="mode"then
return c(s[f.mode].text)
elseif key=="level"then
return tostring(f.level)
elseif key=="speed"then
return c(I[f.speed].text)
end
return c(N[f.music])
end

function SpiffBoyDrTileGame:drawRecordRows(screen,list,first,last,top)
local f=m/2
local as=screen:lineHeight()
for x=first,last do
local a5=list[x]
local y=top+(x-first)*as
local V,W,X=g.r,g.g,g.b
if self.mode==af and self:isRankInverted(x)then
l(screen,f+o.left,y,o.right-o.left,as)
V,W,X=d.r,d.g,d.b
end
screen:textRight(tostring(x)..".",f+o.rank,y,V,W,X,1)
screen:text(a5 .initials,f+o.initials,y,V,W,X,1)
screen:textRight(tostring(a5 .score),f+o.score,y,V,W,X,1)
end
end

function SpiffBoyDrTileGame:drawSetup(screen)
self.window:draw(screen,c("Play"))
for f=1,#O do
local x=O[f]
self:drawMenuRow(screen,c(x.text),self:setupValue(x.key),b8+(f-1)*b9,f==self.setupIndex)
end
l(screen,al,ca,aV-al,1)
local f=self.records[self:gameMode().key]
if#f==0 then
e(screen,c("NoScores"),m/2,aW+math.floor(screen:lineHeight()/2))
return
end
self:drawRecordRows(screen,f,1,math.min(#f,cb),aW)
end

local function cx(screen,x,y,value,chosen)
local f,V=g,d
if chosen then
f,V=d,g
end
local W=p*am+(p-1)*aX
screen:rect(x-1,y-1,W+2,an+2,f.r,f.g,f.b,1)
screen:rect(x,y,W,an,V.r,V.g,V.b,1)
for X=1,value do
screen:rect(x+(X-1)*(am+aX),y,am,an,f.r,f.g,f.b,1)
end
end

function SpiffBoyDrTileGame:drawOptions(screen)
self.window:draw(screen,c("Options"))
for f=1,#w do
local x=w[f]
local y=cc+(f-1)*cd
local V=f==self.optionIndex
self:drawMenuRow(screen,c(x.text),nil,y,V)
if x.key then
cx(screen,ce,y+cf,self.mix[x.key],V)
end
end
end

function SpiffBoyDrTileGame:drawConfirm(screen)
self.window:draw(screen,c("Options"))
local x=m/2
local as=screen:lineHeight()
local V=screen:wrapText(c("EraseScores"),ch)
for f=1,#V do
e(screen,V[f],x,cg+(f-1)*as)
end
local W={{text="No",x=x-aY,chosen=not self.confirmYes},{text="Yes",x=x+aY,chosen=self.confirmYes}}
for a5=1,#W do
local f=W[a5]
local y=c(f.text)
if f.chosen then
local X=math.floor(screen:textWidth(y)/2)+aU
j.rowBar(screen,f.x-X,f.x+X,ao)
screen:textCentre(y,f.x,ao,d.r,d.g,d.b,1)
else
e(screen,y,f.x,ao)
end
end
end

function SpiffBoyDrTileGame:drawScores(screen)
local V=self.scoresPage
local W=c(s[V].text)
self.window:draw(screen,W)
local y=m/2
local X=screen:lineHeight()
j.titleNote(screen,W,b7,"< >")
local f=self:pageRecords(V)
local x,as=self:scoresRows()
if#f==0 then
e(screen,c("NoScores"),y,x+X)
return
end
local a5=math.min(#f,self.scoresTop+as-1)
self:drawRecordRows(screen,f,self.scoresTop,a5,x)
if self.scoresTop>1 then
ar(screen,cj,y+o.arrow,x)
end
if a5<#f then
ar(screen,ck,y+o.arrow,x+(as-1)*X)
end
end

function SpiffBoyDrTileGame:drawInitials(screen)
self.window:draw(screen,c("NewHighScore"))
local f=m/2
local V=screen:lineHeight()
e(screen,tostring(self.score),f,Q.score)
e(screen,c("EnterInitials"),f,Q.prompt)
for x=1,S do
local y=f+(x-2)*co
e(screen,a0(self.letters[x]),y,Q.letters)
if x==self.cursor and self:blinkOn()then
l(screen,y-a_/2,Q.letters+V+1,a_,cp)
end
end
end

local function y(screen,label,centreX,centreY)
local X=screen:lineHeight()
local f=screen:textWidth(label)+R*2
local x=X+R*2
local V=math.floor(centreX-f/2)
local W=math.floor(centreY-x/2)
l(screen,V-1,W-1,f+2,x+2)
screen:rect(V,W,f,x,d.r,d.g,d.b,1)
ar(screen,label,V+R,W+R)
end

local function cy(screen)
local as=i-1
local a5=n-1
local f=as-r
local x=a5-r
local V=k+2+r*2
local W=E+2+r+at
l(screen,f,x,V,W)
screen:rect(f+1,x+1,V-2,W-2,u.r,u.g,u.b,1)
l(screen,as,a5,k+2,E+2)
screen:rect(i,n,k,E,d.r,d.g,d.b,1)
local X=x+W
l(screen,f+V-r-Y-1,X-at+1,Y,Y)
local a6=i+k/2
l(screen,a6-au/2,X,au,av)
l(screen,a6-aw/2,X+av,aw,a8)
end

function SpiffBoyDrTileGame:drawGrid(screen)
local V=self.board
local a5=self.phase==L or self.phase==M
local a6=B
if a5 then
a6=self.curtainRow
end
local as=bg
if self:glitchShifted()then
as=bh
end
for f=0,a6-1 do
local W=a4()
local x=1
for X=0,D-1 do
local a7=V:kindAt(X,f)
if self.phase==aj and self.clearSet[V:key(X,f)]then
U(W,bj,x)
elseif a7==h.GLITCH then
U(W,as[V:colourAt(X,f)],x)
elseif a7==h.HALF then
U(W,bi[V:colourAt(X,f)],x)
end
x=x*2
end
self:drawRowLayers(screen,W,n+f*b)
end
if self.phase==ai then
local f=self.piece
self:drawPatch(screen,f.first,f.second,f.orientation,i+f.x*b,n+f.y*b,n)
end
if a5 then
for f=self.curtainRow,B-1 do
local x=n+f*b
screen:rect(i,x,k,b,u.r,u.g,u.b,1)
local W=a4()
for X=f%2,D-1,2 do
U(W,as[be],2^X)
end
self:drawRowLayers(screen,W,x)
end
end
end

function SpiffBoyDrTileGame:drawFlying(screen)
local f=1-self.phaseTimer/aF
local x=i+F*b
local V=n+G*b
local W=ab+(x-ab)*f
local X=ac+(V-ac)*f-by*4*f*(1-f)
self:drawPatch(screen,self.flying[1],self.flying[2],0,math.floor(W),math.floor(X),0)
end

function SpiffBoyDrTileGame:doctorFrame()
if self.phase==J then
return bm
elseif self.phase==K then
return bn
elseif self.phase==L or self.phase==M then
return bo
elseif self.adjustTimer>0 then
return az
elseif self.board:highestRow()<bt then
if math.floor(self.clock/bs)%2==0 then
return aA
end
return aB
end
return aa
end

function SpiffBoyDrTileGame:drawCounters(screen)
local f=bA
e(screen,c("Score"),f,bB)
e(screen,tostring(self.score),f,bC)
e(screen,c("StartLevel"),f,bD)
e(screen,tostring(self.level),f,bE)
e(screen,c("Glitches"),f,bF)
local x=self.glitchesLeft
if self.modeKey=="b"then
x=self.repaired
end
e(screen,tostring(x),f,bG)
end

function SpiffBoyDrTileGame:drawGiants(screen)
local W=math.floor(self.clock/bv)
local X=aH-math.floor(H/2)-aC
for f=1,h.COLOURS do
if self.kindLeft[f]>0 or self.flinch[f]>0 then
local V=(W+f)%2
local x=X+(f-1)*aC
if self.flinch[f]>0 then
x=x+(math.floor(self.flinch[f]/bx)%2)*2-1
end
local as=(f-1)*2+V
screen:layers(self.giants,as*H,H,H,x,bu+V,ax[f])
end
end
end

function SpiffBoyDrTileGame:drawDoctorPanel(screen)
local f=aH
e(screen,c("Speed"),f,bH)
e(screen,c(self.speed.text),f,bI)
self:drawGiants(screen)
e(screen,c("Next"),f,bJ)
local x=self:doctorFrame()
self:drawDoctor(screen,x,aD,aE)
if bp[x]and not self.paused then
self:drawPatch(screen,self.next[1],self.next[2],0,ab,ac,0)
end
end

function SpiffBoyDrTileGame:drawRun(screen)
a1(screen)
cy(screen)
if not self.paused then
self:drawGrid(screen)
end
self:drawCounters(screen)
self:drawDoctorPanel(screen)
if self.phase==J then
self:drawFlying(screen)
end
local f=i+k/2
local x=n+E/2
if self.paused then
y(screen,getText("UI_SpiffBoy_Paused"),f,x)
elseif self.phase==ah then
y(screen,c("Level",self.level),f,x)
elseif self.phase==K then
y(screen,c("Repaired"),f,x)
elseif self.phase==M then
y(screen,c("GameOver"),f,x)
end
end
