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
local l=SpiffBoy.TICK_RATE
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

function a:art(name)
local c=self.textures[name]
if not c then
c=self.context.art(name)
self.textures[name]=c
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

function a:effect(name)
self.sequencer:effect(e.effectName(name))
end

function a:playMusic(name)
if self.music==name and self.sequencer:isPlaying()then
return
end
self.music=name
self.sequencer:stop()
self.sequencer:play(name)
end

function a:stopMusic()
self.music=nil
self.sequencer:stop()
end

function a:playJingle(name)
self.music=nil
self.sequencer:stop()
self.sequencer:play(name)
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

function a:tick(inputs,tick)
self.clock=self.clock+1
local c=inputs[1]
if self.shake>0 then
self.shake=self.shake-1
end
self:tickFade()
local f=self.mode
if f==a.MODE_FIELD then
self.state.time=self.state.time+1/l
self:tickField(c)
elseif f==a.MODE_BATTLE then
self.state.time=self.state.time+1/l
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

function a:startFade(direction,ticks)
local c=self.fade
c.target=direction=="out"and 3 or 0
c.speed=3/(ticks or h.fade)
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

function a:loadJourney(state,slot)
self.state=state
self.slot=slot
self.shadeShift=0
self:enterField(state.map,state.x,state.y,state.dir)
self:startFade("in")
b.trace("journey loaded from slot "..slot.." at step "..state.step.." on "..state.map)
end

function a:saveJourney(slot)
local c=self.field.player
self.state.map=self.field.id
self.state.x,self.state.y,self.state.dir=c.x,c.y,c.dir
if type(self.save.slots)~="table"then
self.save.slots={}
end
self.save.slots[slot]=o.encode(self.state)
self:persist()
self.slot=slot
b.trace("journey saved in slot "..slot.." at step "..self.state.step.." on "..self.state.map)
end

function a:enterField(mapId,x,y,dir)
self.field=n.new(self,mapId,x,y,dir)
self.state.map=mapId
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
for f,c in ipairs(self.field.map.enter or{})do
if not self.script and d.meets(self.state,c.when)then
self:runScene(c.script)
end
end
end

function a:warp(mapId,x,y,dir)
self.pendingWarp={map=mapId,x=x,y=y,dir=b.DIRECTION_INDEX[dir or"down"]or 1}
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

function a:runScene(name)
self.script=i.new(i.named(name),name)
b.trace("scene "..name)
end

function a:runCommands(commands,name)
self.script=i.new(commands,name)
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

function a:openDialog(speaker,key,argument)
local c=b.text(key,argument)
self:openText(speaker,c)
end

function a:openText(speaker,text)
local c=self.screen:wrapText(text,j.width)
local f={}
for k=1,#c,j.lines do
local g={}
for m=k,math.min(#c,k+j.lines-1)do
g[#g+1]=c[m]
end
f[#f+1]=g
end
self.dialog={speaker=speaker,pages=f,page=1,shown=0}
end

function a:notice(key,first,second)
self:openText(nil,b.text(key,first,second))
self:effect("item")
end

function a:openChoice(question,options,argument)
if question then
self:openDialog(nil,question,argument)
self.dialog.holding=true
end
self.choice={options=options,selected=1}
self.choiceResult=nil
end

function a:emote(actorId,kind)
local c=self.field:actor(actorId)
if c then
actorId=c.id
end
self.emotes[actorId]={kind=kind,timer=h.emote}
self:effect("emote")
end

function a:openTitleCard(key,subKey)
self.card={key=key,subKey=subKey,timer=0}
self.cardReturn=self.mode
self.mode=a.MODE_CARD
self.dialog={card=true,pages={},page=1,shown=0}
self:playJingle(e.CHAPTER)
end

function a:tickCard(input)
local c=self.card
c.timer=c.timer+1
if c.timer>60 and input and(input.pressed.a or input.pressed.start)then
self.card=nil
self.dialog=nil
self.mode=self.cardReturn
self:resumeMapMusic()
end
end

function a:tickDialog(input)
local c=self.dialog
local g=c.pages[c.page]
local f=0
for m,k in ipairs(g or{})do
f=f+string.len(k)
end
if c.shown<f then
c.shown=c.shown+h.typeSpeed
if self.clock%6==0 then
self:effect("talk")
end
if input and(input.pressed.a or input.pressed.b)then
c.shown=f
end
return
end
if c.holding and c.page>=#c.pages then
return
end
if input and(input.pressed.a or input.pressed.b)then
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

function a:tickChoice(input)
local c=self.choice
if self.dialog and not self:dialogComplete()then
self:tickDialog(input)
return
end
if not input then
return
end
local f=b.verticalStep(input.pressed)
if f~=0 then
c.selected=b.wrap(c.selected+f,#c.options)
self:effect("cursor")
end
if input.pressed.a then
self.choiceResult=c.selected
self.choice=nil
self.dialog=nil
self:effect("confirm")
end
end

function a:tickField(input)
local c=self.field
for g,f in pairs(self.emotes)do
f.timer=f.timer-1
if f.timer<=0 then
self.emotes[g]=nil
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
self:tickChoice(input)
c:advanceActors()
return
end
if self.dialog then
self:tickDialog(input)
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
self:tickPlayer(input)
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

function a:tickPlayer(input)
local g=self.field
local m=g.player
if m.moving then
local c=g:advanceActors()
if c then
self:arrived()
end
return
end
g:advanceActors()
if not input then
return
end
local k,f=input.pressed,input.held
if k.start then
self:openMenu()
return
end
if k.a then
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
if not g:walkPlayer(c,f.b)and k[b.DIRECTIONS[c].name]then
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
local m=g:countStep()
if m then
self:startBattle(m,{})
end
end

function a:interact()
local g=self.field
local f,c=g:interactionAhead()
if f=="npc"then
local k=c.definition
local m=g.player
c.dir=({2,1,4,3})[m.dir]
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

function a:talkTo(definition)
local f=definition.talk
if type(f)=="string"then
self:runScene(f)
return
end
for g,c in ipairs(f or{})do
if d.meets(self.state,c.when)then
if c.script then
self:runScene(c.script)
else
self:runCommands({{"say",definition.name or definition.sprite,c.say}},definition.id)
end
return
end
end
end

function a:openChest(chest)
if d.hasFlag(self.state,chest.flag)then
self:runCommands({{"say",nil,"ChestEmpty"}},"chest")
return
end
d.setFlag(self.state,chest.flag,true)
self:effect("chest")
if chest.gold then
self:runCommands({{"gold",chest.gold}},"chest")
else
self:runCommands({{"give",chest.item,chest.count or 1}},"chest")
end
end

function a:tendLamp(lamp)
if self.field:lampLit(lamp)then
self:runCommands({{"say",nil,lamp.litText or"LampLit"}},"lamp")
return
end
if lamp.when and not d.meets(self.state,lamp.when)then
self:runCommands({{"say",nil,lamp.lockedText or"LampLocked"}},"lamp")
return
end
d.setFlag(self.state,lamp.flag,true)
self:effect("lamp")
local c=0
if self.field.map.fog then
c=self.field:refreshReveal()
end
if lamp.script then
self:runScene(lamp.script)
elseif c>0 then
self:runCommands({{"say",nil,"LampLights"},{"sfx","bright"},{"say",nil,"IsletRevealed"}},"lamp")
else
self:runCommands({{"say",nil,"LampLights"}},"lamp")
end
end

function a:startBattle(troop,options)
self.pendingBattle={troop=troop,options=options,timer=h.swirl}
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

function a:tickBattleMode(input)
self.battleScene:tick(input)
end

function a:endBattle(result)
local c=self.battleScene.options
self.battleScene=nil
if result=="lose"and c.forgiving then
for g,f in ipairs(d.active(self.state))do
f.hp=math.max(1,f.hp)
end
elseif result=="lose"then
self.mode=a.MODE_OVER
self.script=nil
self.overTimer=0
self:playMusic(e.OVER)
return
end
for g,f in ipairs(d.active(self.state))do
if f.hp<=0 and result=="win"then
f.hp=1
end
end
self.mode=a.MODE_FIELD
self.battleResult=result
if c.after=="heal"then
d.restoreAll(self.state)
end
self:resumeMapMusic()
self:startFade("in",10)
end

function a:tickOver(input)
self.overTimer=self.overTimer+1
if self.overTimer>90 and input and(input.pressed.a or input.pressed.start)then
self:openTitle()
end
end

require"SpiffBoy/Games/Lanterways/View"
require"SpiffBoy/Games/Lanterways/Menu"
require"SpiffBoy/Games/Lanterways/Shop"
require"SpiffBoy/Games/Lanterways/Title"
