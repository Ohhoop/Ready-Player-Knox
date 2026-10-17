require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Random"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/GameBase"
require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Characters"
require"SpiffBoy/Games/Lanterways/Data/Skills"
require"SpiffBoy/Games/Lanterways/Data/Items"
require"SpiffBoy/Games/Lanterways/Data/Enemies"
require"SpiffBoy/Games/Lanterways/Data/Tiles"
require"SpiffBoy/Games/Lanterways/Data/Flags"
require"SpiffBoy/Games/Lanterways/Data/Shops"
require"SpiffBoy/Games/Lanterways/Data/Lore"
require"SpiffBoy/Games/Lanterways/Maps/All"
require"SpiffBoy/Games/Lanterways/Story/All"
require"SpiffBoy/Games/Lanterways/Party"
require"SpiffBoy/Games/Lanterways/SaveGame"
require"SpiffBoy/Games/Lanterways/Field"
require"SpiffBoy/Games/Lanterways/Script"
require"SpiffBoy/Games/Lanterways/Battle"
require"SpiffBoy/Games/Lanterways/BattleScene"
require"SpiffBoy/Games/Lanterways/Window"
require"SpiffBoy/Games/Lanterways/Music"

SpiffBoyLanterwaysGame=SpiffBoyGameBase:derive("SpiffBoyLanterwaysGame")

local a=SpiffBoyLanterwaysGame
local b=SpiffBoy.Lanterways
local d=b.Party
local n=b.Field
local i=b.Script
local e=b.Music
local o=b.SaveGame

a.MODE_TITLE="title"
a.MODE_FIELD="field"
a.MODE_BATTLE="battle"
a.MODE_MENU="menu"
a.MODE_SHOP="shop"
a.MODE_OVER="over"
a.MODE_ENDING="ending"
a.MODE_CARD="card"

local h={fade=20,swirl=42,typeSpeed=2,emote=40}
local m=SpiffBoy.TICK_RATE
local j={width=168,lines=3}

function a:init()
self.textures={}
self.artUi=self:art("ui")
self.artHeads=self:art("heads")
self.artFx=self:art("fx")
self.artDigits=self:art("digits")
self.artObjects=self:art("objects")
self.clock=0
self.shadeShift=0
self.shake=0
self.emotes={}
self.fade={level=0,target=0,done=true}
self:readOptions()
self:openTitle()
end

function a:art(f)
local c=self.textures[f]
if not c then
c=self.context.art(f)
self.textures[f]=c
end
return c
end

function a:readOptions()
self.mix={music=e.MIX_STEPS,effects=e.MIX_STEPS}
local f=self.save.options
if type(f)=="table"then
for k,g in ipairs({"music","effects"})do
local c=f[g]
if SpiffBoy.isInteger(c)and c>=0 and c<=e.MIX_STEPS then
self.mix[g]=c
end
end
end
self:applyMix()
end

function a:applyMix()
self.sequencer:setMix(self.mix.music/e.MIX_STEPS,self.mix.effects/e.MIX_STEPS)
end

function a:saveOptions()
self.save.options={music=self.mix.music,effects=self.mix.effects}
self:persist()
end

function a:effect(c)
self.sequencer:effect(e.effectName(c))
end

function a:playMusic(c)
if self.music==c and self.sequencer:isPlaying()then
return
end
self.music=c
self.sequencer:stop()
self.sequencer:play(c)
end

function a:stopMusic()
self.music=nil
self.sequencer:stop()
end

function a:playJingle(c)
self.music=nil
self.sequencer:stop()
self.sequencer:play(c)
end

function a:resumeMapMusic()
local c=self.field.map
local f=c.music
if c.musicLate and d.meets(self.state,c.musicLate.when)then
f=c.musicLate.music
end
if f then
self:playMusic(f)
else
self:stopMusic()
end
end

function a:tick(g,k)
self.clock=self.clock+1
local c=g[1]
if self.shake>0 then
self.shake=self.shake-1
end
self:tickFade()
local f=self.mode
if f==a.MODE_FIELD then
self.state.time=self.state.time+1/m
self:tickField(c)
elseif f==a.MODE_BATTLE then
self.state.time=self.state.time+1/m
self:tickBattleMode(c)
elseif f==a.MODE_MENU then
self:tickMenu(c)
elseif f==a.MODE_SHOP then
self:tickShop(c)
elseif f==a.MODE_CARD then
self:tickCard(c)
elseif f==a.MODE_OVER then
self:tickOver(c)
elseif f==a.MODE_ENDING then
self:tickEnding(c)
else
self:tickTitle(c)
end
end

function a:startFade(f,g)
local c=self.fade
c.target=f=="out"and 3 or 0
c.speed=3/(g or h.fade)
c.done=c.level==c.target
end

function a:tickFade()
local c=self.fade
if c.done then
return
end
if c.level<c.target then
c.level=math.min(c.target,c.level+c.speed)
else
c.level=math.max(c.target,c.level-c.speed)
end
c.done=c.level==c.target
end

function a:darkness()
return math.min(3,math.floor(self.fade.level+0.5)+self.shadeShift)
end

function a:newJourney()
self.state=d.newState()
self.slot=nil
self.shadeShift=0
self:enterField(self.state.map,self.state.x,self.state.y,self.state.dir)
self:runScene("intro")
end

function a:loadJourney(c,f)
self.state=c
self.slot=f
self.shadeShift=0
self:enterField(c.map,c.x,c.y,c.dir)
self:startFade("in")
b.trace("journey loaded from slot "..f.." at step "..c.step.." on "..c.map)
end

function a:saveJourney(c)
local f=self.field.player
self.state.map=self.field.id
self.state.x,self.state.y,self.state.dir=f.x,f.y,f.dir
if type(self.save.slots)~="table"then
self.save.slots={}
end
self.save.slots[c]=o.encode(self.state)
self:persist()
self.slot=c
b.trace("journey saved in slot "..c.." at step "..self.state.step.." on "..self.state.map)
end

function a:enterField(c,g,k,l)
self.field=n.new(self,c,g,k,l)
self.state.map=c
self.mode=a.MODE_FIELD
self.dialog=nil
self.choice=nil
self.shadeShift=self.field.map.night or 0
if self.field.map.nightWhen and d.meets(self.state,self.field.map.nightWhen)then
self.shadeShift=self.field.map.nightShift or 1
end
self:resumeMapMusic()
self:showBanner()
if self.field.map.visit then
d.setFlag(self.state,"v_"..self.field.map.visit,true)
end
for p,f in ipairs(self.field.map.enter or{})do
if not self.script and d.meets(self.state,f.when)then
self:runScene(f.script)
end
end
end

function a:warp(c,f,g,k)
self.pendingWarp={map=c,x=f,y=g,dir=b.DIRECTION_INDEX[k or"down"]or 1}
self:effect("door")
self:startFade("out",12)
end

function a:finishWarp()
local c=self.pendingWarp
self.pendingWarp=nil
if self.script and self.script.pc>#self.script.commands then
self.script=nil
end
self:enterField(c.map,c.x,c.y,c.dir)
self:startFade("in",12)
end

function a:runScene(c)
self.script=i.new(i.named(c),c)
b.trace("scene "..c)
end

function a:runCommands(c,f)
self.script=i.new(c,f)
end

function a:storyChanged()
if self.field then
self.field:refreshNpcs()
if self.field.map.fog then
self.field:refreshReveal()
end
end
end

function a:gatherAtLeader()
self.field:gatherFollowers()
end

function a:anyMoving()
local c=self.field
if c.player.moving then
return true
end
for g,f in pairs(c.npcs)do
if f.moving then
return true
end
end
return false
end

function a:openDialog(c,f,g)
local k=b.text(f,g)
self:openText(c,k)
end

function a:openText(l,p)
local c=self.screen:wrapText(p,j.width)
local f={}
for k=1,#c,j.lines do
local g={}
for q=k,math.min(#c,k+j.lines-1)do
g[#g+1]=c[q]
end
f[#f+1]=g
end
self.dialog={speaker=l,pages=f,page=1,shown=0}
end

function a:notice(c,f,g)
self:openText(nil,b.text(c,f,g))
self:effect("item")
end

function a:openChoice(c,f,g)
if c then
self:openDialog(nil,c,g)
self.dialog.holding=true
end
self.choice={options=f,selected=1}
self.choiceResult=nil
end

function a:emote(c,g)
local f=self.field:actor(c)
if f then
c=f.id
end
self.emotes[c]={kind=g,timer=h.emote}
self:effect("emote")
end

function a:openTitleCard(c,f)
self.card={key=c,subKey=f,timer=0}
self.cardReturn=self.mode
self.mode=a.MODE_CARD
self.dialog={card=true,pages={},page=1,shown=0}
self:playJingle(e.CHAPTER)
end

function a:tickCard(c)
local f=self.card
f.timer=f.timer+1
if f.timer>60 and c and(c.pressed.a or c.pressed.start)then
self.card=nil
self.dialog=nil
self.mode=self.cardReturn
self:resumeMapMusic()
end
end

function a:tickDialog(f)
local c=self.dialog
local k=c.pages[c.page]
local g=0
for p,l in ipairs(k or{})do
g=g+string.len(l)
end
if c.shown<g then
c.shown=c.shown+h.typeSpeed
if self.clock%6==0 then
self:effect("talk")
end
if f and(f.pressed.a or f.pressed.b)then
c.shown=g
end
return
end
if c.holding and c.page>=#c.pages then
return
end
if f and(f.pressed.a or f.pressed.b)then
if c.page<#c.pages then
c.page=c.page+1
c.shown=0
else
self.dialog=nil
end
end
end

function a:dialogComplete()
local c=self.dialog
if c.page<#c.pages then
return false
end
local f=0
for k,g in ipairs(c.pages[c.page]or{})do
f=f+string.len(g)
end
return c.shown>=f
end

function a:tickChoice(c)
local f=self.choice
if self.dialog and not self:dialogComplete()then
self:tickDialog(c)
return
end
if not c then
return
end
local g=b.verticalStep(c.pressed)
if g~=0 then
f.selected=b.wrap(f.selected+g,#f.options)
self:effect("cursor")
end
if c.pressed.a then
self.choiceResult=f.selected
self.choice=nil
self.dialog=nil
self:effect("confirm")
end
end

function a:tickField(f)
local c=self.field
for k,g in pairs(self.emotes)do
g.timer=g.timer-1
if g.timer<=0 then
self.emotes[k]=nil
end
end
if self.pendingWarp then
if self.fade.done then
self:finishWarp()
end
return
end
if self.pendingBattle then
self.pendingBattle.timer=self.pendingBattle.timer-1
if self.pendingBattle.timer<=0 then
self:beginBattle()
end
return
end
if self.choice then
self:tickChoice(f)
c:advanceActors()
return
end
if self.dialog then
self:tickDialog(f)
c:advanceActors()
return
end
if self.script then
c:advancePaths()
c:advanceActors()
c:updateCamera()
if self.script:update(self)then
self.script=nil
self:resumeAfterScene()
end
return
end
self:tickPlayer(f)
c:wanderNpcs()
c:updateCamera()
end

function a:resumeAfterScene()
if self.mode==a.MODE_FIELD and not self.pendingWarp and not self.pendingBattle then
if self.music==nil or not self.sequencer:isPlaying()then
self:resumeMapMusic()
end
end
end

function a:tickPlayer(k)
local g=self.field
local p=g.player
if p.moving then
local c=g:advanceActors()
if c then
self:arrived()
end
return
end
g:advanceActors()
if not k then
return
end
local l,f=k.pressed,k.held
if l.start then
self:openMenu()
return
end
if l.a then
self:interact()
return
end
local c=nil
if f.down then
c=1
elseif f.up then
c=2
elseif f.left then
c=3
elseif f.right then
c=4
end
if c then
if not g:walkPlayer(c,f.b)and l[b.DIRECTIONS[c].name]then
self:effect("bump")
end
end
end

function a:arrived()
local g=self.field
local f=g.player
local c=g:warpAt(f.x,f.y)
if c then
if c.to=="@inn"then
self.state.inn={map=g.id,x=f.x,y=f.y+1}
self.innPrice=c.price
self:warp("inn",4,6,"up")
elseif c.to=="@back"then
local k=self.state.inn
self:warp(k.map,k.x,k.y,"down")
else
self:warp(c.to,c.tx,c.ty,c.dir)
end
return
end
local k=g:eventAt(f.x,f.y)
if k then
self:runScene(k.script)
return
end
local l=g:countStep()
if l then
self:startBattle(l,{})
end
end

function a:interact()
local g=self.field
local f,c=g:interactionAhead()
if f=="npc"then
local k=c.definition
local l=g.player
c.dir=({2,1,4,3})[l.dir]
if k then
self:talkTo(k)
end
elseif f=="chest"then
self:openChest(c)
elseif f=="note"then
self:runCommands({{"page",c.page},{"say",nil,"Page_"..c.page}},"page")
elseif f=="echo"then
self:runScene("echo_"..c.echo)
elseif f=="lamp"then
self:tendLamp(c)
elseif f=="sign"then
if c.script then
self:runScene(c.script)
else
self:runCommands({{"say",nil,c.text}},"sign")
end
elseif f=="bell"then
self:runScene("bellpost")
end
end

function a:talkTo(c)
local g=c.talk
if type(g)=="string"then
self:runScene(g)
return
end
for k,f in ipairs(g or{})do
if d.meets(self.state,f.when)then
if f.script then
self:runScene(f.script)
else
self:runCommands({{"say",c.name or c.sprite,f.say}},c.id)
end
return
end
end
end

function a:openChest(c)
if d.hasFlag(self.state,c.flag)then
self:runCommands({{"say",nil,"ChestEmpty"}},"chest")
return
end
d.setFlag(self.state,c.flag,true)
self:effect("chest")
if c.gold then
self:runCommands({{"gold",c.gold}},"chest")
else
self:runCommands({{"give",c.item,c.count or 1}},"chest")
end
end

function a:tendLamp(c)
if self.field:lampLit(c)then
self:runCommands({{"say",nil,c.litText or"LampLit"}},"lamp")
return
end
if c.when and not d.meets(self.state,c.when)then
self:runCommands({{"say",nil,c.lockedText or"LampLocked"}},"lamp")
return
end
d.setFlag(self.state,c.flag,true)
self:effect("lamp")
local f=0
if self.field.map.fog then
f=self.field:refreshReveal()
end
if c.script then
self:runScene(c.script)
elseif f>0 then
self:runCommands({{"say",nil,"LampLights"},{"sfx","bright"},{"say",nil,"IsletRevealed"}},"lamp")
else
self:runCommands({{"say",nil,"LampLights"}},"lamp")
end
end

function a:startBattle(c,f)
self.pendingBattle={troop=c,options=f,timer=h.swirl}
self:stopMusic()
self:effect("ambush")
end

function a:beginBattle()
local c=self.pendingBattle
self.pendingBattle=nil
self.battleScene=b.BattleScene.new(self,c.troop,c.options)
self.mode=a.MODE_BATTLE
self:playMusic(c.options.music or e.BATTLE)
end

function a:tickBattleMode(c)
self.battleScene:tick(c)
end

function a:endBattle(c)
local f=self.battleScene.options
self.battleScene=nil
if c=="lose"and f.forgiving then
for k,g in ipairs(d.active(self.state))do
g.hp=math.max(1,g.hp)
end
elseif c=="lose"then
self.mode=a.MODE_OVER
self.script=nil
self.overTimer=0
self:playMusic(e.OVER)
return
end
for k,g in ipairs(d.active(self.state))do
if g.hp<=0 and c=="win"then
g.hp=1
end
end
self.mode=a.MODE_FIELD
self.battleResult=c
if f.after=="heal"then
d.restoreAll(self.state)
end
self:resumeMapMusic()
self:startFade("in",10)
end

function a:tickOver(c)
self.overTimer=self.overTimer+1
if self.overTimer>90 and c and(c.pressed.a or c.pressed.start)then
self:openTitle()
end
end

require"SpiffBoy/Games/Lanterways/View"
require"SpiffBoy/Games/Lanterways/Menu"
require"SpiffBoy/Games/Lanterways/Shop"
require"SpiffBoy/Games/Lanterways/Title"
