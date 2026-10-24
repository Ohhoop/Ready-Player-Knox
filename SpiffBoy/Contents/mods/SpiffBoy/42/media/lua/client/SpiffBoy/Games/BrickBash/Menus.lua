require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/BrickBash/Records"
require"SpiffBoy/Games/BrickBash/Music"

local a=SpiffBoyBrickBashGame
local K=SpiffBoy.BrickBash
local o=K.Records
local c=K.Music

local m=SpiffBoy.Cartridges.SHADES[4]
local d=SpiffBoy.Cartridges.SHADES[1]
local k=SpiffBoy.Cartridges.SCREEN_WIDTH
local S=SpiffBoy.Cartridges.SCREEN_HEIGHT
local f=a.gameText
local q=a.MODES
local L={1,2,3,4}

local w={"Play","HighScores","Options"}
local E={"MusicA","MusicB","MusicOff"}
local M=#E
local N={"On","MusicOff"}
local z={{key="music",text="Music",values=E},{key="effects",text="Effects",values=N},{action="clear",text="ClearScores"}}
local t={width=120,height=65,y=3,shades={1,2,3,4}}
local O={menuY=70,menuStep=15}
local e={cellW=12,cellH=6,kinds={0,1,2},shades={{2},{3},{2}},columns=15,rows=20}
local A={left=12,right=168,top=6,bottom=114}
local l={gap=6,size=5,top=6,bounce=3,period=24,shades={1,3,4}}
local b={signs={{left=4,top=22,right=88,bottom=56},{left=92,top=22,right=176,bottom=56}},nameY=3,bestY=18,batterX=68,batterY=70,batterWidth=44,batterHeight=48,aim={1,0},swingPose=2,ballX=92,ballY=86,ballSize=5,ballShades={1,2,3,4},flight=30,arc=30,flash=24,blink=4,swing=6}
local n={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=52}
local T={titleY=8,firstY=30,step=22,labelX=24,valueRight=152,arrowRight=160,arrowGap=2}
local r={y=30,width=140,choicesY=80,gap=32}
local g={titleY=8,arrowX=20,listY=28,bottom=112}
local h={titleY=10,scoreY=30,promptY=52,lettersY=80,spacing=20,cursorWidth=12,cursorHeight=2,width=150}
local F={ticks=15,count=4}
local U=30
local P="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local V=62
local B={delay=24,start=8,min=2,speedup=30}
local W=string.char(0x25B4)
local X=string.char(0x25BE)

local function s(value,count)
return(value-1+count)%count+1
end

local function u(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

local function G(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

local function C(screen,label,x,y)
screen:text(label,x,y,d.r,d.g,d.b,1)
end

local function i(screen,label,x,y)
screen:textCentre(label,x,y,d.r,d.g,d.b,1)
end

local function D(screen,label,x,y)
screen:textRight(label,x,y,d.r,d.g,d.b,1)
end

local function H(saved,key,count,first)
local j=type(saved)=="table"and saved[key]
if SpiffBoy.isInteger(j)and j>=1 and j<=count then
return j
end
return first
end

function a:readChoices()
self.setup={mode=H(self.save.setup,"mode",#q,1)}
self.options={
music=H(self.save.options,"music",#E,1),
effects=H(self.save.options,"effects",#N,1),
}
self.setupDirty=false
self.optionsDirty=false
self:applyMix()
end

function a:applyMix()
local j=self.options.effects==1 and 1 or 0
self.sequencer:setMix(1,j)
end

function a:chosenTrack()
if self.options.music==M then
return nil
end
return c.TRACKS[self.options.music]
end

function a:openTitle()
self.mode=a.MODE_TITLE
self.menuIndex=1
self.sequencer:stop()
end

function a:tickMenu(input)
if self.options.music~=M then
self:keepMusic(c.TITLE)
end
if self.mode==a.MODE_SETUP then
self:tickSwing()
end
if not input then
return
end
local j=self.mode
if j==a.MODE_TITLE then
self:tickTitle(input)
elseif j==a.MODE_SETUP then
self:tickSetup(input)
elseif j==a.MODE_OPTIONS then
self:tickOptions(input)
elseif j==a.MODE_CONFIRM then
self:tickConfirm(input)
elseif j==a.MODE_SCORES then
self:tickScores(input)
elseif j==a.MODE_INITIALS then
self:tickInitials(input)
end
end

function a:tickTitle(input)
local j=input.pressed
local p=u(j)
if p~=0 then
self.menuIndex=s(self.menuIndex+p,#w)
self:effect(c.TICK)
end
if j.a or j.start then
self:effect(c.CONFIRM)
local v=w[self.menuIndex]
if v=="Play"then
self:openSetup()
elseif v=="Options"then
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
self.swingTimer=0
end

function a:tickSwing()
if self.swingTimer<=0 then
return
end
self.swingTimer=self.swingTimer-1
if self.swingTimer==b.flash then
self:effect(c.WALL)
end
if self.swingTimer==0 then
self:startRun()
end
end

function a:tickSetup(input)
if self.swingTimer>0 then
return
end
local j=input.pressed
local p=G(j)
if p~=0 then
self.setup.mode=s(self.setup.mode+p,#q)
self.setupDirty=true
self:effect(c.TICK)
end
if j.a or j.start then
self:saveSetup()
self.swingTimer=b.swing+b.flight+b.flash
self:effect(c.LAUNCH)
elseif j.b then
self:saveSetup()
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:closeOptions()
if self.optionsDirty then
self.save.options={music=self.options.music,effects=self.options.effects}
self:persist()
self.optionsDirty=false
end
self.mode=a.MODE_TITLE
end

function a:turnOption(option,turn)
self.options[option.key]=s(self.options[option.key]+turn,#option.values)
self.optionsDirty=true
self:applyMix()
if option.key=="music"then
self.sequencer:stop()
end
self:effect(c.TICK)
end

function a:tickOptions(input)
local j=input.pressed
local v=u(j)
if v~=0 then
self.optionIndex=s(self.optionIndex+v,#z)
self:effect(c.TICK)
end
local p=z[self.optionIndex]
local x=G(j)
if x~=0 and p.key then
self:turnOption(p,x)
end
if j.b or j.start then
self:effect(c.CONFIRM)
self:closeOptions()
elseif j.a then
self:effect(c.CONFIRM)
if p.action then
self.confirmYes=false
self.mode=a.MODE_CONFIRM
else
self:closeOptions()
end
end
end

function a:tickConfirm(input)
local j=input.pressed
if j.left or j.right or j.up or j.down then
self.confirmYes=not self.confirmYes
self:effect(c.TICK)
end
if j.b then
self:effect(c.CONFIRM)
self.mode=a.MODE_OPTIONS
elseif j.a or j.start then
self:effect(c.CONFIRM)
if self.confirmYes then
self.records=o.read({})
self.flashRankIndex=nil
self:persistRecords()
end
self.mode=a.MODE_OPTIONS
end
end

function a:pageRecords(page)
return self.records[q[page].key]
end

function a:scoresVisible()
return math.floor((g.bottom-g.listY)/self.screen:lineHeight())
end

function a:showScores(page,rank)
self.mode=a.MODE_SCORES
self.scoresPage=page
self.scoresTop=SpiffBoy.clamp(rank,1,#self:pageRecords(page)-self:scoresVisible()+1)
end

function a:tickScores(input)
local j=input.pressed
local p=u(j)
local v=G(j)
if p~=0 then
local x=SpiffBoy.clamp(self.scoresTop+p,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if x~=self.scoresTop then
self.scoresTop=x
self:effect(c.TICK)
end
elseif v~=0 then
self.flashRankIndex=nil
self:showScores(s(self.scoresPage+v,#q),1)
self:effect(c.TICK)
elseif j.a or j.b or j.start then
self:effect(c.CONFIRM)
self.mode=a.MODE_TITLE
end
end

function a:offerRecord()
self.sequencer:stop()
if o.rankOf(self.records[self.modeKey],self.score)then
self.letters={1,1,1}
self.letterHoldStep=0
self.cursor=1
self.mode=a.MODE_INITIALS
return
end
self:openSetup()
end

function a:turnLetter(step)
self.letters[self.cursor]=s(self.letters[self.cursor]-step,V)
self:effect(c.TICK)
end

function a:repeatLetter(pressedStep,heldStep)
if pressedStep~=0 then
self:turnLetter(pressedStep)
self.letterHoldStep=pressedStep
self.letterHoldTicks=0
self.letterRepeatTimer=B.delay
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
self.letterRepeatTimer=math.max(B.min,B.start-math.floor(self.letterHoldTicks/B.speedup))
end
end

function a:tickInitials(input)
local j=input.pressed
self:repeatLetter(u(j),u(input.held))
if j.left and self.cursor>1 then
self.cursor=self.cursor-1
elseif j.right and self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
end
if j.a or j.start then
self:effect(c.CONFIRM)
if self.cursor<o.INITIALS_LENGTH then
self.cursor=self.cursor+1
else
local p=""
for v=1,o.INITIALS_LENGTH do
p=p..string.sub(P,self.letters[v],self.letters[v])
end
local v=o.insert(self.records[self.modeKey],p,self.score)
self:persistRecords()
self:showScores(self.setup.mode,v)
self.flashRankIndex=v
self.flashUntil=self.clock+F.ticks*F.count*2
end
end
end

function a:drawMenu(screen)
local j=self.mode
if j==a.MODE_TITLE then
self:drawTitle(screen)
elseif j==a.MODE_SETUP then
self:drawSetup(screen)
elseif j==a.MODE_OPTIONS then
self:drawOptions(screen)
elseif j==a.MODE_CONFIRM then
self:drawConfirm(screen)
elseif j==a.MODE_SCORES then
self:drawScores(screen)
else
self:drawInitials(screen)
end
end

function a:drawPointer(screen,right,y)
local p=self.clock%l.period
local j=l.period/2
local v=math.floor(l.bounce*(1-math.abs(p-j)/j))
screen:layers(self.art.ball,0,l.size,l.size,right-l.gap-l.size,y+l.top-v,l.shades)
end

function a:drawWall(screen)
screen:clear(m.r,m.g,m.b)
local I=self.art.bricks
for j=0,e.rows-1 do
local p=j*e.cellH
local J=p>=A.top and p<A.bottom
local Q=j%2==1 and e.cellW/2 or 0
for x=0,e.columns do
local v=x*e.cellW-Q
if not J or v<A.left or v+e.cellW>A.right then
local y=(x+j)%#e.kinds+1
screen:layers(I,e.kinds[y]*e.cellW,e.cellW,e.cellH,v,p,e.shades[y])
end
end
end
end

function a:drawTitle(screen)
screen:clear(m.r,m.g,m.b)
screen:layers(self.art.logo,0,t.width,t.height,math.floor((k-t.width)/2),t.y,t.shades)
local p=k/2
for j=1,#w do
local v=f(w[j])
local x=O.menuY+(j-1)*O.menuStep
i(screen,v,p,x)
if j==self.menuIndex then
self:drawPointer(screen,p-math.floor(screen:textWidth(v)/2),x)
end
end
end

function a:drawRecordRows(screen,list,first,last,top)
local p=k/2
local y=screen:lineHeight()
for v=first,last do
local I=list[v]
local x=top+(v-first)*y
local j=d
local J=self.mode==a.MODE_SCORES and v==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if J and math.floor((self.flashUntil-self.clock-1)/F.ticks)%2==1 then
screen:rect(p+n.left,x,n.right-n.left,y,d.r,d.g,d.b,1)
j=m
end
screen:textRight(tostring(v)..".",p+n.rank,x,j.r,j.g,j.b,1)
screen:text(I.initials,p+n.initials,x,j.r,j.g,j.b,1)
screen:textRight(tostring(I.score),p+n.score,x,j.r,j.g,j.b,1)
end
end

local function Y(screen,value,valueRight,arrowRight,gap,y)
D(screen,value,valueRight,y)
D(screen,"<",valueRight-screen:textWidth(value)-gap,y)
D(screen,">",arrowRight,y)
end

function a:drawSetup(screen)
local x=self.art
screen:layers(x.ballpark,0,k,S,0,0,L)
local v=b.swing+b.flight+b.flash-self.swingTimer
local y=self.swingTimer>0
local Z=y and v>=b.swing+b.flight
for I,j in ipairs(b.signs)do
local Q=math.floor((j.left+j.right)/2)
local p=d
local J=I==self.setup.mode
if J and Z then
J=math.floor(v/b.blink)%2==0
end
if J then
screen:rect(j.left+2,j.top+2,j.right-j.left-3,j.bottom-j.top-3,d.r,d.g,d.b,1)
p=m
end
local R=self:pageRecords(I)
local _=#R>0 and R[1].score or 0
screen:textCentre(f(q[I].text),Q,j.top+b.nameY,p.r,p.g,p.b,1)
screen:textCentre(tostring(_),Q,j.top+b.bestY,p.r,p.g,p.b,1)
end
local I=b.aim[self.setup.mode]
if y then
I=b.swingPose
end
screen:layers(x.batter,I*b.batterWidth,b.batterWidth,b.batterHeight,b.batterX,b.batterY,L)
if y and v>=b.swing and v<b.swing+b.flight then
local j=b.signs[self.setup.mode]
local p=(v-b.swing)/b.flight
local J=(j.left+j.right)/2
local Q=(j.top+j.bottom)/2
local R=b.ballX+(J-b.ballX)*p
local _=b.ballY+(Q-b.ballY)*p-b.arc*math.sin(p*math.pi)
screen:layers(x.ball,0,b.ballSize,b.ballSize,math.floor(R),math.floor(_),b.ballShades)
end
end

function a:drawOptions(screen)
self:drawWall(screen)
local j=T
i(screen,f("Options"),k/2,j.titleY)
for v=1,#z do
local p=z[v]
local x=j.firstY+(v-1)*j.step
C(screen,f(p.text),j.labelX,x)
if p.key then
Y(screen,f(p.values[self.options[p.key]]),j.valueRight,j.arrowRight,j.arrowGap,x)
end
if v==self.optionIndex then
self:drawPointer(screen,j.labelX,x)
end
end
end

function a:drawConfirm(screen)
self:drawWall(screen)
local p=k/2
local v=screen:wrapText(f("EraseScores"),r.width)
for j=1,#v do
i(screen,v[j],p,r.y+(j-1)*screen:lineHeight())
end
local y={{text="No",x=p-r.gap,chosen=not self.confirmYes},{text="Yes",x=p+r.gap,chosen=self.confirmYes}}
for I,j in ipairs(y)do
local x=f(j.text)
i(screen,x,j.x,r.choicesY)
if j.chosen then
self:drawPointer(screen,j.x-math.floor(screen:textWidth(x)/2),r.choicesY)
end
end
end

function a:drawScores(screen)
self:drawWall(screen)
local j=k/2
local v=screen:lineHeight()
local x=self.scoresPage
i(screen,f(q[x].text),j,g.titleY)
C(screen,"<",g.arrowX,g.titleY)
D(screen,">",k-g.arrowX,g.titleY)
local p=self:pageRecords(x)
if#p==0 then
i(screen,f("NoScores"),j,g.listY+v)
return
end
local y=self:scoresVisible()
local I=math.min(#p,self.scoresTop+y-1)
self:drawRecordRows(screen,p,self.scoresTop,I,g.listY)
if self.scoresTop>1 then
C(screen,W,j+n.arrow,g.listY)
end
if I<#p then
C(screen,X,j+n.arrow,g.listY+(y-1)*v)
end
end

function a:drawInitials(screen)
self:drawWall(screen)
local j=k/2
local v=screen:lineHeight()
i(screen,f("NewHighScore"),j,h.titleY)
i(screen,tostring(self.score),j,h.scoreY)
local x=screen:wrapText(f("EnterInitials"),h.width)
for p=1,#x do
i(screen,x[p],j,h.promptY+(p-1)*v)
end
for p=1,o.INITIALS_LENGTH do
local y=j+(p-2)*h.spacing
i(screen,string.sub(P,self.letters[p],self.letters[p]),y,h.lettersY)
if p==self.cursor and math.floor(self.clock/U)%2==0 then
screen:rect(y-h.cursorWidth/2,h.lettersY+v+1,h.cursorWidth,h.cursorHeight,d.r,d.g,d.b,1)
end
end
end
