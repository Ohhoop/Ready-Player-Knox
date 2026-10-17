require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Fighter"
require"SpiffBoy/Games/StreetBiter/Stage"
require"SpiffBoy/Framework/GameTexts"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local y=SpiffBoy.GameTexts.of("StreetBiter")
local L=SpiffBoy.StreetBiter.Roster
local z=SpiffBoy.StreetBiter.Moves
local g=SpiffBoy.StreetBiter.Fighter
local f=SpiffBoy.StreetBiter.Stage

local a={}
a.__index=a
SpiffBoy.StreetBiter.Match=a

local r=SpiffBoy.Cartridges.SHADES[4]
local c=SpiffBoy.Cartridges.SHADES[1]
local s=SpiffBoy.Cartridges.SHADES[2]
local A={1,2,3,4}
local M={3}
local k={width=72,height=64,anchor=36}
local e={width=20,height=12,count=12,spark1=9,spark2=10,guard=11,shadow=12}
local t=16
local u=f.ARENA-16
local B=110
local C=250
local m=150
local D=26
local i=2
local N=5
local O=99
local E=100
local P=40
local Q=70
local F=110
local R=80
local S=4
local G=2
local T=10
local b={barY=3,barHeight=6,barWidth=76,leftX=4,rightX=100,nameY=6,timerY=-1,markY=12,markSize=4,markGap=6}
local U=44
local l={up=false,down=false,left=false,right=false,a=false,b=false}

a.PHASE_INTRO="intro"
a.PHASE_FIGHT="fight"
a.PHASE_KO="ko"
a.PHASE_TIMEOVER="timeover"
a.PHASE_WIN="win"
a.PHASE_OVER="over"

function a.new(h,j,n,o)
local d=setmetatable({},a)
d.definitions={h,j}
d.fighters={g.new(h,B,1),g.new(j,C,-1)}
d.brain=n
d.damageScale={1,o or 1}
d.wins={0,0}
d.round=0
d.projectiles={}
d.sparks={}
d.events={}
d.hitstop=0
d.camera=0
d.result=nil
d.perfect=false
d:startRound()
return d
end

function a:startRound()
self.round=self.round+1
self.fighters[1]:reset(B,1)
self.fighters[2]:reset(C,-1)
self.projectiles={}
self.sparks={}
self.seconds=O
self.secondTicks=0
self.phase=a.PHASE_INTRO
self.phaseTimer=E
self.bannerTimer=0
self.hitstop=0
self.doubleKo=false
self.perfect=false
self:setBounds()
self:moveCamera()
self:push({kind="round",round=self.round,final=self:isFinalRound()})
end

function a:isFinalRound()
return self.wins[1]==i-1 and self.wins[2]==i-1
end

function a:push(d)
self.events[#self.events+1]=d
end

function a:takeEvents()
local d=self.events
self.events={}
return d
end

function a:onMoveStarted(h,d)
self:push({kind="swing",special=z.SPECIALS[d.name]~=nil,move=d.name})
end

function a:onJump(d)
self:push({kind="jump"})
end

function a:onLanded(d)
self:push({kind="thud"})
end

function a:indexOf(d)
if self.fighters[1]==d then
return 1
end
return 2
end

function a:spawnProjectile(h,d)
local j=z.PROJECTILES[d.kind]
self.projectiles[#self.projectiles+1]={
kind=d.kind,spec=d,data=j,owner=self:indexOf(h),
x=h.x+20*h.facing,y=d.height,dir=h.facing,travelled=0,clock=0,
}
self:push({kind="projectile",projectile=d.kind})
end

function a:setBounds()
local d,h=self.fighters[1],self.fighters[2]
d.minX=math.max(t,h.x-m)
d.maxX=math.min(u,h.x+m)
h.minX=math.max(t,d.x-m)
h.maxX=math.min(u,d.x+m)
end

local function H(d,j)
local h=d.state
if(h==g.STATE_IDLE or h==g.STATE_WALK or h==g.STATE_CROUCH or h==g.STATE_WAIT)and j.x~=d.x then
if j.x>d.x then
d.facing=1
else
d.facing=-1
end
end
end

function a:face()
local d,h=self.fighters[1],self.fighters[2]
H(d,h)
H(h,d)
end

function a:separate()
local d,h=self.fighters[1],self.fighters[2]
if d:airborne()or h:airborne()then
return
end
local n=math.abs(d.x-h.x)
if n>=D then
return
end
local j=(D-n)/2
if d.x<=h.x then
d.x=math.max(d.minX,d.x-j)
h.x=math.min(h.maxX,h.x+j)
else
d.x=math.min(d.maxX,d.x+j)
h.x=math.max(h.minX,h.x-j)
end
end

function a:moveCamera()
local d=math.floor((self.fighters[1].x+self.fighters[2].x)/2)
self.camera=SpiffBoy.clamp(d-math.floor(f.VIEW/2),0,f.ARENA-f.VIEW)
end

local function n(d,h)
return d.left<=h.right and d.right>=h.left and d.bottom<=h.top and d.top>=h.bottom
end

local function v(d,h)
local j=math.floor((math.max(d.left,h.left)+math.min(d.right,h.right))/2)
local o=math.floor((math.max(d.bottom,h.bottom)+math.min(d.top,h.top))/2)
return j,o
end

function a:spark(d,h,j)
self.sparks[#self.sparks+1]={kind=d,x=h,y=j,timer=T}
end

function a:land(q,d,j,w,o,p)
local x=self:indexOf(q)
local h={
damage=math.max(1,math.floor(j.damage*self.damageScale[x])),hitstun=j.hitstun,blockstun=j.blockstun,
chip=j.chip,push=j.push,knockdown=j.knockdown,guard=j.guard,
}
if d:hasArmour()then
d:absorb(h)
self:spark("guard",o,p)
self.hitstop=G
self:push({kind="block"})
return
end
if d:canBlock(h.guard)then
d:block(h,w)
self:spark("guard",o,p)
self.hitstop=G
self:push({kind="block"})
else
d:takeHit(h,w)
self:spark("hit",o,p)
self.hitstop=S
self:push({kind="hit",damage=h.damage,heavy=h.knockdown==true or h.damage>=10,by=x})
if d.hp==0 then
self:push({kind="ko"})
end
end
if d.x<=t or d.x>=u then
q:pushAway(h.push,d.x)
end
end

function a:resolveBlows()
local d,h=self.fighters[1],self.fighters[2]
local j,o=d:hitbox(),h:hitbox()
local p,q=d:hurtbox(),h:hurtbox()
local w=j~=nil and q~=nil and n(j,q)
local x=o~=nil and p~=nil and n(o,p)
if w then
d.hitDone=true
d.connected=true
self:land(d,h,j.move,d.x,v(j,q))
end
if x then
h.hitDone=true
h.connected=true
self:land(h,d,o.move,h.x,v(o,p))
end
end

local function w(d)
local h=d.data
return{left=d.x-h.half,right=d.x+h.half,bottom=d.y,top=d.y+h.tall}
end

function a:moveProjectiles()
local h=self.projectiles
for p=#h,1,-1 do
local d=h[p]
d.x=d.x+d.dir*d.spec.speed
d.travelled=d.travelled+d.spec.speed
d.clock=d.clock+1
local j=d.x<0 or d.x>f.ARENA or(d.spec.range and d.travelled>d.spec.range)
if not j then
local q=self.fighters[3-d.owner]
local o=q:hurtbox()
local x=w(d)
if o and n(x,o)then
self:land(self.fighters[d.owner],q,d.spec,d.x,v(x,o))
j=true
end
end
if j then
table.remove(h,p)
end
end
for o=#h,1,-1 do
for p=o-1,1,-1 do
local d,j=h[o],h[p]
if d and j and d.owner~=j.owner and n(w(d),w(j))then
self:spark("guard",math.floor((d.x+j.x)/2),d.y+4)
self:push({kind="block"})
table.remove(h,o)
table.remove(h,p)
break
end
end
end
end

function a:tickSparks()
for h=#self.sparks,1,-1 do
local d=self.sparks[h]
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.sparks,h)
end
end
end

function a:runClock()
self.secondTicks=self.secondTicks+1
if self.secondTicks>=60 then
self.secondTicks=0
self.seconds=math.max(0,self.seconds-1)
end
end

local function h(d)
return d.state==g.STATE_KO
end

function a:tickFight(p,o)
local d,j=self.fighters[1],self.fighters[2]
if self.brain and o==nil then
o=self.brain:act(j,d)
end
if self.hitstop>0 then
self.hitstop=self.hitstop-1
d:holdInput(p or l)
j:holdInput(o or l)
self:tickSparks()
return
end
self:setBounds()
self:face()
d:update(p or l,self)
j:update(o or l,self)
self:separate()
self:resolveBlows()
self:moveProjectiles()
self:tickSparks()
self:runClock()
if h(d)or h(j)then
self.phase=a.PHASE_KO
self.phaseTimer=Q
self.doubleKo=h(d)and h(j)
self.projectiles={}
elseif self.seconds==0 then
self.phase=a.PHASE_TIMEOVER
self.phaseTimer=R
self.projectiles={}
end
end

function a:endRound(d)
local j,o=self.fighters[1],self.fighters[2]
if self.doubleKo then
self.wins[1]=self.wins[1]+1
self.wins[2]=self.wins[2]+1
elseif d then
self.wins[d]=self.wins[d]+1
self.fighters[d]:celebrate()
self.perfect=self.fighters[d].hp==self.fighters[d].maxHp
end
self.phase=a.PHASE_WIN
self.phaseTimer=F
self:push({kind="roundEnd",winner=d,perfect=self.perfect,seconds=self.seconds,double=self.doubleKo})
end

function a:closeOrContinue()
local d,j=self.wins[1],self.wins[2]
if d>=i and j>=i then
self.result={winner=nil}
elseif d>=i then
self.result={winner=1}
elseif j>=i then
self.result={winner=2}
elseif self.round>=N then
self.result={winner=nil}
end
if self.result then
self.phase=a.PHASE_OVER
self:push({kind="matchEnd",winner=self.result.winner})
return
end
self:startRound()
end

function a:tick(p,q)
local d=self.phase
if d==a.PHASE_FIGHT then
self:tickFight(p,q)
if self.bannerTimer>0 then
self.bannerTimer=self.bannerTimer-1
end
elseif d~=a.PHASE_OVER then
for o,j in ipairs(self.fighters)do
j:update(l,self)
end
self:separate()
self:tickSparks()
self.phaseTimer=self.phaseTimer-1
if self.phaseTimer<=0 then
if d==a.PHASE_INTRO then
self.phase=a.PHASE_FIGHT
self.bannerTimer=P
self.fighters[1]:release()
self.fighters[2]:release()
self:push({kind="fight"})
elseif d==a.PHASE_KO then
local o,j=self.fighters[1],self.fighters[2]
if self.doubleKo then
self:endRound(nil)
elseif h(j)then
self:endRound(1)
else
self:endRound(2)
end
elseif d==a.PHASE_TIMEOVER then
local j,o=self.fighters[1],self.fighters[2]
if j.hp>o.hp then
self:endRound(1)
elseif o.hp>j.hp then
self:endRound(2)
else
self:endRound(nil)
end
elseif d==a.PHASE_WIN then
self:closeOrContinue()
end
end
end
self:moveCamera()
end

function a:isFighting()
return self.phase==a.PHASE_FIGHT
end

function a:isOver()
return self.phase==a.PHASE_OVER
end

function a:screenX(d)
return math.floor(d-self.camera)
end

function a:drawFighter(j,o,q)
local d=self.fighters[q]
local p=self:screenX(d.x)
j:layers(o.effects,(e.shadow-1)*e.width,e.width,e.height,p-e.width/2,f.GROUND_Y-e.height/2-1,M)
local x,I=L.cellOf(d:frame(),d.facing)
j:layers(o.sheets[d.definition.id][x],I*k.width,k.width,k.height,p-k.anchor,f.GROUND_Y-k.height+1-math.floor(d.y),A)
end

function a:drawEffect(j,o,d,p,q,x)
if x<0 then
d=d+e.count
end
j:layers(o.effects,(d-1)*e.width,e.width,e.height,self:screenX(p)-e.width/2,f.GROUND_Y-math.floor(q)-e.height/2,A)
end

function a:drawEffects(o,p)
for x,d in ipairs(self.projectiles)do
local j=d.data
local q=j.cells[math.floor(d.clock/j.spin)%#j.cells+1]
self:drawEffect(o,p,q,d.x,d.y+math.floor(j.tall/2),d.dir)
end
for q,d in ipairs(self.sparks)do
local j=e.guard
if d.kind=="hit"then
j=math.floor(d.timer/3)%2==0 and e.spark1 or e.spark2
end
self:drawEffect(o,p,j,d.x,d.y,1)
end
end

local function I(d,j,o,p,q,J,K)
d:rect(j,o,p,q,c.r,c.g,c.b,1)
d:rect(j+1,o+1,p-2,q-2,r.r,r.g,r.b,1)
local x=math.floor((p-2)*J)
if K then
d:rect(j+p-1-x,o+1,x,q-2,c.r,c.g,c.b,1)
else
d:rect(j+1,o+1,x,q-2,c.r,c.g,c.b,1)
end
end

local function J(d,j,o)
if o then
d:rect(j,b.markY,b.markSize,b.markSize,c.r,c.g,c.b,1)
else
d:rect(j,b.markY,b.markSize,b.markSize,s.r,s.g,s.b,1)
end
end

function a:drawHud(d)
local o,p=self.fighters[1],self.fighters[2]
I(d,b.leftX,b.barY,b.barWidth,b.barHeight,o.hp/o.maxHp,false)
I(d,b.rightX,b.barY,b.barWidth,b.barHeight,p.hp/p.maxHp,true)
d:text(o.definition.name,b.leftX,b.nameY,c.r,c.g,c.b,1)
d:textRight(p.definition.name,b.rightX+b.barWidth,b.nameY,c.r,c.g,c.b,1)
local q=f.VIEW/2
d:textCentre(tostring(self.seconds),q,b.timerY,c.r,c.g,c.b,1)
for j=1,i do
J(d,q-12-j*b.markGap,self.wins[1]>=j)
J(d,q+12+(j-1)*b.markGap,self.wins[2]>=j)
end
end

function a:banner()
local d=self.phase
if d==a.PHASE_INTRO then
if self.phaseTimer>E/2 then
if self:isFinalRound()then
return"FinalRound"
end
return"Round",self.round
end
return nil
elseif d==a.PHASE_FIGHT then
if self.bannerTimer>0 then
return"Fight"
end
elseif d==a.PHASE_KO then
return self.doubleKo and"DoubleKo"or"Ko"
elseif d==a.PHASE_TIMEOVER then
return"TimeOver"
elseif d==a.PHASE_WIN then
if self.perfect and self.phaseTimer>F/2 then
return"Perfect"
end
end
return nil
end

function a:draw(d,j,V)
j.stage:draw(d,self.camera)
local o,p=2,1
if self.fighters[1].state==g.STATE_ATTACK then
o,p=2,1
elseif self.fighters[2].state==g.STATE_ATTACK then
o,p=1,2
end
self:drawFighter(d,j,o)
self:drawFighter(d,j,p)
self:drawEffects(d,j)
self:drawHud(d)
local q,K=self:banner()
if q then
local x
if K then
x=y(q,K)
else
x=y(q)
end
V(d,x,f.VIEW/2,U)
end
end
