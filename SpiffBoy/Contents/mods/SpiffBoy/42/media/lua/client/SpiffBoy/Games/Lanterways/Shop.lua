require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local d=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local c=a.Window
local g=a.Party
local h=a.Items
local o=a.Characters

local e={listRows=4,listY=20,descY=88,descH=32}
local p={"ShopBuy","ShopSell","ShopLeave"}
local q={"ShopBuy","ShopSell","ShopCraft","ShopLeave"}

function d:shopChoices()
if a.Recipes[self.shop.id]then
return q
end
return p
end

function d:canCraft(b)
if self.state.gold<b.gold then
return false
end
for i,f in ipairs(b.needs)do
if g.count(self.state,f[1])<f[2]then
return false
end
end
return true
end

function d:shopRecipeRows()
local f={}
for k,b in ipairs(a.Recipes[self.shop.id])do
local i=a.text("Item_"..b.item)
if b.count>1 then
i=i.." x"..b.count
end
local j=nil
if b.gold>0 then
j=tostring(b.gold)
end
f[#f+1]={id=b.item,recipe=k,label=i,right=j,disabled=not self:canCraft(b)}
end
return f
end

function d:craft(b)
for i,f in ipairs(b.needs)do
g.takeItem(self.state,f[1],f[2])
end
g.addGold(self.state,-b.gold)
g.addItem(self.state,b.item,b.count)
self:effect("buy")
end

function d:recipeNeeds(i)
local b={}
for j,f in ipairs(i.needs)do
b[#b+1]=f[2].." x "..a.text("Item_"..f[1])
end
return a.text("CraftNeeds",table.concat(b,", "))
end

function d:shopRows(b)
if b=="buy"then
return self:shopWares()
elseif b=="craft"then
return self:shopRecipeRows()
end
return self:shopSellRows()
end

function d:openShop(b)
local f=a.Shops[b]
if not f then
error("Lanterways: no shop named "..tostring(b))
end
self.shop={id=b,screen="choose",choice=1,list=1,top=1,amount=1}
self.mode=d.MODE_SHOP
self:effect("open")
end

function d:shopWares()
local f={}
for j,b in ipairs(a.Shops[self.shop.id])do
if g.meets(self.state,b.when)then
local i=h.get(b.item)
f[#f+1]={id=b.item,label=a.text("Item_"..b.item),right=tostring(i.price),disabled=i.price>self.state.gold}
end
end
return f
end

function d:shopSellRows()
local b={}
for j,f in ipairs(g.bagList(self.state))do
local i=h.sellPrice(h.get(f))
if i>0 then
b[#b+1]={id=f,label=a.text("Item_"..f),right=tostring(i)}
end
end
return b
end

function d:closeShop()
self.shop=nil
self.mode=d.MODE_FIELD
self:effect("cancel")
end

function d:tickShop(l)
if self.dialog then
self:tickDialog(l)
return
end
if not l then
return
end
local b=self.shop
local f=l.pressed
if b.screen=="choose"then
local i=self:shopChoices()
local j=a.verticalStep(f)
if j~=0 then
b.choice=a.wrap(b.choice+j,#i)
self:effect("cursor")
end
if f.b then
self:closeShop()
elseif f.a then
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
local i=a.horizontalStep(f)+a.verticalStep(f)*-10
if i~=0 then
b.amount=SpiffBoy.clamp(b.amount+i,1,b.maxAmount)
self:effect("cursor")
end
if f.b then
b.screen=b.back
self:effect("cancel")
elseif f.a then
self:closeDeal()
end
return
end
local j=self:shopRows(b.screen)
local m=a.verticalStep(f)
if m~=0 and#j>0 then
b.list=a.wrap(b.list+m,#j)
b.top=c.scroll(b.list,b.top,e.listRows,#j)
self:effect("cursor")
end
b.list=SpiffBoy.clamp(b.list,1,#j)
if f.b then
b.screen="choose"
self:effect("cancel")
return
end
local i=j[b.list]
if f.a and i and b.screen=="craft"then
if i.disabled then
self:effect("buzz")
else
self:craft(a.Recipes[b.id][i.recipe])
end
return
end
if f.a and i then
local n=h.get(i.id)
if b.screen=="buy"then
local k=math.floor(self.state.gold/n.price)
k=math.min(k,h.MAX_STACK-g.count(self.state,i.id))
if k<=0 then
self:effect("buzz")
return
end
b.maxAmount=k
else
b.maxAmount=g.count(self.state,i.id)
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
local f=h.get(b.item)
if b.back=="buy"then
g.addGold(self.state,-f.price*b.amount)
g.addItem(self.state,b.item,b.amount)
else
g.takeItem(self.state,b.item,b.amount)
g.addGold(self.state,h.sellPrice(f)*b.amount)
end
self:effect("buy")
b.screen=b.back
end

function d:drawWearers(j,k,b,l)
local f=h.get(k)
if not h.isEquipment(f)then
return
end
for n,m in ipairs(self.state.order)do
local i=o.BY_ID[m]
if h.fits(i,f)then
j:layers(self.artHeads,(i.index-1)*8,8,8,b,l,{1,3})
b=b+10
end
end
end

function d:drawShop(b)
local f=self.shop
local i=self.artUi
c.frame(b,i,0,0,a.WIDTH,18)
c.text(b,a.text("Shop_"..f.id),6,0)
c.icon(b,i,"coin",112,4,{1,3})
b:number(self.state.gold,a.WIDTH-6,6,self.artDigits,"right",0,a.INK)
if f.screen=="choose"then
local j={}
for k,l in ipairs(self:shopChoices())do
j[k]={label=a.text(l)}
end
c.frame(b,i,0,20,90,#j*c.LINE+8)
c.list(b,i,j,2,24,86,#j,f.choice,1,self.clock,true)
return
end
local k=f.screen
if k=="amount"then
k=f.back
end
local m=self:shopRows(k)
c.frame(b,i,0,e.listY-2,a.WIDTH,e.listRows*c.LINE+8)
c.list(b,i,m,2,e.listY+2,a.WIDTH-4,e.listRows,f.list,f.top,self.clock,f.screen~="amount")
local j=m[f.list]
c.frame(b,nil,0,e.descY,a.WIDTH,e.descH)
if not j then
return
end
if f.screen=="amount"then
local l=h.get(f.item)
local n=f.back=="buy"and l.price or h.sellPrice(l)
c.text(b,"x"..f.amount,8,e.descY+1)
c.textRight(b,tostring(n*f.amount),a.WIDTH-8,e.descY+1)
c.icon(b,i,"arrowLeft",2,e.descY+6,{1})
c.icon(b,i,"arrowRight",50,e.descY+6,{1})
c.text(b,a.text("Owned",g.count(self.state,f.item)),8,e.descY+16,a.DARK)
return
end
if f.screen=="craft"then
local l=b:wrapText(self:recipeNeeds(a.Recipes[f.id][j.recipe]),a.WIDTH-12)
for n=1,math.min(2,#l)do
c.text(b,l[n],6,e.descY+1+(n-1)*15)
end
return
end
local l=b:wrapText(a.text("ItemDesc_"..j.id),a.WIDTH-12)
c.text(b,l[1]or"",6,e.descY+1)
if h.isEquipment(h.get(j.id))then
self:drawWearers(b,j.id,8,e.descY+21)
c.textRight(b,a.text("Owned",g.count(self.state,j.id)),a.WIDTH-6,e.descY+16,a.DARK)
elseif l[2]then
c.text(b,l[2],6,e.descY+16)
end
end

function d:travelTargets()
local b={}
for i,f in ipairs(a.TOWNS)do
if g.hasFlag(self.state,"v_"..f.place)and f.map~=self.field.id then
b[#b+1]=f
end
end
return b
end

function d:openTravel()
local f=self:travelTargets()
local b={}
for j,i in ipairs(f)do
b[#b+1]="Map_"..i.place
end
b[#b+1]="Cancel"
self.travel=f
self:openChoice("TravelAsk",b)
end

function d:finishTravel(f)
local b=self.travel and self.travel[f]
self.travel=nil
if b then
self:effect("bell")
self:warp(b.map,b.x,b.y,"down")
end
end
