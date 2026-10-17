if isClient()and not isServer()then
return
end

require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

local c={
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

local g=1

local h={
{name="Outfit_Student",weight=0.1},
{name="Outfit_HonorStudent",weight=0.1},
{name="Outfit_Cook_Spiffos",weight=0.25},
{name="Outfit_Waiter_Spiffo",weight=0.25},
}

local function d(b,e,f)
local a=ProceduralDistributions.list[b]
if not a or type(a.items)~="table"then
return false
end
table.insert(a.items,e)
table.insert(a.items,f)
return true
end

local function i(a)
if a.loot.lists==nil then
return c
end
return a.loot.lists
end

local function j()
for f,a in ipairs(SpiffBoy.Cartridges.lootable())do
local b=0
for k,e in ipairs(i(a))do
if d(e,a.item,a.loot.weight)then
b=b+1
end
end
SpiffBoy.trace(a.id.." added to "..tostring(b).." loot lists")
end
local a=0
for e,b in ipairs(c)do
if d(b,SpiffBoy.CABLE_ITEM,g)then
a=a+1
end
end
SpiffBoy.trace("link cable added to "..tostring(a).." loot lists")
end

local function k()
local e=SuburbsDistributions and SuburbsDistributions.all
if type(e)~="table"then
return
end
local f=SpiffBoy.Cartridges.lootable()
for m,b in ipairs(h)do
local a=e[b.name]
if type(a)=="table"and type(a.items)=="table"then
for n,l in ipairs(f)do
table.insert(a.items,l.item)
table.insert(a.items,b.weight)
end
SpiffBoy.trace(b.name.." carries "..tostring(#f).." cartridges")
end
end
end

Events.OnPreDistributionMerge.Add(j)
Events.OnPostDistributionMerge.Add(k)
