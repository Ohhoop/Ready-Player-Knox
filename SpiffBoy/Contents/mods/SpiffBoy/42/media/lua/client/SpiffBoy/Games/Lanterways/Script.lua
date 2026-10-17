require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Party"

local d=SpiffBoy.Lanterways
local f=d.Party

local g={}
g.__index=g
d.Script=g

g.MAX_STEPS_PER_TICK=64

function g.named(a)
local b=d.Scripts[a]
if not b then
error("Lanterways: no scene named "..tostring(a))
end
return b
end

function g.new(b,e)
local a=setmetatable({},g)
a.commands=b
a.name=e
a.pc=1
a.labels={}
for h,c in ipairs(b)do
if c[1]=="label"then
a.labels[c[2]]=h
end
end
a.wait=nil
a.finished=false
return a
end

function g:jump(a)
local b=self.labels[a]
if not b then
error("Lanterways: scene "..tostring(self.name).." has no label "..tostring(a))
end
self.pc=b
end

local function m(a)
local b=a.choiceResult
a.choiceResult=nil
return b
end

function g:waitOver(b)
local a=self.wait
if not a then
return true
end
if a.kind=="dialog"then
return b.dialog==nil
elseif a.kind=="choice"then
if b.choice then
return false
end
local e=m(b)
local c=a.labels
if c and c[e]then
self:jump(c[e])
end
return true
elseif a.kind=="travel"then
if b.choice then
return false
end
local c=m(b)
b:finishTravel(c)
return true
elseif a.kind=="warp"then
return b.pendingWarp==nil and b.fade.done
elseif a.kind=="ticks"then
a.left=a.left-1
return a.left<=0
elseif a.kind=="paths"then
return not b.field:advancePaths()and not b:anyMoving()
elseif a.kind=="fade"then
return b.fade.done
elseif a.kind=="battle"then
return b.battleResult~=nil
elseif a.kind=="mode"then
return b.mode==a.mode
elseif a.kind=="music"then
return not b.sequencer:isPlaying()
end
return true
end

function g:update(a)
if not self:waitOver(a)then
return false
end
if self.wait and self.wait.kind=="battle"then
local b=a.battleResult
local c=self.wait.lost
a.battleResult=nil
self.wait=nil
if b~="win"then
if b=="lose"and c then
self:jump(c)
else
self.finished=true
return true
end
end
end
self.wait=nil
local b=0
while self.pc<=#self.commands do
b=b+1
if b>g.MAX_STEPS_PER_TICK then
return false
end
local c=self.commands[self.pc]
self.pc=self.pc+1
self:run(a,c)
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

function g:argument(b,a)
if a=="@innprice"then
return b.innPrice
end
if type(a)=="table"then
return d.text(a.text)
end
return a
end

function g:run(b,a)
local c=a[1]
local e=b.state
if c=="say"then
b:openDialog(a[2],a[3],self:argument(b,a[4]))
self.wait={kind="dialog"}
elseif c=="choice"then
b:openChoice(a[2],a[3],self:argument(b,a[5]))
self.wait={kind="choice",labels=a[4]}
elseif c=="pay"then
local h=self:argument(b,a[2])
if b.state.gold<h then
self:jump(a[3])
else
f.addGold(e,-h)
b:effect("buy")
end
elseif c=="label"then
return
elseif c=="goto"then
self:jump(a[2])
elseif c=="if"then
if f.meets(e,a[2])then
self:jump(a[3])
end
elseif c=="end"then
self.finished=true
elseif c=="step"then
e.step=a[2]
b:storyChanged()
elseif c=="flag"then
f.setFlag(e,a[2],a[3]~=false)
b:storyChanged()
elseif c=="give"then
f.addItem(e,a[2],a[3]or 1)
b:notice("Got",d.text("Item_"..a[2]),a[3]or 1)
self.wait={kind="dialog"}
elseif c=="take"then
f.takeItem(e,a[2],a[3]or 1)
elseif c=="gold"then
f.addGold(e,a[2])
if a[2]>0 then
b:notice("GotGold",a[2])
self.wait={kind="dialog"}
end
elseif c=="join"then
f.join(e,a[2])
b.field:refreshParty()
b:gatherAtLeader()
b:effect("join")
b:notice("Joined",d.text("Name_"..a[2]))
self.wait={kind="dialog"}
elseif c=="leave"then
f.leave(e,a[2])
b.field:refreshParty()
elseif c=="heal"then
f.restoreAll(e)
elseif c=="battle"then
b.battleResult=nil
b:startBattle(a[2],a[3]or{})
self.wait={kind="battle",lost=a[4]}
elseif c=="bright"then
local h=d.Characters.BY_ID[a[2]]
f.setFlag(e,"b_"..a[2],true)
b:notice("BrightLearned",d.text("Name_"..a[2]),d.text("Skill_"..h.bright))
self.wait={kind="dialog"}
elseif c=="learn"then
f.setFlag(e,a[3],true)
b:effect("join")
b:notice("BattleLearned",d.text("Name_"..a[2]),d.text("Skill_"..a[4]))
self.wait={kind="dialog"}
elseif c=="trialdone"then
local h=d.Characters.BY_ID[a[2]]
f.setFlag(e,"t_"..a[2],true)
b:effect("bright")
b:notice("BrightUp",d.text("Name_"..a[2]),d.text("Skill_"..h.bright))
self.wait={kind="dialog"}

elseif c=="music"then
b:playMusic(a[2])
elseif c=="stopmusic"then
b:stopMusic()
elseif c=="jingle"then
b:playJingle(a[2])
self.wait={kind="music"}
elseif c=="sfx"then
b:effect(a[2])
elseif c=="fade"then
b:startFade(a[2],a[3])
self.wait={kind="fade"}
elseif c=="wait"then
self.wait={kind="ticks",left=a[2]}
elseif c=="warp"then
b:warp(a[2],a[3],a[4],a[5])
self.wait={kind="warp"}
elseif c=="move"then
local h=b.field:actor(a[2])
if h then
b.field:setPath(h,a[3])
end
if a[4]~=false then
self.wait={kind="paths"}
end
elseif c=="waitmoves"then
self.wait={kind="paths"}
elseif c=="face"then
local h=b.field:actor(a[2])
if h then
h.dir=d.DIRECTION_INDEX[a[3]]
end
elseif c=="spawn"then
b.field:spawn(a[2],a[3],a[4],a[5],a[6])
elseif c=="despawn"then
b.field:despawn(a[2])
elseif c=="emote"then
b:emote(a[2],a[3])
self.wait={kind="ticks",left=40}
elseif c=="shake"then
b.shake=a[2]or 30
b:effect("rumble")
elseif c=="title"then
b:openTitleCard(a[2],a[3])
self.wait={kind="dialog"}
elseif c=="shop"then
b:openShop(a[2])
self.wait={kind="mode",mode="field"}
elseif c=="night"then
b.shadeShift=a[2]
elseif c=="travel"then
b:openTravel()
self.wait={kind="travel"}
elseif c=="visit"then
f.setFlag(e,"v_"..a[2],true)
elseif c=="ending"then
b:startEnding()
self.finished=true
elseif c=="gather"then
b:gatherAtLeader()
elseif c=="refresh"then
b.field:refreshNpcs()
elseif c=="page"then
f.setFlag(e,"p_"..a[2],true)
b:notice("PageFound",d.text("PageTitle_"..a[2]))
self.wait={kind="dialog"}
elseif c=="echo"then
f.setFlag(e,"e_"..a[2],true)
b:effect("bright")
elseif c=="walkoff"then
local h=b.field
local i=h:actor(a[2])
local j=h:pathOffScreen(i,d.MurkSea.sites[a[3]])
if not j then
error("Lanterways: "..a[2].." has no way off the screen on "..h.id)
end
h:setPath(i,j)
self.wait={kind="paths"}
elseif c=="walkaway"then
local h=b.field
local i=h:actor(a[2])
local n=d.DIRECTIONS[d.DIRECTION_INDEX[({u="up",d="down",l="left",r="right"})[a[3]]]]
local j,k,l=i.x,i.y,0
while not h:offScreen(j,k)do
j,k,l=j+n.dx,k+n.dy,l+1
end
h:setPath(i,string.rep(a[3],l))
self.wait={kind="paths"}
elseif c=="back"then
local h=b.field.player
b.field:setPath(h,({"u","d","r","l"})[h.dir])
self.wait={kind="paths"}
else
error("Lanterways: unknown scene command "..tostring(c).." in "..tostring(self.name))
end
end
