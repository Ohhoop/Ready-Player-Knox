require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/StreetBiter/Roster"
require"SpiffBoy/Games/StreetBiter/Moves"
require"SpiffBoy/Games/StreetBiter/Fighter"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local r=SpiffBoy.StreetBiter.Roster
local o=SpiffBoy.StreetBiter.Moves
local s=SpiffBoy.StreetBiter.Fighter

local e={}
e.__index=e
SpiffBoy.StreetBiter.Brain=e

e.LEVELS={
{key="e",text="Easy",reaction=26,aggression=0.3,block=0.25,special=0.12,jump=0.1,damage=0.7},
{key="n",text="Normal",reaction=16,aggression=0.5,block=0.55,special=0.25,jump=0.15,damage=1},
{key="h",text="Hard",reaction=9,aggression=0.7,block=0.8,special=0.4,jump=0.2,damage=1.3},
}

local l={reaction=-1.5,aggression=0.03,block=0.04,special=0.03}
local t=50
local u=82
local v=112
local w=100
local x=62
local g={attack=10,approach=20,retreat=14,block=22,wait=12,jump=8,motion=6}
local p={"kick","highkick","straight","ckick","sweep"}
local q={"jab","straight","kick","cpunch","ckick","sweep","highkick"}

function e.settings(a,b)
return{
reaction=math.max(4,math.floor(a.reaction+l.reaction*b)),
aggression=math.min(0.95,a.aggression+l.aggression*b),
block=math.min(0.95,a.block+l.block*b),
special=math.min(0.7,a.special+l.special*b),
jump=a.jump,
}
end

function e.new(b,c)
local a=setmetatable({},e)
a.settings=b
a.random=c
a.plan=nil
a.wait=0
return a
end

local function b(c,d,h,i,f)
local a={up=i==true,down=h==true,left=false,right=false,a=f=="a",b=f=="b"}
if d==1 then
if c>0 then
a.right=true
else
a.left=true
end
elseif d==-1 then
if c>0 then
a.left=true
else
a.right=true
end
end
return a
end

local function m(h,i)
local j=o.NORMALS[i]
local a=j.input
local k=string.sub(a,-1)=="A"and"a"or"b"
local c=0
local d=false
local f=false
if string.find(a,"6")or string.find(a,"3")then
c=1
end
if string.find(a,"2")or string.find(a,"3")then
d=true
end
if string.find(a,"8")then
f=true
end
return{b(h,c,d,f,k),b(h,c,d,f,nil)}
end

local function n(f,h)
local i=r.MOTIONS[h.motion].label
local c={}
for j,a in ipairs(i)do
local d=0
if a==6 or a==3 then
d=1
elseif a==4 or a==1 then
d=-1
end
local k=a<=3
c[j]=b(f,d,k,false,j==#i and h.button or nil)
end
c[#c+1]=b(f,0,false,false,nil)
return c
end

local function h(a,c)
return{ticks=c,actions=a}
end

local function f(a)
return{ticks=#a,script=a}
end

function e:choose(a,i)
local d=self.settings
local c=self.random
local j=(i.x-a.x)*a.facing
local y=i.state==s.STATE_ATTACK and i.move.far and j<=i.move.far+10
if y and c:chance(d.block)then
local k=i.move.guard==o.GUARD_LOW
return h(b(a.facing,-1,k,false,nil),g.block)
end
if i:airborne()and j<x and c:chance(d.block)then
for z,k in ipairs(a.definition.specials)do
if k.move=="flipKick"and c:chance(d.special*2)then
return f(n(a.facing,k))
end
end
return f(m(a.facing,"cpunch"))
end
if j>v then
if c:chance(d.special)then
for z,k in ipairs(a.definition.specials)do
if o.SPECIALS[k.move].projectile then
return f(n(a.facing,k))
end
end
end
if c:chance(d.jump)then
return h(b(a.facing,1,false,true,nil),g.jump)
end
return h(b(a.facing,1,false,false,nil),g.approach)
end
if j>u then
if c:chance(d.jump)and j<w then
return f({b(a.facing,1,false,true,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,nil),b(a.facing,1,false,false,"b")})
end
if c:chance(d.special)then
local k=a.definition.specials[c:int(1,#a.definition.specials)]
return f(n(a.facing,k))
end
return h(b(a.facing,1,false,false,nil),g.approach)
end
if j>t then
if c:chance(d.aggression)then
return f(m(a.facing,p[c:int(1,#p)]))
end
if c:chance(0.3)then
return h(b(a.facing,-1,false,false,nil),g.retreat)
end
return h(b(a.facing,1,false,false,nil),g.approach)
end
if c:chance(d.aggression)then
if c:chance(d.special)then
local k=a.definition.specials[c:int(1,#a.definition.specials)]
return f(n(a.facing,k))
end
local z=a.definition.chain
if c:chance(0.35)then
local k={}
for C,A in ipairs(z)do
for D,B in ipairs(m(a.facing,A))do
k[#k+1]=B
end
k[#k+1]=b(a.facing,0,false,false,nil)
end
return f(k)
end
return f(m(a.facing,q[c:int(1,#q)]))
end
if c:chance(0.5)then
return h(b(a.facing,-1,c:chance(0.5),false,nil),g.retreat)
end
return h(b(a.facing,0,false,false,nil),g.wait)
end

function e:act(c,d)
local a=self.plan
if a and a.ticks>0 then
a.ticks=a.ticks-1
if a.script then
return a.script[#a.script-a.ticks]
end
return a.actions
end
if self.wait>0 then
self.wait=self.wait-1
return b(c.facing,0,false,false,nil)
end
self.wait=self.random:int(math.floor(self.settings.reaction/2),self.settings.reaction)
self.plan=self:choose(c,d)
return self:act(c,d)
end
