require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local i=SpiffBoy.StreetBiter.Roster
local c=SpiffBoy.StreetBiter.Moves

local a={}
a.__index=a
SpiffBoy.StreetBiter.Fighter=a

a.HALF_WIDTH=10
a.STAND_HEIGHT=54
a.CROUCH_HEIGHT=34
a.AIR_HEIGHT=46

local p=1.3
local q=1.0
local r=5.2
local j=1.6
local s=0.28
local f=24
local t=20
local u=10
local k=8
local v=3.2
local w=1.6
local x=40
local y=12
local z=8
local A=30
local B={"walk1","walk2","walk3","walk4"}
local C={"idle1","idle2","idle3"}
local l=5

a.STATE_IDLE="idle"
a.STATE_WALK="walk"
a.STATE_CROUCH="crouch"
a.STATE_JUMP="jump"
a.STATE_ATTACK="attack"
a.STATE_HIT="hit"
a.STATE_BLOCK="block"
a.STATE_KNOCKED="knocked"
a.STATE_DOWN="down"
a.STATE_RISE="rise"
a.STATE_KO="ko"
a.STATE_WIN="win"
a.STATE_WAIT="wait"

local D={idle=true,walk=true,crouch=true}
local E={idle=true,walk=true,crouch=true,block=true}
local F={knocked=true,down=true,rise=true,ko=true,win=true,wait=true}

function a.new(d,g,h)
local b=setmetatable({},a)
b.definition=d
b.maxHp=d.health
b.specials={}
for m,e in ipairs(d.specials)do
b.specials[#b.specials+1]={motion=i.MOTIONS[e.motion].pattern,button=e.button,move=c.SPECIALS[e.move]}
end
b.chainList={}
for m,e in ipairs(i.STANDARD_CHAINS)do
b.chainList[#b.chainList+1]=e
end
b.chainList[#b.chainList+1]=d.chain
b.drift=0
b:reset(g,h)
return b
end

function a:reset(b,d)
self.x=b
self.y=0
self.vy=0
self.facing=d
self.hp=self.maxHp
self.state=a.STATE_WAIT
self.timer=0
self.clock=0
self.move=nil
self.moveTick=0
self.connected=false
self.hitDone=false
self.armourUsed=false
self.airAttacked=false
self.chains={}
self.pushX=0
self.pushTicks=0
self.direction=5
self.history={}
for e=1,f do
self.history[e]=5
end
self.prevA=false
self.prevB=false
self.bufferA=0
self.bufferB=0
self.pressDirection=5
self.crouching=false
self.minX=0
self.maxX=0
self.fell=false
end

function a:airborne()
return self.y>0 or self.vy>0
end

function a:isInvulnerable()
if F[self.state]then
return true
end
return self.state==a.STATE_ATTACK and self.move.invulnerable~=nil and self.moveTick<=self.move.invulnerable
end

function a:hasArmour()
return self.state==a.STATE_ATTACK and self.move.armour~=nil and self.moveTick<=self.move.armour and not self.armourUsed
end

function a:height()
if self:airborne()then
return a.AIR_HEIGHT
end
if self.crouching or(self.state==a.STATE_ATTACK and self.move.crouch)then
return a.CROUCH_HEIGHT
end
return a.STAND_HEIGHT
end

function a:hurtbox()
if self:isInvulnerable()then
return nil
end
return{left=self.x-a.HALF_WIDTH,right=self.x+a.HALF_WIDTH,bottom=self.y,top=self.y+self:height()}
end

function a:hitbox()
local b=self.move
if self.state~=a.STATE_ATTACK or b.far==nil or self.hitDone or not c.isActive(b,self.moveTick)then
return nil
end
local d=self.x+b.near*self.facing
local e=self.x+b.far*self.facing
return{left=math.min(d,e),right=math.max(d,e),bottom=self.y+b.low,top=self.y+b.high,move=b}
end

local function G(e,g)
local b=0
if e.right then
b=b+1
end
if e.left then
b=b-1
end
b=b*g
local d=0
if e.up then
d=d-1
end
if e.down then
d=d+1
end
return 5+b-d*3
end

local function e(b)
return b<=3
end

local function H(b)
return b>=7
end

local function g(b)
return b==1 or b==4 or b==7
end

local function m(b)
return b==3 or b==6 or b==9
end

function a:readInput(b)
self.direction=G(b,self.facing)
self.history[self.clock%f+1]=self.direction
self.bufferA=math.max(0,self.bufferA-1)
self.bufferB=math.max(0,self.bufferB-1)
if b.a and not self.prevA then
self.bufferA=k
self.pressDirection=self.direction
end
if b.b and not self.prevB then
self.bufferB=k
self.pressDirection=self.direction
end
self.prevA=b.a
self.prevB=b.b
end

function a:holdInput(b)
self.clock=self.clock+1
self:readInput(b)
end

function a:pressed(b)
if b=="a"then
return self.bufferA>0
end
return self.bufferB>0
end

function a:takePress()
self.bufferA=0
self.bufferB=0
end

function a:directionAgo(b)
return self.history[(self.clock-b)%f+1]
end

function a:motion(h)
local b=#h
local d=nil
for n=0,t-1 do
local I=self:directionAgo(n)
local J=h[b]
local o=false
for L,K in ipairs(J)do
if K==I then
o=true
end
end
if o then
if d==nil then
d=n
end
b=b-1
if b==0 then
return d<u
end
end
end
return false
end

function a:startMove(b,d)
self:takePress()
self.state=a.STATE_ATTACK
self.move=b
self.moveTick=0
self.connected=false
self.hitDone=false
self.armourUsed=false
self.crouching=b.crouch==true
if b.air then
self.airAttacked=true
end
d:onMoveStarted(self,b)
end

function a:chainStep()
local b=0
for h,d in ipairs(self.chains)do
b=math.max(b,d.step)
end
return b
end

function a:openChains(d)
self.chains={}
for h,b in ipairs(self.chainList)do
if b[1]==d then
self.chains[#self.chains+1]={chain=b,step=1}
end
end
end

function a:followChains(n)
local b={}
for o,d in ipairs(self.chains)do
local h=d.chain
if d.step<#h and h[d.step+1]==n then
b[#b+1]={chain=h,step=d.step+1}
end
end
self.chains=b
return#b>0
end

function a:trySpecial(d)
if self:airborne()then
return false
end
for h,b in ipairs(self.specials)do
if self:pressed(b.button)and self:motion(b.motion)then
self:startMove(b.move,d)
self.chains={}
return true
end
end
return false
end

function a:normalPressed()
local b=nil
if self:pressed("a")then
b="a"
elseif self:pressed("b")then
b="b"
end
if not b then
return nil
end
if self:airborne()and self.airAttacked then
return nil
end
return c.NORMALS[c.normalFor(self.pressDirection,b,self:airborne())]
end

function a:tryAttack(d)
if self:trySpecial(d)then
return true
end
local b=self:normalPressed()
if not b then
return false
end
self:startMove(b,d)
self:openChains(b.name)
return true
end

function a:tryCancel(h)
local b=self.move
if not self.connected or c.SPECIALS[b.name]then
return false
end
if self.moveTick<b.startup+1 or self.moveTick>c.length(b)then
return false
end
if self:trySpecial(h)then
return true
end
local d=self:normalPressed()
if d and self:followChains(d.name)then
self:startMove(d,h)
return true
end
return false
end

function a:control(h)
local b=self.direction
if H(b)then
self.vy=r
self.y=0.01
self.state=a.STATE_JUMP
self.crouching=false
self.airAttacked=false
if m(b)then
self.drift=j*self.facing
elseif g(b)then
self.drift=-j*self.facing
else
self.drift=0
end
h:onJump(self)
return
end
if e(b)then
self.state=a.STATE_CROUCH
self.crouching=true
return
end
self.crouching=false
local d=self.definition.speed
if m(b)then
self.state=a.STATE_WALK
self.x=self.x+p*d*self.facing
elseif g(b)then
self.state=a.STATE_WALK
self.x=self.x-q*d*self.facing
else
self.state=a.STATE_IDLE
end
end

function a:tickAttack(h)
local b=self.move
self.moveTick=self.moveTick+1
local d=self.moveTick
if d==b.startup+1 and b.projectile then
h:spawnProjectile(self,b.projectile)
end
if b.dash and c.isActive(b,d)then
self.x=self.x+b.dash*self.facing
end
if b.rise and d<=b.startup+b.active then
self.y=self.y+b.rise
self.vy=0
elseif b.rise and d==b.startup+b.active+1 then
self.vy=0.5
end
if b.hop and d==b.startup then
self.vy=b.hop
self.y=math.max(self.y,0.01)
end
if self:tryCancel(h)then
return
end
if b.air or b.rise or b.hop then
if d>=b.startup+b.active and not self:airborne()then
self:land()
end
return
end
if d>=c.length(b)then
self.state=e(self.direction)and a.STATE_CROUCH or a.STATE_IDLE
self.crouching=e(self.direction)
self.move=nil
self.chains={}
end
end

function a:land()
self.y=0
self.vy=0
self.drift=0
self.move=nil
self.chains={}
self.airAttacked=false
self.state=a.STATE_IDLE
end

function a:tickStunned(d)
local b=self.state
if b==a.STATE_KNOCKED or b==a.STATE_KO then
if not self:airborne()and self.fell then
if b==a.STATE_KNOCKED then
self.state=a.STATE_DOWN
self.timer=x
end
d:onLanded(self)
self.fell=false
end
return
end
self.timer=self.timer-1
if self.timer>0 then
return
end
if b==a.STATE_DOWN then
self.state=a.STATE_RISE
self.timer=y
elseif b==a.STATE_RISE then
self.state=a.STATE_IDLE
self.crouching=false
else
self.state=self.crouching and a.STATE_CROUCH or a.STATE_IDLE
end
end

function a:fly()
if not self:airborne()then
return
end
self.y=self.y+self.vy
self.vy=self.vy-s
local b=self.state
if b==a.STATE_JUMP or(b==a.STATE_ATTACK and self.move.air)then
self.x=self.x+self.drift
elseif b==a.STATE_KNOCKED or b==a.STATE_KO then
self.x=self.x-w*self.facing
end
if self.y<=0 then
self.y=0
self.vy=0
if b==a.STATE_JUMP then
self:land()
end
end
end

function a:update(h,b)
self.clock=self.clock+1
self:readInput(h)
if self.pushTicks>0 then
self.pushTicks=self.pushTicks-1
self.x=self.x+self.pushX
end
self:fly()
local d=self.state
if d==a.STATE_ATTACK then
self:tickAttack(b)
elseif d==a.STATE_JUMP then
if not self:tryAttack(b)then
self.state=a.STATE_JUMP
end
elseif D[d]then
if not self:tryAttack(b)then
self:control(b)
end
elseif d~=a.STATE_WAIT and d~=a.STATE_WIN then
self:tickStunned(b)
end
self.x=SpiffBoy.clamp(self.x,self.minX,self.maxX)
end

function a:canBlock(b)
if not E[self.state]or self:airborne()or b==c.GUARD_NONE then
return false
end
if not g(self.direction)then
return false
end
local d=e(self.direction)
if b==c.GUARD_LOW then
return d
end
if b==c.GUARD_OVERHEAD then
return not d
end
return true
end

function a:pushAway(d,h)
local b=1
if self.x<h then
b=-1
end
self.pushX=b*d/l
self.pushTicks=l
end

function a:block(b,d)
self.state=a.STATE_BLOCK
self.crouching=e(self.direction)
self.timer=math.max(1,b.blockstun)
self.hp=math.max(0,self.hp-(b.chip or 0))
self:pushAway(math.max(2,math.floor(b.push/2)),d)
self.move=nil
self.chains={}
end

function a:takeHit(b,h)
self.hp=math.max(0,self.hp-b.damage)
self.move=nil
self.chains={}
self.drift=0
local d=self.hp==0
if d or b.knockdown or self:airborne()then
self.state=d and a.STATE_KO or a.STATE_KNOCKED
self.vy=v
self.y=math.max(self.y,0.01)
self.fell=true
self.crouching=false
else
self.state=a.STATE_HIT
self.timer=b.hitstun
end
self:pushAway(b.push,h)
end

function a:absorb(b)
self.armourUsed=true
self.hp=math.max(1,self.hp-math.floor(b.damage/2))
end

function a:celebrate()
if self.state~=a.STATE_KO then
self.state=a.STATE_WIN
self.y=0
self.vy=0
self.move=nil
end
end

function a:hold()
if self.state~=a.STATE_KO then
self.state=a.STATE_WAIT
self.move=nil
end
end

function a:release()
if self.state==a.STATE_WAIT then
self.state=a.STATE_IDLE
end
end

function a:frame()
local b=self.state
if b==a.STATE_ATTACK then
local d=self.move
if self.moveTick>d.startup then
return d.strike
end
return d.frame
elseif b==a.STATE_JUMP then
return"jump"
elseif b==a.STATE_WALK then
return B[math.floor(self.clock/z)%4+1]
elseif b==a.STATE_CROUCH or b==a.STATE_RISE then
return"crouch"
elseif b==a.STATE_BLOCK then
return self.crouching and"cblock"or"block"
elseif b==a.STATE_HIT then
return"hit"
elseif b==a.STATE_KNOCKED or b==a.STATE_KO then
return self:airborne()and"fall"or"down"
elseif b==a.STATE_DOWN then
return"down"
elseif b==a.STATE_WIN then
return"win"
end
return C[math.floor(self.clock/A)%3+1]
end
