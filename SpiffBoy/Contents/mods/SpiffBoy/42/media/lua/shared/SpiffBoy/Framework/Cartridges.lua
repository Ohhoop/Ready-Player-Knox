require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"

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

local e={}
local g={}
local h={}
local d={}

local i="/"

local function j(a)
return type(a)=="string"and string.len(a)>string.len(i)and string.sub(a,-string.len(i))==i
end

local function m(a)
if type(a)~="table"or type(a.id)~="string"then
error("SpiffBoy: a cartridge definition needs a string id")
end
local c="SpiffBoy: cartridge "..a.id.." "
if not SpiffBoy.isInteger(a.api)or a.api<1 then
error(c.."needs the api version of SpiffBoy it was written for, such as api = "..SpiffBoy.API_VERSION)
end
if a.api>SpiffBoy.API_VERSION then
error(c.."needs a newer SpiffBoy (api "..tostring(a.api)..", this SpiffBoy has "..SpiffBoy.API_VERSION..")")
end
if type(a.item)~="string"or not string.find(a.item,".",1,true)then
error(c.."needs the full type of its item, such as MyMod.MyCartridge")
end
if string.len(a.item)>SpiffBoy.CHIP_MAX_STRING then
error(c.."has an item type of "..string.len(a.item).." characters, at most "..SpiffBoy.CHIP_MAX_STRING.." are allowed")
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
if not j(a.art)then
error(c.."needs the folder of its art in its mod, ending with a slash, such as media/ui/MyMod/MyGame/")
end
if not j(a.texts)then
error(c.."needs the folder of its language files in its mod, ending with a slash, such as media/lua/shared/MyMod/MyGame/Translate/")
end
local f=a.loot
if type(f)~="table"then
error(c.."needs a loot table")
end
if type(f.weight)~="number"or f.weight<0 then
error(c.."needs a loot weight of zero or more")
end
if f.lists~=nil and type(f.lists)~="table"then
error(c.."needs a list of loot list names, or none")
end
end

local function k(a,c,f)
if c~=nil and c.id~=a.id then
error("SpiffBoy: cartridge "..a.id.." of the mod "..a.mod.." uses the "..f.." "..tostring(a[f]).." already used by the cartridge "..c.id.." of the mod "..c.mod)
end
end

local function n(a)
local c=g[a.id]
if c~=nil and c.mod~=a.mod then
error("SpiffBoy: cartridge "..a.id.." of the mod "..a.mod.." uses an id already registered by the mod "..c.mod)
end
k(a,e[a.item],"item")
k(a,h[a.game],"game")
end

local function o(a)
for c=1,#d do
if d[c]==a then
return c
end
end
error("SpiffBoy: cartridge "..a.id.." is indexed but missing from the registration order")
end

function b.register(a)
if type(a)=="table"and a.loot==nil then
a.loot={weight=b.DEFAULT_LOOT_WEIGHT}
end
m(a)
n(a)
local c=g[a.id]
if c~=nil then
d[o(c)]=a
e[c.item]=nil
h[c.game]=nil
else
d[#d+1]=a
end
e[a.item]=a
h[a.game]=a
g[a.id]=a
return a
end

function b.byId(a)
return g[a]
end

function b.get(a)
return e[a]
end

function b.all()
return d
end

function b.lootable()
local a={}
for f=1,#d do
local c=d[f]
if c.loot.weight>0 then
a[#a+1]=c
end
end
return a
end

function b.pickWeighted(a,p)
local c=0
for f=1,#a do
c=c+a[f].loot.weight
end
local q=p*c
local f=0
for l=1,#a-1 do
f=f+a[l].loot.weight
if q<f then
return a[l]
end
end
return a[#a]
end

function b.isCartridge(a)
return a~=nil and e[a:getFullType()]~=nil
end

function b.resolveGame(a)
return _G[a.game]
end
