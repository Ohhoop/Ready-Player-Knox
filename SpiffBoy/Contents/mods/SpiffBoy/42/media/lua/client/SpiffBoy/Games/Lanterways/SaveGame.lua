require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"
require"SpiffBoy/Games/Lanterways/Data/Flags"
require"SpiffBoy/Games/Lanterways/Data/Enemies"
require"SpiffBoy/Games/Lanterways/Field"

local c=SpiffBoy.Lanterways
local g=c.Characters
local f=c.Items
local i=c.Party
local n=c.Flags

local b={}
c.SaveGame=b

b.SLOTS=3
b.VERSION=3
b.MAX_NG=99
b.CLEARED_STEP=21
b.CHUNK=120
b.MAX_TIME=359999

local o="0123456789abcdef"

local function d(a,e,h)
return SpiffBoy.isInteger(a)and a>=e and a<=h
end

local function j(p,k)
local h={}
local a=1
while a<=#k do
local e=0
for l=0,3 do
local m=k[a+l]
if m and p[m]then
e=e+2^l
end
end
h[#h+1]=string.sub(o,e+1,e+1)
a=a+4
end
return table.concat(h)
end

local function k(a,p)
if type(a)~="string"or string.find(a,"[^0-9a-f]")then
return nil
end
local h={}
for e=1,string.len(a)do
local q=string.find(o,string.sub(a,e,e),1,true)-1
for l=0,3 do
local m=p[(e-1)*4+l+1]
if m and math.floor(q/2^l)%2==1 then
h[m]=true
end
end
end
return h
end

local function z(e)
local a={}
for l,h in ipairs(c.Skills.DUOS)do
a[#a+1]=e[h]or 0
end
return table.concat(a,",")
end

local function A(h)
if type(h)~="string"then
return nil
end
local l={}
local a=0
for p in string.gmatch(h,"[^,]+")do
a=a+1
local e=tonumber(p)
local m=c.Skills.DUOS[a]
if not m or not d(e,0,c.Skills.BOND_CAP)then
return nil
end
if e>0 then
l[m]=e
end
end
if a~=#c.Skills.DUOS then
return nil
end
return l
end

function b.encodeFlags(a)
return j(a,n.NAMES)
end

function b.decodeFlags(a)
return k(a,n.NAMES)
end

local function l(a)
if not a then
return 0
end
return f.get(a).code
end

local function B(a)
if a==0 then
return nil
end
return f.CODES[a]or false
end

local function p(a)
return table.concat({
a.level,a.xp,a.hp,a.sp,
l(a.equip.weapon),l(a.equip.armor),l(a.equip.charm),
},",")
end

local function q(m,r)
if type(r)~="string"then
return nil
end
local a={}
for h in string.gmatch(r,"[^,]+")do
local e=tonumber(h)
if not e then
return nil
end
a[#a+1]=e
end
if#a~=7 then
return nil
end
local s,t,u,v=a[1],a[2],a[3],a[4]
if not d(s,1,c.LEVEL_CAP)or not d(t,0,99999999)or not d(u,0,99999)or not d(v,0,99999)then
return nil
end
local C=g.BY_ID[m]
local e={}
for w,x in ipairs(i.SLOTS)do
if not d(a[4+w],0,#f.ORDER)then
return nil
end
local h=B(a[4+w])
if h==false then
return nil
end
if h then
local y=f.get(h)
if y.kind~=x or not f.fits(C,y)then
return nil
end
end
e[x]=h
end
if not e.weapon or not e.armor then
return nil
end
local h={id=m,level=s,xp=t,hp=u,sp=v,equip=e}
i.clamp(h)
return h
end

local function C(s)
local e={}
local a=""
for t,r in ipairs(f.ORDER)do
local h=s[r]
if h and h>0 then
local m=f.get(r).code..":"..h
if a~=""and string.len(a)+string.len(m)+1>b.CHUNK then
e[#e+1]=a
a=""
end
if a==""then
a=m
else
a=a..","..m
end
end
end
if a~=""then
e[#e+1]=a
end
return e
end

local function D(a)
if type(a)~="table"then
return nil
end
local e={}
for v,h in ipairs(a)do
if type(h)~="string"then
return nil
end
for s,t in string.gmatch(h,"(%d+):(%d+)")do
local u,m=tonumber(s),tonumber(t)
local r=f.CODES[u]
if not r or not d(m,1,f.MAX_STACK)then
return nil
end
e[r]=m
end
end
return e
end

function b.encode(a)
local h={}
local e=""
for s,m in ipairs(a.order)do
local r=g.BY_ID[m]
h[r.code]=p(a.members[m])
e=e..r.code
end
local m={}
for r,s in pairs(a.carry)do
m[g.BY_ID[r].code]=p(s)
end
local r={
v=b.VERSION,
step=a.step,
map=a.map,
x=a.x,
y=a.y,
d=a.dir,
gold=a.gold,
time=math.min(b.MAX_TIME,math.floor(a.time)),
flags=b.encodeFlags(a.flags),
order=e,
m=h,
items=C(a.items),
seen=j(a.seen,c.Enemies.ORDER),
known=j(a.known,c.Enemies.ORDER),
bonds=z(a.bonds),
ng=a.ng,
c=m,
}
if a.inn then
r.inn=a.inn.map..","..a.inn.x..","..a.inn.y
end
return r
end

function b.decode(a)
if type(a)~="table"or a.v~=b.VERSION then
return nil
end
if not d(a.step,0,999)or type(a.map)~="string"or not c.Maps[a.map]then
return nil
end
local m=c.Field.prepare(c.Maps[a.map])
if not d(a.x,0,m.width-1)or not d(a.y,0,m.height-1)or not d(a.d,1,4)then
return nil
end
if not d(a.gold,0,i.GOLD_CAP)or not d(a.time,0,b.MAX_TIME)or not d(a.ng,0,b.MAX_NG)then
return nil
end
local r=b.decodeFlags(a.flags)
local s=D(a.items)
local t=k(a.seen,c.Enemies.ORDER)
local u=k(a.known,c.Enemies.ORDER)
local v=A(a.bonds)
if not r or not s or not t or not u or not v or type(a.order)~="string"or type(a.m)~="table"or type(a.c)~="table"then
return nil
end
local e={
step=a.step,flags=r,gold=a.gold,items=s,members={},order={},
glow=0,map=a.map,x=a.x,y=a.y,dir=a.d,time=a.time,
seen=t,known=u,bonds=v,ng=a.ng,carry={},
}
for w,y in pairs(a.c)do
local h=type(w)=="string"and g.BY_CODE[w]
if not h then
return nil
end
local x=q(h.id,y)
if not x then
return nil
end
e.carry[h.id]=x
end
for w=1,string.len(a.order)do
local x=string.sub(a.order,w,w)
local h=g.BY_CODE[x]
if not h or e.members[h.id]then
return nil
end
local y=q(h.id,a.m[x])
if not y then
return nil
end
e.members[h.id]=y
e.order[#e.order+1]=h.id
end
if e.order[1]~="pell"then
return nil
end
for h in pairs(e.carry)do
if e.members[h]then
return nil
end
end
if a.inn~=nil then
if type(a.inn)~="string"then
return nil
end
local h,w,x=string.match(a.inn,"^(%a+),(%d+),(%d+)$")
if not h or not c.Maps[h]then
return nil
end
e.inn={map=h,x=tonumber(w),y=tonumber(x)}
end
return e
end

function b.summary(e)
local a=b.decode(e)
if not a then
return nil
end
return{level=a.members.pell.level,map=a.map,time=a.time,step=a.step,order=a.order,cleared=b.cleared(a)}
end

function b.cleared(a)
return a.step>=b.CLEARED_STEP
end
