require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local f={}
SpiffBoy.StreetBiter.Music=f

f.TITLE="title"
f.SELECT="select"
f.STAGE={station="station",gym="gym",barn="barn",bar="bar",cemetery="cemetery",firehouse="firehouse",hospital="hospital",prison="prison"}
f.ROUND="round"
f.KO="ko"
f.WIN="win"
f.LOSE="lose"
f.CONTINUE="continue"
f.OVER="over"
f.ENDING="ending"
f.TICK="tick"
f.CONFIRM="confirm"
f.COUNT="count"
f.HIT_LIGHT="hitLight"
f.HIT_HEAVY="hitHeavy"
f.BLOCK="block"
f.WHOOSH="whoosh"
f.JUMP="jump"
f.THUD="thud"
f.SPECIAL="special"
f.PROJECTILE="projectile"
f.KO_HIT="koHit"
f.PAUSE="pause"

local k="v12 y1 n{32 80 112}"
local j="v9 y2 n{48 64}"
local i="v2 y1 n96"
local n="v4 y3 n80"
local o=k.." "..i.." "..j.." "..i.." "..k.." "..i.." "..j.." "..i
local t=k.." "..i.." "..j.." "..n.." "..k.." "..i.." "..j.." "..n
local p=k.." "..k.." "..j.." "..i.." "..k.." "..k.." "..j.." "..i
local v=k.." "..i.." "..i.." "..i.." "..j.." "..i.." "..i.." "..i
local w=k.." "..i.." "..j.." "..j.." "..k.." "..i.." "..j.." "..i
local x=k.." "..i.." "..j.." "..n.." "..k.." "..i.." "..j.." "..i
local y=k.." "..j.." "..j.." "..k.." "..j.." "..j.." "..k.." "..j
local h={e="{eb}",a="{ae}",g="{gd}",c="{cg}",d="{da}",b="{bf+}",f="{f>c}",["b-"]="{b->f}"}
local e={
f="{fa>c}",g="{gb>d}",c="{ceg}",["b-"]="{b->df}",am="{ace}",a="{ac+e}",d="{df+a}",e="{eg+b}",
dm="{dfa}",gm="{gb->d}",cm="{ce-g}",fm="{fa->c}",["a-"]="{a->ce-}",
}

local function g(header,bars)
return header..table.concat(bars," | ")
end

local function m(root)
return root.." >"..root.."< "..root.." >"..root.."< "..root.." >"..root.."< "..root.." >"..root.."<"
end

local function u(root)
local a=root.." "..root.."16 "..root.."16"
return a.." "..a.." "..a.." "..a
end

local function l(a,b,c,d)
return a.." "..b.." "..c.." "..d.." "..c.." "..b.." "..a.." "..b
end

local function z(root)
return root.." "..root.." "..root.." "..root.." "..root.." "..root.." "..root.." "..root
end

local function q(chord)
return chord.." r "..chord.." "..chord.." r "..chord.." r "..chord
end

local function b(chord)
return"r "..chord.." r "..chord.." r "..chord.." r "..chord
end

local function d(low,high)
return low.." "..high.." "..low.." "..high.." "..low.." "..high.." "..low.." "..high
end

local function a(builder,roots)
local c={}
for r,s in ipairs(roots)do
c[r]=builder(s)
end
return c
end

local function c(pattern,count)
local r={}
for s=1,count do
if s%4==0 then
r[s]=y
else
r[s]=pattern
end
end
return r
end

local r={
[f.TITLE]={
loop=true,
pulse1=g("t152 @1 v12 y0 q7 l8 ",{
"o4 d4 d f a4 g f","o4 e4 e g b-4 a g","o4 d4 d f a4 o5 c d","o5 c+2 d2",
"o5 d4 c o4 b- a4 g f","o4 g4 a b- o5 c4 d e","o5 f4 e d c+4 o4 b- a","o4 a2. r4",
}),
pulse2=g("t152 @0 v6 y0 q5 l8 o3 ",a(q,{h.d,h.e,h.d,h.a,h["b-"],h.g,h.a,h.d})),
wave=g("t152 @5 v3 l8 o2 ",a(m,{"d","e","d","a","b-","g","a","d"})),
noise=g("t152 l8 ",c(o,8)),
},
[f.SELECT]={
loop=true,
pulse1=g("t164 @1 v12 y0 q6 l8 ",{
"o5 c o4 g e g o5 c4 e d","o5 c4 o4 a g a2","o4 f4 a o5 c o4 a4 g4","o4 g4 b o5 d o4 b4 g4",
"o5 c o4 g e g o5 c4 e g","o5 a4 g e g2","o5 f4 e d e4 d c","o5 d2 c2",
}),
pulse2=g("t164 @2 v6 y0 q6 l8 o3 ",a(b,{e.c,e.am,e.f,e.g,e.c,e.am,e.f,e.g})),
wave=g("t164 @5 v3 l8 o2 ",a(m,{"c","a","f","g","c","a","f","g"})),
noise=g("t164 l8 ",c(t,8)),
},
[f.STAGE.station]={
loop=true,
pulse1=g("t168 @1 v12 y0 q7 l8 ",{
"o4 e e g a b4 a g","o4 e e g a b4 o5 d4","o4 e e g a b4 a g","o4 a4 g e d2",
"o4 g g a b o5 d4 c o4 b","o5 c c o4 b a g4 a4","o4 e e g a b4 o5 d4","o5 e2 r4 o4 b4",
"o5 e4 d e d4 o4 b a","o5 c4 o4 b o5 c o4 b4 a g","o4 a4 b o5 c d4 e d","o5 c4 o4 b a b2",
"o5 e4 d e d4 o4 b a","o5 c4 o4 b o5 c d4 e g","o5 f+4 e d e4 d c","o4 b2. r4",
}),
pulse2=g("t168 @0 v6 y0 q5 l8 o3 ",a(q,{h.e,h.e,h.e,h.a,h.g,h.c,h.e,h.b,h.e,h.a,h.c,h.d,h.e,h.a,h.d,h.b})),
wave=g("t168 @5 v3 l8 o2 ",a(m,{"e","e","e","a","g","c","e","b","e","a","c","d","e","a","d","b"})),
noise=g("t168 l8 ",c(o,16)),
},
[f.STAGE.gym]={
loop=true,
pulse1=g("t176 @1 v12 y0 q6 l8 ",{
"o5 c4 c o4 a o5 c d c o4 a","o4 g4 a g f2","o5 c4 c o4 a o5 c d e f","o5 e4 d c d2",
"o4 b-4 b- o5 c d4 c o4 b-","o4 a4 g a b-2","o5 c4 d e f4 e d","o5 c2 r2",
"o5 f4 e f e4 d c","o5 d4 c o4 b- o5 c2","o5 f4 e f g4 f e","o5 d2 c2",
"o4 b-4 o5 c d e4 d c","o4 a4 b- o5 c d4 c o4 b-","o5 c4 d e f4 g a","o5 f2. r4",
}),
pulse2=g("t176 @2 v6 y0 q6 l8 o3 ",a(b,{e.f,e.f,e.f,e.c,e["b-"],e.g,e.c,e.f,e.f,e["b-"],e.f,e.c,e["b-"],e.g,e.c,e.f})),
wave=g("t176 @5 v3 l8 o2 ",a(m,{"f","f","f","c","b-","g","c","f","f","b-","f","c","b-","g","c","f"})),
noise=g("t176 l8 ",c(t,16)),
},
[f.STAGE.barn]={
loop=true,
pulse1=g("t150 @2 v12 y0 q7 l8 ",{
"o4 e a o5 c+ o4 a g e d4","o4 e4 g4 a2","o4 e a o5 c+ o4 a g e d4","o4 f+4 e4 d2",
"o4 d f+ a o5 d4 c+ o4 a f+","o4 e g+ b o5 e4 d o4 b g+","o4 a4 o5 c+ e d4 c+ o4 a","o4 b2 a2",
"o5 e4 d c+ o4 a4 g4","o5 e4 d c+ o4 a4 b4","o5 c+4 o4 a f+ a4 o5 c+4","o5 d4 c+ o4 b a2",
"o4 d f+ a o5 d4 c+ o4 a f+","o4 e g+ b o5 e4 d o4 b g+","o4 a4 o5 c+ e o4 g4 a4","o4 a2. r4",
}),
pulse2=g("t150 @3 v6 y0 q6 l8 o3 ",a(b,{e.a,e.a,e.a,e.a,e.d,e.e,e.a,e.e,e.a,e.a,e.a,e.d,e.d,e.e,e.a,e.a})),
wave=g("t150 @5 v3 l8 o2 ",{
l("a","c+","e","f+"),l("a","c+","e","f+"),l("a","c+","e","f+"),l("a","c+","e","f+"),
l("d","f+","a","b"),l("e","g+","b",">c+<"),l("a","c+","e","f+"),l("e","g+","b",">c+<"),
l("a","c+","e","f+"),l("a","c+","e","f+"),l("a","c+","e","f+"),l("d","f+","a","b"),
l("d","f+","a","b"),l("e","g+","b",">c+<"),l("a","c+","e","f+"),l("a","c+","e","f+"),
}),
noise=g("t150 l8 ",c(x,16)),
},
[f.STAGE.bar]={
loop=true,
pulse1=g("t180 @1 v12 y0 q6 l8 ",{
"o4 a a o5 c o4 a o5 d4 c o4 a","o4 g4 a o5 c o4 g2","o4 a a o5 c o4 a o5 d4 e4","o5 d4 c o4 a g2",
"o5 e4 d c d4 c o4 a","o5 c4 o4 a g a4 g e","o4 g4 a o5 c d4 e d","o5 c2 r4 o4 g4",
"o5 a4 g e g4 e d","o5 e4 d c d2","o5 a4 g e g4 e d","o5 e4 g a g2",
"o5 c4 d e g4 e d","o5 c4 o4 a g a4 o5 c4","o5 d4 c o4 a g4 a4","o4 a2. r4",
}),
pulse2=g("t180 @0 v7 y0 q5 l8 o3 ",a(q,{h.a,h.g,h.a,h.g,h.f,h.a,h.g,h.a,h.f,h.g,h.f,h.g,h.a,h.f,h.g,h.a})),
wave=g("t180 @5 v3 l8 o2 ",a(u,{"a","g","a","g","f","a","g","a","f","g","f","g","a","f","g","a"})),
noise=g("t180 l8 ",c(p,16)),
},
[f.STAGE.cemetery]={
loop=true,
pulse1=g("t144 @2 v11 y0 q7 l8 ",{
"o4 d4 f d a4 g f","o4 e4 d c+ d2","o4 d4 f d b-4 a g","o4 a2 r4 a4",
"o4 f4 g a b-4 a g","o4 e4 f g a2","o4 d4 f a o5 d4 c o4 a","o4 b-2 a2",
"o5 d4 c o4 a b-4 a g","o4 f4 g a b-2","o5 d4 c o4 a b-4 o5 c d","o5 c+2 d2",
"o4 a4 b- o5 c d4 c o4 b-","o4 a4 g f g4 a b-","o4 a4 g f e4 c+ e","o4 d2. r4",
}),
pulse2=g("t144 @2 v5 y0 q8 x1 l1 o3 ",{e.dm,e.dm,e.gm,e.a,e["b-"],e.gm,e.dm,e.a,e.dm,e.gm,e.dm,e.a,e.gm,e["b-"],e.a,e.dm}),
wave=g("t144 @5 v3 l8 o2 ",a(m,{"d","d","g","a","b-","g","d","a","d","g","d","a","g","b-","a","d"})),
noise=g("t144 l8 ",c(p,16)),
},
[f.STAGE.firehouse]={
loop=true,
pulse1=g("t184 @1 v12 y0 q6 l8 ",{
"o4 g b- o5 d o4 b- g b- o5 d o4 b-","o5 c o4 a o5 c d c o4 a f a","o4 g b- o5 d o4 b- g b- o5 d f","o5 e-4 d c d2",
"o5 d4 c o4 b- o5 c4 o4 b- a","o4 b-4 a g a4 g f","o4 g4 a b- o5 c4 d e-","o5 d2 r4 d4",
"o5 g4 f d f4 d c","o5 d4 c o4 b- o5 c2","o5 g4 f d f4 g f","o5 e-4 d c d2",
"o5 d c o4 b- a g a b- o5 c","o5 d c o4 b- a g f e- d","o4 g4 a b- o5 c4 d4","o5 d2. r4",
}),
pulse2=g("t184 @0 v6 y0 q6 l8 ",{
"o4 "..d("g",">d<"),d("g",">d<"),d("g",">d<"),d("g",">d<"),
"o3 "..b(e.gm),b(e.gm),b(e.cm),b(e.d),
"o4 "..d("g",">e-<"),d("g",">e-<"),d("g",">e-<"),d("g",">e-<"),
"o3 "..b(e.gm),b(e.cm),b(e.d),b(e.gm),
}),
wave=g("t184 @5 v3 l8 o2 ",a(z,{"g","g","g","e-","d","c","g","d","g","g","g","e-","d","c","d","g"})),
noise=g("t184 l8 ",c(v,16)),
},
[f.STAGE.hospital]={
loop=true,
pulse1=g("t160 @1 v12 y0 q5 l8 ",{
"o4 c e- g o5 c o4 g e- c4","o4 d f a- o5 d o4 a- f d4","o4 c e- g o5 c o4 g e- c4","o4 b2 o5 c2",
"o5 e-4 d c o4 b4 g4","o4 a-4 g f g2","o5 e-4 d c o4 b4 o5 d4","o5 c2. r4",
"o5 g4 f e- d4 c o4 b","o5 c4 o4 b o5 c d2","o5 g4 f e- f4 e- d","o5 e-2 d2",
"o4 c e- g o5 c o4 g e- c4","o4 f a- o5 c f c o4 a- f4","o4 g b o5 d g d o4 b g4","o5 c2. r4",
}),
pulse2=g("t160 @0 v6 y0 q5 l8 o3 ",a(b,{e.cm,e.dm,e.cm,e.g,e.cm,e.fm,e.g,e.cm,e.cm,e.cm,e.fm,e.g,e.cm,e.fm,e.g,e.cm})),
wave=g("t160 @5 v3 l8 o2 ",a(m,{"c","d","c","g","c","f","g","c","c","c","f","g","c","f","g","c"})),
noise=g("t160 l8 ",c(w,16)),
},
[f.STAGE.prison]={
loop=true,
pulse1=g("t172 @1 v12 y0 q6 l8 ",{
"o4 e e e g f+ f e4","o4 e e e g a g f+4","o4 e e e g f+ f e4","o4 b-4 b4 o5 c4 o4 b4",
"o5 e4 d+ e o4 b4 a g","o4 f+4 g a b2","o5 e4 d+ e g4 f+ e","o4 b2 r4 b4",
"o5 g4 f+ e d+4 e f+","o5 g4 a b g2","o5 e4 d+ e o4 b4 o5 c d","o5 d+2 e2",
"o4 e e e g f+ f e4","o4 e e e g a g f+4","o4 b4 o5 c o4 b a4 g f+","o4 e2. r4",
}),
pulse2={echo="pulse1",delay=16,drop=5},
wave=g("t172 @5 v3 l8 o2 ",a(u,{"e","e","e","b-","e","b","e","b","e","g","e","b","e","e","c","b"})),
noise=g("t172 l8 ",c(p,16)),
},
[f.ROUND]={
pulse1="t180 @1 v12 y0 q8 l8 o4 d f a >d4 f4 e< | >d2 r2",
pulse2="t180 @2 v7 y0 q8 l8 o4 f a >c f4 a4 g< | >f2 r2",
wave="t180 @12 v3 l4 o2 d a d a | d2 r2",
},
[f.KO]={
pulse1="t110 @0 v12 y0 q8 l8 o4 e e- d d- c4 o3 b4 | b-2 a2",
pulse2="t110 @0 v8 y0 q8 l8 o4 b b- a a- g4 f+4 | f2 e2",
wave="t110 @12 v3 l2 o2 e e- | d a",
noise="t110 l4 v12 y3 n{112 113} r r r | r1",
},
[f.WIN]={
pulse1="t170 @1 v12 y0 q7 l8 o4 d f a >d< a >d f4 | >d2 r2",
pulse2="t170 @2 v7 y0 q7 l8 o4 f a >c f c f a4 | f2 r2",
wave="t170 @12 v3 l4 o2 d a d a | d2 r2",
noise="t170 l8 "..k.." "..i.." "..j.." "..i.." "..k.." "..j.." "..j.." r | "..k.." r r r r r r r",
},
[f.LOSE]={
pulse1="t80 @2 v11 y0 q7 l4 o4 f e- d c | o3 b2. r4",
pulse2="t80 @1 v7 y0 q7 l4 o4 d c o3 b- a | o3 a2. r4",
wave="t80 @12 v3 l2 o2 d a | d2. r4",
},
[f.CONTINUE]={
loop=true,
pulse1="t148 @1 v10 y1 l8 o4 d r d r f r e r | d r d r a r g r",
wave="t148 @12 v3 l4 o2 d d d d | d d d d",
noise="t148 l8 v7 y1 n96 r n96 r n96 r n96 r | n96 r n96 r n96 r n96 r",
},
[f.OVER]={
pulse1="t72 @2 v11 y0 q8 l4 o4 d c+ o3 b- a | o3 g+2 a2",
pulse2="t72 @1 v7 y0 q8 l4 o3 b- a g f | f2 e2",
wave="t72 @12 v3 l2 o2 d a | g a",
},
[f.ENDING]={
loop=true,
pulse1=g("t140 @2 v12 y0 q7 l8 ",{
"o4 f4 a o5 c f4 e c","o5 d4 c o4 a b-2","o4 g4 b- o5 d g4 f d","o5 e4 d c o4 a2",
"o4 f4 a o5 c f4 g a","o5 b-4 a g f4 e d","o5 c4 d e f4 g a","o5 f1",
}),
pulse2=g("t140 @1 v7 y0 q7 l8 ",{
"o4 a4 o5 c e a4 g e","o4 b-4 a f g2","o4 b-4 o5 d f b-4 a f","o5 c4 o4 b- a f2",
"o4 a4 o5 c e a4 b- o5 c","o5 d4 c o4 b- a4 g f","o4 a4 b- o5 c d4 e f","o5 a1",
}),
wave=g("t140 @5 v3 l8 o2 ",a(m,{"f","f","g","c","f","b-","c","f"})),
noise=g("t140 l8 ",c(o,8)),
},
[f.TICK]={pulse2="t240 @0 v7 y2 l32 o5 g"},
[f.CONFIRM]={pulse2="t220 @1 v10 y2 l32 o4 a >e a"},
[f.COUNT]={pulse2="t240 @0 v9 y1 l16 o4 d"},
[f.PAUSE]={pulse2="t200 @1 v9 y2 l32 o5 e o4 b"},
[f.HIT_LIGHT]={noise="t240 l32 v10 y1 n{16 48}",pulse2="t240 @3 v7 y3 l32 o3 e"},
[f.HIT_HEAVY]={noise="t240 l16 v12 y2 n{32 80 112}",pulse2="t240 @3 v9 y3 l16 o2 a"},
[f.BLOCK]={pulse2="t240 @1 v9 y3 l32 o6 c o5 g",noise="t240 l32 v6 y1 n48 n48"},
[f.WHOOSH]={noise="t240 l32 v4 y2 n{80 96}"},
[f.JUMP]={pulse1="t240 @1 v6 y2 s1,2 l16 o4 g"},
[f.THUD]={noise="t240 l16 v11 y3 n{96 112 113}"},
[f.SPECIAL]={pulse2="t220 @0 v10 y2 l32 o4 e g b >e",noise="t220 l32 v5 y1 n16 n48 n16 n48"},
[f.PROJECTILE]={pulse1="t200 @1 v8 y2 s3,2 l8 o4 e"},
[f.KO_HIT]={noise="t180 l8 v13 y4 n{16 48 80 113}",pulse2="t180 @0 v11 y3 l16 o3 e o2 b"},
}

SpiffBoy.Tunes.register("StreetBiter",r)
