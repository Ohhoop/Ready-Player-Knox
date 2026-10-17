require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/SnackMan/Rules"
require"SpiffBoy/Games/SnackMan/Records"
require"SpiffBoy/Games/SnackMan/Music"

local a=SpiffBoySnackManGame
local F=SpiffBoy.SnackMan
local g=F.Rules
local o=F.Records
local d=F.Music

local G=SpiffBoy.Cartridges.SHADES
local h=G[4]
local c=G[1]
local H=G[2]
local i=SpiffBoy.Cartridges.SCREEN_WIDTH
local N=SpiffBoy.Cartridges.SCREEN_HEIGHT
local j=a.gameText
local q=d.MIX_STEPS
local r={1,2,3,4}

local z={"Play","HighScores","Options"}
local v={{key="music",text="Music"},{key="effects",text="Effects"},{action="clear",text="ClearScores"}}
local n={x=10,width=160,edge=3,bottom=N-4}
local A={width=105,height=22,y=5}
local I={width=150,height=2}
local p={bottom=86,print=2,ruleTop=33,menuY=38,menuStep=15,ruleBottom=82}
local e={y=96,cycle=720,half=360,start=200,speed=0.9,lead=22,gap=18,back=0.6,from=-90,bat=24,cell=16}
local w={width=8,height=6,gap=4,top=5}
local b={centres={48,132},signY=2,signHeight=36,signMin=60,signPad=8,nameY=3,bestY=20,crowdY=44,crowdStep=16,hordeShown=6,hordeRow=10,heroY=98,step=1.5,walkTicks=40,walkSpeed=1.2,cell=16}
local W={1,2,3}
local s={rank=-26,initials=-22,score=42,left=-44,right=46}
local O={titleY=4,ruleY=22,firstY=30,step=24,labelX=26,barX=96,barCell=5,barGap=1,barHeight=8,barTop=4}
local t={y=26,width=140,choicesY=78,gap=32}
local f={titleY=4,arrowX=18,ruleY=22,listY=28,bottom=112,markX=136,markSize=5}
local k={titleY=6,scoreY=26,promptY=50,lettersY=82,spacing=20,cursorWidth=12,cursorHeight=2,width=150}
local J={ticks=15,count=4}
local X=30
local P="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local Y=62
local B={delay=24,start=8,min=2,speedup=30}
local K={right=0,left=1}
local Q=10

local function x(m,l)
return(m-1+l)%l+1
end

local function y(l)
if l.up then
return-1
elseif l.down then
return 1
end
return 0
end

local function L(l)
if l.left then
return-1
elseif l.right then
return 1
end
return 0
end

local function R(l,m,u,C)
l:text(m,u,C,c.r,c.g,c.b,1)
end

local function l(m,u,C,D)
m:textCentre(u,C,D,c.r,c.g,c.b,1)
end

local function Z(m,u,C,D)
m:textRight(u,C,D,c.r,c.g,c.b,1)
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
for E,C in ipairs(v)do
local u=C.key and D[C.key]
if SpiffBoy.isInteger(u)and u>=0 and u<=q then
self.mix[C.key]=u
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

function a:tickMenu(m)
self:keepMusic(d.TITLE)
self.printed=math.min(p.bottom,self.printed+p.print)
self.titleClock=self.titleClock+1
if self.mode==a.MODE_SETUP then
self:tickAisles()
end
if not m then
return
end
local u=self.mode
if u==a.MODE_TITLE then
self:tickTitle(m)
elseif u==a.MODE_SETUP then
self:tickSetup(m)
elseif u==a.MODE_OPTIONS then
self:tickOptions(m)
elseif u==a.MODE_CONFIRM then
self:tickConfirm(m)
elseif u==a.MODE_SCORES then
self:tickScores(m)
elseif u==a.MODE_INITIALS then
self:tickInitials(m)
end
end

function a:tickTitle(D)
local m=D.pressed
local u=y(m)
if u~=0 then
self.menuIndex=x(self.menuIndex+u,#z)
self:effect(d.TICK)
end
if m.a or m.start then
self:effect(d.CONFIRM)
local C=z[self.menuIndex]
if C=="Play"then
self:openSetup()
elseif C=="Options"then
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
local u=math.min(b.step,math.abs(m-self.aisleX))
self.aisleX=self.aisleX+(m>self.aisleX and u or-u)
end
end

function a:tickSetup(C)
if self.aisleWalk>0 then
return
end
local m=C.pressed
local u=L(m)
if u~=0 then
self.setup.mode=x(self.setup.mode+u,#g.MODES)
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

function a:tickOptions(M)
local m=M.pressed
local D=y(m)
if D~=0 then
self.optionIndex=x(self.optionIndex+D,#v)
self:effect(d.TICK)
end
local u=v[self.optionIndex]
local E=L(m)
if E~=0 and u.key then
local C=SpiffBoy.clamp(self.mix[u.key]+E,0,q)
if C~=self.mix[u.key]then
self.mix[u.key]=C
self.mixDirty=true
self:applyMix()
self:effect(d.STEP..C)
end
end
if m.b or m.start then
self:effect(d.CONFIRM)
self:closeOptions()
elseif m.a then
self:effect(d.CONFIRM)
if u.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(u)
local m=u.pressed
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

function a:pageRecords(m)
return self.records[g.MODES[m].key]
end

function a:scoresVisible()
return math.floor((f.bottom-f.listY)/self.screen:lineHeight())
end

function a:showScores(m,u)
self.mode=a.MODE_SCORES
self.scoresPage=m
self.scoresTop=SpiffBoy.clamp(u,1,#self:pageRecords(m)-self:scoresVisible()+1)
end

function a:tickScores(E)
local m=E.pressed
local u=y(m)
local C=L(m)
if u~=0 then
local D=SpiffBoy.clamp(self.scoresTop+u,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if D~=self.scoresTop then
self.scoresTop=D
self:effect(d.TICK)
end
elseif C~=0 then
self.flashRankIndex=nil
self:showScores(x(self.scoresPage+C,#g.MODES),1)
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

function a:turnLetter(m)
self.letters[self.cursor]=x(self.letters[self.cursor]-m,Y)
self:effect(d.TICK)
end

function a:repeatLetter(m,u)
if m~=0 then
self:turnLetter(m)
self.letterHoldStep=m
self.letterHoldTicks=0
self.letterRepeatTimer=B.delay
return
end
if u==0 or u~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(u)
self.letterRepeatTimer=math.max(B.min,B.start-math.floor(self.letterHoldTicks/B.speedup))
end
end

function a:tickInitials(C)
local m=C.pressed
self:repeatLetter(y(m),y(C.held))
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
local u=""
for D=1,o.INITIALS_LENGTH do
u=u..string.sub(P,self.letters[D],self.letters[D])
end
local D=o.insert(self.records[self.recordKey],u,self.score)
self:persistRecords()
local E=1
for M,S in ipairs(g.MODES)do
if S.key==self.recordKey then
E=M
end
end
self:showScores(E,D)
self.flashRankIndex=D
self.flashUntil=self.clock+J.ticks*J.count*2
end
end
end

function a:drawReceipt(m,u)
m:clear(H.r,H.g,H.b)
if u<=0 then
return
end
m:rect(n.x,0,n.width,u,h.r,h.g,h.b,1)
m:sheet(self.receiptEdge,0,0,n.width,n.edge,n.x,u,1,4)
end

function a:drawRule(m,u)
m:sheet(self.chips,0,0,I.width,I.height,(i-I.width)/2,u,1,1)
end

function a:drawPointer(m,u,C)
m:layers(self.life,0,w.width,w.height,u-w.width-w.gap,C+w.top,r)
end

function a:drawMenu(m)
local u=self.mode
if u==a.MODE_TITLE then
self:drawTitle(m)
elseif u==a.MODE_SETUP then
self:drawSetup(m)
elseif u==a.MODE_OPTIONS then
self:drawOptions(m)
elseif u==a.MODE_CONFIRM then
self:drawConfirm(m)
elseif u==a.MODE_SCORES then
self:drawScores(m)
else
self:drawInitials(m)
end
end

function a:drawChaseHead(m,u,C,D)
m:layers(u,C*e.cell,e.cell,e.cell,math.floor(D),e.y,r)
end

function a:drawChase(m)
local C=self.titleClock%e.cycle
local u=math.floor(self.titleClock/Q)%2
if C<e.half then
local D=e.start-C*e.speed
self:drawChaseHead(m,self.survivor,K.left*2+u,D)
for E,M in ipairs(g.CLASSIC_KINDS)do
self:drawChaseHead(m,self.zombieArt[M],K.left*2+u,D+e.lead+(E-1)*e.gap)
end
return
end
local D=e.from+(C-e.half)*e.back
for E=1,#g.CLASSIC_KINDS do
self:drawChaseHead(m,self.fright,u,D+(E-1)*e.gap)
end
self:drawChaseHead(m,self.survivor,K.right*2+u,D-e.bat)
end

function a:drawTitle(m)
local u=self.printed-p.bottom
self:drawReceipt(m,self.printed)
m:layers(self.logo,0,A.width,A.height,(i-A.width)/2,A.y+u,r)
self:drawRule(m,p.ruleTop+u)
local D=i/2
for C=1,#z do
local E=j(z[C])
local M=p.menuY+(C-1)*p.menuStep+u
l(m,E,D,M)
if C==self.menuIndex then
self:drawPointer(m,D-math.floor(m:textWidth(E)/2),M)
end
end
self:drawRule(m,p.ruleBottom+u)
self:drawChase(m)
end

function a:drawRecordRows(u,U,M,V,_)
local C=i/2
local S=u:lineHeight()
for D=M,V do
local T=U[D]
local E=_+(D-M)*S
local m=c
local aa=self.mode==a.MODE_SCORES and D==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if aa and math.floor((self.flashUntil-self.clock-1)/J.ticks)%2==1 then
u:rect(C+s.left,E,s.right-s.left,S,c.r,c.g,c.b,1)
m=h
end
u:textRight(tostring(D)..".",C+s.rank,E,m.r,m.g,m.b,1)
u:text(T.initials,C+s.initials,E,m.r,m.g,m.b,1)
u:textRight(tostring(T.score),C+s.score,E,m.r,m.g,m.b,1)
end
end

function a:drawAisleSign(u,D,_)
local E=b.centres[D]
local S=j(g.MODES[D].text)
local T=self:pageRecords(D)
local U=tostring(#T>0 and T[1].score or 0)
local M=math.max(b.signMin,math.max(u:textWidth(S),u:textWidth(U))+b.signPad)
local V=E-math.floor(M/2)
local C,m=h,c
if _ then
C,m=c,h
end
u:rect(V-1,b.signY-1,M+2,b.signHeight+2,c.r,c.g,c.b,1)
u:rect(V,b.signY,M,b.signHeight,C.r,C.g,C.b,1)
u:textCentre(S,E,b.signY+b.nameY,m.r,m.g,m.b,1)
u:textCentre(U,E,b.signY+b.bestY,m.r,m.g,m.b,1)
end

function a:drawAisleCrowd(D,E)
local M=b.centres[E]
local m=b.cell
local S=6
if not g.MODES[E].horde then
local u=g.CLASSIC_KINDS
local C=M-#u*b.crowdStep/2
for T,U in ipairs(u)do
D:layers(self.zombieArt[U],S*m,m,m,C+(T-1)*b.crowdStep,b.crowdY,r)
end
return
end
local T=b.hordeShown
local u=T/2
for U=1,T do
local C=math.floor((U-1)/u)
local V=(U-1)-C*u
local _=M-u*b.crowdStep/2+V*b.crowdStep+C*b.crowdStep/2
D:layers(self.zombieArt[g.HORDE_KIND],S*m,m,m,_,b.crowdY+C*b.hordeRow,r)
end
end

function a:drawSetup(m)
m:clear(h.r,h.g,h.b)
m:layers(self.aisles,0,i,N,0,0,W)
for u=1,#g.MODES do
self:drawAisleCrowd(m,u)
end
for u=1,#g.MODES do
self:drawAisleSign(m,u,u==self.setup.mode)
end
local u=b.cell
local D=self.aisleX~=b.centres[self.setup.mode]
local C=2
if D then
C=b.centres[self.setup.mode]>self.aisleX and 0 or 1
end
local E=math.floor(self.titleClock/Q)%2
m:layers(self.survivor,(C*2+E)*u,u,u,math.floor(self.aisleX)-u/2,math.floor(self.aisleY)-u/2,r)
end

local function U(u,C,D,M)
local m=O
local E=q*m.barCell+(q-1)*m.barGap
u:rect(C-1,D-1,E+2,m.barHeight+2,c.r,c.g,c.b,1)
u:rect(C,D,E,m.barHeight,h.r,h.g,h.b,1)
for S=1,M do
u:rect(C+(S-1)*(m.barCell+m.barGap),D,m.barCell,m.barHeight,c.r,c.g,c.b,1)
end
end

function a:drawOptions(u)
self:drawReceipt(u,n.bottom)
local m=O
l(u,j("Options"),i/2,m.titleY)
self:drawRule(u,m.ruleY)
for C=1,#v do
local D=v[C]
local E=m.firstY+(C-1)*m.step
R(u,j(D.text),m.labelX,E)
if D.key then
U(u,m.barX,E+m.barTop,self.mix[D.key])
end
if C==self.optionIndex then
self:drawPointer(u,m.labelX,E)
end
end
end

function a:drawConfirm(m)
self:drawReceipt(m,n.bottom)
local C=i/2
local D=m:wrapText(j("EraseScores"),t.width)
for u=1,#D do
l(m,D[u],C,t.y+(u-1)*m:lineHeight())
end
local M={{text="Yes",x=C-t.gap,chosen=self.confirmYes},{text="No",x=C+t.gap,chosen=not self.confirmYes}}
for S,u in ipairs(M)do
local E=j(u.text)
l(m,E,u.x,t.choicesY)
if u.chosen then
self:drawPointer(m,u.x-math.floor(m:textWidth(E)/2),t.choicesY)
end
end
end

local function D(C,E,M,S)
for m=0,2 do
local u=S and(m*2+1)or(5-m*2)
C:rect(E+(f.markSize-u)/2,M+m,u,1,c.r,c.g,c.b,1)
end
end

function a:drawScores(m)
self:drawReceipt(m,n.bottom)
local C=i/2
local E=m:lineHeight()
local M=self.scoresPage
l(m,j(g.MODES[M].text),C,f.titleY)
R(m,"<",f.arrowX,f.titleY)
Z(m,">",i-f.arrowX,f.titleY)
self:drawRule(m,f.ruleY)
local u=self:pageRecords(M)
if#u==0 then
l(m,j("NoScores"),C,f.listY+E)
return
end
local S=self:scoresVisible()
local T=math.min(#u,self.scoresTop+S-1)
self:drawRecordRows(m,u,self.scoresTop,T,f.listY)
if self.scoresTop>1 then
D(m,f.markX,f.listY+4,true)
end
if T<#u then
D(m,f.markX,f.listY+(S-1)*E+8,false)
end
end

function a:drawInitials(m)
self:drawReceipt(m,n.bottom)
local u=i/2
local E=m:lineHeight()
l(m,j("NewHighScore"),u,k.titleY)
l(m,tostring(self.score),u,k.scoreY)
local M=m:wrapText(j("EnterInitials"),k.width)
for C=1,#M do
l(m,M[C],u,k.promptY+(C-1)*E)
end
for C=1,o.INITIALS_LENGTH do
local S=u+(C-2)*k.spacing
l(m,string.sub(P,self.letters[C],self.letters[C]),S,k.lettersY)
if C==self.cursor and math.floor(self.clock/X)%2==0 then
m:rect(S-k.cursorWidth/2,k.lettersY+E+1,k.cursorWidth,k.cursorHeight,c.r,c.g,c.b,1)
end
end
end
