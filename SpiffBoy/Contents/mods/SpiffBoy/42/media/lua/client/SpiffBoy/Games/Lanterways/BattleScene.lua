require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Battle"
require"SpiffBoy/Games/Lanterways/Window"
require"SpiffBoy/Games/Lanterways/Music"

local a=SpiffBoy.Lanterways
local q=a.Battle
local g=a.Party
local v=a.Skills
local w=a.Items
local G=a.Enemies
local c=a.Window
local x=a.Music

local e={}
e.__index=e
a.BattleScene=e

local b={
fieldTop=12,enemyLeft=62,enemyRight=176,enemyBase=76,enemyBack=10,stepForward=8,enemyLunge=4,
panelY=78,panelH=42,rowX=4,rowY=82,rowH=9,healthX=14,healthSlash=33,pointsX=54,pointsSlash=73,
divideX=95,iconX=99,iconY=81,iconStep=16,labelX=99,labelY=98,sideX=99,sideW=77,
timelineX=2,timelineY=1,timelineStep=10,timelineCount=9,
glowX=126,glowY=3,glowW=40,
listX=4,listY=16,listW=172,listRows=4,
digitW=4,digitH=6,partHalf=5,
}
local i={intro=50,announce=26,impact=46,message=70,fade=30,flee=40}
local m={"attack","skill","item","guard","run"}
local y=3
local n=24
local H={"hit","flame","heal","ring","murk","moth","dust","flash","buff"}
local h=8
local s,z=12,16
local l={stand=9,attack=12,cast=13,hurt=14,down=15,victory=16}
local A={{40,56},{22,42},{40,28},{22,14}}
local o={1}
local I={1,3}
local r={1,4}
local J={3,4}
local B={1,2,3}
local K={1,2,4}
local t={2,3,4}
local L={1,2,3,4}
local M={{"blind","statusBlind"},{"sleep","statusSleep"},{"soot","statusSoot"},{"stun","statusStun"}}

function e.new(f,j,k)
local d=setmetatable({},e)
d.game=f
d.options=k or{}
d.battle=q.new(f.state,j,f.random,d.options)
d.phase="intro"
d.timer=i.intro
d.popups={}
d.messages={}
d.clock=0
d.menu={command=1,list=1,top=1}
d.background=f:art("battle_"..(d.options.back or f.field.map.back or"fog"))
d:layoutEnemies()
d:say(a.text("BattleAppear"))
return d
end

function e:layoutEnemies()
local f=self.battle.enemies
local j=0
for p,d in ipairs(f)do
local k=G.SIZES[d.enemy.size]
d.w,d.h=k[1],k[2]
j=j+k[1]
end
local u=b.enemyRight-b.enemyLeft
local D=4
local k=0
if#f>1 then
k=math.min(D,(u-j)/(#f-1))
end
local p=b.enemyLeft+math.max(0,(u-j-k*(#f-1))/2)
for E,d in ipairs(f)do
local C=0
if#f>1 and E%2==0 then
C=b.enemyBack
end
d.x=math.floor(p)
d.y=b.enemyBase-d.h-C
p=p+d.w+k
end
for C,d in ipairs(self.battle.parts)do
d.x=d.owner.x+d.owner.w-d.offset.x-b.partHalf
d.y=d.owner.y+d.offset.y-b.partHalf
d.w,d.h=b.partHalf*2,b.partHalf*2
end
for C,d in ipairs(self.battle.party)do
d.x,d.y=A[C][1],A[C][2]
d.w,d.h=s,z
end
end

function e:say(d)
self.message=d
end

local function C(d)
return d.x+d.w/2,d.y+d.h/2
end

function e:popup(d,f,j,k)
local p,u=C(d)
self.popups[#self.popups+1]={x=p,y=u-4,kind=f,value=j,timer=i.impact,delay=k or 0}
end

function e:showOutcomes(p,u)
local j=self.game
local k=0
for E,d in ipairs(p)do
local f=d.target
f.fx={name=u or"hit",timer=18,delay=k}
if d.miss then
self:popup(f,"miss",nil,k)
j:effect("miss")
end
if d.damage then
self:popup(f,"damage",d.damage,k)
if d.weak then
self:popup(f,"weak",nil,k)
end
f.flash=16
if d.crit then
j:effect("crit")
else
j:effect("hit")
end
end
if d.heal and d.heal>0 then
self:popup(f,"heal",d.heal,k)
j:effect("heal")
end
if d.spGained then
self:popup(f,"heal",d.spGained,k)
end
if d.statuses then
for F,D in ipairs(d.statuses)do
self:popup(f,"status",D,k+8)
end
if#d.statuses>0 then
j:effect("status")
end
end
if d.resisted then
self:popup(f,"miss",nil,k)
end
if d.surveyed then
j:effect("status")
end
if d.glow then
j:effect("bright")
end
if d.stole then
self:popup(f,"status","statusUp",k)
j:effect("item")
end
if f.part and d.damage then
f.owner.flash=16
end
if d.ko and f.side=="enemy"and not f.part then
f.dying=i.fade
j:effect("fall")
end
if d.broken then
j:effect("crit")
if d.ownerKo then
f.owner.dying=i.fade
j:effect("fall")
end
end
k=k+4
end
end

function e:nextTurn()
local f=self.battle
local d=f:nextActor()
self.actor=d
if d.statuses.stun then
d.statuses.stun=nil
f:requeue(d,0.6)
self:say(a.text("BattleStunned",d.name))
self.phase="wait"
self.timer=i.announce
return
end
if d.statuses.sleep then
f:tickSleep(d)
f:requeue(d,0.8)
self:say(a.text("BattleAsleep",d.name))
self.phase="wait"
self.timer=i.announce
return
end
d.guarding=false
if d.side=="party"then
self.phase="command"
self.menu.mode="main"
self.menu.command=1
self:say(nil)
self.game:effect("turn")
else
self:perform(d,f:enemyAction(d))
end
end

function e:perform(j,d)
self.pending=d
self.phase="announce"
self.timer=i.announce
local f
if d.kind=="skill"and d.skill.kind=="flee"then
self:say(a.text("BattleFled",j.name))
j.acting=true
return
elseif d.kind=="skill"and d.skill.id~="attack"then
f=a.text("Skill_"..d.skill.id)
elseif d.kind=="item"then
f=a.text("Item_"..d.item)
elseif d.kind=="guard"then
f=a.text("CommandGuard")
elseif d.kind=="run"then
f=a.text("CommandRun")
else
f=a.text("CommandAttack")
end
self:say(a.text("BattleUses",j.name,f))
j.acting=true
end

function e:resolve()
local j=self.battle
local f=self.actor
local d=self.pending
self.pending=nil
f.acting=false
local u=1
if d.kind=="skill"then
local k=d.skill
local p=j:useSkill(f,k,d.target)
self:showOutcomes(p,k.fx)
self:tellOutcomes(f,p)
if k.bright or k.duo then
self.game:effect("bright")
end
elseif d.kind=="item"then
local k=w.get(d.item)
if k.effect=="escape"then
self:flee()
return
end
local p="heal"
if k.target=="enemy"or k.target=="enemies"then
p="dust"
if k.effect=="damage"then
p=k.element=="flame"and"flame"or"ring"
end
end
local D=j:useItem(f,d.item,d.target)
self:showOutcomes(D,p)
self:tellOutcomes(f,D)
elseif d.kind=="guard"then
f.guarding=true
u=0.6
self.game:effect("guard")
elseif d.kind=="run"then
if j:tryEscape()then
self:flee()
return
end
self:say(a.text("BattleNoEscape"))
self.game:effect("miss")
end
j:requeue(f,u)
local k=j:endTurn(f)
if k then
self:showOutcomes({k},"dust")
end
self.phase="impact"
self.timer=i.impact
end

function e:tellOutcomes(k,j)
for p,d in ipairs(j)do
if d.broken then
local f=d.broken
self:say(a.text("PartBroken",f.owner.name,a.text("Part_"..f.part)).." "..a.text("PartEffect_"..f.part))
return
elseif d.stole then
self:say(a.text("BattleStole",k.name,a.text("Item_"..d.stole)))
return
elseif d.stealMissed then
self:say(a.text("BattleStealMiss"))
return
elseif d.fled then
self:say(a.text("BattleFled",d.target.name))
return
end
end
for f,d in ipairs(j)do
if d.sharp then
self:say(a.text("SharpHit"))
return
end
end
end

function e:flee()
self:say(a.text("BattleEscaped"))
self.game:effect("flee")
self.phase="flee"
self.timer=i.flee
self.battle:syncParty()
end

function e:afterImpact()
local d=self.battle:outcome()
if d=="win"then
self:victory()
elseif d=="lose"then
self.battle:syncParty()
self.phase="defeat"
self:say(a.text("BattleDefeat"))
self.game:playJingle(x.DEFEAT)
self.timer=i.message*2
else
self:nextTurn()
end
end

function e:victory()
local D=self.battle
local f=self.game.state
D:syncParty()
local N=g.strengthenBonds(f)
local p,u,O=D:spoils()
g.addGold(f,u)
local d={a.text("BattleWin"),a.text("BattleSpoils",p,u)}
for E,j in ipairs(N)do
local k=a.Skills.get(j).duo[2]
d[#d+1]=a.text("DuoReadyLine",a.text("Name_"..k),a.text("DuoReady_"..j))
end
for k,j in ipairs(O)do
g.addItem(f,j,1)
d[#d+1]=a.text("BattleFound",a.text("Item_"..j))
end
local j={}
for E,k in ipairs(g.active(f))do
if k.hp>0 then
j[#j+1]={k,p}
else
j[#j+1]={k,math.floor(p*g.RESERVE_SHARE)}
end
end
for E,k in ipairs(g.reserve(f))do
j[#j+1]={k,math.floor(p*g.RESERVE_SHARE)}
end
for S,E in ipairs(j)do
local k=E[1]
local P=#g.skills(f,k)
local Q=g.gainXp(k,E[2])
if Q>0 then
d[#d+1]=a.text("BattleLevel",a.text("Name_"..k.id),k.level)
local F=g.skills(f,k)
for R=P+1,#F do
d[#d+1]=a.text("BattleLearned",a.text("Name_"..k.id),a.text("Skill_"..F[R]))
end
end
end
self.lines=d
self.lineIndex=1
self:say(d[1])
self.phase="victory"
self.timer=20
self.game:playJingle(x.VICTORY)
a.trace("battle won: "..p.." xp, "..u.." glints")
end

function e.skillLabel(f)
local d=a.text("Skill_"..f.id)
if f.upgraded then
d=d.." II"
end
return d
end

function e:skillRows(f)
local d={}
local j=self.battle
if j:brightReady(f)then
local k=j:brightOf(f)
d[#d+1]={id=k.id,skill=k,label=e.skillLabel(k),right=a.text("Bright")}
end
for p,k in ipairs(j:duosOf(f))do
d[#d+1]={id=k.id,skill=k,label=e.skillLabel(k),right=a.text("Duo"),disabled=self.game.state.glow<v.DUO_GLOW}
end
for u,k in ipairs(g.skills(self.game.state,f.member))do
local p=v.get(k)
d[#d+1]={id=k,skill=p,label=a.text("Skill_"..k),right=tostring(p.cost),disabled=p.cost>f.sp}
end
return d
end

function e:itemRows()
local d={}
local j=self.game.state
for k,f in ipairs(g.bagList(j,function(f)return f.kind=="use"end))do
d[#d+1]={id=f,label=a.text("Item_"..f),right="x"..g.count(j,f)}
end
return d
end

function e:chooseTarget(k,f)
local j=self.battle
local p=self.actor
local d
if f=="enemy"then
d=j:enemyTargets()
elseif f=="ally"then
d=j:standing("party")
elseif f=="fallen"then
d=j:fallen()
if#d==0 then
self.game:effect("buzz")
return
end
else
self:perform(p,k)
return
end
self.menu.targets=d
self.menu.target=1
if f~="enemy"then
self.menu.target=math.max(1,a.indexOf(d,p)or 1)
end
self.menu.action=k
self.menu.back=self.menu.mode
self.menu.mode="target"
end

function e:tickCommand(E)
local d=self.menu
local j=E.pressed
local f=self.game
local k=self.actor
if d.mode=="main"then
local u=a.horizontalStep(j)
if u~=0 then
d.command=a.wrap(d.command+u,#m)
f:effect("cursor")
end
if j.a then
local p=m[d.command]
f:effect("confirm")
if p=="attack"then
self:chooseTarget({kind="skill",skill=q.attackSkill(k)},"enemy")
elseif p=="skill"then
d.rows=self:skillRows(k)
d.list,d.top,d.mode=1,1,"skill"
elseif p=="item"then
d.rows=self:itemRows()
if self.options.noItems or#d.rows==0 then
f:effect("buzz")
else
d.list,d.top,d.mode=1,1,"item"
end
elseif p=="guard"then
self:perform(k,{kind="guard"})
else
if self.options.noEscape then
f:effect("buzz")
self:say(a.text("BattleCannotRun"))
else
self:perform(k,{kind="run"})
end
end
end
elseif d.mode=="skill"or d.mode=="item"then
local u=a.verticalStep(j)
if u~=0 and#d.rows>0 then
d.list=a.wrap(d.list+u,#d.rows)
d.top=c.scroll(d.list,d.top,b.listRows,#d.rows)
f:effect("cursor")
end
if j.b then
d.mode="main"
f:effect("cancel")
elseif j.a and d.rows[d.list]then
local p=d.rows[d.list]
if p.disabled then
f:effect("buzz")
elseif d.mode=="skill"then
local D=p.skill
f:effect("confirm")
self:chooseTarget({kind="skill",skill=D},D.target)
else
local D=w.get(p.id)
f:effect("confirm")
self:chooseTarget({kind="item",item=p.id},D.target)
end
end
elseif d.mode=="target"then
local p=a.verticalStep(j)+a.horizontalStep(j)
if p~=0 then
d.target=a.wrap(d.target+p,#d.targets)
f:effect("cursor")
end
if j.b then
d.mode=d.back
f:effect("cancel")
elseif j.a then
local u=d.action
u.target=d.targets[d.target]
f:effect("confirm")
self:perform(k,u)
end
end
end

function e:tick(j)
self.clock=self.clock+1
for f=#self.popups,1,-1 do
local d=self.popups[f]
if d.delay>0 then
d.delay=d.delay-1
else
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.popups,f)
end
end
end
for k,d in ipairs(self.battle.combatants)do
if d.flash and d.flash>0 then
d.flash=d.flash-1
end
if d.dying and d.dying>0 then
d.dying=d.dying-1
end
local f=d.fx
if f then
if f.delay>0 then
f.delay=f.delay-1
else
f.timer=f.timer-1
if f.timer<=0 then
d.fx=nil
end
end
end
end
local d=self.phase
if d=="command"then
if j then
self:tickCommand(j)
end
return
end
if d=="victory"then
self.timer=self.timer-1
if self.timer<=0 and j and j.pressed.a then
self.lineIndex=self.lineIndex+1
self.game:effect("cursor")
if self.lineIndex>#self.lines then
self.game:endBattle("win")
else
self:say(self.lines[self.lineIndex])
self.timer=10
end
end
return
end
self.timer=self.timer-1
if self.timer>0 then
return
end
if d=="intro"or d=="wait"then
self:nextTurn()
elseif d=="announce"then
self:resolve()
elseif d=="impact"then
self:afterImpact()
elseif d=="flee"then
self.game:endBattle("flee")
elseif d=="defeat"then
self.game:endBattle("lose")
end
end

function e:digits(d,f,j,k,u)
local D=tostring(math.floor(f))
local p=string.len(D)*b.digitW
if u then
c.fill(d,j-p-1,k-1,p+1,b.digitH+2,a.PAPER)
end
d:number(f,j,k,self.game.artDigits,"right",0,a.INK)
end

local function D(d,f,j,k,p,E)
c.fill(d,f,j,k,p,a.INK)
local u=math.floor((k-2)*SpiffBoy.clamp(E,0,1))
if u>0 then
c.fill(d,f+1,j+1,u,p-2,a.PAPER)
end
end

function e:drawEnemy(p,d)
if d.hp<=0 and not(d.dying and d.dying>0)then
return
end
if d.flash and d.flash>0 and math.floor(d.flash/2)%2==0 then
return
end
if d.dying and d.dying>0 and math.floor(d.dying/3)%2==0 then
return
end
local j="enemy_"..d.id
if d.partFighters then
local f=0
for u,k in ipairs(d.partFighters)do
if k.hp<=0 then
f=f+2^(k.index-1)
end
end
if f>0 then
j=j.."_b"..math.floor(f)
end
end
local f=d.x
if d.acting then
f=f-b.enemyLunge
end
p:layers(self.game:art(j),0,d.w,d.h,f,d.y,L)
end

function e:drawMember(p,d)
local f=l.stand
local j=d.x
if d.hp<=0 then
f=l.down
elseif self.phase=="victory"then
f=l.victory
elseif d.acting then
f=l.attack
j=j+b.stepForward
if self.pending and self.pending.kind=="skill"and self.pending.skill.kind~="physical"then
f=l.cast
end
elseif d.flash and d.flash>0 then
f=l.hurt
elseif self.phase=="command"and self.actor==d then
j=j+b.stepForward
f=l.stand+(math.floor(self.clock/16)%2)
end
local E=self.game:art("walk_"..d.id)
p:layers(E,f*s,s,z,j,d.y,B)
local k=j
for F,u in ipairs(M)do
if d.statuses[u[1]]then
c.icon(p,self.game.artUi,u[2],k,d.y-7,o)
k=k+7
end
end
end

function e:drawFraction(d,p,u,f,j)
local k=self.game.artDigits
d:number(p,f,j,k,"right",0,a.INK)
c.icon(d,self.game.artUi,"slash",f,j,o)
d:number(u,f+b.digitW,j,k,"left",0,a.INK)
end

function e:drawPartyRows(d)
local k=self.game.artUi
for p,j in ipairs(self.battle.party)do
local f=b.rowY+(p-1)*b.rowH
if self.phase=="command"and self.actor==j then
c.fill(d,b.rowX-1,f-1,b.divideX-b.rowX-1,b.rowH,a.MID)
end
c.fill(d,b.rowX,f-1,h,h,a.INK)
d:layers(self.game.artHeads,(a.Characters.BY_ID[j.id].index-1)*h,h,h-1,b.rowX,f-1,t)
c.icon(d,k,"heartSmall",b.healthX,f,I)
self:drawFraction(d,j.hp,j.maxHp,b.healthSlash,f)
c.icon(d,k,"lampSmall",b.pointsX,f,B)
self:drawFraction(d,j.sp,j.maxSp,b.pointsSlash,f)
end
c.fill(d,b.divideX,b.panelY+3,1,b.panelH-6,a.DARK)
end

function e:drawFx(j,f)
local d=f.fx
if not d or d.delay>0 then
return
end
local k=a.indexOf(H,d.name)or 1
local p=math.min(y-1,math.floor((18-d.timer)/6))
local u,E=C(f)
j:layers(self.game.artFx,((k-1)*y+p)*n,n,n,u-n/2,E-n/2,r)
end

function e:drawPopups(f)
for u,d in ipairs(self.popups)do
if d.delay<=0 then
local k=math.floor((i.impact-d.timer)/4)
local j=d.y-math.min(8,k)
if d.kind=="damage"then
self:digits(f,d.value,d.x+8,j,true)
elseif d.kind=="heal"then
c.icon(f,self.game.artUi,"statusRegen",d.x-14,j-1,o)
self:digits(f,d.value,d.x+8,j,true)
elseif d.kind=="weak"then
c.icon(f,self.game.artUi,"bang",d.x+8,j-10,r)
elseif d.kind=="miss"then
c.icon(f,self.game.artUi,"dots",d.x-4,j-2,r)
elseif d.kind=="status"then
local p=e.statusIcon(d.value)
c.icon(f,self.game.artUi,p,d.x-4,j-10,r)
end
end
end
end

function e.statusIcon(d)
if string.find(d,"Up")then
return"statusUp"
elseif string.find(d,"Down")then
return"statusDown"
end
return"status"..string.upper(string.sub(d,1,1))..string.sub(d,2)
end

function e:drawTimeline(d)
c.fill(d,0,0,a.WIDTH,b.fieldTop,a.INK)
local k=self.battle:timeline(b.timelineCount)
local p=self.menu.mode=="target"and self.phase=="command"and self.menu.targets[self.menu.target]
for u,f in ipairs(k)do
local j=b.timelineX+(u-1)*b.timelineStep
if f==p then
c.fill(d,j-1,b.timelineY-1,h+2,h+2,a.PAPER)
end
if f.side=="party"then
d:layers(self.game.artHeads,(a.Characters.BY_ID[f.id].index-1)*h,h,h,j,b.timelineY,t)
else
d:layers(self.game.artHeads,7*h,h,h,j,b.timelineY,t)
end
end
if not g.glowKnown(self.game.state)then
return
end
c.icon(d,self.game.artUi,"glow",b.glowX-11,b.glowY-2,J)
D(d,b.glowX,b.glowY,b.glowW,5,self.game.state.glow/q.GLOW_MAX)
if self.game.state.glow>=q.GLOW_MAX and math.floor(self.clock/10)%2==0 then
c.fill(d,b.glowX+1,b.glowY+1,b.glowW-2,3,a.MID)
end
end

function e:drawPanel(d)
local k=self.game.artUi
c.frame(d,k,0,b.panelY,a.WIDTH,b.panelH)
local f=self.menu
if self.phase=="command"then
if f.mode=="skill"or f.mode=="item"then
local j=f.rows[f.list]
if j then
local E=f.mode=="skill"and"SkillDesc_"or"ItemDesc_"
local p=d:wrapText(a.text(E..j.id),a.WIDTH-10)
for u=1,math.min(2,#p)do
c.text(d,p[u],5,b.panelY+3+(u-1)*c.LINE)
end
end
return
end
self:drawPartyRows(d)
if f.mode=="main"then
for j,u in ipairs(m)do
local p=b.iconX+(j-1)*b.iconStep
if j==f.command then
c.fill(d,p-1,b.iconY-1,b.iconStep,b.iconStep,a.MID)
end
c.icon(d,k,u,p,b.iconY,K)
end
local j=self.message or a.text("Command"..string.upper(string.sub(m[f.command],1,1))..string.sub(m[f.command],2))
c.text(d,c.fit(d,j,b.sideW),b.labelX,b.labelY)
elseif f.mode=="target"then
local j=f.targets[f.target]
c.text(d,c.fit(d,j.name,b.sideW),b.sideX,b.panelY+3)
if j.side=="party"or j.surveyed then
local p=j.hp.."/"..j.maxHp
local u=j.side=="enemy"and j.enemy.weak
if u then
p=p.." "..a.text("Weak_"..u)
end
c.text(d,c.fit(d,p,b.sideW),b.sideX,b.labelY,a.DARK)
end
end
return
end
if self.message then
local j=d:wrapText(self.message,a.WIDTH-10)
for p=1,math.min(2,#j)do
c.text(d,j[p],5,b.panelY+3+(p-1)*c.LINE)
end
else
self:drawPartyRows(d)
end
if self.phase=="victory"and self.timer<=0 and math.floor(self.clock/16)%2==0 then
c.icon(d,k,"arrowDown",a.WIDTH-10,a.HEIGHT-9,o)
end
end

function e:drawList(f)
local d=self.menu
local j=self.game.artUi
local k=b.listRows*c.LINE+6
c.frame(f,j,b.listX-2,b.listY-3,b.listW+4,k)
if#d.rows==0 then
return
end
c.list(f,j,d.rows,b.listX,b.listY,b.listW,b.listRows,d.list,d.top,self.clock,true)
if d.mode=="skill"then
c.textRight(f,self.actor.sp.."/"..self.actor.maxSp,b.listX+b.listW,b.listY-16+k+2,a.PAPER)
end
end

function e:draw(d)
d:clear(a.shade(a.PAPER))
local p=b.fieldTop
for f=1,3 do
d:sheet(self.background,0,(f-1)*70,a.WIDTH,70,0,p,1,f)
end
for j,f in ipairs(self.battle.enemies)do
self:drawEnemy(d,f)
end
for j,f in ipairs(self.battle.party)do
self:drawMember(d,f)
end
for j,f in ipairs(self.battle.combatants)do
self:drawFx(d,f)
end
local j=self.menu
if self.phase=="command"and j.mode=="target"then
local f=j.targets[j.target]
local k=f.x-8
if f.side=="enemy"then
k=f.x+math.floor(f.w/2)-3
c.icon(d,self.game.artUi,"target",f.x+math.floor(f.w/2)-4,f.y+math.floor(f.h/2)-4,o)
c.cursor(d,self.game.artUi,k,f.y-10,self.clock)
else
c.cursor(d,self.game.artUi,k,f.y+math.floor(f.h/2)-4,self.clock)
end
end
self:drawPopups(d)
self:drawTimeline(d)
if self.phase=="command"and(j.mode=="skill"or j.mode=="item")then
self:drawList(d)
end
self:drawPanel(d)
end
