require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local b=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local d=a.Window
local f=a.SaveGame
local o=a.Party
local h=a.Music

local j={"NewJourney","Continue","MenuOptions"}
local p={"NewJourney","Continue","NewJourneyPlus","MenuOptions"}
local c={logoX=10,logoY=6,logoW=160,logoH=40,lampX={34,76,118},lampXPlus={22,62,102,142},lampY=92,labelY=70}
local k={lineTicks=150,scroll=0.35}
local i={
"End1","End2","End3","End4","End5","End6","End7","End8","End9","End10","End11","End12",
}

function b:slotSummary(slot)
local e=self.save.slots
if type(e)~="table"or e[slot]==nil then
return nil
end
return f.summary(e[slot])
end

function b:slotValid(slot)
return self:slotSummary(slot)~=nil
end

function b:slotCleared(slot)
local e=self:slotSummary(slot)
return e~=nil and e.cleared
end

function b:anyCleared()
for e=1,f.SLOTS do
if self:slotCleared(e)then
return true
end
end
return false
end

function b:titleEntries()
if self:anyCleared()then
return p
end
return j
end

function b:anySlot()
for e=1,f.SLOTS do
if self:slotValid(e)then
return true
end
end
return false
end

function b:openTitle()
self.mode=b.MODE_TITLE
self.titleScreen="main"
self.titleIndex=self:anySlot()and 2 or 1
self.field=nil
self.script=nil
self.dialog=nil
self.choice=nil
self.state=nil
self.shadeShift=0
self.fade={level=0,target=0,done=true}
self:playMusic(h.TITLE)
end

function b:tickTitleSlots(pressed)
local e=a.verticalStep(pressed)
if e~=0 then
self.loadIndex=a.wrap(self.loadIndex+e,f.SLOTS)
self:effect("cursor")
end
if pressed.b then
self.titleScreen="main"
self:effect("cancel")
return false
end
return pressed.a
end

function b:tickTitle(input)
if not input then
return
end
local e=input.pressed
if self.titleScreen=="plus"then
if self:tickTitleSlots(e)then
if self:slotCleared(self.loadIndex)then
self:effect("lamp")
self:newJourneyFrom(f.decode(self.save.slots[self.loadIndex]))
else
self:effect("buzz")
end
end
return
end
if self.titleScreen=="load"then
if self:tickTitleSlots(e)then
if self:slotValid(self.loadIndex)then
self:effect("confirm")
local g=f.decode(self.save.slots[self.loadIndex])
self:loadJourney(g,self.loadIndex)
else
self:effect("buzz")
end
end
return
end
if self.titleScreen=="options"then
self.menu=self.titleOptions
self:tickOptionsScreen(e)
if self.menu.screen=="main"then
self.titleScreen="main"
end
self.menu=nil
return
end
local l=self:titleEntries()
local m=a.horizontalStep(e)+a.verticalStep(e)
if m~=0 then
self.titleIndex=a.wrap(self.titleIndex+m,#l)
self:effect("cursor")
end
if e.a or e.start then
local g=l[self.titleIndex]
if g=="NewJourney"then
self:effect("lamp")
self:newJourney()
elseif g=="NewJourneyPlus"then
self:effect("confirm")
self.titleScreen="plus"
self.loadIndex=1
for n=f.SLOTS,1,-1 do
if self:slotCleared(n)then
self.loadIndex=n
end
end
elseif g=="Continue"then
if self:anySlot()then
self:effect("confirm")
self.titleScreen="load"
self.loadIndex=1
for n=f.SLOTS,1,-1 do
if self:slotValid(n)then
self.loadIndex=n
end
end
else
self:effect("buzz")
end
else
self:effect("confirm")
self.titleOptions={screen="options",option=1}
self.titleScreen="options"
end
end
end

function b:drawTitle(screen)
if self.titleScreen=="load"then
self:drawSlotList(screen,self.loadIndex,true)
return
end
if self.titleScreen=="plus"then
self:drawSlotList(screen,self.loadIndex,true,"PickCleared")
return
end
if self.titleScreen=="options"then
screen:clear(a.shade(a.PAPER))
self.menu=self.titleOptions
self:drawOptionsScreen(screen)
self.menu=nil
return
end
local q=self:art("title")
screen:clear(a.shade(a.PAPER))
for e=1,3 do
screen:sheet(q,0,(e-1)*a.HEIGHT,a.WIDTH,a.HEIGHT,0,0,1,e)
end
screen:layers(self:art("logo"),0,c.logoW,c.logoH,c.logoX,c.logoY,{1,2,4})
local e=self:titleEntries()
local l=c.lampX
if#e>#j then
l=c.lampXPlus
end
local r=math.floor(self.clock/12)%2
for g in ipairs(e)do
local n=l[g]
local m=0
if g==self.titleIndex then
m=1+r
end
screen:layers(self.artObjects,m*12,12,24,n,c.lampY,{1,2,3,4})
end
local m=a.text(e[self.titleIndex])
local n=a.INK
if e[self.titleIndex]=="Continue"and not self:anySlot()then
n=a.MID
end
local g=screen:textWidth(m)+14
d.fill(screen,(a.WIDTH-g)/2,c.labelY-1,g,18,a.PAPER)
d.textCentre(screen,m,a.WIDTH/2,c.labelY,n)
d.icon(screen,self.artUi,"arrowLeft",(a.WIDTH-g)/2-8,c.labelY+4,{1})
d.icon(screen,self.artUi,"arrowRight",(a.WIDTH+g)/2+2,c.labelY+4,{1})
end

function b:drawOver(screen)
screen:clear(a.shade(a.INK))
local g=screen:wrapText(a.text("GameOver"),a.WIDTH-20)
local e=40
for m,l in ipairs(g)do
d.textCentre(screen,l,a.WIDTH/2,e,a.MID)
e=e+d.LINE
end
screen:layers(self.artObjects,0,12,24,84,80,{2,3})
end

function b:startEnding()
self.mode=b.MODE_ENDING
self.ending={timer=0,line=1}
self:playMusic(h.ENDING)
end

function b:tickEnding(input)
local e=self.ending
e.timer=e.timer+1
if e.line<#i and e.timer>=k.lineTicks then
e.line=e.line+1
e.timer=0
end
if e.line>=#i and e.timer>k.lineTicks and input and(input.pressed.a or input.pressed.start)then
self:openFinishedSave()
end
end

function b:openFinishedSave()
self.mode=b.MODE_MENU
self.menu={screen="save",slotIndex=self.slot or 1,finishing=true}
self:playMusic(h.TITLE)
self:openText(nil,a.text("EndSaveAsk"))
end

function b:newJourneyFrom(finished)
self.state=o.newStateFrom(finished)
self.slot=nil
self.shadeShift=0
self:enterField(self.state.map,self.state.x,self.state.y,self.state.dir)
self:runScene("intro")
a.trace("journey started again, round "..self.state.ng)
end

function b:drawEnding(screen)
local e=self.ending
screen:clear(a.shade(a.PAPER))
local n=self:art("ending")
for g=1,3 do
screen:sheet(n,0,(g-1)*a.HEIGHT,a.WIDTH,a.HEIGHT,0,0,1,g)
end
local q=i[e.line]
local g=screen:wrapText(a.text(q),a.WIDTH-16)
local l=#g*d.LINE+8
local m=a.HEIGHT-l-2
if e.timer>12 then
d.frame(screen,self.artUi,2,m,a.WIDTH-4,l)
for r,s in ipairs(g)do
d.textCentre(screen,s,a.WIDTH/2,m+3+(r-1)*d.LINE)
end
end
end
