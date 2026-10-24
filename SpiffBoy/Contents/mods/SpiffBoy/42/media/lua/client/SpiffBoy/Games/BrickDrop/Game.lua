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
local bb=SpiffBoy.BrickDrop.TitleWall
local aw=SpiffBoy.BrickDrop.Camp
local G=SpiffBoy.BrickDrop.EscapeScene

local e=SpiffBoy.Cartridges.SHADES[4]
local g=SpiffBoy.Cartridges.SHADES[1]
local H=SpiffBoy.Cartridges.SHADES[3]
local h=SpiffBoy.Cartridges.SCREEN_WIDTH
local X=SpiffBoy.Cartridges.SCREEN_HEIGHT
local c=SpiffBoy.GameTexts.of("BrickDrop")

local a=6
local n=10
local s=18
local w=60
local o=6
local I=w-a
local J=w+n*a
local Y=o+s*a
local Z=3
local _=-1
local bc=m.GARBAGE
local bd=9
local ax=10
local be=11
local aa={
{1,4},{1,2,4},{1,3},{1,3},{1,2,4},{1,3},{1,3},
{2,3},{2},{2,3,4},{2,3,4},
}
local z=10
local K=z*a
local A=32
local ay=1024/A*a
local ab={4,2,1,4,4,1,1,1,1,2}
local az={{1,3,9},{2,5,9},{9},{6,9},{2,4,9},{7,9},{8,9},{10}}
local ac={2,3,4}
local bf={[az[bc][1]]=2^n-1}
local aA=aa[ax]
local aB=(n+2)*a

local bg=math.floor(I/2)
local bh=J+a+math.floor((h-J-a)/2)
local bi=4
local bj=16
local bk=36
local aC=56
local aD=68
local bl=4
local aE=17
local bm=46
local aF=59
local ad=32
local ae=20

local aG={53,49,45,41,37,33,28,22,17,11,10,9,8,7,6,6,5,5,4,4,3}
local aH=10
local aI=9
local aJ=20
local bn=2
local bo=12
local bp=5
local bq={40,100,300,1200}
local br=25
local bs={[0]=0,3,5,8,10,12}
local aK=5
local bt=1000
local bu=5
local aL=6
local bv=3
local bw=16
local bx=90
local aM=3
local by=90
local L=60
local bz=3
local bA=60

local p="title"
local af="setup"
local M="options"
local ag="confirm"
local ah="scores"
local ai="run"
local aj="scene"
local aN="initials"

local B="fall"
local ak="clear"
local al="curtain"
local N="over"
local am="won"
local aO="finale"

local j={{key="a",text="ModeA"},{key="b",text="ModeB"},{key="c",text="ModeC"}}
local O={"MusicA","MusicB","MusicC","MusicOff"}
local bB=#O
local C={{key="mode",text="Mode"},{key="level",text="StartLevel"},{key="height",text="Height"},{key="music",text="Music"}}
local t={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local P={"Play","HighScores","Options"}
local an={
scores={text="EraseScores",back=M},
}

local bC=169
local ao=22
local bD=math.floor((h-bC)/2)
local D=5
local bE={1,2,3}
local q={0,18,36,54,72,99,117,135,153}
local bF=16
local aP=-ao-4
local bG=0.35
local bH=9
local bI=24
local bJ=180
local aQ=44
local bK={3}
local bL=30
local aR=5
local ap=X-aR*a
local bM=ap-D-ao-2
local bN=34
local bO=16
local aq=5
local bP=15
local bQ=8
local bR=13
local Q=22
local aS=164
local aT=160
local bS=171
local bT=2
local bU=62
local aU=67
local bV=3
local bW=10
local bX=34
local bY=24
local bZ=98
local ar=6
local aV=1
local as=8
local b_=4
local b0=30
local b1=150
local aW=80
local aX=32
local E=8
local b2=4
local b3=Y
local aY=14
local b4=-26
local b5=-22
local b6=42
local aZ=50
local a_=-44
local b7=46
local a0=15
local b8=4
local R=4
local b9=string.char(0x25B4)
local ca=string.char(0x25BE)
local cb="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local cc=62
local S=i.INITIALS_LENGTH
local a1=30
local cd=20
local a2=12
local ce=2
local cf=24
local cg=8
local ch=2
local ci=30
local k=b.MIX_STEPS

local cj=Y-2
local T=2
local ck={1,3,5,8}
local cl=1.6
local cm=60

local function a3(level)
return aG[math.min(level,#aG-1)+1]
end

local function l(value,count)
return(value-1+count)%count+1
end

local function a4(value,count)
return(value+count)%count
end

local function u(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function at(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function a5(index)
return string.sub(cb,index,index)
end

local function au(screen)
screen:clear(e.r,e.g,e.b)
end

local function F(screen,label,x,y)
screen:text(label,x,y,g.r,g.g,g.b,1)
end

local function d(screen,label,x,y)
screen:textCentre(label,x,y,g.r,g.g,g.b,1)
end

local function U(screen,label,x,y)
screen:textRight(label,x,y,g.r,g.g,g.b,1)
end

local function r(screen,x,y,width,height)
screen:rect(x,y,width,height,g.r,g.g,g.b,1)
end

local cn={{-1,0},{1,0},{0,-1},{0,1}}

local function co(screen,label,x,y)
for v,f in ipairs(cn)do
screen:textCentre(label,x+f[1],y+f[2],e.r,e.g,e.b,1)
end
d(screen,label,x,y)
end

local function cp(save)
local v={mode=1,level=0,height=0,music=1}
local f=save.setup
if type(f)~="table"then
return v
end
if SpiffBoy.isInteger(f.mode)and f.mode>=1 and f.mode<=#j then
v.mode=f.mode
end
if SpiffBoy.isInteger(f.level)and f.level>=0 and f.level<=aI then
v.level=f.level
end
if SpiffBoy.isInteger(f.height)and f.height>=0 and f.height<=aK then
v.height=f.height
end
if SpiffBoy.isInteger(f.music)and f.music>=1 and f.music<=#O then
v.music=f.music
end
return v
end

local function cq(save)
local v={music=k,effects=k}
local y=save.options
if type(y)~="table"then
return v
end
for V,x in ipairs(t)do
local f=x.key and y[x.key]
if SpiffBoy.isInteger(f)and f>=0 and f<=k then
v[x.key]=f
end
end
return v
end

local function cr(kind)
local f=m.cells(kind,1)
local x,y,V,W=4,-1,4,-1
for v=1,4 do
x=math.min(x,f[v][1])
y=math.max(y,f[v][1])
V=math.min(V,f[v][2])
W=math.max(W,f[v][2])
end
return x,y,V,W
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
self.camp=aw.new(self.sequencer,self.random,self.context.art,{
ground=cj,
groundColour=H,
cover={x=I,width=aB},
windows={
{x=T,width=I-T*2},
{x=J+a+T,width=h-J-a-T*2},
},
})
self.records=i.read(self.save)
self.mix=cq(self.save)
self.mixDirty=false
self.setup=cp(self.save)
self.setupDirty=false
self.wall=bb.new(self.random,bL,aR,a,bM)
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

function SpiffBoyBrickDropGame:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function SpiffBoyBrickDropGame:resetTrack(track)
self.track=track
self.trackStep=0
end

function SpiffBoyBrickDropGame:keepTrack(fast)
if self.track==bB or self.sequencer:isPlaying()then
return
end
local f=b.TRACKS[self.track].order
self.trackStep=self.trackStep%#f+1
self.sequencer:play(b.barName(self.track,fast,f[self.trackStep]))
end

function SpiffBoyBrickDropGame:gameMode()
return j[self.setup.mode]
end

function SpiffBoyBrickDropGame:currentRecords()
return i.list(self.records,self:gameMode().key,self.setup.level,self.setup.height)
end

local function a6(modeKey)
return i.TABLE_SIZES[modeKey]
end

function SpiffBoyBrickDropGame:persistRecords()
self.save.records=i.write(self.records)
self:persist()
end

function SpiffBoyBrickDropGame:tick(inputs,tick)
self.clock=self.clock+1
local f=inputs[1]
if self.mode==ai then
self:tickRun(f)
elseif self.mode==aj then
if self.escape:advance(f)then
self.escape=nil
self:offerRecord()
end
elseif self.mode==aN then
self:keepMusic(b.TITLE)
self:tickInitials(f)
elseif self.mode==af then
self:keepTrack(false)
self:tickSetup(f)
else
self:tickWall()
if self.introDone then
self:keepMusic(b.TITLE)
end
if self.mode==p then
self:tickTitle(f)
elseif self.mode==M then
self:tickOptions(f)
elseif self.mode==ag then
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

local function av(index,tick)
local f=tick-(index-1)*bH
if f<=0 then
return aP
end
return math.min(D,aP+bG*f*f/2)
end

function SpiffBoyBrickDropGame:tickIntro(input)
if input and(input.pressed.a or input.pressed.b or input.pressed.start)then
self:endIntro()
return
end
self.introTick=self.introTick+1
local f=0
for v=1,#q do
if av(v,self.introTick)>=D then
f=f+1
end
end
if f>self.lettersLanded then
self.lettersLanded=f
self.sequencer:effect(b.THUD)
end
if f==#q and av(#q,self.introTick-bI)>=D then
self:endIntro()
end
end

function SpiffBoyBrickDropGame:endIntro()
self.introDone=true
self.lettersLanded=#q
self.sequencer:play(b.TITLE)
end

function SpiffBoyBrickDropGame:tickTitle(input)
if not self.introDone then
self:tickIntro(input)
return
end
if not input then
return
end
local f=input.pressed
local v=u(f)
if v~=0 then
self.menuIndex=l(self.menuIndex+v,#P)
self.sequencer:effect(b.TICK)
end
if f.a or f.start then
local x=P[self.menuIndex]
self.sequencer:effect(b.CONFIRM)
if x=="Play"then
self:openSetup()
elseif x=="Options"then
self:openOptions()
else
self:showScores(self.setup.mode,1)
end
end
end

function SpiffBoyBrickDropGame:openSetup()
self.setupIndex=1
self.mode=af
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

function SpiffBoyBrickDropGame:setupRowShown(index)
return C[index].key~="height"or self:gameMode().key=="b"
end

function SpiffBoyBrickDropGame:moveSetupCursor(step)
local f=self.setupIndex
repeat
f=l(f+step,#C)
until self:setupRowShown(f)
self.setupIndex=f
end

function SpiffBoyBrickDropGame:turnSetup(delta)
local f=self.setup
local v=C[self.setupIndex].key
if v=="mode"then
f.mode=l(f.mode+delta,#j)
elseif v=="level"then
f.level=a4(f.level+delta,aI+1)
elseif v=="height"then
f.height=a4(f.height+delta,aK+1)
else
f.music=l(f.music+delta,#O)
self.sequencer:stop()
self:resetTrack(f.music)
end
self.setupDirty=true
self.sequencer:effect(b.TICK)
end

function SpiffBoyBrickDropGame:tickSetup(input)
if not input then
return
end
local f=input.pressed
local v=u(f)
if v~=0 then
self:moveSetupCursor(v)
self.sequencer:effect(b.TICK)
end
local x=at(f)
if x~=0 then
self:turnSetup(x)
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
self.mode=M
end

function SpiffBoyBrickDropGame:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self.mode=p
end

function SpiffBoyBrickDropGame:turnOption(delta)
local f=t[self.optionIndex]
if not f.key then
return
end
local v=SpiffBoy.clamp(self.mix[f.key]+delta,0,k)
if v==self.mix[f.key]then
return
end
self.mix[f.key]=v
self.mixDirty=true
self:applyMix()
self.sequencer:effect(b.STEP..v)
end

function SpiffBoyBrickDropGame:tickOptions(input)
if not input then
return
end
local f=input.pressed
local v=u(f)
if v~=0 then
self.optionIndex=l(self.optionIndex+v,#t)
self.sequencer:effect(b.TICK)
end
local x=at(f)
if x~=0 then
self:turnOption(x)
end
if f.b or f.start then
self.sequencer:effect(b.CONFIRM)
self:closeOptions()
elseif f.a then
self.sequencer:effect(b.CONFIRM)
if t[self.optionIndex].action then
self:openConfirm("scores")
else
self:closeOptions()
end
end
end

function SpiffBoyBrickDropGame:openConfirm(kind)
self.confirmKind=kind
self.confirmYes=false
self.mode=ag
end

function SpiffBoyBrickDropGame:acceptConfirm()
self.records=i.read({})
self.flashRankIndex=nil
self:persistRecords()
end

function SpiffBoyBrickDropGame:tickConfirm(input)
if not input then
return
end
local f=input.pressed
if f.left or f.right or f.up or f.down then
self.confirmYes=not self.confirmYes
self.sequencer:effect(b.TICK)
end
if f.b then
self.sequencer:effect(b.CONFIRM)
self.mode=an[self.confirmKind].back
elseif f.a or f.start then
self.sequencer:effect(b.CONFIRM)
if self.confirmYes then
self:acceptConfirm()
end
self.mode=an[self.confirmKind].back
end
end

function SpiffBoyBrickDropGame:pageRecords(page)
return i.list(self.records,j[page].key,self.setup.level,self.setup.height)
end

function SpiffBoyBrickDropGame:scoresRows(page)
local v=self.screen:lineHeight()
local f=E+v+b2
if j[page].key=="b"then
f=f+v
end
return f,math.floor((b3-f)/v)
end

function SpiffBoyBrickDropGame:clampScoresTop(page,first)
local v,f=self:scoresRows(page)
return SpiffBoy.clamp(first,1,#self:pageRecords(page)-f+1)
end

function SpiffBoyBrickDropGame:showScores(page,rank)
self.mode=ah
self.scoresPage=page
self.scoresTop=self:clampScoresTop(page,rank)
end

function SpiffBoyBrickDropGame:flashRank(rank)
self.flashRankIndex=rank
self.flashUntil=self.clock+a0*b8*2
end

function SpiffBoyBrickDropGame:isRankInverted(rank)
if rank~=self.flashRankIndex or not self.flashUntil or self.clock>=self.flashUntil then
return false
end
return math.floor((self.flashUntil-self.clock-1)/a0)%2==1
end

function SpiffBoyBrickDropGame:tickScores(input)
if not input then
return
end
local f=input.pressed
local v=u(f)
local x=at(f)
if v~=0 then
local y=self:clampScoresTop(self.scoresPage,self.scoresTop+v)
if y~=self.scoresTop then
self.scoresTop=y
self.sequencer:effect(b.TICK)
end
elseif x~=0 then
self.flashRankIndex=nil
self:showScores(l(self.scoresPage+x,#j),1)
self.sequencer:effect(b.TICK)
elseif f.a or f.b or f.start then
self.sequencer:effect(b.CONFIRM)
self.mode=p
end
end

function SpiffBoyBrickDropGame:startRun()
self.well=m.new(n,s)
self.bag=m.newBag(self.random)
self.modeKey=self:gameMode().key
self.startLevel=self.setup.level
self.garbageHeight=self.setup.height
if self.modeKey=="b"then
self.well:fillGarbage(bs[self.garbageHeight],self.random)
end
self.level=self.startLevel
self.lines=0
self.score=0
self.piece={kind=1,rotation=1,x=Z,y=_}
self.nextKind=self.bag.draw()
self.holdKind=nil
self.holdUsed=false
self.repeatTimer=0
self.softBlocked=false
self.paused=false
self.quake=0
self.levelBlink=0
self.phase=B
self.mode=ai
self.camp:reset(cl*(aJ-self.startLevel)*aH)
self.sequencer:stop()
self.sequencer:play(b.START)
self:resetTrack(self.setup.music)
self:spawn(self.nextKind)
self.nextKind=self.bag.draw()
end

function SpiffBoyBrickDropGame:linesLeft()
return math.max(0,br-self.lines)
end

function SpiffBoyBrickDropGame:spawn(kind)
local f=self.piece
f.kind=kind
f.rotation=1
f.x=Z
f.y=_
self.dropTimer=a3(self.level)
self.softBlocked=true
if not self.well:fits(kind,1,Z,_)then
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

function SpiffBoyBrickDropGame:shift(direction)
local f=self.piece
if self.well:fits(f.kind,f.rotation,f.x+direction,f.y)then
f.x=f.x+direction
self.sequencer:effect(b.MOVE)
return true
end
return false
end

function SpiffBoyBrickDropGame:rotate(direction)
local f=self.piece
local v=l(f.rotation+direction,m.rotationCount(f.kind))
local x=self.well:kick(f.kind,v,f.x,f.y)
if x then
f.rotation=v
f.x=f.x+x
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
local v=self.piece
if not self.well:place(v.kind,v.rotation,v.x,v.y)then
self:topOut()
return
end
local f,x=self.well:fullRows()
if#f==0 then
self.sequencer:effect(b.LOCK)
self:spawnNext()
return
end
self.clearRows=x
self.clearCount=#f
self.clearTimer=aL*bv*2
self.phase=ak
self.score=self.score+bq[#f]*(self.level+1)
if self.modeKey=="a"then
self.camp:deliver(ck[#f])
end
if#f==4 then
self.quake=bw
self.sequencer:effect(b.QUAD)
else
self.sequencer:effect(b.CLEAR)
end
end

function SpiffBoyBrickDropGame:finishClear()
self.well:removeRows(self.clearRows)
self.clearRows=nil
self.lines=self.lines+self.clearCount
local f=self.startLevel+math.floor(self.lines/aH)
if f>self.level then
self.level=f
self.levelBlink=bx
self.sequencer:effect(b.LEVEL)
end
if self.modeKey=="b"and self:linesLeft()==0 then
self:winCleared()
return
end
if self.modeKey=="a"and self.level>=aJ then
self:winEscaped()
return
end
self.phase=B
self:spawnNext()
end

function SpiffBoyBrickDropGame:topOut()
if self.modeKey=="a"then
self.camp:startOverrun()
end
self.phase=al
self.curtainRow=s
self.curtainTimer=aM
self.sequencer:stop()
self.sequencer:effect(b.LOSE)
end

function SpiffBoyBrickDropGame:winCleared()
self.phase=am
self.bonus=bt*(self.startLevel+self.garbageHeight+1)
self.tally=0
self.wonHold=bA
self.sequencer:stop()
self.sequencer:play(b.CLEARED)
end

function SpiffBoyBrickDropGame:winEscaped()
self.sequencer:stop()
local f=self.camp:stage()
if f==0 then
self.phase=aO
self.finaleTick=0
self.camp:startOverrun()
return
end
local v=G.FOOT
if f>=#aw.PROJECTS then
v=G.RADIO
elseif f>=2 then
v=G.TRUCK
end
self.mode=aj
self.escape=G.new(v,self.sequencer,self.context.art,self.score)
end

function SpiffBoyBrickDropGame:tickRun(input)
if self.quake>0 then
self.quake=self.quake-1
end
if self.levelBlink>0 then
self.levelBlink=self.levelBlink-1
end
if self.modeKey=="a"and not self.paused then
self.camp:tick()
end
if self.phase==B then
self:tickFall(input)
elseif self.phase==ak then
self:keepTrack(self:inDanger())
self.clearTimer=self.clearTimer-1
if self.clearTimer<=0 then
self:finishClear()
end
elseif self.phase==al then
self:tickCurtain()
elseif self.phase==N then
self.overTimer=self.overTimer-1
if self.overTimer<=0 and not self.sequencer:isPlaying()and(self.modeKey~="a"or self.camp:overrunDone())then
self:afterGameOver()
end
elseif self.phase==aO then
self:tickFinale(input)
else
self:tickWon()
end
end

function SpiffBoyBrickDropGame:tickFinale(input)
self.finaleTick=self.finaleTick+1
local f=input and self.finaleTick>cm and(input.pressed.a or input.pressed.start)
if f or self.camp:overrunDone()then
self:offerRecord()
end
end

function SpiffBoyBrickDropGame:inDanger()
return self.well:top()<bu
end

function SpiffBoyBrickDropGame:tickFall(input)
self:keepTrack(self:inDanger())
if input and input.pressed.start then
self.paused=not self.paused
self.sequencer:effect(b.CONFIRM)
end
if self.paused then
return
end
if input then
self:control(input)
if self.phase~=B then
return
end
end
local f=input and input.held.down and not self.softBlocked
if f then
self.dropTimer=math.min(self.dropTimer,bn)
end
self.dropTimer=self.dropTimer-1
if self.dropTimer<=0 then
self.dropTimer=a3(self.level)
if self:fall()and f then
self.score=self.score+1
end
end
end

function SpiffBoyBrickDropGame:control(input)
local x,f=input.held,input.pressed
if not x.down then
self.softBlocked=false
end
local v=0
if x.left then
v=-1
elseif x.right then
v=1
end
if f.left or f.right then
self:shift(v)
self.repeatTimer=bo
elseif v~=0 then
self.repeatTimer=self.repeatTimer-1
if self.repeatTimer<=0 then
self:shift(v)
self.repeatTimer=bp
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
self.curtainTimer=aM
self.curtainRow=self.curtainRow-1
if self.curtainRow<=0 then
self.curtainRow=0
self.phase=N
self.overTimer=by
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
if i.rankOf(f,a6(self.modeKey),self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.sequencer:stop()
self.mode=aN
return
end
self:openSetup()
end

function SpiffBoyBrickDropGame:tickWon()
if self.tally<L then
self.tally=self.tally+1
if self.tally%bz==0 then
self.sequencer:effect(b.COUNT)
end
if self.tally==L then
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
if self.phase~=am or self.tally>=L then
return 0
end
return math.floor(self.bonus*self.tally/L)
end

function SpiffBoyBrickDropGame:turnLetter(step)
local f=self.cursor
self.letters[f]=l(self.letters[f]-step,cc)
self.sequencer:effect(b.TICK)
end

function SpiffBoyBrickDropGame:repeatLetter(pressedStep,heldStep)
if pressedStep~=0 then
self:turnLetter(pressedStep)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=cf
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
self.letterRepeatTimer=math.max(ch,cg-math.floor(self.letterHoldTicks/ci))
end
end

function SpiffBoyBrickDropGame:tickInitials(input)
if not input then
return
end
local f=input.pressed
local v=self.cursor
self:repeatLetter(u(f),u(input.held))
if f.left and v>1 then
self.cursor=v-1
elseif f.right and v<S then
self.cursor=v+1
end
if f.a or f.start then
self.sequencer:effect(b.CONFIRM)
if self.cursor<S then
self.cursor=self.cursor+1
else
self:saveScore()
end
end
end

function SpiffBoyBrickDropGame:saveScore()
local f=""
for v=1,S do
f=f..a5(self.letters[v])
end
local x=i.ensureList(self.records,self.modeKey,self.startLevel,self.garbageHeight)
local v=i.insert(x,a6(self.modeKey),f,self.score)
self:persistRecords()
self:showScores(self.setup.mode,v)
self:flashRank(v)
end

function SpiffBoyBrickDropGame:blinkOn()
return math.floor(self.clock/a1)%2==0
end

function SpiffBoyBrickDropGame:bob()
return math.floor(self.clock/bP)%2
end

function SpiffBoyBrickDropGame:draw(screen)
if self.mode==p then
self:drawTitle(screen)
elseif self.mode==af then
self:drawSetup(screen)
elseif self.mode==M then
self:drawOptions(screen)
elseif self.mode==ag then
self:drawConfirm(screen)
elseif self.mode==ah then
self:drawScores(screen)
elseif self.mode==ai then
self:drawRun(screen)
elseif self.mode==aj then
self.escape:draw(screen)
else
self:drawInitials(screen)
end
end

function SpiffBoyBrickDropGame:drawBlock(screen,frame,x,y)
screen:layers(self.blocks,(frame-1)*a,a,a,x,y,aa[frame])
end

function SpiffBoyBrickDropGame:drawCells(screen,frame,x,y,count)
while count>0 do
local f=math.min(count,z)
screen:layers(self.runs,(frame-1)*z*a,f*a,a,x,y,aa[frame])
x=x+f*a
count=count-f
end
end

function SpiffBoyBrickDropGame:drawBricks(screen,x,y,course,count)
local f=ax
if course%2==1 then
f=be
end
self:drawCells(screen,f,x,y,count)
end

local function a7(cells,x,y)
for f=1,4 do
if cells[f][1]==x and cells[f][2]==y then
return true
end
end
return false
end

function SpiffBoyBrickDropGame:drawPiece(screen,frame,kind,rotation,x,y,top)
local f=m.cells(kind,rotation)
for a8=1,4 do
local V,W=f[a8][1],f[a8][2]
local a9=y+W*a
if a9>=top and not a7(f,V-1,W)then
local v=1
while a7(f,V+v,W)do
v=v+1
end
self:drawCells(screen,frame,x+V*a,a9,v)
end
end
end

function SpiffBoyBrickDropGame:drawPieceInBox(screen,kind,centreX,boxY)
local f,x,v,y=cr(kind)
local V=(x-f+1)*a
local W=(y-v+1)*a
local a8=centreX-math.floor(V/2)-f*a
local a9=boxY+math.floor((ae-W)/2)-v*a
self:drawPiece(screen,kind,kind,1,a8,a9,0)
end

local function a8(screen,centreX,y)
local f=centreX-math.floor(ad/2)
r(screen,f-1,y-1,ad+2,ae+2)
screen:rect(f,y,ad,ae,e.r,e.g,e.b,1)
end

function SpiffBoyBrickDropGame:drawBrickFrame(screen)
au(screen)
screen:layers(self.frameBricks,0,h,X,0,0,aA)
end

function SpiffBoyBrickDropGame:drawCursor(screen,right,y)
local f=screen:lineHeight()
self:drawBlock(screen,2,right-a-self:bob(),y+math.floor((f-a)/2))
end

function SpiffBoyBrickDropGame:drawWallRow(screen,x,y,course,filled)
local a9=course%2
for v=0,#filled-1,z do
local f,V=0,1
for W=v+1,math.min(v+z,#filled)do
if filled[W]then
f=f+V
end
V=V*2
end
if f>0 then
for W=1,#ac do
local ba=a9*#ac+W-1
screen:sheet(self.wallRows,f%A*K,ba*ay+math.floor(f/A)*a,K,a,x+v*a,y,1,ac[W])
end
end
end
end

function SpiffBoyBrickDropGame:drawTitle(screen)
au(screen)
screen:layers(self.skyline,0,bJ,aQ,0,ap-aQ,bK)
self.wall:draw(0,ap,function(x,y,course,filled)
self:drawWallRow(screen,x,y,course,filled)
end,function(x,y,course)
self:drawBricks(screen,x,y,course,1)
end)
for f=1,#q do
local v=D
if not self.introDone then
v=math.floor(av(f,self.introTick))
end
screen:layers(self.logo,q[f],bF,ao,bD+q[f],v,bE)
end
if not self.introDone then
return
end
local v=h/2
for f=1,#P do
local x=c(P[f])
local y=bN+(f-1)*bO
local V=screen:textWidth(x)
local W=v-math.floor(V/2)
co(screen,x,v,y)
if f==self.menuIndex then
self:drawCursor(screen,W-aq,y)
end
end
end

function SpiffBoyBrickDropGame:drawMenuRow(screen,label,value,labelX,right,y,chosen)
F(screen,label,labelX,y)
if value then
U(screen,value,right,y)
end
if chosen then
self:drawCursor(screen,labelX-aq,y)
end
end

function SpiffBoyBrickDropGame:setupValue(key)
local f=self.setup
if key=="mode"then
return c(j[f.mode].text)
elseif key=="level"then
return tostring(f.level)
elseif key=="height"then
return tostring(f.height)
end
return c(O[f.music])
end

function SpiffBoyBrickDropGame:drawRecordRows(screen,list,first,last,top)
local f=h/2
local a9=screen:lineHeight()
for v=first,last do
local ba=list[v]
local x=top+(v-first)*a9
local y,V,W=g.r,g.g,g.b
if self.mode==ah and self:isRankInverted(v)then
r(screen,f+a_,x,b7-a_,a9)
y,V,W=e.r,e.g,e.b
end
screen:textRight(tostring(v)..".",f+b4,x,y,V,W,1)
screen:text(ba.initials,f+b5,x,y,V,W,1)
screen:textRight(tostring(ba.score),f+b6,x,y,V,W,1)
end
end

local function ba(screen,value,y)
U(screen,"<",aT-screen:textWidth(value)-bT,y)
U(screen,">",bS,y)
end

function SpiffBoyBrickDropGame:drawSetup(screen)
self:drawBrickFrame(screen)
local f=bQ
for v=1,#C do
if self:setupRowShown(v)then
local x=C[v]
local y=self:setupValue(x.key)
local V=v==self.setupIndex
self:drawMenuRow(screen,c(x.text),y,Q,aT,f,V)
if V then
ba(screen,y,f)
end
f=f+bR
end
end
r(screen,Q,bU,aS-Q,1)
local v=self:currentRecords()
if#v==0 then
d(screen,c("NoScores"),h/2,aU+screen:lineHeight())
return
end
self:drawRecordRows(screen,v,1,math.min(#v,bV),aU)
end

local function cs(screen,x,y,value)
local f=k*ar+(k-1)*aV
r(screen,x-1,y-1,f+2,as+2)
screen:rect(x,y,f,as,e.r,e.g,e.b,1)
for v=1,value do
r(screen,x+(v-1)*(ar+aV),y,ar,as)
end
end

function SpiffBoyBrickDropGame:drawOptions(screen)
self:drawBrickFrame(screen)
d(screen,c("Options"),h/2,bW)
for f=1,#t do
local v=t[f]
local x=bX+(f-1)*bY
self:drawMenuRow(screen,c(v.text),nil,Q,aS,x,f==self.optionIndex)
if v.key then
cs(screen,bZ,x+b_,self.mix[v.key])
end
end
end

function SpiffBoyBrickDropGame:drawConfirm(screen)
self:drawBrickFrame(screen)
local v=h/2
local W=screen:lineHeight()
local x=screen:wrapText(c(an[self.confirmKind].text),b1)
for f=1,#x do
d(screen,x[f],v,b0+(f-1)*W)
end
local y={{text="No",x=v-aX,chosen=not self.confirmYes},{text="Yes",x=v+aX,chosen=self.confirmYes}}
for a9=1,#y do
local f=y[a9]
local V=c(f.text)
d(screen,V,f.x,aW)
if f.chosen then
self:drawCursor(screen,f.x-math.floor(screen:textWidth(V)/2)-aq,aW)
end
end
end

function SpiffBoyBrickDropGame:drawScores(screen)
self:drawBrickFrame(screen)
local f=h/2
local V=screen:lineHeight()
local v=self.scoresPage
d(screen,c(j[v].text),f,E)
F(screen,"<",aY,E)
U(screen,">",h-aY,E)
if j[v].key=="b"then
local x=c("Level",self.setup.level).."  "..c("Height").." "..tostring(self.setup.height)
d(screen,x,f,E+V)
end
local x=self:pageRecords(v)
local y,W=self:scoresRows(v)
if#x==0 then
d(screen,c("NoScores"),f,y+V)
return
end
local a9=math.min(#x,self.scoresTop+W-1)
self:drawRecordRows(screen,x,self.scoresTop,a9,y)
if self.scoresTop>1 then
F(screen,b9,f+aZ,y)
end
if a9<#x then
F(screen,ca,f+aZ,y+(W-1)*V)
end
end

function SpiffBoyBrickDropGame:drawInitials(screen)
self:drawBrickFrame(screen)
local v=h/2
local x=screen:lineHeight()
local f=10
d(screen,c("NewHighScore"),v,f)
f=f+x*1.5
d(screen,tostring(self.score),v,f)
f=f+x*1.5
d(screen,c("EnterInitials"),v,f)
f=f+x*1.5
for y=1,S do
local V=v+(y-2)*cd
d(screen,a5(self.letters[y]),V,f)
if y==self.cursor and self:blinkOn()then
r(screen,V-a2/2,f+x+1,a2,ce)
end
end
end

local function V(screen,label,centreX,centreY)
local W=screen:lineHeight()
local f=screen:textWidth(label)+R*2
local v=W+R*2
local x=math.floor(centreX-f/2)
local y=math.floor(centreY-v/2)
r(screen,x-1,y-1,f+2,v+2)
screen:rect(x,y,f,v,e.r,e.g,e.b,1)
F(screen,label,x+R,y+R)
end

function SpiffBoyBrickDropGame:drawWellBricks(screen)
screen:layers(self.wellBricks,0,aB,X,I,0,aA)
end

function SpiffBoyBrickDropGame:rowHidden(row)
if self.phase~=ak or not self.clearRows[row]then
return false
end
return math.floor(self.clearTimer/aL)%2==1
end

function SpiffBoyBrickDropGame:drawRowLayers(screen,masks,x,y)
for f=1,#ab do
local v=masks[f]
if v then
screen:sheet(self.rows,v%A*K,(f-1)*ay+math.floor(v/A)*a,K,a,x,y,1,ab[f])
end
end
end

local y={}

local function ct()
for f=1,#ab do
y[f]=nil
end
return y
end

function SpiffBoyBrickDropGame:drawWellRow(screen,row,left)
local f=ct()
local v=1
for cu=0,n-1 do
local W=self.well:at(cu,row)
if W~=m.EMPTY then
local x=az[W]
for a9=1,#x do
f[x[a9]]=(f[x[a9]]or 0)+v
end
end
v=v*2
end
self:drawRowLayers(screen,f,left,o+row*a)
end

function SpiffBoyBrickDropGame:drawWellContent(screen,offset)
local v=w+offset
local x=self.phase==al or self.phase==N
local W=s-1
if x then
W=self.curtainRow-1
end
for f=0,W do
if not self:rowHidden(f)then
self:drawWellRow(screen,f,v)
end
end
if self.phase==B then
local f=self.piece
local a9=self.well:landing(f.kind,f.rotation,f.x,f.y)
if a9>f.y then
self:drawPiece(screen,bd,f.kind,f.rotation,v+f.x*a,o+a9*a,o)
end
self:drawPiece(screen,f.kind,f.kind,f.rotation,v+f.x*a,o+f.y*a,0)
end
if x then
for f=self.curtainRow,s-1 do
self:drawRowLayers(screen,bf,v,o+f*a)
end
end
end

function SpiffBoyBrickDropGame:drawCounters(screen)
local f=bg
d(screen,c("Score"),f,bi)
d(screen,tostring(self.score+self:countedBonus()),f,bj)
if self.levelBlink==0 or self:blinkFast()then
d(screen,c("Level",self.level),f,bk)
end
if self.modeKey=="b"then
d(screen,c("LinesLeft"),f,aC)
d(screen,tostring(self:linesLeft()),f,aD)
else
d(screen,c("Lines"),f,aC)
d(screen,tostring(self.lines),f,aD)
end
end

function SpiffBoyBrickDropGame:blinkFast()
return math.floor(self.clock/(a1/3))%2==0
end

function SpiffBoyBrickDropGame:drawBoxes(screen)
local f=bh
d(screen,c("Next"),f,bl)
a8(screen,f,aE)
if not self.paused then
self:drawPieceInBox(screen,self.nextKind,f,aE)
end
d(screen,c("Hold"),f,bm)
a8(screen,f,aF)
if self.holdKind and not self.paused then
self:drawPieceInBox(screen,self.holdKind,f,aF)
end
end

function SpiffBoyBrickDropGame:drawRun(screen)
au(screen)
if self.modeKey=="a"then
self.camp:draw(screen,self.clock)
end
screen:rect(w,0,n*a,Y,H.r,H.g,H.b,1)
local x=0
if self.quake>0 then
x=(math.floor(self.quake/2)%2)*2-1
end
if not self.paused then
self:drawWellContent(screen,x)
end
self:drawWellBricks(screen)
self:drawCounters(screen)
self:drawBoxes(screen)
local f=w+n*a/2
local v=o+s*a/2
if self.paused then
V(screen,getText("UI_SpiffBoy_Paused"),f,v)
elseif self.phase==N then
V(screen,c("GameOver"),f,v)
elseif self.phase==am then
V(screen,c("Cleared"),f,v)
end
end
