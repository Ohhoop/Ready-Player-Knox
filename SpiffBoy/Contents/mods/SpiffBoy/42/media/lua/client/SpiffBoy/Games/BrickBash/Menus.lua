require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/BrickBash/Records"
require"SpiffBoy/Games/BrickBash/Music"

local a=SpiffBoyBrickBashGame
local L=SpiffBoy.BrickBash
local o=L.Records
local c=L.Music

local m=SpiffBoy.Cartridges.SHADES[4]
local d=SpiffBoy.Cartridges.SHADES[1]
local k=SpiffBoy.Cartridges.SCREEN_WIDTH
local T=SpiffBoy.Cartridges.SCREEN_HEIGHT
local f=a.gameText
local q=a.MODES
local M={1,2,3,4}

local x={"Play","HighScores","Options"}
local E={"MusicA","MusicB","MusicOff"}
local N=#E
local O={"On","MusicOff"}
local y={{key="music",text="Music",values=E},{key="effects",text="Effects",values=O},{action="clear",text="ClearScores"}}
local u={width=120,height=65,y=3,shades={1,2,3,4}}
local P={menuY=70,menuStep=15}
local e={cellW=12,cellH=6,kinds={0,1,2},shades={{2},{3},{2}},columns=15,rows=20}
local z={left=12,right=168,top=6,bottom=114}
local l={gap=6,size=5,top=6,bounce=3,period=24,shades={1,3,4}}
local b={signs={{left=4,top=22,right=88,bottom=56},{left=92,top=22,right=176,bottom=56}},nameY=3,bestY=18,batterX=68,batterY=70,batterWidth=44,batterHeight=48,aim={1,0},swingPose=2,ballX=92,ballY=86,ballSize=5,ballShades={1,2,3,4},flight=30,arc=30,flash=24,blink=4,swing=6}
local n={rank=-26,initials=-22,score=42,left=-44,right=46,arrow=52}
local U={titleY=8,firstY=30,step=22,labelX=24,valueRight=152,arrowRight=160,arrowGap=2}
local r={y=30,width=140,choicesY=80,gap=32}
local g={titleY=8,arrowX=20,listY=28,bottom=112}
local h={titleY=10,scoreY=30,promptY=52,lettersY=80,spacing=20,cursorWidth=12,cursorHeight=2,width=150}
local F={ticks=15,count=4}
local V=30
local Q="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
local W=62
local A={delay=24,start=8,min=2,speedup=30}
local X=string.char(0x25B4)
local Y=string.char(0x25BE)

local function s(j,i)
return(j-1+i)%i+1
end

local function v(i)
if i.up then
return-1
elseif i.down then
return 1
end
return 0
end

local function G(i)
if i.left then
return-1
elseif i.right then
return 1
end
return 0
end

local function B(i,j,p,t)
i:text(j,p,t,d.r,d.g,d.b,1)
end

local function i(j,p,t,w)
j:textCentre(p,t,w,d.r,d.g,d.b,1)
end

local function C(j,p,t,w)
j:textRight(p,t,w,d.r,d.g,d.b,1)
end

local function H(p,t,w,D)
local j=type(p)=="table"and p[t]
if SpiffBoy.isInteger(j)and j>=1 and j<=w then
return j
end
return D
end

function a:readChoices()
self.setup={mode=H(self.save.setup,"mode",#q,1)}
self.options={
music=H(self.save.options,"music",#E,1),
effects=H(self.save.options,"effects",#O,1),
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
if self.options.music==N then
return nil
end
return c.TRACKS[self.options.music]
end

function a:openTitle()
self.mode=a.MODE_TITLE
self.menuIndex=1
self.sequencer:stop()
end

function a:tickMenu(j)
if self.options.music~=N then
self:keepMusic(c.TITLE)
end
if self.mode==a.MODE_SETUP then
self:tickSwing()
end
if not j then
return
end
local p=self.mode
if p==a.MODE_TITLE then
self:tickTitle(j)
elseif p==a.MODE_SETUP then
self:tickSetup(j)
elseif p==a.MODE_OPTIONS then
self:tickOptions(j)
elseif p==a.MODE_CONFIRM then
self:tickConfirm(j)
elseif p==a.MODE_SCORES then
self:tickScores(j)
elseif p==a.MODE_INITIALS then
self:tickInitials(j)
end
end

function a:tickTitle(w)
local j=w.pressed
local p=v(j)
if p~=0 then
self.menuIndex=s(self.menuIndex+p,#x)
self:effect(c.TICK)
end
if j.a or j.start then
self:effect(c.CONFIRM)
local t=x[self.menuIndex]
if t=="Play"then
self:openSetup()
elseif t=="Options"then
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

function a:tickSetup(t)
if self.swingTimer>0 then
return
end
local j=t.pressed
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

function a:turnOption(j,p)
self.options[j.key]=s(self.options[j.key]+p,#j.values)
self.optionsDirty=true
self:applyMix()
if j.key=="music"then
self.sequencer:stop()
end
self:effect(c.TICK)
end

function a:tickOptions(D)
local j=D.pressed
local t=v(j)
if t~=0 then
self.optionIndex=s(self.optionIndex+t,#y)
self:effect(c.TICK)
end
local p=y[self.optionIndex]
local w=G(j)
if w~=0 and p.key then
self:turnOption(p,w)
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

function a:tickConfirm(p)
local j=p.pressed
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

function a:pageRecords(j)
return self.records[q[j].key]
end

function a:scoresVisible()
return math.floor((g.bottom-g.listY)/self.screen:lineHeight())
end

function a:showScores(j,p)
self.mode=a.MODE_SCORES
self.scoresPage=j
self.scoresTop=SpiffBoy.clamp(p,1,#self:pageRecords(j)-self:scoresVisible()+1)
end

function a:tickScores(D)
local j=D.pressed
local p=v(j)
local t=G(j)
if p~=0 then
local w=SpiffBoy.clamp(self.scoresTop+p,1,#self:pageRecords(self.scoresPage)-self:scoresVisible()+1)
if w~=self.scoresTop then
self.scoresTop=w
self:effect(c.TICK)
end
elseif t~=0 then
self.flashRankIndex=nil
self:showScores(s(self.scoresPage+t,#q),1)
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

function a:turnLetter(j)
self.letters[self.cursor]=s(self.letters[self.cursor]-j,W)
self:effect(c.TICK)
end

function a:repeatLetter(j,p)
if j~=0 then
self:turnLetter(j)
self.letterHoldStep=j
self.letterHoldTicks=0
self.letterRepeatTimer=A.delay
return
end
if p==0 or p~=self.letterHoldStep then
self.letterHoldStep=0
return
end
self.letterHoldTicks=self.letterHoldTicks+1
self.letterRepeatTimer=self.letterRepeatTimer-1
if self.letterRepeatTimer<=0 then
self:turnLetter(p)
self.letterRepeatTimer=math.max(A.min,A.start-math.floor(self.letterHoldTicks/A.speedup))
end
end

function a:tickInitials(t)
local j=t.pressed
self:repeatLetter(v(j),v(t.held))
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
for w=1,o.INITIALS_LENGTH do
p=p..string.sub(Q,self.letters[w],self.letters[w])
end
local w=o.insert(self.records[self.modeKey],p,self.score)
self:persistRecords()
self:showScores(self.setup.mode,w)
self.flashRankIndex=w
self.flashUntil=self.clock+F.ticks*F.count*2
end
end
end

function a:drawMenu(j)
local p=self.mode
if p==a.MODE_TITLE then
self:drawTitle(j)
elseif p==a.MODE_SETUP then
self:drawSetup(j)
elseif p==a.MODE_OPTIONS then
self:drawOptions(j)
elseif p==a.MODE_CONFIRM then
self:drawConfirm(j)
elseif p==a.MODE_SCORES then
self:drawScores(j)
else
self:drawInitials(j)
end
end

function a:drawPointer(p,t,w)
local D=self.clock%l.period
local j=l.period/2
local I=math.floor(l.bounce*(1-math.abs(D-j)/j))
p:layers(self.art.ball,0,l.size,l.size,t-l.gap-l.size,w+l.top-I,l.shades)
end

function a:drawWall(w)
w:clear(m.r,m.g,m.b)
local J=self.art.bricks
for j=0,e.rows-1 do
local p=j*e.cellH
local K=p>=z.top and p<z.bottom
local R=j%2==1 and e.cellW/2 or 0
for D=0,e.columns do
local t=D*e.cellW-R
if not K or t<z.left or t+e.cellW>z.right then
local I=(D+j)%#e.kinds+1
w:layers(J,e.kinds[I]*e.cellW,e.cellW,e.cellH,t,p,e.shades[I])
end
end
end
end

function a:drawTitle(j)
j:clear(m.r,m.g,m.b)
j:layers(self.art.logo,0,u.width,u.height,math.floor((k-u.width)/2),u.y,u.shades)
local t=k/2
for p=1,#x do
local w=f(x[p])
local D=P.menuY+(p-1)*P.menuStep
i(j,w,t,D)
if p==self.menuIndex then
self:drawPointer(j,t-math.floor(j:textWidth(w)/2),D)
end
end
end

function a:drawRecordRows(p,R,I,S,Z)
local t=k/2
local J=p:lineHeight()
for w=I,S do
local K=R[w]
local D=Z+(w-I)*J
local j=d
local _=self.mode==a.MODE_SCORES and w==self.flashRankIndex and self.flashUntil and self.clock<self.flashUntil
if _ and math.floor((self.flashUntil-self.clock-1)/F.ticks)%2==1 then
p:rect(t+n.left,D,n.right-n.left,J,d.r,d.g,d.b,1)
j=m
end
p:textRight(tostring(w)..".",t+n.rank,D,j.r,j.g,j.b,1)
p:text(K.initials,t+n.initials,D,j.r,j.g,j.b,1)
p:textRight(tostring(K.score),t+n.score,D,j.r,j.g,j.b,1)
end
end

local function Z(j,t,w,D,I,p)
C(j,t,w,p)
C(j,"<",w-j:textWidth(t)-I,p)
C(j,">",D,p)
end

function a:drawSetup(t)
local D=self.art
t:layers(D.ballpark,0,k,T,0,0,M)
local w=b.swing+b.flight+b.flash-self.swingTimer
local I=self.swingTimer>0
local _=I and w>=b.swing+b.flight
for J,j in ipairs(b.signs)do
local R=math.floor((j.left+j.right)/2)
local p=d
local K=J==self.setup.mode
if K and _ then
K=math.floor(w/b.blink)%2==0
end
if K then
t:rect(j.left+2,j.top+2,j.right-j.left-3,j.bottom-j.top-3,d.r,d.g,d.b,1)
p=m
end
local S=self:pageRecords(J)
local aa=#S>0 and S[1].score or 0
t:textCentre(f(q[J].text),R,j.top+b.nameY,p.r,p.g,p.b,1)
t:textCentre(tostring(aa),R,j.top+b.bestY,p.r,p.g,p.b,1)
end
local J=b.aim[self.setup.mode]
if I then
J=b.swingPose
end
t:layers(D.batter,J*b.batterWidth,b.batterWidth,b.batterHeight,b.batterX,b.batterY,M)
if I and w>=b.swing and w<b.swing+b.flight then
local j=b.signs[self.setup.mode]
local p=(w-b.swing)/b.flight
local K=(j.left+j.right)/2
local R=(j.top+j.bottom)/2
local S=b.ballX+(K-b.ballX)*p
local aa=b.ballY+(R-b.ballY)*p-b.arc*math.sin(p*math.pi)
t:layers(D.ball,0,b.ballSize,b.ballSize,math.floor(S),math.floor(aa),b.ballShades)
end
end

function a:drawOptions(p)
self:drawWall(p)
local j=U
i(p,f("Options"),k/2,j.titleY)
for w=1,#y do
local t=y[w]
local D=j.firstY+(w-1)*j.step
B(p,f(t.text),j.labelX,D)
if t.key then
Z(p,f(t.values[self.options[t.key]]),j.valueRight,j.arrowRight,j.arrowGap,D)
end
if w==self.optionIndex then
self:drawPointer(p,j.labelX,D)
end
end
end

function a:drawConfirm(j)
self:drawWall(j)
local t=k/2
local w=j:wrapText(f("EraseScores"),r.width)
for p=1,#w do
i(j,w[p],t,r.y+(p-1)*j:lineHeight())
end
local I={{text="No",x=t-r.gap,chosen=not self.confirmYes},{text="Yes",x=t+r.gap,chosen=self.confirmYes}}
for J,p in ipairs(I)do
local D=f(p.text)
i(j,D,p.x,r.choicesY)
if p.chosen then
self:drawPointer(j,p.x-math.floor(j:textWidth(D)/2),r.choicesY)
end
end
end

function a:drawScores(j)
self:drawWall(j)
local p=k/2
local w=j:lineHeight()
local D=self.scoresPage
i(j,f(q[D].text),p,g.titleY)
B(j,"<",g.arrowX,g.titleY)
C(j,">",k-g.arrowX,g.titleY)
local t=self:pageRecords(D)
if#t==0 then
i(j,f("NoScores"),p,g.listY+w)
return
end
local I=self:scoresVisible()
local J=math.min(#t,self.scoresTop+I-1)
self:drawRecordRows(j,t,self.scoresTop,J,g.listY)
if self.scoresTop>1 then
B(j,X,p+n.arrow,g.listY)
end
if J<#t then
B(j,Y,p+n.arrow,g.listY+(I-1)*w)
end
end

function a:drawInitials(j)
self:drawWall(j)
local p=k/2
local w=j:lineHeight()
i(j,f("NewHighScore"),p,h.titleY)
i(j,tostring(self.score),p,h.scoreY)
local D=j:wrapText(f("EnterInitials"),h.width)
for t=1,#D do
i(j,D[t],p,h.promptY+(t-1)*w)
end
for t=1,o.INITIALS_LENGTH do
local I=p+(t-2)*h.spacing
i(j,string.sub(Q,self.letters[t],self.letters[t]),I,h.lettersY)
if t==self.cursor and math.floor(self.clock/V)%2==0 then
j:rect(I-h.cursorWidth/2,h.lettersY+w+1,h.cursorWidth,h.cursorHeight,d.r,d.g,d.b,1)
end
end
end
