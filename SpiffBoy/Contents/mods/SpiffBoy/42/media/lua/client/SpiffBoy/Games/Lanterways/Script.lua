require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"

local b=SpiffBoy.Lanterways
local d=b.Party

local e={}
e.__index=e
b.Script=e

e.MAX_STEPS_PER_TICK=64

function e.named(name)
local a=b.Scripts[name]
if not a then
error("Lanterways: no scene named "..tostring(name))
end
return a
end

function e.new(commands,name)
local a=setmetatable({},e)
a.commands=commands
a.name=name
a.pc=1
a.labels={}
for f,c in ipairs(commands)do
if c[1]=="label"then
a.labels[c[2]]=f
end
end
a.wait=nil
a.finished=false
return a
end

function e:jump(label)
local a=self.labels[label]
if not a then
error("Lanterways: scene "..tostring(self.name).." has no label "..tostring(label))
end
self.pc=a
end

local function k(game)
local a=game.choiceResult
game.choiceResult=nil
return a
end

function e:waitOver(game)
local a=self.wait
if not a then
return true
end
if a.kind=="dialog"then
return game.dialog==nil
elseif a.kind=="choice"then
if game.choice then
return false
end
local f=k(game)
local c=a.labels
if c and c[f]then
self:jump(c[f])
end
return true
elseif a.kind=="travel"then
if game.choice then
return false
end
local c=k(game)
game:finishTravel(c)
return true
elseif a.kind=="warp"then
return game.pendingWarp==nil and game.fade.done
elseif a.kind=="ticks"then
a.left=a.left-1
return a.left<=0
elseif a.kind=="paths"then
return not game.field:advancePaths()and not game:anyMoving()
elseif a.kind=="fade"then
return game.fade.done
elseif a.kind=="battle"then
return game.battleResult~=nil
elseif a.kind=="mode"then
return game.mode==a.mode
elseif a.kind=="music"then
return not game.sequencer:isPlaying()
end
return true
end

function e:update(game)
if not self:waitOver(game)then
return false
end
if self.wait and self.wait.kind=="battle"then
local a=game.battleResult
local c=self.wait.lost
game.battleResult=nil
self.wait=nil
if a~="win"then
if a=="lose"and c then
self:jump(c)
else
self.finished=true
return true
end
end
end
self.wait=nil
local a=0
while self.pc<=#self.commands do
a=a+1
if a>e.MAX_STEPS_PER_TICK then
return false
end
local c=self.commands[self.pc]
self.pc=self.pc+1
self:run(game,c)
if self.wait then
return false
end
if self.finished then
return true
end
end
self.finished=true
return true
end

function e:argument(game,value)
if value=="@innprice"then
return game.innPrice
end
if type(value)=="table"then
return b.text(value.text)
end
return value
end

function e:run(game,command)
local a=command[1]
local c=game.state
if a=="say"then
game:openDialog(command[2],command[3],self:argument(game,command[4]))
self.wait={kind="dialog"}
elseif a=="choice"then
game:openChoice(command[2],command[3],self:argument(game,command[5]))
self.wait={kind="choice",labels=command[4]}
elseif a=="pay"then
local f=self:argument(game,command[2])
if game.state.gold<f then
self:jump(command[3])
else
d.addGold(c,-f)
game:effect("buy")
end
elseif a=="label"then
return
elseif a=="goto"then
self:jump(command[2])
elseif a=="if"then
if d.meets(c,command[2])then
self:jump(command[3])
end
elseif a=="end"then
self.finished=true
elseif a=="step"then
c.step=command[2]
game:storyChanged()
elseif a=="flag"then
d.setFlag(c,command[2],command[3]~=false)
game:storyChanged()
elseif a=="give"then
d.addItem(c,command[2],command[3]or 1)
game:notice("Got",b.text("Item_"..command[2]),command[3]or 1)
self.wait={kind="dialog"}
elseif a=="take"then
d.takeItem(c,command[2],command[3]or 1)
elseif a=="gold"then
d.addGold(c,command[2])
if command[2]>0 then
game:notice("GotGold",command[2])
self.wait={kind="dialog"}
end
elseif a=="join"then
d.join(c,command[2])
game.field:refreshParty()
game:gatherAtLeader()
game:effect("join")
game:notice("Joined",b.text("Name_"..command[2]))
self.wait={kind="dialog"}
elseif a=="leave"then
d.leave(c,command[2])
game.field:refreshParty()
elseif a=="heal"then
d.restoreAll(c)
elseif a=="battle"then
game.battleResult=nil
game:startBattle(command[2],command[3]or{})
self.wait={kind="battle",lost=command[4]}
elseif a=="bright"then
local f=b.Characters.BY_ID[command[2]]
d.setFlag(c,"b_"..command[2],true)
game:notice("BrightLearned",b.text("Name_"..command[2]),b.text("Skill_"..f.bright))
self.wait={kind="dialog"}
elseif a=="learn"then
d.setFlag(c,command[3],true)
game:effect("join")
game:notice("BattleLearned",b.text("Name_"..command[2]),b.text("Skill_"..command[4]))
self.wait={kind="dialog"}
elseif a=="trialdone"then
local f=b.Characters.BY_ID[command[2]]
d.setFlag(c,"t_"..command[2],true)
game:effect("bright")
game:notice("BrightUp",b.text("Name_"..command[2]),b.text("Skill_"..f.bright))
self.wait={kind="dialog"}

elseif a=="music"then
game:playMusic(command[2])
elseif a=="stopmusic"then
game:stopMusic()
elseif a=="jingle"then
game:playJingle(command[2])
self.wait={kind="music"}
elseif a=="sfx"then
game:effect(command[2])
elseif a=="fade"then
game:startFade(command[2],command[3])
self.wait={kind="fade"}
elseif a=="wait"then
self.wait={kind="ticks",left=command[2]}
elseif a=="warp"then
game:warp(command[2],command[3],command[4],command[5])
self.wait={kind="warp"}
elseif a=="move"then
local f=game.field:actor(command[2])
if f then
game.field:setPath(f,command[3])
end
if command[4]~=false then
self.wait={kind="paths"}
end
elseif a=="waitmoves"then
self.wait={kind="paths"}
elseif a=="face"then
local f=game.field:actor(command[2])
if f then
f.dir=b.DIRECTION_INDEX[command[3]]
end
elseif a=="spawn"then
game.field:spawn(command[2],command[3],command[4],command[5],command[6])
elseif a=="despawn"then
game.field:despawn(command[2])
elseif a=="emote"then
game:emote(command[2],command[3])
self.wait={kind="ticks",left=40}
elseif a=="shake"then
game.shake=command[2]or 30
game:effect("rumble")
elseif a=="title"then
game:openTitleCard(command[2],command[3])
self.wait={kind="dialog"}
elseif a=="shop"then
game:openShop(command[2])
self.wait={kind="mode",mode="field"}
elseif a=="night"then
game.shadeShift=command[2]
elseif a=="travel"then
game:openTravel()
self.wait={kind="travel"}
elseif a=="visit"then
d.setFlag(c,"v_"..command[2],true)
elseif a=="ending"then
game:startEnding()
self.finished=true
elseif a=="gather"then
game:gatherAtLeader()
elseif a=="refresh"then
game.field:refreshNpcs()
elseif a=="page"then
d.setFlag(c,"p_"..command[2],true)
game:notice("PageFound",b.text("PageTitle_"..command[2]))
self.wait={kind="dialog"}
elseif a=="echo"then
d.setFlag(c,"e_"..command[2],true)
game:effect("bright")
elseif a=="walkoff"then
local f=game.field
local g=f:actor(command[2])
local h=f:pathOffScreen(g,b.MurkSea.sites[command[3]])
if not h then
error("Lanterways: "..command[2].." has no way off the screen on "..f.id)
end
f:setPath(g,h)
self.wait={kind="paths"}
elseif a=="walkaway"then
local f=game.field
local g=f:actor(command[2])
local l=b.DIRECTIONS[b.DIRECTION_INDEX[({u="up",d="down",l="left",r="right"})[command[3]]]]
local h,i,j=g.x,g.y,0
while not f:offScreen(h,i)do
h,i,j=h+l.dx,i+l.dy,j+1
end
f:setPath(g,string.rep(command[3],j))
self.wait={kind="paths"}
elseif a=="back"then
local f=game.field.player
game.field:setPath(f,({"u","d","r","l"})[f.dir])
self.wait={kind="paths"}
else
error("Lanterways: unknown scene command "..tostring(a).." in "..tostring(self.name))
end
end
