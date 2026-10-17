require"SpiffBoy/Games/QuickStart/Game"

local b=SpiffBoyQuickStartGame
local a=SpiffBoy.QuickStart
local k=a.Atlas
local p=a.Roster
local u=a.Race
local h=a.GrandPrix
local j=a.Records
local v=a.Ghost
local f=a.Music
local e=a.Hud

local t=math.floor
local d=a.WIDTH
local m=a.HEIGHT
local n=b.pressed

b.BOARD={
x=14,y=4,rowY=9,rowH=12,slideTicks=6,
podiumX=30,podiumY=64,
stackTops={76,90,100},stackX={90,50,130},
choice={forward=1,back=2},
}

local c=b.BOARD

function b:openResults()
self.screen=b.SCREEN_RESULTS
self.boardClock=0
self:music(f.RESULTS)
end

function b:drawBoard(g,w)
self:fill(g,a.MID,0,0,d,m)
self:image(g,"letter_board",c.x,c.y)
local o=k.faces
local q=self.context.art
for r,i in ipairs(w)do
if self.boardClock>=r*c.slideTicks then
local l=c.y+c.rowY-4+(r-1)*c.rowH
if i.seat then
self:fill(g,a.DARK,c.x+5,l,142,11)
end
local s=i.seat and a.PAPER or a.INK
e.text(g,q,tostring(r),c.x+9,l+3,s)
local x=p.LIST[i.driver]
g:layers(self:art("faces"),(x.portrait-1)*o.frame,o.frame,o.h,c.x+20,l,o.shades)
if i.extra then
e.text(g,q,i.extra,c.x+36,l+3,s)
end
e.text(g,q,i.value,c.x+140-e.width(i.value),l+3,s)
end
end
end

function b:resultLines()
local g=self.world
local q={}
local r=not g.battle and u.finishTimes(g)or nil
for s,o in ipairs(g.order)do
local l=g.karts[o]
local i={driver=l.driver,seat=l.seat}
if g.battle then
i.value=l.out and"-"or("x"..l.cans)
elseif self.gp then
i.value="+"..tostring(h.POINTS[s]or 0)
i.extra=e.time(r[o])
else
i.value=e.time(r[o])
end
q[s]=i
end
return q
end

function b:tick_results(g)
self.boardClock=self.boardClock+1
if self.boardClock<8*c.slideTicks then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if n(g,"a")then
self:effect(f.CONFIRM)
if self.gp then
if self.twoPlayer then
self.port:sendNext(c.choice.forward)
end
self:openStandings()
else
if self.twoPlayer then
self.port:sendNext(c.choice.back)
self:openHighway()
else
self:openMap()
end
end
end
end

function b:draw_results(g)
self:drawBoard(g,self:resultLines())
end

function b:openStandings()
self.screen=b.SCREEN_STANDINGS
self.boardClock=0
end

function b:tick_standings(g)
self.boardClock=self.boardClock+1
if self.boardClock<8*c.slideTicks then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if n(g,"a")then
self:effect(f.CONFIRM)
self:standingsForward()
end
end

function b:standingsForward()
if h.advance(self.gp)then
if self.twoPlayer then
self:startLinkedRace()
else
self:startSoloRace()
end
return
end
if self.twoPlayer then
self.port:sendNext(c.choice.forward)
end
self:openPodium()
end

function b:draw_standings(l)
local i={}
for o,g in ipairs(self.gp.standings)do
i[o]={driver=g.driver,seat=g.seat,value=tostring(g.points),extra="+"..tostring(g.gained or 0)}
end
self:drawBoard(l,i)
end

function b:followNext(g)
if g==c.choice.back then
self:openGuest()
self.gp=nil
self:music(f.MENU)
return
end
if self.screen==b.SCREEN_RESULTS then
self:openStandings()
elseif self.screen==b.SCREEN_STANDINGS then
self:openPodium()
elseif self.screen==b.SCREEN_PODIUM then
self:openGuest()
self.gp=nil
end
end

function b:openPodium()
self.screen=b.SCREEN_PODIUM
self.boardClock=0
self.unlockKey=nil
self:music(f.PODIUM)
local g=h.placeOfPlayers(self.gp)
if g<=h.PODIUM and self.gp.cup==1 and j.unlock(self.data,"knox")then
self.unlockKey="Unlock_Knox"
end
if g==1 and p.CC[self.setup.cc].id=="150"then
j.unlock(self.data,"win150_"..h.CUPS[self.gp.cup].id)
if j.unlocked(self.data,"win150_spiffo")and j.unlocked(self.data,"win150_knox")and j.unlock(self.data,"mirror")then
self.unlockKey="Unlock_Mirror"
end
end
self:store()
end

function b:tick_podium(g)
self.boardClock=self.boardClock+1
if self.boardClock<60 then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if n(g,"a")then
self:effect(f.CONFIRM)
self.gp=nil
if self.twoPlayer then
self.port:sendNext(c.choice.back)
end
self:openHighway()
end
end

function b:draw_podium(g)
local r=self.world.track
local q=k[r.style.sky]
self:fill(g,a.PAPER,0,0,d,m)
g:layers(self:art(r.style.sky),0,d,q.h,0,60-q.h,q.shades)
self:fill(g,a.MID,0,60,d,m-60)
self:image(g,"podium",c.podiumX,c.podiumY)
for i=1,h.PODIUM do
local w=self.gp.standings[i]
local x=p.LIST[w.driver]
local s="kart_"..x.id
local l=k[s]
local o=l.steps[2]
local y=c.stackX[i]-t(o.w/2)
local z=(i==1 and self.boardClock%30<15)and 2 or 0
g:layers(self:art(s),o.x+4*o.w,o.w,l.h,y,c.stackTops[i]-l.h-z,l.shades)
if i==1 then
self:image(g,"trophy",c.stackX[1]-8,c.stackTops[1]-l.h-20)
end
end
self:centre(g,self:say("Cup_"..h.CUPS[self.gp.cup].id),d/2,4,a.INK)
if self.unlockKey and self.boardClock%60<45 then
self:fill(g,a.INK,0,22,d,18)
self:centre(g,self:say(self.unlockKey),d/2,23,a.PAPER)
end
end

function b:openTrial()
self.screen=b.SCREEN_TRIAL
self.trialIndex=1
local l=self.world
local i=l.karts[1]
local o=l.lapTimes[1]
local g={}
local q=0
for r=1,#o do
g[r]=o[r]-q
q=o[r]
end
g[#g+1]=i.finishTick-q
local r=g[1]
for w,s in ipairs(g)do
r=math.min(r,s)
end
self.trial={time=i.finishTick,laps=g}
self.trial.record=j.submit(self.data,l.track.id,i.driver,i.finishTick,r,v.parts(self.recorder))
self:store()
if self.trial.record then
self:silence()
self.sequencer:play(f.RECORD)
self.playing="jingle"
else
self:music(f.RESULTS)
end
end

function b:tick_trial(g)
self.trialIndex=self:moveCursor(g,self.trialIndex,3)
if n(g,"a")then
self:effect(f.CONFIRM)
if self.trialIndex==1 then
self:startSoloRace()
elseif self.trialIndex==2 then
self:openMap()
else
self:openHighway()
end
end
end

function b:draw_trial(g)
self:fill(g,a.PAPER,0,0,d,m)
local i=self.context.art
local l=e.time(self.trial.time)
self:centre(g,self:say("Track_"..self.world.track.id),d/2,2,a.INK)
e.label(g,i,l,t((d-e.width(l))/2),22)
for o,r in ipairs(self.trial.laps)do
local s=e.time(r)
local q=32+o*8
g:sheet(self:art("flag"),0,0,k.flag.w,k.flag.h,60,q-1,1,a.INK)
e.text(g,i,tostring(o).."  "..s,70,q,a.INK)
end
if self.trial.record then
self:fill(g,a.INK,0,64,d,16)
self:centre(g,self:say("Record"),d/2,64,a.PAPER)
end
local s={"Retry","ChangeCourse","Pause_Quit"}
for o,w in ipairs(s)do
local q=82+(o-1)*12
local r=a.INK
if o==self.trialIndex then
self:fill(g,a.INK,30,q+2,120,12)
r=a.PAPER
end
self:centre(g,self:say(w),d/2,q,r)
end
end
