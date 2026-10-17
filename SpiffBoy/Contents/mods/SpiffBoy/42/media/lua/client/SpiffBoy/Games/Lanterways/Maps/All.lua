require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/Rows"
require"SpiffBoy/Games/Lanterways/Maps/MurkSea"
require"SpiffBoy/Games/Lanterways/Maps/Home"
require"SpiffBoy/Games/Lanterways/Maps/East"
require"SpiffBoy/Games/Lanterways/Maps/South"
require"SpiffBoy/Games/Lanterways/Maps/Capital"
require"SpiffBoy/Games/Lanterways/Maps/Under"
require"SpiffBoy/Games/Lanterways/Maps/Spire"
require"SpiffBoy/Games/Lanterways/Maps/Trials"
require"SpiffBoy/Games/Lanterways/Maps/Overworld"
require"SpiffBoy/Games/Lanterways/Maps/Watch"
require"SpiffBoy/Games/Lanterways/Maps/Homes"
require"SpiffBoy/Games/Lanterways/Maps/Props"

local d=SpiffBoy.Lanterways

for c,a in pairs(d.Maps)do
a.id=c
local e,f,g=d.MapHouses[c],d.MapProps[c],d.MapWalkers[c]
if not e or not f or not g then
error("Lanterways: no furnishing listed for map "..c)
end
a.objects=a.objects or{}
for h,b in ipairs(e)do
a.objects[#a.objects+1]={kind=b.kind,x=b.x,y=b.y,w=b.w,h=b.h,door=b.door,style=b.style,prop=true}
end
for h,b in ipairs(f)do
a.objects[#a.objects+1]={kind=b.kind,x=b.x,y=b.y,w=1,h=1,prop=true}
end
a.npcs=a.npcs or{}
for h,b in ipairs(g)do
a.npcs[#a.npcs+1]={id="walker"..h,sprite=b.sprite,x=b.x,y=b.y,dir="down",wander=true,roam=true}
end
end
