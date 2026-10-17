require"SpiffBoy/Games/QuickStart/Game"

local c=SpiffBoyQuickStartGame
local a=SpiffBoy.QuickStart
local m=a.Atlas
local k=a.Roster
local e=a.Race
local n=a.GrandPrix
local t=a.Records
local i=a.Music
local j=a.Hud
local r=a.View

local l=math.floor
local f=a.WIDTH
local s=a.HEIGHT
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
self:music(i.SELECT)
end

function c:tick_drivers(h)
self.pickClock=self.pickClock+1
if self.twoPlayer and self.port:leads()and self.port:needsPing()then
self.port:ping(self.clock)
end
if self.myDriver then
if g(h,"b")and not self.twoPlayer then
self.myDriver=nil
end
return
end
local o=#k.LIST
local d=self.driverCursor
if g(h,"left")then
d=a.wrapIndex(d-1,o)
elseif g(h,"right")then
d=d%o+1
elseif g(h,"up")or g(h,"down")then
d=(d-1+b.columns)%o+1
end
if d~=self.driverCursor then
self.driverCursor=d
self:effect(i.TICK)
end
if g(h,"a")then
self:effect(i.CONFIRM)
self.myDriver=self.driverCursor
self.data.last.driver=self.myDriver
if self.twoPlayer then
self.port:sendChoice(self.myDriver)
self:maybeStartLinked()
else
self:startSoloRace()
end
elseif g(h,"b")and not self.twoPlayer then
self:effect(i.BACK)
self:openMap()
end
end

function c:draw_drivers(d)
self:fill(d,a.PAPER,0,0,f,s)
local h=m.portraits
for o,u in ipairs(k.LIST)do
local v,w=(o-1)%b.columns,l((o-1)/b.columns)
local p,q=b.gridX+v*b.cellW,b.gridY+w*b.cellH
if o==self.driverCursor then
self:fill(d,a.INK,p,q,b.cellW-2,b.cellH-2)
self:fill(d,self.myDriver and a.MID or a.DARK,p+1,q+1,b.cellW-4,b.cellH-4)
end
d:layers(self:art("portraits"),(u.portrait-1)*h.frame,h.frame,h.h,p+7,q+2,h.shades)
if self.twoPlayer and self.peerDriver==o then
j.label(d,self.context.art,"2",p+2,q+2)
end
end
local p=k.LIST[self.driverCursor]
local u="kart_"..p.id
local o=m[u]
local q=o.steps[1]
local v=self.myDriver and 5 or(l(self.pickClock/b.spinTicks)%8+1)
d:layers(self:art(u),q.x+(v-1)*q.w,q.w,o.h,10,s-o.h-4,o.shades)
self:write(d,self:say("Driver_"..p.id),50,80,a.INK)
self:write(d,self:say("Class_"..p.class),50,98,a.DARK)
if self.twoPlayer and self.myDriver and not self.peerDriver then
self:fill(d,a.INK,0,52,f,18)
self:centre(d,self:say("WaitingP2"),f/2,53,a.PAPER)
end
end

function c:mapEntries()
local o=self:modeOf()
local d={}
local p=t.unlocked(self.data,"knox")
if o==e.MODE_GP then
for h,q in ipairs(n.CUPS)do
d[#d+1]={cup=h,tracks=q.tracks,page=h,open=h==1 or p,key="Cup_"..q.id}
end
elseif o==e.MODE_BATTLE then
for q,h in ipairs(n.ARENAS)do
d[#d+1]={tracks={h},page=1,slot=q,open=true,key="Track_"..h}
end
else
for h,u in ipairs(n.CUPS)do
for v,q in ipairs(u.tracks)do
d[#d+1]={tracks={q},page=h,slot=v,open=h==1 or p,key="Track_"..q,cup=h}
end
end
end
return d
end

function c:startDemo(h)
local o={}
local p=nil
for d,q in ipairs(k.LIST)do
o[d]={driver=d}
if q.id==b.demoDriver then
p=d
end
end
local d=e.new({mode=e.MODE_BATTLE,track=h,cc=k.CC[b.demoCc],grid=o,seed=self.clock})
e.skipIntro(d)
while d.phase~="race"do
e.step(d,{})
end
self.demo={arena=h,world=d,view=r.new(p)}
end

function c:tickDemo(h)
local d=self.demo
if not d or d.arena~=h or d.world.phase=="done"or d.world.karts[d.view.place].out then
self:startDemo(h)
d=self.demo
end
e.step(d.world,{})
r.react(d.view,d.world,d.world.events)
end

function c:openMap()
self.screen=c.SCREEN_MAP
self.demo=nil
local d=self:mapEntries()
if self.setup.course>#d or not d[self.setup.course].open then
self.setup.course=1
end
if self:modeOf()==e.MODE_BATTLE then
self:startDemo(d[self.setup.course].tracks[1])
end
self:music(i.MAP)
end

function c:tick_map(h)
local d=self:mapEntries()
local o=self:moveCursor(h,self.setup.course,#d,function(o)return d[o].open end,"left","right")
o=self:moveCursor(h,o,#d,function(p)return d[p].open end,"up","down")
self.setup.course=o
if self:modeOf()==e.MODE_BATTLE then
self:tickDemo(d[o].tracks[1])
end
if g(h,"a")then
self:effect(i.CONFIRM)
if self.twoPlayer then
self.port:sendSetup(self.setup.mode,self.setup.cc,self.setup.course)
end
self:openDrivers()
elseif g(h,"b")then
self:effect(i.BACK)
local p=self:modeOf()
if p==e.MODE_GP or p==e.MODE_VS then
self:openCc()
else
self:openHighway()
end
end
end

function c:boxedLine(d,h,o)
local p=d:textWidth(h)+2*b.boxPad
self:fill(d,a.PAPER,l((f-p)/2),o,p,d:lineHeight()+2)
self:centre(d,h,f/2,o+1,a.INK)
end

function c:drawArenaChoice(h,w,q)
r.drawBare(self.demo.view,h,self.context.art,self.demo.world,b.demoReserve)
self:boxedLine(h,self:say("Mode_Battle"),b.arenaMargin)
self:boxedLine(h,self:say(q.key),b.arenaMargin+h:lineHeight()+4)
for x,u in ipairs(w)do
local v="outline_"..u.tracks[1]
local d=m[v]
local o=x==1 and b.arenaMargin or f-b.arenaMargin-d.w
local p=s-b.arenaMargin-d.h
if u==q then
self:fill(h,a.INK,o-3,p-3,d.w+6,d.h+6)
end
self:fill(h,a.PAPER,o-1,p-1,d.w+2,d.h+2)
h:sheet(self:art(v),0,0,d.w,d.h,o,p,1,a.INK)
end
end

function c:draw_map(d)
local p=self:mapEntries()
local h=p[self.setup.course]
if self:modeOf()==e.MODE_BATTLE then
self:drawArenaChoice(d,p,h)
return
end
self:image(d,"road_map",0,0)
local u=h.page
local x=self:say("Cup_"..n.CUPS[u].id)
self:centre(d,x,f/2,6,a.INK)
local q={}
for w,o in ipairs(p)do
if o.page==u then
for y,v in ipairs(o.tracks)do
q[#q+1]={track=v,entry=o}
end
end
end
for y,o in ipairs(q)do
local z=b.outlineX[y]
local v="outline_"..o.track
local w=m[v]
d:sheet(self:art(v),0,0,w.w,w.h,z,b.outlineY,1,o.entry.open and a.INK or a.MID)
end
if h.slot then
local o=b.outlineX[h.slot]
self:fill(d,a.INK,o-3,b.outlineY-3,46,2)
self:fill(d,a.INK,o-3,b.outlineY+41,46,2)
self:fill(d,a.INK,o-3,b.outlineY-3,2,46)
self:fill(d,a.INK,o+41,b.outlineY-3,2,46)
else
self:fill(d,a.INK,2,b.outlineY-4,f-4,2)
self:fill(d,a.INK,2,b.outlineY+42,f-4,2)
end
local y=h.open and self:say(h.key)or self:say("Locked")
self:fill(d,a.PAPER,0,80,f,18)
self:centre(d,y,f/2,81,a.INK)
if self:modeOf()==e.MODE_TT and h.open then
local o=t.best(self.data,h.tracks[1])
local v=self.context.art
if o then
local w=j.time(o.time)
j.label(d,v,w,l((f-j.width(w))/2),104)
else
j.label(d,v,"-'--\"--",l((f-j.width("-'--\"--"))/2),104)
end
end
end
