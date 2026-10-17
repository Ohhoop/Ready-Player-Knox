require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"
require"SpiffBoy/Games/Lanterways/Data/Enemies"

local f=SpiffBoy.Lanterways
local d=f.Party
local h=f.Skills
local q=f.Items
local r=f.Enemies

local a={}
a.__index=a
f.Battle=a

a.GLOW_MAX=100
a.GLOW_ACT=10
a.GLOW_KEPT=3
a.GLOW_WEAK=4
a.GLOW_SHARP=10
a.GLOW_HURT=4
a.CRIT_CHANCE=0.06
a.CRIT_MULT=1.6
a.WEAK_MULT=1.6
a.RESIST_MULT=0.5
a.WARD_MULT=0.5
a.SHARP_MULT=1.25
a.OFF_ELEMENT_MULT=0.1
a.BOSS_STATUS=0.35
a.BOSS_DEBUFF=0.6
a.MISS_CHANCE=0.04
a.BLIND_MISS=0.5
a.EARLY_START=0.2
a.STEAL_CHANCE=0.5
a.STEAL_RARE=0.3
a.AIM_WEAKEST=0.35
a.PHASE_SHARE=0.5
a.BRIGHT_UP=1.4
a.PART_SHARE=0.2
a.PART_BREAK_SHARE=0.5
a.PART_XP=0.25
a.BROKEN={legs={"spd",0.6},arm={"atk",0.7},shell={"def",0.6},core={"mag",0.6}}
a.JAW_ACTS={bite=true,soak=true,tidepull=true,smother=true}
a.MODIFIERS={
atkUp={"atk",1.35},atkDown={"atk",0.7},defUp={"def",1.4},defDown={"def",0.6},
magUp={"mag",1.3},resUp={"res",1.4},resDown={"res",0.6},spdUp={"spd",1.5},spdDown={"spd",0.6},
}
a.OPPOSITE={
atkUp="atkDown",atkDown="atkUp",defUp="defDown",defDown="defUp",resUp="resDown",resDown="resUp",spdUp="spdDown",spdDown="spdUp",
}
a.DURATION={stun=1,sleep=3,blind=3,soot=4,regen=4,veil=3,taunt=3}
a.BUFF_DURATION=4
a.AILMENTS={"blind","sleep","soot","stun","atkDown","defDown","resDown","spdDown"}
a.SOOT_SHARE=0.06
a.REGEN_SHARE=0.08

local function k(b)
return 1000/(b+15)
end

function a.new(e,p,m,i)
local b=setmetatable({},a)
b.state=e
b.random=m
b.options=i
b.combatants={}
b.party={}
b.enemies={}
e.glow=math.floor(e.glow/a.GLOW_KEPT)
for n,c in ipairs(d.active(e))do
if not i.seats or n<=i.seats then
local l=d.stats(c)
local g=d.worn(c,"charm")
local j={
side="party",id=c.id,member=c,name=f.text("Name_"..c.id),
base=l,hp=c.hp,maxHp=l.hp,sp=c.sp,maxSp=l.sp,
statuses={},guard=d.guardOf(c),weapon=d.worn(c,"weapon"),wards=d.wardsOf(c),charm=g,
}
if g and g.glowStart and j.hp>0 and d.glowKnown(e)then
e.glow=math.min(a.GLOW_MAX,e.glow+g.glowStart)
end
if g and g.regenStart and j.hp>0 then
j.statuses.regen=a.DURATION.regen
end
b.party[#b.party+1]=j
b.combatants[#b.combatants+1]=j
end
end
local j={}
local l=d.enemyBonus(e)
if i.levels then
l=l+i.levels
end
for o,c in ipairs(p)do
local g=r.get(c,l)
if not g then
error("Lanterways: unknown enemy "..tostring(c))
end
d.markSeen(e,c)
j[c]=(j[c]or 0)+1
local n={
side="enemy",id=c,enemy=g,name=f.text("Enemy_"..c),
base=g,hp=g.hp,maxHp=g.hp,sp=0,maxSp=0,statuses={},boss=g.boss,
surveyed=e.known[c]==true,
}
b.enemies[#b.enemies+1]=n
b.combatants[#b.combatants+1]=n
end
b.parts={}
for t,c in ipairs(b.enemies)do
if c.enemy.parts then
c.broken={}
c.partFighters={}
for s,g in ipairs(c.enemy.parts)do
local n=math.floor(c.maxHp*a.PART_SHARE)
local o={
side="enemy",part=g.kind,index=s,owner=c,id=c.id,enemy=c.enemy,
name=f.text("BattleUses",c.name,f.text("Part_"..g.kind)),
base=c.base,hp=n,maxHp=n,sp=0,maxSp=0,statuses={},boss=true,
offset={x=g.x,y=g.y},surveyed=c.surveyed,
}
c.partFighters[#c.partFighters+1]=o
b.parts[#b.parts+1]=o
end
end
end
for o,c in ipairs(b.enemies)do
if j[c.id]>1 then
local g=0
for s,n in ipairs(b.enemies)do
if n.id==c.id then
g=g+1
if n==c then
break
end
end
end
c.name=c.name.." "..string.sub("ABCD",g,g)
end
end
for g,c in ipairs(b.combatants)do
c.ct=k(b:stat(c,"spd"))*(0.3+m:float()*0.7)
if c.charm and c.charm.early then
c.ct=c.ct*a.EARLY_START
end
end
return b
end

function a:stat(c,e)
local b=c.base[e]
for i,g in pairs(a.MODIFIERS)do
if g[1]==e and c.statuses[i]then
b=b*g[2]
end
end
if c.broken then
for i,g in pairs(a.BROKEN)do
if g[1]==e and c.broken[i]then
b=b*g[2]
end
end
end
return b
end

function a:enemyTargets()
local b={}
for g,c in ipairs(self:standing("enemy"))do
b[#b+1]=c
for i,e in ipairs(c.partFighters or{})do
if e.hp>0 then
b[#b+1]=e
end
end
end
return b
end

function a:breakPart(c,e)
local b=c.owner
b.broken[c.part]=true
e.broken=c
local g=math.floor(c.maxHp*a.PART_BREAK_SHARE)
b.hp=math.max(0,b.hp-g)
e.ownerDamage=g
if b.hp<=0 then
b.statuses={}
e.ownerKo=true
end
end

function a.alive(b)
return b.hp>0
end

function a:standing(g)
local b={}
local c=self.party
if g=="enemy"then
c=self.enemies
end
for i,e in ipairs(c)do
if e.hp>0 then
b[#b+1]=e
end
end
return b
end

function a:fallen()
local b={}
for e,c in ipairs(self.party)do
if c.hp<=0 then
b[#b+1]=c
end
end
return b
end

function a:nextActor()
local b=nil
for e,c in ipairs(self.combatants)do
if c.hp>0 and(not b or c.ct<b.ct)then
b=c
end
end
local e=b.ct
for g,c in ipairs(self.combatants)do
if c.hp>0 then
c.ct=c.ct-e
end
end
return b
end

function a:requeue(b,c)
b.ct=b.ct+k(self:stat(b,"spd"))*c
end

function a:timeline(i)
local b={}
for e,c in ipairs(self.combatants)do
if c.hp>0 then
b[#b+1]={fighter=c,ct=c.ct}
end
end
local e={}
while#e<i and#b>0 do
local c=b[1]
for g=2,#b do
if b[g].ct<c.ct then
c=b[g]
end
end
e[#e+1]=c.fighter
c.ct=c.ct+k(self:stat(c.fighter,"spd"))
end
return e
end

function a:addGlow(b)
if not d.glowKnown(self.state)then
return
end
self.state.glow=math.min(a.GLOW_MAX,self.state.glow+b)
end

function a:elementMultiplier(c,b)
if c.side=="party"then
if b and c.wards[b]then
return a.WARD_MULT
end
return 1
end
local e=self.options.onlyElement
if e and b~=e then
return a.OFF_ELEMENT_MULT
end
if not b then
return 1
end
if c.enemy.weak==b then
return a.WEAK_MULT
elseif c.enemy.resist==b then
return a.RESIST_MULT
end
return 1
end

local function s(b,c)
return b.side=="enemy"and c~=nil and b.enemy.weak==c and(b.statuses.defDown~=nil or b.statuses.resDown~=nil)
end

local function o(c,g,b)
local e=s(c,g)
if e then
b=b*a.SHARP_MULT
end
if c.statuses.veil then
b=b*0.5
end
if c.guarding then
b=b*0.5
end
return math.max(1,math.floor(b)),e
end

function a:physicalDamage(i,c,j,e,l)
local m=self:stat(i,"atk")
local n=self:stat(c,"def")
local b=m*j-n*0.5
b=b*(0.9+self.random:float()*0.2)
local g=self.random:chance(l)
if g then
b=b*a.CRIT_MULT
end
b=b*self:elementMultiplier(c,e or"phys")
local p,t=o(c,e,b)
return p,g,t
end

function a:magicDamage(g,b,i,e)
local j=self:stat(g,"mag")
local l=self:stat(b,"res")
local c=(i+j)*(0.9+self.random:float()*0.2)-l*0.5
c=c*self:elementMultiplier(b,e)
return o(b,e,c)
end

function a:healAmount(c,e,b,g)
if g then
return math.floor(e.maxHp*math.min(1,b))
end
return math.floor(b+self:stat(c,"mag")*0.8)
end

function a:hurt(b,e,c)
local g=0
if self.options.fleeBelow and b.side=="enemy"then
g=1
end
b.hp=math.max(g,b.hp-e)
c.damage=(c.damage or 0)+e
if b.statuses.sleep then
b.statuses.sleep=nil
end
if b.side=="party"then
self:addGlow(a.GLOW_HURT)
end
if b.hp<=0 then
c.ko=true
b.statuses={}
b.guarding=false
if b.part then
self:breakPart(b,c)
end
end
return c
end

function a:heal(b,e,c)
local g=b.hp
b.hp=math.min(b.maxHp,b.hp+e)
c.heal=(c.heal or 0)+(b.hp-g)
return c
end

function a:inflict(c,b,g)
if c.hp<=0 then
return false
end
if c.guard==b then
return false
end
local i=f.indexOf(a.AILMENTS,b)~=nil
if i then
local e=g
if c.boss then
if b=="sleep"or b=="stun"then
e=e*a.BOSS_STATUS
else
e=e*a.BOSS_DEBUFF
end
end
if not self.random:chance(e)then
return false
end
end
local e=a.OPPOSITE[b]
if e and c.statuses[e]then
c.statuses[e]=nil
return true
end
local j=a.DURATION[b]or a.BUFF_DURATION
c.statuses[b]=j
return true
end

function a:cure(e,b)
for g,c in ipairs(a.AILMENTS)do
if not b or b==c then
e.statuses[c]=nil
end
end
end

function a:targetsOf(j,b,g)
local c,i="enemy","party"
if j.side=="enemy"then
c,i="party","enemy"
end
if b=="enemies"then
return self:standing(c)
elseif b=="allies"then
return self:standing(i)
elseif b=="self"then
return{j}
elseif b=="random"then
return self:standing(c)
elseif g and(g.hp>0 or b=="fallen")then
return{g}
end
local e=self:standing(c)
if b=="ally"then
e=self:standing(i)
elseif b=="fallen"then
e=self:fallen()
end
if#e==0 then
return{}
end
return{e[1]}
end

function a:steal(b)
if b.side~="enemy"or b.part or b.stolen then
return nil
end
local c=b.enemy
if not c.drop and not c.rare then
return nil
end
local e=a.STEAL_CHANCE
if b.boss then
e=e*a.BOSS_DEBUFF
end
if not self.random:chance(e)then
return nil
end
b.stolen=true
if c.rare and(not c.drop or self.random:chance(a.STEAL_RARE))then
return c.rare[1]
end
return c.drop[1]
end

function a:strike(c,e,g,i,b)
if e.kind=="physical"then
local l=c.statuses.blind or(c.broken and c.broken.eye)
if(l and self.random:chance(a.BLIND_MISS))or self.random:chance(a.MISS_CHANCE)then
b.miss=true
return
end
local j=a.CRIT_CHANCE
if e.crit then
j=1
elseif e.critChance then
j=j+e.critChance
end
local m,n,p=self:physicalDamage(c,g,e.power,i,j)
b.crit=b.crit or n
b.sharp=b.sharp or p
self:hurt(g,m,b)
else
local j,l=self:magicDamage(c,g,e.power,i)
b.sharp=b.sharp or l
self:hurt(g,j,b)
if e.drain then
self:heal(c,math.floor(j/2),{target=c})
b.drained=math.floor(j/2)
end
end
if g.side=="enemy"and i and g.enemy.weak==i then
b.weak=true
end
end

function a:applySkill(j,e,b)
local c={target=b}
local g=e.kind
if g=="physical"or g=="magic"then
for l,i in ipairs(e.elements or{e.element or false})do
if b.hp>0 and not c.miss then
self:strike(j,e,b,i or nil,c)
end
end
elseif g=="heal"then
if b.hp>0 or e.revive then
if b.hp<=0 then
c.revived=true
end
self:heal(b,self:healAmount(j,b,e.power,e.ratio),c)
end
elseif g=="revive"then
if b.hp<=0 then
c.revived=true
self:heal(b,math.max(1,math.floor(b.maxHp*e.power)),c)
end
elseif g=="cure"then
self:cure(b)
c.cured=true
elseif g=="survey"then
b.surveyed=true
c.surveyed=true
d.markKnown(self.state,b.id)
elseif g=="drainSp"then
local i=math.min(b.sp,e.power+math.floor(j.base.level or 0)/4)
b.sp=b.sp-math.floor(i)
c.spLost=math.floor(i)
elseif g=="steal"then
local i=self:steal(b)
if i then
d.addItem(self.state,i,1)
c.stole=i
else
c.miss=true
c.stealMissed=true
end
elseif g=="flee"then
b.hp=0
b.fled=true
c.fled=true
end
local i=b.owner or b
if e.cure and i.hp>0 then
self:cure(i)
c.cured=true
end
if e.status and i.hp>0 and not c.miss then
local m={e.status,e.also}
c.statuses={}
for n,l in ipairs(m)do
if self:inflict(i,l,e.chance)then
c.statuses[#c.statuses+1]=l
end
end
end
return c
end

function a:brightOf(e)
local g=f.Characters.BY_ID[e.id]
local c=h.get(g.bright)
if not d.hasFlag(self.state,"t_"..e.id)then
return c
end
local b={}
for i,j in pairs(c)do
b[i]=j
end
b.power=c.power*a.BRIGHT_UP
b.upgraded=true
return b
end

function a:brightReady(b)
return d.hasFlag(self.state,"b_"..b.id)and self.state.glow>=a.GLOW_MAX
end

function a:duosOf(g)
local e={}
for m,i in ipairs(h.DUOS)do
local j=h.get(i)
local b=j.duo
local c=nil
if b[1]==g.id then
c=b[2]
elseif b[2]==g.id then
c=b[1]
end
if c and d.duoReady(self.state,i)then
for n,l in ipairs(self.party)do
if l.id==c and l.hp>0 then
e[#e+1]=j
end
end
end
end
return e
end

function a:useSkill(c,b,l)
local e={}
if b.bright then
self.state.glow=0
elseif b.duo then
self.state.glow=self.state.glow-h.DUO_GLOW
elseif c.side=="party"then
c.sp=c.sp-b.cost
end
if b.target=="random"then
for j=1,b.hits or 1 do
local g=self:targetsOf(c,"enemies")
if#g==0 then
break
end
local i=g[self.random:int(1,#g)]
e[#e+1]=self:applySkill(c,b,i)
end
else
local g=self:targetsOf(c,b.target,l)
if b.revive and b.target=="allies"then
g=c.side=="party"and self.party or self.enemies
end
for j,i in ipairs(g)do
for m=1,b.hits or 1 do
if i.hp>0 or b.target=="fallen"or b.revive then
e[#e+1]=self:applySkill(c,b,i)
end
end
end
end
if b.healParty then
for i,g in ipairs(self:standing(c.side))do
e[#e+1]=self:heal(g,math.floor(g.maxHp*b.healParty),{target=g})
end
end
if b.reviveParty then
for i,g in ipairs(self:fallen())do
e[#e+1]=self:heal(g,math.floor(g.maxHp*b.reviveParty),{target=g,revived=true})
end
end
if b.partyStatus then
for m,i in ipairs(self:standing(c.side))do
local g={}
for n,j in ipairs({b.partyStatus,b.partyAlso})do
self:inflict(i,j,1)
g[#g+1]=j
end
e[#e+1]={target=i,statuses=g}
end
end
if c.side=="party"and not b.bright and not b.duo then
self:glowFrom(c,e)
end
return e
end

function a:glowFrom(c,l)
local j,e,g,i=false,false,false,0
for m,b in ipairs(l)do
if b.damage and b.target.side=="enemy"then
j=true
i=i+1
e=e or b.weak==true
g=g or b.sharp==true
end
end
if not j then
return
end
local b=a.GLOW_ACT
if e then
b=b+a.GLOW_WEAK
end
if g then
b=b+a.GLOW_SHARP
end
if c.charm and c.charm.glowHit then
b=b+c.charm.glowHit*i
end
self:addGlow(b)
end

function a.attackSkill(e)
local c={id="attack",cost=0,target="enemy",kind="physical",power=1,fx="hit"}
local b=e.side=="party"and e.weapon
if b then
c.element=b.element
c.critChance=b.crit
if b.onHit then
c.status=b.onHit[1]
c.chance=b.onHit[2]
end
if b.element=="flame"then
c.fx="flame"
elseif b.element=="sound"then
c.fx="ring"
elseif b.element=="murk"then
c.fx="murk"
end
end
return c
end

function a:useItem(j,l,m)
local c=q.get(l)
d.takeItem(self.state,l,1)
local i={}
local n=self:targetsOf(j,c.target,m)
for u,b in ipairs(n)do
local e={target=b}
local g=c.effect
if g=="heal"and b.hp>0 then
self:heal(b,c.power,e)
elseif g=="sp"and b.hp>0 then
local p=b.sp
b.sp=math.min(b.maxSp,b.sp+c.power)
e.spGained=b.sp-p
elseif g=="revive"and b.hp<=0 then
e.revived=true
self:heal(b,math.max(1,math.floor(b.maxHp*c.power)),e)
elseif g=="cure"then
self:cure(b,c.status)
e.cured=true
elseif g=="glow"then
self:addGlow(c.power)
e.glow=c.power
elseif g=="buff"or g=="debuff"then
e.statuses={}
if self:inflict(b,c.status,c.chance)then
e.statuses[1]=c.status
else
e.resisted=true
end
elseif g=="damage"then
local p,t=self:magicDamage(j,b,c.power,c.element)
e.sharp=t
self:hurt(b,p,e)
if c.status and b.hp>0 and self:inflict(b,c.status,c.chance)then
e.statuses={c.status}
end
end
i[#i+1]=e
end
return i
end

function a:tryEscape()
if self.options.noEscape then
return false
end
local function c(e)
local b=0
for i,g in ipairs(e)do
b=b+self:stat(g,"spd")
end
return b/math.max(1,#e)
end
local b=0.55+0.02*(c(self:standing("party"))-c(self:standing("enemy")))
return self.random:chance(SpiffBoy.clamp(b,0.2,0.95))
end

function a:actFits(c,e)
local b=e[3]
if not b then
return true
end
if b.below and c.hp/c.maxHp>=b.below then
return false
end
if b.unless then
if b.foe then
for i,g in ipairs(self:standing("party"))do
if not g.statuses[b.unless]then
return true
end
end
return false
end
return not c.statuses[b.unless]
end
return true
end

function a:actLost(l,e,m)
local b=l.broken
if not b or e[1]=="attack"then
return false
end
local g=h.get(e[1])
if b.arm and g.kind=="physical"then
return true
end
if b.jaw and a.JAW_ACTS[e[1]]then
return true
end
if b.core and g.kind=="magic"then
local i=0
for n,j in ipairs(m)do
local c=j[1]~="attack"and h.get(j[1])
if c and c.kind=="magic"and c.power>i then
i=c.power
end
end
return g.power>=i
end
return false
end

function a:enemyAction(b)
local g=b.enemy.acts
if b.enemy.acts2 and b.hp<b.maxHp*a.PHASE_SHARE then
g=b.enemy.acts2
end
if self.options.fleeBelow and b.hp<b.maxHp*self.options.fleeBelow then
g={{"flee",1}}
end
local c=f.filter(g,function(c)return self:actFits(b,c)and not self:actLost(b,c,g)end)
if#c==0 then
c={{"attack",1}}
end
local l=0
for i,e in ipairs(c)do
l=l+e[2]
end
local m=self.random:int(1,l)
local n=c[1][1]
for i,e in ipairs(c)do
m=m-e[2]
if m<=0 then
n=e[1]
break
end
end
local e
if n=="attack"then
e=a.attackSkill(b)
else
e=h.get(n)
end
if e.kind=="flee"then
return{kind="skill",skill=e,target=b}
end
local i=self:standing("party")
local j=i[self.random:int(1,#i)]
if self.random:chance(a.AIM_WEAKEST)then
for t,p in ipairs(i)do
if p.hp<j.hp then
j=p
end
end
end
for t,p in ipairs(i)do
if p.statuses.taunt then
j=p
end
end
return{kind="skill",skill=e,target=j}
end

function a:endTurn(b)
local c=nil
if b.hp>0 and b.statuses.soot then
c={target=b}
self:hurt(b,math.max(1,math.floor(b.maxHp*a.SOOT_SHARE*(b.boss and 0.25 or 1))),c)
end
if b.hp>0 and b.statuses.regen then
c=c or{target=b}
self:heal(b,math.max(1,math.floor(b.maxHp*a.REGEN_SHARE)),c)
end
for e,g in pairs(b.statuses)do
if e~="stun"and e~="sleep"then
if g<=1 then
b.statuses[e]=nil
else
b.statuses[e]=g-1
end
end
end
return c
end

function a:tickSleep(b)
local c=b.statuses.sleep
if c<=1 then
b.statuses.sleep=nil
else
b.statuses.sleep=c-1
end
end

function a:outcome()
if#self:standing("enemy")==0 then
return"win"
end
if#self:standing("party")==0 then
return"lose"
end
return nil
end

function a:syncParty()
for c,b in ipairs(self.party)do
b.member.hp=math.max(0,b.hp)
b.member.sp=math.max(0,b.sp)
end
end

function a:spoils()
local c,g,e=0,0,{}
for l,b in ipairs(self.enemies)do
if not b.fled then
c=c+b.enemy.xp
for i in pairs(b.broken or{})do
c=c+math.floor(b.enemy.xp*a.PART_XP)
end
g=g+b.enemy.gold
local i=b.enemy.drop
local j=b.enemy.rare
if j and self.random:chance(j[2])then
e[#e+1]=j[1]
elseif i and not b.stolen and self.random:chance(i[2])then
e[#e+1]=i[1]
end
end
end
return c,g,e
end
