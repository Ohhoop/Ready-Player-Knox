require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/SnackMan/Rules"
require"SpiffBoy/Games/SnackMan/Records"
require"SpiffBoy/Games/SnackMan/Music"

local a=SpiffBoySnackManGame
local E=SpiffBoy.SnackMan
local g=E.Rules
local o=E.Records
local d=E.Music

local F=SpiffBoy.Cartridges.SHADES
local h=F[4]
local c=F[1]
local G=F[2]
local i=SpiffBoy.Cartridges.SCREEN_WIDTH
local L=SpiffBoy.Cartridges.SCREEN_HEIGHT
local j=a.gameText
local q=d.MIX_STEPS
local r={1,2,3,4}

local A={"Play","HighScores","Options"}
local u={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local n={x=10,width=160,edge=3,bottom=L-4}
local B={width=105,height=22,y=5}
local H={width=150,height=2}
local p={bottom=86,print=2,ruleTop=33,menuY=38,menuStep=15,ruleBottom=82}
local e={y=96,cycle=720,half=360,start=200,speed=0.9,lead=22,gap=18,back=0.6,from=-90,bat=24,cell=16}
local v={width=8,height=6,gap=4,top=5}
local b={centres={48,132},signY=2,signHeight=36,signMin=60,signPad=8,nameY=3,bestY=20,crowdY=44,crowdStep=16,hordeShown=6,hordeRow=10,heroY=98,step=1.5,walkTicks=40,walkSpeed=1.2,cell=16}
local U={1,2,3}
local s={rank=-26,initials=-22,score=42,left=-44,right=46}
local M={titleY=4,ruleY=22,firstY=30,step=24,labelX=26,barX=96,barCell=5,barGap=1,barHeight=8,barTop=4}
local t={y=26,width=140,choicesY=78,gap=32}
local f={titleY=4,arrowX=18,ruleY=22,listY=28,bottom=112,markX=136,markSize=5}
local k={titleY=6,scoreY=26,promptY=50,lettersY=82,spacing=20,cursorWidth=12,cursorHeight=2,width=150}
local I={ticks=15,count=4}
local V=30
local N="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local W=62
local C={delay=24,start=8,min=2,speedup=30}
local J={right=0,left=1}
local O=10

local function w(value,count)
return(value-1+count)%count+1
end

local function z(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function K(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function P(screen,label,x,y)
screen:text(label,x,y,c.r,c.g,c.b,1)
end

local function l(screen,label,x,y)
screen:textCentre(label,x,y,c.r,c.g,c.b,1)
end

local function X(screen,label,x,y)
screen:textRight(label,x,y,c.r,c.g,c.b,1)
end

function a:readChoices()
self.setup={mode=1}
local m=self.save.setup
if type(m)=="table"and SpiffBoy.isInteger(m.mode)and m.mode>=1 and m.mode<=#g.MODES then
self.setup.mode=m.mode
end
self.mix={music=q,effects=q}
local D=self.save.options
if type(D)=="table"then
for Q,y in ipairs(u)do
local x=y.key and D[y.key]
if SpiffBoy.isInteger(x)and x>=0 and x<=q then
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
self.printed=0
self.titleClock=0
self.sequencer:stop()
end

function a:tickMenu(input)
self:keepMusic(d.TITLE)
self.printed=math.min(p.bottom,self.printed+p.print)
self.titleClock=self.titleClock+1
if self.mode==a.MODE_SETUP then
self:tickAisles()
end
if not input then
return
end
local m=self.mode
if m==a.MODE_TITLE then
self:tickTitle(input)
elseif m==a.MODE_SETUP then
self:tickSetup(input)
elseif m==a.MODE_OPTIONS then
self:tickOptions(input)
elseif m==a.MODE_CONFIRM then
self:tickConfirm(input)
elseif m==a.MODE_SCORES then
self:tickScores(input)
elseif m==a.MODE_INITIALS then
self:tickInitials(input)
end
end

function a:tickTitle(input)
local m=input.pressed
local x=z(m)
if x~=0 then
self.menuIndex=w(self.menuIndex+x,#A)
self:effect(d.TICK)
end
if m.a or m.start then
self:effect(d.CONFIRM)
local y=A[self.menuIndex]
if y=="Play"then
self:openSetup()
elseif y=="Options"then
self.mode=a.MODE_OPTIONS
self.optionIndex=1
else
self:showScores(self.setup.mode,1)
end
end
end

function a:saveSetup()
if self.setupDirty then
self.save.setup={mode=self.setup.mode}
self:persist()
self.setupDirty=false
end
end

function a:openSetup()
self.mode=a.MODE_SETUP
self.aisleX=b.centres[self.setup.mode]
self.aisleY=b.heroY
self.aisleWalk=0
end

function a:tickAisles()
if self.aisleWalk>0 then
self.aisleWalk=self.aisleWalk-1
self.aisleY=self.aisleY-b.walkSpeed
if self.aisleWalk==0 then
self:startRun()
end
return
end
local m=b.centres[self.setup.mode]
if self.aisleX~=m then
local x=math.min(b.step,math.abs(m-self.aisleX))
self.aisleX=self.aisleX+(m>self.aisleX and x or-x)
end
end

function a:tickSetup(input)
if self.aisleWalk>0 then
return
end
local m=input.pressed
local x=K(m)
if x~=0 then
self.setup.mode=w(self.setup.mode+x,#g.MODES)
self.setupDirty=true
self:effect(d.TICK)
end
if m.a or m.start then
self:saveSetup()
self:effect(d.CONFIRM)
self.aisleX=b.centres[self.setup.mode]
self.aisleWalk=b.walkTicks
elseif m.b then
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
local m=input.pressed
local D=z(m)
if D~=0 then
self.optionIndex=w(self.optionIndex+D,#u)
self:effect(d.TICK)
end
local x=u[self.optionIndex]
local Q=K(m)
if Q~=0 and x.key then
local y=SpiffBoy.clamp(self.mix[x.key]+Q,0,q)
if y~=self.mix[x.key]then
self.mix[x.key]=y
self.mixDirty=true
self:applyMix()
self:effect(d.STEP..y)
end
end
if m.b or m.start then
self:effect(d.CONFIRM)
self:closeOptions()
elseif m.a then
self:effect(d.CONFIRM)
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
self:effect(d.TICK)
end
if m.b then
self:effect(d.CONFIRM)
self.mode=a.MODE_OPTIONS
elseif m.a or m.start then
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
return self.records[g.MODES[page].key]
end

function a:scoresVisible()
return math.floor((f.bottom-f.listY)/self.screen:lineHeight())
end

function a:showScores(page,rank)
self.mode=a.MODE_SCORES
self.scoresPage=page
self.scoresTop=SpiffBoy.clamp(rank,1,#self:pageRecords(page)-self:scoresVisible()+1)
end

function a:tickScores(input)
local m=input.pressed
local x=z(m)
local y=K(m)
if x~=0 then
local D=SpiffBoy.clamp(self.scoresTop+x,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if D~=self.scoresTop then
self.scoresTop=D
self:effect(d.TICK)
end
elseif y~=0 then
self.flashRankIndex=nil
self:showScores(w(self.scoresPage+y,#g.MODES),1)
self:effect(d.TICK)
elseif m.a or m.b or m.start then
self:effect(d.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:offerRecord()
self.sequencer:stop()
if o.rankOf(self.records[self.recordKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self:openSetup()
end

function a:turnLetter(step)
self.letters[self.cursor]=w(self.letters[self.cursor]-step,W)
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
local m=input.pressed
self:repeatLetter(z(m),z(input.held))
if m.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif m.right and self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if m.a or m.start then
self:effect(d.CONFIRM)
if self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local x=""
for y=1,o.INITIALS_LENGTH do
x=x..string.sub(N,self.letters[y],self.letters[y])
end
local y=o.insert(self.records[self.recordKey],x,self.score)
self:persistRecords()
local D=1
for Q,R in ipairs(g.MODES)do
if R.key==self.recordKey then
D=Q
end
end
self:showScores(D,y)
self.flashRankIndex=y
self.flashUntil=self.clock+I.ticks*I.count*2
end
end
end

function a:drawReceipt(screen,bottom)
screen:clear(G.r,G.g,G.b)
if bottom<=0 then
return
end
screen:rect(n.x,0,n.width,bottom,h.r,h.g,h.b,1)
screen:sheet(self.receiptEdge,0,0,n.width,n.edge,n.x,bottom,1,4)
end

function a:drawRule(screen,y)
screen:sheet(self.chips,0,0,H.width,H.height,(i-H.width)/2,y,1,1)
end

function a:drawPointer(screen,right,y)
screen:layers(self.life,0,v.width,v.height,right-v.width-v.gap,y+v.top,r)
end

function a:drawMenu(screen)
local m=self.mode
if m==a.MODE_TITLE then
self:drawTitle(screen)
elseif m==a.MODE_SETUP then
self:drawSetup(screen)
elseif m==a.MODE_OPTIONS then
self:drawOptions(screen)
elseif m==a.MODE_CONFIRM then
self:drawConfirm(screen)
elseif m==a.MODE_SCORES then
self:drawScores(screen)
else
self:drawInitials(screen)
end
end

function a:drawChaseHead(screen,sheet,frame,x)
screen:layers(sheet,frame*e.cell,e.cell,e.cell,math.floor(x),e.y,r)
end

function a:drawChase(screen)
local x=self.titleClock%e.cycle
local m=math.floor(self.titleClock/O)%2
if x<e.half then
local y=e.start-x*e.speed
self:drawChaseHead(screen,self.survivor,J.left*2+m,y)
for D,Q in ipairs(g.CLASSIC_KINDS)do
self:drawChaseHead(screen,self.zombieArt[Q],J.left*2+m,y+e.lead+(D-1)*e.gap)
end
return
end
local y=e.from+(x-e.half)*e.back
for D=1,#g.CLASSIC_KINDS do
self:drawChaseHead(screen,self.fright,m,y+(D-1)*e.gap)
end
self:drawChaseHead(screen,self.survivor,J.right*2+m,y-e.bat)
end

function a:drawTitle(screen)
local m=self.printed-p.bottom
self:drawReceipt(screen,self.printed)
screen:layers(self.logo,0,B.width,B.height,(i-B.width)/2,B.y+m,r)
self:drawRule(screen,p.ruleTop+m)
local y=i/2
for x=1,#A do
local D=j(A[x])
local Q=p.menuY+(x-1)*p.menuStep+m
l(screen,D,y,Q)
if x==self.menuIndex then
self:drawPointer(screen,y-math.floor(screen:textWidth(D)/2),Q)
end
end
self:drawRule(screen,p.ruleBottom+m)
self:drawChase(screen)
end

function a:drawRecordRows(screen,list,first,last,top)
local x=i/2
local Q=screen:lineHeight()
for y=first,last do
local R=list[y]
local D=top+(y-first)*Q
local m=c
local S=self.mode==a.MODE_SCORES and y==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if S and math.floor((self.flashUntil-self.clock-1)/I.ticks)%2==1 then
screen:rect(x+s.left,D,s.right-s.left,Q,c.r,c.g,c.b,1)
m=h
end
screen:textRight(tostring(y)..".",x+s.rank,D,m.r,m.g,m.b,1)
screen:text(R.initials,x+s.initials,D,m.r,m.g,m.b,1)
screen:textRight(tostring(R.score),x+s.score,D,m.r,m.g,m.b,1)
end
end

function a:drawAisleSign(screen,index,chosen)
local y=b.centres[index]
local Q=j(g.MODES[index].text)
local R=self:pageRecords(index)
local S=tostring(#R>0 and R[1].score or 0)
local D=math.max(b.signMin,math.max(screen:textWidth(Q),screen:textWidth(S))+b.signPad)
local T=y-math.floor(D/2)
local x,m=h,c
if chosen then
x,m=c,h
end
screen:rect(T-1,b.signY-1,D+2,b.signHeight+2,c.r,c.g,c.b,1)
screen:rect(T,b.signY,D,b.signHeight,x.r,x.g,x.b,1)
screen:textCentre(Q,y,b.signY+b.nameY,m.r,m.g,m.b,1)
screen:textCentre(S,y,b.signY+b.bestY,m.r,m.g,m.b,1)
end

function a:drawAisleCrowd(screen,index)
local D=b.centres[index]
local m=b.cell
local Q=6
if not g.MODES[index].horde then
local x=g.CLASSIC_KINDS
local y=D-#x*b.crowdStep/2
for R,S in ipairs(x)do
screen:layers(self.zombieArt[S],Q*m,m,m,y+(R-1)*b.crowdStep,b.crowdY,r)
end
return
end
local R=b.hordeShown
local x=R/2
for S=1,R do
local y=math.floor((S-1)/x)
local T=(S-1)-y*x
local Y=D-x*b.crowdStep/2+T*b.crowdStep+y*b.crowdStep/2
screen:layers(self.zombieArt[g.HORDE_KIND],Q*m,m,m,Y,b.crowdY+y*b.hordeRow,r)
end
end

function a:drawSetup(screen)
screen:clear(h.r,h.g,h.b)
screen:layers(self.aisles,0,i,L,0,0,U)
for m=1,#g.MODES do
self:drawAisleCrowd(screen,m)
end
for m=1,#g.MODES do
self:drawAisleSign(screen,m,m==self.setup.mode)
end
local m=b.cell
local y=self.aisleX~=b.centres[self.setup.mode]
local x=2
if y then
x=b.centres[self.setup.mode]>self.aisleX and 0 or 1
end
local D=math.floor(self.titleClock/O)%2
screen:layers(self.survivor,(x*2+D)*m,m,m,math.floor(self.aisleX)-m/2,math.floor(self.aisleY)-m/2,r)
end

local function T(screen,x,y,value)
local m=M
local D=q*m.barCell+(q-1)*m.barGap
screen:rect(x-1,y-1,D+2,m.barHeight+2,c.r,c.g,c.b,1)
screen:rect(x,y,D,m.barHeight,h.r,h.g,h.b,1)
for Q=1,value do
screen:rect(x+(Q-1)*(m.barCell+m.barGap),y,m.barCell,m.barHeight,c.r,c.g,c.b,1)
end
end

function a:drawOptions(screen)
self:drawReceipt(screen,n.bottom)
local m=M
l(screen,j("Options"),i/2,m.titleY)
self:drawRule(screen,m.ruleY)
for x=1,#u do
local y=u[x]
local D=m.firstY+(x-1)*m.step
P(screen,j(y.text),m.labelX,D)
if y.key then
T(screen,m.barX,D+m.barTop,self.mix[y.key])
end
if x==self.optionIndex then
self:drawPointer(screen,m.labelX,D)
end
end
end

function a:drawConfirm(screen)
self:drawReceipt(screen,n.bottom)
local x=i/2
local y=screen:wrapText(j("EraseScores"),t.width)
for m=1,#y do
l(screen,y[m],x,t.y+(m-1)*screen:lineHeight())
end
local Q={{text="Yes",x=x-t.gap,chosen=self.confirmYes},{text="No",x=x+t.gap,chosen=not self.confirmYes}}
for R,m in ipairs(Q)do
local D=j(m.text)
l(screen,D,m.x,t.choicesY)
if m.chosen then
self:drawPointer(screen,m.x-math.floor(screen:textWidth(D)/2),t.choicesY)
end
end
end

local function D(screen,x,y,up)
for m=0,2 do
local Q=up and(m*2+1)or(5-m*2)
screen:rect(x+(f.markSize-Q)/2,y+m,Q,1,c.r,c.g,c.b,1)
end
end

function a:drawScores(screen)
self:drawReceipt(screen,n.bottom)
local x=i/2
local y=screen:lineHeight()
local Q=self.scoresPage
l(screen,j(g.MODES[Q].text),x,f.titleY)
P(screen,"<",f.arrowX,f.titleY)
X(screen,">",i-f.arrowX,f.titleY)
self:drawRule(screen,f.ruleY)
local m=self:pageRecords(Q)
if#m==0 then
l(screen,j("NoScores"),x,f.listY+y)
return
end
local R=self:scoresVisible()
local S=math.min(#m,self.scoresTop+R-1)
self:drawRecordRows(screen,m,self.scoresTop,S,f.listY)
if self.scoresTop>1 then
D(screen,f.markX,f.listY+4,true)
end
if S<#m then
D(screen,f.markX,f.listY+(R-1)*y+8,false)
end
end

function a:drawInitials(screen)
self:drawReceipt(screen,n.bottom)
local m=i/2
local y=screen:lineHeight()
l(screen,j("NewHighScore"),m,k.titleY)
l(screen,tostring(self.score),m,k.scoreY)
local Q=screen:wrapText(j("EnterInitials"),k.width)
for x=1,#Q do
l(screen,Q[x],m,k.promptY+(x-1)*y)
end
for x=1,o.INITIALS_LENGTH do
local R=m+(x-2)*k.spacing
l(screen,string.sub(N,self.letters[x],self.letters[x]),R,k.lettersY)
if x==self.cursor and math.floor(self.clock/V)%2==0 then
screen:rect(R-k.cursorWidth/2,k.lettersY+y+1,k.cursorWidth,k.cursorHeight,c.r,c.g,c.b,1)
end
end
end
