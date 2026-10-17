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
local C=8
local A=16
local i=68
local n=14
local k=C*b
local D=A*b
local E=3
local F=0
local r=3
local au=5
local Z=2
local av=12
local aw=2
local ax=28
local a9=2

local ba=1
local bb=4
local bc=7
local bd=11
local ay={{1,3},{1,2,3},{1}}
local be={{1,2,3},{1,2,3},{1,2}}
local bf=3
local _=16
local bg=256/_*b
local aa={1,3,1,2,3,1,3,1,2,3,1,3,2,1,2,1,1,2}
local bh={{1,2},{3,4,5},{6}}
local bi={{1,7},{8,9,10},{11}}
local bj={{1,12,13},{14,15,5},{16,13}}
local bk={17,18}

local az=24
local bl=34
local bm={1,2,3}
local ab=1
local bn=2
local bo=3
local bp=4
local aA=5
local aB=6
local aC=7
local bq={[ab]=true,[aA]=true,[aB]=true,[aC]=true}
local br=45
local bs=2
local bt=15
local bu=3
local G=12
local bv=38
local aD=18
local bw=15
local bx=30
local by=2
local aE=137
local aF=84
local ac=aE-1
local ad=aF-b
local aG=18
local bz=24

local bA=i-1-r
local aH=i+k+1+r
local bB=math.floor(bA/2)
local aI=aH+math.floor((m-aH)/2)
local bC=4
local bD=18
local bE=40
local bF=54
local bG=76
local bH=90
local bI=4
local bJ=18
local bK=58

local aJ={39,37,35,33,31,29,27,25,23,21,19,18,17,16,15,14,13,12,11,10,9,9,8,8,7,7,6,6,5,5,5,5,4,4,4,4,3}
local H={{text="Slow",step=1,score=100},{text="Medium",step=11,score=200},{text="Fast",step=21,score=300}}
local bL=10
local bM=2
local bN=12
local bO=5
local aK={1,2,4,8,16,32}
local bP=18
local aL=7
local bQ=90
local bR=150
local aM=3
local bS=90
local bT=12
local bU=20
local bV=12
local bW=4
local bX=3
local bY=2
local bZ=6
local b_=5

local v="title"
local ae="setup"
local B="options"
local af="confirm"
local ag="scores"
local ah="run"
local aN="initials"

local ai="ready"
local I="throw"
local aj="fall"
local ak="clear"
local aO="settle"
local J="repaired"
local K="curtain"
local L="over"

local s={{key="a",text="ModeA"},{key="b",text="ModeB"}}
local M={"MusicA","MusicB","MusicOff"}
local b0=#M
local N={{key="mode",text="Mode"},{key="level",text="StartLevel"},{key="speed",text="Speed"},{key="music",text="Music"}}
local w={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local O={"Play","HighScores","Options"}

local b1=133
local aP=23
local b2=math.floor((m-b1)/2)
local aQ=6
local b3={1,2,3}
local aR=2
local x={{x=0,w=15},{x=20,w=15},{x=38,w=15},{x=56,w=3},{x=62,w=15},{x=80,w=15},{x=98,w=15},{x=116,w=15}}
local al=20
local aS=10
local b4=20
local b5={{x=10,y=108,colour=1},{x=20,y=108,colour=2},{x=30,y=108,colour=3}}
local aT=148
local aU=84
local b6=40
local b7=16
local aV=4

local b8=8
local b9=22
local ca=13
local am=12
local aW=168
local cb=78
local aX=81
local cc=2
local cd=30
local ce=24
local cf=92
local an=5
local aY=1
local ao=8
local cg=4
local ch=34
local ci=150
local ap=80
local aZ=32
local a_=23
local cj=114
local P={score=26,prompt=52,letters=78}
local o={rank=-26,initials=-22,score=42,arrow=50,left=-44,right=46}
local aq={ticks=15,count=4}
local Q=4
local ck=string.char(0x25B4)
local cl=string.char(0x25BE)
local cm="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local cn=62
local R=t.INITIALS_LENGTH
local co=30
local cp=20
local a0=12
local cq=2
local S={delay=24,start=8,min=2,speedup=30}
local p=a.MIX_STEPS

local function q(f,e)
return(f-1+e)%e+1
end

local function cr(f,e)
return(f+e)%e
end

local function y(e)
if e.up then
return-1
elseif e.down then
return 1
end
return 0
end

local function ar(e)
if e.left then
return-1
elseif e.right then
return 1
end
return 0
end

local function a1(e)
return string.sub(cm,e,e)
end

local function a2(e)
e:clear(d.r,d.g,d.b)
end

local function as(e,f,l,z)
e:text(f,l,z,g.r,g.g,g.b,1)
end

local function e(f,l,z,T)
f:textCentre(l,z,T,g.r,g.g,g.b,1)
end

local function l(f,z,T,U,V)
f:rect(z,T,U,V,g.r,g.g,g.b,1)
end

local cs={{-1,0},{1,0},{0,-1},{0,1}}

local function ct(f,z,T,U)
for W,V in ipairs(cs)do
f:textCentre(z,T+V[1],U+V[2],d.r,d.g,d.b,1)
end
e(f,z,T,U)
end

local function a3(f)
return aJ[math.min(f,#aJ)]
end

local function cu(T)
local z={mode=1,level=0,speed=1,music=1}
local f=T.setup
if type(f)~="table"then
return z
end
if SpiffBoy.isInteger(f.mode)and f.mode>=1 and f.mode<=#s then
z.mode=f.mode
end
if SpiffBoy.isInteger(f.level)and f.level>=0 and f.level<=h.MAX_LEVEL then
z.level=f.level
end
if SpiffBoy.isInteger(f.speed)and f.speed>=1 and f.speed<=#H then
z.speed=f.speed
end
if SpiffBoy.isInteger(f.music)and f.music>=1 and f.music<=#M then
z.music=f.music
end
return z
end

local function cv(V)
local z={music=p,effects=p}
local U=V.options
if type(U)~="table"then
return z
end
for W,T in ipairs(w)do
local f=T.key and U[T.key]
if SpiffBoy.isInteger(f)and f>=0 and f<=p then
z[T.key]=f
end
end
return z
end

function SpiffBoyDrTileGame:init()
self.cells=self.context.art("cells")
self.rows=self.context.art("rows")
self.logo=self.context.art("logo")
self.doctor=self.context.art("doctor")
self.giants=self.context.art("giants")
self.window=j.new(self.cells,(bd-1)*b,b)
self.records=t.read(self.save)
self.mix=cv(self.save)
self.mixDirty=false
self.setup=cu(self.save)
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

function SpiffBoyDrTileGame:setMode(f)
self.mode=f
self.transition=j.TUBE_TICKS
end

function SpiffBoyDrTileGame:applyMix()
self.sequencer:setMix(self.mix.music/p,self.mix.effects/p)
end

function SpiffBoyDrTileGame:keepMusic(f)
if not self.sequencer:isPlaying()then
self.sequencer:play(f)
end
end

function SpiffBoyDrTileGame:keepTrack()
if self.setup.music~=b0 then
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

function SpiffBoyDrTileGame:tick(z,T)
self.clock=self.clock+1
if self.transition>0 then
self.transition=self.transition-1
end
local f=z[1]
if self.mode==ah then
self:tickRun(f)
elseif self.mode==aN then
self:keepMusic(a.TITLE)
self:tickInitials(f)
elseif self.mode==ae then
self:keepTrack()
self:tickSetup(f)
else
if self.introDone then
self:keepMusic(a.TITLE)
end
if self.mode==v then
self:tickTitle(f)
elseif self.mode==B then
self:tickOptions(f)
elseif self.mode==af then
self:tickConfirm(f)
else
self:tickScores(f)
end
end
end

local function cw(f)
if f<al then
return 0
end
return math.min(#x,math.floor((f-al)/aS)+1)
end

function SpiffBoyDrTileGame:tickIntro(f)
if f and(f.pressed.a or f.pressed.b or f.pressed.start)then
self:endIntro()
return
end
self.introTick=self.introTick+1
local z=cw(self.introTick)
if z>self.partsHealed then
self.partsHealed=z
self.sequencer:effect(a.HEAL)
end
if z==#x and self.introTick>=al+(#x-1)*aS+b4 then
self:endIntro()
end
end

function SpiffBoyDrTileGame:endIntro()
self.introDone=true
self.partsHealed=#x
self.sequencer:play(a.TITLE)
end

function SpiffBoyDrTileGame:tickTitle(f)
if not self.introDone then
self:tickIntro(f)
return
end
if not f then
return
end
local z=f.pressed
local T=y(z)
if T~=0 then
self.menuIndex=q(self.menuIndex+T,#O)
self.sequencer:effect(a.TICK)
end
if z.a or z.start then
local U=O[self.menuIndex]
self.sequencer:effect(a.CONFIRM)
if U=="Play"then
self:openSetup()
elseif U=="Options"then
self:openOptions()
else
self:showScores(self.setup.mode,1)
end
end
end

function SpiffBoyDrTileGame:openSetup()
self.setupIndex=1
self:setMode(ae)
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

function SpiffBoyDrTileGame:turnSetup(z)
local f=self.setup
local T=N[self.setupIndex].key
if T=="mode"then
f.mode=q(f.mode+z,#s)
elseif T=="level"then
f.level=cr(f.level+z,h.MAX_LEVEL+1)
elseif T=="speed"then
f.speed=q(f.speed+z,#H)
else
f.music=q(f.music+z,#M)
self.sequencer:stop()
end
self.setupDirty=true
self.sequencer:effect(a.TICK)
end

function SpiffBoyDrTileGame:tickSetup(z)
if not z then
return
end
local f=z.pressed
local T=y(f)
if T~=0 then
self.setupIndex=q(self.setupIndex+T,#N)
self.sequencer:effect(a.TICK)
end
local U=ar(f)
if U~=0 then
self:turnSetup(U)
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
self:setMode(B)
end

function SpiffBoyDrTileGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self:setMode(v)
end

function SpiffBoyDrTileGame:turnOption(T)
local f=w[self.optionIndex]
if not f.key then
return
end
local z=SpiffBoy.clamp(self.mix[f.key]+T,0,p)
if z==self.mix[f.key]then
return
end
self.mix[f.key]=z
self.mixDirty=true
self:applyMix()
self.sequencer:effect(a.STEP..z)
end

function SpiffBoyDrTileGame:tickOptions(z)
if not z then
return
end
local f=z.pressed
local T=y(f)
if T~=0 then
self.optionIndex=q(self.optionIndex+T,#w)
self.sequencer:effect(a.TICK)
end
local U=ar(f)
if U~=0 then
self:turnOption(U)
end
if f.b or f.start then
self.sequencer:effect(a.CONFIRM)
self:closeOptions()
elseif f.a then
self.sequencer:effect(a.CONFIRM)
if w[self.optionIndex].action then
self.confirmYes=false
self:setMode(af)
else
self:closeOptions()
end
end
end

function SpiffBoyDrTileGame:tickConfirm(z)
if not z then
return
end
local f=z.pressed
if f.left or f.right or f.up or f.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(a.TICK)
end
if f.b then
self.sequencer:effect(a.CONFIRM)
self:setMode(B)
elseif f.a or f.start then
self.sequencer:effect(a.CONFIRM)
if self.confirmYes then
self.records=t.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self:setMode(B)
end
end

function SpiffBoyDrTileGame:pageRecords(f)
return self.records[s[f].key]
end

function SpiffBoyDrTileGame:scoresRows()
local f=self.screen:lineHeight()
return a_,math.floor((cj-a_)/f)
end

function SpiffBoyDrTileGame:clampScoresTop(f,z)
local U,T=self:scoresRows()
return SpiffBoy.clamp(z,1,#self:pageRecords(f)-T+1)
end

function SpiffBoyDrTileGame:showScores(f,z)
self:setMode(ag)
self.scoresPage=f
self.scoresTop=self:clampScoresTop(f,z)
end

function SpiffBoyDrTileGame:flashRank(f)
self.flashRankIndex=f
self.flashUntil=self.clock+aq.ticks*aq.count*2
end

function SpiffBoyDrTileGame:isRankInverted(f)
if f~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/aq.ticks)%2==1
end

function SpiffBoyDrTileGame:tickScores(z)
if not z then
return
end
local f=z.pressed
local T=y(f)
local U=ar(f)
if T~=0 then
local V=self:clampScoresTop(self.scoresPage,self.scoresTop+T)
if V~=self.scoresTop then
self.scoresTop=V
self.sequencer:effect(a.TICK)
end
elseif U~=0 then
self.flashRankIndex=nil
self:showScores(q(self.scoresPage+U,#s),1)
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
self.speed=H[self.setup.speed]
self.speedStep=self.speed.step
self.patches=0
self.score=0
self.repaired=0
self.sinceRise=0
self.paused=false
self.next={self:drawColour(),self:drawColour()}
self.piece={x=E,y=F,orientation=0,first=1,second=1}
self:setMode(ah)
self.sequencer:stop()
self.sequencer:play(a.START)
self:startLevelBoard()
end

function SpiffBoyDrTileGame:drawColour()
return self.random:int(1,h.COLOURS)
end

function SpiffBoyDrTileGame:startLevelBoard()
self.board=h.new(C,A)
self.board:fillGlitches(self.level,self.random)
self.kindLeft=nil
self.flinch={0,0,0}
self.adjustTimer=0
self:countGlitches()
self.phase=ai
self.phaseTimer=bQ
end

function SpiffBoyDrTileGame:countGlitches()
local z=self.board:glitchCounts()
local T=0
for f=1,h.COLOURS do
if self.kindLeft and z[f]<self.kindLeft[f]then
self.flinch[f]=bx
end
T=T+z[f]
end
self.kindLeft=z
self.glitchesLeft=T
end

function SpiffBoyDrTileGame:endlessLevel()
return self.startLevel+math.floor(self.repaired/bU)
end

function SpiffBoyDrTileGame:riseInterval()
return math.max(bW,bV-math.floor(self.level/bX))
end

function SpiffBoyDrTileGame:riseCount()
return math.min(bZ,bY+math.floor(self.level/b_))
end

function SpiffBoyDrTileGame:throwPatch()
self.flying=self.next
self.next={self:drawColour(),self:drawColour()}
self.phase=I
self.phaseTimer=aG
self.sequencer:effect(a.THROW)
end

function SpiffBoyDrTileGame:spawn()
local f=self.piece
f.x=E
f.y=F
f.orientation=0
f.first=self.flying[1]
f.second=self.flying[2]
self.flying=nil
self.patches=self.patches+1
self.speedStep=self.speed.step+math.floor(self.patches/bL)
self.dropTimer=a3(self.speedStep)
self.softBlocked=true
self.repeatTimer=0
self.chainGlitches=0
self.chainStep=0
if not self.board:fits(E,F,0)then
self:topOut()
return
end
self.phase=aj
end

function SpiffBoyDrTileGame:shift(z)
local f=self.piece
if self.board:fits(f.x+z,f.y,f.orientation)then
f.x=f.x+z
self.sequencer:effect(a.MOVE)
end
end

function SpiffBoyDrTileGame:rotate(T)
local f=self.piece
local z=(f.orientation+T+4)%4
if self.board:fits(f.x,f.y,z)then
f.orientation=z
self.sequencer:effect(a.ROTATE)
elseif h.isFlat(z)and self.board:fits(f.x-1,f.y,z)then
f.x=f.x-1
f.orientation=z
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
local f,z=self.board:matches()
if z==0 then
self:endTurn()
return
end
self.clearSet=f
self.chainStep=self.chainStep+1
if self.chainStep==bs then
self.adjustTimer=br
end
self.phase=ak
self.phaseTimer=bP
self.sequencer:effect(a.POP..math.min(self.chainStep,a.POP_LEVELS))
end

function SpiffBoyDrTileGame:finishClear()
local f=self.board:remove(self.clearSet)
self.clearSet=nil
for z=1,f do
self.chainGlitches=self.chainGlitches+1
self.score=self.score+self.speed.score*aK[math.min(self.chainGlitches,#aK)]
end
self:countGlitches()
if self.modeKey=="b"then
self.repaired=self.repaired+f
self.level=self:endlessLevel()
end
self.phase=aO
self.phaseTimer=aL
end

function SpiffBoyDrTileGame:tickSettle()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer>0 then
return
end
self.phaseTimer=aL
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
self.phase=J
self.phaseTimer=bR
self.sequencer:stop()
self.sequencer:play(a.REPAIRED)
end

function SpiffBoyDrTileGame:topOut()
self.phase=K
self.curtainRow=A
self.phaseTimer=aM
self.sequencer:stop()
self.sequencer:effect(a.LOSE)
end

function SpiffBoyDrTileGame:tickRun(f)
if not self.paused then
self:tickReactions()
end
if self.phase==ai then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:throwPatch()
end
elseif self.phase==I then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:spawn()
end
elseif self.phase==aj then
self:tickFall(f)
elseif self.phase==ak then
self:keepTrack()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
self:finishClear()
end
elseif self.phase==aO then
self:keepTrack()
self:tickSettle()
elseif self.phase==J then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.level=self.level+1
self:startLevelBoard()
end
elseif self.phase==K then
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

function SpiffBoyDrTileGame:tickFall(f)
self:keepTrack()
if f and f.pressed.start then
self.paused=not self.paused
self.sequencer:effect(a.CONFIRM)
end
if self.paused then
return
end
if f then
self:control(f)
end
local z=f and f.held.down and not self.softBlocked
if z then
self.dropTimer=math.min(self.dropTimer,bM)
end
self.dropTimer=self.dropTimer-1
if self.dropTimer<=0 then
self.dropTimer=a3(self.speedStep)
self:fall()
end
end

function SpiffBoyDrTileGame:control(U)
local T,z=U.held,U.pressed
if not T.down then
self.softBlocked=false
end
local f=0
if T.left then
f=-1
elseif T.right then
f=1
end
if z.left or z.right then
self:shift(f)
self.repeatTimer=bN
elseif f~=0 then
self.repeatTimer=self.repeatTimer-1
if self.repeatTimer<=0 then
self:shift(f)
self.repeatTimer=bO
end
end
if z.a then
self:rotate(1)
end
if z.b then
self:rotate(-1)
end
end

function SpiffBoyDrTileGame:tickCurtain()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer>0 then
return
end
self.phaseTimer=aM
self.curtainRow=self.curtainRow-1
if self.curtainRow<=0 then
self.curtainRow=0
self.phase=L
self.phaseTimer=bS
self.sequencer:play(a.OVER)
end
end

function SpiffBoyDrTileGame:offerRecord()
if t.rankOf(self.records[self.modeKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.sequencer:stop()
self:setMode(aN)
return
end
self:openSetup()
end

function SpiffBoyDrTileGame:turnLetter(z)
local f=self.cursor
self.letters[f]=q(self.letters[f]-z,cn)
self.sequencer:effect(a.TICK)
end

function SpiffBoyDrTileGame:repeatLetter(f,z)
if f~=0 then
self:turnLetter(f)
self.letterHoldStep=f
self.letterHoldTicks=0
self.letterRepeatTimer=S.delay
return
end
if z==0 or z~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(z)
self.letterRepeatTimer=math.max(S.min,S.start-math.floor(self.letterHoldTicks/S.speedup))
end
end

function SpiffBoyDrTileGame:tickInitials(T)
if not T then
return
end
local f=T.pressed
local z=self.cursor
self:repeatLetter(y(f),y(T.held))
if f.left and z>1 then
self.cursor=z-1
elseif f.right and z<R then
self.cursor=z+1
end
if f.a or f.start then
self.sequencer:effect(a.CONFIRM)
if self.cursor<R then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoyDrTileGame:saveScore()
local f=""
for z=1,R do
f=f..a1(self.letters[z])
end
local z=t.insert(self.records[self.modeKey],f,self.score)
self:persistRecords()
self:showScores(self.setup.mode,z)
self:flashRank(z)
end

function SpiffBoyDrTileGame:blinkOn()
return math.floor(self.clock/co)%2==0
end

function SpiffBoyDrTileGame:draw(f)
self:drawScreen(f)
if self.transition>0 then
j.drawTube(f,self.transition)
end
end

function SpiffBoyDrTileGame:drawScreen(f)
if self.mode==v then
self:drawTitle(f)
elseif self.mode==ae then
self:drawSetup(f)
elseif self.mode==B then
self:drawOptions(f)
elseif self.mode==af then
self:drawConfirm(f)
elseif self.mode==ag then
self:drawScores(f)
elseif self.mode==ah then
self:drawRun(f)
else
self:drawInitials(f)
end
end

function SpiffBoyDrTileGame:drawCell(f,z,T,U,V)
f:layers(self.cells,(z-1)*b,b,b,U,V,T)
end

function SpiffBoyDrTileGame:glitchShifted()
return math.floor(self.clock/bT)%2==1
end

function SpiffBoyDrTileGame:drawGlitch(T,f,U,V)
local z=ba
if self:glitchShifted()then
z=bb
end
self:drawCell(T,z+f-1,ay[f],U,V)
end

local function T(z,f,V)
for U=1,#f do
z[f[U]]=(z[f[U]]or 0)+V
end
end

local a4={}

local function a5()
for f=1,#aa do
a4[f]=nil
end
return a4
end

function SpiffBoyDrTileGame:drawRowLayers(U,V,W)
for f=1,#aa do
local z=V[f]
if z then
U:sheet(self.rows,z%_*k,(f-1)*bg+math.floor(z/_)*b,k,b,i,W,1,aa[f])
end
end
end

function SpiffBoyDrTileGame:drawTile(z,f,U,V)
self:drawCell(z,bc+f-1,be[f],U,V)
end

function SpiffBoyDrTileGame:drawPatch(z,Y,at,a6,U,f,V)
local a7,W,a8,X=h.patchCells(0,0,a6)
if f+W*b>=V then
self:drawTile(z,Y,U+a7*b,f+W*b)
end
if f+X*b>=V then
self:drawTile(z,at,U+a8*b,f+X*b)
end
end

function SpiffBoyDrTileGame:drawDoctor(f,z,U,V)
f:layers(self.doctor,(z-1)*az,az,bl,U,V,bm)
end

local function cx(z,U,V,W,f)
z:text(U,V,W,f.r,f.g,f.b,1)
end

function SpiffBoyDrTileGame:drawLogo(U)
for z=1,#x do
local f=x[z]
local V=b2+f.x
if z<=self.partsHealed then
U:layers(self.logo,f.x,f.w+aR,aP,V,aQ,b3)
else
local Y=math.max(1,math.ceil(f.w/b))
local at=math.ceil((aP-aR)/b)
for W=0,at-1 do
for X=0,Y-1 do
self:drawGlitch(U,(z+W+X)%h.COLOURS+1,V+X*b,aQ+W*b)
end
end
end
end
end

function SpiffBoyDrTileGame:drawTitle(f)
a2(f)
self:drawLogo(f)
if not self.introDone then
return
end
for U,z in ipairs(b5)do
self:drawGlitch(f,z.colour,z.x,z.y)
end
self:drawDoctor(f,ab,aT,aU)
self:drawPatch(f,1,3,0,aT-1,aU-b,0)
local z=m/2
for U=1,#O do
local V=c(O[U])
local W=b6+(U-1)*b7
if U==self.menuIndex then
local X=math.floor(f:textWidth(V)/2)+aV
j.rowBar(f,z-X,z+X,W)
f:textCentre(V,z,W,d.r,d.g,d.b,1)
else
ct(f,V,z,W)
end
end
end

function SpiffBoyDrTileGame:drawMenuRow(z,W,V,U,X)
local f=g
if X then
j.rowBar(z,j.ROW_LEFT,j.ROW_RIGHT,U)
f=d
end
cx(z,W,am,U,f)
if V then
z:textRight(V,aW,U,f.r,f.g,f.b,1)
end
end

function SpiffBoyDrTileGame:setupValue(z)
local f=self.setup
if z=="mode"then
return c(s[f.mode].text)
elseif z=="level"then
return tostring(f.level)
elseif z=="speed"then
return c(H[f.speed].text)
end
return c(M[f.music])
end

function SpiffBoyDrTileGame:drawRecordRows(f,a8,at,cy,cz)
local z=m/2
local a6=f:lineHeight()
for U=at,cy do
local a7=a8[U]
local V=cz+(U-at)*a6
local W,X,Y=g.r,g.g,g.b
if self.mode==ag and self:isRankInverted(U)then
l(f,z+o.left,V,o.right-o.left,a6)
W,X,Y=d.r,d.g,d.b
end
f:textRight(tostring(U)..".",z+o.rank,V,W,X,Y,1)
f:text(a7 .initials,z+o.initials,V,W,X,Y,1)
f:textRight(tostring(a7 .score),z+o.score,V,W,X,Y,1)
end
end

function SpiffBoyDrTileGame:drawSetup(f)
self.window:draw(f,c("Play"))
for z=1,#N do
local U=N[z]
self:drawMenuRow(f,c(U.text),self:setupValue(U.key),b9+(z-1)*ca,z==self.setupIndex)
end
l(f,am,cb,aW-am,1)
local z=self.records[self:gameMode().key]
if#z==0 then
e(f,c("NoScores"),m/2,aX+math.floor(f:lineHeight()/2))
return
end
self:drawRecordRows(f,z,1,math.min(#z,cc),aX)
end

local function cy(U,V,W,Y,at)
local f,z=g,d
if at then
f,z=d,g
end
local X=p*an+(p-1)*aY
U:rect(V-1,W-1,X+2,ao+2,f.r,f.g,f.b,1)
U:rect(V,W,X,ao,z.r,z.g,z.b,1)
for a6=1,Y do
U:rect(V+(a6-1)*(an+aY),W,an,ao,f.r,f.g,f.b,1)
end
end

function SpiffBoyDrTileGame:drawOptions(f)
self.window:draw(f,c("Options"))
for z=1,#w do
local U=w[z]
local V=cd+(z-1)*ce
local W=z==self.optionIndex
self:drawMenuRow(f,c(U.text),nil,V,W)
if U.key then
cy(f,cf,V+cg,self.mix[U.key],W)
end
end
end

function SpiffBoyDrTileGame:drawConfirm(f)
self.window:draw(f,c("Options"))
local U=m/2
local at=f:lineHeight()
local W=f:wrapText(c("EraseScores"),ci)
for z=1,#W do
e(f,W[z],U,ch+(z-1)*at)
end
local X={{text="No",x=U-aZ,chosen=not self.confirmYes},{text="Yes",x=U+aZ,chosen=self.confirmYes}}
for a6=1,#X do
local z=X[a6]
local V=c(z.text)
if z.chosen then
local Y=math.floor(f:textWidth(V)/2)+aV
j.rowBar(f,z.x-Y,z.x+Y,ap)
f:textCentre(V,z.x,ap,d.r,d.g,d.b,1)
else
e(f,V,z.x,ap)
end
end
end

function SpiffBoyDrTileGame:drawScores(f)
local W=self.scoresPage
local X=c(s[W].text)
self.window:draw(f,X)
local V=m/2
local Y=f:lineHeight()
j.titleNote(f,X,b8,"< >")
local z=self:pageRecords(W)
local U,at=self:scoresRows()
if#z==0 then
e(f,c("NoScores"),V,U+Y)
return
end
local a6=math.min(#z,self.scoresTop+at-1)
self:drawRecordRows(f,z,self.scoresTop,a6,U)
if self.scoresTop>1 then
as(f,ck,V+o.arrow,U)
end
if a6<#z then
as(f,cl,V+o.arrow,U+(at-1)*Y)
end
end

function SpiffBoyDrTileGame:drawInitials(f)
self.window:draw(f,c("NewHighScore"))
local z=m/2
local W=f:lineHeight()
e(f,tostring(self.score),z,P.score)
e(f,c("EnterInitials"),z,P.prompt)
for U=1,R do
local V=z+(U-2)*cp
e(f,a1(self.letters[U]),V,P.letters)
if U==self.cursor and self:blinkOn()then
l(f,V-a0/2,P.letters+W+1,a0,cq)
end
end
end

local function U(f,Y,at,a6)
local a7=f:lineHeight()
local z=f:textWidth(Y)+Q*2
local V=a7+Q*2
local W=math.floor(at-z/2)
local X=math.floor(a6-V/2)
l(f,W-1,X-1,z+2,V+2)
f:rect(W,X,z,V,d.r,d.g,d.b,1)
as(f,Y,W+Q,X+Q)
end

local function cz(f)
local at=i-1
local a6=n-1
local z=at-r
local V=a6-r
local W=k+2+r*2
local X=D+2+r+au
l(f,z,V,W,X)
f:rect(z+1,V+1,W-2,X-2,u.r,u.g,u.b,1)
l(f,at,a6,k+2,D+2)
f:rect(i,n,k,D,d.r,d.g,d.b,1)
local Y=V+X
l(f,z+W-r-Z-1,Y-au+1,Z,Z)
local a7=i+k/2
l(f,a7-av/2,Y,av,aw)
l(f,a7-ax/2,Y+aw,ax,a9)
end

function SpiffBoyDrTileGame:drawGrid(V)
local W=self.board
local a6=self.phase==K or self.phase==L
local a7=A
if a6 then
a7=self.curtainRow
end
local at=bh
if self:glitchShifted()then
at=bi
end
for f=0,a7-1 do
local X=a5()
local z=1
for Y=0,C-1 do
local a8=W:kindAt(Y,f)
if self.phase==ak and self.clearSet[W:key(Y,f)]then
T(X,bk,z)
elseif a8==h.GLITCH then
T(X,at[W:colourAt(Y,f)],z)
elseif a8==h.HALF then
T(X,bj[W:colourAt(Y,f)],z)
end
z=z*2
end
self:drawRowLayers(V,X,n+f*b)
end
if self.phase==aj then
local f=self.piece
self:drawPatch(V,f.first,f.second,f.orientation,i+f.x*b,n+f.y*b,n)
end
if a6 then
for f=self.curtainRow,A-1 do
local z=n+f*b
V:rect(i,z,k,b,u.r,u.g,u.b,1)
local X=a5()
for Y=f%2,C-1,2 do
T(X,at[bf],2^Y)
end
self:drawRowLayers(V,X,z)
end
end
end

function SpiffBoyDrTileGame:drawFlying(z)
local f=1-self.phaseTimer/aG
local V=i+E*b
local W=n+F*b
local X=ac+(V-ac)*f
local Y=ad+(W-ad)*f-bz*4*f*(1-f)
self:drawPatch(z,self.flying[1],self.flying[2],0,math.floor(X),math.floor(Y),0)
end

function SpiffBoyDrTileGame:doctorFrame()
if self.phase==I then
return bn
elseif self.phase==J then
return bo
elseif self.phase==K or self.phase==L then
return bp
elseif self.adjustTimer>0 then
return aA
elseif self.board:highestRow()<bu then
if math.floor(self.clock/bt)%2==0 then
return aB
end
return aC
end
return ab
end

function SpiffBoyDrTileGame:drawCounters(f)
local z=bB
e(f,c("Score"),z,bC)
e(f,tostring(self.score),z,bD)
e(f,c("StartLevel"),z,bE)
e(f,tostring(self.level),z,bF)
e(f,c("Glitches"),z,bG)
local V=self.glitchesLeft
if self.modeKey=="b"then
V=self.repaired
end
e(f,tostring(V),z,bH)
end

function SpiffBoyDrTileGame:drawGiants(W)
local X=math.floor(self.clock/bw)
local Y=aI-math.floor(G/2)-aD
for f=1,h.COLOURS do
if self.kindLeft[f]>0 or self.flinch[f]>0 then
local V=(X+f)%2
local z=Y+(f-1)*aD
if self.flinch[f]>0 then
z=z+(math.floor(self.flinch[f]/by)%2)*2-1
end
local at=(f-1)*2+V
W:layers(self.giants,at*G,G,G,z,bv+V,ay[f])
end
end
end

function SpiffBoyDrTileGame:drawDoctorPanel(f)
local z=aI
e(f,c("Speed"),z,bI)
e(f,c(self.speed.text),z,bJ)
self:drawGiants(f)
e(f,c("Next"),z,bK)
local V=self:doctorFrame()
self:drawDoctor(f,V,aE,aF)
if bq[V]and not self.paused then
self:drawPatch(f,self.next[1],self.next[2],0,ac,ad,0)
end
end

function SpiffBoyDrTileGame:drawRun(f)
a2(f)
cz(f)
if not self.paused then
self:drawGrid(f)
end
self:drawCounters(f)
self:drawDoctorPanel(f)
if self.phase==I then
self:drawFlying(f)
end
local z=i+k/2
local V=n+D/2
if self.paused then
U(f,getText("UI_SpiffBoy_Paused"),z,V)
elseif self.phase==ai then
U(f,c("Level",self.level),z,V)
elseif self.phase==J then
U(f,c("Repaired"),z,V)
elseif self.phase==L then
U(f,c("GameOver"),z,V)
end
end
