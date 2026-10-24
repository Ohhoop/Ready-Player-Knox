require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local a={}
SpiffBoy.BrickDrop.Music=a

a.TITLE="title"
a.START="start"
a.OVER="over"
a.CLEARED="cleared"
a.ESCAPED="escaped"
a.TICK="tick"
a.CONFIRM="confirm"
a.STEP="step"
a.MOVE="move"
a.ROTATE="rotate"
a.LOCK="lock"
a.HOLD="hold"
a.CLEAR="clear"
a.QUAD="quad"
a.LEVEL="level"
a.LOSE="lose"
a.COUNT="count"
a.THUD="thud"
a.ROW="row"
a.BUILD="build"
a.BUILT="built"
a.GROWL="growl"
a.CHOMP="chomp"
a.TRUCK="truck"
a.FLIGHT="flight"
a.STAB="stab"
a.BANG="bang"

local k={"d","e","f+","g","a","b",">c+",">d",">e",">f+",">g"}
a.MIX_STEPS=#k-1

local d="v11 y1 n{48 80 113}"
local e="v8 y2 n64"
local i="v4 y1 n80"
local b=d.." r "..e.." r "..d.." r "..e.." r"
local c=d.." "..i.." "..e.." "..i.." "..d.." "..d.." "..e.." "..i
local l=d.." r "..e.." r "..e.." n64 v9 y2 n64 n64"

local o={
tempo=150,
fast=188,
voices={
pulse1={
header="@2 v12 y0 q7 l8 o5 ",
bars={
"e4 <b >c d4 c <b","<a4 a >c e4 d c","<b4. >c d4 e4","c4 <a4 a4 r4",
"r d4 f a4 g f","e4. c e4 d c","<b4 b >c d4 e4","c4 <a4 a4 r4",
"<e2 c2","<d2 <b2","<c2 <a2","<<g+2 b2",
"<e2 c2","<d2 <b2","<c4 e4 a2","<g+2 r2",
},
},
pulse2={
header="@1 v8 y0 q7 l8 o5 ",
bars={
"c4 <g+ a b4 a g+","<e4 e a >c4< b a","<g+4. a b4 >c4<","<a4 e4 e4 r4",
"r <b4 >d f4 e d","c4.< a >c4< b a","<g+4 g+ a b4 >c4<","<a4 e4 e4 r4",
"v6 x1 o3 {ace}1","v6 x1 o3 {gb>d}1","v6 x1 o3 {ace}1","v6 x1 o3 {eg+b}1",
"v6 x1 o3 {ace}1","v6 x1 o3 {gb>d}1","v6 x1 o3 {ace}1","v6 x1 o3 {eg+b}1",
},
},
wave={
header="@12 v3 l8 o2 ",
bars={
"[a>e<]4","[a>e<]4","[eb]4","[a>e<]4","[da]4","[a>e<]4","[eb]4","[a>e<]4",
"[a>e<]4","[g>d<]4","[a>e<]4","[eb]4","[a>e<]4","[g>d<]4","[a>e<]4","[eb]4",
},
},
},
order={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16},
}

local p={
tempo=160,
fast=200,
voices={
pulse1={
header="@2 v11 y0 q7 l8 o4 ",
bars={
"d4 f a >d4< a f","e f g e f4 d4","b-4 a b- >d4< b-4",">c4.< b- a4 g4",
"a4 f a >d e f4",">e d c+ d< a4 f4","g b- a g f4 e4","d2. r4",
"@1 >c4 c d c4< a4","@1 g4 g a g4 e4","@1 f4 f g a4 >d4","@1 >c d c< b- a4 f4",
"@1 g4 b- >d g4 f e","@1 >f4 e d< a4 f4","d e f g e4 c+4","e2. r4",
},
},
pulse2={
header="@2 v6 y2 q4 x1 l8 o3 ",
bars={
"[r {fa>d}]4","[r {fa>d}]4","[r {b->df}]4","[r {eg>c}]4",
"[r {fa>d}]4","[r {fa>d}]4","[r {gb->d}]2 [r {a>c+e}]2","[r {fa>d}]2 r2",
"[r {fa>c}]4","[r {eg>c}]4","[r {fa>d}]4","[r {b->df}]4",
"[r {gb->d}]4","[r {fa>d}]4","[r {b->df}]2 [r {a>c+e}]2","[r {a>c+e}]2 r2",
},
},
wave={
header="@5 v3 l8 o2 ",
bars={
"[d>d<]4","[d>d<]4","[b->b-<]4","[c>c<]4",
"[d>d<]4","[d>d<]4","[g>g<]2 [a>a<]2","d2 a2",
"[f>f<]4","[c>c<]4","[d>d<]4","[b->b-<]4",
"[g>g<]4","[d>d<]4","[b->b-<]2 [a>a<]2","[a>a<]2 a2",
},
},
noise={
header="l8 ",
bars={
b,b,b,b,
b,b,b,l,
c,c,c,c,
c,c,c,l,
},
},
},
order={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16},
}

local q={
tempo=144,
fast=180,
voices={
pulse1={
header="@2 v11 y0 q7 l8 ",
bars={
"o4 d f+ b f+ c+ f+","o4 d f+ <b >f+ <a+ >f+","o3 b >f+ b f+ c+ f+","o4 d f+ <b >f+ <a+ >f+",
"o4 d f+ d <b >g e","o4 c+ e c+ <a >f+ d","o3 b >f+ e d c+ <b","o3 a+ f+ a+ >c+ f+ e",
"o4 d f+ b f+ c+ f+","o4 d f+ <b >f+ <a+ >f+","o3 b >f+ b f+ c+ f+","o4 d f+ <b >f+ <a+ >f+",
"o4 d f+ d <b >g e","o4 c+ e c+ <a >a e","o4 f+ a f+ d <a >c+","o4 d2.",
"o4 a g f+ e d c+","o4 d e f+ d e g","o4 f+ g a4 c+4","o4 d4 f+4 e4",
"o4 f+4 b4 g+4","o3 b >c+ d4 c+4","o3 b a g+ f+ g+ e+","o3 f+2.",
"o3 a4. b16 >c16 <b4","o3 a g a f+ g e","o3 b4. >c+16 d16 c+4","o3 b a+ b g+ a+ f+",
"o4 e c+ <f+ >c+ e f+","o4 g c+ f+ c+ e c+","o4 d <b f+ b >d <b","o4 f+ <b >e <b >d <b",
"o4 c+ <b >d <b >e <b","o4 f+ <b >g <b >e <b","o4 f+4 e d c+ d","o3 b2.",
},
},
pulse2={
header="@1 v5 y0 q6 l4 ",
bars={
"o3 b <b >a+","o3 b >d f+","o4 d <b a+","o3 b d f+",
"o2 b >b e","o2 a >a d","o2 g >g e","o3 f+8 g8 f+8 e8 d8 c+8",
"o2 b >b a+","o3 b >d f+","o4 d <b a+","o3 b d f+",
"o2 b >b e","o2 a >a c+","o3 d f+ a","o3 d <a d",
"o3 f+8 a8 >d8 <a8 >c+8 <a8","o3 f+8 a8 d8 a8 c+8 a8","o3 d8 a8 >d8 <a8 >c+8 <a8","o3 f+8 a8 d8 a8 c+8 a8",
"o3 d8 f+8 d8 <b8 >b8 g+8","o3 e+8 g+8 e+8 c+8 g+8 e+8","o3 f+ >c+ <c+","o3 f+8 a8 >c+8 <a8 e8 a8",
"o3 d+8 f+8 <b8 >f+8 d+8 f+8","o3 e <b e","o3 e+8 g+8 c+8 g+8 e+8 g+8","o3 f+ c+ <f+",
"o2 a+ >c+ f+","o3 a+ f+ a+","o2 b >d f+","o3 b >c+ d",
"o4 e f+ g","o4 d e c+","o4 d e f+","o3 b f+ <b",
},
},
wave={
header="@12 v3 l4 ",
bars={
"o2 b <b >a+","o2 b >d f+","o3 d <b a+","o2 b d f+",
"o1 b >b e","o1 a >a d","o1 g >g e","o2 f+8 g8 f+8 e8 d8 c+8",
"o1 b >b a+","o2 b >d f+","o3 d <b a+","o2 b d f+",
"o1 b >b e","o1 a >a c+","o2 d f+ a","o2 d <a d",
"o2 f+8 a8 >d8 <a8 >c+8 <a8","o2 f+8 a8 d8 a8 c+8 a8","o2 d8 a8 >d8 <a8 >c+8 <a8","o2 f+8 a8 d8 a8 c+8 a8",
"o2 d8 f+8 d8 <b8 >b8 g+8","o2 e+8 g+8 e+8 c+8 g+8 e+8","o2 f+ >c+ <c+","o2 f+8 a8 >c+8 <a8 e8 a8",
"o2 d+8 f+8 <b8 >f+8 d+8 f+8","o2 e <b e","o2 e+8 g+8 c+8 g+8 e+8 g+8","o2 f+ c+ <f+",
"o1 a+ >c+ f+","o2 a+ f+ a+","o1 b >d f+","o2 b >c+ d",
"o3 e f+ g","o3 d e c+","o3 d e f+","o2 b f+ <b",
},
},
},
order={
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
},
}

a.TRACKS={o,p,q}

local r="o4 f+8 g8 a4 g4 | o5 c4 <b4 a4 | o4 g4 b8 a8 g8 f+8 | o4 a8 g8 f+8 g8 e8 g8"
.." | o4 a+8 b8 >c+8 <a+8 b8 >d8 | o5 e16 f+16 g8 f+4. e8 | o5 d8 c+8 e8 d8 c+8 <b8 | o5 f+2."
local s="o4 a4 f+4 e4 | o4 d+2. | o4 e4 f+4 g4 | o4 c+8 <b8 >d8 c+8 <b8 a8"
.." | o4 d8 e8 f+8 d8 e8 g8 | o4 b4 a4 g4 | o4 f+8 e8 g8 f+8 e8 f+8 | o4 d2."
.." | o4 a8 g8 f+4 g4 | o4 e4 f+4 g4 | o4 f+4 e8 d8 c+8 <b8 | o3 b8 a+8 g+8 a+8 f+8 a+8"
.." | o4 c+8 d8 e8 c+8 d8 f+8 | o4 g4 f+4 e4 | o4 d8 c+8 e8 d8 c+8 d8 | o3 b2."
local t="o4 d4 d+4 e4 | o4 f+2. | o4 e2 d+4 | o4 e2."
.." | r4 o4 e4 d4 | r4 r8 o5 c+8 <f+4 | o4 b2. | o4 a+2."
local u="o4 c+4 c4 <b4 | o3 b8 a8 a8 g8 g8 f+8 | o3 b2. | r4 o3 e4 g4"
.." | o3 f+8 g8 a4 g4^4 | o3 f+4 e4 | o3 d4 >d4 c+4 | o4 d2."
.." | o4 f+8 e8 d4 e4 | o4 c+4 d4 e4^8 | o4 d8 c+8 <b8 a+8 b8 | r4 o3 b4 a+4^8"
.." | o3 b8 >c+8 <a+8 b8 >d8 | o3 e4 d4 c+4 | o3 b4 >b4 a+4 | o3 b2."
local v="o2 b2. | o2 d+2. | o2 e4 <a4 b4 | o1 e4 b4 >e4"
.." | o2 g2. | o1 a+2. | o1 b4 a4 g4 | o1 f+2."
local w="o2 f+8 g8 a4 g4 | o3 c4 <b4 a4 | o2 g8 f+8 a8 g8 f+8 e8 | o2 a2.^2.^4"
.." | o2 b4 >c+4 | o3 d4 <g4 a4 | o2 d4 <a4 d4"
.." | o2 d8 e8 f+8 e8 f+8 g8 | o2 a8 b8 >c+8 <b8 a+8 >c+8 | o2 d4 g4 e4 | o2 f+2.^2.^4"
.." | o2 g+4 a+4 | o2 b4 e4 f+4 | o1 b2."

local function j(header,first,second)
return header.."["..first.."]2 ["..second.."]2"
end

local g={
[a.TITLE]={
loop=true,
pulse1=j("t100 @2 v10 y0 q8 ~1,8,12 l8 ",r,s),
pulse2=j("t100 @1 v6 y0 q8 l8 ",t,u),
wave=j("t100 @12 v3 l4 ",v,w),
},
[a.START]={
pulse1="t180 @2 v11 y2 l16 o4 b >d f+ b8",
pulse2={echo="pulse1",delay=16,drop=4},
},
[a.OVER]={
pulse1="t110 @2 v11 y0 q7 l8 o4 f+ e d c+ <b4 a+4 | b2.",
pulse2="t110 @1 v7 y0 q7 l8 o4 d c+ <b a+ g4 f+4 | f+2.",
wave="t110 @12 v3 l4 o2 b g f+ f+ | b2.",
},
[a.CLEARED]={
pulse1="t150 @2 v12 y0 q7 l8 o5 d d d4 d f+ a4 | g f+ e4 f+2 | @1 a4 b8 a8 g8 f+8 e8 g8 | f+2. r4",
pulse2="t150 @2 v7 y0 q7 l8 o4 a a a4 a >d f+4< | b a g4 a2 | >f+4 g8 f+8 e8 d8 c+8 e8 | d2. r4",
wave="t150 @12 v3 l4 o2 d >d< d >d< | g a d d | g a a a | d2. r4",
noise="t150 l8 [v11 y1 n{48 80 113} r v8 y2 n64 r]6 v8 y2 n64 n64 v9 y2 n64 n64 v11 y1 n{48 80 113} r r r",
},
[a.ESCAPED]={
pulse1="t104 @2 v12 y0 q7 ~1,8,16 l8 o5 e4 <b >c+ d4 c+ <b | a4 a >c+ e4 d c+ | <b4. >c+ d4 e4 | c+4 <a4 a2"
.." | @1 >f+4. g+16 a16 b4 a4 | g+4 e4 a2 | f+4 d4 e4 c+4 | <a1",
pulse2="t104 @1 v7 y0 q8 l2 o4 c+ e | c+ e | d e | c+ e | d f+ | e c+ | d e | c+1",
wave="t104 @12 v3 l4 o2 a >e< a >e< | f+ >c+< f+ >c+< | e b e b | a >e< a >e<"
.." | d a d a | e b a >e< | d a e b | a1",
noise="t104 l4 r1 r1 r1 r1 [v11 y1 n{48 80 113} r v8 y2 n64 r]3 v9 y2 n64 n64 n64 n64",
},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 e"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 d f+ a"},
[a.MOVE]={noise="t240 l64 v5 y1 n32"},
[a.ROTATE]={pulse2="t240 @2 v7 y1 l32 o5 c g"},
[a.LOCK]={noise="t240 l32 v10 y2 n{64 113}"},
[a.HOLD]={pulse2="t240 @1 v8 y1 l32 o5 g d"},
[a.CLEAR]={
pulse2="t220 @2 v10 y2 l32 o5 c e g >c",
noise="t220 l16 v8 y2 n{16 32 64}",
},
[a.QUAD]={
pulse1="t200 @2 v12 y2 l32 o4 c e g >c e g >c8",
pulse2="t200 @1 v9 y2 l32 o4 g >c e g >c e g8",
noise="t200 l8 v11 y3 n{16 32 48 64}",
},
[a.LEVEL]={pulse1="t200 @2 v11 y1 l16 o5 g a b >d8"},
[a.LOSE]={
pulse2="t140 @1 v11 y3 l16 o5 b a+ a g+ g f+ f e d+ d c+ c",
noise="t140 l2 v9 y3 n{32 64 96 113}",
},
[a.COUNT]={pulse2="t240 @2 v7 y1 l64 o6 c"},
[a.THUD]={noise="t240 l16 v12 y2 n{48 80 113}"},
[a.ROW]={pulse2="t240 @2 v6 y2 l32 o5 e g b"},
[a.BUILD]={
noise="t240 l32 v11 y2 n{32 64} r v9 y2 n{32 64} r",
pulse2="t240 @3 v7 y1 l32 o6 c r c r",
},
[a.GROWL]={noise="t120 l8 v7 u3 n{113 112 113 112 113} v10 y3 n{112 113 112 113}"},
[a.CHOMP]={noise="t240 l32 v12 y2 n{48 80} r v10 y2 n{48 80} r r v8 y3 n{64 113}"},
[a.BUILT]={pulse1="t200 @2 v11 y1 l16 o5 d f+ a >d8 <a >d4"},
[a.FLIGHT]={
pulse1="t170 @2 v10 y2 l16 o4 [d f a f]8 [c e g e]8 [b- d f d]8 [a c+ e c+]8",
pulse2="t170 @1 v8 y0 q8 l1 o5 d c <b- a >d c <b- a",
wave="t170 @5 v3 l8 o2 [d d >d< d]4 [c c >c< c]4 [b- b- >b-< b-]4 [a a >a< a]4",
noise="t170 l8 [v11 y1 n{48 80 113} v4 y1 n80 v8 y2 n64 v4 y1 n80]16",
},
[a.STAB]={noise="t240 l32 v11 y2 n{32 64} r v7 y2 n{64 113}"},
[a.BANG]={noise="t240 l16 v12 y3 n{80 113 112}"},
[a.TRUCK]={
pulse1="t140 @2 v12 y0 q7 l8 o5 d f+ a >d4 <a >d | e4 f+4 g4 a4 | @1 b2 >d2 r",
pulse2="t140 @1 v8 y0 q7 l8 o4 a >d f+ a4 f+ a | b4 >d4 e4 f+4 | g2 f+2 r",
noise="t140 l8 [v6 y1 n113]24",
wave="t140 @12 v3 l4 o2 d a d a | g b a >c+< | g2 d2",
},
}

for f=0,a.MIX_STEPS do
g[a.STEP..f]={pulse2="t240 @2 v10 y1 l16 o5 "..k[f+1]}
end

function a.barName(track,fast,bar)
local f="n"
if fast then
f="f"
end
return"music"..track..f.."_"..bar
end

local function m(track,tempo,bar)
local f={}
for n,h in pairs(track.voices)do
f[n]="t"..tostring(tempo).." "..h.header..h.bars[bar]
end
return f
end

for n,f in ipairs(a.TRACKS)do
for h=1,#f.voices.pulse1 .bars do
g[a.barName(n,false,h)]=m(f,f.tempo,h)
g[a.barName(n,true,h)]=m(f,f.fast,h)
end
end

SpiffBoy.Tunes.register("BrickDrop",g)
