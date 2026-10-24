require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Maps/Rows"
require"SpiffBoy/Games/Lanterways/Maps/HomesLayout"
require"SpiffBoy/Games/Lanterways/Maps/Home"
require"SpiffBoy/Games/Lanterways/Maps/East"
require"SpiffBoy/Games/Lanterways/Maps/South"
require"SpiffBoy/Games/Lanterways/Maps/Capital"
require"SpiffBoy/Games/Lanterways/Maps/Trials"
require"SpiffBoy/Games/Lanterways/Maps/Under"

local e=SpiffBoy.Lanterways
local c=e.Maps
local h=e.MapRows

local i={
talmill={
folk={
{sprite="kid",name="wispchild",show={flag="q_wisp1"},talk={
{when={max=18},say="Home_talmill1"},
{say="Home_talmill2"},
}},
},
looks={drawings={text="Look_talmill_drawings"}},
},
talfenn={
folk={
{sprite="elder",name="fenn",talk={
{when={max=3},say="Home_talfenn1"},
{when={max=18},say="Home_talfenn2"},
{say="Home_talfenn3"},
}},
},
looks={bell={text="Look_talfenn_bell"}},
},
talodd={
folk={
{sprite="elder",name="oddny",talk={
{when={notFlag="j_book"},say="Home_talodd1"},
{when={max=16},say="Home_talodd2"},
{when={max=18},say="Home_talodd3"},
{say="Home_talodd4"},
}},
},
looks={spyglass={text="Look_talodd_spyglass"}},
},
talempty={
folk={},
looks={table={text="Look_talempty_table"},letter={text="Look_talempty_letter"}},
},

wickbunk={
folk={
{sprite="farmer",name="presser",talk={
{when={max=6},say="Home_wickbunk1"},
{when={max=18},say="Home_wickbunk2"},
{say="Home_wickbunk3"},
}},
},
looks={board={text="Look_wickbunk_board"}},
},
wickprune={
folk={
{sprite="elder",name="prune",talk={
{when={notFlag="h_prune"},script="home_prune_gift"},
{when={max=18},say="Home_wickprune3"},
{say="Home_wickprune4"},
}},
},
looks={knives={text="Look_wickprune_knives"}},
},
wickodge={
folk={},
looks={recipes={script="home_odge_recipes"},buffet={script="home_odge_buffet"}},
},
wickguard={
folk={
{sprite="guard",name="watchman",talk={
{when={max=6},say="Home_wickguard1"},
{when={max=18},say="Home_wickguard2"},
{say="Home_wickguard3"},
}},
},
looks={poster={text="Look_wickguard_poster"}},
},
wickcarter={
folk={
{sprite="farmer",name="carter",talk={
{when={max=6},say="Home_wickcarter1"},
{when={max=18},say="Home_wickcarter2"},
{say="Home_wickcarter3"},
}},
},
looks={ledger={text="Look_wickcarter_ledger"}},
},

brasssail={
folk={
{sprite="woman",name="sailmaker",talk={
{when={max=9},say="Home_brasssail1"},
{when={max=18},say="Home_brasssail2"},
{say="Home_brasssail3"},
}},
},
looks={sail={text="Look_brasssail_sail"}},
},
brassbell={
folk={
{sprite="elder",name="founderwidow",talk={
{when={max=18},say="Home_brassbell1"},
{say="Home_brassbell2"},
}},
},
looks={mould={text="Look_brassbell_mould"}},
},
brassfish={
folk={
{sprite="sailor",name="fisher",talk={
{when={notFlag="h_cards"},script="home_cards"},
{say="Home_brassfish5"},
}},
},
looks={cards={text="Look_brassfish_cards"}},
},
brassport={
folk={
{sprite="sailor",name="harbourmaster",talk={
{when={max=9},say="Home_brassport1"},
{when={max=18},say="Home_brassport2"},
{say="Home_brassport3"},
}},
},
looks={tides={text="Look_brassport_tides"},report={text="Look_brassport_report"}},
},
brasskids={
folk={
{sprite="kid",name="kid",talk={
{when={max=9},say="Home_brasskids1"},
{when={max=18},say="Home_brasskids2"},
{say="Home_brasskids3"},
}},
},
looks={drawings={text="Look_brasskids_drawings"}},
},
brasswarden={
folk={
{sprite="lamplighter",name="oldwarden",talk={
{when={max=9},say="Home_brasswarden1"},
{when={max=18},say="Home_brasswarden2"},
{say="Home_brasswarden3"},
}},
},
looks={lanterns={text="Look_brasswarden_lanterns"}},
},
brasssunk={
folk={},
looks={pipe={text="Look_brasssunk_pipe"}},
},
brasscustoms={
folk={
{sprite="clerk",name="customs",talk={
{when={max=9},say="Home_brasscustoms1"},
{when={max=18},say="Home_brasscustoms2"},
{say="Home_brasscustoms3"},
}},
},
looks={taxes={text="Look_brasscustoms_taxes"}},
},

glimclerk={
folk={
{sprite="clerk",name="councilclerk",talk={
{when={max=12},say="Home_glimclerk1"},
{when={max=20},say="Home_glimclerk2"},
{say="Home_glimclerk3"},
}},
},
looks={forms={text="Look_glimclerk_forms"}},
},
glimglass={
folk={
{sprite="woman",name="glassblower",talk={
{when={max=12},say="Home_glimglass1"},
{when={max=20},say="Home_glimglass2"},
{say="Home_glimglass3"},
}},
},
looks={globes={text="Look_glimglass_globes"}},
},
glimash={
folk={
{sprite="liss",name="liss",show={min=21},talk={
{say="Home_glimash1"},
}},
},
looks={toys={text="Look_glimash_toys"},bed={text="Look_glimash_bed"},desk={text="Look_glimash_desk"}},
},
glimscholar={
folk={
{sprite="elder",name="scholar",talk={
{when={max=12},say="Home_glimscholar1"},
{when={max=20},say="Home_glimscholar2"},
{say="Home_glimscholar3"},
}},
},
looks={plaques={text="Look_glimscholar_plaques"}},
},
glimwidow={
folk={
{sprite="woman",name="guardwidow",talk={
{when={notFlag="h_widow"},script="home_widow_gift"},
{when={max=18},say="Home_glimwidow3"},
{say="Home_glimwidow4"},
}},
},
looks={uniform={text="Look_glimwidow_uniform"}},
},
glimbarracks={
folk={
{sprite="guard",name="guard",talk={
{when={max=12},say="Home_glimbarracks1"},
{when={max=20},say="Home_glimbarracks2"},
{say="Home_glimbarracks3"},
}},
},
looks={bunk={text="Look_glimbarracks_bunk"}},
},
glimguild={
folk={
{sprite="smith",name="lampmaker",talk={
{when={max=12},say="Home_glimguild1"},
{when={max=20},say="Home_glimguild2"},
{say="Home_glimguild3"},
}},
},
looks={bench={text="Look_glimguild_bench"}},
},

farrowgorse={
folk={
{sprite="woman",name="gorsewife",talk={
{when={max=20},say="Home_farrowgorse1"},
{say="Home_farrowgorse2"},
}},
},
looks={rations={text="Look_farrowgorse_rations"}},
},
farrowmother={
folk={
{sprite="elder",name="mother",talk={
{when={flag="q_deserterhome"},say="Home_farrowmother2"},
{when={flag="q_desertergone"},say="Home_farrowmother3"},
{say="Home_farrowmother1"},
}},
},
looks={chair={text="Look_farrowmother_chair"}},
},
farrowbell={
folk={
{sprite="elder",name="learner",talk={
{when={max=20},say="Home_farrowbell1"},
{say="Home_farrowbell2"},
}},
},
looks={handbell={text="Look_farrowbell_handbell"}},
},
farrowgone={
folk={},
looks={note={text="Look_farrowgone_note"}},
},
farrowbarn={
folk={
{sprite="farmer",name="farmhand",talk={
{when={max=20},say="Home_farrowbarn1"},
{say="Home_farrowbarn2"},
}},
},
looks={sacks={text="Look_farrowbarn_sacks"}},
},

mothnames={
folk={
{sprite="mothfolk",name="namekeeper",talk={
{when={max=18},say="Home_mothnames1"},
{say="Home_mothnames2"},
}},
},
looks={register={text="Look_mothnames_register"}},
},
mothweaver={
folk={
{sprite="mothfolk",name="weaver",talk={
{when={notFlag="h_weaver"},script="home_weaver_gift"},
{when={max=18},say="Home_mothweaver3"},
{say="Home_mothweaver4"},
}},
},
looks={loom={text="Look_mothweaver_loom"}},
},
mothwenna={
folk={},
looks={cradle={text="Look_mothwenna_cradle"}},
},
mothnim={
folk={},
looks={drawings={text="Look_mothnim_drawings"}},
},
mothsleeper={
folk={},
looks={cocoon={script="home_sleeper"}},
},
}

local j={
{village="tallowby",x=22,y=3,text="Knock_tallowby"},
{village="wickhollow",x=22,y=22,text="Knock_wickhollow"},
{village="brassmouth",x=35,y=24,text="Knock_brassmouth1"},
{village="brassmouth",x=3,y=24,text="Knock_brassmouth2"},
{village="glimmerhold",x=38,y=27,text="Knock_glimmerhold1"},
{village="glimmerhold",x=3,y=19,text="Knock_glimmerhold2"},
{village="farrow",x=4,y=13,text="Knock_farrow"},
{village="mothgrove",x=4,y=15,text="Knock_mothgrove"},
}

local function f(village,x,y)
for b,a in ipairs(c[village].objects)do
if a.kind=="house"and a.x==x and a.y==y then
return a
end
end
error("Lanterways: no house at "..x..","..y.." in "..village)
end

local function k(layout,home)
local b={}
for d,a in ipairs(home.folk)do
b[d]={
id=layout.id..d,sprite=a.sprite,name=a.name,x=layout.npc.x,y=layout.npc.y,
dir="down",show=a.show,talk=a.talk,
}
end
return b
end

local function l(layout,home)
local a={}
for g,b in pairs(layout.looks)do
local d=home.looks[g]
a[#a+1]={x=b.x,y=b.y,text=d.text,script=d.script}
end
return a
end

local function m(layout)
if layout.page then
return{{x=layout.page.x,y=layout.page.y,page=layout.page.id}}
end
return{}
end

for n,a in ipairs(e.HomeLayout)do
local g=i[a.id]
local d=c[a.village]
local b=f(a.village,a.houseX,a.houseY)
b.to,b.tx,b.ty,b.dir=a.id,a.doorX,a.doorY-1,"up"
c[a.id]={
rows=h[a.id],
place=d.place,
music=d.music,
musicLate=d.musicLate,
nightWhen=d.nightWhen,
npcs=k(a,g),
signs=l(a,g),
notes=m(a),
warps={
{x=a.doorX,y=a.doorY,w=2,h=1,to=a.village,tx=b.x+b.door,ty=b.y+b.h,dir="down"},
},
}
end

for g,a in ipairs(j)do
local b=c[a.village]
local d=f(a.village,a.x,a.y)
b.signs=b.signs or{}
b.signs[#b.signs+1]={x=d.x+d.door,y=d.y+d.h-1,text=a.text}
end
