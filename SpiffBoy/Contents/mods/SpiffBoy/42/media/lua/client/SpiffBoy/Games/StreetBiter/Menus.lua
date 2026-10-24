require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Brain"
require"SpiffBoy/Games/StreetBiter/Music"

local a=SpiffBoyStreetBiterGame
local v=SpiffBoy.StreetBiter
local l=v.Roster
local E=v.Moves
local F=v.Brain
local c=v.Music

local e=SpiffBoy.Cartridges.SHADES[4]
local h=SpiffBoy.Cartridges.SHADES[1]
local r=SpiffBoy.Cartridges.SHADES[2]
local f=SpiffBoy.Cartridges.SCREEN_WIDTH
local L=SpiffBoy.Cartridges.SCREEN_HEIGHT
local d=a.gameText
local G={1,2,3,4}
local s={width=72,height=64,anchor=36}
local j={size=36,columns=4,gap=2,left=14,top=18}
local k={logoY=4,logoW=73,logoH=34,leftX=30,rightX=150,feetY=84,barY=84,menuY=84,menuStep=12}
local Q={titleY=4,firstY=34,step=24,labelX=14,valueX=166}
local M={titleY=2,nameY=90,markY=2}
local n={leftX=50,rightX=130,feetY=92,nameY=14,vsY=44}
local w={titleY=18,countY=44,choicesY=82,gap=32}
local z={bandY=14,bandHeight=26,titleY=18,feetY=110}
local R={x=16,y=20,width=148,height=84,titleY=24,firstY=44,step=14}
local A={titleY=2,headerY=18,step=12,labelX=8,inputX=172,arrowX=10,pages=3}
local S=30
local T=20
local U=180
local V={"idle1","idle2","idle3"}
local W=string.char(0x25B6)
local H={["1"]=0x2199,["2"]=0x2193,["3"]=0x2198,["4"]=0x2190,["6"]=0x2192,["7"]=0x2196,["8"]=0x2191,["9"]=0x2197}
local I={"Resume","MoveList","Options","ReturnToTitle"}
local J={"Difficulty","Music"}

local function o(value,count)
return(value-1+count)%count+1
end

local function B(pressed)
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

local function p(screen)
screen:clear(h.r,h.g,h.b)
end

local function m(screen,label,x,y)
screen:text(label,x,y,e.r,e.g,e.b,1)
end

local function i(screen,label,x,y)
screen:textCentre(label,x,y,e.r,e.g,e.b,1)
end

local function q(screen,label,x,y)
screen:textRight(label,x,y,e.r,e.g,e.b,1)
end

local function C(input)
local b=""
for t=1,string.len(input)do
local g=string.sub(input,t,t)
if H[g]then
b=b..string.char(H[g])
else
b=b..g
end
end
return b
end

local function N(special)
local b=""
for t,g in ipairs(l.MOTIONS[special.motion].label)do
b=b..string.char(H[tostring(g)])
end
return b..string.upper(special.button)
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

local X={"OnePlayer","TwoPlayers","Options"}

function a:titleEntries()
return X
end

function a:canChoose(entry)
return entry~="TwoPlayers"or self.port:isConnected()
end

function a:tickMenu(input)
local b=self.mode
if b==a.MODE_TITLE or b==a.MODE_OPTIONS or b==a.MODE_WAITING then
self:keepMusic(c.TITLE)
elseif b==a.MODE_SELECT or b==a.MODE_VERSUS then
self:keepMusic(c.SELECT)
end
if b==a.MODE_WAITING then
self:tickWaiting(input)
elseif b==a.MODE_VERSUS then
self:tickVersus()
elseif b==a.MODE_RESULT then
self:tickResult()
elseif b==a.MODE_OVER then
self:tickOver()
elseif b==a.MODE_CONTINUE then
self:tickContinue(input)
elseif not input then
return
elseif b==a.MODE_TITLE then
self:tickTitle(input)
elseif b==a.MODE_OPTIONS then
self:tickOptions(input,a.MODE_TITLE)
elseif b==a.MODE_SELECT then
self:tickSelect(input)
elseif b==a.MODE_ENDING then
self:tickEnding(input)
end
end

function a:tickTitle(input)
local b=input.pressed
local t=self:titleEntries()
local u=B(b)
if u~=0 then
self.menuIndex=o(self.menuIndex+u,#t)
self:effect(c.TICK)
end
if b.a or b.start then
local g=t[self.menuIndex]
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

function a:tickOptions(input,back)
local b=input.pressed
local g=B(b)
if g~=0 then
self.optionIndex=o(self.optionIndex+g,#J)
self:effect(c.TICK)
end
local t=K(b)
if t~=0 then
if J[self.optionIndex]=="Difficulty"then
self.setup.difficulty=o(self.setup.difficulty+t,#F.LEVELS)
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
if back==a.MODE_TITLE then
self.mode=a.MODE_TITLE
else
self.pauseScreen=a.PAUSE_MENU
end
end
end

function a:tickWaiting(input)
if self.clock%S==0 then
self.port:hello()
end
if input and input.pressed.b then
self:effect(c.CONFIRM)
self:openTitle()
end
end

function a:tickSelect(input)
local b=input.pressed
if self.twoPlayer and self.port:leads()and self.port:needsPing()and self.clock%T==0 then
self.port:ping(self.clock)
end
if self.myChoice then
return
end
local g=K(b)
local t=B(b)
if g~=0 then
local u=math.floor((self.cursor-1)/j.columns)
local x=o((self.cursor-1)%j.columns+1+g,j.columns)
self.cursor=u*j.columns+x
self:effect(c.TICK)
elseif t~=0 then
self.cursor=o(self.cursor+t*j.columns,l.COUNT)
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

function a:tickContinue(input)
if input then
local b=input.pressed
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

function a:tickEnding(input)
self.endingTimer=self.endingTimer+1
if self.endingTimer>U and(input.pressed.a or input.pressed.start)then
self:openTitle()
end
end

function a:tickPause(input)
if not input then
return
end
local b=input.pressed
if self.pauseScreen==a.PAUSE_OPTIONS then
self:tickOptions(input,a.PAUSE_MENU)
return
end
if self.pauseScreen==a.PAUSE_MOVES then
local g=K(b)
if g~=0 then
self.movePage=o(self.movePage+g,A.pages)
self:effect(c.TICK)
end
if b.a or b.b or b.start then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_MENU
end
return
end
local t=B(b)
if t~=0 then
self.pauseIndex=o(self.pauseIndex+t,#I)
self:effect(c.TICK)
end
if b.b or b.start then
self:resume()
return
end
if b.a then
local g=I[self.pauseIndex]
if g=="Resume"then
self:resume()
elseif g=="MoveList"then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_MOVES
self.movePage=1
elseif g=="Options"then
self:effect(c.CONFIRM)
self.pauseScreen=a.PAUSE_OPTIONS
self.optionIndex=1
else
self:effect(c.CONFIRM)
self:openTitle()
end
end
end

function a:drawMenu(screen)
local b=self.mode
if b==a.MODE_TITLE then
self:drawTitle(screen)
elseif b==a.MODE_OPTIONS then
self:drawOptions(screen)
elseif b==a.MODE_WAITING then
self:drawWaiting(screen)
elseif b==a.MODE_SELECT then
self:drawSelect(screen)
elseif b==a.MODE_VERSUS then
self:drawVersus(screen)
elseif b==a.MODE_RESULT then
self:drawResult(screen)
elseif b==a.MODE_CONTINUE then
self:drawContinue(screen)
elseif b==a.MODE_OVER then
self:drawOver(screen)
elseif b==a.MODE_ENDING then
self:drawEnding(screen)
end
end

function a:drawFighterAt(screen,definition,frame,x,feetY,facing)
local b,g=l.cellOf(frame,facing)
screen:layers(self.sheets[definition.id][b],g*s.width,s.width,s.height,x-s.anchor,feetY-s.height+1,G)
end

function a:idleFrame()
return V[math.floor(self.clock/30)%3+1]
end

local function D(screen,x,y)
q(screen,W,x-4,y)
end

function a:drawTitle(screen)
screen:clear(e.r,e.g,e.b)
screen:layers(self.logo,0,k.logoW,k.logoH,math.floor((f-k.logoW)/2),k.logoY,G)
self:drawFighterAt(screen,l.LIST[1],self:idleFrame(),k.leftX,k.feetY,1)
self:drawFighterAt(screen,l.LIST[5],self:idleFrame(),k.rightX,k.feetY,-1)
screen:rect(0,k.barY,f,L-k.barY,h.r,h.g,h.b,1)
local b=f/2
local y=self:titleEntries()
for u,x in ipairs(y)do
local g=d(x)
local t=k.menuY+(u-1)*k.menuStep
if self:canChoose(x)then
i(screen,g,b,t)
else
screen:textCentre(g,b,t,r.r,r.g,r.b,1)
end
if u==self.menuIndex then
D(screen,b-math.floor(screen:textWidth(g)/2),t)
end
end
end

function a:drawOptions(screen)
p(screen)
local b=Q
i(screen,d("Options"),f/2,b.titleY)
for u,x in ipairs(J)do
local g=b.firstY+(u-1)*b.step
m(screen,d(x),b.labelX,g)
local t
if x=="Difficulty"then
t=d(F.LEVELS[self.setup.difficulty].text)
else
t=d((self.options.music and"On"or"Off"))
end
q(screen,"< "..t.." >",b.valueX,g)
if u==self.optionIndex then
D(screen,b.labelX,g)
end
end
end

function a:drawWaiting(screen)
p(screen)
local t=string.rep(".",math.floor(self.clock/20)%4)
local b=screen:wrapText(d("Waiting"),f-20)
local g=math.floor((L-#b*screen:lineHeight())/2)-8
for u,x in ipairs(b)do
i(screen,x,f/2,g+(u-1)*screen:lineHeight())
end
i(screen,t,f/2,g+#b*screen:lineHeight())
end

function a:drawSelect(screen)
p(screen)
i(screen,d("SelectFighter"),f/2,M.titleY)
local b=j.size
for g=1,l.COUNT do
local y=(g-1)%j.columns
local O=math.floor((g-1)/j.columns)
local t=j.left+y*(b+j.gap)
local u=j.top+O*(b+j.gap)
local P=g==self.cursor
if P then
screen:rect(t-1,u-1,b+2,b+2,e.r,e.g,e.b,1)
end
screen:rect(t,u,b,b,r.r,r.g,r.b,1)
screen:layers(self.portraits,(g-1)*b,b,b,t,u,G)
local x=nil
if self.twoPlayer then
if self.myChoice==g then
x=tostring(self:mySide()).."P"
elseif self.peerChoice==g then
x=tostring(3-self:mySide()).."P"
end
end
if x then
screen:rect(t,u,16,12,h.r,h.g,h.b,1)
m(screen,x,t,u-4)
end
end
i(screen,l.LIST[self.cursor].name,f/2,M.nameY)
end

function a:drawVersus(screen)
p(screen)
local b,g=self:pairing()
self:drawFighterAt(screen,b,self:idleFrame(),n.leftX,n.feetY,1)
self:drawFighterAt(screen,g,self:idleFrame(),n.rightX,n.feetY,-1)
m(screen,b.name,6,n.nameY)
q(screen,g.name,f-6,n.nameY)
i(screen,"VS",f/2,n.vsY)
end

function a:drawResult(screen)
self.match:draw(screen,self.matchArt,a.haloCentre)
local b
if self.resultText=="Wins"then
b=d("Wins",self.resultName)
else
b=d(self.resultText)
end
a.haloCentre(screen,b,f/2,44)
end

function a:drawQuestion(screen,question,y,choicesY,gap,yes)
local g=f/2
i(screen,question,g,y)
local u={{text="Yes",x=g-gap,chosen=yes},{text="No",x=g+gap,chosen=not yes}}
for x,b in ipairs(u)do
local t=d(b.text)
i(screen,t,b.x,choicesY)
if b.chosen then
D(screen,b.x-math.floor(screen:textWidth(t)/2),choicesY)
end
end
end

function a:drawContinue(screen)
p(screen)
self:drawQuestion(screen,d("Continue"),w.titleY,w.choicesY,w.gap,self.continueYes)
i(screen,tostring(math.max(0,self.continueCount)),f/2,w.countY)
end

function a:drawOver(screen)
p(screen)
i(screen,d("GameOver"),f/2,44)
end

function a:drawEnding(screen)
screen:clear(e.r,e.g,e.b)
self.matchArt.stage:draw(screen,0)
self:drawFighterAt(screen,self:myFighter(),"win",f/2,z.feetY-6,1)
screen:rect(0,z.bandY,f,z.bandHeight,h.r,h.g,h.b,1)
i(screen,d("Champion"),f/2,z.titleY)
end

local function O(chain)
local b=""
for g,t in ipairs(chain)do
if g>1 then
b=b.." "
end
b=b..C(E.NORMALS[t].input)
end
return b
end

local function x(screen,label,input,y)
m(screen,label,A.labelX+8,y)
q(screen,input,A.inputX,y)
end

function a:drawMoveList(screen)
p(screen)
local g=A
local t=self:myFighter()
local y=self.movePage
local P=t.name
if y<g.pages then
P=d("StandardMoves")
end
i(screen,P,f/2,g.titleY)
m(screen,string.char(0x25C0),g.arrowX,g.titleY)
q(screen,string.char(0x25B6),f-g.arrowX,g.titleY)
local b=g.headerY
if y==1 then
for Y,u in ipairs(l.STANDARD_MOVES)do
x(screen,d(u.text),C(E.NORMALS[u.move].input),b)
b=b+g.step
end
elseif y==2 then
for Z,u in ipairs(l.STANDARD_EXTRAS)do
local Y=u.input and C(u.input)or C(E.NORMALS[u.move].input)
x(screen,d(u.text),Y,b)
b=b+g.step
end
b=b+4
m(screen,d("Combos"),g.labelX,b)
b=b+g.step
for Y,u in ipairs(l.STANDARD_CHAINS)do
q(screen,O(u),g.inputX,b)
b=b+g.step
end
else
m(screen,d("SpecialMoves"),g.labelX,b)
b=b+g.step+2
for Y,u in ipairs(t.specials)do
x(screen,d(u.text),N(u),b)
b=b+g.step+4
end
b=b+6
m(screen,d("Combo"),g.labelX,b)
b=b+g.step
q(screen,O(t.chain).." "..N(t.specials[1]),g.inputX,b)
end
end

function a:drawPause(screen)
if self.pauseScreen==a.PAUSE_MOVES then
self:drawMoveList(screen)
return
end
if self.pauseScreen==a.PAUSE_OPTIONS then
self:drawOptions(screen)
return
end
local b=R
screen:rect(b.x-1,b.y-1,b.width+2,b.height+2,e.r,e.g,e.b,1)
screen:rect(b.x,b.y,b.width,b.height,h.r,h.g,h.b,1)
local g=f/2
i(screen,d("Pause"),g,b.titleY)
for t,P in ipairs(I)do
local u=b.firstY+(t-1)*b.step
local y=d(P)
i(screen,y,g,u)
if t==self.pauseIndex then
D(screen,g-math.floor(screen:textWidth(y)/2),u)
end
end
end
