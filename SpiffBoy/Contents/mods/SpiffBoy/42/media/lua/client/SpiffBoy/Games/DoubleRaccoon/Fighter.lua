require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/DoubleRaccoon/Combat"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local d=SpiffBoy.DoubleRaccoon.Combat

local a={}
a.__index=a
SpiffBoy.DoubleRaccoon.Fighter=a

a.MAX_HP=24

local f=1.25
local g=0.75
local l=10
local q=20
local h=9
local r=7
local s=30
local t={"walk1","walk2","walk3","walk4"}
local u={"idle1","idle2"}
local v=16
local w=30
local m=60
local x=10
local y=60
local n=80
local o=8
local z=120
local A=3
local B=30
local C=12
local D=3
local E=14
local F=7
local e={ticks=12,hit=4,near=2,far=20,damage=3}
local i={ticks=18,hit=9,raise=8}
local j={
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

function a.new(c,k)
local b=setmetatable({},a)
b.x=c
b.z=k
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

function a:update(k,b)
self.clock=self.clock+1
if self.guard>0 then
self.guard=self.guard-1
end
if self.comboWindow>0 then
self.comboWindow=self.comboWindow-1
end
local c=self.state
if c=="stand"or c=="walk"then
self:control(k,b)
elseif c=="attack"then
self:tickAttack(k,b)
elseif c=="swing"then
self:tickSwing(b)
elseif c=="elbow"then
self:tickElbow(b)
elseif c=="hold"then
self:tickHold(k,b)
elseif c=="throw"then
self:tickThrow(b)
elseif c=="pickup"then
self:tickPickup(b)
else
self:tickStunned(b)
end
self.x=SpiffBoy.clamp(self.x,b.left+l,b.right-l)
end

function a:control(b,k)
if not b then
self.state="stand"
return
end
if b.pressed.a then
self:startAttack(k)
return
end
if b.pressed.b then
self:startAction(k)
return
end
local c,p=b:axes()
if c~=0 then
self.facing=c
end
if c~=0 or p~=0 then
self.state="walk"
self.x=self.x+c*f
self.z=d.clampDepth(self.z+p*g)
else
self.state="stand"
end
end

function a:startAttack(b)
self.timer=0
if self.weapon then
self.state="swing"
b:effect("whoosh")
return
end
if self.comboWindow>0 then
self.combo=self.combo%#j+1
else
self.combo=1
end
self.state="attack"
self.queued=false
end

function a:startAction(b)
self.timer=0
if b:itemAt(self)then
self.state="pickup"
return
end
local c=b.horde:grabTarget(self)
if c then
self.held=c
c:grab(self)
self.state="hold"
b:effect("grab")
return
end
self.state="elbow"
b:effect("whoosh")
end

function a:tickAttack(k,c)
local b=j[self.combo]
self.timer=self.timer+1
if self.timer==b.hit then
local p=c.horde:strike(self,b.near,b.far,h,b.damage,b.knock,c)
c:effect(p>0 and b.effect or"whoosh")
end
if k and k.pressed.a and self.timer>=b.hit then
self.queued=true
end
if self.timer>=b.ticks then
self.state="stand"
self.comboWindow=q
if self.queued then
self:startAttack(c)
end
end
end

function a:tickSwing(b)
local c=a.WEAPONS[self.weapon]
self.timer=self.timer+1
if self.timer==i.hit then
local k=b.horde:strike(self,2,c.far,h,c.damage,c.knock,b)
if k>0 then
b:effect(c.effect)
self.durability=self.durability-k
if self.durability<=0 then
self.weapon=nil
b:effect("break")
end
end
end
if self.timer>=i.ticks then
self.state="stand"
end
end

function a:tickElbow(b)
self.timer=self.timer+1
if self.timer==e.hit then
self.facing=-self.facing
local c=b.horde:strike(self,e.near,e.far,h,e.damage,false,b)
self.facing=-self.facing
if c>0 then
b:effect("punch")
end
end
if self.timer>=e.ticks then
self.state="stand"
end
end

function a:tickHold(b,c)
self.timer=self.timer+1
if not self.held or self.held.state~="held"then
self.held=nil
self.state="stand"
return
end
if(b and b.pressed.a)or self.timer>=B then
self.state="throw"
self.timer=0
end
end

function a:tickThrow(b)
self.timer=self.timer+1
if self.timer==D and self.held then
b.horde:throw(self.held,self.facing,b)
self.held=nil
b:effect("throw")
end
if self.timer>=C then
self.state="stand"
end
end

function a:tickPickup(b)
self.timer=self.timer+1
if self.timer==F then
local c=b:takeItem(self)
if c then
local k=a.FOOD[c.kind]
if k then
self.hp=math.min(a.MAX_HP,self.hp+k)
b:effect("eat")
else
if self.weapon then
b:dropWeapon(self.weapon,self.durability,self.x,self.z)
end
self.weapon=c.kind
self.durability=c.durability
b:effect("pickup")
end
end
end
if self.timer>=E then
self.state="stand"
end
end

function a:tickStunned(b)
self.timer=self.timer-1
if self.timer>0 then
return
end
if self.state=="hurt"then
self.state="stand"
elseif self.state=="down"then
self.state="rise"
self.timer=x
elseif self.state=="rise"then
self.state="stand"
self.guard=y
elseif self.state=="dead"then
b:lifeLost()
end
end

function a:releaseHeld()
if self.held then
self.held:release()
self.held=nil
end
end

function a:loseGrip(b)
self:releaseHeld()
if self.weapon then
b:dropWeapon(self.weapon,self.durability,self.x,self.z)
self.weapon=nil
end
end

function a:hurt(c,k,p,b)
if not self:vulnerable()then
return false
end
self.hp=math.max(0,self.hp-c)
self.x=self.x+d.sign(self.x-p)*A
if self.hp==0 then
self:loseGrip(b)
self.state="dead"
self.timer=n
b:effect("down")
elseif k then
self:loseGrip(b)
self.state="down"
self.timer=m
b:effect("down")
else
self:releaseHeld()
self.state="hurt"
self.timer=v
self.guard=w
b:effect("hurt")
end
return true
end

function a:respawn()
self.hp=a.MAX_HP
self.state="stand"
self.timer=0
self.guard=z
end

function a:walkTo(b,c)
self.clock=self.clock+1
self.guard=0
self.held=nil
if math.abs(self.x-b)<f and math.abs(self.z-c)<g then
self.state="stand"
self.facing=1
return
end
if math.abs(self.x-b)>=f then
self.facing=d.sign(b-self.x)
end
self.state="walk"
self.x=d.approach(self.x,b,f)
self.z=d.approach(self.z,c,g)
end

function a:frame()
local b=self.state
if b=="walk"then
return t[math.floor(self.clock/r)%4+1]
elseif b=="attack"then
return j[self.combo].frame
elseif b=="swing"then
return self.timer<i.raise and"swing1"or"swing2"
elseif b=="elbow"or b=="hold"or b=="throw"or b=="pickup"or b=="hurt"then
return b
elseif b=="down"then
return self.timer>m-o and"fall"or"down"
elseif b=="dead"then
return self.timer>n-o and"fall"or"down"
elseif b=="rise"then
return"pickup"
end
return u[math.floor(self.clock/s)%2+1]
end

function a:blinking()
return self.guard>0 and math.floor(self.guard/3)%2==1
end
