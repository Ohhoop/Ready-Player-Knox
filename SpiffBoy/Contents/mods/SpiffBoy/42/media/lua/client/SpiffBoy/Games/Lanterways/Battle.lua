require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"
require"SpiffBoy/Games/Lanterways/Data/Enemies"

local f=SpiffBoy.Lanterways
local d=f.Party
local h=f.Skills
local p=f.Items
local q=f.Enemies

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

local function j(speed)
return 1000/(speed+15)
end

function a.new(state,troop,random,options)
local b=setmetatable({},a)
b.state=state
b.random=random
b.options=options
b.combatants={}
b.party={}
b.enemies={}
state.glow=math.floor(state.glow/a.GLOW_KEPT)
for k,c in ipairs(d.active(state))do
if not options.seats or k<=options.seats then
local i=d.stats(c)
local e=d.worn(c,"charm")
local g={
side="party",id=c.id,member=c,name=f.text("Name_"..c.id),
base=i,hp=c.hp,maxHp=i.hp,sp=c.sp,maxSp=i.sp,
statuses={},guard=d.guardOf(c),weapon=d.worn(c,"weapon"),wards=d.wardsOf(c),charm=e,
}
if e and e.glowStart and g.hp>0 and d.glowKnown(state)then
state.glow=math.min(a.GLOW_MAX,state.glow+e.glowStart)
end
if e and e.regenStart and g.hp>0 then
g.statuses.regen=a.DURATION.regen
end
b.party[#b.party+1]=g
b.combatants[#b.combatants+1]=g
end
end
local g={}
local i=d.enemyBonus(state)
if options.levels then
i=i+options.levels
end
for l,c in ipairs(troop)do
local e=q.get(c,i)
if not e then
error("Lanterways: unknown enemy "..tostring(c))
end
d.markSeen(state,c)
g[c]=(g[c]or 0)+1
local k={
side="enemy",id=c,enemy=e,name=f.text("Enemy_"..c),
base=e,hp=e.hp,maxHp=e.hp,sp=0,maxSp=0,statuses={},boss=e.boss,
surveyed=state.known[c]==true,
}
b.enemies[#b.enemies+1]=k
b.combatants[#b.combatants+1]=k
end
b.parts={}
for n,c in ipairs(b.enemies)do
if c.enemy.parts then
c.broken={}
c.partFighters={}
for m,e in ipairs(c.enemy.parts)do
local k=math.floor(c.maxHp*a.PART_SHARE)
local l={
side="enemy",part=e.kind,index=m,owner=c,id=c.id,enemy=c.enemy,
name=f.text("BattleUses",c.name,f.text("Part_"..e.kind)),
base=c.base,hp=k,maxHp=k,sp=0,maxSp=0,statuses={},boss=true,
offset={x=e.x,y=e.y},surveyed=c.surveyed,
}
c.partFighters[#c.partFighters+1]=l
b.parts[#b.parts+1]=l
end
end
end
for l,c in ipairs(b.enemies)do
if g[c.id]>1 then
local e=0
for m,k in ipairs(b.enemies)do
if k.id==c.id then
e=e+1
if k==c then
break
end
end
end
c.name=c.name.." "..string.sub("ABCD",e,e)
end
end
for e,c in ipairs(b.combatants)do
c.ct=j(b:stat(c,"spd"))*(0.3+random:float()*0.7)
if c.charm and c.charm.early then
c.ct=c.ct*a.EARLY_START
end
end
return b
end

function a:stat(fighter,name)
local b=fighter.base[name]
for e,c in pairs(a.MODIFIERS)do
if c[1]==name and fighter.statuses[e]then
b=b*c[2]
end
end
if fighter.broken then
for e,c in pairs(a.BROKEN)do
if c[1]==name and fighter.broken[e]then
b=b*c[2]
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

function a:breakPart(piece,outcome)
local b=piece.owner
b.broken[piece.part]=true
outcome.broken=piece
local c=math.floor(piece.maxHp*a.PART_BREAK_SHARE)
b.hp=math.max(0,b.hp-c)
outcome.ownerDamage=c
if b.hp<=0 then
b.statuses={}
outcome.ownerKo=true
end
end

function a.alive(fighter)
return fighter.hp>0
end

function a:standing(side)
local b={}
local c=self.party
if side=="enemy"then
c=self.enemies
end
for g,e in ipairs(c)do
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

function a:requeue(fighter,weight)
fighter.ct=fighter.ct+j(self:stat(fighter,"spd"))*weight
end

function a:timeline(count)
local b={}
for e,c in ipairs(self.combatants)do
if c.hp>0 then
b[#b+1]={fighter=c,ct=c.ct}
end
end
local e={}
while#e<count and#b>0 do
local c=b[1]
for g=2,#b do
if b[g].ct<c.ct then
c=b[g]
end
end
e[#e+1]=c.fighter
c.ct=c.ct+j(self:stat(c.fighter,"spd"))
end
return e
end

function a:addGlow(amount)
if not d.glowKnown(self.state)then
return
end
self.state.glow=math.min(a.GLOW_MAX,self.state.glow+amount)
end

function a:elementMultiplier(target,element)
if target.side=="party"then
if element and target.wards[element]then
return a.WARD_MULT
end
return 1
end
local b=self.options.onlyElement
if b and element~=b then
return a.OFF_ELEMENT_MULT
end
if not element then
return 1
end
if target.enemy.weak==element then
return a.WEAK_MULT
elseif target.enemy.resist==element then
return a.RESIST_MULT
end
return 1
end

local function r(target,element)
return target.side=="enemy"and element~=nil and target.enemy.weak==element and(target.statuses.defDown~=nil or target.statuses.resDown~=nil)
end

local function n(target,element,damage)
local b=r(target,element)
if b then
damage=damage*a.SHARP_MULT
end
if target.statuses.veil then
damage=damage*0.5
end
if target.guarding then
damage=damage*0.5
end
return math.max(1,math.floor(damage)),b
end

function a:physicalDamage(user,target,power,element,critChance)
local e=self:stat(user,"atk")
local g=self:stat(target,"def")
local b=e*power-g*0.5
b=b*(0.9+self.random:float()*0.2)
local c=self.random:chance(critChance)
if c then
b=b*a.CRIT_MULT
end
b=b*self:elementMultiplier(target,element or"phys")
local i,k=n(target,element,b)
return i,c,k
end

function a:magicDamage(user,target,power,element)
local c=self:stat(user,"mag")
local e=self:stat(target,"res")
local b=(power+c)*(0.9+self.random:float()*0.2)-e*0.5
b=b*self:elementMultiplier(target,element)
return n(target,element,b)
end

function a:healAmount(user,target,power,ratio)
if ratio then
return math.floor(target.maxHp*math.min(1,power))
end
return math.floor(power+self:stat(user,"mag")*0.8)
end

function a:hurt(target,damage,outcome)
local b=0
if self.options.fleeBelow and target.side=="enemy"then
b=1
end
target.hp=math.max(b,target.hp-damage)
outcome.damage=(outcome.damage or 0)+damage
if target.statuses.sleep then
target.statuses.sleep=nil
end
if target.side=="party"then
self:addGlow(a.GLOW_HURT)
end
if target.hp<=0 then
outcome.ko=true
target.statuses={}
target.guarding=false
if target.part then
self:breakPart(target,outcome)
end
end
return outcome
end

function a:heal(target,amount,outcome)
local b=target.hp
target.hp=math.min(target.maxHp,target.hp+amount)
outcome.heal=(outcome.heal or 0)+(target.hp-b)
return outcome
end

function a:inflict(target,status,chance)
if target.hp<=0 then
return false
end
if target.guard==status then
return false
end
local c=f.indexOf(a.AILMENTS,status)~=nil
if c then
local b=chance
if target.boss then
if status=="sleep"or status=="stun"then
b=b*a.BOSS_STATUS
else
b=b*a.BOSS_DEBUFF
end
end
if not self.random:chance(b)then
return false
end
end
local b=a.OPPOSITE[status]
if b and target.statuses[b]then
target.statuses[b]=nil
return true
end
local e=a.DURATION[status]or a.BUFF_DURATION
target.statuses[status]=e
return true
end

function a:cure(target,only)
for c,b in ipairs(a.AILMENTS)do
if not only or only==b then
target.statuses[b]=nil
end
end
end

function a:targetsOf(user,kind,chosen)
local b,e="enemy","party"
if user.side=="enemy"then
b,e="party","enemy"
end
if kind=="enemies"then
return self:standing(b)
elseif kind=="allies"then
return self:standing(e)
elseif kind=="self"then
return{user}
elseif kind=="random"then
return self:standing(b)
elseif chosen and(chosen.hp>0 or kind=="fallen")then
return{chosen}
end
local c=self:standing(b)
if kind=="ally"then
c=self:standing(e)
elseif kind=="fallen"then
c=self:fallen()
end
if#c==0 then
return{}
end
return{c[1]}
end

function a:steal(target)
if target.side~="enemy"or target.part or target.stolen then
return nil
end
local b=target.enemy
if not b.drop and not b.rare then
return nil
end
local c=a.STEAL_CHANCE
if target.boss then
c=c*a.BOSS_DEBUFF
end
if not self.random:chance(c)then
return nil
end
target.stolen=true
if b.rare and(not b.drop or self.random:chance(a.STEAL_RARE))then
return b.rare[1]
end
return b.drop[1]
end

function a:strike(user,skill,target,element,outcome)
if skill.kind=="physical"then
local c=user.statuses.blind or(user.broken and user.broken.eye)
if(c and self.random:chance(a.BLIND_MISS))or self.random:chance(a.MISS_CHANCE)then
outcome.miss=true
return
end
local b=a.CRIT_CHANCE
if skill.crit then
b=1
elseif skill.critChance then
b=b+skill.critChance
end
local e,g,i=self:physicalDamage(user,target,skill.power,element,b)
outcome.crit=outcome.crit or g
outcome.sharp=outcome.sharp or i
self:hurt(target,e,outcome)
else
local b,c=self:magicDamage(user,target,skill.power,element)
outcome.sharp=outcome.sharp or c
self:hurt(target,b,outcome)
if skill.drain then
self:heal(user,math.floor(b/2),{target=user})
outcome.drained=math.floor(b/2)
end
end
if target.side=="enemy"and element and target.enemy.weak==element then
outcome.weak=true
end
end

function a:applySkill(user,skill,target)
local b={target=target}
local c=skill.kind
if c=="physical"or c=="magic"then
for g,e in ipairs(skill.elements or{skill.element or false})do
if target.hp>0 and not b.miss then
self:strike(user,skill,target,e or nil,b)
end
end
elseif c=="heal"then
if target.hp>0 or skill.revive then
if target.hp<=0 then
b.revived=true
end
self:heal(target,self:healAmount(user,target,skill.power,skill.ratio),b)
end
elseif c=="revive"then
if target.hp<=0 then
b.revived=true
self:heal(target,math.max(1,math.floor(target.maxHp*skill.power)),b)
end
elseif c=="cure"then
self:cure(target)
b.cured=true
elseif c=="survey"then
target.surveyed=true
b.surveyed=true
d.markKnown(self.state,target.id)
elseif c=="drainSp"then
local e=math.min(target.sp,skill.power+math.floor(user.base.level or 0)/4)
target.sp=target.sp-math.floor(e)
b.spLost=math.floor(e)
elseif c=="steal"then
local e=self:steal(target)
if e then
d.addItem(self.state,e,1)
b.stole=e
else
b.miss=true
b.stealMissed=true
end
elseif c=="flee"then
target.hp=0
target.fled=true
b.fled=true
end
local e=target.owner or target
if skill.cure and e.hp>0 then
self:cure(e)
b.cured=true
end
if skill.status and e.hp>0 and not b.miss then
local i={skill.status,skill.also}
b.statuses={}
for k,g in ipairs(i)do
if self:inflict(e,g,skill.chance)then
b.statuses[#b.statuses+1]=g
end
end
end
return b
end

function a:brightOf(fighter)
local e=f.Characters.BY_ID[fighter.id]
local c=h.get(e.bright)
if not d.hasFlag(self.state,"t_"..fighter.id)then
return c
end
local b={}
for g,i in pairs(c)do
b[g]=i
end
b.power=c.power*a.BRIGHT_UP
b.upgraded=true
return b
end

function a:brightReady(fighter)
return d.hasFlag(self.state,"b_"..fighter.id)and self.state.glow>=a.GLOW_MAX
end

function a:duosOf(fighter)
local e={}
for l,g in ipairs(h.DUOS)do
local i=h.get(g)
local b=i.duo
local c=nil
if b[1]==fighter.id then
c=b[2]
elseif b[2]==fighter.id then
c=b[1]
end
if c and d.duoReady(self.state,g)then
for m,k in ipairs(self.party)do
if k.id==c and k.hp>0 then
e[#e+1]=i
end
end
end
end
return e
end

function a:useSkill(user,skill,chosen)
local b={}
if skill.bright then
self.state.glow=0
elseif skill.duo then
self.state.glow=self.state.glow-h.DUO_GLOW
elseif user.side=="party"then
user.sp=user.sp-skill.cost
end
if skill.target=="random"then
for g=1,skill.hits or 1 do
local c=self:targetsOf(user,"enemies")
if#c==0 then
break
end
local e=c[self.random:int(1,#c)]
b[#b+1]=self:applySkill(user,skill,e)
end
else
local c=self:targetsOf(user,skill.target,chosen)
if skill.revive and skill.target=="allies"then
c=user.side=="party"and self.party or self.enemies
end
for g,e in ipairs(c)do
for i=1,skill.hits or 1 do
if e.hp>0 or skill.target=="fallen"or skill.revive then
b[#b+1]=self:applySkill(user,skill,e)
end
end
end
end
if skill.healParty then
for e,c in ipairs(self:standing(user.side))do
b[#b+1]=self:heal(c,math.floor(c.maxHp*skill.healParty),{target=c})
end
end
if skill.reviveParty then
for e,c in ipairs(self:fallen())do
b[#b+1]=self:heal(c,math.floor(c.maxHp*skill.reviveParty),{target=c,revived=true})
end
end
if skill.partyStatus then
for i,e in ipairs(self:standing(user.side))do
local c={}
for k,g in ipairs({skill.partyStatus,skill.partyAlso})do
self:inflict(e,g,1)
c[#c+1]=g
end
b[#b+1]={target=e,statuses=c}
end
end
if user.side=="party"and not skill.bright and not skill.duo then
self:glowFrom(user,b)
end
return b
end

function a:glowFrom(user,outcomes)
local i,c,e,g=false,false,false,0
for k,b in ipairs(outcomes)do
if b.damage and b.target.side=="enemy"then
i=true
g=g+1
c=c or b.weak==true
e=e or b.sharp==true
end
end
if not i then
return
end
local b=a.GLOW_ACT
if c then
b=b+a.GLOW_WEAK
end
if e then
b=b+a.GLOW_SHARP
end
if user.charm and user.charm.glowHit then
b=b+user.charm.glowHit*g
end
self:addGlow(b)
end

function a.attackSkill(fighter)
local c={id="attack",cost=0,target="enemy",kind="physical",power=1,fx="hit"}
local b=fighter.side=="party"and fighter.weapon
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

function a:useItem(user,itemId,chosen)
local c=p.get(itemId)
d.takeItem(self.state,itemId,1)
local i={}
local k=self:targetsOf(user,c.target,chosen)
for o,b in ipairs(k)do
local e={target=b}
local g=c.effect
if g=="heal"and b.hp>0 then
self:heal(b,c.power,e)
elseif g=="sp"and b.hp>0 then
local l=b.sp
b.sp=math.min(b.maxSp,b.sp+c.power)
e.spGained=b.sp-l
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
local l,m=self:magicDamage(user,b,c.power,c.element)
e.sharp=m
self:hurt(b,l,e)
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
local function c(list)
local b=0
for g,e in ipairs(list)do
b=b+self:stat(e,"spd")
end
return b/math.max(1,#list)
end
local b=0.55+0.02*(c(self:standing("party"))-c(self:standing("enemy")))
return self.random:chance(SpiffBoy.clamp(b,0.2,0.95))
end

function a:actFits(fighter,act)
local b=act[3]
if not b then
return true
end
if b.below and fighter.hp/fighter.maxHp>=b.below then
return false
end
if b.unless then
if b.foe then
for e,c in ipairs(self:standing("party"))do
if not c.statuses[b.unless]then
return true
end
end
return false
end
return not fighter.statuses[b.unless]
end
return true
end

function a:actLost(fighter,act,acts)
local b=fighter.broken
if not b or act[1]=="attack"then
return false
end
local e=h.get(act[1])
if b.arm and e.kind=="physical"then
return true
end
if b.jaw and a.JAW_ACTS[act[1]]then
return true
end
if b.core and e.kind=="magic"then
local g=0
for k,i in ipairs(acts)do
local c=i[1]~="attack"and h.get(i[1])
if c and c.kind=="magic"and c.power>g then
g=c.power
end
end
return e.power>=g
end
return false
end

function a:enemyAction(fighter)
local e=fighter.enemy.acts
if fighter.enemy.acts2 and fighter.hp<fighter.maxHp*a.PHASE_SHARE then
e=fighter.enemy.acts2
end
if self.options.fleeBelow and fighter.hp<fighter.maxHp*self.options.fleeBelow then
e={{"flee",1}}
end
local b=f.filter(e,function(act)return self:actFits(fighter,act)and not self:actLost(fighter,act,e)end)
if#b==0 then
b={{"attack",1}}
end
local k=0
for g,c in ipairs(b)do
k=k+c[2]
end
local l=self.random:int(1,k)
local m=b[1][1]
for g,c in ipairs(b)do
l=l-c[2]
if l<=0 then
m=c[1]
break
end
end
local c
if m=="attack"then
c=a.attackSkill(fighter)
else
c=h.get(m)
end
if c.kind=="flee"then
return{kind="skill",skill=c,target=fighter}
end
local g=self:standing("party")
local i=g[self.random:int(1,#g)]
if self.random:chance(a.AIM_WEAKEST)then
for s,o in ipairs(g)do
if o.hp<i.hp then
i=o
end
end
end
for s,o in ipairs(g)do
if o.statuses.taunt then
i=o
end
end
return{kind="skill",skill=c,target=i}
end

function a:endTurn(fighter)
local b=nil
if fighter.hp>0 and fighter.statuses.soot then
b={target=fighter}
self:hurt(fighter,math.max(1,math.floor(fighter.maxHp*a.SOOT_SHARE*(fighter.boss and 0.25 or 1))),b)
end
if fighter.hp>0 and fighter.statuses.regen then
b=b or{target=fighter}
self:heal(fighter,math.max(1,math.floor(fighter.maxHp*a.REGEN_SHARE)),b)
end
for c,e in pairs(fighter.statuses)do
if c~="stun"and c~="sleep"then
if e<=1 then
fighter.statuses[c]=nil
else
fighter.statuses[c]=e-1
end
end
end
return b
end

function a:tickSleep(fighter)
local b=fighter.statuses.sleep
if b<=1 then
fighter.statuses.sleep=nil
else
fighter.statuses.sleep=b-1
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
local k=b.enemy.rare
if k and self.random:chance(k[2])then
e[#e+1]=k[1]
elseif i and not b.stolen and self.random:chance(i[2])then
e[#e+1]=i[1]
end
end
end
return c,g,e
end
