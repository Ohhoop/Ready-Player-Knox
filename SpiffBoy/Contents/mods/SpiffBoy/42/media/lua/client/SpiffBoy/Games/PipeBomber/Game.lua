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
local d=j.Actors
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
local z=2
local A=3
local B=f.GRENADE_FUSE
local C=6
local q=2
local D=2
local v=SpiffBoy.TICK_RATE
local w={"up","down","left","right"}
local E={
up={dx=0,dy=-1},down={dx=0,dy=1},left={dx=-1,dy=0},right={dx=1,dy=0},
}

function a:trace(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("PipeBomber: "..message)
end
end

function a:init()
local c=self.context.art
self.art={
survivor=c("survivor"),bombs=c("bombs"),fire=c("fire"),bonuses=c("bonuses"),
hatch=c("hatch"),hud=c("hud"),logo=c("logo"),frame=c("frame"),titleBomb=c("title_bomb"),
zombies={},bosses={},tiles={},arenas={},crates={},crateColumns={},
}
for i in pairs(d.ZOMBIES)do
self.art.zombies[i]=c("zombie_"..i)
end
for i in pairs(g.KINDS)do
self.art.bosses[i]=c("boss_"..i)
end
for m,i in ipairs(e.LIST)do
self.art.tiles[i.key]=c("tiles_"..i.key)
self.art.arenas[i.key]=c("arena_"..i.key)
self.art.crates[i.key]=c("crates_"..i.key)
self.art.crateColumns[i.key]=c("cratecol_"..i.key)
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

function a:keepMusic(name)
if not self.sequencer:isPlaying()then
self.sequencer:play(name)
end
end

function a:effect(name)
self.sequencer:effect(name)
end

function a:persistRecords()
self.save.records=t.write(self.records)
self:persist()
end

function a:addScore(points)
self.score=self.score+points
end

function a:tick(inputs,tick)
self.clock=self.clock+1
local c=inputs[1]
if self.mode==a.MODE_RUN then
self:tickRun(c)
else
self:tickMenu(c)
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

function a:beginZone(index)
self.zoneIndex=index
self.zone=e.LIST[index]
self.powers={range=1,count=1,speed=0}
self:beginLevel(1)
end

function a:clearTimed()
self.timed={detonator=0,kick=0,pass=0,vest=0}
self.special=nil
end

local function s(grid,random,count,distance)
local c=grid:emptyCells(k.START.column,k.START.row,distance)
local m={}
for i=1,math.min(count,#c)do
local n=random:int(i,#c)
c[i],c[n]=c[n],c[i]
m[i]=c[i]
end
return m
end

function a:beginLevel(level)
local c=self.zone
self.level=level
self.bossLevel=level==e.LEVELS
local i=SpiffBoyRandom.new(e.layoutSeed(self.zoneIndex,level))
local y=self.bossLevel and e.BOSS_CRATES or c.crates
local m=k.new(c.columns,c.rows,y,i)
self.grid=m
if not self.bossLevel then
m:hideExit(i)
end
for r,n in ipairs(e.levelBonuses(level,i))do
m:hide(n,i,z)
end
self.bombs=f.new(m)
self.zombies={}
self.shots={}
self.boss=nil
local n=self.difficulty.pace
if self.bossLevel then
local r=s(m,i,1,math.max(C,math.floor(c.columns/2)))[1]
self.boss=g.new(c.boss,r[1],r[2],n)
local F=math.max(0,e.BOSS_MINIONS[self.zoneIndex]+self.difficulty.extra)
for G,x in ipairs(s(m,i,F,u))do
self.zombies[#self.zombies+1]=d.newZombie(c.kinds[(G-1)%#c.kinds+1],x[1],x[2],n)
end
else
local r=e.zombieKinds(c,e.zombieCount(self.zoneIndex,level,self.difficulty))
for F,x in ipairs(s(m,i,#r,u))do
self.zombies[#self.zombies+1]=d.newZombie(r[F],x[1],x[2],n)
end
end
self.survivor=d.newSurvivor(k.START.column,k.START.row)
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
self:trace("zone "..self.zoneIndex.." level "..level.." with "..#self.zombies.." zombies, boss "..tostring(self.boss and self.boss.kind))
end

function a:readDirection(input)
if not input then
self.heldDirection=nil
return nil
end
for i,c in ipairs(w)do
if input.pressed[c]then
self.heldDirection=c
return c
end
end
if self.heldDirection and input.held[self.heldDirection]then
return self.heldDirection
end
for i,c in ipairs(w)do
if input.held[c]then
self.heldDirection=c
return c
end
end
self.heldDirection=nil
return nil
end

function a:survivorCell()
return d.cellOf(self.survivor)
end

function a:closedToZombie(column,row)
return self.grid:isSolid(column,row)or self.bombs:at(column,row)~=nil
end

function a:occupied(column,row)
local i,m=self:survivorCell()
if i==column and m==row then
return true
end
for x,c in ipairs(self.zombies)do
local n,r=d.cellOf(c)
if n==column and r==row and c.state~="dying"then
return true
end
end
if self.boss then
local c,n=d.cellOf(self.boss)
return c==column and n==row
end
return false
end

function a:walkSurvivor(name)
local c=self.survivor
local i=E[name]
c.facing=name
local n=self.grid
local r=self.bombs
local x=self.timed.pass>0
local y=self.timed.kick>0
local F=d.SPEED+d.SPEED_STEP*self.powers.speed
local m=d.walk(c,i.dx,i.dy,F,function(column,row)
if n:isHard(column,row)then
return true
end
if n:isCrate(column,row)then
return not x
end
local m=r:at(column,row)
if m then
if y and not m.slideX then
r:kick(m,i.dx,i.dy)
self:effect(b.KICK)
end
return true
end
return false
end)
c.moving=m
if m then
c.walkTicks=c.walkTicks+1
end
end

function a:layBomb()
local c,i=self:survivorCell()
if self.grid:isSolid(c,i)or self.bombs:at(c,i)then
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
self.bombs:place(c,i,m,f.PLAYER,self.powers.range,n)
self:effect(b.PLACE)
end

function a:applyBonus(kind)
local c=self.powers
if kind=="range"then
c.range=math.min(d.MAX_RANGE,c.range+1)
elseif kind=="count"then
c.count=math.min(d.MAX_COUNT,c.count+1)
elseif kind=="speed"then
c.speed=math.min(d.MAX_SPEED,c.speed+1)
elseif kind=="aerosol"or kind=="molotov"then
self.special={kind=kind,uses=A}
else
self.timed[kind]=h.timed
end
self:addScore(p.bonus)
self:effect(b.PICKUP)
self:trace("bonus "..kind)
end

function a:tickTimed()
for i,c in ipairs(e.TEMPORARY)do
if self.timed[c]>0 then
self.timed[c]=self.timed[c]-1
if self.timed[c]==0 and c=="detonator"then
self.bombs:lightAll(f.PLAYER)
end
end
end
end

function a:tickSurvivor(input)
local c=self.survivor
if c.safe>0 then
c.safe=c.safe-1
end
local n=self:readDirection(input)
if n then
self:walkSurvivor(n)
else
c.moving=false
end
if input and input.pressed.a then
self:layBomb()
end
if input and input.pressed.b and self.timed.detonator>0 and self.bombs:detonate(f.PLAYER)then
self:effect(b.CLICK)
end
self:tickTimed()
local i,m=self:survivorCell()
local r=self.grid:takeItem(i,m)
if r then
self:applyBonus(r)
end
if self.grid.exitOpen and self.grid:isExit(i,m)and not self.grid:isSolid(i,m)then
self:clearLevel()
end
end

function a:zombieFelled(points)
self.combo=math.min(p.comboCap,self.combo+1)
self.comboTimer=h.combo
self:addScore(points*self.combo)
self:effect(b.ZOMBIE)
end

function a:applyFlames()
local i=self.bombs
for r,c in ipairs(self.zombies)do
if c.state~="dying"then
local m,n=d.cellOf(c)
if i:dangerAt(m,n)and d.hitZombie(c)then
self:zombieFelled(c.stats.points)
end
end
end
local c=self.boss
if c and c.state~="dying"then
local m,n=d.cellOf(c)
if i:dangerAt(m,n)==f.PLAYER then
if g.hit(c)then
self:bossFelled()
elseif c.flash==g.HIT_TICKS then
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
local c=self.survivor
for m,i in ipairs(self.zombies)do
if i.state~="dying"and d.touch(i,c)then
self:killSurvivor("bitten by "..i.kind)
return
end
end
local i=self.boss
if i and i.state~="dying"and math.abs(i.x-c.x)<g.TOUCH and math.abs(i.y-c.y)<g.TOUCH then
self:killSurvivor("caught by "..i.kind)
return
end
local n,r=c.x+o/2,c.y+o/2
for x,m in ipairs(self.shots)do
if math.abs(m.x-n)<g.SHOT_TOUCH and math.abs(m.y-r)<g.SHOT_TOUCH then
self:killSurvivor("hit by "..m.kind)
return
end
end
end

function a:killSurvivor(cause)
local c=self.survivor
if c.state~="alive"or c.safe>0 then
return
end
d.killSurvivor(c)
self.phase=a.PHASE_DYING
self.sequencer:stop()
self.sequencer:play(b.DEATH)
self:trace("survivor dies in zone "..self.zoneIndex.." level "..self.level..": "..cause)
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
for i,c in ipairs(self.zombies)do
if c.state~="dying"then
c.hp=1
c.flash=0
d.hitZombie(c)
end
end
self.sequencer:stop()
self:trace("boss "..self.boss.kind.." felled")
end

function a:tickZombies()
for i=#self.zombies,1,-1 do
local c=self.zombies[i]
d.updateZombie(c,self)
if c.state=="dying"and c.timer<=0 then
table.remove(self.zombies,i)
end
end
local c=self.boss
if c then
g.update(c,self)
if c.state=="dying"and c.timer<=0 then
local i,m=d.cellOf(c)
self.grid:revealExit(i,m)
self.boss=nil
self:effect(b.OPEN)
end
end
end

function a:tickShots()
for i=#self.shots,1,-1 do
local c=self.shots[i]
c.x=c.x+c.dx*g.SHOT_SPEED
c.y=c.y+c.dy*g.SHOT_SPEED
local m=math.floor(c.x/o)+1
local n=math.floor(c.y/o)+1
if self.grid:isSolid(m,n)then
table.remove(self.shots,i)
end
end
end

function a:checkExit()
local c=self.grid
if c.exitOpen or self.bossLevel then
return
end
for m,i in ipairs(self.zombies)do
if i.state~="dying"then
return
end
end
c.exitOpen=true
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

function a:sendHorde(count)
local n,r=self:survivorCell()
local i=self.grid:emptyCells(n,r,l.distance)
local c=0
while c<count and#i>0 and#self.zombies<l.cap do
local m=table.remove(i,self.random:int(1,#i))
self.zombies[#self.zombies+1]=d.newZombie(l.kind,m[1],m[2],self.difficulty.pace)
c=c+1
end
if c>0 and not self.bossLevel then
self.grid.exitOpen=false
end
end

function a:tickPlay(input)
if self.bannerTimer>0 then
self.bannerTimer=self.bannerTimer-1
end
if self.comboTimer>0 then
self.comboTimer=self.comboTimer-1
if self.comboTimer==0 then
self.combo=0
end
end
self:tickSurvivor(input)
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
local c=math.floor(self.timeLeft/v)*p.perSecond
self:addScore(c)
self.survivor.state="cheer"
self.phase=a.PHASE_CLEAR
self.phaseTimer=h.clear
self.sequencer:stop()
self.sequencer:play(b.CLEAR)
self:trace("level clear, time bonus "..c..", score "..self.score)
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

function a:tickRun(input)
local c=self.phase
if c==a.PHASE_INTRO then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self.phase=a.PHASE_PLAY
end
elseif c==a.PHASE_PLAY then
if input and input.pressed.start then
self.paused=not self.paused
self:effect(b.CONFIRM)
end
if not self.paused then
self:tickPlay(input)
end
elseif c==a.PHASE_DYING then
self.bombs:update(self)
self.grid:update()
self.survivor.timer=self.survivor.timer-1
if self.survivor.timer<=0 and not self.sequencer:isPlaying()then
self:lifeLost()
end
elseif c==a.PHASE_CLEAR then
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:nextLevel()
end
elseif c==a.PHASE_ENDING then
self.phaseTimer=self.phaseTimer-1
local i=input and(input.pressed.a or input.pressed.start)and self.phaseTimer<h.ending-h.endingSkip
if i or(self.phaseTimer<=0 and not self.sequencer:isPlaying())then
self:offerRecord()
end
else
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 and not self.sequencer:isPlaying()then
self:offerRecord()
end
end
end

function a:addShot(kind,x,y,dx,dy)
self.shots[#self.shots+1]={kind=kind,x=x,y=y,dx=dx,dy=dy}
self:effect(b.SHOT)
end

function a:layCrates(column,row,count)
local m=self.grid
local r,x=self:survivorCell()
local n={}
for c=row-q,row+q do
for i=column-q,column+q do
local y=not m:isSolid(i,c)and not self.bombs:at(i,c)and not m:itemAt(i,c)and not m:isExit(i,c)
if y and not self:occupied(i,c)and k.distance(i,c,r,x)>D then
n[#n+1]={i,c}
end
end
end
for i=1,math.min(count,#n)do
local c=table.remove(n,self.random:int(1,#n))
m.cells[m:index(c[1],c[2])]=k.CRATE
end
self:effect(b.THUD)
end

function a:callZombie(kind,column,row,cap)
local i=0
for m,c in ipairs(self.zombies)do
if c.state~="dying"then
i=i+1
end
end
if i>=cap then
return
end
local c=d.openDirections(column,row,function(c,r)return self:closedToZombie(c,r)or self:occupied(c,r)end)
if#c==0 then
return
end
local m=c[self.random:int(1,#c)]
self.zombies[#self.zombies+1]=d.newZombie(kind,column+m.dx,row+m.dy,self.difficulty.pace)
self:effect(b.CALL)
end

function a:throwGrenade()
local c,i=self:survivorCell()
if self.grid:isSolid(c,i)or self.bombs:at(c,i)then
return
end
self.bombs:place(c,i,"grenade",f.ENEMY,f.GRENADE_RANGE,B)
self:effect(b.THROW)
end

function a:strike(column,row)
self:effect(b.STRIKE)
local c,i=self:survivorCell()
if c==column and i==row then
self:killSurvivor("pitchfork")
end
end

function a:bossThud()
self:effect(b.THUD)
end

function a:crateBroken(owner)
if owner==f.PLAYER then
self:addScore(p.crate)
end
end

function a:itemBurnt()
self:effect(b.BURN)
end

function a:bombExploded(bomb)
self:effect(b.BLAST)
end

require"SpiffBoy/Games/PipeBomber/View"
require"SpiffBoy/Games/PipeBomber/Menus"
