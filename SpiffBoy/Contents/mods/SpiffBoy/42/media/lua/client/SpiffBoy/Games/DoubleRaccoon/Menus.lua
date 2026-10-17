require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/DoubleRaccoon/Stage"
require"SpiffBoy/Games/DoubleRaccoon/Records"
require"SpiffBoy/Games/DoubleRaccoon/Music"

local a=SpiffBoyDoubleRaccoonGame
local F=SpiffBoy.DoubleRaccoon
local r=F.Stage
local p=F.Records
local d=F.Music

local b=SpiffBoy.Cartridges.SHADES[4]
local f=SpiffBoy.Cartridges.SHADES[1]
local G=SpiffBoy.Cartridges.SHADES[2]
local h=SpiffBoy.Cartridges.SCREEN_WIDTH
local I=SpiffBoy.Cartridges.SCREEN_HEIGHT
local i=a.gameText
local s=d.MIX_STEPS
local m={1,2,3,4}

local A={"Play","HighScores","Options"}
local u={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local c={scroll=3,loop=600,panelX=8,panelY=4,panelW=164,panelH=42,headX=13,headY=12,logoX=65,logoY=8,logoW=85,logoH=34,barY=84,menuY=82,menuStep=12,spiffoX=34,zombieX=146,feetY=80}
local v={width=9,height=8,gap=6,top=4}
local J=26
local g={width=52,height=50,anchor=26,idle=0,zombieFacingLeft=9}
local Q={spiffoX=-14,spiffoY=-6,spiffoWidth=104,spiffoHeight=100,boxLeft=74,boxTop=4,boxHeight=35,rowStep=38,iconX=78,iconY=8,iconWidth=24,iconHeight=14,textX=104,nameY=2,bestY=18}
local n={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=50}
local K={titleY=4,firstY=28,step=24,labelX=22,barX=96,barCell=5,barGap=1,barHeight=8,barTop=4}
local B={y=30,width=150,choicesY=80,gap=32}
local j={titleY=4,arrowX=12,listY=26,bottom=116}
local w={titleY=18,countY=44,choicesY=82,gap=32,step=60}
local l={titleY=10,scoreY=34,promptY=58,lettersY=82,spacing=20,cursorWidth=12,cursorHeight=2}
local H={ticks=15,count=4}
local R=30
local L="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local S=62
local C={delay=24,start=8,min=2,speedup=30}
local T=string.char(0x25B4)
local U=string.char(0x25BE)

local function x(k,e)
return(k-1+e)%e+1
end

local function t(e)
if e.up then
return-1
elseif e.down then
return 1
end
return 0
end

local function M(e)
if e.left then
return-1
elseif e.right then
return 1
end
return 0
end

local function y(e)
e:clear(f.r,f.g,f.b)
end

local function D(e,k,o,q)
e:text(k,o,q,b.r,b.g,b.b,1)
end

local function k(e,o,q,z)
e:textCentre(o,q,z,b.r,b.g,b.b,1)
end

local function V(e,o,q,z)
e:textRight(o,q,z,b.r,b.g,b.b,1)
end

function a:readChoices()
self.setup={difficulty=2}
local e=self.save.setup
if type(e)=="table"and SpiffBoy.isInteger(e.difficulty)and e.difficulty>=1 and e.difficulty<=#r.DIFFICULTIES then
self.setup.difficulty=e.difficulty
end
self.mix={music=s,effects=s}
local z=self.save.options
if type(z)=="table"then
for E,q in ipairs(u)do
local o=q.key and z[q.key]
if SpiffBoy.isInteger(o)and o>=0 and o<=s then
self.mix[q.key]=o
end
end
end
self.mixDirty=false
self.setupDirty=false
self:applyMix()
end

function a:openTitle()
self.mode=a.MODE_TITLE
self.menuIndex=1
self.sequencer:stop()
end

function a:tickMenu(e)
local o=self.mode
if o~=a.MODE_CONTINUE then
self:keepMusic(d.TITLE)
end
if not e then
if o==a.MODE_CONTINUE then
self:tickContinue(nil)
end
return
end
if o==a.MODE_TITLE then
self:tickTitle(e)
elseif o==a.MODE_SETUP then
self:tickSetup(e)
elseif o==a.MODE_OPTIONS then
self:tickOptions(e)
elseif o==a.MODE_CONFIRM then
self:tickConfirm(e)
elseif o==a.MODE_SCORES then
self:tickScores(e)
elseif o==a.MODE_CONTINUE then
self:tickContinue(e)
else
self:tickInitials(e)
end
end

function a:tickTitle(z)
local e=z.pressed
local o=t(e)
if o~=0 then
self.menuIndex=x(self.menuIndex+o,#A)
self:effect(d.TICK)
end
if e.a or e.start then
self:effect(d.CONFIRM)
local q=A[self.menuIndex]
if q=="Play"then
self.mode=a.MODE_SETUP
elseif q=="Options"then
self.mode=a.MODE_OPTIONS
self.optionIndex=1
else
self:showScores(self.setup.difficulty,1)
end
end
end

function a:saveSetup()
if self.setupDirty then
self.save.setup={difficulty=self.setup.difficulty}
self:persist()
self.setupDirty=false
end
end

function a:tickSetup(q)
local e=q.pressed
local o=t(e)
if o~=0 then
self.setup.difficulty=x(self.setup.difficulty+o,#r.DIFFICULTIES)
self.setupDirty=true
self:effect(d.TICK)
end
if e.a or e.start then
self:saveSetup()
self:startRun()
elseif e.b then
self:saveSetup()
self:effect(d.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:closeOptions()
if self.mixDirty then
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
self.mixDirty=false
end
self.mode=a.MODE_TITLE
end

function a:tickOptions(N)
local e=N.pressed
local z=t(e)
if z~=0 then
self.optionIndex=x(self.optionIndex+z,#u)
self:effect(d.TICK)
end
local o=u[self.optionIndex]
local E=M(e)
if E~=0 and o.key then
local q=SpiffBoy.clamp(self.mix[o.key]+E,0,s)
if q~=self.mix[o.key]then
self.mix[o.key]=q
self.mixDirty=true
self:applyMix()
self:effect(d.STEP..q)
end
end
if e.b or e.start then
self:effect(d.CONFIRM)
self:closeOptions()
elseif e.a then
self:effect(d.CONFIRM)
if o.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(o)
local e=o.pressed
if e.left or e.right or e.up or e.down then
self.confirmYes=not self.confirmYes
self:effect(d.TICK)
end
if e.b then
self:effect(d.CONFIRM)
self.mode=a.MODE_OPTIONS
elseif e.a or e.start then
self:effect(d.CONFIRM)
if self.confirmYes then
self.records=p.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self.mode=a.MODE_OPTIONS
end
end

function a:pageRecords(e)
return self.records[r.DIFFICULTIES[e].key]
end

function a:scoresVisible()
return math.floor((j.bottom-j.listY)/self.screen:lineHeight())
end

function a:showScores(e,o)
self.mode=a.MODE_SCORES
self.scoresPage=e
self.scoresTop=SpiffBoy.clamp(o,1,#self:pageRecords(e)-self:scoresVisible()+1)
end

function a:tickScores(E)
local e=E.pressed
local o=t(e)
local q=M(e)
if o~=0 then
local z=SpiffBoy.clamp(self.scoresTop+o,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if z~=self.scoresTop then
self.scoresTop=z
self:effect(d.TICK)
end
elseif q~=0 then
self.flashRankIndex=nil
self:showScores(x(self.scoresPage+q,#r.DIFFICULTIES),1)
self:effect(d.TICK)
elseif e.a or e.b or e.start then
self:effect(d.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:tickContinue(o)
if o then
local e=o.pressed
if e.left or e.right or e.up or e.down then
self.continueYes=not self.continueYes
self:effect(d.TICK)
end
if e.a or e.start then
self:effect(d.CONFIRM)
if self.continueYes then
self:continueRun()
else
self:gameOver()
end
return
end
end
self.continueTimer=self.continueTimer-1
if self.continueTimer>0 then
return
end
self.continueTimer=w.step
self.continueCount=self.continueCount-1
if self.continueCount<0 then
self:gameOver()
return
end
self:effect(d.COUNT)
end

function a:offerRecord()
self.sequencer:stop()
if p.rankOf(self.records[self.difficultyKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self.mode=a.MODE_SETUP
end

function a:turnLetter(e)
self.letters[self.cursor]=x(self.letters[self.cursor]-e,S)
self:effect(d.TICK)
end

function a:repeatLetter(e,o)
if e~=0 then
self:turnLetter(e)
self.letterHoldStep=e
self.letterHoldTicks=0
self.letterRepeatTimer=C.delay
return
end
if o==0 or o~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(o)
self.letterRepeatTimer=math.max(C.min,C.start-math.floor(self.letterHoldTicks/C.speedup))
end
end

function a:tickInitials(q)
local e=q.pressed
self:repeatLetter(t(e),t(q.held))
if e.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif e.right and self.cursor<p.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if e.a or e.start then
self:effect(d.CONFIRM)
if self.cursor<p.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local o=""
for z=1,p.INITIALS_LENGTH do
o=o..string.sub(L,self.letters[z],self.letters[z])
end
local z=p.insert(self.records[self.difficultyKey],o,self.score)
self:persistRecords()
self:showScores(self.setup.difficulty,z)
self.flashRankIndex=z
self.flashUntil=self.clock+H.ticks*H.count*2
end
end
end

function a:drawMenu(e)
local o=self.mode
if o==a.MODE_TITLE then
self:drawTitle(e)
elseif o==a.MODE_SETUP then
self:drawSetup(e)
elseif o==a.MODE_OPTIONS then
self:drawOptions(e)
elseif o==a.MODE_CONFIRM then
self:drawConfirm(e)
elseif o==a.MODE_SCORES then
self:drawScores(e)
elseif o==a.MODE_CONTINUE then
self:drawContinue(e)
else
self:drawInitials(e)
end
end

function a:drawPointer(e,o,q)
e:layers(self.hudHead,0,v.width,v.height,o-v.width-v.gap,q+v.top,m)
end

function a:drawTitle(e)
e:clear(b.r,b.g,b.b)
self.sceneries[1]:drawBack(e,math.floor(self.clock/c.scroll)%c.loop)
e:layers(self.spiffo,g.idle*g.width,g.width,g.height,c.spiffoX-g.anchor,c.feetY-g.height+1,m)
e:layers(self.zombieSheets.shambler,g.zombieFacingLeft*g.width,g.width,g.height,c.zombieX-g.anchor,c.feetY-g.height+1,m)
e:rect(c.panelX-1,c.panelY-1,c.panelW+2,c.panelH+2,f.r,f.g,f.b,1)
e:rect(c.panelX,c.panelY,c.panelW,c.panelH,b.r,b.g,b.b,1)
e:layers(self.titleHead,0,J,J,c.headX,c.headY,m)
e:layers(self.logo,0,c.logoW,c.logoH,c.logoX,c.logoY,m)
e:rect(0,c.barY,h,I-c.barY,f.r,f.g,f.b,1)
local q=h/2
for o=1,#A do
local z=i(A[o])
local E=c.menuY+(o-1)*c.menuStep
k(e,z,q,E)
if o==self.menuIndex then
self:drawPointer(e,q-math.floor(e:textWidth(z)/2),E)
end
end
end

function a:drawRecordRows(o,W,N,X,Y)
local q=h/2
local O=o:lineHeight()
for z=N,X do
local P=W[z]
local E=Y+(z-N)*O
local e=b
local Z=self.mode==a.MODE_SCORES and z==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if Z and math.floor((self.flashUntil-self.clock-1)/H.ticks)%2==1 then
o:rect(q+n.left,E,n.right-n.left,O,b.r,b.g,b.b,1)
e=f
end
o:textRight(tostring(z)..".",q+n.rank,E,e.r,e.g,e.b,1)
o:text(P.initials,q+n.initials,E,e.r,e.g,e.b,1)
o:textRight(tostring(P.score),q+n.score,E,e.r,e.g,e.b,1)
end
end

function a:drawSetup(o)
local e=Q
o:layers(self.selectStage,0,h,I,0,0,m)
o:layers(self.selectSpiffo,(self.setup.difficulty-1)*e.spiffoWidth,e.spiffoWidth,e.spiffoHeight,e.spiffoX,e.spiffoY,m)
local N=h-e.boxLeft
for E,O in ipairs(r.DIFFICULTIES)do
local z=e.boxTop+(E-1)*e.rowStep
local q=f
o:rect(e.boxLeft,z,N,e.boxHeight,b.r,b.g,b.b,1)
if E~=self.setup.difficulty then
o:rect(e.boxLeft+1,z+1,N-2,e.boxHeight-2,G.r,G.g,G.b,1)
q=b
end
o:layers(self.headbands,(E-1)*e.iconWidth,e.iconWidth,e.iconHeight,e.iconX,z+e.iconY,m)
local P=self.records[O.key]
local W=#P>0 and P[1].score or 0
o:text(i(O.text),e.textX,z+e.nameY,q.r,q.g,q.b,1)
o:text(tostring(W),e.textX,z+e.bestY,q.r,q.g,q.b,1)
end
end

local function W(o,q,z,N)
local e=K
local E=s*e.barCell+(s-1)*e.barGap
o:rect(q-1,z-1,E+2,e.barHeight+2,b.r,b.g,b.b,1)
o:rect(q,z,E,e.barHeight,f.r,f.g,f.b,1)
for O=1,N do
o:rect(q+(O-1)*(e.barCell+e.barGap),z,e.barCell,e.barHeight,b.r,b.g,b.b,1)
end
end

function a:drawOptions(o)
y(o)
local e=K
k(o,i("Options"),h/2,e.titleY)
for q=1,#u do
local z=u[q]
local E=e.firstY+(q-1)*e.step
D(o,i(z.text),e.labelX,E)
if z.key then
W(o,e.barX,E+e.barTop,self.mix[z.key])
end
if q==self.optionIndex then
self:drawPointer(o,e.labelX,E)
end
end
end

function a:drawQuestion(e,X,Y,z,E,N)
local q=h/2
local O=e:wrapText(X,B.width)
for o=1,#O do
k(e,O[o],q,Y+(o-1)*e:lineHeight())
end
local Z={{text="Yes",x=q-E,chosen=N},{text="No",x=q+E,chosen=not N}}
for _,o in ipairs(Z)do
local P=i(o.text)
k(e,P,o.x,z)
if o.chosen then
self:drawPointer(e,o.x-math.floor(e:textWidth(P)/2),z)
end
end
end

function a:drawConfirm(e)
y(e)
self:drawQuestion(e,i("EraseScores"),B.y,B.choicesY,B.gap,self.confirmYes)
end

function a:drawContinue(e)
y(e)
self:drawQuestion(e,i("Continue"),w.titleY,w.choicesY,w.gap,self.continueYes)
k(e,tostring(math.max(0,self.continueCount)),h/2,w.countY)
end

function a:drawScores(e)
y(e)
local o=h/2
local z=e:lineHeight()
local E=self.scoresPage
k(e,i(r.DIFFICULTIES[E].text),o,j.titleY)
D(e,"<",j.arrowX,j.titleY)
V(e,">",h-j.arrowX,j.titleY)
local q=self:pageRecords(E)
if#q==0 then
k(e,i("NoScores"),o,j.listY+z)
return
end
local N=self:scoresVisible()
local O=math.min(#q,self.scoresTop+N-1)
self:drawRecordRows(e,q,self.scoresTop,O,j.listY)
if self.scoresTop>1 then
D(e,T,o+n.arrow,j.listY)
end
if O<#q then
D(e,U,o+n.arrow,j.listY+(N-1)*z)
end
end

function a:drawInitials(e)
y(e)
local o=h/2
local E=e:lineHeight()
k(e,i("NewHighScore"),o,l.titleY)
k(e,tostring(self.score),o,l.scoreY)
k(e,i("EnterInitials"),o,l.promptY)
for q=1,p.INITIALS_LENGTH do
local z=o+(q-2)*l.spacing
k(e,string.sub(L,self.letters[q],self.letters[q]),z,l.lettersY)
if q==self.cursor and math.floor(self.clock/R)%2==0 then
e:rect(z-l.cursorWidth/2,l.lettersY+E+1,l.cursorWidth,l.cursorHeight,b.r,b.g,b.b,1)
end
end
end
