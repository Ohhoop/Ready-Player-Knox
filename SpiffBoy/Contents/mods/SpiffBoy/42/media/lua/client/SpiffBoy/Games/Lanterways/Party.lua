require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Characters"
require"SpiffBoy/Games/Lanterways/Data/Items"
require"SpiffBoy/Games/Lanterways/Data/Skills"

local b=SpiffBoy.Lanterways
local e=b.Characters
local d=b.Items

local a={}
b.Party=a

a.SLOTS={"weapon","armor","charm"}
a.RESERVE_SHARE=0.75
a.GOLD_CAP=999999
a.STATS={"hp","sp","atk","def","mag","res","spd"}

function a.newMember(id,level)
local f=e.BY_ID[id]
local c={
id=id,
level=level,
xp=0,
equip={weapon=f.start.weapon,armor=f.start.armor,charm=nil},
}
local g=a.stats(c)
c.hp=g.hp
c.sp=g.sp
return c
end

function a.stats(member)
local i=e.BY_ID[member.id]
local c={}
for g,f in ipairs(a.STATS)do
c[f]=e.statAt(i,f,member.level)
end
for k,j in ipairs(a.SLOTS)do
local h=member.equip[j]
local g=h and d.get(h)
if g then
for l,f in ipairs(a.STATS)do
if g[f]then
c[f]=c[f]+g[f]
end
end
end
end
return c
end

function a.guardOf(member)
local c=member.equip.charm and d.get(member.equip.charm)
return c and c.guard
end

function a.worn(member,slot)
local c=member.equip[slot]
return c and d.get(c)
end

function a.wardsOf(member)
local f={}
for h,g in ipairs({"armor","charm"})do
local c=a.worn(member,g)
if c and c.ward then
f[c.ward]=true
end
end
return f
end

function a.skills(state,member)
return e.skillsAt(e.BY_ID[member.id],member.level,state.flags)
end

function a.clamp(member)
local c=a.stats(member)
member.hp=SpiffBoy.clamp(member.hp,0,c.hp)
member.sp=SpiffBoy.clamp(member.sp,0,c.sp)
end

function a.gainXp(member,amount)
local c=0
member.xp=member.xp+amount
while member.level<b.LEVEL_CAP and member.xp>=e.toNext(member.level)do
local f=a.stats(member)
member.xp=member.xp-e.toNext(member.level)
member.level=member.level+1
local g=a.stats(member)
member.hp=member.hp+(g.hp-f.hp)
member.sp=member.sp+(g.sp-f.sp)
c=c+1
end
if member.level>=b.LEVEL_CAP then
member.xp=0
end
return c
end

function a.newState()
local c={
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
return c
end

function a.newStateFrom(finished)
local c=a.newState()
c.ng=finished.ng+1
c.gold=finished.gold
c.items=finished.items
c.seen=finished.seen
c.known=finished.known
c.bonds=finished.bonds
for f,g in pairs(finished.members)do
c.carry[f]=g
end
for f,g in pairs(finished.carry)do
if not c.carry[f]then
c.carry[f]=g
end
end
local f=c.carry.pell
c.carry.pell=nil
c.members.pell=f
a.restoreAll(c)
return c
end

function a.enemyBonus(state)
return state.ng*8
end

function a.averageLevel(state)
local c=0
local f=a.active(state)
for h,g in ipairs(f)do
c=c+g.level
end
return math.floor(c/#f+0.5)
end

function a.join(state,id)
if state.members[id]then
return state.members[id]
end
local f=a.averageLevel(state)
local c=state.carry[id]
if c then
state.carry[id]=nil
if c.level<f then
c.level=f
c.xp=0
end
a.clamp(c)
else
c=a.newMember(id,f)
end
state.members[id]=c
state.order[#state.order+1]=id
return c
end

function a.leave(state,id)
local c=state.members[id]
if not c then
return
end
state.carry[id]=c
state.members[id]=nil
local f=b.indexOf(state.order,id)
if f then
table.remove(state.order,f)
end
end

function a.active(state)
local c={}
for f=1,math.min(b.PARTY_SIZE,#state.order)do
c[#c+1]=state.members[state.order[f]]
end
return c
end

function a.reserve(state)
local c={}
for f=b.PARTY_SIZE+1,#state.order do
c[#c+1]=state.members[state.order[f]]
end
return c
end

function a.restoreAll(state)
for h,g in ipairs(state.order)do
local c=state.members[g]
local f=a.stats(c)
c.hp=f.hp
c.sp=f.sp
end
end

function a.count(state,itemId)
return state.items[itemId]or 0
end

function a.addItem(state,itemId,amount)
local c=(state.items[itemId]or 0)+amount
if c>d.MAX_STACK then
c=d.MAX_STACK
end
if c<=0 then
state.items[itemId]=nil
else
state.items[itemId]=c
end
end

function a.takeItem(state,itemId,amount)
local c=state.items[itemId]or 0
if c<amount then
return false
end
a.addItem(state,itemId,-amount)
return true
end

function a.bagList(state,test)
local c={}
for g,f in ipairs(d.DISPLAY)do
if(state.items[f]or 0)>0 and(not test or test(d.get(f)))then
c[#c+1]=f
end
end
return c
end

function a.addGold(state,amount)
state.gold=SpiffBoy.clamp(state.gold+amount,0,a.GOLD_CAP)
end

function a.equip(state,member,itemId)
local c=d.get(itemId)
local g=e.BY_ID[member.id]
if not c or not d.fits(g,c)or not a.takeItem(state,itemId,1)then
return false
end
local f=c.kind
if member.equip[f]then
a.addItem(state,member.equip[f],1)
end
member.equip[f]=itemId
a.clamp(member)
return true
end

function a.unequipCharm(state,member)
if member.equip.charm then
a.addItem(state,member.equip.charm,1)
member.equip.charm=nil
a.clamp(member)
end
end

function a.statsWith(member,itemId)
local f=d.get(itemId)
local c={id=member.id,level=member.level,equip={weapon=member.equip.weapon,armor=member.equip.armor,charm=member.equip.charm}}
c.equip[f.kind]=itemId
return a.stats(c)
end

function a.setFlag(state,name,value)
if value then
state.flags[name]=true
else
state.flags[name]=nil
end
end

function a.hasFlag(state,name)
return state.flags[name]==true
end

function a.meets(state,condition)
if not condition then
return true
end
if condition.min and state.step<condition.min then
return false
end
if condition.max and state.step>condition.max then
return false
end
if condition.flag and not state.flags[condition.flag]then
return false
end
if condition.notFlag and state.flags[condition.notFlag]then
return false
end
for f,c in ipairs(condition.flags or{})do
if not state.flags[c]then
return false
end
end
if condition.member and not state.members[condition.member]then
return false
end
if condition.notMember and state.members[condition.notMember]then
return false
end
if condition.item and(state.items[condition.item]or 0)<=0 then
return false
end
if condition.active and not a.isActive(state,condition.active)then
return false
end
if condition.notActive and a.isActive(state,condition.notActive)then
return false
end
return true
end

function a.isActive(state,id)
local c=b.indexOf(state.order,id)
return c~=nil and c<=b.PARTY_SIZE
end

function a.bond(state,duoId)
return state.bonds[duoId]or 0
end

function a.strengthenBonds(state)
local f={}
for i,c in ipairs(b.Skills.DUOS)do
local g=b.Skills.get(c).duo
if a.isActive(state,g[1])and a.isActive(state,g[2])then
local h=a.duoReady(state,c)
state.bonds[c]=math.min(b.Skills.BOND_CAP,a.bond(state,c)+1)
if not h and a.duoReady(state,c)then
f[#f+1]=c
end
end
end
return f
end

function a.glowKnown(state)
for f,c in ipairs(b.Characters.LIST)do
if a.hasFlag(state,"b_"..c.id)then
return true
end
end
for f,c in ipairs(b.Skills.DUOS)do
if a.duoReady(state,c)then
return true
end
end
return false
end

function a.duoReady(state,duoId)
return a.bond(state,duoId)>=b.Skills.BOND_NEEDED
end

function a.markSeen(state,enemyId)
state.seen[enemyId]=true
end

function a.markKnown(state,enemyId)
state.seen[enemyId]=true
state.known[enemyId]=true
end
