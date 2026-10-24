require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Battle"
require"SpiffBoy/Games/Lanterways/Window"
require"SpiffBoy/Games/Lanterways/Music"

local a=SpiffBoy.Lanterways
local q=a.Battle
local g=a.Party
local v=a.Skills
local z=a.Items
local G=a.Enemies
local c=a.Window
local A=a.Music

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
local j={intro=50,announce=26,impact=46,message=70,fade=30,flee=40}
local m={"attack","skill","item","guard","run"}
local B=3
local n=24
local H={"hit","flame","heal","ring","murk","moth","dust","flash","buff"}
local i=8
local s,C=12,16
local l={stand=9,attack=12,cast=13,hurt=14,down=15,victory=16}
local D={{40,56},{22,42},{40,28},{22,14}}
local o={1}
local I={1,3}
local r={1,4}
local J={3,4}
local E={1,2,3}
local K={1,2,4}
local t={2,3,4}
local L={1,2,3,4}
local M={{"blind","statusBlind"},{"sleep","statusSleep"},{"soot","statusSoot"},{"stun","statusStun"}}

function e.new(game,troop,options)
local d=setmetatable({},e)
d.game=game
d.options=options or{}
d.battle=q.new(game.state,troop,game.random,d.options)
d.phase="intro"
d.timer=j.intro
d.popups={}
d.messages={}
d.clock=0
d.menu={command=1,list=1,top=1}
d.background=game:art("battle_"..(d.options.back or game.field.map.back or"fog"))
d:layoutEnemies()
d:say(a.text("BattleAppear"))
return d
end

function e:layoutEnemies()
local f=self.battle.enemies
local h=0
for p,d in ipairs(f)do
local k=G.SIZES[d.enemy.size]
d.w,d.h=k[1],k[2]
h=h+k[1]
end
local u=b.enemyRight-b.enemyLeft
local x=4
local k=0
if#f>1 then
k=math.min(x,(u-h)/(#f-1))
end
local p=b.enemyLeft+math.max(0,(u-h-k*(#f-1))/2)
for y,d in ipairs(f)do
local w=0
if#f>1 and y%2==0 then
w=b.enemyBack
end
d.x=math.floor(p)
d.y=b.enemyBase-d.h-w
p=p+d.w+k
end
for w,d in ipairs(self.battle.parts)do
d.x=d.owner.x+d.owner.w-d.offset.x-b.partHalf
d.y=d.owner.y+d.offset.y-b.partHalf
d.w,d.h=b.partHalf*2,b.partHalf*2
end
for w,d in ipairs(self.battle.party)do
d.x,d.y=D[w][1],D[w][2]
d.w,d.h=s,C
end
end

function e:say(text)
self.message=text
end

local function F(fighter)
return fighter.x+fighter.w/2,fighter.y+fighter.h/2
end

function e:popup(fighter,kind,value,delay)
local d,f=F(fighter)
self.popups[#self.popups+1]={x=d,y=f-4,kind=kind,value=value,timer=j.impact,delay=delay or 0}
end

function e:showOutcomes(outcomes,fx)
local h=self.game
local k=0
for u,d in ipairs(outcomes)do
local f=d.target
f.fx={name=fx or"hit",timer=18,delay=k}
if d.miss then
self:popup(f,"miss",nil,k)
h:effect("miss")
end
if d.damage then
self:popup(f,"damage",d.damage,k)
if d.weak then
self:popup(f,"weak",nil,k)
end
f.flash=16
if d.crit then
h:effect("crit")
else
h:effect("hit")
end
end
if d.heal and d.heal>0 then
self:popup(f,"heal",d.heal,k)
h:effect("heal")
end
if d.spGained then
self:popup(f,"heal",d.spGained,k)
end
if d.statuses then
for w,p in ipairs(d.statuses)do
self:popup(f,"status",p,k+8)
end
if#d.statuses>0 then
h:effect("status")
end
end
if d.resisted then
self:popup(f,"miss",nil,k)
end
if d.surveyed then
h:effect("status")
end
if d.glow then
h:effect("bright")
end
if d.stole then
self:popup(f,"status","statusUp",k)
h:effect("item")
end
if f.part and d.damage then
f.owner.flash=16
end
if d.ko and f.side=="enemy"and not f.part then
f.dying=j.fade
h:effect("fall")
end
if d.broken then
h:effect("crit")
if d.ownerKo then
f.owner.dying=j.fade
h:effect("fall")
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
self.timer=j.announce
return
end
if d.statuses.sleep then
f:tickSleep(d)
f:requeue(d,0.8)
self:say(a.text("BattleAsleep",d.name))
self.phase="wait"
self.timer=j.announce
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

function e:perform(fighter,action)
self.pending=action
self.phase="announce"
self.timer=j.announce
local d
if action.kind=="skill"and action.skill.kind=="flee"then
self:say(a.text("BattleFled",fighter.name))
fighter.acting=true
return
elseif action.kind=="skill"and action.skill.id~="attack"then
d=a.text("Skill_"..action.skill.id)
elseif action.kind=="item"then
d=a.text("Item_"..action.item)
elseif action.kind=="guard"then
d=a.text("CommandGuard")
elseif action.kind=="run"then
d=a.text("CommandRun")
else
d=a.text("CommandAttack")
end
self:say(a.text("BattleUses",fighter.name,d))
fighter.acting=true
end

function e:resolve()
local h=self.battle
local f=self.actor
local d=self.pending
self.pending=nil
f.acting=false
local u=1
if d.kind=="skill"then
local k=d.skill
local p=h:useSkill(f,k,d.target)
self:showOutcomes(p,k.fx)
self:tellOutcomes(f,p)
if k.bright or k.duo then
self.game:effect("bright")
end
elseif d.kind=="item"then
local k=z.get(d.item)
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
local w=h:useItem(f,d.item,d.target)
self:showOutcomes(w,p)
self:tellOutcomes(f,w)
elseif d.kind=="guard"then
f.guarding=true
u=0.6
self.game:effect("guard")
elseif d.kind=="run"then
if h:tryEscape()then
self:flee()
return
end
self:say(a.text("BattleNoEscape"))
self.game:effect("miss")
end
h:requeue(f,u)
local k=h:endTurn(f)
if k then
self:showOutcomes({k},"dust")
end
self.phase="impact"
self.timer=j.impact
end

function e:tellOutcomes(fighter,outcomes)
for h,d in ipairs(outcomes)do
if d.broken then
local f=d.broken
self:say(a.text("PartBroken",f.owner.name,a.text("Part_"..f.part)).." "..a.text("PartEffect_"..f.part))
return
elseif d.stole then
self:say(a.text("BattleStole",fighter.name,a.text("Item_"..d.stole)))
return
elseif d.stealMissed then
self:say(a.text("BattleStealMiss"))
return
elseif d.fled then
self:say(a.text("BattleFled",d.target.name))
return
end
end
for f,d in ipairs(outcomes)do
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
self.timer=j.flee
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
self.game:playJingle(A.DEFEAT)
self.timer=j.message*2
else
self:nextTurn()
end
end

function e:victory()
local w=self.battle
local f=self.game.state
w:syncParty()
local N=g.strengthenBonds(f)
local p,u,O=w:spoils()
g.addGold(f,u)
local d={a.text("BattleWin"),a.text("BattleSpoils",p,u)}
for x,h in ipairs(N)do
local k=a.Skills.get(h).duo[2]
d[#d+1]=a.text("DuoReadyLine",a.text("Name_"..k),a.text("DuoReady_"..h))
end
for k,h in ipairs(O)do
g.addItem(f,h,1)
d[#d+1]=a.text("BattleFound",a.text("Item_"..h))
end
local h={}
for x,k in ipairs(g.active(f))do
if k.hp>0 then
h[#h+1]={k,p}
else
h[#h+1]={k,math.floor(p*g.RESERVE_SHARE)}
end
end
for x,k in ipairs(g.reserve(f))do
h[#h+1]={k,math.floor(p*g.RESERVE_SHARE)}
end
for S,x in ipairs(h)do
local k=x[1]
local P=#g.skills(f,k)
local Q=g.gainXp(k,x[2])
if Q>0 then
d[#d+1]=a.text("BattleLevel",a.text("Name_"..k.id),k.level)
local y=g.skills(f,k)
for R=P+1,#y do
d[#d+1]=a.text("BattleLearned",a.text("Name_"..k.id),a.text("Skill_"..y[R]))
end
end
end
self.lines=d
self.lineIndex=1
self:say(d[1])
self.phase="victory"
self.timer=20
self.game:playJingle(A.VICTORY)
a.trace("battle won: "..p.." xp, "..u.." glints")
end

function e.skillLabel(skill)
local d=a.text("Skill_"..skill.id)
if skill.upgraded then
d=d.." II"
end
return d
end

function e:skillRows(fighter)
local d={}
local f=self.battle
if f:brightReady(fighter)then
local h=f:brightOf(fighter)
d[#d+1]={id=h.id,skill=h,label=e.skillLabel(h),right=a.text("Bright")}
end
for k,h in ipairs(f:duosOf(fighter))do
d[#d+1]={id=h.id,skill=h,label=e.skillLabel(h),right=a.text("Duo"),disabled=self.game.state.glow<v.DUO_GLOW}
end
for p,h in ipairs(g.skills(self.game.state,fighter.member))do
local k=v.get(h)
d[#d+1]={id=h,skill=k,label=a.text("Skill_"..h),right=tostring(k.cost),disabled=k.cost>fighter.sp}
end
return d
end

function e:itemRows()
local d={}
local h=self.game.state
for k,f in ipairs(g.bagList(h,function(item)return item.kind=="use"end))do
d[#d+1]={id=f,label=a.text("Item_"..f),right="x"..g.count(h,f)}
end
return d
end

function e:chooseTarget(action,targetKind)
local f=self.battle
local h=self.actor
local d
if targetKind=="enemy"then
d=f:enemyTargets()
elseif targetKind=="ally"then
d=f:standing("party")
elseif targetKind=="fallen"then
d=f:fallen()
if#d==0 then
self.game:effect("buzz")
return
end
else
self:perform(h,action)
return
end
self.menu.targets=d
self.menu.target=1
if targetKind~="enemy"then
self.menu.target=math.max(1,a.indexOf(d,h)or 1)
end
self.menu.action=action
self.menu.back=self.menu.mode
self.menu.mode="target"
end

function e:tickCommand(input)
local d=self.menu
local h=input.pressed
local f=self.game
local k=self.actor
if d.mode=="main"then
local u=a.horizontalStep(h)
if u~=0 then
d.command=a.wrap(d.command+u,#m)
f:effect("cursor")
end
if h.a then
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
local u=a.verticalStep(h)
if u~=0 and#d.rows>0 then
d.list=a.wrap(d.list+u,#d.rows)
d.top=c.scroll(d.list,d.top,b.listRows,#d.rows)
f:effect("cursor")
end
if h.b then
d.mode="main"
f:effect("cancel")
elseif h.a and d.rows[d.list]then
local p=d.rows[d.list]
if p.disabled then
f:effect("buzz")
elseif d.mode=="skill"then
local w=p.skill
f:effect("confirm")
self:chooseTarget({kind="skill",skill=w},w.target)
else
local w=z.get(p.id)
f:effect("confirm")
self:chooseTarget({kind="item",item=p.id},w.target)
end
end
elseif d.mode=="target"then
local p=a.verticalStep(h)+a.horizontalStep(h)
if p~=0 then
d.target=a.wrap(d.target+p,#d.targets)
f:effect("cursor")
end
if h.b then
d.mode=d.back
f:effect("cancel")
elseif h.a then
local u=d.action
u.target=d.targets[d.target]
f:effect("confirm")
self:perform(k,u)
end
end
end

function e:tick(input)
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
for h,d in ipairs(self.battle.combatants)do
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
if input then
self:tickCommand(input)
end
return
end
if d=="victory"then
self.timer=self.timer-1
if self.timer<=0 and input and input.pressed.a then
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

function e:digits(screen,value,right,y,plate)
local f=tostring(math.floor(value))
local d=string.len(f)*b.digitW
if plate then
c.fill(screen,right-d-1,y-1,d+1,b.digitH+2,a.PAPER)
end
screen:number(value,right,y,self.game.artDigits,"right",0,a.INK)
end

local function u(screen,x,y,w,h,share)
c.fill(screen,x,y,w,h,a.INK)
local d=math.floor((w-2)*SpiffBoy.clamp(share,0,1))
if d>0 then
c.fill(screen,x+1,y+1,d,h-2,a.PAPER)
end
end

function e:drawEnemy(screen,fighter)
if fighter.hp<=0 and not(fighter.dying and fighter.dying>0)then
return
end
if fighter.flash and fighter.flash>0 and math.floor(fighter.flash/2)%2==0 then
return
end
if fighter.dying and fighter.dying>0 and math.floor(fighter.dying/3)%2==0 then
return
end
local f="enemy_"..fighter.id
if fighter.partFighters then
local d=0
for k,h in ipairs(fighter.partFighters)do
if h.hp<=0 then
d=d+2^(h.index-1)
end
end
if d>0 then
f=f.."_b"..math.floor(d)
end
end
local d=fighter.x
if fighter.acting then
d=d-b.enemyLunge
end
screen:layers(self.game:art(f),0,fighter.w,fighter.h,d,fighter.y,L)
end

function e:drawMember(screen,fighter)
local d=l.stand
local f=fighter.x
if fighter.hp<=0 then
d=l.down
elseif self.phase=="victory"then
d=l.victory
elseif fighter.acting then
d=l.attack
f=f+b.stepForward
if self.pending and self.pending.kind=="skill"and self.pending.skill.kind~="physical"then
d=l.cast
end
elseif fighter.flash and fighter.flash>0 then
d=l.hurt
elseif self.phase=="command"and self.actor==fighter then
f=f+b.stepForward
d=l.stand+(math.floor(self.clock/16)%2)
end
local p=self.game:art("walk_"..fighter.id)
screen:layers(p,d*s,s,C,f,fighter.y,E)
local h=f
for w,k in ipairs(M)do
if fighter.statuses[k[1]]then
c.icon(screen,self.game.artUi,k[2],h,fighter.y-7,o)
h=h+7
end
end
end

function e:drawFraction(screen,value,most,slash,y)
local d=self.game.artDigits
screen:number(value,slash,y,d,"right",0,a.INK)
c.icon(screen,self.game.artUi,"slash",slash,y,o)
screen:number(most,slash+b.digitW,y,d,"left",0,a.INK)
end

function e:drawPartyRows(screen)
local h=self.game.artUi
for k,f in ipairs(self.battle.party)do
local d=b.rowY+(k-1)*b.rowH
if self.phase=="command"and self.actor==f then
c.fill(screen,b.rowX-1,d-1,b.divideX-b.rowX-1,b.rowH,a.MID)
end
c.fill(screen,b.rowX,d-1,i,i,a.INK)
screen:layers(self.game.artHeads,(a.Characters.BY_ID[f.id].index-1)*i,i,i-1,b.rowX,d-1,t)
c.icon(screen,h,"heartSmall",b.healthX,d,I)
self:drawFraction(screen,f.hp,f.maxHp,b.healthSlash,d)
c.icon(screen,h,"lampSmall",b.pointsX,d,E)
self:drawFraction(screen,f.sp,f.maxSp,b.pointsSlash,d)
end
c.fill(screen,b.divideX,b.panelY+3,1,b.panelH-6,a.DARK)
end

function e:drawFx(screen,fighter)
local d=fighter.fx
if not d or d.delay>0 then
return
end
local f=a.indexOf(H,d.name)or 1
local h=math.min(B-1,math.floor((18-d.timer)/6))
local k,p=F(fighter)
screen:layers(self.game.artFx,((f-1)*B+h)*n,n,n,k-n/2,p-n/2,r)
end

function e:drawPopups(screen)
for p,d in ipairs(self.popups)do
if d.delay<=0 then
local h=math.floor((j.impact-d.timer)/4)
local f=d.y-math.min(8,h)
if d.kind=="damage"then
self:digits(screen,d.value,d.x+8,f,true)
elseif d.kind=="heal"then
c.icon(screen,self.game.artUi,"statusRegen",d.x-14,f-1,o)
self:digits(screen,d.value,d.x+8,f,true)
elseif d.kind=="weak"then
c.icon(screen,self.game.artUi,"bang",d.x+8,f-10,r)
elseif d.kind=="miss"then
c.icon(screen,self.game.artUi,"dots",d.x-4,f-2,r)
elseif d.kind=="status"then
local k=e.statusIcon(d.value)
c.icon(screen,self.game.artUi,k,d.x-4,f-10,r)
end
end
end
end

function e.statusIcon(status)
if string.find(status,"Up")then
return"statusUp"
elseif string.find(status,"Down")then
return"statusDown"
end
return"status"..string.upper(string.sub(status,1,1))..string.sub(status,2)
end

function e:drawTimeline(screen)
c.fill(screen,0,0,a.WIDTH,b.fieldTop,a.INK)
local h=self.battle:timeline(b.timelineCount)
local k=self.menu.mode=="target"and self.phase=="command"and self.menu.targets[self.menu.target]
for p,d in ipairs(h)do
local f=b.timelineX+(p-1)*b.timelineStep
if d==k then
c.fill(screen,f-1,b.timelineY-1,i+2,i+2,a.PAPER)
end
if d.side=="party"then
screen:layers(self.game.artHeads,(a.Characters.BY_ID[d.id].index-1)*i,i,i,f,b.timelineY,t)
else
screen:layers(self.game.artHeads,7*i,i,i,f,b.timelineY,t)
end
end
if not g.glowKnown(self.game.state)then
return
end
c.icon(screen,self.game.artUi,"glow",b.glowX-11,b.glowY-2,J)
u(screen,b.glowX,b.glowY,b.glowW,5,self.game.state.glow/q.GLOW_MAX)
if self.game.state.glow>=q.GLOW_MAX and math.floor(self.clock/10)%2==0 then
c.fill(screen,b.glowX+1,b.glowY+1,b.glowW-2,3,a.MID)
end
end

function e:drawPanel(screen)
local h=self.game.artUi
c.frame(screen,h,0,b.panelY,a.WIDTH,b.panelH)
local d=self.menu
if self.phase=="command"then
if d.mode=="skill"or d.mode=="item"then
local f=d.rows[d.list]
if f then
local w=d.mode=="skill"and"SkillDesc_"or"ItemDesc_"
local k=screen:wrapText(a.text(w..f.id),a.WIDTH-10)
for p=1,math.min(2,#k)do
c.text(screen,k[p],5,b.panelY+3+(p-1)*c.LINE)
end
end
return
end
self:drawPartyRows(screen)
if d.mode=="main"then
for f,p in ipairs(m)do
local k=b.iconX+(f-1)*b.iconStep
if f==d.command then
c.fill(screen,k-1,b.iconY-1,b.iconStep,b.iconStep,a.MID)
end
c.icon(screen,h,p,k,b.iconY,K)
end
local f=self.message or a.text("Command"..string.upper(string.sub(m[d.command],1,1))..string.sub(m[d.command],2))
c.text(screen,c.fit(screen,f,b.sideW),b.labelX,b.labelY)
elseif d.mode=="target"then
local f=d.targets[d.target]
c.text(screen,c.fit(screen,f.name,b.sideW),b.sideX,b.panelY+3)
if f.side=="party"or f.surveyed then
local k=f.hp.."/"..f.maxHp
local p=f.side=="enemy"and f.enemy.weak
if p then
k=k.." "..a.text("Weak_"..p)
end
c.text(screen,c.fit(screen,k,b.sideW),b.sideX,b.labelY,a.DARK)
end
end
return
end
if self.message then
local f=screen:wrapText(self.message,a.WIDTH-10)
for k=1,math.min(2,#f)do
c.text(screen,f[k],5,b.panelY+3+(k-1)*c.LINE)
end
else
self:drawPartyRows(screen)
end
if self.phase=="victory"and self.timer<=0 and math.floor(self.clock/16)%2==0 then
c.icon(screen,h,"arrowDown",a.WIDTH-10,a.HEIGHT-9,o)
end
end

function e:drawList(screen)
local d=self.menu
local f=self.game.artUi
local h=b.listRows*c.LINE+6
c.frame(screen,f,b.listX-2,b.listY-3,b.listW+4,h)
if#d.rows==0 then
return
end
c.list(screen,f,d.rows,b.listX,b.listY,b.listW,b.listRows,d.list,d.top,self.clock,true)
if d.mode=="skill"then
c.textRight(screen,self.actor.sp.."/"..self.actor.maxSp,b.listX+b.listW,b.listY-16+h+2,a.PAPER)
end
end

function e:draw(screen)
screen:clear(a.shade(a.PAPER))
local k=b.fieldTop
for d=1,3 do
screen:sheet(self.background,0,(d-1)*70,a.WIDTH,70,0,k,1,d)
end
for f,d in ipairs(self.battle.enemies)do
self:drawEnemy(screen,d)
end
for f,d in ipairs(self.battle.party)do
self:drawMember(screen,d)
end
for f,d in ipairs(self.battle.combatants)do
self:drawFx(screen,d)
end
local f=self.menu
if self.phase=="command"and f.mode=="target"then
local d=f.targets[f.target]
local h=d.x-8
if d.side=="enemy"then
h=d.x+math.floor(d.w/2)-3
c.icon(screen,self.game.artUi,"target",d.x+math.floor(d.w/2)-4,d.y+math.floor(d.h/2)-4,o)
c.cursor(screen,self.game.artUi,h,d.y-10,self.clock)
else
c.cursor(screen,self.game.artUi,h,d.y+math.floor(d.h/2)-4,self.clock)
end
end
self:drawPopups(screen)
self:drawTimeline(screen)
if self.phase=="command"and(f.mode=="skill"or f.mode=="item")then
self:drawList(screen)
end
self:drawPanel(screen)
end
