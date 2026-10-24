require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"
require"SpiffBoy/Games/Lanterways/Data/Flags"
require"SpiffBoy/Games/Lanterways/Data/Enemies"
require"SpiffBoy/Games/Lanterways/Field"

local b=SpiffBoy.Lanterways
local f=b.Characters
local e=b.Items
local i=b.Party
local n=b.Flags

local a={}
b.SaveGame=a

a.SLOTS=3
a.VERSION=3
a.MAX_NG=99
a.CLEARED_STEP=21
a.CHUNK=120
a.MAX_TIME=359999

local o="0123456789abcdef"

local function c(value,low,high)
return SpiffBoy.isInteger(value)and value>=low and value<=high
end

local function j(set,names)
local h={}
local d=1
while d<=#names do
local g=0
for k=0,3 do
local l=names[d+k]
if l and set[l]then
g=g+2^k
end
end
h[#h+1]=string.sub(o,g+1,g+1)
d=d+4
end
return table.concat(h)
end

local function k(text,names)
if type(text)~="string"or string.find(text,"[^0-9a-f]")then
return nil
end
local g={}
for d=1,string.len(text)do
local m=string.find(o,string.sub(text,d,d),1,true)-1
for h=0,3 do
local l=names[(d-1)*4+h+1]
if l and math.floor(m/2^h)%2==1 then
g[l]=true
end
end
end
return g
end

local function y(bonds)
local d={}
for h,g in ipairs(b.Skills.DUOS)do
d[#d+1]=bonds[g]or 0
end
return table.concat(d,",")
end

local function z(text)
if type(text)~="string"then
return nil
end
local h={}
local d=0
for m in string.gmatch(text,"[^,]+")do
d=d+1
local g=tonumber(m)
local l=b.Skills.DUOS[d]
if not l or not c(g,0,b.Skills.BOND_CAP)then
return nil
end
if g>0 then
h[l]=g
end
end
if d~=#b.Skills.DUOS then
return nil
end
return h
end

function a.encodeFlags(flags)
return j(flags,n.NAMES)
end

function a.decodeFlags(text)
return k(text,n.NAMES)
end

local function l(id)
if not id then
return 0
end
return e.get(id).code
end

local function A(code)
if code==0 then
return nil
end
return e.CODES[code]or false
end

local function p(member)
return table.concat({
member.level,member.xp,member.hp,member.sp,
l(member.equip.weapon),l(member.equip.armor),l(member.equip.charm),
},",")
end

local function q(id,text)
if type(text)~="string"then
return nil
end
local d={}
for h in string.gmatch(text,"[^,]+")do
local g=tonumber(h)
if not g then
return nil
end
d[#d+1]=g
end
if#d~=7 then
return nil
end
local m,r,s,t=d[1],d[2],d[3],d[4]
if not c(m,1,b.LEVEL_CAP)or not c(r,0,99999999)or not c(s,0,99999)or not c(t,0,99999)then
return nil
end
local x=f.BY_ID[id]
local g={}
for u,v in ipairs(i.SLOTS)do
if not c(d[4+u],0,#e.ORDER)then
return nil
end
local h=A(d[4+u])
if h==false then
return nil
end
if h then
local w=e.get(h)
if w.kind~=v or not e.fits(x,w)then
return nil
end
end
g[v]=h
end
if not g.weapon or not g.armor then
return nil
end
local h={id=id,level=m,xp=r,hp=s,sp=t,equip=g}
i.clamp(h)
return h
end

local function B(items)
local g={}
local d=""
for s,r in ipairs(e.ORDER)do
local h=items[r]
if h and h>0 then
local m=e.get(r).code..":"..h
if d~=""and string.len(d)+string.len(m)+1>a.CHUNK then
g[#g+1]=d
d=""
end
if d==""then
d=m
else
d=d..","..m
end
end
end
if d~=""then
g[#g+1]=d
end
return g
end

local function C(chunks)
if type(chunks)~="table"then
return nil
end
local d={}
for u,g in ipairs(chunks)do
if type(g)~="string"then
return nil
end
for r,s in string.gmatch(g,"(%d+):(%d+)")do
local t,h=tonumber(r),tonumber(s)
local m=e.CODES[t]
if not m or not c(h,1,e.MAX_STACK)then
return nil
end
d[m]=h
end
end
return d
end

function a.encode(state)
local g={}
local d=""
for r,h in ipairs(state.order)do
local m=f.BY_ID[h]
g[m.code]=p(state.members[h])
d=d..m.code
end
local h={}
for m,r in pairs(state.carry)do
h[f.BY_ID[m].code]=p(r)
end
local m={
v=a.VERSION,
step=state.step,
map=state.map,
x=state.x,
y=state.y,
d=state.dir,
gold=state.gold,
time=math.min(a.MAX_TIME,math.floor(state.time)),
flags=a.encodeFlags(state.flags),
order=d,
m=g,
items=B(state.items),
seen=j(state.seen,b.Enemies.ORDER),
known=j(state.known,b.Enemies.ORDER),
bonds=y(state.bonds),
ng=state.ng,
c=h,
}
if state.inn then
m.inn=state.inn.map..","..state.inn.x..","..state.inn.y
end
return m
end

function a.decode(slot)
if type(slot)~="table"or slot.v~=a.VERSION then
return nil
end
if not c(slot.step,0,999)or type(slot.map)~="string"or not b.Maps[slot.map]then
return nil
end
local h=b.Field.prepare(b.Maps[slot.map])
if not c(slot.x,0,h.width-1)or not c(slot.y,0,h.height-1)or not c(slot.d,1,4)then
return nil
end
if not c(slot.gold,0,i.GOLD_CAP)or not c(slot.time,0,a.MAX_TIME)or not c(slot.ng,0,a.MAX_NG)then
return nil
end
local m=a.decodeFlags(slot.flags)
local r=C(slot.items)
local s=k(slot.seen,b.Enemies.ORDER)
local t=k(slot.known,b.Enemies.ORDER)
local u=z(slot.bonds)
if not m or not r or not s or not t or not u or type(slot.order)~="string"or type(slot.m)~="table"or type(slot.c)~="table"then
return nil
end
local d={
step=slot.step,flags=m,gold=slot.gold,items=r,members={},order={},
glow=0,map=slot.map,x=slot.x,y=slot.y,dir=slot.d,time=slot.time,
seen=s,known=t,bonds=u,ng=slot.ng,carry={},
}
for v,x in pairs(slot.c)do
local g=type(v)=="string"and f.BY_CODE[v]
if not g then
return nil
end
local w=q(g.id,x)
if not w then
return nil
end
d.carry[g.id]=w
end
for v=1,string.len(slot.order)do
local w=string.sub(slot.order,v,v)
local g=f.BY_CODE[w]
if not g or d.members[g.id]then
return nil
end
local x=q(g.id,slot.m[w])
if not x then
return nil
end
d.members[g.id]=x
d.order[#d.order+1]=g.id
end
if d.order[1]~="pell"then
return nil
end
for g in pairs(d.carry)do
if d.members[g]then
return nil
end
end
if slot.inn~=nil then
if type(slot.inn)~="string"then
return nil
end
local g,v,w=string.match(slot.inn,"^(%a+),(%d+),(%d+)$")
if not g or not b.Maps[g]then
return nil
end
d.inn={map=g,x=tonumber(v),y=tonumber(w)}
end
return d
end

function a.summary(slot)
local d=a.decode(slot)
if not d then
return nil
end
return{level=d.members.pell.level,map=d.map,time=d.time,step=d.step,order=d.order,cleared=a.cleared(d)}
end

function a.cleared(state)
return state.step>=a.CLEARED_STEP
end
