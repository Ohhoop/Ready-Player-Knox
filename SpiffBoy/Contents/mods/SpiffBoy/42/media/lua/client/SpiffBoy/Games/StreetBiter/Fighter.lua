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

local o=1.3
local p=1.0
local q=5.2
local j=1.6
local r=0.28
local f=24
local s=20
local t=10
local k=8
local u=3.2
local v=1.6
local w=40
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

function a.new(definition,x,facing)
local b=setmetatable({},a)
b.definition=definition
b.maxHp=definition.health
b.specials={}
for e,d in ipairs(definition.specials)do
b.specials[#b.specials+1]={motion=i.MOTIONS[d.motion].pattern,button=d.button,move=c.SPECIALS[d.move]}
end
b.chainList={}
for e,d in ipairs(i.STANDARD_CHAINS)do
b.chainList[#b.chainList+1]=d
end
b.chainList[#b.chainList+1]=definition.chain
b.drift=0
b:reset(x,facing)
return b
end

function a:reset(x,facing)
self.x=x
self.y=0
self.vy=0
self.facing=facing
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
for b=1,f do
self.history[b]=5
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

local function x(held,facing)
local b=0
if held.right then
b=b+1
end
if held.left then
b=b-1
end
b=b*facing
local d=0
if held.up then
d=d-1
end
if held.down then
d=d+1
end
return 5+b-d*3
end

local function e(direction)
return direction<=3
end

local function G(direction)
return direction>=7
end

local function g(direction)
return direction==1 or direction==4 or direction==7
end

local function m(direction)
return direction==3 or direction==6 or direction==9
end

function a:readInput(held)
self.direction=x(held,self.facing)
self.history[self.clock%f+1]=self.direction
self.bufferA=math.max(0,self.bufferA-1)
self.bufferB=math.max(0,self.bufferB-1)
if held.a and not self.prevA then
self.bufferA=k
self.pressDirection=self.direction
end
if held.b and not self.prevB then
self.bufferB=k
self.pressDirection=self.direction
end
self.prevA=held.a
self.prevB=held.b
end

function a:holdInput(held)
self.clock=self.clock+1
self:readInput(held)
end

function a:pressed(button)
if button=="a"then
return self.bufferA>0
end
return self.bufferB>0
end

function a:takePress()
self.bufferA=0
self.bufferB=0
end

function a:directionAgo(ago)
return self.history[(self.clock-ago)%f+1]
end

function a:motion(pattern)
local b=#pattern
local d=nil
for h=0,s-1 do
local H=self:directionAgo(h)
local I=pattern[b]
local n=false
for K,J in ipairs(I)do
if J==H then
n=true
end
end
if n then
if d==nil then
d=h
end
b=b-1
if b==0 then
return d<t
end
end
end
return false
end

function a:startMove(move,world)
self:takePress()
self.state=a.STATE_ATTACK
self.move=move
self.moveTick=0
self.connected=false
self.hitDone=false
self.armourUsed=false
self.crouching=move.crouch==true
if move.air then
self.airAttacked=true
end
world:onMoveStarted(self,move)
end

function a:chainStep()
local b=0
for h,d in ipairs(self.chains)do
b=math.max(b,d.step)
end
return b
end

function a:openChains(name)
self.chains={}
for d,b in ipairs(self.chainList)do
if b[1]==name then
self.chains[#self.chains+1]={chain=b,step=1}
end
end
end

function a:followChains(name)
local b={}
for n,d in ipairs(self.chains)do
local h=d.chain
if d.step<#h and h[d.step+1]==name then
b[#b+1]={chain=h,step=d.step+1}
end
end
self.chains=b
return#b>0
end

function a:trySpecial(world)
if self:airborne()then
return false
end
for d,b in ipairs(self.specials)do
if self:pressed(b.button)and self:motion(b.motion)then
self:startMove(b.move,world)
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

function a:tryAttack(world)
if self:trySpecial(world)then
return true
end
local b=self:normalPressed()
if not b then
return false
end
self:startMove(b,world)
self:openChains(b.name)
return true
end

function a:tryCancel(world)
local b=self.move
if not self.connected or c.SPECIALS[b.name]then
return false
end
if self.moveTick<b.startup+1 or self.moveTick>c.length(b)then
return false
end
if self:trySpecial(world)then
return true
end
local d=self:normalPressed()
if d and self:followChains(d.name)then
self:startMove(d,world)
return true
end
return false
end

function a:control(world)
local b=self.direction
if G(b)then
self.vy=q
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
world:onJump(self)
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
self.x=self.x+o*d*self.facing
elseif g(b)then
self.state=a.STATE_WALK
self.x=self.x-p*d*self.facing
else
self.state=a.STATE_IDLE
end
end

function a:tickAttack(world)
local b=self.move
self.moveTick=self.moveTick+1
local d=self.moveTick
if d==b.startup+1 and b.projectile then
world:spawnProjectile(self,b.projectile)
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
if self:tryCancel(world)then
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

function a:tickStunned(world)
local b=self.state
if b==a.STATE_KNOCKED or b==a.STATE_KO then
if not self:airborne()and self.fell then
if b==a.STATE_KNOCKED then
self.state=a.STATE_DOWN
self.timer=w
end
world:onLanded(self)
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
self.vy=self.vy-r
local b=self.state
if b==a.STATE_JUMP or(b==a.STATE_ATTACK and self.move.air)then
self.x=self.x+self.drift
elseif b==a.STATE_KNOCKED or b==a.STATE_KO then
self.x=self.x-v*self.facing
end
if self.y<=0 then
self.y=0
self.vy=0
if b==a.STATE_JUMP then
self:land()
end
end
end

function a:update(held,world)
self.clock=self.clock+1
self:readInput(held)
if self.pushTicks>0 then
self.pushTicks=self.pushTicks-1
self.x=self.x+self.pushX
end
self:fly()
local b=self.state
if b==a.STATE_ATTACK then
self:tickAttack(world)
elseif b==a.STATE_JUMP then
if not self:tryAttack(world)then
self.state=a.STATE_JUMP
end
elseif D[b]then
if not self:tryAttack(world)then
self:control(world)
end
elseif b~=a.STATE_WAIT and b~=a.STATE_WIN then
self:tickStunned(world)
end
self.x=SpiffBoy.clamp(self.x,self.minX,self.maxX)
end

function a:canBlock(guard)
if not E[self.state]or self:airborne()or guard==c.GUARD_NONE then
return false
end
if not g(self.direction)then
return false
end
local b=e(self.direction)
if guard==c.GUARD_LOW then
return b
end
if guard==c.GUARD_OVERHEAD then
return not b
end
return true
end

function a:pushAway(distance,fromX)
local b=1
if self.x<fromX then
b=-1
end
self.pushX=b*distance/l
self.pushTicks=l
end

function a:block(hit,fromX)
self.state=a.STATE_BLOCK
self.crouching=e(self.direction)
self.timer=math.max(1,hit.blockstun)
self.hp=math.max(0,self.hp-(hit.chip or 0))
self:pushAway(math.max(2,math.floor(hit.push/2)),fromX)
self.move=nil
self.chains={}
end

function a:takeHit(hit,fromX)
self.hp=math.max(0,self.hp-hit.damage)
self.move=nil
self.chains={}
self.drift=0
local b=self.hp==0
if b or hit.knockdown or self:airborne()then
self.state=b and a.STATE_KO or a.STATE_KNOCKED
self.vy=u
self.y=math.max(self.y,0.01)
self.fell=true
self.crouching=false
else
self.state=a.STATE_HIT
self.timer=hit.hitstun
end
self:pushAway(hit.push,fromX)
end

function a:absorb(hit)
self.armourUsed=true
self.hp=math.max(1,self.hp-math.floor(hit.damage/2))
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
