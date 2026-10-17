require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/Rows"
require"SpiffBoy/Games/Lanterways/Maps/MurkSea"
require"SpiffBoy/Games/Lanterways/Music"

local a=SpiffBoy.Lanterways
local b=a.Maps
local c=a.MapRows
local d=a.Music

b.spire={
rows=c.spire,
place="spire",
banner="spire",
music=d.SPIRE,
back="spire",
objects={
{kind="everlamp",x=16,y=3,w=4,h=3},
},
npcs={
{id="brask",sprite="brask",x=16,y=20,dir="right",show={min=19,max=19}},
{id="ashgrave",sprite="ashgrave",x=18,y=7,dir="down",show={min=20,max=20}},
},
chests={
{flag="c_spire1",x=2,y=30,item="dawncoat",count=1},
{flag="c_spire2",x=34,y=38,item="greatstew",count=3},
{flag="c_spire3",x=2,y=38,item="banquetapron",count=1},
{flag="c_spire4",x=2,y=24,item="dawnember",count=1},
{flag="c_spire5",x=34,y=24,item="glimmerbomb",count=3},
{flag="c_spire6",x=34,y=18,item="beaconplate",count=1},
{flag="c_spire7",x=34,y=10,item="sparkjar",count=3},
{flag="c_spire8",x=34,y=3,item="oilcask",count=2},
{flag="c_spire9",x=5,y=10,item="mothjar",count=2},
{flag="c_spire10",x=2,y=10,item="veilash",count=2},
},
events={
{x=18,y=16,w=1,h=9,when={min=19,max=19},script="brask_fight"},
{x=10,y=2,w=1,h=9,when={min=20,max=20},script="final_fight"},
},
encounters={rate=14,troops={
{"kindledguard","glarewisp"},{"lampgolem","glarewisp"},{"ashhound","ashhound","glarewisp"},{"kindledguard","kindledguard","ashhound"},{"lampgolem"},
},rares={{"gildedmite"},{"lostwarden"}}},
warps={
{x=17,y=39,w=2,h=1,to="murksea",tx=a.MurkSea.sites.spireBack.x,ty=a.MurkSea.sites.spireBack.y,dir="down"},
{x=33,y=30,to="spire",tx=32,ty=17,dir="left"},
{x=33,y=16,to="spire",tx=32,ty=30,dir="left"},
{x=2,y=16,to="spire",tx=3,ty=3,dir="right"},
{x=2,y=2,to="spire",tx=3,ty=17,dir="right"},
},
}

a.TOWNS={
{place="tallowby",map="tallowby",x=28,y=19},
{place="wickhollow",map="wickhollow",x=3,y=16},
{place="brassmouth",map="brassmouth",x=5,y=20},
{place="glimmerhold",map="glimmerhold",x=5,y=17},
{place="mothgrove",map="mothgrove",x=12,y=12},
{place="farrow",map="farrow",x=8,y=12},
}
