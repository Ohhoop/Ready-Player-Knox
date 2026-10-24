require"SpiffBoy/Games/QuickStart/Game"

local b=SpiffBoyQuickStartGame
local a=SpiffBoy.QuickStart
local j=a.Atlas
local o=a.Roster
local u=a.Race
local g=a.GrandPrix
local i=a.Records
local v=a.Ghost
local f=a.Music
local e=a.Hud

local s=math.floor
local d=a.WIDTH
local l=a.HEIGHT
local m=b.pressed

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

function b:drawBoard(screen,lines)
self:fill(screen,a.MID,0,0,d,l)
self:image(screen,"letter_board",c.x,c.y)
local n=j.faces
local p=self.context.art
for q,h in ipairs(lines)do
if self.boardClock>=q*c.slideTicks then
local k=c.y+c.rowY-4+(q-1)*c.rowH
if h.seat then
self:fill(screen,a.DARK,c.x+5,k,142,11)
end
local r=h.seat and a.PAPER or a.INK
e.text(screen,p,tostring(q),c.x+9,k+3,r)
local t=o.LIST[h.driver]
screen:layers(self:art("faces"),(t.portrait-1)*n.frame,n.frame,n.h,c.x+20,k,n.shades)
if h.extra then
e.text(screen,p,h.extra,c.x+36,k+3,r)
end
e.text(screen,p,h.value,c.x+140-e.width(h.value),k+3,r)
end
end
end

function b:resultLines()
local h=self.world
local q={}
local r=not h.battle and u.finishTimes(h)or nil
for t,p in ipairs(h.order)do
local n=h.karts[p]
local k={driver=n.driver,seat=n.seat}
if h.battle then
k.value=n.out and"-"or("x"..n.cans)
elseif self.gp then
k.value="+"..tostring(g.POINTS[t]or 0)
k.extra=e.time(r[p])
else
k.value=e.time(r[p])
end
q[t]=k
end
return q
end

function b:tick_results(input)
self.boardClock=self.boardClock+1
if self.boardClock<8*c.slideTicks then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if m(input,"a")then
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

function b:draw_results(screen)
self:drawBoard(screen,self:resultLines())
end

function b:openStandings()
self.screen=b.SCREEN_STANDINGS
self.boardClock=0
end

function b:tick_standings(input)
self.boardClock=self.boardClock+1
if self.boardClock<8*c.slideTicks then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if m(input,"a")then
self:effect(f.CONFIRM)
self:standingsForward()
end
end

function b:standingsForward()
if g.advance(self.gp)then
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

function b:draw_standings(screen)
local k={}
for n,h in ipairs(self.gp.standings)do
k[n]={driver=h.driver,seat=h.seat,value=tostring(h.points),extra="+"..tostring(h.gained or 0)}
end
self:drawBoard(screen,k)
end

function b:followNext(choice)
if choice==c.choice.back then
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
local h=g.placeOfPlayers(self.gp)
if h<=g.PODIUM and self.gp.cup==1 and i.unlock(self.data,"knox")then
self.unlockKey="Unlock_Knox"
end
if h==1 and o.CC[self.setup.cc].id=="150"then
i.unlock(self.data,"win150_"..g.CUPS[self.gp.cup].id)
if i.unlocked(self.data,"win150_spiffo")and i.unlocked(self.data,"win150_knox")and i.unlock(self.data,"mirror")then
self.unlockKey="Unlock_Mirror"
end
end
self:store()
end

function b:tick_podium(input)
self.boardClock=self.boardClock+1
if self.boardClock<60 then
return
end
if self.twoPlayer and not self.port:leads()then
return
end
if m(input,"a")then
self:effect(f.CONFIRM)
self.gp=nil
if self.twoPlayer then
self.port:sendNext(c.choice.back)
end
self:openHighway()
end
end

function b:draw_podium(screen)
local q=self.world.track
local p=j[q.style.sky]
self:fill(screen,a.PAPER,0,0,d,l)
screen:layers(self:art(q.style.sky),0,d,p.h,0,60-p.h,p.shades)
self:fill(screen,a.MID,0,60,d,l-60)
self:image(screen,"podium",c.podiumX,c.podiumY)
for h=1,g.PODIUM do
local t=self.gp.standings[h]
local w=o.LIST[t.driver]
local r="kart_"..w.id
local k=j[r]
local n=k.steps[2]
local x=c.stackX[h]-s(n.w/2)
local y=(h==1 and self.boardClock%30<15)and 2 or 0
screen:layers(self:art(r),n.x+4*n.w,n.w,k.h,x,c.stackTops[h]-k.h-y,k.shades)
if h==1 then
self:image(screen,"trophy",c.stackX[1]-8,c.stackTops[1]-k.h-20)
end
end
self:centre(screen,self:say("Cup_"..g.CUPS[self.gp.cup].id),d/2,4,a.INK)
if self.unlockKey and self.boardClock%60<45 then
self:fill(screen,a.INK,0,22,d,18)
self:centre(screen,self:say(self.unlockKey),d/2,23,a.PAPER)
end
end

function b:openTrial()
self.screen=b.SCREEN_TRIAL
self.trialIndex=1
local n=self.world
local k=n.karts[1]
local p=n.lapTimes[1]
local h={}
local q=0
for r=1,#p do
h[r]=p[r]-q
q=p[r]
end
h[#h+1]=k.finishTick-q
local r=h[1]
for w,t in ipairs(h)do
r=math.min(r,t)
end
self.trial={time=k.finishTick,laps=h}
self.trial.record=i.submit(self.data,n.track.id,k.driver,k.finishTick,r,v.parts(self.recorder))
self:store()
if self.trial.record then
self:silence()
self.sequencer:play(f.RECORD)
self.playing="jingle"
else
self:music(f.RESULTS)
end
end

function b:tick_trial(input)
self.trialIndex=self:moveCursor(input,self.trialIndex,3)
if m(input,"a")then
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

function b:draw_trial(screen)
self:fill(screen,a.PAPER,0,0,d,l)
local h=self.context.art
local k=e.time(self.trial.time)
self:centre(screen,self:say("Track_"..self.world.track.id),d/2,2,a.INK)
e.label(screen,h,k,s((d-e.width(k))/2),22)
for n,q in ipairs(self.trial.laps)do
local r=e.time(q)
local p=32+n*8
screen:sheet(self:art("flag"),0,0,j.flag.w,j.flag.h,60,p-1,1,a.INK)
e.text(screen,h,tostring(n).."  "..r,70,p,a.INK)
end
if self.trial.record then
self:fill(screen,a.INK,0,64,d,16)
self:centre(screen,self:say("Record"),d/2,64,a.PAPER)
end
local r={"Retry","ChangeCourse","Pause_Quit"}
for n,t in ipairs(r)do
local p=82+(n-1)*12
local q=a.INK
if n==self.trialIndex then
self:fill(screen,a.INK,30,p+2,120,12)
q=a.PAPER
end
self:centre(screen,self:say(t),d/2,p,q)
end
end
