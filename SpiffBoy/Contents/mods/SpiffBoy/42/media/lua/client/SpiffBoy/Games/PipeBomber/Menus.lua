require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Records"
require"SpiffBoy/Games/PipeBomber/Music"

local a=SpiffBoyPipeBomberGame
local G=SpiffBoy.PipeBomber
local i=G.Zones
local p=G.Records
local c=G.Music

local q=SpiffBoy.Cartridges.SHADES[4]
local b=SpiffBoy.Cartridges.SHADES[1]
local H=SpiffBoy.Cartridges.SHADES[3]
local j=SpiffBoy.Cartridges.SCREEN_WIDTH
local Q=SpiffBoy.Cartridges.SCREEN_HEIGHT
local d=a.gameText
local t=c.MIX_STEPS
local v={1,2,3,4}
local R={1,3}

local A={"Play","Password","HighScores","Options"}
local w={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local f={logoX=22,logoY=8,logoW=78,logoH=38,bombX=130,bombY=12,bombW=20,bombH=25,menuY=50,menuStep=13,chaseY=98,chaseSpeed=2,chaseLoop=260,chaseGap=18}
local r={size=12,gap=4,top=1,blink=10}
local k={survivorRight=6,zombieRight=0,zombieKinds={"shambler","runner"},size=16,cycle=8}
local e={labelX=14,valueRight=160,arrowRight=168,arrowGap=2,rowY=10,zoneY=28,ruleY=48,scoresY=52,shown=3}
local o={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=50}
local K={titleY=8,firstY=32,step=24,labelX=26,barX=100,barCell=5,barGap=1,barHeight=8,barTop=4}
local B={y=26,width=150,choicesY=76,gap=32}
local l={titleY=8,arrowX=14,listY=28,bottom=112}
local C={titleY=18,countY=44,choicesY=78,gap=32}
local n={titleY=10,scoreY=32,promptY=54,lettersY=78,spacing=20,cursorWidth=12,cursorHeight=2}
local h={titleY=14,boxY=46,boxW=20,boxH=22,spacing=26,letterY=48,cursorY=64,errorY=86,errorTicks=120}
local I={ticks=15,count=4}
local L=30
local M="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local S=62
local N="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local T=26
local D={delay=24,start=8,min=2,speedup=30}
local U=string.char(0x25B4)
local V=string.char(0x25BE)

local function u(value,count)
return(value-1+count)%count+1
end

local function s(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function J(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function z(screen,label,x,y)
screen:text(label,x,y,b.r,b.g,b.b,1)
end

local function g(screen,label,x,y)
screen:textCentre(label,x,y,b.r,b.g,b.b,1)
end

local function E(screen,label,x,y)
screen:textRight(label,x,y,b.r,b.g,b.b,1)
end

function a:readChoices()
self.setup={difficulty=2}
local m=self.save.setup
if type(m)=="table"and SpiffBoy.isInteger(m.difficulty)and m.difficulty>=1 and m.difficulty<=#i.DIFFICULTIES then
self.setup.difficulty=m.difficulty
end
self.mix={music=t,effects=t}
local F=self.save.options
if type(F)=="table"then
for O,y in ipairs(w)do
local x=y.key and F[y.key]
if SpiffBoy.isInteger(x)and x>=0 and x<=t then
self.mix[y.key]=x
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

function a:tickMenu(input)
local m=self.mode
if m~=a.MODE_CONTINUE then
self:keepMusic(c.TITLE)
end
if self.passwordError and self.passwordError>0 then
self.passwordError=self.passwordError-1
end
if not input then
if m==a.MODE_CONTINUE then
self:tickContinue(nil)
end
return
end
if m==a.MODE_TITLE then
self:tickTitle(input)
elseif m==a.MODE_SETUP then
self:tickSetup(input)
elseif m==a.MODE_PASSWORD then
self:tickPassword(input)
elseif m==a.MODE_OPTIONS then
self:tickOptions(input)
elseif m==a.MODE_CONFIRM then
self:tickConfirm(input)
elseif m==a.MODE_SCORES then
self:tickScores(input)
elseif m==a.MODE_CONTINUE then
self:tickContinue(input)
else
self:tickInitials(input)
end
end

function a:tickTitle(input)
local m=input.pressed
local y=s(m)
if y~=0 then
self.menuIndex=u(self.menuIndex+y,#A)
self:effect(c.TICK)
end
if m.a or m.start then
self:effect(c.CONFIRM)
local x=A[self.menuIndex]
if x=="Play"then
self.startZone=1
self.mode=a.MODE_SETUP
elseif x=="Password"then
self:openPassword()
elseif x=="Options"then
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

function a:tickSetup(input)
local m=input.pressed
local x=J(m)
if x~=0 then
self.setup.difficulty=u(self.setup.difficulty+x,#i.DIFFICULTIES)
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
for x=1,i.PASSWORD_LENGTH do
m=m..string.sub(N,self.code[x],self.code[x])
end
return m
end

function a:tickPassword(input)
local m=input.pressed
self:repeatLetter(s(m),s(input.held),function(step)
self.code[self.codeCursor]=u(self.code[self.codeCursor]-step,T)
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
local x=i.zoneOfPassword(self:codeText())
if x then
self:effect(c.CONFIRM)
self.startZone=x
self.mode=a.MODE_SETUP
self:trace("password opens zone "..x)
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

function a:tickOptions(input)
local m=input.pressed
local F=s(m)
if F~=0 then
self.optionIndex=u(self.optionIndex+F,#w)
self:effect(c.TICK)
end
local x=w[self.optionIndex]
local O=J(m)
if O~=0 and x.key then
local y=SpiffBoy.clamp(self.mix[x.key]+O,0,t)
if y~=self.mix[x.key]then
self.mix[x.key]=y
self.mixDirty=true
self:applyMix()
self:effect(c.STEP..y)
end
end
if m.b or m.start then
self:effect(c.CONFIRM)
self:closeOptions()
elseif m.a then
self:effect(c.CONFIRM)
if x.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(input)
local m=input.pressed
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
self.records=p.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self.mode=a.MODE_OPTIONS
end
end

function a:pageRecords(page)
return self.records[i.DIFFICULTIES[page].key]
end

function a:scoresVisible()
return math.floor((l.bottom-l.listY)/self.screen:lineHeight())
end

function a:showScores(page,rank)
self.mode=a.MODE_SCORES
self.scoresPage=page
self.scoresTop=SpiffBoy.clamp(rank,1,#self:pageRecords(page)-self:scoresVisible()+1)
end

function a:tickScores(input)
local m=input.pressed
local x=s(m)
local y=J(m)
if x~=0 then
local F=SpiffBoy.clamp(self.scoresTop+x,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if F~=self.scoresTop then
self.scoresTop=F
self:effect(c.TICK)
end
elseif y~=0 then
self.flashRankIndex=nil
self:showScores(u(self.scoresPage+y,#i.DIFFICULTIES),1)
self:effect(c.TICK)
elseif m.a or m.b or m.start then
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:tickContinue(input)
if input then
local m=input.pressed
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
if p.rankOf(self.records[self.difficultyKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self.mode=a.MODE_SETUP
end

function a:repeatLetter(pressedStep,heldStep,turn)
if pressedStep~=0 then
turn(pressedStep)
self:effect(c.TICK)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=D.delay
return
end
if heldStep==0 or heldStep~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
turn(heldStep)
self:effect(c.TICK)
self.letterRepeatTimer=math.max(D.min,D.start-math.floor(self.letterHoldTicks/D.speedup))
end
end

function a:tickInitials(input)
local m=input.pressed
self:repeatLetter(s(m),s(input.held),function(step)
self.letters[self.cursor]=u(self.letters[self.cursor]-step,S)
end)
if m.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif m.right and self.cursor<p.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if m.a or m.start then
self:effect(c.CONFIRM)
if self.cursor<p.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local x=""
for y=1,p.INITIALS_LENGTH do
x=x..string.sub(M,self.letters[y],self.letters[y])
end
local y=p.insert(self.records[self.difficultyKey],x,self.score)
self:persistRecords()
self:showScores(self.setup.difficulty,y)
self.flashRankIndex=y
self.flashUntil=self.clock+I.ticks*I.count*2
end
end
end

function a:drawFrame(screen)
screen:clear(q.r,q.g,q.b)
screen:layers(self.art.frame,0,j,Q,0,0,R)
end

function a:drawMenu(screen)
self:drawFrame(screen)
local m=self.mode
if m==a.MODE_TITLE then
self:drawTitle(screen)
elseif m==a.MODE_SETUP then
self:drawSetup(screen)
elseif m==a.MODE_PASSWORD then
self:drawPassword(screen)
elseif m==a.MODE_OPTIONS then
self:drawOptions(screen)
elseif m==a.MODE_CONFIRM then
self:drawConfirm(screen)
elseif m==a.MODE_SCORES then
self:drawScores(screen)
elseif m==a.MODE_CONTINUE then
self:drawContinue(screen)
else
self:drawInitials(screen)
end
end

function a:drawPointer(screen,right,y)
local m=math.floor(self.clock/r.blink)%2
screen:layers(self.art.bombs,m*r.size,r.size,r.size,right-r.size-r.gap,y+r.top,v)
end

function a:drawChase(screen)
local y=math.floor(self.clock*f.chaseSpeed/4)%f.chaseLoop
local m=math.floor(self.clock/k.cycle)%2
local x=y-k.size
screen:layers(self.art.survivor,(k.survivorRight+1+m)*k.size,k.size,k.size,x,f.chaseY,v)
for F,O in ipairs(k.zombieKinds)do
local P=x-F*f.chaseGap-f.chaseGap
screen:layers(self.art.zombies[O],(k.zombieRight+m)*k.size,k.size,k.size,P,f.chaseY,v)
end
end

function a:drawTitle(screen)
screen:layers(self.art.logo,0,f.logoW,f.logoH,f.logoX,f.logoY,v)
screen:layers(self.art.titleBomb,0,f.bombW,f.bombH,f.bombX,f.bombY,v)
local x=j/2
for m=1,#A do
local y=f.menuY+(m-1)*f.menuStep
local F=d(A[m])
g(screen,F,x,y)
if m==self.menuIndex then
self:drawPointer(screen,x-math.floor(screen:textWidth(F)/2),y)
end
end
self:drawChase(screen)
end

function a:drawRecordRows(screen,list,first,last,top)
local x=j/2
local O=screen:lineHeight()
for y=first,last do
local P=list[y]
local F=top+(y-first)*O
local m=b
local W=self.mode==a.MODE_SCORES and y==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if W and math.floor((self.flashUntil-self.clock-1)/I.ticks)%2==1 then
screen:rect(x+o.left,F,o.right-o.left,O,b.r,b.g,b.b,1)
m=q
end
screen:textRight(tostring(y)..".",x+o.rank,F,m.r,m.g,m.b,1)
screen:text(P.initials,x+o.initials,F,m.r,m.g,m.b,1)
screen:textRight(tostring(P.score),x+o.score,F,m.r,m.g,m.b,1)
end
end

function a:drawSetup(screen)
local x=d(i.DIFFICULTIES[self.setup.difficulty].text)
z(screen,d("Difficulty"),e.labelX,e.rowY)
E(screen,x,e.valueRight,e.rowY)
E(screen,"<",e.valueRight-screen:textWidth(x)-e.arrowGap,e.rowY)
E(screen,">",e.arrowRight,e.rowY)
local y=i.LIST[self.startZone]
g(screen,d("Zone",self.startZone).." "..d(y.name),j/2,e.zoneY)
screen:rect(e.labelX,e.ruleY,e.arrowRight-e.labelX,1,b.r,b.g,b.b,1)
local m=self:pageRecords(self.setup.difficulty)
if#m==0 then
g(screen,d("NoScores"),j/2,e.scoresY+screen:lineHeight())
return
end
self:drawRecordRows(screen,m,1,math.min(#m,e.shown),e.scoresY)
end

function a:drawPassword(screen)
local x=j/2
g(screen,d("Password"),x,h.titleY)
local F=i.PASSWORD_LENGTH
for m=1,F do
local O=x+(m-(F+1)/2)*h.spacing
local y=math.floor(O-h.boxW/2)
screen:rect(y,h.boxY,h.boxW,h.boxH,b.r,b.g,b.b,1)
screen:rect(y+1,h.boxY+1,h.boxW-2,h.boxH-2,H.r,H.g,H.b,1)
g(screen,string.sub(N,self.code[m],self.code[m]),O,h.letterY)
if m==self.codeCursor and math.floor(self.clock/L)%2==0 then
screen:rect(y+2,h.cursorY,h.boxW-4,2,b.r,b.g,b.b,1)
end
end
if self.passwordError>0 then
g(screen,d("WrongPassword"),x,h.errorY)
end
end

local function W(screen,x,y,value)
local m=K
local F=t*m.barCell+(t-1)*m.barGap
screen:rect(x-1,y-1,F+2,m.barHeight+2,b.r,b.g,b.b,1)
screen:rect(x,y,F,m.barHeight,q.r,q.g,q.b,1)
for O=1,value do
screen:rect(x+(O-1)*(m.barCell+m.barGap),y,m.barCell,m.barHeight,b.r,b.g,b.b,1)
end
end

function a:drawOptions(screen)
local m=K
g(screen,d("Options"),j/2,m.titleY)
for x=1,#w do
local y=w[x]
local F=m.firstY+(x-1)*m.step
z(screen,d(y.text),m.labelX,F)
if y.key then
W(screen,m.barX,F+m.barTop,self.mix[y.key])
end
if x==self.optionIndex then
self:drawPointer(screen,m.labelX,F)
end
end
end

function a:drawQuestion(screen,question,y,choicesY,gap,yes)
local x=j/2
local F=screen:wrapText(question,B.width)
for m=1,#F do
g(screen,F[m],x,y+(m-1)*screen:lineHeight())
end
local P={{text="Yes",x=x-gap,chosen=yes},{text="No",x=x+gap,chosen=not yes}}
for X,m in ipairs(P)do
local O=d(m.text)
g(screen,O,m.x,choicesY)
if m.chosen then
self:drawPointer(screen,m.x-math.floor(screen:textWidth(O)/2),choicesY)
end
end
end

function a:drawConfirm(screen)
self:drawQuestion(screen,d("EraseScores"),B.y,B.choicesY,B.gap,self.confirmYes)
end

function a:drawContinue(screen)
self:drawQuestion(screen,d("Continue"),C.titleY,C.choicesY,C.gap,self.continueYes)
g(screen,tostring(math.max(0,self.continueCount)),j/2,C.countY)
end

function a:drawScores(screen)
local m=j/2
local y=screen:lineHeight()
local F=self.scoresPage
g(screen,d(i.DIFFICULTIES[F].text),m,l.titleY)
z(screen,"<",l.arrowX,l.titleY)
E(screen,">",j-l.arrowX,l.titleY)
local x=self:pageRecords(F)
if#x==0 then
g(screen,d("NoScores"),m,l.listY+y)
return
end
local O=self:scoresVisible()
local P=math.min(#x,self.scoresTop+O-1)
self:drawRecordRows(screen,x,self.scoresTop,P,l.listY)
if self.scoresTop>1 then
z(screen,U,m+o.arrow,l.listY)
end
if P<#x then
z(screen,V,m+o.arrow,l.listY+(O-1)*y)
end
end

function a:drawInitials(screen)
local m=j/2
local F=screen:lineHeight()
g(screen,d("NewHighScore"),m,n.titleY)
g(screen,tostring(self.score),m,n.scoreY)
g(screen,d("EnterInitials"),m,n.promptY)
for x=1,p.INITIALS_LENGTH do
local y=m+(x-2)*n.spacing
g(screen,string.sub(M,self.letters[x],self.letters[x]),y,n.lettersY)
if x==self.cursor and math.floor(self.clock/L)%2==0 then
screen:rect(y-n.cursorWidth/2,n.lettersY+F+1,n.cursorWidth,n.cursorHeight,b.r,b.g,b.b,1)
end
end
end
