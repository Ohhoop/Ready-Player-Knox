require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/Rows"
require"SpiffBoy/Games/Lanterways/Maps/MurkSea"
require"SpiffBoy/Games/Lanterways/Music"

local b=SpiffBoy.Lanterways
local d=b.Maps
local f=b.MapRows
local g=b.Music
local h=b.MurkSea.sites

b.WATCHLIGHTS={
{region="rive",door="riveWatchDoor",when={min=4}},
{region="east",door="eastWatchDoor",page="book6",when={min=7}},
{region="coast",door="coastWatchDoor",page="book9",when={min=9}},
{region="tide",door="tideWatchDoor",page="book14",when={min=10}},
{region="spire",door="spireWatchDoor",page="book23",when={min=19}},
}

local function i(a)
if a.page then
return{{x=8,y=12,page=a.page}}
end
return{}
end

for j,a in ipairs(b.WATCHLIGHTS)do
local c="watch"..a.region
local e=h[a.door]
d[c]={
rows=f[c],
place=c,
banner=c,
music=g.HOME,
lamps={
{flag="w_"..a.region,x=5,y=3,brazier=true,when=a.when,lockedText="WatchLocked_"..a.region,script="watch_"..a.region,litText="WatchLit"},
},
notes=i(a),
warps={
{x=5,y=15,w=2,h=1,to="murksea",tx=e.x,ty=e.y+1,dir="down"},
{x=10,y=9,to=c,tx=9,ty=5,dir="left"},
{x=10,y=5,to=c,tx=9,ty=9,dir="left"},
},
}
end

d.watchrive.enter={
{when={notFlag="j_book"},script="book_found"},
}
d.watchrive.signs={
{x=4,y=12,script="book_table"},
{x=5,y=12,script="book_table"},
}
