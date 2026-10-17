require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local a={}
SpiffBoy.BrickBash.Music=a

a.TITLE="title"
a.TRACKS={"musicA","musicB"}
a.START="start"
a.CLEAR="clear"
a.ALL_CLEAR="allClear"
a.OVER="over"
a.LOSE="lose"
a.TICK="tick"
a.CONFIRM="confirm"
a.LAUNCH="launch"
a.PLANK="plank"
a.WALL="wall"
a.BRICK="brick"
a.TOUGH="tough"
a.METAL="metal"
a.EXPLODE="explode"
a.CATCH="catch"
a.LIFE="life"
a.STICK="stick"

local f="v10 y1 n{48 80 113}"
local h="v8 y2 n64"
local g="v3 y1 n80"
local b="r r "..g.." r r r "..g.." r"
local e=f.." r "..g.." r "..h.." r "..g.." r"
local k=f.." r "..h.." r "..h.." "..h.." v9 y2 n64 n64"

local function c(d,i)
return d..table.concat(i," | ")
end

local function d(i)
return i.." "..i.." r "..i.." >"..i.."< r "..i.." r"
end

local function i(j)
return j.." "..j.." r "..j
end

local function l(m,n)
local j={}
for o=1,n do
j[o]=m
end
return j
end

local j={
loop=true,
pulse1=c("t150 @2 v11 y0 q7 l8 ",{
"o4 a4 o5 c o4 a e4 a4","o4 g4 b g d4 g4","o4 f4 a o5 c o4 b a g e","o4 e2 r4 e g+",
"o4 a4 o5 c o4 a e4 a4","o4 g4 b o5 d c4 o4 b4","o4 a o5 c e d c o4 b a g+","o4 a2. r4",
"o5 c4 e c o4 g4 o5 c4","o4 b4 o5 d o4 b g4 b4","o4 a4 o5 c e a4 g4","o5 f2 e2",
"o5 d4 f d o4 a4 o5 d4","o5 c4 e c o4 a4 o5 c4","o4 b o5 c d e d c o4 b g+","o4 a2. r4",
}),
pulse2=c("t150 @2 v6 y0 q8 x1 l1 o3 ",{
"{ace}","{gb>d}","{fa>c}","{eg+b}","{ace}","{gb>d}","{ace}2 {eg+b}2","{ace}",
"{ceg}","{gb>d}","{ace}","{fa>c}2 {ceg}2","{dfa}","{ace}","{eg+b}","{ace}",
}),
wave=c("t150 @5 v3 l8 o2 ",{
d("a"),d("g"),d("f"),d("e"),
d("a"),d("g"),i("a").." "..i("e"),d("a"),
d("c"),d("g"),d("a"),i("f").." "..i("c"),
d("d"),d("a"),d("e"),d("a"),
}),
noise=c("t150 l8 ",{
b,b,b,b,b,b,b,b,
e,e,e,e,e,e,e,k,
}),
}

local m={
loop=true,
pulse1=c("t112 @1 v10 y0 q8 l8 ",{
"o4 e4 g b o5 e4 d4","o5 c4 o4 b a b2","o4 a4 o5 c e d4 c4","o4 b2. r4",
"o4 e4 g b o5 e4 f+4","o5 g4 f+ e d2","o5 c4 o4 a f+ g4 a4","o4 e2. r4",
"o4 g4 b o5 d g4 f+4","o5 e4 d c o4 b2","o4 a4 o5 c e a4 g4","o5 f+2. r4",
"o5 e4 d o4 b o5 c4 o4 a4","o4 b4 a g f+2","o4 g4 a b o5 c4 d+4","o4 e2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=c("t112 @12 v3 l2 o2 ",{
"e b","a e","a e","b f+","e b","g d","d a","e b",
"g >d<","c g","a e","b f+","c g","b f+","c b","e b",
}),
noise=c("t112 l8 ",{
"r1","r1","r1","r1","r1","r1","r1","r1",
b,b,b,b,b,b,b,b,
}),
}

local n={
[a.TITLE]={
loop=true,
pulse1=c("t132 @2 v11 y0 q7 l8 ",{
"o4 c e g o5 c o4 b g e g","o4 a o5 c o4 a f e4 d4","o4 e g o5 c e d c o4 b o5 c","o5 d2 o4 g4 r4",
"o4 c e g o5 c o4 b g e g","o4 a o5 c e f e4 d4","o5 c o4 b a g f e d e","o4 c2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=c("t132 @12 v3 l4 o2 ",{
"c g c g","f >c< f >c<","a >e< a >e<","g >d< g >d<",
"c g c g","f >c< f >c<","f >c< g >d<","c2. r4",
}),
noise=c("t132 l4 ",l("r "..g.." r "..g,8)),
},
[a.TRACKS[1]]=j,
[a.TRACKS[2]]=m,
[a.START]={
pulse1="t160 @2 v11 y0 q7 l16 o4 c e g o5 c8 r8 o4 g8 o5 c4",
pulse2="t160 @1 v7 y0 q7 l16 o3 g o4 c e g8 r8 e8 g4",
wave="t160 @12 v3 l16 o2 c8. r8 c8 g8 c4",
},
[a.CLEAR]={
pulse1="t150 @2 v12 y0 q7 l16 o4 g a b o5 d g8 d8 g4 | o5 a8 g8 a8 b8 o6 c2",
pulse2="t150 @1 v7 y0 q7 l16 o4 d e g b o5 d8 o4 b8 o5 d4 | o5 e8 d8 e8 f+8 g2",
wave="t150 @12 v3 l4 o2 g >d< g | c d g2",
noise="t150 l8 "..f.." r "..h.." r "..f.." "..f.." | "..f.." r r r r r r r",
},
[a.ALL_CLEAR]={
pulse1=c("t132 @2 v12 y0 q7 l8 ",{
"o4 c e g o5 c4 o4 g o5 c e","o5 g4 e c d2","o5 e d c o4 a o5 c4 d e","o5 c2. r4",
}),
pulse2=c("t132 @1 v7 y0 q7 l8 ",{
"o3 g o4 c e g4 e g o5 c","o5 e4 c o4 g b2","o5 c o4 b a f a4 b o5 c","o4 g2. r4",
}),
wave=c("t132 @12 v3 l4 o2 ",{"c g c g","c g g >d<","f >c< g >d<","c2. r4"}),
noise=c("t132 l8 ",{e,e,k,f.." r r r r r r r"}),
},
[a.OVER]={
pulse1="t100 @2 v11 y0 q7 l8 o4 e g f d e c o3 b4 | o3 a2. r4",
pulse2="t100 @1 v7 y0 q7 l8 o4 c e d o3 b o4 c o3 a g+4 | o3 e2. r4",
wave="t100 @12 v3 l4 o2 a f e e | a2. r4",
},
[a.LOSE]={
pulse1="t120 @2 v12 y4 o5 c4 p24 o3 c2",
noise="t120 l2 v9 y3 n{32 64 96 113}",
},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 g"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 c e g"},
[a.LAUNCH]={pulse1="t200 @2 v10 y2 s3,6 l16 o4 c"},
[a.PLANK]={pulse2="t240 @2 v9 y2 l32 o4 g"},
[a.WALL]={pulse2="t240 @1 v6 y1 l64 o5 c"},
[a.BRICK]={pulse2="t240 @2 v9 y2 l32 o5 e"},
[a.TOUGH]={pulse2="t240 @1 v10 y2 l32 o4 a"},
[a.METAL]={
pulse2="t240 @3 v10 y3 l32 o6 c",
noise="t240 l64 v6 y1 n16",
},
[a.EXPLODE]={noise="t120 l4 v13 y4 n{32 48 64 80 96 113}"},
[a.CATCH]={pulse2="t200 @2 v10 y2 x2 l8 o4 {ceg>c}"},
[a.LIFE]={pulse2="t240 @2 v11 y1 l32 o5 c e g >c e g >c"},
[a.STICK]={pulse2="t240 @0 v9 y2 l32 o4 c o3 g"},
}

SpiffBoy.Tunes.register("BrickBash",n)
