require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local c=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local b=a.Window
local e=a.Party
local l=a.Items
local j=a.Skills
local m=a.Characters
local o=a.SaveGame
local r=a.Music

local B={"MenuItems","MenuSkills","MenuEquip","MenuStatus","MenuOrder","MenuBook","MenuBestiary","MenuBonds","MenuSave","MenuOptions"}
local p={bookPages=true,bookEchoes=true,bookQuests=true}
local g={x=52,y=30,w=75,h=54,step=2,shades={1,2,4},outline=4}
local s={1}
local C={1,3}
local t={1,2,3}
local d={
mainX=0,mainW=74,partyX=74,partyW=106,rowH=26,listX=2,listY=4,listW=176,listRows=5,
descY=86,descH=34,statX=6,statY=22,slotY=4,mainRows=6,panelRows=4,
}
local u={"atk","def","mag","res","spd"}
local n={"weapon","armor","charm"}

function c:menuEntries()
local f={}
for i,h in ipairs(B)do
if h~="MenuBook"or e.hasFlag(self.state,"j_book")then
f[#f+1]=h
end
end
return f
end

function c:openMenu()
self.mode=c.MODE_MENU
self.menu={screen="main",index=1,top=1,mainTop=1,partyTop=1}
self:effect("open")
end

function c:closeMenu()
self.mode=c.MODE_FIELD
self.menu=nil
self:effect("cancel")
end

function c:pickMember(purpose,all)
local f=self.menu
f.pickFrom=f.screen
f.screen="pick"
f.purpose=purpose
f.pickAll=all
if purpose=="useItem"or purpose=="castOn"or not f.member then
f.member=1
end
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#self:menuMembers(all))
end

function c:menuMembers(all)
if all then
local f={}
for i,h in ipairs(self.state.order)do
f[#f+1]=self.state.members[h]
end
return f
end
return e.active(self.state)
end

function c:useItemOnMember(itemId,member)
local f=l.get(itemId)
local v=e.stats(member)
local h=false
local k={member}
if f.target=="allies"then
k=e.active(self.state)
end
if f.effect=="heal"then
for w,i in ipairs(k)do
local q=e.stats(i).hp
if i.hp>0 and i.hp<q then
i.hp=math.min(q,i.hp+f.power)
h=true
end
end
elseif f.effect=="sp"then
for w,i in ipairs(k)do
local q=e.stats(i).sp
if i.hp>0 and i.sp<q then
i.sp=math.min(q,i.sp+f.power)
h=true
end
end
elseif f.effect=="revive"and member.hp<=0 then
member.hp=math.max(1,math.floor(v.hp*f.power))
h=true
end
if h then
e.takeItem(self.state,itemId,1)
self:effect("heal")
else
self:effect("buzz")
end
return h
end

function c:useSkillOnMember(caster,skillId,member)
local f=j.get(skillId)
if caster.sp<f.cost or caster.hp<=0 then
self:effect("buzz")
return false
end
local v=e.stats(caster).mag
local q={member}
if f.target=="allies"then
q=e.active(self.state)
end
local i=false
for w,h in ipairs(q)do
local k=e.stats(h).hp
if f.kind=="heal"and h.hp>0 and h.hp<k then
h.hp=math.min(k,h.hp+math.floor(f.power+v*0.8))
i=true
elseif f.kind=="revive"and h.hp<=0 then
h.hp=math.max(1,math.floor(k*f.power))
i=true
end
end
if i then
caster.sp=caster.sp-f.cost
self:effect("heal")
else
self:effect("buzz")
end
return i
end

function c:bagRows()
local h={}
for q,f in ipairs(e.bagList(self.state))do
local k=l.get(f)
local i="x"..e.count(self.state,f)
if k.kind=="key"then
i=nil
end
h[#h+1]={id=f,label=a.text("Item_"..f),right=i}
end
return h
end

function c:skillRowsOf(member)
local f={}
for k,h in ipairs(e.skills(self.state,member))do
local i=j.get(h)
f[#f+1]={id=h,label=a.text("Skill_"..h),right=tostring(i.cost),disabled=not j.usableInField(i)or i.cost>member.sp}
end
return f
end

function c:bestiaryRows()
local h={}
local i=self.state
for q,f in ipairs(a.Enemies.ORDER)do
local k={id=f,label="???"}
if i.seen[f]then
k.label=a.text("Enemy_"..f)
end
if i.known[f]then
k.right=a.text("Level").." "..a.Enemies.get(f,e.enemyBonus(i)).level
end
h[#h+1]=k
end
return h
end

function c:bondRows()
local h={}
for q,f in ipairs(j.DUOS)do
local k=j.get(f).duo
local i={id=f,label=a.text("Name_"..k[1]).." + "..a.text("Name_"..k[2]),right=e.bond(self.state,f).."/"..j.BOND_NEEDED}
if e.duoReady(self.state,f)then
i.label=a.text("Skill_"..f)
i.right=a.text("Duo")
end
h[#h+1]=i
end
return h
end

function c:bookRows()
local f=self.state
local q,h=a.Lore.pages(),0
for k,i in ipairs(q)do
if e.hasFlag(f,"p_"..i.id)then
h=h+1
end
end
local i=0
for v,k in ipairs(a.Lore.ECHOES)do
if e.hasFlag(f,"e_"..k)then
i=i+1
end
end
local k=0
for w,v in ipairs(a.Lore.QUESTS)do
if e.hasFlag(f,v.done)then
k=k+1
end
end
return{
{id="pages",label=a.text("BookPages"),right=h.."/"..#q},
{id="echoes",label=a.text("BookEchoes"),right=i.."/"..#a.Lore.ECHOES},
{id="quests",label=a.text("BookQuests"),right=k.."/"..#a.Lore.QUESTS},
{id="map",label=a.text("BookMap")},
}
end

function c:bookPageRows()
local h={}
for k,f in ipairs(a.Lore.pages())do
local i=e.hasFlag(self.state,"p_"..f.id)
h[#h+1]={id=f.id,series=f.series,found=i,label=i and a.text("PageTitle_"..f.id)or"???"}
end
return h
end

function c:bookEchoRows()
local f={}
for k,h in ipairs(a.Lore.ECHOES)do
local i=e.hasFlag(self.state,"e_"..h)
f[#f+1]={id=h,found=i,label=i and a.text("EchoTitle_"..h)or"???"}
end
return f
end

function c:questState(quest)
if e.hasFlag(self.state,quest.done)then
return"done"
elseif e.hasFlag(self.state,quest.started)then
return"started"
end
return nil
end

function c:bookQuestRows()
local f={}
for q,h in ipairs(a.Lore.QUESTS)do
local i=self:questState(h)
local k={id=h.id,progress=i,label="???"}
if i then
k.label=a.text("QuestTitle_"..h.id)
k.right=a.text("Quest_"..i)
end
f[#f+1]=k
end
return f
end

function c:equipRows(member,slot)
local f={}
local i=m.BY_ID[member.id]
if slot=="charm"and member.equip.charm then
f[#f+1]={id=false,label=a.text("Remove")}
end
for k,h in ipairs(e.bagList(self.state,function(item)return item.kind==slot and l.fits(i,item)end))do
f[#f+1]={id=h,label=a.text("Item_"..h),right="x"..e.count(self.state,h)}
end
return f
end

function c:openList(screen,rows)
local f=self.menu
f.screen=screen
f.rows=rows
f.list=1
f.listTop=1
end

function c:stepList(pressed)
local f=self.menu
local h=a.verticalStep(pressed)
if h~=0 and#f.rows>0 then
f.list=a.wrap(f.list+h,#f.rows)
f.listTop=b.scroll(f.list,f.listTop,d.listRows,#f.rows)
self:effect("cursor")
end
end

function c:tickMenu(input)
if self.dialog then
self:tickDialog(input)
return
end
if not input then
return
end
local f=self.menu
if f.finishing and(f.written or f.screen=="main")then
self:openTitle()
return
end
local h=input.pressed
local i=f.screen
if i=="main"then
local k=a.verticalStep(h)
if k~=0 then
local q=self:menuEntries()
f.index=a.wrap(f.index+k,#q)
f.mainTop=b.scroll(f.index,f.mainTop,d.mainRows,#q)
self:effect("cursor")
end
if h.b or h.start then
self:closeMenu()
elseif h.a then
self:effect("confirm")
self:openEntry(self:menuEntries()[f.index])
end
elseif i=="pick"then
self:tickPick(h)
elseif i=="items"or i=="skills"or i=="equipList"or i=="bestiary"or i=="bonds"or i=="book"or p[i]then
self:tickMenuList(h)
elseif i=="slots"then
local k=a.verticalStep(h)
if k~=0 then
f.slot=a.wrap(f.slot+k,#n)
self:effect("cursor")
end
if h.b then
f.screen="pick"
self:effect("cancel")
elseif h.a then
self:effect("confirm")
self:openList("equipList",self:equipRows(f.target,n[f.slot]))
end
elseif i=="bookMap"then
self:tickBookMap(h)
elseif i=="status"then
local k=a.horizontalStep(h)+a.verticalStep(h)
local q=self:menuMembers(true)
if k~=0 then
f.statusIndex=a.wrap(f.statusIndex+k,#q)
f.member=f.statusIndex
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#q)
self:effect("cursor")
end
if h.b or h.a then
f.screen="pick"
self:effect("cancel")
end
elseif i=="save"then
self:tickSaveScreen(h)
elseif i=="options"then
self:tickOptionsScreen(h)
end
end

function c:openEntry(entry)
local f=self.menu
f.member=1
if entry=="MenuItems"then
self:openList("items",self:bagRows())
elseif entry=="MenuSkills"then
f.screen="main"
self:pickMember("skills")
elseif entry=="MenuEquip"then
f.screen="main"
self:pickMember("equip",true)
elseif entry=="MenuStatus"then
f.screen="main"
self:pickMember("status",true)
elseif entry=="MenuOrder"then
f.screen="main"
f.swapFrom=nil
self:pickMember("order",true)
elseif entry=="MenuBook"then
self:openList("book",self:bookRows())
elseif entry=="MenuBestiary"then
self:openList("bestiary",self:bestiaryRows())
elseif entry=="MenuBonds"then
self:openList("bonds",self:bondRows())
elseif entry=="MenuSave"then
f.screen="save"
f.slotIndex=self.slot or 1
f.confirm=nil
else
f.screen="options"
f.option=1
end
end

function c:tickPick(pressed)
local f=self.menu
local q=self:menuMembers(f.pickAll)
local v=a.verticalStep(pressed)
if v~=0 then
f.member=a.wrap(f.member+v,#q)
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#q)
self:effect("cursor")
end
if pressed.b then
self:effect("cancel")
if f.purpose=="order"and f.swapFrom then
f.swapFrom=nil
elseif f.purpose=="useItem"then
f.screen="items"
elseif f.purpose=="castOn"then
f.screen="skills"
else
f.screen="main"
end
return
end
if not pressed.a then
return
end
local i=q[f.member]
local h=f.purpose
if h=="skills"then
f.caster=i
self:effect("confirm")
self:openList("skills",self:skillRowsOf(i))
elseif h=="equip"then
f.target=i
f.slot=1
f.screen="slots"
self:effect("confirm")
elseif h=="status"then
f.statusIndex=f.member
f.screen="status"
self:effect("confirm")
elseif h=="useItem"then
local k=f.rows[f.list]
self:useItemOnMember(k.id,i)
if e.count(self.state,k.id)<=0 then
self:openList("items",self:bagRows())
end
elseif h=="castOn"then
local k=f.rows[f.list]
self:useSkillOnMember(f.caster,k.id,i)
f.rows=self:skillRowsOf(f.caster)
if f.caster.sp<j.get(k.id).cost then
f.screen="skills"
end
elseif h=="order"then
if f.member==1 then
self:effect("buzz")
elseif not f.swapFrom then
f.swapFrom=f.member
self:effect("confirm")
else
local k=self.state.order
k[f.swapFrom],k[f.member]=k[f.member],k[f.swapFrom]
f.swapFrom=nil
self.field:refreshParty()
self.field:gatherFollowers()
self:effect("confirm")
end
end
end

function c:tickMenuList(pressed)
local f=self.menu
self:stepList(pressed)
local h=f.rows[f.list]
if pressed.b then
self:effect("cancel")
if f.screen=="bestiary"or f.screen=="bonds"or f.screen=="book"then
f.screen="main"
elseif p[f.screen]then
self:openList("book",self:bookRows())
f.list=f.bookIndex
f.listTop=b.scroll(f.list,1,d.listRows,#f.rows)
elseif f.screen=="equipList"then
f.screen="slots"
elseif f.screen=="skills"then
f.member=a.indexOf(self:menuMembers(false),f.caster)or 1
self:pickMember("skills")
else
f.screen="main"
end
return
end
if not pressed.a or not h then
return
end
if f.screen=="book"then
self:openBookPart(h.id)
elseif f.screen=="bookPages"or f.screen=="bookEchoes"then
if h.found then
self:effect("confirm")
self:openText(nil,self:bookText(f.screen,h.id))
else
self:effect("buzz")
end
elseif f.screen=="items"then
local i=l.get(h.id)
if i.kind=="use"and(i.effect=="heal"or i.effect=="sp"or i.effect=="revive")then
self:effect("confirm")
self:pickMember("useItem")
else
self:effect("buzz")
end
elseif f.screen=="skills"then
if h.disabled then
self:effect("buzz")
else
self:effect("confirm")
self:pickMember("castOn")
end
elseif f.screen=="equipList"then
local i=f.target
if h.id==false then
e.unequipCharm(self.state,i)
else
e.equip(self.state,i,h.id)
end
self:effect("equip")
f.screen="slots"
end
end

function c:openBookPart(part)
local f=self.menu
f.bookIndex=f.list
self:effect("confirm")
if part=="pages"then
self:openList("bookPages",self:bookPageRows())
elseif part=="echoes"then
self:openList("bookEchoes",self:bookEchoRows())
elseif part=="quests"then
self:openList("bookQuests",self:bookQuestRows())
else
f.screen="bookMap"
end
end

function c:bookText(list,id)
if list=="bookPages"then
return a.text("Page_"..id)
end
return a.text("Echo_"..id.."_1").." "..a.text("Echo_"..id.."_2").." "..a.text("Echo_"..id.."_3")
end

function c:tickBookMap(pressed)
if pressed.b or pressed.a then
self:effect("cancel")
self:openList("book",self:bookRows())
self.menu.list=self.menu.bookIndex
end
end

function c:tickSaveScreen(pressed)
local f=self.menu
if f.confirm then
if pressed.up or pressed.down or pressed.left or pressed.right then
f.confirm=f.confirm==1 and 2 or 1
self:effect("cursor")
end
if pressed.b then
f.confirm=nil
self:effect("cancel")
elseif pressed.a then
if f.confirm==1 then
self:writeSlot(f.slotIndex)
else
self:effect("cancel")
end
f.confirm=nil
end
return
end
local i=a.verticalStep(pressed)
if i~=0 then
f.slotIndex=a.wrap(f.slotIndex+i,o.SLOTS)
self:effect("cursor")
end
if pressed.b then
f.screen="main"
self:effect("cancel")
elseif pressed.a then
local h=self.save.slots
if type(h)=="table"and h[f.slotIndex]and o.summary(h[f.slotIndex])then
f.confirm=2
self:effect("confirm")
else
self:writeSlot(f.slotIndex)
end
end
end

function c:writeSlot(slot)
self:saveJourney(slot)
self:effect("save")
self:openText(nil,a.text("Saved",slot))
self.menu.written=true
end

function c:tickOptionsScreen(pressed)
local f=self.menu
local i={"music","effects"}
local k=a.verticalStep(pressed)
if k~=0 then
f.option=a.wrap(f.option+k,#i)
self:effect("cursor")
end
local q=a.horizontalStep(pressed)
if q~=0 then
local h=i[f.option]
local v=SpiffBoy.clamp(self.mix[h]+q,0,r.MIX_STEPS)
if v~=self.mix[h]then
self.mix[h]=v
self:applyMix()
self:effect("cursor")
end
end
if pressed.b or pressed.a then
self:saveOptions()
f.screen="main"
self:effect("cancel")
end
end

local function q(screen,x,y,w,share)
b.fill(screen,x,y,w,4,a.INK)
local f=math.floor((w-2)*SpiffBoy.clamp(share,0,1))
if f>0 then
b.fill(screen,x+1,y+1,f,2,a.MID)
end
end

function c:drawMemberRow(screen,member,x,y,w,selected,marked,reserve)
local f=e.stats(member)
if selected then
b.fill(screen,x+1,y,w-2,d.rowH-1,a.MID)
end
if marked then
b.fill(screen,x+1,y,3,d.rowH-1,a.INK)
end
screen:layers(self:art("walk_"..member.id),0,12,16,x+3,y+4,t)
b.text(screen,b.fit(screen,a.text("Name_"..member.id),w-46),x+17,y-2,reserve and a.DARK or a.INK)
local h=e.worn(member,"weapon")
if h.element then
b.icon(screen,self.artUi,b.ELEMENT_ICONS[h.element],x+w-22,y+1,s)
end
screen:number(member.level,x+w-3,y+2,self.artDigits,"right",0,a.INK)
b.icon(screen,self.artUi,"heart",x+16,y+11,C)
q(screen,x+28,y+14,34,member.hp/f.hp)
b.icon(screen,self.artUi,"lampIcon",x+65,y+11,t)
q(screen,x+77,y+14,w-80,member.sp/f.sp)
local k=m.toNext(member.level)
local v=member.level>=a.LEVEL_CAP and 1 or member.xp/k
b.icon(screen,self.artUi,"xp",x+29,y+21,s)
local i=math.floor((w-41)*SpiffBoy.clamp(v,0,1))
if i>0 then
b.fill(screen,x+38,y+22,i,2,a.DARK)
end
end

function c:drawPartyPanel(screen,x,w,members,selected,marked,top)
b.frame(screen,self.artUi,x,0,w,a.HEIGHT)
for h=0,d.panelRows-1 do
local f=top+h
local i=members[f]
if i then
local k=4+h*d.rowH
self:drawMemberRow(screen,i,x+2,k,w-4,f==selected,f==marked,f>a.PARTY_SIZE)
if f==a.PARTY_SIZE and members[f+1]and h<d.panelRows-1 then
b.fill(screen,x+6,k+d.rowH-1,w-12,1,a.INK)
end
end
end
if top>1 then
b.icon(screen,self.artUi,"arrowUp",x+w-10,1,{1})
end
if top+d.panelRows-1<#members then
b.icon(screen,self.artUi,"arrowDown",x+w-10,a.HEIGHT-7,{1})
end
end

function c:drawDescription(screen,key)
b.frame(screen,self.artUi,0,d.descY,a.WIDTH,d.descH)
if key then
local f=screen:wrapText(a.text(key),a.WIDTH-12)
for h=1,math.min(2,#f)do
b.text(screen,f[h],6,d.descY+1+(h-1)*b.LINE)
end
end
end

local function v(seconds)
local f=math.floor(seconds/60)
local i=math.floor(f/60)
f=f%60
local h=tostring(f)
if f<10 then
h="0"..h
end
return i..":"..h
end
c.clockText=v

function c:drawMenu(screen)
local h=self.menu
local k=self.artUi
local x=self.state
local f=h.screen
if self.dialog and p[f]then
self:drawDialog(screen)
return
end
if f=="main"or f=="pick"then
b.frame(screen,k,d.mainX,0,d.mainW,a.HEIGHT)
local w={}
for i,y in ipairs(self:menuEntries())do
w[i]={label=b.fit(screen,a.text(y),d.mainW-16)}
end
b.list(screen,k,w,2,3,d.mainW-4,d.mainRows,h.index,h.mainTop,self.clock,f=="main")
b.icon(screen,k,"coin",4,a.HEIGHT-9,{1,3})
screen:number(x.gold,d.mainW-5,a.HEIGHT-8,self.artDigits,"right",0,a.INK)
local y=self:menuMembers(f=="pick"and h.pickAll)
local z=f=="pick"and h.member or nil
local i=1
if f=="pick"then
i=h.partyTop
end
self:drawPartyPanel(screen,d.partyX,d.partyW,y,z,h.swapFrom,i)
if f=="pick"then
b.cursor(screen,k,d.partyX-5,4+(h.member-i)*d.rowH+9,self.clock)
end
elseif f=="items"or f=="skills"or f=="equipList"or f=="bestiary"or f=="bonds"or f=="book"or p[f]then
local w=d.listRows*b.LINE+8
b.frame(screen,k,0,0,a.WIDTH,w)
b.list(screen,k,h.rows,d.listX,d.listY,d.listW,d.listRows,h.list,h.listTop,self.clock,true)
local i=h.rows[h.list]
if self.dialog then
i=nil
elseif f=="items"then
self:drawDescription(screen,i and("ItemDesc_"..i.id))
elseif f=="skills"then
self:drawDescription(screen,i and("SkillDesc_"..i.id))
b.textRight(screen,h.caster.sp.."/"..e.stats(h.caster).sp,a.WIDTH-6,d.descY+17,a.DARK)
elseif f=="bestiary"then
self:drawBestiaryEntry(screen,i.id)
elseif f=="bonds"then
self:drawBondEntry(screen,i.id)
elseif f=="book"then
self:drawDescription(screen,"BookHelp_"..i.id)
elseif f=="bookPages"then
self:drawDescription(screen,i.found and("Series_"..i.series)or"BookUnknown")
elseif f=="bookEchoes"then
self:drawDescription(screen,i.found and"EchoReplay"or"BookUnknown")
elseif f=="bookQuests"then
self:drawDescription(screen,i.progress and("QuestNote_"..i.id.."_"..i.progress)or"BookUnknown")
else
self:drawEquipCompare(screen,h.target,i and i.id)
end
elseif f=="bookMap"then
self:drawBookMap(screen)
elseif f=="slots"then
self:drawSlots(screen,h.target,h.slot)
elseif f=="status"then
self:drawStatus(screen,self:menuMembers(true)[h.statusIndex])
elseif f=="save"then
self:drawSaveScreen(screen)
elseif f=="options"then
self:drawOptionsScreen(screen)
end
if self.dialog then
self:drawDialog(screen)
end
end

local D={save=true,options=true}

function c:menuCoversScreen()
return not D[self.menu.screen]or self.dialog~=nil
end

function c:drawBookMap(screen)
local z=self.artUi
b.frame(screen,z,0,0,a.WIDTH,a.HEIGHT)
b.textCentre(screen,a.text("BookMap"),a.WIDTH/2,2)
b.fill(screen,g.x-1,g.y-1,g.w+2,g.h+2,a.DARK)
b.fill(screen,g.x,g.y,g.w,g.h,a.MID)
local k=a.Field.prepare(a.Maps.murksea)
local A=a.Field.wholeIslets(k,self.state)
local w=self:art("minimap")
local E=e.hasFlag(self.state,"q_carto")
for H,f in ipairs(a.MurkSea.islets)do
local h,i=math.floor(f.x/g.step),math.floor(f.y/g.step)
local x=math.floor((f.x+f.w-1)/g.step)-h+1
local y=math.floor((f.y+f.h-1)/g.step)-i+1
if A[f.id]then
for F,G in ipairs(g.shades)do
screen:sheet(w,h,(F-1)*g.h+i,x,y,g.x+h,g.y+i,1,G)
end
elseif E then
screen:sheet(w,h,(g.outline-1)*g.h+i,x,y,g.x+h,g.y+i,1,a.DARK)
end
end
for x,f in ipairs(k.objects)do
if f.kind=="watchlight"and e.hasFlag(self.state,f.flag)then
local h,i=g.x+math.floor((f.x+f.door)/g.step),g.y+math.floor((f.y+1)/g.step)
b.fill(screen,h-2,i,5,1,a.INK)
b.fill(screen,h,i-2,1,5,a.INK)
end
end
if self.field.id=="murksea"and math.floor(self.clock/15)%2==0 then
local f=self.field.player
b.fill(screen,g.x+math.floor(f.x/g.step)-1,g.y+math.floor(f.y/g.step)-1,3,3,a.INK)
end
b.textCentre(screen,a.text("BookMapHint"),a.WIDTH/2,g.y+g.h+2,a.DARK)
end

function c:drawPairLines(screen,lines)
b.frame(screen,self.artUi,0,d.descY,a.WIDTH,d.descH)
for i,f in ipairs(lines)do
local h=d.descY+1+(i-1)*b.LINE
if f[1]then
b.text(screen,b.fit(screen,f[1],a.WIDTH-12),6,h)
end
if f[2]then
b.textRight(screen,f[2],a.WIDTH-6,h,a.DARK)
end
end
end

function c:drawBestiaryEntry(screen,enemyId)
local h=self.state
if not h.known[enemyId]then
local f=0
for k,i in ipairs(a.Enemies.ORDER)do
if h.seen[i]then
f=f+1
end
end
self:drawPairLines(screen,{{a.text("BestiaryCount",f,#a.Enemies.ORDER)}})
return
end
local f=a.Enemies.get(enemyId,e.enemyBonus(h))
local i=f.weak and a.text("Weak_"..f.weak)
local k=f.resist and a.text("Resist_"..f.resist)
local w=f.drop and a.text("BestiaryDrop",a.text("Item_"..f.drop[1]))
self:drawPairLines(screen,{{a.text("Level").." "..f.level,i},{w,k}})
b.icon(screen,self.artUi,"heart",44,d.descY+6,{1,3})
screen:number(f.hp,76,d.descY+6,self.artDigits,"right",0,a.INK)
end

function c:drawBondEntry(screen,duoId)
if e.duoReady(self.state,duoId)then
self:drawDescription(screen,"SkillDesc_"..duoId)
return
end
self:drawPairLines(screen,{{a.text("BondLocked",e.bond(self.state,duoId),j.BOND_NEEDED)}})
end

function c:drawEquipCompare(screen,member,itemId)
b.frame(screen,self.artUi,0,d.descY,a.WIDTH,d.descH)
local i=e.stats(member)
local h=i
if itemId then
h=e.statsWith(member,itemId)
elseif itemId==false then
local f={id=member.id,level=member.level,equip={weapon=member.equip.weapon,armor=member.equip.armor}}
h=e.stats(f)
end
for w,f in ipairs(u)do
local k=6+(w-1)*35
b.text(screen,a.text("Stat_"..f),k,d.descY+1,a.DARK)
local x=a.INK
if h[f]~=i[f]then
b.icon(screen,self.artUi,h[f]>i[f]and"arrowUp"or"arrowDown",k+24,d.descY+20,{1})
end
screen:number(h[f],k+22,d.descY+21,self.artDigits,"right",0,x)
end
end

function c:drawSlots(screen,member,slotIndex)
local h=self.artUi
b.frame(screen,h,0,0,a.WIDTH,58)
local i={}
for x,k in ipairs(n)do
local w=member.equip[k]
local f=a.text("Slot_"..k)..": "
if w then
f=f..a.text("Item_"..w)
else
f=f.."-"
end
i[x]={label=b.fit(screen,f,a.WIDTH-20)}
end
b.list(screen,h,i,2,4,a.WIDTH-4,3,slotIndex,1,self.clock,true)
for w,x in ipairs(n)do
local f=e.worn(member,x)
local k=f and b.gearIcon(f)
if k then
b.icon(screen,h,k,a.WIDTH-13,8+(w-1)*b.LINE,{1,2,3,4})
end
end
self:drawEquipCompare(screen,member,nil)
b.frame(screen,h,0,58,a.WIDTH,28)
b.text(screen,a.text("Name_"..member.id).." - "..a.text("Class_"..m.BY_ID[member.id].class),6,63)
end

function c:drawStatus(screen,member)
local f=self.artUi
local y=m.BY_ID[member.id]
local i=e.stats(member)
b.frame(screen,f,0,0,a.WIDTH,a.HEIGHT)
self:drawRegion(screen,self:art("walk_"..member.id),0,0,12,16,16,6,5,{1,2,3,4},0)
b.text(screen,a.text("Name_"..member.id),22,2)
b.text(screen,a.text("Class_"..y.class),22,17,a.DARK)
b.textRight(screen,a.text("Level").." "..member.level,a.WIDTH-6,2)
local w=m.toNext(member.level)-member.xp
if member.level>=a.LEVEL_CAP then
w=0
end
b.textRight(screen,a.text("Next").." "..w,a.WIDTH-6,17,a.DARK)
b.icon(screen,f,"heart",6,37,{1,3})
b.text(screen,member.hp.."/"..i.hp,18,32)
b.icon(screen,f,"lampIcon",92,37,{1,2,3,4})
b.text(screen,member.sp.."/"..i.sp,104,32)
for z,h in ipairs(u)do
local k=6+(z-1)*35
local x=a.text("Stat_"..h)
b.text(screen,x,k,46,a.DARK)
screen:number(i[h],k+math.floor(screen:textWidth(x)/2),63,self.artDigits,"centre",0,a.INK)
end
for k,z in ipairs(n)do
local h=member.equip[z]
local A=h and a.text("Item_"..h)or"-"
b.text(screen,b.fit(screen,A,a.WIDTH-24),6,70+(k-1)*15,k%2==0 and a.DARK or a.INK)
local x=h and b.gearIcon(l.get(h))
if x then
b.icon(screen,f,x,a.WIDTH-16,74+(k-1)*15,{1,2,3,4})
end
end
b.icon(screen,f,"arrowLeft",2,a.HEIGHT-10,{1})
b.icon(screen,f,"arrowRight",a.WIDTH-9,a.HEIGHT-10,{1})
end

function c:drawSlotList(screen,selected,focused,header)
local w=self.artUi
b.frame(screen,w,0,0,a.WIDTH,a.HEIGHT)
local k=self.save.slots
local x,y,z=4,38,36
if header then
x,y,z=20,33,31
b.textCentre(screen,b.fit(screen,a.text(header),a.WIDTH-12),a.WIDTH/2,1)
end
for h=1,o.SLOTS do
local f=x+(h-1)*y
if h==selected then
b.fill(screen,8,f,a.WIDTH-12,z,a.MID)
if focused then
b.cursor(screen,w,2,f+11,self.clock)
end
end
b.text(screen,a.text("Slot",h),12,f)
local i=type(k)=="table"and k[h]and o.summary(k[h])
if i then
local A=a.text("Map_"..a.Maps[i.map].place)
if i.cleared then
A=a.text("SlotCleared")
end
b.textRight(screen,v(i.time),a.WIDTH-6,f)
b.text(screen,b.fit(screen,A,110),12,f+15,a.DARK)
b.textRight(screen,a.text("Level").." "..i.level,a.WIDTH-6,f+15,a.DARK)
else
b.text(screen,a.text("EmptySlot"),12,f+15,a.DARK)
end
end
end

function c:drawSaveScreen(screen)
local f=self.menu
self:drawSlotList(screen,f.slotIndex,not f.confirm)
if f.confirm then
local w={{label=a.text("Yes")},{label=a.text("No")}}
local i=a.text("Overwrite")
local h=math.max(screen:textWidth(i)+12,70)
local k=(a.WIDTH-h)/2
b.frame(screen,self.artUi,k,30,h,58)
b.textCentre(screen,i,a.WIDTH/2,33)
b.list(screen,self.artUi,w,k+4,52,h-8,2,f.confirm,1,self.clock,true)
end
end

function c:drawOptionsScreen(screen)
local x=self.menu
local h=self.artUi
b.frame(screen,h,0,20,a.WIDTH,70)
local y={"music","effects"}
for i,k in ipairs(y)do
local f=28+(i-1)*28
if i==x.option then
b.cursor(screen,h,4,f+4,self.clock)
end
b.text(screen,a.text(k=="music"and"Music"or"Effects"),14,f)
for w=1,r.MIX_STEPS do
local z=w<=self.mix[k]and a.INK or a.MID
b.fill(screen,96+(w-1)*8,f+4,6,8,z)
end
end
end
