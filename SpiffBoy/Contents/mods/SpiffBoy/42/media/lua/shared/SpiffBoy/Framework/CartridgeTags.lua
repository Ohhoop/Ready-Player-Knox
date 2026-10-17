require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

local a=SpiffBoy.Cartridges

a.TAG="spiffboy:cartridge"

function a.checkItemTags()
local e=ItemTag.get(ResourceLocation.of(a.TAG))
local c=0
for f,b in ipairs(a.all())do
local d=getScriptManager():FindItem(b.item)
if not d then
SpiffBoy.log("cartridge "..b.id.." of the mod "..b.mod.." names the item "..b.item..", which no item script defines")
c=c+1
elseif not d:hasTag(e)then
SpiffBoy.log("cartridge "..b.id.." of the mod "..b.mod.." has the item "..b.item.." without the tag "..a.TAG..": the dismantling recipe does not take it")
c=c+1
end
end
SpiffBoy.trace("item tags checked on "..#a.all().." cartridges, "..c.." reported")
return c
end

Events.OnGameStart.Add(a.checkItemTags)
Events.OnServerStarted.Add(a.checkItemTags)
