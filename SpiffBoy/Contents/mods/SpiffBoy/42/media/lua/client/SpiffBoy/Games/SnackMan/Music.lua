require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a={}
SpiffBoy.SnackMan.Music=a

a.TITLE="title"
a.START="start"
a.PLAY="play"
a.FRIGHT="fright"
a.CLEAR="clear"
a.OVER="over"
a.DEATH="death"
a.CHOMP={"chomp1","chomp2"}
a.BAT="bat"
a.WHACK="whack"
a.FOOD="food"
a.LIFE="life"
a.TICK="tick"
a.CONFIRM="confirm"
a.STEP="step"

local d={"c","d","e","f","g","a","b",">c",">d",">e",">f"}
a.MIX_STEPS=#d-1

local h="v9 y1 n{48 80 113}"
local c="v3 y1 n80"
local i=h.." "..c.." r "..c.." r "..c.." r "..c

local function b(e,f)
return e..table.concat(f," | ")
end

local function e(g,j)
local f={}
for k=1,j do
f[k]=g
end
return f
end

local f={
[a.TITLE]={
loop=true,
pulse1=b("t132 @2 v11 y0 q7 l8 ",{
"o4 g4 b o5 d e4 d o4 b","o5 c4 o4 a f+ g2","o4 g4 b o5 d g4 f+ e","o5 d2. r4",
"o5 e4 d c o4 b4 a g","o4 a4 b o5 c d4 o4 b4","o5 c4 o4 b a g4 f+ a","o4 g2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=b("t132 @12 v3 l4 o2 ",{
"g >d< g >d<","c g d a","g >d< g >d<","d a d a",
"c g c g","d a g >d<","c g d a","g >d< g r",
}),
noise=b("t132 l4 ",e("r v3 y1 n80 r n80",8)),
},
[a.START]={
pulse1=b("t150 @2 v12 y0 q7 l8 ",{"o4 g b o5 d g4 d o4 b g","o4 a o5 c e f+4 e c o4 a","o4 b o5 d g b4 a f+ d","o5 g2 r2"}),
pulse2={echo="pulse1",delay=16,drop=5},
wave=b("t150 @12 v3 l4 o2 ",{"g >d< g >d<","d a d a","g >d< d a","g2 r2"}),
noise="t150 l8 [v10 y1 n{48 80 113} r v8 y2 n64 r]6 | l2 v12 y5 n{16 32 48} r",
},
[a.PLAY]={
loop=true,
pulse1=b("t140 @2 v10 y0 q7 l8 ",{
"r1","r1","r1","r1",
"o4 e4 g4 b4 a g","o4 f+2 e4 r4","o4 e4 g4 o5 c4 o4 b a","o4 b2 r2",
}),
pulse2=b("t140 @2 v5 y0 q8 x2 l1 o3 ",{"{egb}","{egb}","{ceg}","{df+a}","{egb}","{egb}","{ceg}","{d+f+b}"}),
wave=b("t140 @12 v3 l8 ",{
"o2 e e o3 e o2 e g e o3 d o2 e","o2 e e o3 e o2 e g e o3 d o2 e","o2 c c o3 c o2 c e c g c","o2 d d o3 d o2 d f+ d a d",
"o2 e e o3 e o2 e g e o3 d o2 e","o2 e e o3 e o2 e g e o3 d o2 e","o2 c c o3 c o2 c e c g c","o1 b b o2 b o1 b o2 d+ o1 b o2 f+ o1 b",
}),
noise=b("t140 l8 ",e(i,8)),
},
[a.FRIGHT]={
loop=true,
pulse1="t180 @1 v9 y0 q7 l16 o4 [g >c e c<]8",
wave="t180 @12 v3 l8 o2 [c g]8",
noise="t180 l8 [v6 y1 n64 r]8",
},
[a.CLEAR]={
pulse1="t160 @2 v12 y0 q7 l16 o5 e g >c< g >c e g8 g4 r4",
pulse2="t160 @1 v7 y0 q7 l16 o4 g >c e c e g e8 e4 r4",
wave="t160 @12 v3 l8 o2 c g >c< g c4 r4",
},
[a.OVER]={
pulse1="t96 @2 v11 y0 q7 l8 o4 b a g e f+4 d+4 | o4 e2. r4",
pulse2="t96 @1 v7 y0 q7 l8 o4 g f+ e c d+4 o3 b4 | o3 b2. r4",
wave="t96 @12 v3 l4 o2 e c o1 b o2 b | e2. r4",
},
[a.DEATH]={
pulse1="t120 @2 v12 y2 l16 o5 c o4 b b- a a- g g- f e e- d d- c4",
noise="t240 l16 v12 y2 n{64 96 113} r r r v8 y3 n{96 113}",
},
chomp1={noise="t240 l32 v6 y1 n32"},
chomp2={noise="t240 l32 v6 y1 n48"},
[a.BAT]={pulse2="t200 @2 v11 y2 l32 o4 g >c e g >c"},
[a.WHACK]={noise="t240 l16 v13 y2 n{48 80 113}",pulse2="t240 @2 v11 y1 l32 o5 c e g >c e"},
[a.FOOD]={pulse2="t240 @2 v10 y1 l32 o5 e g >c< g >c e"},
[a.LIFE]={pulse2="t200 @2 v11 y0 l16 o5 c e g >c4"},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 g"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 c e g"},
}

for g=0,a.MIX_STEPS do
f[a.STEP..g]={pulse2="t240 @2 v10 y1 l16 o5 "..d[g+1]}
end

SpiffBoy.Tunes.register("SnackMan",f)
