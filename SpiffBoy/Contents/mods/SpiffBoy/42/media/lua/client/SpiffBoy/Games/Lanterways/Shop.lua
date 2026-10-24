require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local d=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local c=a.Window
local f=a.Party
local g=a.Items
local n=a.Characters

local e={listRows=4,listY=20,descY=88,descH=32}
local o={"ShopBuy","ShopSell","ShopLeave"}
local p={"ShopBuy","ShopSell","ShopCraft","ShopLeave"}

function d:shopChoices()
if a.Recipes[self.shop.id]then
return p
end
return o
end

function d:canCraft(recipe)
if self.state.gold<recipe.gold then
return false
end
for h,b in ipairs(recipe.needs)do
if f.count(self.state,b[1])<b[2]then
return false
end
end
return true
end

function d:shopRecipeRows()
local h={}
for k,b in ipairs(a.Recipes[self.shop.id])do
local i=a.text("Item_"..b.item)
if b.count>1 then
i=i.." x"..b.count
end
local j=nil
if b.gold>0 then
j=tostring(b.gold)
end
h[#h+1]={id=b.item,recipe=k,label=i,right=j,disabled=not self:canCraft(b)}
end
return h
end

function d:craft(recipe)
for h,b in ipairs(recipe.needs)do
f.takeItem(self.state,b[1],b[2])
end
f.addGold(self.state,-recipe.gold)
f.addItem(self.state,recipe.item,recipe.count)
self:effect("buy")
end

function d:recipeNeeds(recipe)
local b={}
for i,h in ipairs(recipe.needs)do
b[#b+1]=h[2].." x "..a.text("Item_"..h[1])
end
return a.text("CraftNeeds",table.concat(b,", "))
end

function d:shopRows(screen)
if screen=="buy"then
return self:shopWares()
elseif screen=="craft"then
return self:shopRecipeRows()
end
return self:shopSellRows()
end

function d:openShop(shopId)
local b=a.Shops[shopId]
if not b then
error("Lanterways: no shop named "..tostring(shopId))
end
self.shop={id=shopId,screen="choose",choice=1,list=1,top=1,amount=1}
self.mode=d.MODE_SHOP
self:effect("open")
end

function d:shopWares()
local h={}
for j,b in ipairs(a.Shops[self.shop.id])do
if f.meets(self.state,b.when)then
local i=g.get(b.item)
h[#h+1]={id=b.item,label=a.text("Item_"..b.item),right=tostring(i.price),disabled=i.price>self.state.gold}
end
end
return h
end

function d:shopSellRows()
local b={}
for j,h in ipairs(f.bagList(self.state))do
local i=g.sellPrice(g.get(h))
if i>0 then
b[#b+1]={id=h,label=a.text("Item_"..h),right=tostring(i)}
end
end
return b
end

function d:closeShop()
self.shop=nil
self.mode=d.MODE_FIELD
self:effect("cancel")
end

function d:tickShop(input)
if self.dialog then
self:tickDialog(input)
return
end
if not input then
return
end
local b=self.shop
local h=input.pressed
if b.screen=="choose"then
local i=self:shopChoices()
local j=a.verticalStep(h)
if j~=0 then
b.choice=a.wrap(b.choice+j,#i)
self:effect("cursor")
end
if h.b then
self:closeShop()
elseif h.a then
local k=i[b.choice]
if k=="ShopLeave"then
self:closeShop()
return
end
b.screen=({ShopBuy="buy",ShopSell="sell",ShopCraft="craft"})[k]
b.list,b.top=1,1
self:effect("confirm")
end
return
end
if b.screen=="amount"then
local i=a.horizontalStep(h)+a.verticalStep(h)*-10
if i~=0 then
b.amount=SpiffBoy.clamp(b.amount+i,1,b.maxAmount)
self:effect("cursor")
end
if h.b then
b.screen=b.back
self:effect("cancel")
elseif h.a then
self:closeDeal()
end
return
end
local j=self:shopRows(b.screen)
local l=a.verticalStep(h)
if l~=0 and#j>0 then
b.list=a.wrap(b.list+l,#j)
b.top=c.scroll(b.list,b.top,e.listRows,#j)
self:effect("cursor")
end
b.list=SpiffBoy.clamp(b.list,1,#j)
if h.b then
b.screen="choose"
self:effect("cancel")
return
end
local i=j[b.list]
if h.a and i and b.screen=="craft"then
if i.disabled then
self:effect("buzz")
else
self:craft(a.Recipes[b.id][i.recipe])
end
return
end
if h.a and i then
local m=g.get(i.id)
if b.screen=="buy"then
local k=math.floor(self.state.gold/m.price)
k=math.min(k,g.MAX_STACK-f.count(self.state,i.id))
if k<=0 then
self:effect("buzz")
return
end
b.maxAmount=k
else
b.maxAmount=f.count(self.state,i.id)
end
b.item=i.id
b.amount=1
b.back=b.screen
b.screen="amount"
self:effect("confirm")
end
end

function d:closeDeal()
local b=self.shop
local h=g.get(b.item)
if b.back=="buy"then
f.addGold(self.state,-h.price*b.amount)
f.addItem(self.state,b.item,b.amount)
else
f.takeItem(self.state,b.item,b.amount)
f.addGold(self.state,g.sellPrice(h)*b.amount)
end
self:effect("buy")
b.screen=b.back
end

function d:drawWearers(screen,itemId,x,y)
local b=g.get(itemId)
if not g.isEquipment(b)then
return
end
for j,i in ipairs(self.state.order)do
local h=n.BY_ID[i]
if g.fits(h,b)then
screen:layers(self.artHeads,(h.index-1)*8,8,8,x,y,{1,3})
x=x+10
end
end
end

function d:drawShop(screen)
local b=self.shop
local h=self.artUi
c.frame(screen,h,0,0,a.WIDTH,18)
c.text(screen,a.text("Shop_"..b.id),6,0)
c.icon(screen,h,"coin",112,4,{1,3})
screen:number(self.state.gold,a.WIDTH-6,6,self.artDigits,"right",0,a.INK)
if b.screen=="choose"then
local i={}
for j,k in ipairs(self:shopChoices())do
i[j]={label=a.text(k)}
end
c.frame(screen,h,0,20,90,#i*c.LINE+8)
c.list(screen,h,i,2,24,86,#i,b.choice,1,self.clock,true)
return
end
local j=b.screen
if j=="amount"then
j=b.back
end
local l=self:shopRows(j)
c.frame(screen,h,0,e.listY-2,a.WIDTH,e.listRows*c.LINE+8)
c.list(screen,h,l,2,e.listY+2,a.WIDTH-4,e.listRows,b.list,b.top,self.clock,b.screen~="amount")
local i=l[b.list]
c.frame(screen,nil,0,e.descY,a.WIDTH,e.descH)
if not i then
return
end
if b.screen=="amount"then
local k=g.get(b.item)
local m=b.back=="buy"and k.price or g.sellPrice(k)
c.text(screen,"x"..b.amount,8,e.descY+1)
c.textRight(screen,tostring(m*b.amount),a.WIDTH-8,e.descY+1)
c.icon(screen,h,"arrowLeft",2,e.descY+6,{1})
c.icon(screen,h,"arrowRight",50,e.descY+6,{1})
c.text(screen,a.text("Owned",f.count(self.state,b.item)),8,e.descY+16,a.DARK)
return
end
if b.screen=="craft"then
local k=screen:wrapText(self:recipeNeeds(a.Recipes[b.id][i.recipe]),a.WIDTH-12)
for m=1,math.min(2,#k)do
c.text(screen,k[m],6,e.descY+1+(m-1)*15)
end
return
end
local k=screen:wrapText(a.text("ItemDesc_"..i.id),a.WIDTH-12)
c.text(screen,k[1]or"",6,e.descY+1)
if g.isEquipment(g.get(i.id))then
self:drawWearers(screen,i.id,8,e.descY+21)
c.textRight(screen,a.text("Owned",f.count(self.state,i.id)),a.WIDTH-6,e.descY+16,a.DARK)
elseif k[2]then
c.text(screen,k[2],6,e.descY+16)
end
end

function d:travelTargets()
local b={}
for i,h in ipairs(a.TOWNS)do
if f.hasFlag(self.state,"v_"..h.place)and h.map~=self.field.id then
b[#b+1]=h
end
end
return b
end

function d:openTravel()
local h=self:travelTargets()
local b={}
for j,i in ipairs(h)do
b[#b+1]="Map_"..i.place
end
b[#b+1]="Cancel"
self.travel=h
self:openChoice("TravelAsk",b)
end

function d:finishTravel(picked)
local b=self.travel and self.travel[picked]
self.travel=nil
if b then
self:effect("bell")
self:warp(b.map,b.x,b.y,"down")
end
end
