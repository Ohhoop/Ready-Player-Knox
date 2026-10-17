require"SpiffBoy/Games/Lanterways/Base"

local d=SpiffBoy.Lanterways

local a={}
d.Lore=a

a.SERIES={
{id="round",pages={
"book1","book2","book3","book4","book5","book6","book7","book8","book9","book10","book11","book12",
"book13","book14","book15","book16","book17","book18","book19","book20","book21","book22","book23","book24",
}},
}

a.ECHOES={"firstflame","twofriends","firstsnuff","softvoice","onebell","braskleaves","drownedvillage","lissleaves","lastferry","thevote"}

a.QUESTS={
{id="ferry",started="q_ferry1",done="q_ferry"},
{id="wisp",started="q_wisp1",done="q_wisp"},
{id="courier",started="q_courier1",done="q_courier"},
{id="deserter",started="q_deserter1",done="q_deserter1"},
{id="carto",started="q_carto1",done="q_carto"},
{id="merchant",started="q_merchant1",done="q_merchant"},
}

function a.pages()
local b={}
for f,c in ipairs(a.SERIES)do
for g,e in ipairs(c.pages)do
b[#b+1]={id=e,series=c.id}
end
end
return b
end
