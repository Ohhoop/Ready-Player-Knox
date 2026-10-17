require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Brain"
require"SpiffBoy/Games/StreetBiter/Music"

local a=SpiffBoyStreetBiterGame
local w=SpiffBoy.StreetBiter
local m=w.Roster
local E=w.Moves
local F=w.Brain
local c=w.Music

local e=SpiffBoy.Cartridges.SHADES[4]
local h=SpiffBoy.Cartridges.SHADES[1]
local s=SpiffBoy.Cartridges.SHADES[2]
local f=SpiffBoy.Cartridges.SCREEN_WIDTH
local M=SpiffBoy.Cartridges.SCREEN_HEIGHT
local d=a.gameText
local G={1,2,3,4}
local t={width=72,height=64,anchor=36}
local j={size=36,columns=4,gap=2,left=14,top=18}
local k={logoY=4,logoW=73,logoH=34,leftX=30,rightX=150,feetY=84,barY=84,menuY=84,menuStep=12}
local R={titleY=4,firstY=34,step=24,labelX=14,valueX=166}
local N={titleY=2,nameY=90,markY=2}
local o={leftX=50,rightX=130,feetY=92,nameY=14,vsY=44}
local x={titleY=18,countY=44,choicesY=82,gap=32}
local y={bandY=14,bandHeight=26,titleY=18,feetY=110}
local S={x=16,y=20,width=148,height=84,titleY=24,firstY=44,step=14}
local z={titleY=2,headerY=18,step=12,labelX=8,inputX=172,arrowX=10,pages=3}
local T=30
local U=20
local V=180
local W={"idle1","idle2","idle3"}
local X=string.char(0x25B6)
local H={["1"]=0x2199,["2"]=0x2193,["3"]=0x2198,["4"]=0x2190,["6"]=0x2192,["7"]=0x2196,["8"]=0x2191,["9"]=0x2197}
local I={"Resume","MoveList","Options","ReturnToTitle"}
local J={"Difficulty","Music"}

local function p(g,b)
return(g-1+b)%b+1
end

local function A(b)
if b.up then
return-1
elseif b.down then
return 1
end
return 0
end

local function K(b)
if b.left then
return-1
elseif b.right then
return 1
end
return 0
end

local function q(b)
b:clear(h.r,h.g,h.b)
end

local function n(b,g,i,l)
b:text(g,i,l,e.r,e.g,e.b,1)
end

local function i(b,g,l,r)
b:textCentre(g,l,r,e.r,e.g,e.b,1)
end

local function r(b,g,l,u)
b:textRight(g,l,u,e.r,e.g,e.b,1)
end

local function B(l)
local b=""
for u=1,string.len(l)do
local g=string.sub(l,u,u)
if H[g]then
b=b..string.char(H[g])
else
b=b..g
end
end
return b
end

local function O(g)
local b=""
for u,l in ipairs(m.MOTIONS[g.motion].label)do
b=b..string.char(H[tostring(l)])
end
return b..string.upper(g.button)
end

function a:readChoices()
self.setup={difficulty=2}
local b=self.save.setup
if type(b)=="table"and SpiffBoy.isInteger(b.difficulty)and b.difficulty>=1 and b.difficulty<=#F.LEVELS then
self.setup.difficulty=b.difficulty
end
self.options={music=true}
local g=self.save.options
if type(g)=="table"and g.music==false then
self.options.music=false
end
self.choicesDirty=false
self:applyMusic()
end

function a:saveChoices()
if self.choicesDirty then
self.save.setup={difficulty=self.setup.difficulty}
self.save.options={music=self.options.music}
self:persist()
self.choicesDirty=false
end
end

local Y={"OnePlayer","TwoPlayers","Options"}

function a:titleEntries()
return Y
end

function a:canChoose(b)
return b~="TwoPlayers"or self.port:isConnected()
end

function a:tickMenu(g)
local b=self.mode
if b==a.MODE_TITLE or b==a.MODE_OPTIONS or b==a.MODE_WAITING then
self:keepMusic(c.TITLE)
elseif b==a.MODE_SELECT or b==a.MODE_VERSUS then
self:keepMusic(c.SELECT)
end
if b==a.MODE_WAITING then
self:tickWaiting(g)
elseif b==a.MODE_VERSUS then
self:tickVersus()
elseif b==a.MODE_RESULT then
self:tickResult()
elseif b==a.MODE_OVER then
self:tickOver()
elseif b==a.MODE_CONTINUE then
self:tickContinue(g)
elseif not g then
return
elseif b==a.MODE_TITLE then
self:tickTitle(g)
elseif b==a.MODE_OPTIONS then
self:tickOptions(g,a.MODE_TITLE)
elseif b==a.MODE_SELECT then
self:tickSelect(g)
elseif b==a.MODE_ENDING then
self:tickEnding(g)
end
end

function a:tickTitle(v)
local b=v.pressed
local l=self:titleEntries()
local u=A(b)
if u~=0 then
self.menuIndex=p(self.menuIndex+u,#l)
self:effect(c.TICK)
end
if b.a or b.start then
local g=l[self.menuIndex]
if not self:canChoose(g)then
self:effect(c.TICK)
return
end
self:effect(c.CONFIRM)
if g=="OnePlayer"then
self:openSelect(false)
elseif g=="TwoPlayers"then
self:openWaiting()
else
self.mode=a.MODE_OPTIONS
self.optionIndex=1
end
end
end

function a:tickOptions(u,v)
local b=u.pressed
local g=A(b)
if g~=0 then
self.optionIndex=p(self.optionIndex+g,#J)
self:effect(c.TICK)
end
local l=K(b)
if l~=0 then
if J[self.optionIndex]=="Difficulty"then
self.setup.difficulty=p(self.setup.difficulty+l,#F.LEVELS)
else
self.options.music=not self.options.music
self:applyMusic()
end
self.choicesDirty=true
self:effect(c.TICK)
end
if b.a or b.b or b.start then
self:effect(c.CONFIRM)
self:saveChoices()
if v==a.MODE_TITLE then
self.mode=a.MODE_TITLE
else
self.pauseScreen=a.PAUSE_MENU
end
end
end

function a:tickWaiting(b)
if self.clock%T==0 then
self.port:hello()
end
if b and b.pressed.b then
self:effect(c.CONFIRM)
self:openTitle()
end
end

function a:tickSelect(u)
local b=u.pressed
if self.twoPlayer and self.port:leads()and self.port:needsPing()and self.clock%U==0 then
self.port:ping(self.clock)
end
if self.myChoice then
return
end
local g=K(b)
local l=A(b)
if g~=0 then
local v=math.floor((self.cursor-1)/j.columns)
local C=p((self.cursor-1)%j.columns+1+g,j.columns)
self.cursor=v*j.columns+C
self:effect(c.TICK)
elseif l~=0 then
self.cursor=p(self.cursor+l*j.columns,m.COUNT)
self:effect(c.TICK)
end
if b.a or b.start then
self:effect(c.CONFIRM)
if self.twoPlayer then
self.myChoice=self.cursor
self.port:sendChoice(self.cursor)
if self.peerChoice then
self:openVersus()
end
else
self:startRun(self.cursor)
end
elseif b.b and not self.twoPlayer then
self:effect(c.CONFIRM)
self:openTitle()
end
end

function a:tickVersus()
self.versusTimer=self.versusTimer-1
if self.twoPlayer and self.match then
self:prefill()
end
if self.versusTimer<=0 and self.match then
self:openFight()
end
end

function a:tickResult()
self.resultTimer=self.resultTimer-1
if self.resultTimer<=0 then
self:leaveResult()
end
end

function a:tickOver()
self.overTimer=self.overTimer-1
if self.overTimer<=0 and not self.sequencer:isPlaying()then
self:openTitle()
end
end

function a:tickContinue(g)
if g then
local b=g.pressed
if b.left or b.right or b.up or b.down then
self.continueYes=not self.continueYes
self:effect(c.TICK)
end
if b.a or b.start then
self:effect(c.CONFIRM)
if self.continueYes then
self:openVersus()
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
self.continueTimer=60
self.continueCount=self.continueCount-1
if self.continueCount<0 then
self:gameOver()
return
end
self:effect(c.COUNT)
end

function a:tickEnding(b)
self.endingTimer=self.endingTimer+1
if self.endingTimer>V and(b.pressed.a or b.pressed.start)then
self:openTitle()
end
end

function a:tickPause(g)
if not g then
return
end
local b=g.pressed
if self.pauseScreen==a.PAUSE_OPTIONS then
self:tickOptions(g,a.PAUSE_MENU)
return
end
if self.pauseScreen==a.PAUSE_MOVES then
local l=K(b)
if l~=0 then
self.movePage=p(self.movePage+l,z.pages)
self:effect(c.TICK)
end
if b.a or b.b or b.start then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_MENU
end
return
end
local u=A(b)
if u~=0 then
self.pauseIndex=p(self.pauseIndex+u,#I)
self:effect(c.TICK)
end
if b.b or b.start then
self:resume()
return
end
if b.a then
local l=I[self.pauseIndex]
if l=="Resume"then
self:resume()
elseif l=="MoveList"then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_MOVES
self.movePage=1
elseif l=="Options"then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_OPTIONS
self.optionIndex=1
else
self:effect(c.CONFIRM)
self:openTitle()
end
end
end

function a:drawMenu(b)
local g=self.mode
if g==a.MODE_TITLE then
self:drawTitle(b)
elseif g==a.MODE_OPTIONS then
self:drawOptions(b)
elseif g==a.MODE_WAITING then
self:drawWaiting(b)
elseif g==a.MODE_SELECT then
self:drawSelect(b)
elseif g==a.MODE_VERSUS then
self:drawVersus(b)
elseif g==a.MODE_RESULT then
self:drawResult(b)
elseif g==a.MODE_CONTINUE then
self:drawContinue(b)
elseif g==a.MODE_OVER then
self:drawOver(b)
elseif g==a.MODE_ENDING then
self:drawEnding(b)
end
end

function a:drawFighterAt(b,g,l,u,v,C)
local D,L=m.cellOf(l,C)
b:layers(self.sheets[g.id][D],L*t.width,t.width,t.height,u-t.anchor,v-t.height+1,G)
end

function a:idleFrame()
return W[math.floor(self.clock/30)%3+1]
end

local function C(b,g,l)
r(b,X,g-4,l)
end

function a:drawTitle(b)
b:clear(e.r,e.g,e.b)
b:layers(self.logo,0,k.logoW,k.logoH,math.floor((f-k.logoW)/2),k.logoY,G)
self:drawFighterAt(b,m.LIST[1],self:idleFrame(),k.leftX,k.feetY,1)
self:drawFighterAt(b,m.LIST[5],self:idleFrame(),k.rightX,k.feetY,-1)
b:rect(0,k.barY,f,M-k.barY,h.r,h.g,h.b,1)
local g=f/2
local L=self:titleEntries()
for v,D in ipairs(L)do
local l=d(D)
local u=k.menuY+(v-1)*k.menuStep
if self:canChoose(D)then
i(b,l,g,u)
else
b:textCentre(l,g,u,s.r,s.g,s.b,1)
end
if v==self.menuIndex then
C(b,g-math.floor(b:textWidth(l)/2),u)
end
end
end

function a:drawOptions(g)
q(g)
local b=R
i(g,d("Options"),f/2,b.titleY)
for v,D in ipairs(J)do
local l=b.firstY+(v-1)*b.step
n(g,d(D),b.labelX,l)
local u
if D=="Difficulty"then
u=d(F.LEVELS[self.setup.difficulty].text)
else
u=d((self.options.music and"On"or"Off"))
end
r(g,"< "..u.." >",b.valueX,l)
if v==self.optionIndex then
C(g,b.labelX,l)
end
end
end

function a:drawWaiting(b)
q(b)
local u=string.rep(".",math.floor(self.clock/20)%4)
local g=b:wrapText(d("Waiting"),f-20)
local l=math.floor((M-#g*b:lineHeight())/2)-8
for v,D in ipairs(g)do
i(b,D,f/2,l+(v-1)*b:lineHeight())
end
i(b,u,f/2,l+#g*b:lineHeight())
end

function a:drawSelect(g)
q(g)
i(g,d("SelectFighter"),f/2,N.titleY)
local b=j.size
for l=1,m.COUNT do
local L=(l-1)%j.columns
local P=math.floor((l-1)/j.columns)
local u=j.left+L*(b+j.gap)
local v=j.top+P*(b+j.gap)
local Q=l==self.cursor
if Q then
g:rect(u-1,v-1,b+2,b+2,e.r,e.g,e.b,1)
end
g:rect(u,v,b,b,s.r,s.g,s.b,1)
g:layers(self.portraits,(l-1)*b,b,b,u,v,G)
local D=nil
if self.twoPlayer then
if self.myChoice==l then
D=tostring(self:mySide()).."P"
elseif self.peerChoice==l then
D=tostring(3-self:mySide()).."P"
end
end
if D then
g:rect(u,v,16,12,h.r,h.g,h.b,1)
n(g,D,u,v-4)
end
end
i(g,m.LIST[self.cursor].name,f/2,N.nameY)
end

function a:drawVersus(b)
q(b)
local g,l=self:pairing()
self:drawFighterAt(b,g,self:idleFrame(),o.leftX,o.feetY,1)
self:drawFighterAt(b,l,self:idleFrame(),o.rightX,o.feetY,-1)
n(b,g.name,6,o.nameY)
r(b,l.name,f-6,o.nameY)
i(b,"VS",f/2,o.vsY)
end

function a:drawResult(g)
self.match:draw(g,self.matchArt,a.haloCentre)
local b
if self.resultText=="Wins"then
b=d("Wins",self.resultName)
else
b=d(self.resultText)
end
a.haloCentre(g,b,f/2,44)
end

function a:drawQuestion(b,P,Q,u,v,D)
local l=f/2
i(b,P,l,Q)
local Z={{text="Yes",x=l-v,chosen=D},{text="No",x=l+v,chosen=not D}}
for _,g in ipairs(Z)do
local L=d(g.text)
i(b,L,g.x,u)
if g.chosen then
C(b,g.x-math.floor(b:textWidth(L)/2),u)
end
end
end

function a:drawContinue(b)
q(b)
self:drawQuestion(b,d("Continue"),x.titleY,x.choicesY,x.gap,self.continueYes)
i(b,tostring(math.max(0,self.continueCount)),f/2,x.countY)
end

function a:drawOver(b)
q(b)
i(b,d("GameOver"),f/2,44)
end

function a:drawEnding(b)
b:clear(e.r,e.g,e.b)
self.matchArt.stage:draw(b,0)
self:drawFighterAt(b,self:myFighter(),"win",f/2,y.feetY-6,1)
b:rect(0,y.bandY,f,y.bandHeight,h.r,h.g,h.b,1)
i(b,d("Champion"),f/2,y.titleY)
end

local function P(g)
local b=""
for l,u in ipairs(g)do
if l>1 then
b=b.." "
end
b=b..B(E.NORMALS[u].input)
end
return b
end

local function D(b,l,u,g)
n(b,l,z.labelX+8,g)
r(b,u,z.inputX,g)
end

function a:drawMoveList(l)
q(l)
local g=z
local u=self:myFighter()
local L=self.movePage
local Q=u.name
if L<g.pages then
Q=d("StandardMoves")
end
i(l,Q,f/2,g.titleY)
n(l,string.char(0x25C0),g.arrowX,g.titleY)
r(l,string.char(0x25B6),f-g.arrowX,g.titleY)
local b=g.headerY
if L==1 then
for Z,v in ipairs(m.STANDARD_MOVES)do
D(l,d(v.text),B(E.NORMALS[v.move].input),b)
b=b+g.step
end
elseif L==2 then
for _,v in ipairs(m.STANDARD_EXTRAS)do
local Z=v.input and B(v.input)or B(E.NORMALS[v.move].input)
D(l,d(v.text),Z,b)
b=b+g.step
end
b=b+4
n(l,d("Combos"),g.labelX,b)
b=b+g.step
for Z,v in ipairs(m.STANDARD_CHAINS)do
r(l,P(v),g.inputX,b)
b=b+g.step
end
else
n(l,d("SpecialMoves"),g.labelX,b)
b=b+g.step+2
for Z,v in ipairs(u.specials)do
D(l,d(v.text),O(v),b)
b=b+g.step+4
end
b=b+6
n(l,d("Combo"),g.labelX,b)
b=b+g.step
r(l,P(u.chain).." "..O(u.specials[1]),g.inputX,b)
end
end

function a:drawPause(g)
if self.pauseScreen==a.PAUSE_MOVES then
self:drawMoveList(g)
return
end
if self.pauseScreen==a.PAUSE_OPTIONS then
self:drawOptions(g)
return
end
local b=S
g:rect(b.x-1,b.y-1,b.width+2,b.height+2,e.r,e.g,e.b,1)
g:rect(b.x,b.y,b.width,b.height,h.r,h.g,h.b,1)
local l=f/2
i(g,d("Pause"),l,b.titleY)
for u,Q in ipairs(I)do
local v=b.firstY+(u-1)*b.step
local L=d(Q)
i(g,L,l,v)
if u==self.pauseIndex then
C(g,l-math.floor(g:textWidth(L)/2),v)
end
end
end
