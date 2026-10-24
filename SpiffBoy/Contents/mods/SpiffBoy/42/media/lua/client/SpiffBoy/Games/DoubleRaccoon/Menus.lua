require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/DoubleRaccoon/Stage"
require"SpiffBoy/Games/DoubleRaccoon/Records"
require"SpiffBoy/Games/DoubleRaccoon/Music"

local a=SpiffBoyDoubleRaccoonGame
local E=SpiffBoy.DoubleRaccoon
local q=E.Stage
local o=E.Records
local d=E.Music

local b=SpiffBoy.Cartridges.SHADES[4]
local f=SpiffBoy.Cartridges.SHADES[1]
local F=SpiffBoy.Cartridges.SHADES[2]
local h=SpiffBoy.Cartridges.SCREEN_WIDTH
local H=SpiffBoy.Cartridges.SCREEN_HEIGHT
local i=a.gameText
local r=d.MIX_STEPS
local m={1,2,3,4}

local A={"Play","HighScores","Options"}
local t={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local c={scroll=3,loop=600,panelX=8,panelY=4,panelW=164,panelH=42,headX=13,headY=12,logoX=65,logoY=8,logoW=85,logoH=34,barY=84,menuY=82,menuStep=12,spiffoX=34,zombieX=146,feetY=80}
local u={width=9,height=8,gap=6,top=4}
local I=26
local g={width=52,height=50,anchor=26,idle=0,zombieFacingLeft=9}
local P={spiffoX=-14,spiffoY=-6,spiffoWidth=104,spiffoHeight=100,boxLeft=74,boxTop=4,boxHeight=35,rowStep=38,iconX=78,iconY=8,iconWidth=24,iconHeight=14,textX=104,nameY=2,bestY=18}
local n={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=50}
local J={titleY=4,firstY=28,step=24,labelX=22,barX=96,barCell=5,barGap=1,barHeight=8,barTop=4}
local B={y=30,width=150,choicesY=80,gap=32}
local j={titleY=4,arrowX=12,listY=26,bottom=116}
local v={titleY=18,countY=44,choicesY=82,gap=32,step=60}
local l={titleY=10,scoreY=34,promptY=58,lettersY=82,spacing=20,cursorWidth=12,cursorHeight=2}
local G={ticks=15,count=4}
local Q=30
local K="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local R=62
local C={delay=24,start=8,min=2,speedup=30}
local S=string.char(0x25B4)
local T=string.char(0x25BE)

local function w(value,count)
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

local function L(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function z(screen)
screen:clear(f.r,f.g,f.b)
end

local function D(screen,label,x,y)
screen:text(label,x,y,b.r,b.g,b.b,1)
end

local function k(screen,label,x,y)
screen:textCentre(label,x,y,b.r,b.g,b.b,1)
end

local function U(screen,label,x,y)
screen:textRight(label,x,y,b.r,b.g,b.b,1)
end

function a:readChoices()
self.setup={difficulty=2}
local e=self.save.setup
if type(e)=="table"and SpiffBoy.isInteger(e.difficulty)and e.difficulty>=1 and e.difficulty<=#q.DIFFICULTIES then
self.setup.difficulty=e.difficulty
end
self.mix={music=r,effects=r}
local y=self.save.options
if type(y)=="table"then
for M,x in ipairs(t)do
local p=x.key and y[x.key]
if SpiffBoy.isInteger(p)and p>=0 and p<=r then
self.mix[x.key]=p
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
local e=self.mode
if e~=a.MODE_CONTINUE then
self:keepMusic(d.TITLE)
end
if not input then
if e==a.MODE_CONTINUE then
self:tickContinue(nil)
end
return
end
if e==a.MODE_TITLE then
self:tickTitle(input)
elseif e==a.MODE_SETUP then
self:tickSetup(input)
elseif e==a.MODE_OPTIONS then
self:tickOptions(input)
elseif e==a.MODE_CONFIRM then
self:tickConfirm(input)
elseif e==a.MODE_SCORES then
self:tickScores(input)
elseif e==a.MODE_CONTINUE then
self:tickContinue(input)
else
self:tickInitials(input)
end
end

function a:tickTitle(input)
local e=input.pressed
local p=s(e)
if p~=0 then
self.menuIndex=w(self.menuIndex+p,#A)
self:effect(d.TICK)
end
if e.a or e.start then
self:effect(d.CONFIRM)
local x=A[self.menuIndex]
if x=="Play"then
self.mode=a.MODE_SETUP
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
local e=input.pressed
local p=s(e)
if p~=0 then
self.setup.difficulty=w(self.setup.difficulty+p,#q.DIFFICULTIES)
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

function a:tickOptions(input)
local e=input.pressed
local y=s(e)
if y~=0 then
self.optionIndex=w(self.optionIndex+y,#t)
self:effect(d.TICK)
end
local p=t[self.optionIndex]
local M=L(e)
if M~=0 and p.key then
local x=SpiffBoy.clamp(self.mix[p.key]+M,0,r)
if x~=self.mix[p.key]then
self.mix[p.key]=x
self.mixDirty=true
self:applyMix()
self:effect(d.STEP..x)
end
end
if e.b or e.start then
self:effect(d.CONFIRM)
self:closeOptions()
elseif e.a then
self:effect(d.CONFIRM)
if p.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(input)
local e=input.pressed
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
self.records=o.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self.mode=a.MODE_OPTIONS
end
end

function a:pageRecords(page)
return self.records[q.DIFFICULTIES[page].key]
end

function a:scoresVisible()
return math.floor((j.bottom-j.listY)/self.screen:lineHeight())
end

function a:showScores(page,rank)
self.mode=a.MODE_SCORES
self.scoresPage=page
self.scoresTop=SpiffBoy.clamp(rank,1,#self:pageRecords(page)-self:scoresVisible()+1)
end

function a:tickScores(input)
local e=input.pressed
local p=s(e)
local x=L(e)
if p~=0 then
local y=SpiffBoy.clamp(self.scoresTop+p,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if y~=self.scoresTop then
self.scoresTop=y
self:effect(d.TICK)
end
elseif x~=0 then
self.flashRankIndex=nil
self:showScores(w(self.scoresPage+x,#q.DIFFICULTIES),1)
self:effect(d.TICK)
elseif e.a or e.b or e.start then
self:effect(d.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:tickContinue(input)
if input then
local e=input.pressed
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
self.continueTimer=v.step
self.continueCount=self.continueCount-1
if self.continueCount<0 then
self:gameOver()
return
end
self:effect(d.COUNT)
end

function a:offerRecord()
self.sequencer:stop()
if o.rankOf(self.records[self.difficultyKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self.mode=a.MODE_SETUP
end

function a:turnLetter(step)
self.letters[self.cursor]=w(self.letters[self.cursor]-step,R)
self:effect(d.TICK)
end

function a:repeatLetter(pressedStep,heldStep)
if pressedStep~=0 then
self:turnLetter(pressedStep)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=C.delay
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
self.letterRepeatTimer=math.max(C.min,C.start-math.floor(self.letterHoldTicks/C.speedup))
end
end

function a:tickInitials(input)
local e=input.pressed
self:repeatLetter(s(e),s(input.held))
if e.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif e.right and self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if e.a or e.start then
self:effect(d.CONFIRM)
if self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local p=""
for x=1,o.INITIALS_LENGTH do
p=p..string.sub(K,self.letters[x],self.letters[x])
end
local x=o.insert(self.records[self.difficultyKey],p,self.score)
self:persistRecords()
self:showScores(self.setup.difficulty,x)
self.flashRankIndex=x
self.flashUntil=self.clock+G.ticks*G.count*2
end
end
end

function a:drawMenu(screen)
local e=self.mode
if e==a.MODE_TITLE then
self:drawTitle(screen)
elseif e==a.MODE_SETUP then
self:drawSetup(screen)
elseif e==a.MODE_OPTIONS then
self:drawOptions(screen)
elseif e==a.MODE_CONFIRM then
self:drawConfirm(screen)
elseif e==a.MODE_SCORES then
self:drawScores(screen)
elseif e==a.MODE_CONTINUE then
self:drawContinue(screen)
else
self:drawInitials(screen)
end
end

function a:drawPointer(screen,right,y)
screen:layers(self.hudHead,0,u.width,u.height,right-u.width-u.gap,y+u.top,m)
end

function a:drawTitle(screen)
screen:clear(b.r,b.g,b.b)
self.sceneries[1]:drawBack(screen,math.floor(self.clock/c.scroll)%c.loop)
screen:layers(self.spiffo,g.idle*g.width,g.width,g.height,c.spiffoX-g.anchor,c.feetY-g.height+1,m)
screen:layers(self.zombieSheets.shambler,g.zombieFacingLeft*g.width,g.width,g.height,c.zombieX-g.anchor,c.feetY-g.height+1,m)
screen:rect(c.panelX-1,c.panelY-1,c.panelW+2,c.panelH+2,f.r,f.g,f.b,1)
screen:rect(c.panelX,c.panelY,c.panelW,c.panelH,b.r,b.g,b.b,1)
screen:layers(self.titleHead,0,I,I,c.headX,c.headY,m)
screen:layers(self.logo,0,c.logoW,c.logoH,c.logoX,c.logoY,m)
screen:rect(0,c.barY,h,H-c.barY,f.r,f.g,f.b,1)
local p=h/2
for e=1,#A do
local x=i(A[e])
local y=c.menuY+(e-1)*c.menuStep
k(screen,x,p,y)
if e==self.menuIndex then
self:drawPointer(screen,p-math.floor(screen:textWidth(x)/2),y)
end
end
end

function a:drawRecordRows(screen,list,first,last,top)
local p=h/2
local M=screen:lineHeight()
for x=first,last do
local N=list[x]
local y=top+(x-first)*M
local e=b
local O=self.mode==a.MODE_SCORES and x==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if O and math.floor((self.flashUntil-self.clock-1)/G.ticks)%2==1 then
screen:rect(p+n.left,y,n.right-n.left,M,b.r,b.g,b.b,1)
e=f
end
screen:textRight(tostring(x)..".",p+n.rank,y,e.r,e.g,e.b,1)
screen:text(N.initials,p+n.initials,y,e.r,e.g,e.b,1)
screen:textRight(tostring(N.score),p+n.score,y,e.r,e.g,e.b,1)
end
end

function a:drawSetup(screen)
local e=P
screen:layers(self.selectStage,0,h,H,0,0,m)
screen:layers(self.selectSpiffo,(self.setup.difficulty-1)*e.spiffoWidth,e.spiffoWidth,e.spiffoHeight,e.spiffoX,e.spiffoY,m)
local M=h-e.boxLeft
for y,N in ipairs(q.DIFFICULTIES)do
local x=e.boxTop+(y-1)*e.rowStep
local p=f
screen:rect(e.boxLeft,x,M,e.boxHeight,b.r,b.g,b.b,1)
if y~=self.setup.difficulty then
screen:rect(e.boxLeft+1,x+1,M-2,e.boxHeight-2,F.r,F.g,F.b,1)
p=b
end
screen:layers(self.headbands,(y-1)*e.iconWidth,e.iconWidth,e.iconHeight,e.iconX,x+e.iconY,m)
local O=self.records[N.key]
local V=#O>0 and O[1].score or 0
screen:text(i(N.text),e.textX,x+e.nameY,p.r,p.g,p.b,1)
screen:text(tostring(V),e.textX,x+e.bestY,p.r,p.g,p.b,1)
end
end

local function O(screen,x,y,value)
local e=J
local p=r*e.barCell+(r-1)*e.barGap
screen:rect(x-1,y-1,p+2,e.barHeight+2,b.r,b.g,b.b,1)
screen:rect(x,y,p,e.barHeight,f.r,f.g,f.b,1)
for M=1,value do
screen:rect(x+(M-1)*(e.barCell+e.barGap),y,e.barCell,e.barHeight,b.r,b.g,b.b,1)
end
end

function a:drawOptions(screen)
z(screen)
local e=J
k(screen,i("Options"),h/2,e.titleY)
for p=1,#t do
local x=t[p]
local y=e.firstY+(p-1)*e.step
D(screen,i(x.text),e.labelX,y)
if x.key then
O(screen,e.barX,y+e.barTop,self.mix[x.key])
end
if p==self.optionIndex then
self:drawPointer(screen,e.labelX,y)
end
end
end

function a:drawQuestion(screen,question,y,choicesY,gap,yes)
local p=h/2
local x=screen:wrapText(question,B.width)
for e=1,#x do
k(screen,x[e],p,y+(e-1)*screen:lineHeight())
end
local N={{text="Yes",x=p-gap,chosen=yes},{text="No",x=p+gap,chosen=not yes}}
for V,e in ipairs(N)do
local M=i(e.text)
k(screen,M,e.x,choicesY)
if e.chosen then
self:drawPointer(screen,e.x-math.floor(screen:textWidth(M)/2),choicesY)
end
end
end

function a:drawConfirm(screen)
z(screen)
self:drawQuestion(screen,i("EraseScores"),B.y,B.choicesY,B.gap,self.confirmYes)
end

function a:drawContinue(screen)
z(screen)
self:drawQuestion(screen,i("Continue"),v.titleY,v.choicesY,v.gap,self.continueYes)
k(screen,tostring(math.max(0,self.continueCount)),h/2,v.countY)
end

function a:drawScores(screen)
z(screen)
local e=h/2
local x=screen:lineHeight()
local y=self.scoresPage
k(screen,i(q.DIFFICULTIES[y].text),e,j.titleY)
D(screen,"<",j.arrowX,j.titleY)
U(screen,">",h-j.arrowX,j.titleY)
local p=self:pageRecords(y)
if#p==0 then
k(screen,i("NoScores"),e,j.listY+x)
return
end
local M=self:scoresVisible()
local N=math.min(#p,self.scoresTop+M-1)
self:drawRecordRows(screen,p,self.scoresTop,N,j.listY)
if self.scoresTop>1 then
D(screen,S,e+n.arrow,j.listY)
end
if N<#p then
D(screen,T,e+n.arrow,j.listY+(M-1)*x)
end
end

function a:drawInitials(screen)
z(screen)
local e=h/2
local y=screen:lineHeight()
k(screen,i("NewHighScore"),e,l.titleY)
k(screen,tostring(self.score),e,l.scoreY)
k(screen,i("EnterInitials"),e,l.promptY)
for p=1,o.INITIALS_LENGTH do
local x=e+(p-2)*l.spacing
k(screen,string.sub(K,self.letters[p],self.letters[p]),x,l.lettersY)
if p==self.cursor and math.floor(self.clock/Q)%2==0 then
screen:rect(x-l.cursorWidth/2,l.lettersY+y+1,l.cursorWidth,l.cursorHeight,b.r,b.g,b.b,1)
end
end
end
