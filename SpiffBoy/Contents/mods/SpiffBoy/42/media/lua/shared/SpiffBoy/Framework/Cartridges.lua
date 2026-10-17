require"SpiffBoy/Core/Core"

SpiffBoy.Cartridges=SpiffBoy.Cartridges or{}
local b=SpiffBoy.Cartridges

b.SCREEN_WIDTH=180
b.SCREEN_HEIGHT=120
b.DEFAULT_LOOT_WEIGHT=2
b.SHADES={
{r=28/255,g=36/255,b=32/255},
{r=72/255,g=86/255,b=78/255},
{r=112/255,g=128/255,b=118/255},
{r=156/255,g=168/255,b=160/255},
}

local f={}
local g={}
local d={}

local h="media/ui/SpiffBoy/Games/"
local i="media/lua/shared/SpiffBoy/Games/"
local j="/Translate/"

local function k(a)
if type(a)~="table"or type(a.id)~="string"then
error("SpiffBoy: a cartridge definition needs a string id")
end
local c="SpiffBoy: cartridge "..a.id.." "
if type(a.item)~="string"or not string.find(a.item,".",1,true)then
error(c.."needs the full type of its item, such as MyMod.MyCartridge")
end
if type(a.title)~="string"then
error(c.."needs a title")
end
if type(a.game)~="string"then
error(c.."needs the global name of its game class")
end
if type(a.mod)~="string"then
error(c.."needs the id of the mod that holds its files")
end
local e=a.loot
if type(e)~="table"then
error(c.."needs a loot table")
end
if type(e.weight)~="number"or e.weight<0 then
error(c.."needs a loot weight of zero or more")
end
if e.lists~=nil and type(e.lists)~="table"then
error(c.."needs a list of loot list names, or none")
end
end

function b.register(a)
if type(a)=="table"then
if a.art==nil then
a.art=h..tostring(a.id).."/"
end
if a.texts==nil then
a.texts=i..tostring(a.id)..j
end
if a.loot==nil then
a.loot={weight=b.DEFAULT_LOOT_WEIGHT}
end
end
k(a)
if f[a.item]==nil then
d[#d+1]=a
end
f[a.item]=a
g[a.id]=a
return a
end

function b.byId(a)
return g[a]
end

function b.get(a)
return f[a]
end

function b.all()
return d
end

function b.lootable()
local a={}
for e=1,#d do
local c=d[e]
if c.loot.weight>0 then
a[#a+1]=c
end
end
return a
end

function b.isCartridge(a)
return a~=nil and f[a:getFullType()]~=nil
end

function b.resolveGame(a)
return _G[a.game]
end
