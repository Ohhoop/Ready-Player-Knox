require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/BrickDrop/Well"
require"SpiffBoy/Games/BrickDrop/Records"
require"SpiffBoy/Games/BrickDrop/Music"
require"SpiffBoy/Games/BrickDrop/TitleWall"
require"SpiffBoy/Games/BrickDrop/Camp"
require"SpiffBoy/Games/BrickDrop/EscapeScene"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyBrickDropGame=SpiffBoyGameBase:derive("SpiffBoyBrickDropGame")

local m=SpiffBoy.BrickDrop.Well
local i=SpiffBoy.BrickDrop.Records
local b=SpiffBoy.BrickDrop.Music
local bd=SpiffBoy.BrickDrop.TitleWall
local ax=SpiffBoy.BrickDrop.Camp
local E=SpiffBoy.BrickDrop.EscapeScene

local e=SpiffBoy.Cartridges.SHADES[4]
local g=SpiffBoy.Cartridges.SHADES[1]
local F=SpiffBoy.Cartridges.SHADES[3]
local h=SpiffBoy.Cartridges.SCREEN_WIDTH
local Y=SpiffBoy.Cartridges.SCREEN_HEIGHT
local c=SpiffBoy.GameTexts.of("BrickDrop")

local a=6
local n=10
local t=18
local w=60
local o=6
local G=w-a
local H=w+n*a
local Z=o+t*a
local _=3
local aa=-1
local be=m.GARBAGE
local bf=9
local ay=10
local bg=11
local ab={
{1,4},{1,2,4},{1,3},{1,3},{1,2,4},{1,3},{1,3},
{2,3},{2},{2,3,4},{2,3,4},
}
local x=10
local I=x*a
local y=32
local az=1024/y*a
local ac={4,2,1,4,4,1,1,1,1,2}
local aA={{1,3,9},{2,5,9},{9},{6,9},{2,4,9},{7,9},{8,9},{10}}
local ad={2,3,4}
local bh={[aA[be][1]]=2^n-1}
local aB=ab[ay]
local aC=(n+2)*a

local bi=math.floor(G/2)
local bj=H+a+math.floor((h-H-a)/2)
local bk=4
local bl=16
local bm=36
local aD=56
local aE=68
local bn=4
local aF=17
local bo=46
local aG=59
local ae=32
local af=20

local aH={53,49,45,41,37,33,28,22,17,11,10,9,8,7,6,6,5,5,4,4,3}
local aI=10
local aJ=9
local aK=20
local bp=2
local bq=12
local br=5
local bs={40,100,300,1200}
local bt=25
local bu={[0]=0,3,5,8,10,12}
local aL=5
local bv=1000
local bw=5
local aM=6
local bx=3
local by=16
local bz=90
local aN=3
local bA=90
local J=60
local bB=3
local bC=60

local p="title"
local ag="setup"
local K="options"
local ah="confirm"
local ai="scores"
local aj="run"
local ak="scene"
local aO="initials"

local z="fall"
local al="clear"
local am="curtain"
local L="over"
local an="won"
local aP="finale"

local j={{key="a",text="ModeA"},{key="b",text="ModeB"},{key="c",text="ModeC"}}
local M={"MusicA","MusicB","MusicC","MusicOff"}
local bD=#M
local A={{key="mode",text="Mode"},{key="level",text="StartLevel"},{key="height",text="Height"},{key="music",text="Music"}}
local u={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local N={"Play","HighScores","Options"}
local ao={
scores={text="EraseScores",back=K},
}

local bE=169
local ap=22
local bF=math.floor((h-bE)/2)
local B=5
local bG={1,2,3}
local q={0,18,36,54,72,99,117,135,153}
local bH=16
local aQ=-ap-4
local bI=0.35
local bJ=9
local bK=24
local bL=180
local aR=44
local bM={3}
local bN=30
local aS=5
local aq=Y-aS*a
local bO=aq-B-ap-2
local bP=34
local bQ=16
local ar=5
local bR=15
local bS=8
local bT=13
local O=22
local aT=164
local aU=160
local bU=171
local bV=2
local bW=62
local aV=67
local bX=3
local bY=10
local bZ=34
local b_=24
local b0=98
local as=6
local aW=1
local at=8
local b1=4
local b2=30
local b3=150
local aX=80
local aY=32
local C=8
local b4=4
local b5=Z
local aZ=14
local b6=-26
local b7=-22
local b8=42
local a_=50
local a0=-44
local b9=46
local a1=15
local ca=4
local P=4
local cb=string.char(0x25B4)
local cc=string.char(0x25BE)
local cd="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local ce=62
local Q=i.INITIALS_LENGTH
local a2=30
local cf=20
local a3=12
local cg=2
local ch=24
local ci=8
local cj=2
local ck=30
local k=b.MIX_STEPS

local cl=Z-2
local R=2
local cm={1,3,5,8}
local cn=1.6
local co=60

local function a4(d)
return aH[math.min(d,#aH-1)+1]
end

local function l(f,d)
return(f-1+d)%d+1
end

local function a5(f,d)
return(f+d)%d
end

local function v(d)
if d.up then
return-1
elseif d.down then
return 1
end
return 0
end

local function au(d)
if d.left then
return-1
elseif d.right then
return 1
end
return 0
end

local function a6(d)
return string.sub(cd,d,d)
end

local function av(d)
d:clear(e.r,e.g,e.b)
end

local function D(d,f,r,s)
d:text(f,r,s,g.r,g.g,g.b,1)
end

local function d(f,r,s,S)
f:textCentre(r,s,S,g.r,g.g,g.b,1)
end

local function S(f,r,s,T)
f:textRight(r,s,T,g.r,g.g,g.b,1)
end

local function r(f,s,T,U,V)
f:rect(s,T,U,V,g.r,g.g,g.b,1)
end

local cp={{-1,0},{1,0},{0,-1},{0,1}}

local function cq(f,s,T,U)
for W,V in ipairs(cp)do
f:textCentre(s,T+V[1],U+V[2],e.r,e.g,e.b,1)
end
d(f,s,T,U)
end

local function cr(T)
local s={mode=1,level=0,height=0,music=1}
local f=T.setup
if type(f)~="table"then
return s
end
if SpiffBoy.isInteger(f.mode)and f.mode>=1 and f.mode<=#j then
s.mode=f.mode
end
if SpiffBoy.isInteger(f.level)and f.level>=0 and f.level<=aJ then
s.level=f.level
end
if SpiffBoy.isInteger(f.height)and f.height>=0 and f.height<=aL then
s.height=f.height
end
if SpiffBoy.isInteger(f.music)and f.music>=1 and f.music<=#M then
s.music=f.music
end
return s
end

local function cs(V)
local s={music=k,effects=k}
local U=V.options
if type(U)~="table"then
return s
end
for W,T in ipairs(u)do
local f=T.key and U[T.key]
if SpiffBoy.isInteger(f)and f>=0 and f<=k then
s[T.key]=f
end
end
return s
end

local function ct(X)
local f=m.cells(X,1)
local T,U,V,W=4,-1,4,-1
for s=1,4 do
T=math.min(T,f[s][1])
U=math.max(U,f[s][1])
V=math.min(V,f[s][2])
W=math.max(W,f[s][2])
end
return T,U,V,W
end

function SpiffBoyBrickDropGame:init()
self.blocks=self.context.art("blocks")
self.runs=self.context.art("runs")
self.rows=self.context.art("rows")
self.wallRows=self.context.art("wallRows")
self.wellBricks=self.context.art("wellBricks")
self.frameBricks=self.context.art("frame")
self.logo=self.context.art("logo")
self.skyline=self.context.art("skyline")
self.camp=ax.new(self.sequencer,self.random,self.context.art,{
ground=cl,
groundColour=F,
cover={x=G,width=aC},
windows={
{x=R,width=G-R*2},
{x=H+a+R,width=h-H-a-R*2},
},
})
self.records=i.read(self.save)
self.mix=cs(self.save)
self.mixDirty=false
self.setup=cr(self.save)
self.setupDirty=false
self.wall=bd.new(self.random,bN,aS,a,bO)
self.menuIndex=1
self.setupIndex=1
self.optionIndex=1
self.clock=0
self.score=0
self.mode=p
self.introTick=0
self.introDone=false
self.lettersLanded=0
self:applyMix()
end

function SpiffBoyBrickDropGame:applyMix()
self.sequencer:setMix(self.mix.music/k,self.mix.effects/k)
end

function SpiffBoyBrickDropGame:keepMusic(f)
if not self.sequencer:isPlaying()then
self.sequencer:play(f)
end
end

function SpiffBoyBrickDropGame:resetTrack(f)
self.track=f
self.trackStep=0
end

function SpiffBoyBrickDropGame:keepTrack(s)
if self.track==bD or self.sequencer:isPlaying()then
return
end
local f=b.TRACKS[self.track].order
self.trackStep=self.trackStep%#f+1
self.sequencer:play(b.barName(self.track,s,f[self.trackStep]))
end

function SpiffBoyBrickDropGame:gameMode()
return j[self.setup.mode]
end

function SpiffBoyBrickDropGame:currentRecords()
return i.list(self.records,self:gameMode().key,self.setup.level,self.setup.height)
end

local function a7(f)
return i.TABLE_SIZES[f]
end

function SpiffBoyBrickDropGame:persistRecords()
self.save.records=i.write(self.records)
self:persist()
end

function SpiffBoyBrickDropGame:tick(s,T)
self.clock=self.clock+1
local f=s[1]
if self.mode==aj then
self:tickRun(f)
elseif self.mode==ak then
if self.escape:advance(f)then
self.escape=nil
self:offerRecord()
end
elseif self.mode==aO then
self:keepMusic(b.TITLE)
self:tickInitials(f)
elseif self.mode==ag then
self:keepTrack(false)
self:tickSetup(f)
else
self:tickWall()
if self.introDone then
self:keepMusic(b.TITLE)
end
if self.mode==p then
self:tickTitle(f)
elseif self.mode==K then
self:tickOptions(f)
elseif self.mode==ah then
self:tickConfirm(f)
else
self:tickScores(f)
end
end
end

function SpiffBoyBrickDropGame:tickWall()
if self.wall:tick()=="row"and self.introDone and self.mode==p then
self.sequencer:effect(b.ROW)
end
end

local function aw(s,T)
local f=T-(s-1)*bJ
if f<=0 then
return aQ
end
return math.min(B,aQ+bI*f*f/2)
end

function SpiffBoyBrickDropGame:tickIntro(s)
if s and(s.pressed.a or s.pressed.b or s.pressed.start)then
self:endIntro()
return
end
self.introTick=self.introTick+1
local f=0
for T=1,#q do
if aw(T,self.introTick)>=B then
f=f+1
end
end
if f>self.lettersLanded then
self.lettersLanded=f
self.sequencer:effect(b.THUD)
end
if f==#q and aw(#q,self.introTick-bK)>=B then
self:endIntro()
end
end

function SpiffBoyBrickDropGame:endIntro()
self.introDone=true
self.lettersLanded=#q
self.sequencer:play(b.TITLE)
end

function SpiffBoyBrickDropGame:tickTitle(f)
if not self.introDone then
self:tickIntro(f)
return
end
if not f then
return
end
local s=f.pressed
local T=v(s)
if T~=0 then
self.menuIndex=l(self.menuIndex+T,#N)
self.sequencer:effect(b.TICK)
end
if s.a or s.start then
local U=N[self.menuIndex]
self.sequencer:effect(b.CONFIRM)
if U=="Play"then
self:openSetup()
elseif U=="Options"then
self:openOptions()
else
self:showScores(self.setup.mode,1)
end
end
end

function SpiffBoyBrickDropGame:openSetup()
self.setupIndex=1
self.mode=ag
self.sequencer:stop()
self:resetTrack(self.setup.music)
end

function SpiffBoyBrickDropGame:saveSetup()
if self.setupDirty then
local f=self.setup
self.save.setup={mode=f.mode,level=f.level,height=f.height,music=f.music}
self:persist()
self.setupDirty=false
end
end

function SpiffBoyBrickDropGame:closeSetup()
self:saveSetup()
self.sequencer:stop()
self.mode=p
end

function SpiffBoyBrickDropGame:setupRowShown(f)
return A[f].key~="height"or self:gameMode().key=="b"
end

function SpiffBoyBrickDropGame:moveSetupCursor(s)
local f=self.setupIndex
repeat
f=l(f+s,#A)
until self:setupRowShown(f)
self.setupIndex=f
end

function SpiffBoyBrickDropGame:turnSetup(s)
local f=self.setup
local T=A[self.setupIndex].key
if T=="mode"then
f.mode=l(f.mode+s,#j)
elseif T=="level"then
f.level=a5(f.level+s,aJ+1)
elseif T=="height"then
f.height=a5(f.height+s,aL+1)
else
f.music=l(f.music+s,#M)
self.sequencer:stop()
self:resetTrack(f.music)
end
self.setupDirty=true
self.sequencer:effect(b.TICK)
end

function SpiffBoyBrickDropGame:tickSetup(s)
if not s then
return
end
local f=s.pressed
local T=v(f)
if T~=0 then
self:moveSetupCursor(T)
self.sequencer:effect(b.TICK)
end
local U=au(f)
if U~=0 then
self:turnSetup(U)
end
if f.a or f.start then
self:saveSetup()
self:startRun()
elseif f.b then
self.sequencer:effect(b.CONFIRM)
self:closeSetup()
end
end

function SpiffBoyBrickDropGame:openOptions()
self.optionIndex=1
self.mode=K
end

function SpiffBoyBrickDropGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self.mode=p
end

function SpiffBoyBrickDropGame:turnOption(T)
local f=u[self.optionIndex]
if not f.key then
return
end
local s=SpiffBoy.clamp(self.mix[f.key]+T,0,k)
if s==self.mix[f.key]then
return
end
self.mix[f.key]=s
self.mixDirty=true
self:applyMix()
self.sequencer:effect(b.STEP..s)
end

function SpiffBoyBrickDropGame:tickOptions(s)
if not s then
return
end
local f=s.pressed
local T=v(f)
if T~=0 then
self.optionIndex=l(self.optionIndex+T,#u)
self.sequencer:effect(b.TICK)
end
local U=au(f)
if U~=0 then
self:turnOption(U)
end
if f.b or f.start then
self.sequencer:effect(b.CONFIRM)
self:closeOptions()
elseif f.a then
self.sequencer:effect(b.CONFIRM)
if u[self.optionIndex].action then
self:openConfirm("scores")
else
self:closeOptions()
end
end
end

function SpiffBoyBrickDropGame:openConfirm(f)
self.confirmKind=f
self.confirmYes=false
self.mode=ah
end

function SpiffBoyBrickDropGame:acceptConfirm()
self.records=i.read({})
self.flashRankIndex=nil
self:persistRecords()
end

function SpiffBoyBrickDropGame:tickConfirm(s)
if not s then
return
end
local f=s.pressed
if f.left or f.right or f.up or f.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(b.TICK)
end
if f.b then
self.sequencer:effect(b.CONFIRM)
self.mode=ao[self.confirmKind].back
elseif f.a or f.start then
self.sequencer:effect(b.CONFIRM)
if self.confirmYes then
self:acceptConfirm()
end
self.mode=ao[self.confirmKind].back
end
end

function SpiffBoyBrickDropGame:pageRecords(f)
return i.list(self.records,j[f].key,self.setup.level,self.setup.height)
end

function SpiffBoyBrickDropGame:scoresRows(T)
local s=self.screen:lineHeight()
local f=C+s+b4
if j[T].key=="b"then
f=f+s
end
return f,math.floor((b5-f)/s)
end

function SpiffBoyBrickDropGame:clampScoresTop(f,s)
local U,T=self:scoresRows(f)
return SpiffBoy.clamp(s,1,#self:pageRecords(f)-T+1)
end

function SpiffBoyBrickDropGame:showScores(f,s)
self.mode=ai
self.scoresPage=f
self.scoresTop=self:clampScoresTop(f,s)
end

function SpiffBoyBrickDropGame:flashRank(f)
self.flashRankIndex=f
self.flashUntil=self.clock+a1*ca*2
end

function SpiffBoyBrickDropGame:isRankInverted(f)
if f~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/a1)%2==1
end

function SpiffBoyBrickDropGame:tickScores(s)
if not s then
return
end
local f=s.pressed
local T=v(f)
local U=au(f)
if T~=0 then
local V=self:clampScoresTop(self.scoresPage,self.scoresTop+T)
if V~=self.scoresTop then
self.scoresTop=V
self.sequencer:effect(b.TICK)
end
elseif U~=0 then
self.flashRankIndex=nil
self:showScores(l(self.scoresPage+U,#j),1)
self.sequencer:effect(b.TICK)
elseif f.a or f.b or f.start then
self.sequencer:effect(b.CONFIRM)
self.mode=p
end
end

function SpiffBoyBrickDropGame:startRun()
self.well=m.new(n,t)
self.bag=m.newBag(self.random)
self.modeKey=self:gameMode().key
self.startLevel=self.setup.level
self.garbageHeight=self.setup.height
if self.modeKey=="b"then
self.well:fillGarbage(bu[self.garbageHeight],self.random)
end
self.level=self.startLevel
self.lines=0
self.score=0
self.piece={kind=1,rotation=1,x=_,y=aa}
self.nextKind=self.bag.draw()
self.holdKind=nil
self.holdUsed=false
self.repeatTimer=0
self.softBlocked=false
self.paused=false
self.quake=0
self.levelBlink=0
self.phase=z
self.mode=aj
self.camp:reset(cn*(aK-self.startLevel)*aI)
self.sequencer:stop()
self.sequencer:play(b.START)
self:resetTrack(self.setup.music)
self:spawn(self.nextKind)
self.nextKind=self.bag.draw()
end

function SpiffBoyBrickDropGame:linesLeft()
return math.max(0,bt-self.lines)
end

function SpiffBoyBrickDropGame:spawn(s)
local f=self.piece
f.kind=s
f.rotation=1
f.x=_
f.y=aa
self.dropTimer=a4(self.level)
self.softBlocked=true
if not self.well:fits(s,1,_,aa)then
self:topOut()
end
end

function SpiffBoyBrickDropGame:spawnNext()
self:spawn(self.nextKind)
self.nextKind=self.bag.draw()
self.holdUsed=false
end

function SpiffBoyBrickDropGame:holdPiece()
if self.holdUsed then
return
end
local f=self.piece.kind
if self.holdKind then
self:spawn(self.holdKind)
else
self:spawn(self.nextKind)
self.nextKind=self.bag.draw()
end
self.holdKind=f
self.holdUsed=true
self.sequencer:effect(b.HOLD)
end

function SpiffBoyBrickDropGame:shift(s)
local f=self.piece
if self.well:fits(f.kind,f.rotation,f.x+s,f.y)then
f.x=f.x+s
self.sequencer:effect(b.MOVE)
return true
end
return false
end

function SpiffBoyBrickDropGame:rotate(U)
local f=self.piece
local s=l(f.rotation+U,m.rotationCount(f.kind))
local T=self.well:kick(f.kind,s,f.x,f.y)
if T then
f.rotation=s
f.x=f.x+T
self.sequencer:effect(b.ROTATE)
end
end

function SpiffBoyBrickDropGame:fall()
local f=self.piece
if self.well:fits(f.kind,f.rotation,f.x,f.y+1)then
f.y=f.y+1
return true
end
self:lock()
return false
end

function SpiffBoyBrickDropGame:lock()
local s=self.piece
if not self.well:place(s.kind,s.rotation,s.x,s.y)then
self:topOut()
return
end
local f,T=self.well:fullRows()
if#f==0 then
self.sequencer:effect(b.LOCK)
self:spawnNext()
return
end
self.clearRows=T
self.clearCount=#f
self.clearTimer=aM*bx*2
self.phase=al
self.score=self.score+bs[#f]*(self.level+1)
if self.modeKey=="a"then
self.camp:deliver(cm[#f])
end
if#f==4 then
self.quake=by
self.sequencer:effect(b.QUAD)
else
self.sequencer:effect(b.CLEAR)
end
end

function SpiffBoyBrickDropGame:finishClear()
self.well:removeRows(self.clearRows)
self.clearRows=nil
self.lines=self.lines+self.clearCount
local f=self.startLevel+math.floor(self.lines/aI)
if f>self.level then
self.level=f
self.levelBlink=bz
self.sequencer:effect(b.LEVEL)
end
if self.modeKey=="b"and self:linesLeft()==0 then
self:winCleared()
return
end
if self.modeKey=="a"and self.level>=aK then
self:winEscaped()
return
end
self.phase=z
self:spawnNext()
end

function SpiffBoyBrickDropGame:topOut()
if self.modeKey=="a"then
self.camp:startOverrun()
end
self.phase=am
self.curtainRow=t
self.curtainTimer=aN
self.sequencer:stop()
self.sequencer:effect(b.LOSE)
end

function SpiffBoyBrickDropGame:winCleared()
self.phase=an
self.bonus=bv*(self.startLevel+self.garbageHeight+1)
self.tally=0
self.wonHold=bC
self.sequencer:stop()
self.sequencer:play(b.CLEARED)
end

function SpiffBoyBrickDropGame:winEscaped()
self.sequencer:stop()
local f=self.camp:stage()
if f==0 then
self.phase=aP
self.finaleTick=0
self.camp:startOverrun()
return
end
local s=E.FOOT
if f>=#ax.PROJECTS then
s=E.RADIO
elseif f>=2 then
s=E.TRUCK
end
self.mode=ak
self.escape=E.new(s,self.sequencer,self.context.art,self.score)
end

function SpiffBoyBrickDropGame:tickRun(f)
if self.quake>0 then
self.quake=self.quake-1
end
if self.levelBlink>0 then
self.levelBlink=self.levelBlink-1
end
if self.modeKey=="a"and not self.paused then
self.camp:tick()
end
if self.phase==z then
self:tickFall(f)
elseif self.phase==al then
self:keepTrack(self:inDanger())
self.clearTimer=self.clearTimer-1
if self.clearTimer<=0 then
self:finishClear()
end
elseif self.phase==am then
self:tickCurtain()
elseif self.phase==L then
self.overTimer=self.overTimer-1
if self.overTimer<=0 and not self.sequencer:isPlaying()and(self.modeKey~="a"or self.camp:overrunDone())then
self:afterGameOver()
end
elseif self.phase==aP then
self:tickFinale(f)
else
self:tickWon()
end
end

function SpiffBoyBrickDropGame:tickFinale(f)
self.finaleTick=self.finaleTick+1
local s=f and self.finaleTick>co and(f.pressed.a or f.pressed.start)
if s or self.camp:overrunDone()then
self:offerRecord()
end
end

function SpiffBoyBrickDropGame:inDanger()
return self.well:top()<bw
end

function SpiffBoyBrickDropGame:tickFall(f)
self:keepTrack(self:inDanger())
if f and f.pressed.start then
self.paused=not self.paused
self.sequencer:effect(b.CONFIRM)
end
if self.paused then
return
end
if f then
self:control(f)
if self.phase~=z then
return
end
end
local s=f and f.held.down and not self.softBlocked
if s then
self.dropTimer=math.min(self.dropTimer,bp)
end
self.dropTimer=self.dropTimer-1
if self.dropTimer<=0 then
self.dropTimer=a4(self.level)
if self:fall()and s then
self.score=self.score+1
end
end
end

function SpiffBoyBrickDropGame:control(U)
local T,f=U.held,U.pressed
if not T.down then
self.softBlocked=false
end
local s=0
if T.left then
s=-1
elseif T.right then
s=1
end
if f.left or f.right then
self:shift(s)
self.repeatTimer=bq
elseif s~=0 then
self.repeatTimer=self.repeatTimer-1
if self.repeatTimer<=0 then
self:shift(s)
self.repeatTimer=br
end
end
if f.a then
self:rotate(1)
end
if f.b then
self:rotate(-1)
end
if f.up then
self:holdPiece()
end
end

function SpiffBoyBrickDropGame:tickCurtain()
self.curtainTimer=self.curtainTimer-1
if self.curtainTimer>0 then
return
end
self.curtainTimer=aN
self.curtainRow=self.curtainRow-1
if self.curtainRow<=0 then
self.curtainRow=0
self.phase=L
self.overTimer=bA
self.sequencer:play(b.OVER)
end
end

function SpiffBoyBrickDropGame:afterGameOver()
if self.modeKey=="b"then
self:openSetup()
return
end
self:offerRecord()
end

function SpiffBoyBrickDropGame:offerRecord()
local f=i.list(self.records,self.modeKey,self.startLevel,self.garbageHeight)
if i.rankOf(f,a7(self.modeKey),self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.sequencer:stop()
self.mode=aO
return
end
self:openSetup()
end

function SpiffBoyBrickDropGame:tickWon()
if self.tally<J then
self.tally=self.tally+1
if self.tally%bB==0 then
self.sequencer:effect(b.COUNT)
end
if self.tally==J then
self.score=self.score+self.bonus
end
return
end
if self.wonHold>0 then
self.wonHold=self.wonHold-1
return
end
if not self.sequencer:isPlaying()then
self:offerRecord()
end
end

function SpiffBoyBrickDropGame:countedBonus()
if self.phase~=an or self.tally>=J then
return 0
end
return math.floor(self.bonus*self.tally/J)
end

function SpiffBoyBrickDropGame:turnLetter(s)
local f=self.cursor
self.letters[f]=l(self.letters[f]-s,ce)
self.sequencer:effect(b.TICK)
end

function SpiffBoyBrickDropGame:repeatLetter(f,s)
if f~=0 then
self:turnLetter(f)
self.letterHoldStep=f
self.letterHoldTicks=0
self.letterRepeatTimer=ch
return
end
if s==0 or s~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(s)
self.letterRepeatTimer=math.max(cj,ci-math.floor(self.letterHoldTicks/ck))
end
end

function SpiffBoyBrickDropGame:tickInitials(T)
if not T then
return
end
local f=T.pressed
local s=self.cursor
self:repeatLetter(v(f),v(T.held))
if f.left and s>1 then
self.cursor=s-1
elseif f.right and s<Q then
self.cursor=s+1
end
if f.a or f.start then
self.sequencer:effect(b.CONFIRM)
if self.cursor<Q then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoyBrickDropGame:saveScore()
local f=""
for s=1,Q do
f=f..a6(self.letters[s])
end
local T=i.ensureList(self.records,self.modeKey,self.startLevel,self.garbageHeight)
local s=i.insert(T,a7(self.modeKey),f,self.score)
self:persistRecords()
self:showScores(self.setup.mode,s)
self:flashRank(s)
end

function SpiffBoyBrickDropGame:blinkOn()
return math.floor(self.clock/a2)%2==0
end

function SpiffBoyBrickDropGame:bob()
return math.floor(self.clock/bR)%2
end

function SpiffBoyBrickDropGame:draw(f)
if self.mode==p then
self:drawTitle(f)
elseif self.mode==ag then
self:drawSetup(f)
elseif self.mode==K then
self:drawOptions(f)
elseif self.mode==ah then
self:drawConfirm(f)
elseif self.mode==ai then
self:drawScores(f)
elseif self.mode==aj then
self:drawRun(f)
elseif self.mode==ak then
self.escape:draw(f)
else
self:drawInitials(f)
end
end

function SpiffBoyBrickDropGame:drawBlock(s,f,T,U)
s:layers(self.blocks,(f-1)*a,a,a,T,U,ab[f])
end

function SpiffBoyBrickDropGame:drawCells(V,U,s,W,f)
while f>0 do
local T=math.min(f,x)
V:layers(self.runs,(U-1)*x*a,T*a,a,s,W,ab[U])
s=s+T*a
f=f-T
end
end

function SpiffBoyBrickDropGame:drawBricks(s,T,U,V,W)
local f=ay
if V%2==1 then
f=bg
end
self:drawCells(s,f,T,U,W)
end

local function a8(f,T,U)
for s=1,4 do
if f[s][1]==T and f[s][2]==U then
return true
end
end
return false
end

function SpiffBoyBrickDropGame:drawPiece(X,a9,ba,bb,bc,cu,cv)
local f=m.cells(ba,bb)
for V=1,4 do
local T,U=f[V][1],f[V][2]
local W=cu+U*a
if W>=cv and not a8(f,T-1,U)then
local s=1
while a8(f,T+s,U)do
s=s+1
end
self:drawCells(X,a9,bc+T*a,W,s)
end
end
end

function SpiffBoyBrickDropGame:drawPieceInBox(U,f,V,W)
local s,X,T,a9=ct(f)
local ba=(X-s+1)*a
local bb=(a9-T+1)*a
local bc=V-math.floor(ba/2)-s*a
local cu=W+math.floor((af-bb)/2)-T*a
self:drawPiece(U,f,f,1,bc,cu,0)
end

local function a9(f,U,s)
local T=U-math.floor(ae/2)
r(f,T-1,s-1,ae+2,af+2)
f:rect(T,s,ae,af,e.r,e.g,e.b,1)
end

function SpiffBoyBrickDropGame:drawBrickFrame(f)
av(f)
f:layers(self.frameBricks,0,h,Y,0,0,aB)
end

function SpiffBoyBrickDropGame:drawCursor(f,s,T)
local U=f:lineHeight()
self:drawBlock(f,2,s-a-self:bob(),T+math.floor((U-a)/2))
end

function SpiffBoyBrickDropGame:drawWallRow(W,X,ba,bb,s)
local bc=bb%2
for T=0,#s-1,x do
local f,U=0,1
for V=T+1,math.min(T+x,#s)do
if s[V]then
f=f+U
end
U=U*2
end
if f>0 then
for V=1,#ad do
local cu=bc*#ad+V-1
W:sheet(self.wallRows,f%y*I,cu*az+math.floor(f/y)*a,I,a,X+T*a,ba,1,ad[V])
end
end
end
end

function SpiffBoyBrickDropGame:drawTitle(f)
av(f)
f:layers(self.skyline,0,bL,aR,0,aq-aR,bM)
self.wall:draw(0,aq,function(s,T,U,V)
self:drawWallRow(f,s,T,U,V)
end,function(s,T,U)
self:drawBricks(f,s,T,U,1)
end)
for s=1,#q do
local T=B
if not self.introDone then
T=math.floor(aw(s,self.introTick))
end
f:layers(self.logo,q[s],bH,ap,bF+q[s],T,bG)
end
if not self.introDone then
return
end
local T=h/2
for s=1,#N do
local U=c(N[s])
local V=bP+(s-1)*bQ
local W=f:textWidth(U)
local X=T-math.floor(W/2)
cq(f,U,T,V)
if s==self.menuIndex then
self:drawCursor(f,X-ar,V)
end
end
end

function SpiffBoyBrickDropGame:drawMenuRow(f,V,T,U,W,s,X)
D(f,V,U,s)
if T then
S(f,T,W,s)
end
if X then
self:drawCursor(f,U-ar,s)
end
end

function SpiffBoyBrickDropGame:setupValue(s)
local f=self.setup
if s=="mode"then
return c(j[f.mode].text)
elseif s=="level"then
return tostring(f.level)
elseif s=="height"then
return tostring(f.height)
end
return c(M[f.music])
end

function SpiffBoyBrickDropGame:drawRecordRows(f,cu,ba,cv,cw)
local s=h/2
local bb=f:lineHeight()
for T=ba,cv do
local bc=cu[T]
local U=cw+(T-ba)*bb
local V,W,X=g.r,g.g,g.b
if self.mode==ai and self:isRankInverted(T)then
r(f,s+a0,U,b9-a0,bb)
V,W,X=e.r,e.g,e.b
end
f:textRight(tostring(T)..".",s+b6,U,V,W,X,1)
f:text(bc.initials,s+b7,U,V,W,X,1)
f:textRight(tostring(bc.score),s+b8,U,V,W,X,1)
end
end

local function bb(f,T,s)
S(f,"<",aU-f:textWidth(T)-bV,s)
S(f,">",bU,s)
end

function SpiffBoyBrickDropGame:drawSetup(f)
self:drawBrickFrame(f)
local s=bS
for T=1,#A do
if self:setupRowShown(T)then
local U=A[T]
local V=self:setupValue(U.key)
local W=T==self.setupIndex
self:drawMenuRow(f,c(U.text),V,O,aU,s,W)
if W then
bb(f,V,s)
end
s=s+bT
end
end
r(f,O,bW,aT-O,1)
local T=self:currentRecords()
if#T==0 then
d(f,c("NoScores"),h/2,aV+f:lineHeight())
return
end
self:drawRecordRows(f,T,1,math.min(#T,bX),aV)
end

local function bc(f,s,T,V)
local U=k*as+(k-1)*aW
r(f,s-1,T-1,U+2,at+2)
f:rect(s,T,U,at,e.r,e.g,e.b,1)
for W=1,V do
r(f,s+(W-1)*(as+aW),T,as,at)
end
end

function SpiffBoyBrickDropGame:drawOptions(f)
self:drawBrickFrame(f)
d(f,c("Options"),h/2,bY)
for s=1,#u do
local T=u[s]
local U=bZ+(s-1)*b_
self:drawMenuRow(f,c(T.text),nil,O,aT,U,s==self.optionIndex)
if T.key then
bc(f,b0,U+b1,self.mix[T.key])
end
end
end

function SpiffBoyBrickDropGame:drawConfirm(f)
self:drawBrickFrame(f)
local T=h/2
local X=f:lineHeight()
local U=f:wrapText(c(ao[self.confirmKind].text),b3)
for s=1,#U do
d(f,U[s],T,b2+(s-1)*X)
end
local V={{text="No",x=T-aY,chosen=not self.confirmYes},{text="Yes",x=T+aY,chosen=self.confirmYes}}
for ba=1,#V do
local s=V[ba]
local W=c(s.text)
d(f,W,s.x,aX)
if s.chosen then
self:drawCursor(f,s.x-math.floor(f:textWidth(W)/2)-ar,aX)
end
end
end

function SpiffBoyBrickDropGame:drawScores(f)
self:drawBrickFrame(f)
local s=h/2
local W=f:lineHeight()
local T=self.scoresPage
d(f,c(j[T].text),s,C)
D(f,"<",aZ,C)
S(f,">",h-aZ,C)
if j[T].key=="b"then
local U=c("Level",self.setup.level).."  "..c("Height").." "..tostring(self.setup.height)
d(f,U,s,C+W)
end
local U=self:pageRecords(T)
local V,X=self:scoresRows(T)
if#U==0 then
d(f,c("NoScores"),s,V+W)
return
end
local ba=math.min(#U,self.scoresTop+X-1)
self:drawRecordRows(f,U,self.scoresTop,ba,V)
if self.scoresTop>1 then
D(f,cb,s+a_,V)
end
if ba<#U then
D(f,cc,s+a_,V+(X-1)*W)
end
end

function SpiffBoyBrickDropGame:drawInitials(s)
self:drawBrickFrame(s)
local T=h/2
local U=s:lineHeight()
local f=10
d(s,c("NewHighScore"),T,f)
f=f+U*1.5
d(s,tostring(self.score),T,f)
f=f+U*1.5
d(s,c("EnterInitials"),T,f)
f=f+U*1.5
for V=1,Q do
local W=T+(V-2)*cf
d(s,a6(self.letters[V]),W,f)
if V==self.cursor and self:blinkOn()then
r(s,W-a3/2,f+U+1,a3,cg)
end
end
end

local function U(f,X,ba,cu)
local cv=f:lineHeight()
local s=f:textWidth(X)+P*2
local T=cv+P*2
local V=math.floor(ba-s/2)
local W=math.floor(cu-T/2)
r(f,V-1,W-1,s+2,T+2)
f:rect(V,W,s,T,e.r,e.g,e.b,1)
D(f,X,V+P,W+P)
end

function SpiffBoyBrickDropGame:drawWellBricks(f)
f:layers(self.wellBricks,0,aC,Y,G,0,aB)
end

function SpiffBoyBrickDropGame:rowHidden(f)
if self.phase~=al or not self.clearRows[f]then
return false
end
return math.floor(self.clearTimer/aM)%2==1
end

function SpiffBoyBrickDropGame:drawRowLayers(T,V,W,X)
for f=1,#ac do
local s=V[f]
if s then
T:sheet(self.rows,s%y*I,(f-1)*az+math.floor(s/y)*a,I,a,W,X,1,ac[f])
end
end
end

local V={}

local function cu()
for f=1,#ac do
V[f]=nil
end
return V
end

function SpiffBoyBrickDropGame:drawWellRow(cv,W,cw)
local f=cu()
local s=1
for cx=0,n-1 do
local X=self.well:at(cx,W)
if X~=m.EMPTY then
local T=aA[X]
for ba=1,#T do
f[T[ba]]=(f[T[ba]]or 0)+s
end
end
s=s*2
end
self:drawRowLayers(cv,f,cw,o+W*a)
end

function SpiffBoyBrickDropGame:drawWellContent(s,cv)
local T=w+cv
local W=self.phase==am or self.phase==L
local X=t-1
if W then
X=self.curtainRow-1
end
for f=0,X do
if not self:rowHidden(f)then
self:drawWellRow(s,f,T)
end
end
if self.phase==z then
local f=self.piece
local ba=self.well:landing(f.kind,f.rotation,f.x,f.y)
if ba>f.y then
self:drawPiece(s,bf,f.kind,f.rotation,T+f.x*a,o+ba*a,o)
end
self:drawPiece(s,f.kind,f.kind,f.rotation,T+f.x*a,o+f.y*a,0)
end
if W then
for f=self.curtainRow,t-1 do
self:drawRowLayers(s,bh,T,o+f*a)
end
end
end

function SpiffBoyBrickDropGame:drawCounters(f)
local s=bi
d(f,c("Score"),s,bk)
d(f,tostring(self.score+self:countedBonus()),s,bl)
if self.levelBlink==0 or self:blinkFast()then
d(f,c("Level",self.level),s,bm)
end
if self.modeKey=="b"then
d(f,c("LinesLeft"),s,aD)
d(f,tostring(self:linesLeft()),s,aE)
else
d(f,c("Lines"),s,aD)
d(f,tostring(self.lines),s,aE)
end
end

function SpiffBoyBrickDropGame:blinkFast()
return math.floor(self.clock/(a2/3))%2==0
end

function SpiffBoyBrickDropGame:drawBoxes(f)
local s=bj
d(f,c("Next"),s,bn)
a9(f,s,aF)
if not self.paused then
self:drawPieceInBox(f,self.nextKind,s,aF)
end
d(f,c("Hold"),s,bo)
a9(f,s,aG)
if self.holdKind and not self.paused then
self:drawPieceInBox(f,self.holdKind,s,aG)
end
end

function SpiffBoyBrickDropGame:drawRun(f)
av(f)
if self.modeKey=="a"then
self.camp:draw(f,self.clock)
end
f:rect(w,0,n*a,Z,F.r,F.g,F.b,1)
local W=0
if self.quake>0 then
W=(math.floor(self.quake/2)%2)*2-1
end
if not self.paused then
self:drawWellContent(f,W)
end
self:drawWellBricks(f)
self:drawCounters(f)
self:drawBoxes(f)
local s=w+n*a/2
local T=o+t*a/2
if self.paused then
U(f,getText("UI_SpiffBoy_Paused"),s,T)
elseif self.phase==L then
U(f,c("GameOver"),s,T)
elseif self.phase==an then
U(f,c("Cleared"),s,T)
end
end
