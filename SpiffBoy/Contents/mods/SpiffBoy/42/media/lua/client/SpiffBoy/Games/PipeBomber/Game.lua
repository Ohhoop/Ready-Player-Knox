require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Random"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Grid"
require"SpiffBoy/Games/PipeBomber/Bombs"
require"SpiffBoy/Games/PipeBomber/Actors"
require"SpiffBoy/Games/PipeBomber/Bosses"
require"SpiffBoy/Games/PipeBomber/Records"
require"SpiffBoy/Games/PipeBomber/Music"
require"SpiffBoy/Framework/GameTexts"

SpiffBoyPipeBomberGame=SpiffBoyGameBase:derive("SpiffBoyPipeBomberGame")

local a=SpiffBoyPipeBomberGame
local j=SpiffBoy.PipeBomber
local e=j.Zones
local k=j.Grid
local f=j.Bombs
local c=j.Actors
local g=j.Bosses
local t=j.Records
local b=j.Music

local o=e.TILE
a.gameText=SpiffBoy.GameTexts.of("PipeBomber")

a.MODE_TITLE="title"
a.MODE_SETUP="setup"
a.MODE_PASSWORD="password"
a.MODE_OPTIONS="options"
a.MODE_CONFIRM="confirm"
a.MODE_SCORES="scores"
a.MODE_RUN="run"
a.MODE_CONTINUE="continue"
a.MODE_INITIALS="initials"

a.PHASE_INTRO="intro"
a.PHASE_PLAY="play"
a.PHASE_DYING="dying"
a.PHASE_CLEAR="clear"
a.PHASE_OVER="over"
a.PHASE_ENDING="ending"
a.CONTINUE={from=9,step=60}
a.BANNER_TICKS=120

local h={
intro=180,clear=150,over=150,ending=600,endingSkip=180,timed=1200,
combo=60,bossFall=30,
}
local p={crate=10,bonus=50,perSecond=10,comboCap=8}
local l={first=4,every=600,more=2,cap=12,kind="runner",distance=5}
local u=6
local A=2
local B=3
local C=f.GRENADE_FUSE
local D=6
local q=2
local E=2
local v=SpiffBoy.TICK_RATE
local w={"up","down","left","right"}
local F={
up={dx=0,dy=-1},down={dx=0,dy=1},left={dx=-1,dy=0},right={dx=1,dy=0},
}

function a:trace(d)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("PipeBomber: "..d)
end
end

function a:init()
local d=self.context.art
self.art={
survivor=d("survivor"),bombs=d("bombs"),fire=d("fire"),bonuses=d("bonuses"),
hatch=d("hatch"),hud=d("hud"),logo=d("logo"),frame=d("frame"),titleBomb=d("title_bomb"),
zombies={},bosses={},tiles={},arenas={},crates={},crateColumns={},
}
for i in pairs(c.ZOMBIES)do
self.art.zombies[i]=d("zombie_"..i)
end
for i in pairs(g.KINDS)do
self.art.bosses[i]=d("boss_"..i)
end
for m,i in ipairs(e.LIST)do
self.art.tiles[i.key]=d("tiles_"..i.key)
self.art.arenas[i.key]=d("arena_"..i.key)
self.art.crates[i.key]=d("crates_"..i.key)
self.art.crateColumns[i.key]=d("cratecol_"..i.key)
end
self.records=t.read(self.save)
self:readChoices()
self.clock=0
self.score=0
self.startZone=1
self:openTitle()
end

function a:applyMix()
self.sequencer:setMix(self.mix.music/b.MIX_STEPS,self.mix.effects/b.MIX_STEPS)
end

function a:keepMusic(d)
if not self.sequencer:isPlaying()then
self.sequencer:play(d)
end
end

function a:effect(d)
self.sequencer:effect(d)
end

function a:persistRecords()
self.save.records=t.write(self.records)
self:persist()
end

function a:addScore(d)
self.score=self.score+d
end

function a:tick(i,m)
self.clock=self.clock+1
local d=i[1]
if self.mode==a.MODE_RUN then
self:tickRun(d)
else
self:tickMenu(d)
end
end

function a:startRun()
self.difficulty=e.DIFFICULTIES[self.setup.difficulty]
self.difficultyKey=self.difficulty.key
self.lives=self.difficulty.lives
self.score=0
self.mode=a.MODE_RUN
self:trace("run starts in zone "..self.startZone.." at "..self.difficultyKey)
self:beginZone(self.startZone)
end

function a:beginZone(d)
self.zoneIndex=d
self.zone=e.LIST[d]
self.powers={range=1,count=1,speed=0}
self:beginLevel(1)
end

function a:clearTimed()
self.timed={detonator=0,kick=0,pass=0,vest=0}
self.special=nil
end

local function r(s,x,y,z)
local d=s:emptyCells(k.START.column,k.START.row,z)
local m={}
for i=1,math.min(y,#d)do
local n=x:int(i,#d)
d[i],d[n]=d[n],d[i]
m[i]=d[i]
end
return m
end

function a:beginLevel(n)
local d=self.zone
self.level=n
self.bossLevel=n==e.LEVELS
local i=SpiffBoyRandom.new(e.layoutSeed(self.zoneIndex,n))
local z=self.bossLevel and e.BOSS_CRATES or d.crates
local m=k.new(d.columns,d.rows,z,i)
self.grid=m
if not self.bossLevel then
m:hideExit(i)
end
for x,s in ipairs(e.levelBonuses(n,i))do
m:hide(s,i,A)
end
self.bombs=f.new(m)
self.zombies={}
self.shots={}
self.boss=nil
local s=self.difficulty.pace
if self.bossLevel then
local x=r(m,i,1,math.max(D,math.floor(d.columns/2)))[1]
self.boss=g.new(d.boss,x[1],x[2],s)
local G=math.max(0,e.BOSS_MINIONS[self.zoneIndex]+self.difficulty.extra)
for H,y in ipairs(r(m,i,G,u))do
self.zombies[#self.zombies+1]=c.newZombie(d.kinds[(H-1)%#d.kinds+1],y[1],y[2],s)
end
else
local x=e.zombieKinds(d,e.zombieCount(self.zoneIndex,n,self.difficulty))
for G,y in ipairs(r(m,i,#x,u))do
self.zombies[#self.zombies+1]=c.newZombie(x[G],y[1],y[2],s)
end
end
self.survivor=c.newSurvivor(k.START.column,k.START.row)
self:clearTimed()
self.timeLeft=self.difficulty.seconds*v
self.horde=false
self.hordeTimer=0
self.bannerTimer=0
self.combo=0
self.comboTimer=0
self.heldDirection=nil
self.paused=false
self.phase=a.PHASE_INTRO
self.phaseTimer=h.intro
self.sequencer:stop()
self.sequencer:play(b.START)
self:trace("zone "..self.zoneIndex.." level "..n.." with "..#self.zombies.." zombies, boss "..tostring(self.boss and self.boss.kind))
end

function a:readDirection(d)
if not d then
self.heldDirection=nil
return nil
end
for m,i in ipairs(w)do
if d.pressed[i]then
self.heldDirection=i
return i
end
end
if self.heldDirection and d.held[self.heldDirection]then
return self.heldDirection
end
for m,i in ipairs(w)do
if d.held[i]then
self.heldDirection=i
return i
end
end
self.heldDirection=nil
return nil
end

function a:survivorCell()
return c.cellOf(self.survivor)
end

function a:closedToZombie(d,i)
return self.grid:isSolid(d,i)or self.bombs:at(d,i)~=nil
end

function a:occupied(d,i)
local n,s=self:survivorCell()
if n==d and s==i then
return true
end
for z,m in ipairs(self.zombies)do
local x,y=c.cellOf(m)
if x==d and y==i and m.state~="dying"then
return true
end
end
if self.boss then
local m,x=c.cellOf(self.boss)
return m==d and x==i
end
return false
end

function a:walkSurvivor(x)
local d=self.survivor
local i=F[x]
d.facing=x
local y=self.grid
local z=self.bombs
local G=self.timed.pass>0
local H=self.timed.kick>0
local I=c.SPEED+c.SPEED_STEP*self.powers.speed
local m=c.walk(d,i.dx,i.dy,I,function(m,n)
if y:isHard(m,n)then
return true
end
if y:isCrate(m,n)then
return not G
end
local s=z:at(m,n)
if s then
if H and not s.slideX then
z:kick(s,i.dx,i.dy)
self:effect(b.KICK)
end
return true
end
return false
end)
d.moving=m
if m then
d.walkTicks=d.walkTicks+1
end
end

function a:layBomb()
local d,i=self:survivorCell()
if self.grid:isSolid(d,i)or self.bombs:at(d,i)then
return
end
if self.bombs:countOf(f.PLAYER)>=self.powers.count then
return
end
local m="pipe"
if self.special then
m=self.special.kind
self.special.uses=self.special.uses-1
if self.special.uses<=0 then
self.special=nil
end
end
local n=f.FUSE
if self.timed.detonator>0 then
n=nil
end
self.bombs:place(d,i,m,f.PLAYER,self.powers.range,n)
self:effect(b.PLACE)
end

function a:applyBonus(d)
local i=self.powers
if d=="range"then
i.range=math.min(c.MAX_RANGE,i.range+1)
elseif d=="count"then
i.count=math.min(c.MAX_COUNT,i.count+1)
elseif d=="speed"then
i.speed=math.min(c.MAX_SPEED,i.speed+1)
elseif d=="aerosol"or d=="molotov"then
self.special={kind=d,uses=B}
else
self.timed[d]=h.timed
end
self:addScore(p.bonus)
self:effect(b.PICKUP)
self:trace("bonus "..d)
end

function a:tickTimed()
for i,d in ipairs(e.TEMPORARY)do
if self.timed[d]>0 then
self.timed[d]=self.timed[d]-1
if self.timed[d]==0 and d=="detonator"then
self.bombs:lightAll(f.PLAYER)
end
end
end
end

function a:tickSurvivor(d)
local i=self.survivor
if i.safe>0 then
i.safe=i.safe-1
end
local s=self:readDirection(d)
if s then
self:walkSurvivor(s)
else
i.moving=false
end
if d and d.pressed.a then
self:layBomb()
end
if d and d.pressed.b and self.timed.detonator>0 and self.bombs:detonate(f.PLAYER)then
self:effect(b.CLICK)
end
self:tickTimed()
local m,n=self:survivorCell()
local x=self.grid:takeItem(m,n)
if x then
self:applyBonus(x)
end
if self.grid.exitOpen and self.grid:isExit(m,n)and not self.grid:isSolid(m,n)then
self:clearLevel()
end
end

function a:zombieFelled(d)
self.combo=math.min(p.comboCap,self.combo+1)
self.comboTimer=h.combo
self:addScore(d*self.combo)
self:effect(b.ZOMBIE)
end

function a:applyFlames()
local i=self.bombs
for s,d in ipairs(self.zombies)do
if d.state~="dying"then
local m,n=c.cellOf(d)
if i:dangerAt(m,n)and c.hitZombie(d)then
self:zombieFelled(d.stats.points)
end
end
end
local d=self.boss
if d and d.state~="dying"then
local m,n=c.cellOf(d)
if i:dangerAt(m,n)==f.PLAYER then
if g.hit(d)then
self:bossFelled()
elseif d.flash==g.HIT_TICKS then
self:effect(b.BOSS_HIT)
end
end
end
local m,n=self:survivorCell()
if i:dangerAt(m,n)and self.timed.vest==0 then
self:killSurvivor("flames")
end
end

function a:applyTouches()
local d=self.survivor
for m,i in ipairs(self.zombies)do
if i.state~="dying"and c.touch(i,d)then
self:killSurvivor("bitten by "..i.kind)
return
end
end
local i=self.boss
if i and i.state~="dying"and math.abs(i.x-d.x)<g.TOUCH and math.abs(i.y-d.y)<g.TOUCH then
self:killSurvivor("caught by "..i.kind)
return
end
local n,s=d.x+o/2,d.y+o/2
for x,m in ipairs(self.shots)do
if math.abs(m.x-n)<g.SHOT_TOUCH and math.abs(m.y-s)<g.SHOT_TOUCH then
self:killSurvivor("hit by "..m.kind)
return
end
end
end

function a:killSurvivor(i)
local d=self.survivor
if d.state~="alive"or d.safe>0 then
return
end
c.killSurvivor(d)
self.phase=a.PHASE_DYING
self.sequencer:stop()
self.sequencer:play(b.DEATH)
self:trace("survivor dies in zone "..self.zoneIndex.." level "..self.level..": "..i)
end

function a:lifeLost()
self.lives=self.lives-1
if self.lives>0 then
self:beginLevel(self.level)
return
end
self.sequencer:stop()
self.mode=a.MODE_CONTINUE
self.continueCount=a.CONTINUE.from
self.continueTimer=a.CONTINUE.step
self.continueYes=true
end

function a:continueRun()
self.score=0
self.lives=self.difficulty.lives
self.mode=a.MODE_RUN
self:beginZone(self.zoneIndex)
end

function a:gameOver()
self.mode=a.MODE_RUN
self.phase=a.PHASE_OVER
self.phaseTimer=h.over
self.sequencer:play(b.OVER)
end

function a:bossFelled()
self:addScore(self.boss.stats.points)
self:effect(b.BOSS_DOWN)
for i,d in ipairs(self.zombies)do
if d.state~="dying"then
d.hp=1
d.flash=0
c.hitZombie(d)
end
end
self.sequencer:stop()
self:trace("boss "..self.boss.kind.." felled")
end

function a:tickZombies()
for i=#self.zombies,1,-1 do
local d=self.zombies[i]
c.updateZombie(d,self)
if d.state=="dying"and d.timer<=0 then
table.remove(self.zombies,i)
end
end
local d=self.boss
if d then
g.update(d,self)
if d.state=="dying"and d.timer<=0 then
local i,m=c.cellOf(d)
self.grid:revealExit(i,m)
self.boss=nil
self:effect(b.OPEN)
end
end
end

function a:tickShots()
for i=#self.shots,1,-1 do
local d=self.shots[i]
d.x=d.x+d.dx*g.SHOT_SPEED
d.y=d.y+d.dy*g.SHOT_SPEED
local m=math.floor(d.x/o)+1
local n=math.floor(d.y/o)+1
if self.grid:isSolid(m,n)then
table.remove(self.shots,i)
end
end
end

function a:checkExit()
local d=self.grid
if d.exitOpen or self.bossLevel then
return
end
for m,i in ipairs(self.zombies)do
if i.state~="dying"then
return
end
end
d.exitOpen=true
self:effect(b.OPEN)
end

function a:tickClock()
if self.timeLeft>0 then
self.timeLeft=self.timeLeft-1
if self.timeLeft==0 then
self.horde=true
self.bannerTimer=a.BANNER_TICKS
self.hordeTimer=l.every
self:sendHorde(l.first)
self.sequencer:stop()
self.sequencer:play(b.HURRY)
self:trace("the horde comes in zone "..self.zoneIndex.." level "..self.level)
end
return
end
self.hordeTimer=self.hordeTimer-1
if self.hordeTimer<=0 then
self.hordeTimer=l.every
self:sendHorde(l.more)
end
end

function a:sendHorde(n)
local s,x=self:survivorCell()
local i=self.grid:emptyCells(s,x,l.distance)
local d=0
while d<n and#i>0 and#self.zombies<l.cap do
local m=table.remove(i,self.random:int(1,#i))
self.zombies[#self.zombies+1]=c.newZombie(l.kind,m[1],m[2],self.difficulty.pace)
d=d+1
end
if d>0 and not self.bossLevel then
self.grid.exitOpen=false
end
end

function a:tickPlay(d)
if self.bannerTimer>0 then
self.bannerTimer=self.bannerTimer-1
end
if self.comboTimer>0 then
self.comboTimer=self.comboTimer-1
if self.comboTimer==0 then
self.combo=0
end
end
self:tickSurvivor(d)
if self.phase~=a.PHASE_PLAY then
return
end
self.bombs:update(self)
self.grid:update()
self:tickZombies()
self:tickShots()
self:applyFlames()
self:applyTouches()
self:checkExit()
self:tickClock()
if self.phase==a.PHASE_PLAY and not self.horde then
self:keepMusic(self:levelMusic())
elseif self.phase==a.PHASE_PLAY then
self:keepMusic(b.HURRY)
end
end

function a:levelMusic()
if not self.bossLevel then
return b.ZONE[self.zone.key]
elseif self.zone.boss=="mother"then
return b.FINAL
end
return b.BOSS
end

function a:clearLevel()
local d=math.floor(self.timeLeft/v)*p.perSecond
self:addScore(d)
self.survivor.state="cheer"
self.phase=a.PHASE_CLEAR
self.phaseTimer=h.clear
self.sequencer:stop()
self.sequencer:play(b.CLEAR)
self:trace("level clear, time bonus "..d..", score "..self.score)
end

function a:nextLevel()
if self.level<e.LEVELS then
self:beginLevel(self.level+1)
elseif self.zoneIndex<#e.LIST then
self:beginZone(self.zoneIndex+1)
else
self.phase=a.PHASE_ENDING
self.phaseTimer=h.ending
self.sequencer:stop()
self.sequencer:play(b.ENDING)
self:trace("ending reached with "..self.score)
end
end

function a:tickRun(d)
local i=self.phase
if i==a.PHASE_INTRO then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.phase=a.PHASE_PLAY
end
elseif i==a.PHASE_PLAY then
if d and d.pressed.start then
self.paused=not self.paused
self:effect(b.CONFIRM)
end
if not self.paused then
self:tickPlay(d)
end
elseif i==a.PHASE_DYING then
self.bombs:update(self)
self.grid:update()
self.survivor.timer=self.survivor.timer-1
if self.survivor.timer<=0 and not self.sequencer:isPlaying()then
self:lifeLost()
end
elseif i==a.PHASE_CLEAR then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextLevel()
end
elseif i==a.PHASE_ENDING then
self.phaseTimer=self.phaseTimer-1
local m=d and(d.pressed.a or d.pressed.start)and self.phaseTimer<h.ending-h.endingSkip
if m or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:addShot(d,i,m,n,s)
self.shots[#self.shots+1]={kind=d,x=i,y=m,dx=n,dy=s}
self:effect(b.SHOT)
end

function a:layCrates(s,x,y)
local m=self.grid
local z,G=self:survivorCell()
local n={}
for d=x-q,x+q do
for i=s-q,s+q do
local H=not m:isSolid(i,d)and not self.bombs:at(i,d)and not m:itemAt(i,d)and not m:isExit(i,d)
if H and not self:occupied(i,d)and k.distance(i,d,z,G)>E then
n[#n+1]={i,d}
end
end
end
for i=1,math.min(y,#n)do
local d=table.remove(n,self.random:int(1,#n))
m.cells[m:index(d[1],d[2])]=k.CRATE
end
self:effect(b.THUD)
end

function a:callZombie(x,m,n,y)
local d=0
for s,i in ipairs(self.zombies)do
if i.state~="dying"then
d=d+1
end
end
if d>=y then
return
end
local i=c.openDirections(m,n,function(i,s)return self:closedToZombie(i,s)or self:occupied(i,s)end)
if#i==0 then
return
end
local s=i[self.random:int(1,#i)]
self.zombies[#self.zombies+1]=c.newZombie(x,m+s.dx,n+s.dy,self.difficulty.pace)
self:effect(b.CALL)
end

function a:throwGrenade()
local d,i=self:survivorCell()
if self.grid:isSolid(d,i)or self.bombs:at(d,i)then
return
end
self.bombs:place(d,i,"grenade",f.ENEMY,f.GRENADE_RANGE,C)
self:effect(b.THROW)
end

function a:strike(d,i)
self:effect(b.STRIKE)
local m,n=self:survivorCell()
if m==d and n==i then
self:killSurvivor("pitchfork")
end
end

function a:bossThud()
self:effect(b.THUD)
end

function a:crateBroken(d)
if d==f.PLAYER then
self:addScore(p.crate)
end
end

function a:itemBurnt()
self:effect(b.BURN)
end

function a:bombExploded(d)
self:effect(b.BLAST)
end

require"SpiffBoy/Games/PipeBomber/View"
require"SpiffBoy/Games/PipeBomber/Menus"
