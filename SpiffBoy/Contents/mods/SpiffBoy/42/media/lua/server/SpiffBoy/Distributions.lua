if isClient()and not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/Sandbox"

local b={
"BedroomDresserChild",
"BookStoreCounter",
"ClassroomDesk",
"ComicStoreCounter",
"ComicStoreShelfGames",
"CrateElectronics",
"CrateToys",
"CyberCafeDesk",
"Gifts",
"GigamartHouseElectronics",
"GigamartToys",
"Hobbies",
"HolidayStuff",
"JunkHoard",
"LivingRoomWardrobe",
"SchoolLockers",
"SchoolLockersBad",
"UniversityWardrobe",
"WardrobeChild",
}

local e=1

local f={
{name="Outfit_Student",weight=0.1},
{name="Outfit_HonorStudent",weight=0.1},
{name="Outfit_Cook_Spiffos",weight=0.25},
{name="Outfit_Waiter_Spiffo",weight=0.25},
}

local function g(listName,fullType,weight)
local a=ProceduralDistributions.list[listName]
if not a or type(a.items)~="table"then
return false
end
table.insert(a.items,fullType)
table.insert(a.items,weight)
return true
end

local function h(definition)
if definition.loot.lists==nil then
return b
end
return definition.loot.lists
end

local function m()
for i,a in ipairs(SpiffBoy.Cartridges.lootable())do
local c=0
for j,d in ipairs(h(a))do
if g(d,a.item,a.loot.weight)then
c=c+1
end
end
SpiffBoy.trace(a.id.." added to "..tostring(c).." loot lists")
end
local a=0
for d,c in ipairs(b)do
if g(c,SpiffBoy.CABLE_ITEM,e)then
a=a+1
end
end
SpiffBoy.trace("link cable added to "..tostring(a).." loot lists")
end

local function i(outfit,definition)
return outfit.weight*definition.loot.weight/SpiffBoy.Cartridges.DEFAULT_LOOT_WEIGHT
end

local function n()
local d=SuburbsDistributions and SuburbsDistributions.all
if type(d)~="table"then
return
end
local j=SpiffBoy.Cartridges.lootable()
for l,c in ipairs(f)do
local a=d[c.name]
if type(a)=="table"and type(a.items)=="table"then
for o,k in ipairs(j)do
table.insert(a.items,k.item)
table.insert(a.items,i(c,k))
end
SpiffBoy.trace(c.name.." carries "..tostring(#j).." cartridges")
end
end
end

local function a(entries,fullType,weight)
for c=1,#entries-1,2 do
if entries[c]==fullType then
entries[c+1]=weight
end
end
end

local function o()
local p=SpiffBoy.Sandbox.cartridgeLootScale()
local q=e*SpiffBoy.Sandbox.linkCableLootScale()
local j=SpiffBoy.Cartridges.lootable()
for l,c in ipairs(j)do
for r,k in ipairs(h(c))do
local d=ProceduralDistributions.list[k]
if d and type(d.items)=="table"then
a(d.items,c.item,c.loot.weight*p)
end
end
end
for k,d in ipairs(b)do
local c=ProceduralDistributions.list[d]
if c and type(c.items)=="table"then
a(c.items,SpiffBoy.CABLE_ITEM,q)
end
end
local d=SuburbsDistributions and SuburbsDistributions.all
if type(d)=="table"then
local r=SpiffBoy.Sandbox.zombiesCarryCartridges()
for s,k in ipairs(f)do
local c=d[k.name]
if type(c)=="table"and type(c.items)=="table"then
for t,l in ipairs(j)do
a(c.items,l.item,r and i(k,l)or 0)
end
end
end
end
ItemPickerJava.Parse()
end

Events.OnPreDistributionMerge.Add(m)
Events.OnPostDistributionMerge.Add(n)
Events.OnInitGlobalModData.Add(o)
