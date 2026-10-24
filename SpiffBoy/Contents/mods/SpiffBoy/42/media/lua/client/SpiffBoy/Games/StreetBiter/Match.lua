require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Fighter"
require"SpiffBoy/Games/StreetBiter/Stage"
require"SpiffBoy/Framework/GameTexts"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local w=SpiffBoy.GameTexts.of("StreetBiter")
local J=SpiffBoy.StreetBiter.Roster
local z=SpiffBoy.StreetBiter.Moves
local h=SpiffBoy.StreetBiter.Fighter
local g=SpiffBoy.StreetBiter.Stage

local c={}
c.__index=c
SpiffBoy.StreetBiter.Match=c

local p=SpiffBoy.Cartridges.SHADES[4]
local e=SpiffBoy.Cartridges.SHADES[1]
local q=SpiffBoy.Cartridges.SHADES[2]
local A={1,2,3,4}
local K={3}
local j={width=72,height=64,anchor=36}
local f={width=20,height=12,count=12,spark1=9,spark2=10,guard=11,shadow=12}
local r=16
local s=g.ARENA-16
local B=110
local C=250
local m=150
local D=26
local i=2
local L=5
local M=99
local E=100
local N=40
local O=70
local F=110
local P=80
local Q=4
local G=2
local R=10
local d={barY=3,barHeight=6,barWidth=76,leftX=4,rightX=100,nameY=6,timerY=-1,markY=12,markSize=4,markGap=6}
local S=44
local k={up=false,down=false,left=false,right=false,a=false,b=false}

c.PHASE_INTRO="intro"
c.PHASE_FIGHT="fight"
c.PHASE_KO="ko"
c.PHASE_TIMEOVER="timeover"
c.PHASE_WIN="win"
c.PHASE_OVER="over"

function c.new(left,right,brain,damageScale)
local a=setmetatable({},c)
a.definitions={left,right}
a.fighters={h.new(left,B,1),h.new(right,C,-1)}
a.brain=brain
a.damageScale={1,damageScale or 1}
a.wins={0,0}
a.round=0
a.projectiles={}
a.sparks={}
a.events={}
a.hitstop=0
a.camera=0
a.result=nil
a.perfect=false
a:startRound()
return a
end

function c:startRound()
self.round=self.round+1
self.fighters[1]:reset(B,1)
self.fighters[2]:reset(C,-1)
self.projectiles={}
self.sparks={}
self.seconds=M
self.secondTicks=0
self.phase=c.PHASE_INTRO
self.phaseTimer=E
self.bannerTimer=0
self.hitstop=0
self.doubleKo=false
self.perfect=false
self:setBounds()
self:moveCamera()
self:push({kind="round",round=self.round,final=self:isFinalRound()})
end

function c:isFinalRound()
return self.wins[1]==i-1 and self.wins[2]==i-1
end

function c:push(event)
self.events[#self.events+1]=event
end

function c:takeEvents()
local a=self.events
self.events={}
return a
end

function c:onMoveStarted(fighter,move)
self:push({kind="swing",special=z.SPECIALS[move.name]~=nil,move=move.name})
end

function c:onJump(fighter)
self:push({kind="jump"})
end

function c:onLanded(fighter)
self:push({kind="thud"})
end

function c:indexOf(fighter)
if self.fighters[1]==fighter then
return 1
end
return 2
end

function c:spawnProjectile(fighter,spec)
local a=z.PROJECTILES[spec.kind]
self.projectiles[#self.projectiles+1]={
kind=spec.kind,spec=spec,data=a,owner=self:indexOf(fighter),
x=fighter.x+20*fighter.facing,y=spec.height,dir=fighter.facing,travelled=0,clock=0,
}
self:push({kind="projectile",projectile=spec.kind})
end

function c:setBounds()
local a,b=self.fighters[1],self.fighters[2]
a.minX=math.max(r,b.x-m)
a.maxX=math.min(s,b.x+m)
b.minX=math.max(r,a.x-m)
b.maxX=math.min(s,a.x+m)
end

local function H(me,foe)
local a=me.state
if(a==h.STATE_IDLE or a==h.STATE_WALK or a==h.STATE_CROUCH or a==h.STATE_WAIT)and foe.x~=me.x then
if foe.x>me.x then
me.facing=1
else
me.facing=-1
end
end
end

function c:face()
local a,b=self.fighters[1],self.fighters[2]
H(a,b)
H(b,a)
end

function c:separate()
local a,b=self.fighters[1],self.fighters[2]
if a:airborne()or b:airborne()then
return
end
local n=math.abs(a.x-b.x)
if n>=D then
return
end
local l=(D-n)/2
if a.x<=b.x then
a.x=math.max(a.minX,a.x-l)
b.x=math.min(b.maxX,b.x+l)
else
a.x=math.min(a.maxX,a.x+l)
b.x=math.max(b.minX,b.x-l)
end
end

function c:moveCamera()
local a=math.floor((self.fighters[1].x+self.fighters[2].x)/2)
self.camera=SpiffBoy.clamp(a-math.floor(g.VIEW/2),0,g.ARENA-g.VIEW)
end

local function n(a,b)
return a.left<=b.right and a.right>=b.left and a.bottom<=b.top and a.top>=b.bottom
end

local function t(a,b)
local l=math.floor((math.max(a.left,b.left)+math.min(a.right,b.right))/2)
local o=math.floor((math.max(a.bottom,b.bottom)+math.min(a.top,b.top))/2)
return l,o
end

function c:spark(kind,x,y)
self.sparks[#self.sparks+1]={kind=kind,x=x,y=y,timer=R}
end

function c:land(attacker,defender,hit,fromX,contactX,contactY)
local b=self:indexOf(attacker)
local a={
damage=math.max(1,math.floor(hit.damage*self.damageScale[b])),hitstun=hit.hitstun,blockstun=hit.blockstun,
chip=hit.chip,push=hit.push,knockdown=hit.knockdown,guard=hit.guard,
}
if defender:hasArmour()then
defender:absorb(a)
self:spark("guard",contactX,contactY)
self.hitstop=G
self:push({kind="block"})
return
end
if defender:canBlock(a.guard)then
defender:block(a,fromX)
self:spark("guard",contactX,contactY)
self.hitstop=G
self:push({kind="block"})
else
defender:takeHit(a,fromX)
self:spark("hit",contactX,contactY)
self.hitstop=Q
self:push({kind="hit",damage=a.damage,heavy=a.knockdown==true or a.damage>=10,by=b})
if defender.hp==0 then
self:push({kind="ko"})
end
end
if defender.x<=r or defender.x>=s then
attacker:pushAway(a.push,defender.x)
end
end

function c:resolveBlows()
local a,b=self.fighters[1],self.fighters[2]
local l,o=a:hitbox(),b:hitbox()
local u,v=a:hurtbox(),b:hurtbox()
local x=l~=nil and v~=nil and n(l,v)
local y=o~=nil and u~=nil and n(o,u)
if x then
a.hitDone=true
a.connected=true
self:land(a,b,l.move,a.x,t(l,v))
end
if y then
b.hitDone=true
b.connected=true
self:land(b,a,o.move,b.x,t(o,u))
end
end

local function o(projectile)
local a=projectile.data
return{left=projectile.x-a.half,right=projectile.x+a.half,bottom=projectile.y,top=projectile.y+a.tall}
end

function c:moveProjectiles()
local b=self.projectiles
for v=#b,1,-1 do
local a=b[v]
a.x=a.x+a.dir*a.spec.speed
a.travelled=a.travelled+a.spec.speed
a.clock=a.clock+1
local l=a.x<0 or a.x>g.ARENA or(a.spec.range and a.travelled>a.spec.range)
if not l then
local x=self.fighters[3-a.owner]
local u=x:hurtbox()
local y=o(a)
if u and n(y,u)then
self:land(self.fighters[a.owner],x,a.spec,a.x,t(y,u))
l=true
end
end
if l then
table.remove(b,v)
end
end
for u=#b,1,-1 do
for v=u-1,1,-1 do
local a,l=b[u],b[v]
if a and l and a.owner~=l.owner and n(o(a),o(l))then
self:spark("guard",math.floor((a.x+l.x)/2),a.y+4)
self:push({kind="block"})
table.remove(b,u)
table.remove(b,v)
break
end
end
end
end

function c:tickSparks()
for b=#self.sparks,1,-1 do
local a=self.sparks[b]
a.timer=a.timer-1
if a.timer<=0 then
table.remove(self.sparks,b)
end
end
end

function c:runClock()
self.secondTicks=self.secondTicks+1
if self.secondTicks>=60 then
self.secondTicks=0
self.seconds=math.max(0,self.seconds-1)
end
end

local function b(fighter)
return fighter.state==h.STATE_KO
end

function c:tickFight(held1,held2)
local a,l=self.fighters[1],self.fighters[2]
if self.brain and held2==nil then
held2=self.brain:act(l,a)
end
if self.hitstop>0 then
self.hitstop=self.hitstop-1
a:holdInput(held1 or k)
l:holdInput(held2 or k)
self:tickSparks()
return
end
self:setBounds()
self:face()
a:update(held1 or k,self)
l:update(held2 or k,self)
self:separate()
self:resolveBlows()
self:moveProjectiles()
self:tickSparks()
self:runClock()
if b(a)or b(l)then
self.phase=c.PHASE_KO
self.phaseTimer=O
self.doubleKo=b(a)and b(l)
self.projectiles={}
elseif self.seconds==0 then
self.phase=c.PHASE_TIMEOVER
self.phaseTimer=P
self.projectiles={}
end
end

function c:endRound(winner)
local a,l=self.fighters[1],self.fighters[2]
if self.doubleKo then
self.wins[1]=self.wins[1]+1
self.wins[2]=self.wins[2]+1
elseif winner then
self.wins[winner]=self.wins[winner]+1
self.fighters[winner]:celebrate()
self.perfect=self.fighters[winner].hp==self.fighters[winner].maxHp
end
self.phase=c.PHASE_WIN
self.phaseTimer=F
self:push({kind="roundEnd",winner=winner,perfect=self.perfect,seconds=self.seconds,double=self.doubleKo})
end

function c:closeOrContinue()
local a,l=self.wins[1],self.wins[2]
if a>=i and l>=i then
self.result={winner=nil}
elseif a>=i then
self.result={winner=1}
elseif l>=i then
self.result={winner=2}
elseif self.round>=L then
self.result={winner=nil}
end
if self.result then
self.phase=c.PHASE_OVER
self:push({kind="matchEnd",winner=self.result.winner})
return
end
self:startRound()
end

function c:tick(held1,held2)
local a=self.phase
if a==c.PHASE_FIGHT then
self:tickFight(held1,held2)
if self.bannerTimer>0 then
self.bannerTimer=self.bannerTimer-1
end
elseif a~=c.PHASE_OVER then
for u,l in ipairs(self.fighters)do
l:update(k,self)
end
self:separate()
self:tickSparks()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
if a==c.PHASE_INTRO then
self.phase=c.PHASE_FIGHT
self.bannerTimer=N
self.fighters[1]:release()
self.fighters[2]:release()
self:push({kind="fight"})
elseif a==c.PHASE_KO then
local u,l=self.fighters[1],self.fighters[2]
if self.doubleKo then
self:endRound(nil)
elseif b(l)then
self:endRound(1)
else
self:endRound(2)
end
elseif a==c.PHASE_TIMEOVER then
local l,u=self.fighters[1],self.fighters[2]
if l.hp>u.hp then
self:endRound(1)
elseif u.hp>l.hp then
self:endRound(2)
else
self:endRound(nil)
end
elseif a==c.PHASE_WIN then
self:closeOrContinue()
end
end
end
self:moveCamera()
end

function c:isFighting()
return self.phase==c.PHASE_FIGHT
end

function c:isOver()
return self.phase==c.PHASE_OVER
end

function c:screenX(x)
return math.floor(x-self.camera)
end

function c:drawFighter(screen,art,index)
local a=self.fighters[index]
local l=self:screenX(a.x)
screen:layers(art.effects,(f.shadow-1)*f.width,f.width,f.height,l-f.width/2,g.GROUND_Y-f.height/2-1,K)
local u,v=J.cellOf(a:frame(),a.facing)
screen:layers(art.sheets[a.definition.id][u],v*j.width,j.width,j.height,l-j.anchor,g.GROUND_Y-j.height+1-math.floor(a.y),A)
end

function c:drawEffect(screen,art,cell,x,y,dir)
if dir<0 then
cell=cell+f.count
end
screen:layers(art.effects,(cell-1)*f.width,f.width,f.height,self:screenX(x)-f.width/2,g.GROUND_Y-math.floor(y)-f.height/2,A)
end

function c:drawEffects(screen,art)
for v,a in ipairs(self.projectiles)do
local l=a.data
local u=l.cells[math.floor(a.clock/l.spin)%#l.cells+1]
self:drawEffect(screen,art,u,a.x,a.y+math.floor(l.tall/2),a.dir)
end
for u,a in ipairs(self.sparks)do
local l=f.guard
if a.kind=="hit"then
l=math.floor(a.timer/3)%2==0 and f.spark1 or f.spark2
end
self:drawEffect(screen,art,l,a.x,a.y,1)
end
end

local function I(screen,x,y,width,height,share,fromRight)
screen:rect(x,y,width,height,e.r,e.g,e.b,1)
screen:rect(x+1,y+1,width-2,height-2,p.r,p.g,p.b,1)
local a=math.floor((width-2)*share)
if fromRight then
screen:rect(x+width-1-a,y+1,a,height-2,e.r,e.g,e.b,1)
else
screen:rect(x+1,y+1,a,height-2,e.r,e.g,e.b,1)
end
end

local function y(screen,x,won)
if won then
screen:rect(x,d.markY,d.markSize,d.markSize,e.r,e.g,e.b,1)
else
screen:rect(x,d.markY,d.markSize,d.markSize,q.r,q.g,q.b,1)
end
end

function c:drawHud(screen)
local l,u=self.fighters[1],self.fighters[2]
I(screen,d.leftX,d.barY,d.barWidth,d.barHeight,l.hp/l.maxHp,false)
I(screen,d.rightX,d.barY,d.barWidth,d.barHeight,u.hp/u.maxHp,true)
screen:text(l.definition.name,d.leftX,d.nameY,e.r,e.g,e.b,1)
screen:textRight(u.definition.name,d.rightX+d.barWidth,d.nameY,e.r,e.g,e.b,1)
local v=g.VIEW/2
screen:textCentre(tostring(self.seconds),v,d.timerY,e.r,e.g,e.b,1)
for a=1,i do
y(screen,v-12-a*d.markGap,self.wins[1]>=a)
y(screen,v+12+(a-1)*d.markGap,self.wins[2]>=a)
end
end

function c:banner()
local a=self.phase
if a==c.PHASE_INTRO then
if self.phaseTimer>E/2 then
if self:isFinalRound()then
return"FinalRound"
end
return"Round",self.round
end
return nil
elseif a==c.PHASE_FIGHT then
if self.bannerTimer>0 then
return"Fight"
end
elseif a==c.PHASE_KO then
return self.doubleKo and"DoubleKo"or"Ko"
elseif a==c.PHASE_TIMEOVER then
return"TimeOver"
elseif a==c.PHASE_WIN then
if self.perfect and self.phaseTimer>F/2 then
return"Perfect"
end
end
return nil
end

function c:draw(screen,art,haloCentre)
art.stage:draw(screen,self.camera)
local a,l=2,1
if self.fighters[1].state==h.STATE_ATTACK then
a,l=2,1
elseif self.fighters[2].state==h.STATE_ATTACK then
a,l=1,2
end
self:drawFighter(screen,art,a)
self:drawFighter(screen,art,l)
self:drawEffects(screen,art)
self:drawHud(screen)
local u,x=self:banner()
if u then
local v
if x then
v=w(u,x)
else
v=w(u)
end
haloCentre(screen,v,g.VIEW/2,S)
end
end
