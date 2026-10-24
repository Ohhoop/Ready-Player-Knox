require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/DoubleRaccoon/Combat"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local c=SpiffBoy.DoubleRaccoon.Combat

local a={}
a.__index=a
SpiffBoy.DoubleRaccoon.Fighter=a

a.MAX_HP=24

local e=1.25
local f=0.75
local j=10
local o=20
local g=9
local p=7
local q=30
local r={"walk1","walk2","walk3","walk4"}
local s={"idle1","idle2"}
local t=16
local u=30
local k=60
local v=10
local w=60
local l=80
local m=8
local y=120
local A=3
local B=30
local C=12
local D=3
local E=14
local F=7
local d={ticks=12,hit=4,near=2,far=20,damage=3}
local h={ticks=18,hit=9,raise=8}
local i={
{frame="jab",ticks=11,hit=4,near=2,far=24,damage=2,knock=false,effect="punch"},
{frame="cross",ticks=11,hit=4,near=2,far=24,damage=2,knock=false,effect="punch"},
{frame="kick",ticks=15,hit=6,near=2,far=28,damage=4,knock=true,effect="kick"},
}
a.WEAPONS={
bat={damage=5,far=34,durability=14,knock=false,effect="swing"},
pan={damage=4,far=30,durability=12,knock=false,effect="clang"},
axe={damage=7,far=32,durability=8,knock=true,effect="chop"},
}
a.FOOD={chips=8,tin=16}

function a.new(x,z)
local b=setmetatable({},a)
b.x=x
b.z=z
b.height=0
b.facing=1
b.hp=a.MAX_HP
b.state="stand"
b.timer=0
b.combo=0
b.comboWindow=0
b.queued=false
b.weapon=nil
b.durability=0
b.guard=0
b.clock=0
b.held=nil
return b
end

function a:vulnerable()
return self.guard==0 and self.state~="down"and self.state~="rise"and self.state~="dead"
end

function a:isDead()
return self.state=="dead"
end

function a:update(input,world)
self.clock=self.clock+1
if self.guard>0 then
self.guard=self.guard-1
end
if self.comboWindow>0 then
self.comboWindow=self.comboWindow-1
end
local b=self.state
if b=="stand"or b=="walk"then
self:control(input,world)
elseif b=="attack"then
self:tickAttack(input,world)
elseif b=="swing"then
self:tickSwing(world)
elseif b=="elbow"then
self:tickElbow(world)
elseif b=="hold"then
self:tickHold(input,world)
elseif b=="throw"then
self:tickThrow(world)
elseif b=="pickup"then
self:tickPickup(world)
else
self:tickStunned(world)
end
self.x=SpiffBoy.clamp(self.x,world.left+j,world.right-j)
end

function a:control(input,world)
if not input then
self.state="stand"
return
end
if input.pressed.a then
self:startAttack(world)
return
end
if input.pressed.b then
self:startAction(world)
return
end
local b,n=input:axes()
if b~=0 then
self.facing=b
end
if b~=0 or n~=0 then
self.state="walk"
self.x=self.x+b*e
self.z=c.clampDepth(self.z+n*f)
else
self.state="stand"
end
end

function a:startAttack(world)
self.timer=0
if self.weapon then
self.state="swing"
world:effect("whoosh")
return
end
if self.comboWindow>0 then
self.combo=self.combo%#i+1
else
self.combo=1
end
self.state="attack"
self.queued=false
end

function a:startAction(world)
self.timer=0
if world:itemAt(self)then
self.state="pickup"
return
end
local b=world.horde:grabTarget(self)
if b then
self.held=b
b:grab(self)
self.state="hold"
world:effect("grab")
return
end
self.state="elbow"
world:effect("whoosh")
end

function a:tickAttack(input,world)
local b=i[self.combo]
self.timer=self.timer+1
if self.timer==b.hit then
local n=world.horde:strike(self,b.near,b.far,g,b.damage,b.knock,world)
world:effect(n>0 and b.effect or"whoosh")
end
if input and input.pressed.a and self.timer>=b.hit then
self.queued=true
end
if self.timer>=b.ticks then
self.state="stand"
self.comboWindow=o
if self.queued then
self:startAttack(world)
end
end
end

function a:tickSwing(world)
local b=a.WEAPONS[self.weapon]
self.timer=self.timer+1
if self.timer==h.hit then
local n=world.horde:strike(self,2,b.far,g,b.damage,b.knock,world)
if n>0 then
world:effect(b.effect)
self.durability=self.durability-n
if self.durability<=0 then
self.weapon=nil
world:effect("break")
end
end
end
if self.timer>=h.ticks then
self.state="stand"
end
end

function a:tickElbow(world)
self.timer=self.timer+1
if self.timer==d.hit then
self.facing=-self.facing
local b=world.horde:strike(self,d.near,d.far,g,d.damage,false,world)
self.facing=-self.facing
if b>0 then
world:effect("punch")
end
end
if self.timer>=d.ticks then
self.state="stand"
end
end

function a:tickHold(input,world)
self.timer=self.timer+1
if not self.held or self.held.state~="held"then
self.held=nil
self.state="stand"
return
end
if(input and input.pressed.a)or self.timer>=B then
self.state="throw"
self.timer=0
end
end

function a:tickThrow(world)
self.timer=self.timer+1
if self.timer==D and self.held then
world.horde:throw(self.held,self.facing,world)
self.held=nil
world:effect("throw")
end
if self.timer>=C then
self.state="stand"
end
end

function a:tickPickup(world)
self.timer=self.timer+1
if self.timer==F then
local b=world:takeItem(self)
if b then
local n=a.FOOD[b.kind]
if n then
self.hp=math.min(a.MAX_HP,self.hp+n)
world:effect("eat")
else
if self.weapon then
world:dropWeapon(self.weapon,self.durability,self.x,self.z)
end
self.weapon=b.kind
self.durability=b.durability
world:effect("pickup")
end
end
end
if self.timer>=E then
self.state="stand"
end
end

function a:tickStunned(world)
self.timer=self.timer-1
if self.timer>0 then
return
end
if self.state=="hurt"then
self.state="stand"
elseif self.state=="down"then
self.state="rise"
self.timer=v
elseif self.state=="rise"then
self.state="stand"
self.guard=w
elseif self.state=="dead"then
world:lifeLost()
end
end

function a:releaseHeld()
if self.held then
self.held:release()
self.held=nil
end
end

function a:loseGrip(world)
self:releaseHeld()
if self.weapon then
world:dropWeapon(self.weapon,self.durability,self.x,self.z)
self.weapon=nil
end
end

function a:hurt(damage,heavy,fromX,world)
if not self:vulnerable()then
return false
end
self.hp=math.max(0,self.hp-damage)
self.x=self.x+c.sign(self.x-fromX)*A
if self.hp==0 then
self:loseGrip(world)
self.state="dead"
self.timer=l
world:effect("down")
elseif heavy then
self:loseGrip(world)
self.state="down"
self.timer=k
world:effect("down")
else
self:releaseHeld()
self.state="hurt"
self.timer=t
self.guard=u
world:effect("hurt")
end
return true
end

function a:respawn()
self.hp=a.MAX_HP
self.state="stand"
self.timer=0
self.guard=y
end

function a:walkTo(x,z)
self.clock=self.clock+1
self.guard=0
self.held=nil
if math.abs(self.x-x)<e and math.abs(self.z-z)<f then
self.state="stand"
self.facing=1
return
end
if math.abs(self.x-x)>=e then
self.facing=c.sign(x-self.x)
end
self.state="walk"
self.x=c.approach(self.x,x,e)
self.z=c.approach(self.z,z,f)
end

function a:frame()
local b=self.state
if b=="walk"then
return r[math.floor(self.clock/p)%4+1]
elseif b=="attack"then
return i[self.combo].frame
elseif b=="swing"then
return self.timer<h.raise and"swing1"or"swing2"
elseif b=="elbow"or b=="hold"or b=="throw"or b=="pickup"or b=="hurt"then
return b
elseif b=="down"then
return self.timer>k-m and"fall"or"down"
elseif b=="dead"then
return self.timer>l-m and"fall"or"down"
elseif b=="rise"then
return"pickup"
end
return s[math.floor(self.clock/q)%2+1]
end

function a:blinking()
return self.guard>0 and math.floor(self.guard/3)%2==1
end
