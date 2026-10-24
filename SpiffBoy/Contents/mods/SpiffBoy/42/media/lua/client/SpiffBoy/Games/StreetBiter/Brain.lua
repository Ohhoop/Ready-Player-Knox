require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Fighter"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local p=SpiffBoy.StreetBiter.Roster
local m=SpiffBoy.StreetBiter.Moves
local q=SpiffBoy.StreetBiter.Fighter

local d={}
d.__index=d
SpiffBoy.StreetBiter.Brain=d

d.LEVELS={
{key="e",text="Easy",reaction=26,aggression=0.3,block=0.25,special=0.12,jump=0.1,damage=0.7},
{key="n",text="Normal",reaction=16,aggression=0.5,block=0.55,special=0.25,jump=0.15,damage=1},
{key="h",text="Hard",reaction=9,aggression=0.7,block=0.8,special=0.4,jump=0.2,damage=1.3},
}

local j={reaction=-1.5,aggression=0.03,block=0.04,special=0.03}
local r=50
local s=82
local t=112
local u=100
local v=62
local f={attack=10,approach=20,retreat=14,block=22,wait=12,jump=8,motion=6}
local n={"kick","highkick","straight","ckick","sweep"}
local o={"jab","straight","kick","cpunch","ckick","sweep","highkick"}

function d.settings(level,rank)
return{
reaction=math.max(4,math.floor(level.reaction+j.reaction*rank)),
aggression=math.min(0.95,level.aggression+j.aggression*rank),
block=math.min(0.95,level.block+j.block*rank),
special=math.min(0.7,level.special+j.special*rank),
jump=level.jump,
}
end

function d.new(settings,random)
local a=setmetatable({},d)
a.settings=settings
a.random=random
a.plan=nil
a.wait=0
return a
end

local function a(facing,toward,down,up,button)
local b={up=up==true,down=down==true,left=false,right=false,a=button=="a",b=button=="b"}
if toward==1 then
if facing>0 then
b.right=true
else
b.left=true
end
elseif toward==-1 then
if facing>0 then
b.left=true
else
b.right=true
end
end
return b
end

local function k(facing,name)
local h=m.NORMALS[name]
local b=h.input
local i=string.sub(b,-1)=="A"and"a"or"b"
local c=0
local e=false
local g=false
if string.find(b,"6")or string.find(b,"3")then
c=1
end
if string.find(b,"2")or string.find(b,"3")then
e=true
end
if string.find(b,"8")then
g=true
end
return{a(facing,c,e,g,i),a(facing,c,e,g,nil)}
end

local function l(facing,special)
local g=p.MOTIONS[special.motion].label
local c={}
for h,b in ipairs(g)do
local e=0
if b==6 or b==3 then
e=1
elseif b==4 or b==1 then
e=-1
end
local i=b<=3
c[h]=a(facing,e,i,false,h==#g and special.button or nil)
end
c[#c+1]=a(facing,0,false,false,nil)
return c
end

local function g(actions,ticks)
return{ticks=ticks,actions=actions}
end

local function e(script)
return{ticks=#script,script=script}
end

function d:choose(me,foe)
local c=self.settings
local b=self.random
local h=(foe.x-me.x)*me.facing
local w=foe.state==q.STATE_ATTACK and foe.move.far and h<=foe.move.far+10
if w and b:chance(c.block)then
local i=foe.move.guard==m.GUARD_LOW
return g(a(me.facing,-1,i,false,nil),f.block)
end
if foe:airborne()and h<v and b:chance(c.block)then
for x,i in ipairs(me.definition.specials)do
if i.move=="flipKick"and b:chance(c.special*2)then
return e(l(me.facing,i))
end
end
return e(k(me.facing,"cpunch"))
end
if h>t then
if b:chance(c.special)then
for x,i in ipairs(me.definition.specials)do
if m.SPECIALS[i.move].projectile then
return e(l(me.facing,i))
end
end
end
if b:chance(c.jump)then
return g(a(me.facing,1,false,true,nil),f.jump)
end
return g(a(me.facing,1,false,false,nil),f.approach)
end
if h>s then
if b:chance(c.jump)and h<u then
return e({a(me.facing,1,false,true,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,nil),a(me.facing,1,false,false,"b")})
end
if b:chance(c.special)then
local i=me.definition.specials[b:int(1,#me.definition.specials)]
return e(l(me.facing,i))
end
return g(a(me.facing,1,false,false,nil),f.approach)
end
if h>r then
if b:chance(c.aggression)then
return e(k(me.facing,n[b:int(1,#n)]))
end
if b:chance(0.3)then
return g(a(me.facing,-1,false,false,nil),f.retreat)
end
return g(a(me.facing,1,false,false,nil),f.approach)
end
if b:chance(c.aggression)then
if b:chance(c.special)then
local i=me.definition.specials[b:int(1,#me.definition.specials)]
return e(l(me.facing,i))
end
local x=me.definition.chain
if b:chance(0.35)then
local i={}
for A,y in ipairs(x)do
for B,z in ipairs(k(me.facing,y))do
i[#i+1]=z
end
i[#i+1]=a(me.facing,0,false,false,nil)
end
return e(i)
end
return e(k(me.facing,o[b:int(1,#o)]))
end
if b:chance(0.5)then
return g(a(me.facing,-1,b:chance(0.5),false,nil),f.retreat)
end
return g(a(me.facing,0,false,false,nil),f.wait)
end

function d:act(me,foe)
local b=self.plan
if b and b.ticks>0 then
b.ticks=b.ticks-1
if b.script then
return b.script[#b.script-b.ticks]
end
return b.actions
end
if self.wait>0 then
self.wait=self.wait-1
return a(me.facing,0,false,false,nil)
end
self.wait=self.random:int(math.floor(self.settings.reaction/2),self.settings.reaction)
self.plan=self:choose(me,foe)
return self:act(me,foe)
end
