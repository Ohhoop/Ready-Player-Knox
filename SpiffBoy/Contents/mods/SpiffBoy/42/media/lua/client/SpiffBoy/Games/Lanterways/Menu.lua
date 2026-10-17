require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local c=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local b=a.Window
local e=a.Party
local m=a.Items
local k=a.Skills
local n=a.Characters
local p=a.SaveGame
local t=a.Music

local D={"MenuItems","MenuSkills","MenuEquip","MenuStatus","MenuOrder","MenuBook","MenuBestiary","MenuBonds","MenuSave","MenuOptions"}
local q={bookPages=true,bookEchoes=true,bookQuests=true}
local g={x=52,y=30,w=75,h=54,step=2,shades={1,2,4},outline=4}
local u={1}
local E={1,3}
local v={1,2,3}
local d={
mainX=0,mainW=74,partyX=74,partyW=106,rowH=26,listX=2,listY=4,listW=176,listRows=5,
descY=86,descH=34,statX=6,statY=22,slotY=4,mainRows=6,panelRows=4,
}
local w={"atk","def","mag","res","spd"}
local o={"weapon","armor","charm"}

function c:menuEntries()
local f={}
for i,h in ipairs(D)do
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

function c:pickMember(h,i)
local f=self.menu
f.pickFrom=f.screen
f.screen="pick"
f.purpose=h
f.pickAll=i
if h=="useItem"or h=="castOn"or not f.member then
f.member=1
end
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#self:menuMembers(i))
end

function c:menuMembers(h)
if h then
local f={}
for j,i in ipairs(self.state.order)do
f[#f+1]=self.state.members[i]
end
return f
end
return e.active(self.state)
end

function c:useItemOnMember(r,j)
local f=m.get(r)
local x=e.stats(j)
local h=false
local l={j}
if f.target=="allies"then
l=e.active(self.state)
end
if f.effect=="heal"then
for y,i in ipairs(l)do
local s=e.stats(i).hp
if i.hp>0 and i.hp<s then
i.hp=math.min(s,i.hp+f.power)
h=true
end
end
elseif f.effect=="sp"then
for y,i in ipairs(l)do
local s=e.stats(i).sp
if i.hp>0 and i.sp<s then
i.sp=math.min(s,i.sp+f.power)
h=true
end
end
elseif f.effect=="revive"and j.hp<=0 then
j.hp=math.max(1,math.floor(x.hp*f.power))
h=true
end
if h then
e.takeItem(self.state,r,1)
self:effect("heal")
else
self:effect("buzz")
end
return h
end

function c:useSkillOnMember(i,s,x)
local f=k.get(s)
if i.sp<f.cost or i.hp<=0 then
self:effect("buzz")
return false
end
local y=e.stats(i).mag
local r={x}
if f.target=="allies"then
r=e.active(self.state)
end
local j=false
for z,h in ipairs(r)do
local l=e.stats(h).hp
if f.kind=="heal"and h.hp>0 and h.hp<l then
h.hp=math.min(l,h.hp+math.floor(f.power+y*0.8))
j=true
elseif f.kind=="revive"and h.hp<=0 then
h.hp=math.max(1,math.floor(l*f.power))
j=true
end
end
if j then
i.sp=i.sp-f.cost
self:effect("heal")
else
self:effect("buzz")
end
return j
end

function c:bagRows()
local h={}
for l,f in ipairs(e.bagList(self.state))do
local j=m.get(f)
local i="x"..e.count(self.state,f)
if j.kind=="key"then
i=nil
end
h[#h+1]={id=f,label=a.text("Item_"..f),right=i}
end
return h
end

function c:skillRowsOf(j)
local f={}
for l,h in ipairs(e.skills(self.state,j))do
local i=k.get(h)
f[#f+1]={id=h,label=a.text("Skill_"..h),right=tostring(i.cost),disabled=not k.usableInField(i)or i.cost>j.sp}
end
return f
end

function c:bestiaryRows()
local h={}
local i=self.state
for l,f in ipairs(a.Enemies.ORDER)do
local j={id=f,label="???"}
if i.seen[f]then
j.label=a.text("Enemy_"..f)
end
if i.known[f]then
j.right=a.text("Level").." "..a.Enemies.get(f,e.enemyBonus(i)).level
end
h[#h+1]=j
end
return h
end

function c:bondRows()
local h={}
for l,f in ipairs(k.DUOS)do
local j=k.get(f).duo
local i={id=f,label=a.text("Name_"..j[1]).." + "..a.text("Name_"..j[2]),right=e.bond(self.state,f).."/"..k.BOND_NEEDED}
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
local l,h=a.Lore.pages(),0
for j,i in ipairs(l)do
if e.hasFlag(f,"p_"..i.id)then
h=h+1
end
end
local i=0
for r,j in ipairs(a.Lore.ECHOES)do
if e.hasFlag(f,"e_"..j)then
i=i+1
end
end
local j=0
for s,r in ipairs(a.Lore.QUESTS)do
if e.hasFlag(f,r.done)then
j=j+1
end
end
return{
{id="pages",label=a.text("BookPages"),right=h.."/"..#l},
{id="echoes",label=a.text("BookEchoes"),right=i.."/"..#a.Lore.ECHOES},
{id="quests",label=a.text("BookQuests"),right=j.."/"..#a.Lore.QUESTS},
{id="map",label=a.text("BookMap")},
}
end

function c:bookPageRows()
local h={}
for j,f in ipairs(a.Lore.pages())do
local i=e.hasFlag(self.state,"p_"..f.id)
h[#h+1]={id=f.id,series=f.series,found=i,label=i and a.text("PageTitle_"..f.id)or"???"}
end
return h
end

function c:bookEchoRows()
local f={}
for j,h in ipairs(a.Lore.ECHOES)do
local i=e.hasFlag(self.state,"e_"..h)
f[#f+1]={id=h,found=i,label=i and a.text("EchoTitle_"..h)or"???"}
end
return f
end

function c:questState(f)
if e.hasFlag(self.state,f.done)then
return"done"
elseif e.hasFlag(self.state,f.started)then
return"started"
end
return nil
end

function c:bookQuestRows()
local f={}
for l,h in ipairs(a.Lore.QUESTS)do
local i=self:questState(h)
local j={id=h.id,progress=i,label="???"}
if i then
j.label=a.text("QuestTitle_"..h.id)
j.right=a.text("Quest_"..i)
end
f[#f+1]=j
end
return f
end

function c:equipRows(i,j)
local f={}
local l=n.BY_ID[i.id]
if j=="charm"and i.equip.charm then
f[#f+1]={id=false,label=a.text("Remove")}
end
for r,h in ipairs(e.bagList(self.state,function(h)return h.kind==j and m.fits(l,h)end))do
f[#f+1]={id=h,label=a.text("Item_"..h),right="x"..e.count(self.state,h)}
end
return f
end

function c:openList(h,i)
local f=self.menu
f.screen=h
f.rows=i
f.list=1
f.listTop=1
end

function c:stepList(i)
local f=self.menu
local h=a.verticalStep(i)
if h~=0 and#f.rows>0 then
f.list=a.wrap(f.list+h,#f.rows)
f.listTop=b.scroll(f.list,f.listTop,d.listRows,#f.rows)
self:effect("cursor")
end
end

function c:tickMenu(j)
if self.dialog then
self:tickDialog(j)
return
end
if not j then
return
end
local f=self.menu
if f.finishing and(f.written or f.screen=="main")then
self:openTitle()
return
end
local h=j.pressed
local i=f.screen
if i=="main"then
local l=a.verticalStep(h)
if l~=0 then
local r=self:menuEntries()
f.index=a.wrap(f.index+l,#r)
f.mainTop=b.scroll(f.index,f.mainTop,d.mainRows,#r)
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
elseif i=="items"or i=="skills"or i=="equipList"or i=="bestiary"or i=="bonds"or i=="book"or q[i]then
self:tickMenuList(h)
elseif i=="slots"then
local l=a.verticalStep(h)
if l~=0 then
f.slot=a.wrap(f.slot+l,#o)
self:effect("cursor")
end
if h.b then
f.screen="pick"
self:effect("cancel")
elseif h.a then
self:effect("confirm")
self:openList("equipList",self:equipRows(f.target,o[f.slot]))
end
elseif i=="bookMap"then
self:tickBookMap(h)
elseif i=="status"then
local l=a.horizontalStep(h)+a.verticalStep(h)
local r=self:menuMembers(true)
if l~=0 then
f.statusIndex=a.wrap(f.statusIndex+l,#r)
f.member=f.statusIndex
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#r)
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

function c:openEntry(h)
local f=self.menu
f.member=1
if h=="MenuItems"then
self:openList("items",self:bagRows())
elseif h=="MenuSkills"then
f.screen="main"
self:pickMember("skills")
elseif h=="MenuEquip"then
f.screen="main"
self:pickMember("equip",true)
elseif h=="MenuStatus"then
f.screen="main"
self:pickMember("status",true)
elseif h=="MenuOrder"then
f.screen="main"
f.swapFrom=nil
self:pickMember("order",true)
elseif h=="MenuBook"then
self:openList("book",self:bookRows())
elseif h=="MenuBestiary"then
self:openList("bestiary",self:bestiaryRows())
elseif h=="MenuBonds"then
self:openList("bonds",self:bondRows())
elseif h=="MenuSave"then
f.screen="save"
f.slotIndex=self.slot or 1
f.confirm=nil
else
f.screen="options"
f.option=1
end
end

function c:tickPick(l)
local f=self.menu
local r=self:menuMembers(f.pickAll)
local s=a.verticalStep(l)
if s~=0 then
f.member=a.wrap(f.member+s,#r)
f.partyTop=b.scroll(f.member,f.partyTop,d.panelRows,#r)
self:effect("cursor")
end
if l.b then
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
if not l.a then
return
end
local i=r[f.member]
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
local j=f.rows[f.list]
self:useItemOnMember(j.id,i)
if e.count(self.state,j.id)<=0 then
self:openList("items",self:bagRows())
end
elseif h=="castOn"then
local j=f.rows[f.list]
self:useSkillOnMember(f.caster,j.id,i)
f.rows=self:skillRowsOf(f.caster)
if f.caster.sp<k.get(j.id).cost then
f.screen="skills"
end
elseif h=="order"then
if f.member==1 then
self:effect("buzz")
elseif not f.swapFrom then
f.swapFrom=f.member
self:effect("confirm")
else
local j=self.state.order
j[f.swapFrom],j[f.member]=j[f.member],j[f.swapFrom]
f.swapFrom=nil
self.field:refreshParty()
self.field:gatherFollowers()
self:effect("confirm")
end
end
end

function c:tickMenuList(j)
local f=self.menu
self:stepList(j)
local h=f.rows[f.list]
if j.b then
self:effect("cancel")
if f.screen=="bestiary"or f.screen=="bonds"or f.screen=="book"then
f.screen="main"
elseif q[f.screen]then
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
if not j.a or not h then
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
local i=m.get(h.id)
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

function c:openBookPart(f)
local h=self.menu
h.bookIndex=h.list
self:effect("confirm")
if f=="pages"then
self:openList("bookPages",self:bookPageRows())
elseif f=="echoes"then
self:openList("bookEchoes",self:bookEchoRows())
elseif f=="quests"then
self:openList("bookQuests",self:bookQuestRows())
else
h.screen="bookMap"
end
end

function c:bookText(h,f)
if h=="bookPages"then
return a.text("Page_"..f)
end
return a.text("Echo_"..f.."_1").." "..a.text("Echo_"..f.."_2").." "..a.text("Echo_"..f.."_3")
end

function c:tickBookMap(f)
if f.b or f.a then
self:effect("cancel")
self:openList("book",self:bookRows())
self.menu.list=self.menu.bookIndex
end
end

function c:tickSaveScreen(h)
local f=self.menu
if f.confirm then
if h.up or h.down or h.left or h.right then
f.confirm=f.confirm==1 and 2 or 1
self:effect("cursor")
end
if h.b then
f.confirm=nil
self:effect("cancel")
elseif h.a then
if f.confirm==1 then
self:writeSlot(f.slotIndex)
else
self:effect("cancel")
end
f.confirm=nil
end
return
end
local j=a.verticalStep(h)
if j~=0 then
f.slotIndex=a.wrap(f.slotIndex+j,p.SLOTS)
self:effect("cursor")
end
if h.b then
f.screen="main"
self:effect("cancel")
elseif h.a then
local i=self.save.slots
if type(i)=="table"and i[f.slotIndex]and p.summary(i[f.slotIndex])then
f.confirm=2
self:effect("confirm")
else
self:writeSlot(f.slotIndex)
end
end
end

function c:writeSlot(f)
self:saveJourney(f)
self:effect("save")
self:openText(nil,a.text("Saved",f))
self.menu.written=true
end

function c:tickOptionsScreen(f)
local h=self.menu
local j={"music","effects"}
local l=a.verticalStep(f)
if l~=0 then
h.option=a.wrap(h.option+l,#j)
self:effect("cursor")
end
local r=a.horizontalStep(f)
if r~=0 then
local i=j[h.option]
local s=SpiffBoy.clamp(self.mix[i]+r,0,t.MIX_STEPS)
if s~=self.mix[i]then
self.mix[i]=s
self:applyMix()
self:effect("cursor")
end
end
if f.b or f.a then
self:saveOptions()
h.screen="main"
self:effect("cancel")
end
end

local function x(f,h,i,j,r)
b.fill(f,h,i,j,4,a.INK)
local l=math.floor((j-2)*SpiffBoy.clamp(r,0,1))
if l>0 then
b.fill(f,h+1,i+1,l,2,a.MID)
end
end

function c:drawMemberRow(f,j,h,i,l,z,A,B)
local r=e.stats(j)
if z then
b.fill(f,h+1,i,l-2,d.rowH-1,a.MID)
end
if A then
b.fill(f,h+1,i,3,d.rowH-1,a.INK)
end
f:layers(self:art("walk_"..j.id),0,12,16,h+3,i+4,v)
b.text(f,b.fit(f,a.text("Name_"..j.id),l-46),h+17,i-2,B and a.DARK or a.INK)
local s=e.worn(j,"weapon")
if s.element then
b.icon(f,self.artUi,b.ELEMENT_ICONS[s.element],h+l-22,i+1,u)
end
f:number(j.level,h+l-3,i+2,self.artDigits,"right",0,a.INK)
b.icon(f,self.artUi,"heart",h+16,i+11,E)
x(f,h+28,i+14,34,j.hp/r.hp)
b.icon(f,self.artUi,"lampIcon",h+65,i+11,v)
x(f,h+77,i+14,l-80,j.sp/r.sp)
local C=n.toNext(j.level)
local F=j.level>=a.LEVEL_CAP and 1 or j.xp/C
b.icon(f,self.artUi,"xp",h+29,i+21,u)
local y=math.floor((l-41)*SpiffBoy.clamp(F,0,1))
if y>0 then
b.fill(f,h+38,i+22,y,2,a.DARK)
end
end

function c:drawPartyPanel(h,i,j,l,A,B,r)
b.frame(h,self.artUi,i,0,j,a.HEIGHT)
for s=0,d.panelRows-1 do
local f=r+s
local y=l[f]
if y then
local z=4+s*d.rowH
self:drawMemberRow(h,y,i+2,z,j-4,f==A,f==B,f>a.PARTY_SIZE)
if f==a.PARTY_SIZE and l[f+1]and s<d.panelRows-1 then
b.fill(h,i+6,z+d.rowH-1,j-12,1,a.INK)
end
end
end
if r>1 then
b.icon(h,self.artUi,"arrowUp",i+j-10,1,{1})
end
if r+d.panelRows-1<#l then
b.icon(h,self.artUi,"arrowDown",i+j-10,a.HEIGHT-7,{1})
end
end

function c:drawDescription(f,h)
b.frame(f,self.artUi,0,d.descY,a.WIDTH,d.descH)
if h then
local i=f:wrapText(a.text(h),a.WIDTH-12)
for j=1,math.min(2,#i)do
b.text(f,i[j],6,d.descY+1+(j-1)*b.LINE)
end
end
end

local function y(i)
local f=math.floor(i/60)
local j=math.floor(f/60)
f=f%60
local h=tostring(f)
if f<10 then
h="0"..h
end
return j..":"..h
end
c.clockText=y

function c:drawMenu(h)
local i=self.menu
local l=self.artUi
local s=self.state
local f=i.screen
if self.dialog and q[f]then
self:drawDialog(h)
return
end
if f=="main"or f=="pick"then
b.frame(h,l,d.mainX,0,d.mainW,a.HEIGHT)
local r={}
for j,z in ipairs(self:menuEntries())do
r[j]={label=b.fit(h,a.text(z),d.mainW-16)}
end
b.list(h,l,r,2,3,d.mainW-4,d.mainRows,i.index,i.mainTop,self.clock,f=="main")
b.icon(h,l,"coin",4,a.HEIGHT-9,{1,3})
h:number(s.gold,d.mainW-5,a.HEIGHT-8,self.artDigits,"right",0,a.INK)
local z=self:menuMembers(f=="pick"and i.pickAll)
local A=f=="pick"and i.member or nil
local j=1
if f=="pick"then
j=i.partyTop
end
self:drawPartyPanel(h,d.partyX,d.partyW,z,A,i.swapFrom,j)
if f=="pick"then
b.cursor(h,l,d.partyX-5,4+(i.member-j)*d.rowH+9,self.clock)
end
elseif f=="items"or f=="skills"or f=="equipList"or f=="bestiary"or f=="bonds"or f=="book"or q[f]then
local r=d.listRows*b.LINE+8
b.frame(h,l,0,0,a.WIDTH,r)
b.list(h,l,i.rows,d.listX,d.listY,d.listW,d.listRows,i.list,i.listTop,self.clock,true)
local j=i.rows[i.list]
if self.dialog then
j=nil
elseif f=="items"then
self:drawDescription(h,j and("ItemDesc_"..j.id))
elseif f=="skills"then
self:drawDescription(h,j and("SkillDesc_"..j.id))
b.textRight(h,i.caster.sp.."/"..e.stats(i.caster).sp,a.WIDTH-6,d.descY+17,a.DARK)
elseif f=="bestiary"then
self:drawBestiaryEntry(h,j.id)
elseif f=="bonds"then
self:drawBondEntry(h,j.id)
elseif f=="book"then
self:drawDescription(h,"BookHelp_"..j.id)
elseif f=="bookPages"then
self:drawDescription(h,j.found and("Series_"..j.series)or"BookUnknown")
elseif f=="bookEchoes"then
self:drawDescription(h,j.found and"EchoReplay"or"BookUnknown")
elseif f=="bookQuests"then
self:drawDescription(h,j.progress and("QuestNote_"..j.id.."_"..j.progress)or"BookUnknown")
else
self:drawEquipCompare(h,i.target,j and j.id)
end
elseif f=="bookMap"then
self:drawBookMap(h)
elseif f=="slots"then
self:drawSlots(h,i.target,i.slot)
elseif f=="status"then
self:drawStatus(h,self:menuMembers(true)[i.statusIndex])
elseif f=="save"then
self:drawSaveScreen(h)
elseif f=="options"then
self:drawOptionsScreen(h)
end
if self.dialog then
self:drawDialog(h)
end
end

local F={save=true,options=true}

function c:menuCoversScreen()
return not F[self.menu.screen]or self.dialog~=nil
end

function c:drawBookMap(f)
local A=self.artUi
b.frame(f,A,0,0,a.WIDTH,a.HEIGHT)
b.textCentre(f,a.text("BookMap"),a.WIDTH/2,2)
b.fill(f,g.x-1,g.y-1,g.w+2,g.h+2,a.DARK)
b.fill(f,g.x,g.y,g.w,g.h,a.MID)
local l=a.Field.prepare(a.Maps.murksea)
local B=a.Field.wholeIslets(l,self.state)
local r=self:art("minimap")
local C=e.hasFlag(self.state,"q_carto")
for I,h in ipairs(a.MurkSea.islets)do
local i,j=math.floor(h.x/g.step),math.floor(h.y/g.step)
local s=math.floor((h.x+h.w-1)/g.step)-i+1
local z=math.floor((h.y+h.h-1)/g.step)-j+1
if B[h.id]then
for G,H in ipairs(g.shades)do
f:sheet(r,i,(G-1)*g.h+j,s,z,g.x+i,g.y+j,1,H)
end
elseif C then
f:sheet(r,i,(g.outline-1)*g.h+j,s,z,g.x+i,g.y+j,1,a.DARK)
end
end
for s,h in ipairs(l.objects)do
if h.kind=="watchlight"and e.hasFlag(self.state,h.flag)then
local i,j=g.x+math.floor((h.x+h.door)/g.step),g.y+math.floor((h.y+1)/g.step)
b.fill(f,i-2,j,5,1,a.INK)
b.fill(f,i,j-2,1,5,a.INK)
end
end
if self.field.id=="murksea"and math.floor(self.clock/15)%2==0 then
local h=self.field.player
b.fill(f,g.x+math.floor(h.x/g.step)-1,g.y+math.floor(h.y/g.step)-1,3,3,a.INK)
end
b.textCentre(f,a.text("BookMapHint"),a.WIDTH/2,g.y+g.h+2,a.DARK)
end

function c:drawPairLines(f,j)
b.frame(f,self.artUi,0,d.descY,a.WIDTH,d.descH)
for l,h in ipairs(j)do
local i=d.descY+1+(l-1)*b.LINE
if h[1]then
b.text(f,b.fit(f,h[1],a.WIDTH-12),6,i)
end
if h[2]then
b.textRight(f,h[2],a.WIDTH-6,i,a.DARK)
end
end
end

function c:drawBestiaryEntry(h,j)
local i=self.state
if not i.known[j]then
local f=0
for r,l in ipairs(a.Enemies.ORDER)do
if i.seen[l]then
f=f+1
end
end
self:drawPairLines(h,{{a.text("BestiaryCount",f,#a.Enemies.ORDER)}})
return
end
local f=a.Enemies.get(j,e.enemyBonus(i))
local l=f.weak and a.text("Weak_"..f.weak)
local r=f.resist and a.text("Resist_"..f.resist)
local s=f.drop and a.text("BestiaryDrop",a.text("Item_"..f.drop[1]))
self:drawPairLines(h,{{a.text("Level").." "..f.level,l},{s,r}})
b.icon(h,self.artUi,"heart",44,d.descY+6,{1,3})
h:number(f.hp,76,d.descY+6,self.artDigits,"right",0,a.INK)
end

function c:drawBondEntry(h,f)
if e.duoReady(self.state,f)then
self:drawDescription(h,"SkillDesc_"..f)
return
end
self:drawPairLines(h,{{a.text("BondLocked",e.bond(self.state,f),k.BOND_NEEDED)}})
end

function c:drawEquipCompare(j,f,l)
b.frame(j,self.artUi,0,d.descY,a.WIDTH,d.descH)
local r=e.stats(f)
local i=r
if l then
i=e.statsWith(f,l)
elseif l==false then
local h={id=f.id,level=f.level,equip={weapon=f.equip.weapon,armor=f.equip.armor}}
i=e.stats(h)
end
for z,h in ipairs(w)do
local s=6+(z-1)*35
b.text(j,a.text("Stat_"..h),s,d.descY+1,a.DARK)
local A=a.INK
if i[h]~=r[h]then
b.icon(j,self.artUi,i[h]>r[h]and"arrowUp"or"arrowDown",s+24,d.descY+20,{1})
end
j:number(i[h],s+22,d.descY+21,self.artDigits,"right",0,A)
end
end

function c:drawSlots(f,h,z)
local j=self.artUi
b.frame(f,j,0,0,a.WIDTH,58)
local l={}
for A,r in ipairs(o)do
local s=h.equip[r]
local i=a.text("Slot_"..r)..": "
if s then
i=i..a.text("Item_"..s)
else
i=i.."-"
end
l[A]={label=b.fit(f,i,a.WIDTH-20)}
end
b.list(f,j,l,2,4,a.WIDTH-4,3,z,1,self.clock,true)
for s,A in ipairs(o)do
local i=e.worn(h,A)
local r=i and b.gearIcon(i)
if r then
b.icon(f,j,r,a.WIDTH-13,8+(s-1)*b.LINE,{1,2,3,4})
end
end
self:drawEquipCompare(f,h,nil)
b.frame(f,j,0,58,a.WIDTH,28)
b.text(f,a.text("Name_"..h.id).." - "..a.text("Class_"..n.BY_ID[h.id].class),6,63)
end

function c:drawStatus(f,h)
local i=self.artUi
local A=n.BY_ID[h.id]
local l=e.stats(h)
b.frame(f,i,0,0,a.WIDTH,a.HEIGHT)
self:drawRegion(f,self:art("walk_"..h.id),0,0,12,16,16,6,5,{1,2,3,4},0)
b.text(f,a.text("Name_"..h.id),22,2)
b.text(f,a.text("Class_"..A.class),22,17,a.DARK)
b.textRight(f,a.text("Level").." "..h.level,a.WIDTH-6,2)
local s=n.toNext(h.level)-h.xp
if h.level>=a.LEVEL_CAP then
s=0
end
b.textRight(f,a.text("Next").." "..s,a.WIDTH-6,17,a.DARK)
b.icon(f,i,"heart",6,37,{1,3})
b.text(f,h.hp.."/"..l.hp,18,32)
b.icon(f,i,"lampIcon",92,37,{1,2,3,4})
b.text(f,h.sp.."/"..l.sp,104,32)
for B,j in ipairs(w)do
local r=6+(B-1)*35
local z=a.text("Stat_"..j)
b.text(f,z,r,46,a.DARK)
f:number(l[j],r+math.floor(f:textWidth(z)/2),63,self.artDigits,"centre",0,a.INK)
end
for r,B in ipairs(o)do
local j=h.equip[B]
local C=j and a.text("Item_"..j)or"-"
b.text(f,b.fit(f,C,a.WIDTH-24),6,70+(r-1)*15,r%2==0 and a.DARK or a.INK)
local z=j and b.gearIcon(m.get(j))
if z then
b.icon(f,i,z,a.WIDTH-16,74+(r-1)*15,{1,2,3,4})
end
end
b.icon(f,i,"arrowLeft",2,a.HEIGHT-10,{1})
b.icon(f,i,"arrowRight",a.WIDTH-9,a.HEIGHT-10,{1})
end

function c:drawSlotList(f,G,H,r)
local s=self.artUi
b.frame(f,s,0,0,a.WIDTH,a.HEIGHT)
local l=self.save.slots
local z,A,B=4,38,36
if r then
z,A,B=20,33,31
b.textCentre(f,b.fit(f,a.text(r),a.WIDTH-12),a.WIDTH/2,1)
end
for i=1,p.SLOTS do
local h=z+(i-1)*A
if i==G then
b.fill(f,8,h,a.WIDTH-12,B,a.MID)
if H then
b.cursor(f,s,2,h+11,self.clock)
end
end
b.text(f,a.text("Slot",i),12,h)
local j=type(l)=="table"and l[i]and p.summary(l[i])
if j then
local C=a.text("Map_"..a.Maps[j.map].place)
if j.cleared then
C=a.text("SlotCleared")
end
b.textRight(f,y(j.time),a.WIDTH-6,h)
b.text(f,b.fit(f,C,110),12,h+15,a.DARK)
b.textRight(f,a.text("Level").." "..j.level,a.WIDTH-6,h+15,a.DARK)
else
b.text(f,a.text("EmptySlot"),12,h+15,a.DARK)
end
end
end

function c:drawSaveScreen(f)
local h=self.menu
self:drawSlotList(f,h.slotIndex,not h.confirm)
if h.confirm then
local r={{label=a.text("Yes")},{label=a.text("No")}}
local j=a.text("Overwrite")
local i=math.max(f:textWidth(j)+12,70)
local l=(a.WIDTH-i)/2
b.frame(f,self.artUi,l,30,i,58)
b.textCentre(f,j,a.WIDTH/2,33)
b.list(f,self.artUi,r,l+4,52,i-8,2,h.confirm,1,self.clock,true)
end
end

function c:drawOptionsScreen(f)
local s=self.menu
local i=self.artUi
b.frame(f,i,0,20,a.WIDTH,70)
local z={"music","effects"}
for j,l in ipairs(z)do
local h=28+(j-1)*28
if j==s.option then
b.cursor(f,i,4,h+4,self.clock)
end
b.text(f,a.text(l=="music"and"Music"or"Effects"),14,h)
for r=1,t.MIX_STEPS do
local A=r<=self.mix[l]and a.INK or a.MID
b.fill(f,96+(r-1)*8,h+4,6,8,A)
end
end
end
