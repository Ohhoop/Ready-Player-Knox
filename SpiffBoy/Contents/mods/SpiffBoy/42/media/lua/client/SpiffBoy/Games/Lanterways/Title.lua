require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local b=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local e=a.Window
local f=a.SaveGame
local p=a.Party
local i=a.Music

local k={"NewJourney","Continue","MenuOptions"}
local q={"NewJourney","Continue","NewJourneyPlus","MenuOptions"}
local d={logoX=10,logoY=6,logoW=160,logoH=40,lampX={34,76,118},lampXPlus={22,62,102,142},lampY=92,labelY=70}
local l={lineTicks=150,scroll=0.35}
local j={
"End1","End2","End3","End4","End5","End6","End7","End8","End9","End10","End11","End12",
}

function b:slotSummary(g)
local c=self.save.slots
if type(c)~="table"or c[g]==nil then
return nil
end
return f.summary(c[g])
end

function b:slotValid(c)
return self:slotSummary(c)~=nil
end

function b:slotCleared(g)
local c=self:slotSummary(g)
return c~=nil and c.cleared
end

function b:anyCleared()
for c=1,f.SLOTS do
if self:slotCleared(c)then
return true
end
end
return false
end

function b:titleEntries()
if self:anyCleared()then
return q
end
return k
end

function b:anySlot()
for c=1,f.SLOTS do
if self:slotValid(c)then
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
self:playMusic(i.TITLE)
end

function b:tickTitleSlots(c)
local g=a.verticalStep(c)
if g~=0 then
self.loadIndex=a.wrap(self.loadIndex+g,f.SLOTS)
self:effect("cursor")
end
if c.b then
self.titleScreen="main"
self:effect("cancel")
return false
end
return c.a
end

function b:tickTitle(h)
if not h then
return
end
local c=h.pressed
if self.titleScreen=="plus"then
if self:tickTitleSlots(c)then
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
if self:tickTitleSlots(c)then
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
self:tickOptionsScreen(c)
if self.menu.screen=="main"then
self.titleScreen="main"
end
self.menu=nil
return
end
local m=self:titleEntries()
local n=a.horizontalStep(c)+a.verticalStep(c)
if n~=0 then
self.titleIndex=a.wrap(self.titleIndex+n,#m)
self:effect("cursor")
end
if c.a or c.start then
local g=m[self.titleIndex]
if g=="NewJourney"then
self:effect("lamp")
self:newJourney()
elseif g=="NewJourneyPlus"then
self:effect("confirm")
self.titleScreen="plus"
self.loadIndex=1
for o=f.SLOTS,1,-1 do
if self:slotCleared(o)then
self.loadIndex=o
end
end
elseif g=="Continue"then
if self:anySlot()then
self:effect("confirm")
self.titleScreen="load"
self.loadIndex=1
for o=f.SLOTS,1,-1 do
if self:slotValid(o)then
self.loadIndex=o
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

function b:drawTitle(c)
if self.titleScreen=="load"then
self:drawSlotList(c,self.loadIndex,true)
return
end
if self.titleScreen=="plus"then
self:drawSlotList(c,self.loadIndex,true,"PickCleared")
return
end
if self.titleScreen=="options"then
c:clear(a.shade(a.PAPER))
self.menu=self.titleOptions
self:drawOptionsScreen(c)
self.menu=nil
return
end
local r=self:art("title")
c:clear(a.shade(a.PAPER))
for g=1,3 do
c:sheet(r,0,(g-1)*a.HEIGHT,a.WIDTH,a.HEIGHT,0,0,1,g)
end
c:layers(self:art("logo"),0,d.logoW,d.logoH,d.logoX,d.logoY,{1,2,4})
local g=self:titleEntries()
local m=d.lampX
if#g>#k then
m=d.lampXPlus
end
local s=math.floor(self.clock/12)%2
for h in ipairs(g)do
local o=m[h]
local n=0
if h==self.titleIndex then
n=1+s
end
c:layers(self.artObjects,n*12,12,24,o,d.lampY,{1,2,3,4})
end
local n=a.text(g[self.titleIndex])
local o=a.INK
if g[self.titleIndex]=="Continue"and not self:anySlot()then
o=a.MID
end
local h=c:textWidth(n)+14
e.fill(c,(a.WIDTH-h)/2,d.labelY-1,h,18,a.PAPER)
e.textCentre(c,n,a.WIDTH/2,d.labelY,o)
e.icon(c,self.artUi,"arrowLeft",(a.WIDTH-h)/2-8,d.labelY+4,{1})
e.icon(c,self.artUi,"arrowRight",(a.WIDTH+h)/2+2,d.labelY+4,{1})
end

function b:drawOver(c)
c:clear(a.shade(a.INK))
local h=c:wrapText(a.text("GameOver"),a.WIDTH-20)
local g=40
for n,m in ipairs(h)do
e.textCentre(c,m,a.WIDTH/2,g,a.MID)
g=g+e.LINE
end
c:layers(self.artObjects,0,12,24,84,80,{2,3})
end

function b:startEnding()
self.mode=b.MODE_ENDING
self.ending={timer=0,line=1}
self:playMusic(i.ENDING)
end

function b:tickEnding(g)
local c=self.ending
c.timer=c.timer+1
if c.line<#j and c.timer>=l.lineTicks then
c.line=c.line+1
c.timer=0
end
if c.line>=#j and c.timer>l.lineTicks and g and(g.pressed.a or g.pressed.start)then
self:openFinishedSave()
end
end

function b:openFinishedSave()
self.mode=b.MODE_MENU
self.menu={screen="save",slotIndex=self.slot or 1,finishing=true}
self:playMusic(i.TITLE)
self:openText(nil,a.text("EndSaveAsk"))
end

function b:newJourneyFrom(c)
self.state=p.newStateFrom(c)
self.slot=nil
self.shadeShift=0
self:enterField(self.state.map,self.state.x,self.state.y,self.state.dir)
self:runScene("intro")
a.trace("journey started again, round "..self.state.ng)
end

function b:drawEnding(c)
local g=self.ending
c:clear(a.shade(a.PAPER))
local o=self:art("ending")
for h=1,3 do
c:sheet(o,0,(h-1)*a.HEIGHT,a.WIDTH,a.HEIGHT,0,0,1,h)
end
local r=j[g.line]
local h=c:wrapText(a.text(r),a.WIDTH-16)
local m=#h*e.LINE+8
local n=a.HEIGHT-m-2
if g.timer>12 then
e.frame(c,self.artUi,2,n,a.WIDTH-4,m)
for s,t in ipairs(h)do
e.textCentre(c,t,a.WIDTH/2,n+3+(s-1)*e.LINE)
end
end
end
