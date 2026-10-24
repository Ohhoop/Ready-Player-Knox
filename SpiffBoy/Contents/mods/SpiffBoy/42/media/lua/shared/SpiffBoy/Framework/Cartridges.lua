require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"

SpiffBoy.Cartridges=SpiffBoy.Cartridges or{}
local a=SpiffBoy.Cartridges

a.SCREEN_WIDTH=180
a.SCREEN_HEIGHT=120
a.DEFAULT_LOOT_WEIGHT=2
a.SHADES={
{r=28/255,g=36/255,b=32/255},
{r=72/255,g=86/255,b=78/255},
{r=112/255,g=128/255,b=118/255},
{r=156/255,g=168/255,b=160/255},
}

local d={}
local f={}
local g={}
local c={}

local h="/"

local function i(value)
return type(value)=="string"and string.len(value)>string.len(h)and string.sub(value,-string.len(h))==h
end

local function l(definition)
if type(definition)~="table"or type(definition.id)~="string"then
error("SpiffBoy: a cartridge definition needs a string id")
end
local b="SpiffBoy: cartridge "..definition.id.." "
if not SpiffBoy.isInteger(definition.api)or definition.api<1 then
error(b.."needs the api version of SpiffBoy it was written for, such as api = "..SpiffBoy.API_VERSION)
end
if definition.api>SpiffBoy.API_VERSION then
error(b.."needs a newer SpiffBoy (api "..tostring(definition.api)..", this SpiffBoy has "..SpiffBoy.API_VERSION..")")
end
if type(definition.item)~="string"or not string.find(definition.item,".",1,true)then
error(b.."needs the full type of its item, such as MyMod.MyCartridge")
end
if string.len(definition.item)>SpiffBoy.CHIP_MAX_STRING then
error(b.."has an item type of "..string.len(definition.item).." characters, at most "..SpiffBoy.CHIP_MAX_STRING.." are allowed")
end
if type(definition.title)~="string"then
error(b.."needs a title")
end
if type(definition.game)~="string"then
error(b.."needs the global name of its game class")
end
if type(definition.mod)~="string"then
error(b.."needs the id of the mod that holds its files")
end
if not i(definition.art)then
error(b.."needs the folder of its art in its mod, ending with a slash, such as media/ui/MyMod/MyGame/")
end
if not i(definition.texts)then
error(b.."needs the folder of its language files in its mod, ending with a slash, such as media/lua/shared/MyMod/MyGame/Translate/")
end
local e=definition.loot
if type(e)~="table"then
error(b.."needs a loot table")
end
if type(e.weight)~="number"or e.weight<0 then
error(b.."needs a loot weight of zero or more")
end
if e.lists~=nil and type(e.lists)~="table"then
error(b.."needs a list of loot list names, or none")
end
end

local function j(definition,owner,field)
if owner~=nil and owner.id~=definition.id then
error("SpiffBoy: cartridge "..definition.id.." of the mod "..definition.mod.." uses the "..field.." "..tostring(definition[field]).." already used by the cartridge "..owner.id.." of the mod "..owner.mod)
end
end

local function m(definition)
local b=f[definition.id]
if b~=nil and b.mod~=definition.mod then
error("SpiffBoy: cartridge "..definition.id.." of the mod "..definition.mod.." uses an id already registered by the mod "..b.mod)
end
j(definition,d[definition.item],"item")
j(definition,g[definition.game],"game")
end

local function n(definition)
for b=1,#c do
if c[b]==definition then
return b
end
end
error("SpiffBoy: cartridge "..definition.id.." is indexed but missing from the registration order")
end

function a.register(definition)
if type(definition)=="table"and definition.loot==nil then
definition.loot={weight=a.DEFAULT_LOOT_WEIGHT}
end
l(definition)
m(definition)
local b=f[definition.id]
if b~=nil then
c[n(b)]=definition
d[b.item]=nil
g[b.game]=nil
else
c[#c+1]=definition
end
d[definition.item]=definition
g[definition.game]=definition
f[definition.id]=definition
return definition
end

function a.byId(id)
return f[id]
end

function a.get(fullType)
return d[fullType]
end

function a.all()
return c
end

function a.lootable()
local b={}
for k=1,#c do
local e=c[k]
if e.loot.weight>0 then
b[#b+1]=e
end
end
return b
end

function a.pickWeighted(definitions,roll)
local b=0
for e=1,#definitions do
b=b+definitions[e].loot.weight
end
local o=roll*b
local e=0
for k=1,#definitions-1 do
e=e+definitions[k].loot.weight
if o<e then
return definitions[k]
end
end
return definitions[#definitions]
end

function a.isCartridge(item)
return item~=nil and d[item:getFullType()]~=nil
end

function a.resolveGame(definition)
return _G[definition.game]
end
