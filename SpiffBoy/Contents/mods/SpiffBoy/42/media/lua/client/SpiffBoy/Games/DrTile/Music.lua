require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.DrTile=SpiffBoy.DrTile or{}

local a={}
SpiffBoy.DrTile.Music=a

a.TITLE="title"
a.TRACKS={"musicA","musicB"}
a.START="start"
a.REPAIRED="repaired"
a.OVER="over"
a.LOSE="lose"
a.TICK="tick"
a.CONFIRM="confirm"
a.STEP="step"
a.MOVE="move"
a.ROTATE="rotate"
a.LOCK="lock"
a.THROW="throw"
a.POP="pop"
a.RISE="rise"
a.HEAL="heal"

local n={"d","e","f+","g","a","b",">c+",">d",">e",">f+",">g"}
local o={"c e g >c","d f+ a >d","e g+ b >e","f+ a+ >c+ f+"}
a.MIX_STEPS=#n-1
a.POP_LEVELS=#o

local f="v11 y1 n{48 80 113}"
local i="v8 y2 n64"
local j="v3 y1 n80"
local b=f.." r "..j.." "..f.." "..i.." r "..j.." r"
local p=f.." r "..i.." r "..i.." n64 v9 y2 n64 n64"
local g="r r "..j.." r r r "..j.." r"
local h=f.." r "..j.." r "..i.." r "..j.." r"

local function e(c,d)
return c..table.concat(d," | ")
end

local function c(d)
return d.." r "..d.." >"..d.."< r "..d.." >"..d.."< r"
end

local function l(d)
return d.." r "..d.." >"..d.."<"
end

local function q(d,m,k)
if m then
return">"..d..k.."<"
end
return d..k
end

local function d(k,m,r)
return k.."4. "..k.." "..q(m,r,"4").." r4"
end

local function k(m,r,s)
return m.."4 "..q(r,s,"4")
end

local s={
loop=true,
pulse1=e("t150 @2 v11 y0 q7 l8 ",{
"o4 d g r b r a g4","o4 e g r b o5 c4 o4 b4","o4 e4 g r o5 c r o4 b a","o4 f+2 a4 r4",
"o4 d g r b r a g4","o4 e g r b o5 d4 c o4 b","o4 a4 o5 c o4 a f+4 a4","o4 g2. r4",
"o4 g4 o5 c r c d e4","o5 d4 o4 b r b o5 c d4","o5 c4 o4 a r a b o5 c4","o5 d2 o4 a4 f+4",
"o5 e4 g r g a g4","o5 f+4 d r d e f+4","o5 e4 c o4 a o5 d4 c o4 b","o4 g2. r4",
}),
pulse2=e("t150 @2 v6 y0 q8 x1 l1 o3 ",{
"{gb>d}","{egb}","{ceg}","{df+a}","{gb>d}","{egb}","{ace}2 {df+a}2","{gb>d}",
"{ceg}","{df+b}","{ace}","{df+a}","{ceg}","{df+b}","{ace}2 {df+a}2","{gb>d}",
}),
wave=e("t150 @5 v3 l8 o2 ",{
c("g"),c("e"),c("c"),c("d"),
c("g"),c("e"),l("a").." "..l("d"),c("g"),
c("c"),c("b"),c("a"),c("d"),
c("c"),c("b"),l("a").." "..l("d"),c("g"),
}),
noise=e("t150 l8 ",{
b,b,b,b,b,b,b,p,
b,b,b,b,b,b,b,p,
}),
}

local t={
loop=true,
pulse1=e("t112 @1 v10 y0 q8 l8 ",{
"o4 r4 a o5 c d4 c o4 a","o4 b2 g4 f4","o4 e2. r4","o4 r a g e g4 a4",
"o4 r4 a o5 c f4 e d","o5 d4 o4 b4 g4 f4","o4 g4 e4 c+4 e4","o4 d2. r4",
"o4 a4 o5 c4 e2","o5 d4 o4 b4 g2","o4 f a o5 c e d4 c o4 a","o4 b2 r4 g4",
"o5 c4 e4 g4 f e","o5 d2 c+2","o5 d4 c o4 a g4 f4","o4 e2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=e("t112 @12 v3 l8 o2 ",{
d("d","a"),d("g","d",true),d("c","g"),d("a","e",true),
d("d","a"),d("g","d",true),k("e","b").." "..k("a","e",true),d("d","a"),
d("f","c",true),d("e","b"),d("d","a"),d("g","d",true),
d("f","c",true),k("e","b").." "..k("a","e",true),k("d","a").." "..k("g","d",true),d("c","g"),
}),
noise=e("t112 l8 ",{
g,g,g,g,g,g,g,g,
h,h,h,h,h,h,h,h,
}),
}

local m={
[a.TITLE]={
loop=true,
pulse1=e("t120 @2 v10 y0 q7 l8 ",{
"o4 e g o5 c4 o4 b g e4","o4 a2 g e c4","o4 f a o5 c4 d c o4 a4","o4 g2. r4",
"o4 e g o5 c4 e d c4","o5 c2 o4 a g a4","o4 f4 a4 b4 o5 d4","o5 c2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=e("t120 @12 v3 l4 o2 ",{
"c g c g","a >e< a >e<","f >c< f >c<","g >d< g >d<",
"c g c g","a >e< a >e<","d a g >d<","c2. r4",
}),
},
[a.TRACKS[1]]=s,
[a.TRACKS[2]]=t,
[a.START]={
pulse1="t180 @2 v11 y2 l16 o4 g >c e g8",
pulse2={echo="pulse1",delay=16,drop=4},
},
[a.REPAIRED]={
pulse1="t150 @2 v12 y0 q7 l8 o4 g o5 c e g4 e g4 | o5 c2 r2",
pulse2="t150 @1 v7 y0 q7 l8 o4 e g o5 c e4 c e4 | o4 g2 r2",
wave="t150 @12 v3 l4 o2 c g c g | c2 r2",
noise="t150 l8 "..f.." r "..i.." r "..f.." "..f.." "..i.." r | "..f.." r r r r r r r",
},
[a.OVER]={
pulse1="t100 @2 v11 y0 q7 l8 o4 e d c o3 b a4 g+4 | o3 a2. r4",
pulse2="t100 @1 v7 y0 q7 l8 o4 c o3 b a g+ e4 e4 | o3 e2. r4",
wave="t100 @12 v3 l4 o2 a e f e | a2. r4",
},
[a.LOSE]={
pulse2="t140 @1 v11 y3 l16 o5 c o4 b a+ a g+ g f+ f e d+ d c+",
noise="t140 l2 v9 y3 n{32 64 96 113}",
},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 e"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 d f+ a"},
[a.MOVE]={noise="t240 l64 v5 y1 n32"},
[a.ROTATE]={pulse2="t240 @2 v7 y1 l32 o5 c g"},
[a.LOCK]={noise="t240 l32 v10 y2 n{64 113}"},
[a.THROW]={pulse1="t240 @2 v8 y2 s2,4 l16 o4 g"},
[a.RISE]={
pulse2="t200 @1 v9 y2 l16 o3 c o2 g",
noise="t160 l8 v11 y3 n{113 112 113}",
},
[a.HEAL]={pulse2="t240 @2 v9 y2 l32 o5 g >c e"},
}

for r=0,a.MIX_STEPS do
m[a.STEP..r]={pulse2="t240 @2 v10 y1 l16 o5 "..n[r+1]}
end

for r=1,a.POP_LEVELS do
m[a.POP..r]={
pulse2="t220 @2 v10 y2 l32 o5 "..o[r],
noise="t220 l16 v8 y2 n{16 32 64}",
}
end

SpiffBoy.Tunes.register("DrTile",m)
