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

local function g(c,d,h)
local a=ProceduralDistributions.list[c]
if not a or type(a.items)~="table"then
return false
end
table.insert(a.items,d)
table.insert(a.items,h)
return true
end

local function h(a)
if a.loot.lists==nil then
return b
end
return a.loot.lists
end

local function k()
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

local function l()
local d=SuburbsDistributions and SuburbsDistributions.all
if type(d)~="table"then
return
end
local i=SpiffBoy.Cartridges.lootable()
for m,c in ipairs(f)do
local a=d[c.name]
if type(a)=="table"and type(a.items)=="table"then
for n,j in ipairs(i)do
table.insert(a.items,j.item)
table.insert(a.items,c.weight)
end
SpiffBoy.trace(c.name.." carries "..tostring(#i).." cartridges")
end
end
end

local function a(c,i,j)
for d=1,#c-1,2 do
if c[d]==i then
c[d+1]=j
end
end
end

local function m()
local n=SpiffBoy.Sandbox.cartridgeLootScale()
local o=e*SpiffBoy.Sandbox.linkCableLootScale()
local i=SpiffBoy.Cartridges.lootable()
for p,c in ipairs(i)do
for q,j in ipairs(h(c))do
local d=ProceduralDistributions.list[j]
if d and type(d.items)=="table"then
a(d.items,c.item,c.loot.weight*n)
end
end
end
for j,d in ipairs(b)do
local c=ProceduralDistributions.list[d]
if c and type(c.items)=="table"then
a(c.items,SpiffBoy.CABLE_ITEM,o)
end
end
local d=SuburbsDistributions and SuburbsDistributions.all
if type(d)=="table"then
local p=SpiffBoy.Sandbox.zombiesCarryCartridges()
for r,j in ipairs(f)do
local c=d[j.name]
if type(c)=="table"and type(c.items)=="table"then
for s,q in ipairs(i)do
a(c.items,q.item,p and j.weight or 0)
end
end
end
end
ItemPickerJava.Parse()
end

Events.OnPreDistributionMerge.Add(k)
Events.OnPostDistributionMerge.Add(l)
Events.OnInitGlobalModData.Add(m)
