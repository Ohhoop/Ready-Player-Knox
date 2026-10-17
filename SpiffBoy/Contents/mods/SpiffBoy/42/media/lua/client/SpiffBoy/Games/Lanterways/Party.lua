require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Characters"
require"SpiffBoy/Games/Lanterways/Data/Items"
require"SpiffBoy/Games/Lanterways/Data/Skills"

local c=SpiffBoy.Lanterways
local f=c.Characters
local d=c.Items

local a={}
c.Party=a

a.SLOTS={"weapon","armor","charm"}
a.RESERVE_SHARE=0.75
a.GOLD_CAP=999999
a.STATS={"hp","sp","atk","def","mag","res","spd"}

function a.newMember(e,i)
local g=f.BY_ID[e]
local b={
id=e,
level=i,
xp=0,
equip={weapon=g.start.weapon,armor=g.start.armor,charm=nil},
}
local h=a.stats(b)
b.hp=h.hp
b.sp=h.sp
return b
end

function a.stats(g)
local j=f.BY_ID[g.id]
local b={}
for h,e in ipairs(a.STATS)do
b[e]=f.statAt(j,e,g.level)
end
for l,k in ipairs(a.SLOTS)do
local i=g.equip[k]
local h=i and d.get(i)
if h then
for m,e in ipairs(a.STATS)do
if h[e]then
b[e]=b[e]+h[e]
end
end
end
end
return b
end

function a.guardOf(b)
local e=b.equip.charm and d.get(b.equip.charm)
return e and e.guard
end

function a.worn(e,g)
local b=e.equip[g]
return b and d.get(b)
end

function a.wardsOf(g)
local e={}
for i,h in ipairs({"armor","charm"})do
local b=a.worn(g,h)
if b and b.ward then
e[b.ward]=true
end
end
return e
end

function a.skills(e,b)
return f.skillsAt(f.BY_ID[b.id],b.level,e.flags)
end

function a.clamp(b)
local e=a.stats(b)
b.hp=SpiffBoy.clamp(b.hp,0,e.hp)
b.sp=SpiffBoy.clamp(b.sp,0,e.sp)
end

function a.gainXp(b,i)
local e=0
b.xp=b.xp+i
while b.level<c.LEVEL_CAP and b.xp>=f.toNext(b.level)do
local g=a.stats(b)
b.xp=b.xp-f.toNext(b.level)
b.level=b.level+1
local h=a.stats(b)
b.hp=b.hp+(h.hp-g.hp)
b.sp=b.sp+(h.sp-g.sp)
e=e+1
end
if b.level>=c.LEVEL_CAP then
b.xp=0
end
return e
end

function a.newState()
local b={
step=0,
flags={},
gold=30,
items={bun=3},
members={pell=a.newMember("pell",1)},
order={"pell"},
glow=0,
map="pellhouse",
x=2,
y=3,
dir=1,
time=0,
inn=nil,
seen={},
known={},
bonds={},
ng=0,
carry={},
}
return b
end

function a.newStateFrom(e)
local b=a.newState()
b.ng=e.ng+1
b.gold=e.gold
b.items=e.items
b.seen=e.seen
b.known=e.known
b.bonds=e.bonds
for g,h in pairs(e.members)do
b.carry[g]=h
end
for g,h in pairs(e.carry)do
if not b.carry[g]then
b.carry[g]=h
end
end
local g=b.carry.pell
b.carry.pell=nil
b.members.pell=g
a.restoreAll(b)
return b
end

function a.enemyBonus(b)
return b.ng*8
end

function a.averageLevel(g)
local b=0
local e=a.active(g)
for i,h in ipairs(e)do
b=b+h.level
end
return math.floor(b/#e+0.5)
end

function a.join(b,g)
if b.members[g]then
return b.members[g]
end
local h=a.averageLevel(b)
local e=b.carry[g]
if e then
b.carry[g]=nil
if e.level<h then
e.level=h
e.xp=0
end
a.clamp(e)
else
e=a.newMember(g,h)
end
b.members[g]=e
b.order[#b.order+1]=g
return e
end

function a.leave(b,e)
local g=b.members[e]
if not g then
return
end
b.carry[e]=g
b.members[e]=nil
local h=c.indexOf(b.order,e)
if h then
table.remove(b.order,h)
end
end

function a.active(b)
local e={}
for g=1,math.min(c.PARTY_SIZE,#b.order)do
e[#e+1]=b.members[b.order[g]]
end
return e
end

function a.reserve(b)
local e={}
for g=c.PARTY_SIZE+1,#b.order do
e[#e+1]=b.members[b.order[g]]
end
return e
end

function a.restoreAll(e)
for i,h in ipairs(e.order)do
local b=e.members[h]
local g=a.stats(b)
b.hp=g.hp
b.sp=g.sp
end
end

function a.count(b,e)
return b.items[e]or 0
end

function a.addItem(e,g,h)
local b=(e.items[g]or 0)+h
if b>d.MAX_STACK then
b=d.MAX_STACK
end
if b<=0 then
e.items[g]=nil
else
e.items[g]=b
end
end

function a.takeItem(b,e,g)
local h=b.items[e]or 0
if h<g then
return false
end
a.addItem(b,e,-g)
return true
end

function a.bagList(h,g)
local b={}
for i,e in ipairs(d.DISPLAY)do
if(h.items[e]or 0)>0 and(not g or g(d.get(e)))then
b[#b+1]=e
end
end
return b
end

function a.addGold(b,e)
b.gold=SpiffBoy.clamp(b.gold+e,0,a.GOLD_CAP)
end

function a.equip(i,b,e)
local g=d.get(e)
local j=f.BY_ID[b.id]
if not g or not d.fits(j,g)or not a.takeItem(i,e,1)then
return false
end
local h=g.kind
if b.equip[h]then
a.addItem(i,b.equip[h],1)
end
b.equip[h]=e
a.clamp(b)
return true
end

function a.unequipCharm(e,b)
if b.equip.charm then
a.addItem(e,b.equip.charm,1)
b.equip.charm=nil
a.clamp(b)
end
end

function a.statsWith(b,e)
local h=d.get(e)
local g={id=b.id,level=b.level,equip={weapon=b.equip.weapon,armor=b.equip.armor,charm=b.equip.charm}}
g.equip[h.kind]=e
return a.stats(g)
end

function a.setFlag(b,e,g)
if g then
b.flags[e]=true
else
b.flags[e]=nil
end
end

function a.hasFlag(b,e)
return b.flags[e]==true
end

function a.meets(e,b)
if not b then
return true
end
if b.min and e.step<b.min then
return false
end
if b.max and e.step>b.max then
return false
end
if b.flag and not e.flags[b.flag]then
return false
end
if b.notFlag and e.flags[b.notFlag]then
return false
end
for h,g in ipairs(b.flags or{})do
if not e.flags[g]then
return false
end
end
if b.member and not e.members[b.member]then
return false
end
if b.notMember and e.members[b.notMember]then
return false
end
if b.item and(e.items[b.item]or 0)<=0 then
return false
end
if b.active and not a.isActive(e,b.active)then
return false
end
if b.notActive and a.isActive(e,b.notActive)then
return false
end
return true
end

function a.isActive(e,g)
local b=c.indexOf(e.order,g)
return b~=nil and b<=c.PARTY_SIZE
end

function a.bond(b,e)
return b.bonds[e]or 0
end

function a.strengthenBonds(b)
local g={}
for j,e in ipairs(c.Skills.DUOS)do
local h=c.Skills.get(e).duo
if a.isActive(b,h[1])and a.isActive(b,h[2])then
local i=a.duoReady(b,e)
b.bonds[e]=math.min(c.Skills.BOND_CAP,a.bond(b,e)+1)
if not i and a.duoReady(b,e)then
g[#g+1]=e
end
end
end
return g
end

function a.glowKnown(b)
for g,e in ipairs(c.Characters.LIST)do
if a.hasFlag(b,"b_"..e.id)then
return true
end
end
for g,e in ipairs(c.Skills.DUOS)do
if a.duoReady(b,e)then
return true
end
end
return false
end

function a.duoReady(b,e)
return a.bond(b,e)>=c.Skills.BOND_NEEDED
end

function a.markSeen(b,e)
b.seen[e]=true
end

function a.markKnown(b,e)
b.seen[e]=true
b.known[e]=true
end
