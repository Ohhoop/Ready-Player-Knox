require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Art"
require"SpiffBoy/Games/QuickStart/Roster"
require"SpiffBoy/Games/QuickStart/Kart"
require"SpiffBoy/Games/QuickStart/Race"
require"SpiffBoy/Games/QuickStart/View"
require"SpiffBoy/Games/QuickStart/GrandPrix"
require"SpiffBoy/Games/QuickStart/Ghost"
require"SpiffBoy/Games/QuickStart/Records"
require"SpiffBoy/Games/QuickStart/Link"
require"SpiffBoy/Games/QuickStart/Music"

SpiffBoyQuickStartGame=SpiffBoyGameBase:derive("SpiffBoyQuickStartGame")

local a=SpiffBoyQuickStartGame
local b=SpiffBoy.QuickStart
local i=b.Roster
local j=b.Kart
local c=b.Race
local n=b.View
local g=b.GrandPrix
local o=b.Ghost
local q=b.Records
local k=b.Link
local f=b.Music

a.MODES={c.MODE_GP,c.MODE_TT,c.MODE_VS,c.MODE_BATTLE}
a.MODE_KEYS={"Mode_GP","Mode_TT","Mode_VS","Mode_Battle"}

a.SCREEN_TITLE="title"
a.SCREEN_OPTIONS="options"
a.SCREEN_WAITING="waiting"
a.SCREEN_GUEST="guest"
a.SCREEN_HIGHWAY="highway"
a.SCREEN_CC="cc"
a.SCREEN_DRIVERS="drivers"
a.SCREEN_MAP="map"
a.SCREEN_RACE="race"
a.SCREEN_RESULTS="results"
a.SCREEN_STANDINGS="standings"
a.SCREEN_PODIUM="podium"
a.SCREEN_TRIAL="trial"

a.LOCKSTEP={
prefillPerTick=3,
sendsPerTick=4,
catchUp=3,
seedMax=2000000000,
sumEvery=60,
}

a.BATTLE_CC=2
a.TRIAL_CC=3

local h=a.LOCKSTEP

local w={{"up",j.UP},{"down",j.DOWN},{"left",j.LEFT},{"right",j.RIGHT},{"a",j.A},{"b",j.B}}
local r={
light=b.Music.LIGHT,go=b.Music.GO,boom=b.Music.BOOM,helicopter=b.Music.CHOPPER,horde=b.Music.BOOM,thunder=b.Music.THUNDER,
}
local s={
crate=b.Music.CRATE,throw=b.Music.THROW,shot=b.Music.SHOT,boost=b.Music.BOOST,spin=b.Music.SPIN,money=b.Music.MONEY,
bump=b.Music.BUMP,splash=b.Music.SPLASH,lap=b.Music.LAP,riot=b.Music.RIOT,can=b.Music.CAN,hop=b.Music.HOP,
drop=b.Music.THROW,stall=b.Music.SPIN,
}

local function x(input)
if not input then
return 0
end
local l,m=input.held,input.pressed
local d=0
for p,e in ipairs(w)do
if l[e[1]]or m[e[1]]then
d=d+e[2]
end
end
return d
end

function a:init()
self.data=q.prepare(self.save)
self.port=k.new(self.link)
self.clock=0
self.twoPlayer=false
self.setup={mode=1,cc=1,course=1}
self:applyMusic()
self:openTitle()
end

function a:art(name)
return self.context.art(name)
end

function a:store()
self:persist()
end

function a:applyMusic()
self.sequencer:setMix(self.data.options.music and 1 or 0,1)
end

function a:music(name)
if self.playing~=name or not self.sequencer:isPlaying()then
self.sequencer:play(name)
self.playing=name
end
end

function a:silence()
self.sequencer:stop()
self.playing=nil
end

function a:effect(name)
self.sequencer:effect(name)
end

function a:modeOf()
return a.MODES[self.setup.mode]
end

function a:ccOf()
local d=self:modeOf()
if d==c.MODE_TT then
return i.CC[a.TRIAL_CC]
end
if d==c.MODE_BATTLE then
return i.CC[a.BATTLE_CC]
end
return i.CC[self.setup.cc]
end

function a:tick(inputs,tick)
self.clock=self.clock+1
local d=self.screen
self:pollLink()
if self.screen~=d and self.screen~=a.SCREEN_RACE then
return
end
local e=inputs[1]
local l=self["tick_"..self.screen]
l(self,e)
end

function a:draw(screen)
local d=self["draw_"..self.screen]
d(self,screen)
end

function a:linkedScreen()
if not self.twoPlayer then
return false
end
return self.screen~=a.SCREEN_TITLE and self.screen~=a.SCREEN_OPTIONS
end

function a:pollLink()
local l=self.port
local p=l:poll(self.clock)
if self:linkedScreen()and not l:isConnected()then
self:openTitle()
return
end
for t,d in ipairs(p)do
local m=d.kind
local e=self.screen
if e==a.SCREEN_WAITING and m==k.KIND_HELLO then
l:hello()
self:openSession()
elseif e==a.SCREEN_GUEST and m==k.KIND_SETUP then
self.setup={mode=d.mode,cc=d.cc,course=d.course}
self:openDrivers()
elseif e==a.SCREEN_DRIVERS and self.twoPlayer and m==k.KIND_CHOICE then
if d.index>=1 and d.index<=#i.LIST then
self.peerDriver=d.index
self:maybeStartLinked()
end
elseif(e==a.SCREEN_DRIVERS or e==a.SCREEN_STANDINGS)and self.twoPlayer and m==k.KIND_START and not l:leads()then
if e==a.SCREEN_STANDINGS then
g.advance(self.gp)
end
self:createRace(d.seed,d.delay)
elseif(e==a.SCREEN_RESULTS or e==a.SCREEN_STANDINGS or e==a.SCREEN_PODIUM)and self.twoPlayer and m==k.KIND_NEXT and not l:leads()then
self:followNext(d.choice)
end
end
end

function a:openSession()
self.peerDriver=nil
self.myDriver=nil
if self.port:leads()then
self:openHighway()
else
self:openGuest()
self:music(f.MENU)
end
end

function a:gridOf()
local d={}
local e={}
if self.twoPlayer then
local l,m=self.myDriver,self.peerDriver
if self.port:seat()==2 then
l,m=self.peerDriver,self.myDriver
end
d[1]={driver=l,seat=1}
d[2]={driver=m,seat=2}
e[l],e[m]=true,true
else
d[1]={driver=self.myDriver,seat=1}
e[self.myDriver]=true
end
if self:modeOf()==c.MODE_TT then
return d
end
for l=1,#i.LIST do
if#d<8 and not e[l]then
d[#d+1]={driver=l}
end
end
local l=1
while#d<8 do
d[#d+1]={driver=l}
l=l%#i.LIST+1
end
return d
end

function a:mySeat()
if self.twoPlayer then
return self.port:seat()
end
return 1
end

function a:maybeStartLinked()
if not(self.myDriver and self.peerDriver)then
return
end
if self.port:leads()then
self:startLinkedRace()
end
end

function a:startLinkedRace()
local d=self.port
d:nextMatch()
local e=d:delay()
local l=self.random:int(1,h.seedMax)
d:sendStart(l,e)
self:createRace(l,e)
end

function a:trackOf()
if self.gp then
return g.track(self.gp)
end
local e=self:modeOf()
if e==c.MODE_BATTLE then
return g.ARENAS[self.setup.course]
end
local d={}
for p,l in ipairs(g.CUPS)do
for t,m in ipairs(l.tracks)do
d[#d+1]=m
end
end
return d[self.setup.course]
end

function a:createRace(seed,delay)
local d=self:modeOf()
if d==c.MODE_GP and not self.gp then
self.gp=g.new(self.setup.course,self:gridOf())
end
local l=self:trackOf()
local p=self.gp and g.grid(self.gp)or self:gridOf()
local m={mode=d,track=l,cc=self:ccOf(),grid=p,seed=seed}
if d==c.MODE_TT then
local e=q.ghost(self.data,l)
if e then
m.ghost={driver=e.driver,reader=o.reader(e.parts)}
end
self.recorder=o.recorder()
else
self.recorder=nil
end
self.world=c.new(m)
self.view=n.new(self.world.seats[self:mySeat()])
self.screen=a.SCREEN_RACE
self.paused=false
self.fastMusic=false
self.resultHeard=false
self.delay=delay
self.frame=0
self.prefillTick=0
self.sentTick=delay or 0
self:music(f.INTRO)
end

function a:startSoloRace()
self:createRace(self.random:int(1,h.seedMax),nil)
end

function a:prefill()
local d=0
while self.prefillTick<self.delay and d<h.prefillPerTick do
self.port:sendInput(self.prefillTick+1,0)
self.prefillTick=self.prefillTick+1
d=d+1
end
return d
end

function a:stepWorld(seatBits)
local d=self.world
local e=d.phase
c.step(d,seatBits)
if self.recorder and(e=="race"or e=="countdown")then
o.record(self.recorder,seatBits[1]or 0)
end
n.react(self.view,d,d.events)
self:hearWorld(d.events)
end

function a:tickLinkedRace(bits)
local d=self.port
local e=self:prefill()
self.frame=self.frame+1
local y=self.frame+self.delay
while self.sentTick<y and e<h.sendsPerTick and self.prefillTick>=self.delay do
self.sentTick=self.sentTick+1
d:sendInput(self.sentTick,bits)
e=e+1
end
local m=0
local l=self.world
while m<h.catchUp and l.tick<self.frame and l.phase~="done"do
local t=l.tick+1
local u=d:localInput(t)
local v=d:remoteInput(t)
if not u or not v then
break
end
local p={}
p[d:seat()]=u
p[3-d:seat()]=v
self:stepWorld(p)
m=m+1
if l.tick%h.sumEvery==0 and e<h.sendsPerTick then
d:sendSum(l.tick,c.checksum(l))
e=e+1
end
end
end

function a:tick_race(input)
if self.paused then
self:tickPause(input)
return
end
if input and input.pressed.start and not self.twoPlayer then
self:openPause()
return
end
local d=x(input)
if self.twoPlayer then
self:tickLinkedRace(d)
else
self:stepWorld({d})
end
self:raceMusic()
if self.world.phase=="done"then
self:endRace()
end
end

function a:raceMusic()
local d=self.world
local e=d.karts[self.view.place]
local l=f.TRACKS[d.track.id]
if d.phase=="intro"then
return
end
if d.phase=="countdown"then
if self.playing==f.INTRO and not self.sequencer:isPlaying()then
self:silence()
end
return
end
if e.finished or e.out or d.phase=="finish"then
if not self.resultHeard then
self.resultHeard=true
local m=d.battle and not e.out or(not d.battle and e.rank<=4)
self:silence()
self.sequencer:play(m and f.GOAL or f.LOST)
self.playing="jingle"
end
return
end
if not d.battle and c.lapOf(e)==c.TIMING.laps and not self.fastMusic then
self.fastMusic=true
self:silence()
end
self:music(self.fastMusic and(l..f.FAST)or l)
end

function a:hearWorld(events)
local e=self.view.place
for l,d in ipairs(events)do
if r[d.kind]then
self:effect(r[d.kind])
elseif d.kart==e and s[d.kind]then
self:effect(s[d.kind])
end
end
local d=self.world.karts[e]
if d.roulette>0 and d.roulette%4==0 then
self:effect(f.ROULETTE)
end
end

function a:draw_race(screen)
n.draw(self.view,screen,self.context.art,self.world)
if self.paused then
self:drawPause(screen)
end
end

function a:endRace()
local d=self.world
if self.gp then
g.score(self.gp,d)
self:openResults()
return
end
if d.mode==c.MODE_TT then
self:openTrial()
return
end
self:openResults()
end

require"SpiffBoy/Games/QuickStart/Menus"
require"SpiffBoy/Games/QuickStart/Pick"
require"SpiffBoy/Games/QuickStart/Board"
