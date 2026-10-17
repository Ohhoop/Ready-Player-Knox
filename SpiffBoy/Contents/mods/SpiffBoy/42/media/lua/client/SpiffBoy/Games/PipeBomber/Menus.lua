require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Records"
require"SpiffBoy/Games/PipeBomber/Music"

local a=SpiffBoyPipeBomberGame
local H=SpiffBoy.PipeBomber
local i=H.Zones
local q=H.Records
local c=H.Music

local r=SpiffBoy.Cartridges.SHADES[4]
local b=SpiffBoy.Cartridges.SHADES[1]
local I=SpiffBoy.Cartridges.SHADES[3]
local j=SpiffBoy.Cartridges.SCREEN_WIDTH
local S=SpiffBoy.Cartridges.SCREEN_HEIGHT
local d=a.gameText
local u=c.MIX_STEPS
local w={1,2,3,4}
local T={1,3}

local z={"Play","Password","HighScores","Options"}
local x={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local f={logoX=22,logoY=8,logoW=78,logoH=38,bombX=130,bombY=12,bombW=20,bombH=25,menuY=50,menuStep=13,chaseY=98,chaseSpeed=2,chaseLoop=260,chaseGap=18}
local s={size=12,gap=4,top=1,blink=10}
local k={survivorRight=6,zombieRight=0,zombieKinds={"shambler","runner"},size=16,cycle=8}
local e={labelX=14,valueRight=160,arrowRight=168,arrowGap=2,rowY=10,zoneY=28,ruleY=48,scoresY=52,shown=3}
local p={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=50}
local L={titleY=8,firstY=32,step=24,labelX=26,barX=100,barCell=5,barGap=1,barHeight=8,barTop=4}
local A={y=26,width=150,choicesY=76,gap=32}
local l={titleY=8,arrowX=14,listY=28,bottom=112}
local B={titleY=18,countY=44,choicesY=78,gap=32}
local n={titleY=10,scoreY=32,promptY=54,lettersY=78,spacing=20,cursorWidth=12,cursorHeight=2}
local h={titleY=14,boxY=46,boxW=20,boxH=22,spacing=26,letterY=48,cursorY=64,errorY=86,errorTicks=120}
local J={ticks=15,count=4}
local M=30
local N="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local U=62
local O="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local V=26
local C={delay=24,start=8,min=2,speedup=30}
local W=string.char(0x25B4)
local X=string.char(0x25BE)

local function v(m,g)
return(m-1+g)%g+1
end

local function t(g)
if g.up then
return-1
elseif g.down then
return 1
end
return 0
end

local function K(g)
if g.left then
return-1
elseif g.right then
return 1
end
return 0
end

local function y(g,m,o,D)
g:text(m,o,D,b.r,b.g,b.b,1)
end

local function g(m,o,D,E)
m:textCentre(o,D,E,b.r,b.g,b.b,1)
end

local function D(m,o,E,F)
m:textRight(o,E,F,b.r,b.g,b.b,1)
end

function a:readChoices()
self.setup={difficulty=2}
local m=self.save.setup
if type(m)=="table"and SpiffBoy.isInteger(m.difficulty)and m.difficulty>=1 and m.difficulty<=#i.DIFFICULTIES then
self.setup.difficulty=m.difficulty
end
self.mix={music=u,effects=u}
local F=self.save.options
if type(F)=="table"then
for G,E in ipairs(x)do
local o=E.key and F[E.key]
if SpiffBoy.isInteger(o)and o>=0 and o<=u then
self.mix[E.key]=o
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

function a:tickMenu(m)
local o=self.mode
if o~=a.MODE_CONTINUE then
self:keepMusic(c.TITLE)
end
if self.passwordError and self.passwordError>0 then
self.passwordError=self.passwordError-1
end
if not m then
if o==a.MODE_CONTINUE then
self:tickContinue(nil)
end
return
end
if o==a.MODE_TITLE then
self:tickTitle(m)
elseif o==a.MODE_SETUP then
self:tickSetup(m)
elseif o==a.MODE_PASSWORD then
self:tickPassword(m)
elseif o==a.MODE_OPTIONS then
self:tickOptions(m)
elseif o==a.MODE_CONFIRM then
self:tickConfirm(m)
elseif o==a.MODE_SCORES then
self:tickScores(m)
elseif o==a.MODE_CONTINUE then
self:tickContinue(m)
else
self:tickInitials(m)
end
end

function a:tickTitle(F)
local m=F.pressed
local E=t(m)
if E~=0 then
self.menuIndex=v(self.menuIndex+E,#z)
self:effect(c.TICK)
end
if m.a or m.start then
self:effect(c.CONFIRM)
local o=z[self.menuIndex]
if o=="Play"then
self.startZone=1
self.mode=a.MODE_SETUP
elseif o=="Password"then
self:openPassword()
elseif o=="Options"then
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

function a:tickSetup(E)
local m=E.pressed
local o=K(m)
if o~=0 then
self.setup.difficulty=v(self.setup.difficulty+o,#i.DIFFICULTIES)
self.setupDirty=true
self:effect(c.TICK)
end
if m.a or m.start then
self:saveSetup()
self:startRun()
elseif m.b then
self:saveSetup()
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:openPassword()
self.mode=a.MODE_PASSWORD
self.code={}
for m=1,i.PASSWORD_LENGTH do
self.code[m]=1
end
self.codeCursor=1
self.letterHoldStep=0
self.passwordError=0
end

function a:codeText()
local m=""
for o=1,i.PASSWORD_LENGTH do
m=m..string.sub(O,self.code[o],self.code[o])
end
return m
end

function a:tickPassword(E)
local m=E.pressed
self:repeatLetter(t(m),t(E.held),function(o)
self.code[self.codeCursor]=v(self.code[self.codeCursor]-o,V)
end)
if m.left and self.codeCursor>1 then
self.codeCursor=self.codeCursor-1
elseif m.right and self.codeCursor<i.PASSWORD_LENGTH then
self.codeCursor=self.codeCursor+1
end
if m.b then
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
elseif m.a or m.start then
if self.codeCursor<i.PASSWORD_LENGTH then
self:effect(c.TICK)
self.codeCursor=self.codeCursor+1
return
end
local o=i.zoneOfPassword(self:codeText())
if o then
self:effect(c.CONFIRM)
self.startZone=o
self.mode=a.MODE_SETUP
self:trace("password opens zone "..o)
else
self:effect(c.WRONG)
self.passwordError=h.errorTicks
end
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

function a:tickOptions(P)
local m=P.pressed
local F=t(m)
if F~=0 then
self.optionIndex=v(self.optionIndex+F,#x)
self:effect(c.TICK)
end
local o=x[self.optionIndex]
local G=K(m)
if G~=0 and o.key then
local E=SpiffBoy.clamp(self.mix[o.key]+G,0,u)
if E~=self.mix[o.key]then
self.mix[o.key]=E
self.mixDirty=true
self:applyMix()
self:effect(c.STEP..E)
end
end
if m.b or m.start then
self:effect(c.CONFIRM)
self:closeOptions()
elseif m.a then
self:effect(c.CONFIRM)
if o.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(o)
local m=o.pressed
if m.left or m.right or m.up or m.down then
self.confirmYes=not self.confirmYes
self:effect(c.TICK)
end
if m.b then
self:effect(c.CONFIRM)
self.mode=a.MODE_OPTIONS
elseif m.a or m.start then
self:effect(c.CONFIRM)
if self.confirmYes then
self.records=q.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self.mode=a.MODE_OPTIONS
end
end

function a:pageRecords(m)
return self.records[i.DIFFICULTIES[m].key]
end

function a:scoresVisible()
return math.floor((l.bottom-l.listY)/self.screen:lineHeight())
end

function a:showScores(m,o)
self.mode=a.MODE_SCORES
self.scoresPage=m
self.scoresTop=SpiffBoy.clamp(o,1,#self:pageRecords(m)-self:scoresVisible()+1)
end

function a:tickScores(G)
local m=G.pressed
local o=t(m)
local E=K(m)
if o~=0 then
local F=SpiffBoy.clamp(self.scoresTop+o,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if F~=self.scoresTop then
self.scoresTop=F
self:effect(c.TICK)
end
elseif E~=0 then
self.flashRankIndex=nil
self:showScores(v(self.scoresPage+E,#i.DIFFICULTIES),1)
self:effect(c.TICK)
elseif m.a or m.b or m.start then
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:tickContinue(o)
if o then
local m=o.pressed
if m.left or m.right or m.up or m.down then
self.continueYes=not self.continueYes
self:effect(c.TICK)
end
if m.a or m.start then
self:effect(c.CONFIRM)
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
self.continueTimer=a.CONTINUE.step
self.continueCount=self.continueCount-1
if self.continueCount<0 then
self:gameOver()
return
end
self:effect(c.COUNT)
end

function a:offerRecord()
self.sequencer:stop()
if q.rankOf(self.records[self.difficultyKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self.mode=a.MODE_SETUP
end

function a:repeatLetter(m,o,E)
if m~=0 then
E(m)
self:effect(c.TICK)
self.letterHoldStep=m
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
E(o)
self:effect(c.TICK)
self.letterRepeatTimer=math.max(C.min,C.start-math.floor(self.letterHoldTicks/C.speedup))
end
end

function a:tickInitials(E)
local m=E.pressed
self:repeatLetter(t(m),t(E.held),function(o)
self.letters[self.cursor]=v(self.letters[self.cursor]-o,U)
end)
if m.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif m.right and self.cursor<q.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if m.a or m.start then
self:effect(c.CONFIRM)
if self.cursor<q.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local o=""
for F=1,q.INITIALS_LENGTH do
o=o..string.sub(N,self.letters[F],self.letters[F])
end
local F=q.insert(self.records[self.difficultyKey],o,self.score)
self:persistRecords()
self:showScores(self.setup.difficulty,F)
self.flashRankIndex=F
self.flashUntil=self.clock+J.ticks*J.count*2
end
end
end

function a:drawFrame(m)
m:clear(r.r,r.g,r.b)
m:layers(self.art.frame,0,j,S,0,0,T)
end

function a:drawMenu(m)
self:drawFrame(m)
local o=self.mode
if o==a.MODE_TITLE then
self:drawTitle(m)
elseif o==a.MODE_SETUP then
self:drawSetup(m)
elseif o==a.MODE_PASSWORD then
self:drawPassword(m)
elseif o==a.MODE_OPTIONS then
self:drawOptions(m)
elseif o==a.MODE_CONFIRM then
self:drawConfirm(m)
elseif o==a.MODE_SCORES then
self:drawScores(m)
elseif o==a.MODE_CONTINUE then
self:drawContinue(m)
else
self:drawInitials(m)
end
end

function a:drawPointer(m,o,E)
local F=math.floor(self.clock/s.blink)%2
m:layers(self.art.bombs,F*s.size,s.size,s.size,o-s.size-s.gap,E+s.top,w)
end

function a:drawChase(m)
local F=math.floor(self.clock*f.chaseSpeed/4)%f.chaseLoop
local o=math.floor(self.clock/k.cycle)%2
local E=F-k.size
m:layers(self.art.survivor,(k.survivorRight+1+o)*k.size,k.size,k.size,E,f.chaseY,w)
for G,P in ipairs(k.zombieKinds)do
local Q=E-G*f.chaseGap-f.chaseGap
m:layers(self.art.zombies[P],(k.zombieRight+o)*k.size,k.size,k.size,Q,f.chaseY,w)
end
end

function a:drawTitle(m)
m:layers(self.art.logo,0,f.logoW,f.logoH,f.logoX,f.logoY,w)
m:layers(self.art.titleBomb,0,f.bombW,f.bombH,f.bombX,f.bombY,w)
local E=j/2
for o=1,#z do
local F=f.menuY+(o-1)*f.menuStep
local G=d(z[o])
g(m,G,E,F)
if o==self.menuIndex then
self:drawPointer(m,E-math.floor(m:textWidth(G)/2),F)
end
end
self:drawChase(m)
end

function a:drawRecordRows(o,Y,P,Z,_)
local E=j/2
local Q=o:lineHeight()
for F=P,Z do
local R=Y[F]
local G=_+(F-P)*Q
local m=b
local aa=self.mode==a.MODE_SCORES and F==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if aa and math.floor((self.flashUntil-self.clock-1)/J.ticks)%2==1 then
o:rect(E+p.left,G,p.right-p.left,Q,b.r,b.g,b.b,1)
m=r
end
o:textRight(tostring(F)..".",E+p.rank,G,m.r,m.g,m.b,1)
o:text(R.initials,E+p.initials,G,m.r,m.g,m.b,1)
o:textRight(tostring(R.score),E+p.score,G,m.r,m.g,m.b,1)
end
end

function a:drawSetup(m)
local E=d(i.DIFFICULTIES[self.setup.difficulty].text)
y(m,d("Difficulty"),e.labelX,e.rowY)
D(m,E,e.valueRight,e.rowY)
D(m,"<",e.valueRight-m:textWidth(E)-e.arrowGap,e.rowY)
D(m,">",e.arrowRight,e.rowY)
local F=i.LIST[self.startZone]
g(m,d("Zone",self.startZone).." "..d(F.name),j/2,e.zoneY)
m:rect(e.labelX,e.ruleY,e.arrowRight-e.labelX,1,b.r,b.g,b.b,1)
local o=self:pageRecords(self.setup.difficulty)
if#o==0 then
g(m,d("NoScores"),j/2,e.scoresY+m:lineHeight())
return
end
self:drawRecordRows(m,o,1,math.min(#o,e.shown),e.scoresY)
end

function a:drawPassword(m)
local E=j/2
g(m,d("Password"),E,h.titleY)
local G=i.PASSWORD_LENGTH
for o=1,G do
local P=E+(o-(G+1)/2)*h.spacing
local F=math.floor(P-h.boxW/2)
m:rect(F,h.boxY,h.boxW,h.boxH,b.r,b.g,b.b,1)
m:rect(F+1,h.boxY+1,h.boxW-2,h.boxH-2,I.r,I.g,I.b,1)
g(m,string.sub(O,self.code[o],self.code[o]),P,h.letterY)
if o==self.codeCursor and math.floor(self.clock/M)%2==0 then
m:rect(F+2,h.cursorY,h.boxW-4,2,b.r,b.g,b.b,1)
end
end
if self.passwordError>0 then
g(m,d("WrongPassword"),E,h.errorY)
end
end

local function Y(o,E,F,P)
local m=L
local G=u*m.barCell+(u-1)*m.barGap
o:rect(E-1,F-1,G+2,m.barHeight+2,b.r,b.g,b.b,1)
o:rect(E,F,G,m.barHeight,r.r,r.g,r.b,1)
for Q=1,P do
o:rect(E+(Q-1)*(m.barCell+m.barGap),F,m.barCell,m.barHeight,b.r,b.g,b.b,1)
end
end

function a:drawOptions(o)
local m=L
g(o,d("Options"),j/2,m.titleY)
for E=1,#x do
local F=x[E]
local G=m.firstY+(E-1)*m.step
y(o,d(F.text),m.labelX,G)
if F.key then
Y(o,m.barX,G+m.barTop,self.mix[F.key])
end
if E==self.optionIndex then
self:drawPointer(o,m.labelX,G)
end
end
end

function a:drawQuestion(m,Z,_,F,G,P)
local E=j/2
local Q=m:wrapText(Z,A.width)
for o=1,#Q do
g(m,Q[o],E,_+(o-1)*m:lineHeight())
end
local aa={{text="Yes",x=E-G,chosen=P},{text="No",x=E+G,chosen=not P}}
for ab,o in ipairs(aa)do
local R=d(o.text)
g(m,R,o.x,F)
if o.chosen then
self:drawPointer(m,o.x-math.floor(m:textWidth(R)/2),F)
end
end
end

function a:drawConfirm(m)
self:drawQuestion(m,d("EraseScores"),A.y,A.choicesY,A.gap,self.confirmYes)
end

function a:drawContinue(m)
self:drawQuestion(m,d("Continue"),B.titleY,B.choicesY,B.gap,self.continueYes)
g(m,tostring(math.max(0,self.continueCount)),j/2,B.countY)
end

function a:drawScores(m)
local o=j/2
local F=m:lineHeight()
local G=self.scoresPage
g(m,d(i.DIFFICULTIES[G].text),o,l.titleY)
y(m,"<",l.arrowX,l.titleY)
D(m,">",j-l.arrowX,l.titleY)
local E=self:pageRecords(G)
if#E==0 then
g(m,d("NoScores"),o,l.listY+F)
return
end
local P=self:scoresVisible()
local Q=math.min(#E,self.scoresTop+P-1)
self:drawRecordRows(m,E,self.scoresTop,Q,l.listY)
if self.scoresTop>1 then
y(m,W,o+p.arrow,l.listY)
end
if Q<#E then
y(m,X,o+p.arrow,l.listY+(P-1)*F)
end
end

function a:drawInitials(m)
local o=j/2
local G=m:lineHeight()
g(m,d("NewHighScore"),o,n.titleY)
g(m,tostring(self.score),o,n.scoreY)
g(m,d("EnterInitials"),o,n.promptY)
for E=1,q.INITIALS_LENGTH do
local F=o+(E-2)*n.spacing
g(m,string.sub(N,self.letters[E],self.letters[E]),F,n.lettersY)
if E==self.cursor and math.floor(self.clock/M)%2==0 then
m:rect(F-n.cursorWidth/2,n.lettersY+G+1,n.cursorWidth,n.cursorHeight,b.r,b.g,b.b,1)
end
end
end
