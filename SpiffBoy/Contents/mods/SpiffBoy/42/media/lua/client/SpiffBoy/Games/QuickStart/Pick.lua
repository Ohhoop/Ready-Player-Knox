require"SpiffBoy/Games/QuickStart/Game"

local c=SpiffBoyQuickStartGame
local a=SpiffBoy.QuickStart
local m=a.Atlas
local k=a.Roster
local d=a.Race
local n=a.GrandPrix
local s=a.Records
local h=a.Music
local j=a.Hud
local q=a.View

local l=math.floor
local e=a.WIDTH
local r=a.HEIGHT
local g=c.pressed

c.PICK={
columns=4,
cellW=44,
cellH=34,
gridX=2,
gridY=4,
spinTicks=8,
outlineX={6,50,94,138},
outlineY=30,
demoCc=3,
demoDriver="spiffo",
demoReserve=70,
arenaMargin=4,
boxPad=4,
}

local b=c.PICK

function c:openDrivers()
self.screen=c.SCREEN_DRIVERS
self.driverCursor=self.myDriver or self.driverCursor or 1
self.myDriver=nil
self.peerDriver=nil
self.pickClock=0
self:music(h.SELECT)
end

function c:tick_drivers(input)
self.pickClock=self.pickClock+1
if self.twoPlayer and self.port:leads()and self.port:needsPing()then
self.port:ping(self.clock)
end
if self.myDriver then
if g(input,"b")and not self.twoPlayer then
self.myDriver=nil
end
return
end
local i=#k.LIST
local f=self.driverCursor
if g(input,"left")then
f=a.wrapIndex(f-1,i)
elseif g(input,"right")then
f=f%i+1
elseif g(input,"up")or g(input,"down")then
f=(f-1+b.columns)%i+1
end
if f~=self.driverCursor then
self.driverCursor=f
self:effect(h.TICK)
end
if g(input,"a")then
self:effect(h.CONFIRM)
self.myDriver=self.driverCursor
self.data.last.driver=self.myDriver
if self.twoPlayer then
self.port:sendChoice(self.myDriver)
self:maybeStartLinked()
else
self:startSoloRace()
end
elseif g(input,"b")and not self.twoPlayer then
self:effect(h.BACK)
self:openMap()
end
end

function c:draw_drivers(screen)
self:fill(screen,a.PAPER,0,0,e,r)
local f=m.portraits
for i,t in ipairs(k.LIST)do
local u,v=(i-1)%b.columns,l((i-1)/b.columns)
local o,p=b.gridX+u*b.cellW,b.gridY+v*b.cellH
if i==self.driverCursor then
self:fill(screen,a.INK,o,p,b.cellW-2,b.cellH-2)
self:fill(screen,self.myDriver and a.MID or a.DARK,o+1,p+1,b.cellW-4,b.cellH-4)
end
screen:layers(self:art("portraits"),(t.portrait-1)*f.frame,f.frame,f.h,o+7,p+2,f.shades)
if self.twoPlayer and self.peerDriver==i then
j.label(screen,self.context.art,"2",o+2,p+2)
end
end
local o=k.LIST[self.driverCursor]
local t="kart_"..o.id
local i=m[t]
local p=i.steps[1]
local u=self.myDriver and 5 or(l(self.pickClock/b.spinTicks)%8+1)
screen:layers(self:art(t),p.x+(u-1)*p.w,p.w,i.h,10,r-i.h-4,i.shades)
self:write(screen,self:say("Driver_"..o.id),50,80,a.INK)
self:write(screen,self:say("Class_"..o.class),50,98,a.DARK)
if self.twoPlayer and self.myDriver and not self.peerDriver then
self:fill(screen,a.INK,0,52,e,18)
self:centre(screen,self:say("WaitingP2"),e/2,53,a.PAPER)
end
end

function c:mapEntries()
local o=self:modeOf()
local f={}
local p=s.unlocked(self.data,"knox")
if o==d.MODE_GP then
for i,t in ipairs(n.CUPS)do
f[#f+1]={cup=i,tracks=t.tracks,page=i,open=i==1 or p,key="Cup_"..t.id}
end
elseif o==d.MODE_BATTLE then
for t,i in ipairs(n.ARENAS)do
f[#f+1]={tracks={i},page=1,slot=t,open=true,key="Track_"..i}
end
else
for i,u in ipairs(n.CUPS)do
for v,t in ipairs(u.tracks)do
f[#f+1]={tracks={t},page=i,slot=v,open=i==1 or p,key="Track_"..t,cup=i}
end
end
end
return f
end

function c:startDemo(arena)
local i={}
local o=nil
for f,p in ipairs(k.LIST)do
i[f]={driver=f}
if p.id==b.demoDriver then
o=f
end
end
local f=d.new({mode=d.MODE_BATTLE,track=arena,cc=k.CC[b.demoCc],grid=i,seed=self.clock})
d.skipIntro(f)
while f.phase~="race"do
d.step(f,{})
end
self.demo={arena=arena,world=f,view=q.new(o)}
end

function c:tickDemo(arena)
local f=self.demo
if not f or f.arena~=arena or f.world.phase=="done"or f.world.karts[f.view.place].out then
self:startDemo(arena)
f=self.demo
end
d.step(f.world,{})
q.react(f.view,f.world,f.world.events)
end

function c:openMap()
self.screen=c.SCREEN_MAP
self.demo=nil
local f=self:mapEntries()
if self.setup.course>#f or not f[self.setup.course].open then
self.setup.course=1
end
if self:modeOf()==d.MODE_BATTLE then
self:startDemo(f[self.setup.course].tracks[1])
end
self:music(h.MAP)
end

function c:tick_map(input)
local f=self:mapEntries()
local o=self:moveCursor(input,self.setup.course,#f,function(i)return f[i].open end,"left","right")
o=self:moveCursor(input,o,#f,function(i)return f[i].open end,"up","down")
self.setup.course=o
if self:modeOf()==d.MODE_BATTLE then
self:tickDemo(f[o].tracks[1])
end
if g(input,"a")then
self:effect(h.CONFIRM)
if self.twoPlayer then
self.port:sendSetup(self.setup.mode,self.setup.cc,self.setup.course)
end
self:openDrivers()
elseif g(input,"b")then
self:effect(h.BACK)
local i=self:modeOf()
if i==d.MODE_GP or i==d.MODE_VS then
self:openCc()
else
self:openHighway()
end
end
end

function c:boxedLine(screen,text,top)
local f=screen:textWidth(text)+2*b.boxPad
self:fill(screen,a.PAPER,l((e-f)/2),top,f,screen:lineHeight()+2)
self:centre(screen,text,e/2,top+1,a.INK)
end

function c:drawArenaChoice(screen,entries,chosen)
q.drawBare(self.demo.view,screen,self.context.art,self.demo.world,b.demoReserve)
self:boxedLine(screen,self:say("Mode_Battle"),b.arenaMargin)
self:boxedLine(screen,self:say(chosen.key),b.arenaMargin+screen:lineHeight()+4)
for u,p in ipairs(entries)do
local t="outline_"..p.tracks[1]
local f=m[t]
local i=u==1 and b.arenaMargin or e-b.arenaMargin-f.w
local o=r-b.arenaMargin-f.h
if p==chosen then
self:fill(screen,a.INK,i-3,o-3,f.w+6,f.h+6)
end
self:fill(screen,a.PAPER,i-1,o-1,f.w+2,f.h+2)
screen:sheet(self:art(t),0,0,f.w,f.h,i,o,1,a.INK)
end
end

function c:draw_map(screen)
local o=self:mapEntries()
local f=o[self.setup.course]
if self:modeOf()==d.MODE_BATTLE then
self:drawArenaChoice(screen,o,f)
return
end
self:image(screen,"road_map",0,0)
local t=f.page
local w=self:say("Cup_"..n.CUPS[t].id)
self:centre(screen,w,e/2,6,a.INK)
local p={}
for v,i in ipairs(o)do
if i.page==t then
for x,u in ipairs(i.tracks)do
p[#p+1]={track=u,entry=i}
end
end
end
for x,i in ipairs(p)do
local y=b.outlineX[x]
local u="outline_"..i.track
local v=m[u]
screen:sheet(self:art(u),0,0,v.w,v.h,y,b.outlineY,1,i.entry.open and a.INK or a.MID)
end
if f.slot then
local i=b.outlineX[f.slot]
self:fill(screen,a.INK,i-3,b.outlineY-3,46,2)
self:fill(screen,a.INK,i-3,b.outlineY+41,46,2)
self:fill(screen,a.INK,i-3,b.outlineY-3,2,46)
self:fill(screen,a.INK,i+41,b.outlineY-3,2,46)
else
self:fill(screen,a.INK,2,b.outlineY-4,e-4,2)
self:fill(screen,a.INK,2,b.outlineY+42,e-4,2)
end
local x=f.open and self:say(f.key)or self:say("Locked")
self:fill(screen,a.PAPER,0,80,e,18)
self:centre(screen,x,e/2,81,a.INK)
if self:modeOf()==d.MODE_TT and f.open then
local i=s.best(self.data,f.tracks[1])
local u=self.context.art
if i then
local v=j.time(i.time)
j.label(screen,u,v,l((e-j.width(v))/2),104)
else
j.label(screen,u,"-'--\"--",l((e-j.width("-'--\"--"))/2),104)
end
end
end
