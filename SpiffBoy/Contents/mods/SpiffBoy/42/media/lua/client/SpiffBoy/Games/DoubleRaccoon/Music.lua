require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.DoubleRaccoon=SpiffBoy.DoubleRaccoon or{}

local a={}
SpiffBoy.DoubleRaccoon.Music=a

a.TITLE="title"
a.STAGE={forest="forest",suburbs="suburbs",downtown="downtown",heart="heart"}
a.BOSS="boss"
a.FINAL="final"
a.ENDING="ending"
a.CLEAR="clear"
a.OVER="over"
a.TICK="tick"
a.CONFIRM="confirm"
a.STEP="step"
a.COUNT="count"
a.GO="go"
a.SHUTTER="shutter"

local n={"d","e","f+","g","a","b",">c+",">d",">e",">f+",">g"}
a.MIX_STEPS=#n-1

local c="v11 y1 n{48 80 113}"
local f="v8 y2 n64"
local h="v3 y1 n80"
local d=c.." r "..h.." "..c.." "..f.." r "..h.." r"
local j=c.." "..h.." "..f.." "..h.." "..c.." "..c.." "..f.." "..h
local o=c.." r "..f.." r "..f.." n64 v9 y2 n64 n64"
local g="r "..h.." r n80"

local function b(header,bars)
return header..table.concat(bars," | ")
end

local function l(root)
return root.." >"..root.."< "..root.." "..root.." >"..root.."< "..root.." "..root.." >"..root.."<"
end

local function e(pattern,count)
local i={}
for k=1,count-1 do
i[k]=pattern
end
i[count]=o
return i
end

local y={"a","a","f","g","a","a","f","e","d","a","f","g","d","a","e","e"}
local z={"{ace}","{ace}","{fa>c}","{gb>d}","{ace}","{ace}","{fa>c}","{eg+b}","{dfa}","{ace}","{fa>c}","{gb>d}","{dfa}","{ace}","{eg+b}","{eg+b}"}
local A={"e","e","e","c","c","d","a","b"}
local p={"d","g","d","a","d","g","a","d","g","d","e","d","g","d","a","d"}
local q={"g","c","g","d","g","c","f","g","c","f","c","g","c","d","d","g"}
local r={"d","b-","d","a","d","b-","a","d","d","f","g","d","d","a","a","d"}
local B={"c","c","c","g","a-","f","a-","g"}
local C={d="{df+a}",g="{gb>d}",a="{ac+e}",e="{egb}",c="{ce-g}",f="{fa>c}",["b-"]="{b->df}"}
local D="{dfa}"

local function k(roots)
local i={}
for m,s in ipairs(roots)do
i[m]=l(s)
end
return i
end

local function m(roots,minorD)
local i={}
for s,t in ipairs(roots)do
if t=="d"and minorD then
i[s]=D
else
i[s]=C[t]
end
end
return i
end

local function s(first,second)
local i={}
for u,t in ipairs(first)do
i[#i+1]=t
end
for u,t in ipairs(second)do
i[#i+1]=t
end
return i
end

local t={}
for i,u in ipairs(y)do
t[i]=l(u)
end
local i={}
for w,u in ipairs({e(d,8),e(d,8)})do
for x,v in ipairs(u)do
i[#i+1]=v
end
end
local u={}
local v={}
for w,x in ipairs(A)do
u[w]=l(x)
v[w]=j
end

local w={
[a.TITLE]={
loop=true,
pulse1=b("t120 @2 v11 y0 q7 l8 ",{
"o4 a4 o5 c d e4 d c","o5 d4 c o4 b a2","o4 f4 a o5 c f4 e d","o5 e2. r4",
"o4 a4 o5 c d e4 g e","o5 a4 g e d4 c o4 a","o4 b4 o5 c d e4 d o4 b","o4 a2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=b("t120 @12 v3 l4 o2 ",{
"a >e< a >e<","f >c< g >d<","f >c< f >c<","e b e b",
"a >e< a >e<","f >c< g >d<","g >d< e b","a2. r4",
}),
noise=b("t120 l4 ",{"r v3 y1 n80 r n80",g,g,g,g,g,g,g}),
},
[a.STAGE.forest]={
loop=true,
pulse1=b("t138 @2 v11 y0 q7 l8 ",{
"o4 a4 o5 c o4 b a e4 r","o4 a b o5 c d e4 d c","o5 c4 o4 a f a4 g f","o4 g2 b4 r4",
"o4 a4 o5 c o4 b a e4 r","o4 a b o5 c e a4 g e","o5 f4 e c o4 a4 f4","o4 e2 g+2",
"o4 d4 f a o5 d4 c o4 a","o4 c4 e a o5 c4 o4 b a","o4 f4 a o5 c f4 e c","o5 d2 o4 b4 g4",
"o5 d4 f e d4 c o4 a","o5 c4 e d c4 o4 b a","o4 b4 o5 c o4 b g+4 e4","o4 e2. r4",
}),
pulse2=b("t138 @2 v6 y0 q8 x1 l1 o3 ",z),
wave=b("t138 @5 v3 l8 o2 ",t),
noise=b("t138 l8 ",i),
},
[a.BOSS]={
loop=true,
pulse1=b("t160 @1 v11 y0 q6 l8 ",{
"o4 e e g e a e g e","o4 e e g e b a g f+","o4 e e g e a e g e","o4 e e g e o5 c o4 b a b",
"o5 e4 d c o4 b4 a g","o4 f+4 g a b4 a g","o5 c4 o4 b a g4 f+ g","o4 f+2 d+2",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=b("t160 @5 v3 l8 o2 ",u),
noise=b("t160 l8 ",v),
},
[a.STAGE.suburbs]={
loop=true,
pulse1=b("t144 @2 v11 y0 q7 l8 ",{
"o4 d4 f+ a o5 d4 c+ o4 a","o4 b4 g b o5 d4 c+ o4 b","o4 a4 f+ d e4 f+ g","o4 a2 r4 a4",
"o4 d4 f+ a o5 d4 e f+","o5 g4 f+ e d4 c+ o4 b","o4 a4 b o5 c+ d4 o4 a4","o5 d2. r4",
"o4 g4 b o5 d g4 f+ e","o5 f+4 d o4 a o5 d4 c+ o4 b","o4 g4 b o5 d e4 d c+","o5 d2 o4 a2",
"o4 b4 o5 d c+ o4 b4 a g","o4 f+4 a g f+4 e d","o4 e4 f+ g a4 c+4","o4 d2. r4",
}),
pulse2=b("t144 @2 v6 y0 q8 x1 l1 o3 ",m(p,false)),
wave=b("t144 @5 v3 l8 o2 ",k(p)),
noise=b("t144 l8 ",s(e(d,8),e(d,8))),
},
[a.STAGE.downtown]={
loop=true,
pulse1=b("t150 @1 v11 y0 q7 l8 ",{
"o4 g4 r b- o5 c4 d o4 b-","o5 c4 o4 b- g f4 g4","o4 g4 r b- o5 c4 d f","o5 d2 r4 c4",
"o4 g4 r b- o5 c4 d o4 b-","o5 c4 o4 b- g f4 d4","o4 f4 g b- o5 c4 o4 b- a","o4 g2. r4",
"o5 e-4 d c d4 c o4 b-","o5 c4 o4 b- a b-4 g4","o5 e-4 d c d4 f4","o5 d2 c4 o4 b-4",
"o5 e-4 d c d4 c o4 b-","o4 a4 b- o5 c d4 o4 a4","o4 b-4 a g f+4 a4","o4 g2. r4",
}),
pulse2=b("t150 @2 v6 y0 q8 x1 l1 o3 ",m(q,false)),
wave=b("t150 @5 v3 l8 o2 ",k(q)),
noise=b("t150 l8 ",s(e(d,8),e(j,8))),
},
[a.STAGE.heart]={
loop=true,
pulse1=b("t156 @2 v11 y0 q7 l8 ",{
"o4 d4 a d o5 d4 c o4 a","o4 b-4 a g a4 f4","o4 d4 a d o5 d4 e f","o5 e2 c+2",
"o4 d4 a d o5 d4 c o4 a","o4 b-4 o5 c d e4 f4","o5 g4 f e f4 e c+","o5 d2. r4",
"o5 f4 e d e4 d c","o5 d4 c o4 b- o5 c4 o4 a4","o4 b-4 a g a4 b- o5 c","o5 d2 o4 a2",
"o5 f4 e d e4 f g","o5 a4 g f e4 d c+","o5 d4 o4 a f e4 c+4","o4 d2. r4",
}),
pulse2=b("t156 @2 v6 y0 q8 x1 l1 o3 ",m(r,true)),
wave=b("t156 @5 v3 l8 o2 ",k(r)),
noise=b("t156 l8 ",e(j,16)),
},
[a.FINAL]={
loop=true,
pulse1=b("t168 @1 v11 y0 q6 l8 ",{
"o4 c c e- c f+ c g c","o4 c c e- c a- g f+ e-","o4 c c e- c f+ c g c","o4 b- a- g f+ g2",
"o5 c4 o4 b a- g4 f+ g","o5 e-4 d c o4 b4 a- g","o5 c4 o4 b a- b4 o5 d4","o5 c2 o4 b2",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=b("t168 @5 v3 l8 o2 ",k(B)),
noise=b("t168 l8 ",e(j,8)),
},
[a.ENDING]={
pulse1="t120 @2 v12 y0 q7 l8 o4 d f+ a o5 d4 o4 a o5 d f+ | o5 e4 d c+ d2 | o4 b o5 d g b4 a g f+ | o5 e2 a2 | o5 d1",
pulse2="t120 @1 v7 y0 q7 l8 o4 f+ a o5 d f+4 d f+ a | o5 c+4 o4 b a f+2 | o4 g b o5 d g4 f+ e d | o5 c+2 e2 | o4 a1",
wave="t120 @12 v3 l4 o2 d a d a | a >e< a >e< | g >d< g >d< | a >e< a >e< | d1",
noise="t120 l8 "..d.." | "..d.." | "..d.." | "..o.." | l2 v12 y5 n{16 32 48} r",
},
[a.CLEAR]={
pulse1="t150 @2 v12 y0 q7 l8 o4 a o5 c e a4 e a4 | o5 a2 r2",
pulse2="t150 @1 v7 y0 q7 l8 o4 e a o5 c e4 c e4 | o5 e2 r2",
wave="t150 @12 v3 l4 o2 a >e< a >e< | a2 r2",
noise="t150 l8 "..c.." r "..f.." r "..c.." "..c.." "..f.." r | "..c.." r r r r r r r",
},
[a.OVER]={
pulse1="t90 @2 v11 y0 q7 l8 o4 e d c o3 b a4 e4 | o3 a2. r4",
pulse2="t90 @1 v7 y0 q7 l8 o4 c o3 b a g+ e4 c4 | o3 e2. r4",
wave="t90 @12 v3 l4 o2 a e f e | a2. r4",
},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 e"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 d f+ a"},
[a.COUNT]={pulse2="t240 @2 v9 y1 l16 o5 a"},
[a.SHUTTER]={noise="t240 l32 v11 y1 n16 r v8 y1 n32"},
[a.GO]={pulse2="t200 @2 v10 y1 l16 o5 e r e r"},
punch={noise="t240 l32 v11 y1 n{48 64}"},
kick={noise="t240 l16 v12 y2 n{48 80 113}"},
whoosh={noise="t240 l32 v5 y1 n{16 32}"},
swing={noise="t240 l16 v12 y2 n{64 80}",pulse2="t240 @3 v8 y2 l32 o3 c"},
clang={pulse2="t240 @3 v11 y3 l16 o6 c",noise="t240 l32 v8 y1 n16"},
chop={noise="t240 l16 v12 y2 n{32 64 113}"},
["break"]={noise="t200 l8 v11 y3 n{16 48 80}",pulse2="t200 @1 v9 y2 l32 o5 c o4 g c"},
grab={pulse2="t240 @2 v8 y1 l32 o4 g >c"},
throw={pulse1="t200 @2 v9 y2 s2,-3 l8 o5 c"},
pickup={pulse2="t240 @2 v10 y1 l32 o5 c e g >c"},
eat={pulse2="t220 @1 v9 y1 l32 o5 e g e g >c"},
hurt={pulse2="t200 @1 v11 y2 l32 o4 g f+ f e"},
down={noise="t240 l16 v12 y3 n{80 113 112}"},
die={noise="t200 l16 v10 y3 n{64 96 113}",pulse2="t200 @1 v7 y2 l32 o3 c o2 g"},
roar={noise="t120 l4 v12 y4 n{113 112 113 112}",pulse1="t120 @1 v10 y3 l4 o3 c p20 o2 g"},
bossDie={noise="t120 l2 v13 y5 n{32 48 64 80 96 113}"},
}

for x=0,a.MIX_STEPS do
w[a.STEP..x]={pulse2="t240 @2 v10 y1 l16 o5 "..n[x+1]}
end

SpiffBoy.Tunes.register("DoubleRaccoon",w)
