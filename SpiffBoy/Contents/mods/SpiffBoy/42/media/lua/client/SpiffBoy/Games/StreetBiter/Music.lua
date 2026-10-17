require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local b={}
SpiffBoy.StreetBiter.Music=b

b.TITLE="title"
b.SELECT="select"
b.STAGE={station="station",gym="gym",barn="barn",bar="bar",cemetery="cemetery",firehouse="firehouse",hospital="hospital",prison="prison"}
b.ROUND="round"
b.KO="ko"
b.WIN="win"
b.LOSE="lose"
b.CONTINUE="continue"
b.OVER="over"
b.ENDING="ending"
b.TICK="tick"
b.CONFIRM="confirm"
b.COUNT="count"
b.HIT_LIGHT="hitLight"
b.HIT_HEAVY="hitHeavy"
b.BLOCK="block"
b.WHOOSH="whoosh"
b.JUMP="jump"
b.THUD="thud"
b.SPECIAL="special"
b.PROJECTILE="projectile"
b.KO_HIT="koHit"
b.PAUSE="pause"

local g="v12 y1 n{32 80 112}"
local f="v9 y2 n{48 64}"
local e="v2 y1 n96"
local n="v4 y3 n80"
local o=g.." "..e.." "..f.." "..e.." "..g.." "..e.." "..f.." "..e
local t=g.." "..e.." "..f.." "..n.." "..g.." "..e.." "..f.." "..n
local p=g.." "..g.." "..f.." "..e.." "..g.." "..g.." "..f.." "..e
local v=g.." "..e.." "..e.." "..e.." "..f.." "..e.." "..e.." "..e
local w=g.." "..e.." "..f.." "..f.." "..g.." "..e.." "..f.." "..e
local x=g.." "..e.." "..f.." "..n.." "..g.." "..e.." "..f.." "..e
local y=g.." "..f.." "..f.." "..g.." "..f.." "..f.." "..g.." "..f
local d={e="{eb}",a="{ae}",g="{gd}",c="{cg}",d="{da}",b="{bf+}",f="{f>c}",["b-"]="{b->f}"}
local a={
f="{fa>c}",g="{gb>d}",c="{ceg}",["b-"]="{b->df}",am="{ace}",a="{ac+e}",d="{df+a}",e="{eg+b}",
dm="{dfa}",gm="{gb->d}",cm="{ce-g}",fm="{fa->c}",["a-"]="{a->ce-}",
}

local function c(h,i)
return h..table.concat(i," | ")
end

local function m(h)
return h.." >"..h.."< "..h.." >"..h.."< "..h.." >"..h.."< "..h.." >"..h.."<"
end

local function u(i)
local h=i.." "..i.."16 "..i.."16"
return h.." "..h.." "..h.." "..h
end

local function i(j,h,k,l)
return j.." "..h.." "..k.." "..l.." "..k.." "..h.." "..j.." "..h
end

local function z(h)
return h.." "..h.." "..h.." "..h.." "..h.." "..h.." "..h.." "..h
end

local function q(h)
return h.." r "..h.." "..h.." r "..h.." r "..h
end

local function j(h)
return"r "..h.." r "..h.." r "..h.." r "..h
end

local function l(h,k)
return h.." "..k.." "..h.." "..k.." "..h.." "..k.." "..h.." "..k
end

local function h(r,s)
local k={}
for A,B in ipairs(s)do
k[A]=r(B)
end
return k
end

local function k(A,B)
local r={}
for s=1,B do
if s%4==0 then
r[s]=y
else
r[s]=A
end
end
return r
end

local r={
[b.TITLE]={
loop=true,
pulse1=c("t152 @1 v12 y0 q7 l8 ",{
"o4 d4 d f a4 g f","o4 e4 e g b-4 a g","o4 d4 d f a4 o5 c d","o5 c+2 d2",
"o5 d4 c o4 b- a4 g f","o4 g4 a b- o5 c4 d e","o5 f4 e d c+4 o4 b- a","o4 a2. r4",
}),
pulse2=c("t152 @0 v6 y0 q5 l8 o3 ",h(q,{d.d,d.e,d.d,d.a,d["b-"],d.g,d.a,d.d})),
wave=c("t152 @5 v3 l8 o2 ",h(m,{"d","e","d","a","b-","g","a","d"})),
noise=c("t152 l8 ",k(o,8)),
},
[b.SELECT]={
loop=true,
pulse1=c("t164 @1 v12 y0 q6 l8 ",{
"o5 c o4 g e g o5 c4 e d","o5 c4 o4 a g a2","o4 f4 a o5 c o4 a4 g4","o4 g4 b o5 d o4 b4 g4",
"o5 c o4 g e g o5 c4 e g","o5 a4 g e g2","o5 f4 e d e4 d c","o5 d2 c2",
}),
pulse2=c("t164 @2 v6 y0 q6 l8 o3 ",h(j,{a.c,a.am,a.f,a.g,a.c,a.am,a.f,a.g})),
wave=c("t164 @5 v3 l8 o2 ",h(m,{"c","a","f","g","c","a","f","g"})),
noise=c("t164 l8 ",k(t,8)),
},
[b.STAGE.station]={
loop=true,
pulse1=c("t168 @1 v12 y0 q7 l8 ",{
"o4 e e g a b4 a g","o4 e e g a b4 o5 d4","o4 e e g a b4 a g","o4 a4 g e d2",
"o4 g g a b o5 d4 c o4 b","o5 c c o4 b a g4 a4","o4 e e g a b4 o5 d4","o5 e2 r4 o4 b4",
"o5 e4 d e d4 o4 b a","o5 c4 o4 b o5 c o4 b4 a g","o4 a4 b o5 c d4 e d","o5 c4 o4 b a b2",
"o5 e4 d e d4 o4 b a","o5 c4 o4 b o5 c d4 e g","o5 f+4 e d e4 d c","o4 b2. r4",
}),
pulse2=c("t168 @0 v6 y0 q5 l8 o3 ",h(q,{d.e,d.e,d.e,d.a,d.g,d.c,d.e,d.b,d.e,d.a,d.c,d.d,d.e,d.a,d.d,d.b})),
wave=c("t168 @5 v3 l8 o2 ",h(m,{"e","e","e","a","g","c","e","b","e","a","c","d","e","a","d","b"})),
noise=c("t168 l8 ",k(o,16)),
},
[b.STAGE.gym]={
loop=true,
pulse1=c("t176 @1 v12 y0 q6 l8 ",{
"o5 c4 c o4 a o5 c d c o4 a","o4 g4 a g f2","o5 c4 c o4 a o5 c d e f","o5 e4 d c d2",
"o4 b-4 b- o5 c d4 c o4 b-","o4 a4 g a b-2","o5 c4 d e f4 e d","o5 c2 r2",
"o5 f4 e f e4 d c","o5 d4 c o4 b- o5 c2","o5 f4 e f g4 f e","o5 d2 c2",
"o4 b-4 o5 c d e4 d c","o4 a4 b- o5 c d4 c o4 b-","o5 c4 d e f4 g a","o5 f2. r4",
}),
pulse2=c("t176 @2 v6 y0 q6 l8 o3 ",h(j,{a.f,a.f,a.f,a.c,a["b-"],a.g,a.c,a.f,a.f,a["b-"],a.f,a.c,a["b-"],a.g,a.c,a.f})),
wave=c("t176 @5 v3 l8 o2 ",h(m,{"f","f","f","c","b-","g","c","f","f","b-","f","c","b-","g","c","f"})),
noise=c("t176 l8 ",k(t,16)),
},
[b.STAGE.barn]={
loop=true,
pulse1=c("t150 @2 v12 y0 q7 l8 ",{
"o4 e a o5 c+ o4 a g e d4","o4 e4 g4 a2","o4 e a o5 c+ o4 a g e d4","o4 f+4 e4 d2",
"o4 d f+ a o5 d4 c+ o4 a f+","o4 e g+ b o5 e4 d o4 b g+","o4 a4 o5 c+ e d4 c+ o4 a","o4 b2 a2",
"o5 e4 d c+ o4 a4 g4","o5 e4 d c+ o4 a4 b4","o5 c+4 o4 a f+ a4 o5 c+4","o5 d4 c+ o4 b a2",
"o4 d f+ a o5 d4 c+ o4 a f+","o4 e g+ b o5 e4 d o4 b g+","o4 a4 o5 c+ e o4 g4 a4","o4 a2. r4",
}),
pulse2=c("t150 @3 v6 y0 q6 l8 o3 ",h(j,{a.a,a.a,a.a,a.a,a.d,a.e,a.a,a.e,a.a,a.a,a.a,a.d,a.d,a.e,a.a,a.a})),
wave=c("t150 @5 v3 l8 o2 ",{
i("a","c+","e","f+"),i("a","c+","e","f+"),i("a","c+","e","f+"),i("a","c+","e","f+"),
i("d","f+","a","b"),i("e","g+","b",">c+<"),i("a","c+","e","f+"),i("e","g+","b",">c+<"),
i("a","c+","e","f+"),i("a","c+","e","f+"),i("a","c+","e","f+"),i("d","f+","a","b"),
i("d","f+","a","b"),i("e","g+","b",">c+<"),i("a","c+","e","f+"),i("a","c+","e","f+"),
}),
noise=c("t150 l8 ",k(x,16)),
},
[b.STAGE.bar]={
loop=true,
pulse1=c("t180 @1 v12 y0 q6 l8 ",{
"o4 a a o5 c o4 a o5 d4 c o4 a","o4 g4 a o5 c o4 g2","o4 a a o5 c o4 a o5 d4 e4","o5 d4 c o4 a g2",
"o5 e4 d c d4 c o4 a","o5 c4 o4 a g a4 g e","o4 g4 a o5 c d4 e d","o5 c2 r4 o4 g4",
"o5 a4 g e g4 e d","o5 e4 d c d2","o5 a4 g e g4 e d","o5 e4 g a g2",
"o5 c4 d e g4 e d","o5 c4 o4 a g a4 o5 c4","o5 d4 c o4 a g4 a4","o4 a2. r4",
}),
pulse2=c("t180 @0 v7 y0 q5 l8 o3 ",h(q,{d.a,d.g,d.a,d.g,d.f,d.a,d.g,d.a,d.f,d.g,d.f,d.g,d.a,d.f,d.g,d.a})),
wave=c("t180 @5 v3 l8 o2 ",h(u,{"a","g","a","g","f","a","g","a","f","g","f","g","a","f","g","a"})),
noise=c("t180 l8 ",k(p,16)),
},
[b.STAGE.cemetery]={
loop=true,
pulse1=c("t144 @2 v11 y0 q7 l8 ",{
"o4 d4 f d a4 g f","o4 e4 d c+ d2","o4 d4 f d b-4 a g","o4 a2 r4 a4",
"o4 f4 g a b-4 a g","o4 e4 f g a2","o4 d4 f a o5 d4 c o4 a","o4 b-2 a2",
"o5 d4 c o4 a b-4 a g","o4 f4 g a b-2","o5 d4 c o4 a b-4 o5 c d","o5 c+2 d2",
"o4 a4 b- o5 c d4 c o4 b-","o4 a4 g f g4 a b-","o4 a4 g f e4 c+ e","o4 d2. r4",
}),
pulse2=c("t144 @2 v5 y0 q8 x1 l1 o3 ",{a.dm,a.dm,a.gm,a.a,a["b-"],a.gm,a.dm,a.a,a.dm,a.gm,a.dm,a.a,a.gm,a["b-"],a.a,a.dm}),
wave=c("t144 @5 v3 l8 o2 ",h(m,{"d","d","g","a","b-","g","d","a","d","g","d","a","g","b-","a","d"})),
noise=c("t144 l8 ",k(p,16)),
},
[b.STAGE.firehouse]={
loop=true,
pulse1=c("t184 @1 v12 y0 q6 l8 ",{
"o4 g b- o5 d o4 b- g b- o5 d o4 b-","o5 c o4 a o5 c d c o4 a f a","o4 g b- o5 d o4 b- g b- o5 d f","o5 e-4 d c d2",
"o5 d4 c o4 b- o5 c4 o4 b- a","o4 b-4 a g a4 g f","o4 g4 a b- o5 c4 d e-","o5 d2 r4 d4",
"o5 g4 f d f4 d c","o5 d4 c o4 b- o5 c2","o5 g4 f d f4 g f","o5 e-4 d c d2",
"o5 d c o4 b- a g a b- o5 c","o5 d c o4 b- a g f e- d","o4 g4 a b- o5 c4 d4","o5 d2. r4",
}),
pulse2=c("t184 @0 v6 y0 q6 l8 ",{
"o4 "..l("g",">d<"),l("g",">d<"),l("g",">d<"),l("g",">d<"),
"o3 "..j(a.gm),j(a.gm),j(a.cm),j(a.d),
"o4 "..l("g",">e-<"),l("g",">e-<"),l("g",">e-<"),l("g",">e-<"),
"o3 "..j(a.gm),j(a.cm),j(a.d),j(a.gm),
}),
wave=c("t184 @5 v3 l8 o2 ",h(z,{"g","g","g","e-","d","c","g","d","g","g","g","e-","d","c","d","g"})),
noise=c("t184 l8 ",k(v,16)),
},
[b.STAGE.hospital]={
loop=true,
pulse1=c("t160 @1 v12 y0 q5 l8 ",{
"o4 c e- g o5 c o4 g e- c4","o4 d f a- o5 d o4 a- f d4","o4 c e- g o5 c o4 g e- c4","o4 b2 o5 c2",
"o5 e-4 d c o4 b4 g4","o4 a-4 g f g2","o5 e-4 d c o4 b4 o5 d4","o5 c2. r4",
"o5 g4 f e- d4 c o4 b","o5 c4 o4 b o5 c d2","o5 g4 f e- f4 e- d","o5 e-2 d2",
"o4 c e- g o5 c o4 g e- c4","o4 f a- o5 c f c o4 a- f4","o4 g b o5 d g d o4 b g4","o5 c2. r4",
}),
pulse2=c("t160 @0 v6 y0 q5 l8 o3 ",h(j,{a.cm,a.dm,a.cm,a.g,a.cm,a.fm,a.g,a.cm,a.cm,a.cm,a.fm,a.g,a.cm,a.fm,a.g,a.cm})),
wave=c("t160 @5 v3 l8 o2 ",h(m,{"c","d","c","g","c","f","g","c","c","c","f","g","c","f","g","c"})),
noise=c("t160 l8 ",k(w,16)),
},
[b.STAGE.prison]={
loop=true,
pulse1=c("t172 @1 v12 y0 q6 l8 ",{
"o4 e e e g f+ f e4","o4 e e e g a g f+4","o4 e e e g f+ f e4","o4 b-4 b4 o5 c4 o4 b4",
"o5 e4 d+ e o4 b4 a g","o4 f+4 g a b2","o5 e4 d+ e g4 f+ e","o4 b2 r4 b4",
"o5 g4 f+ e d+4 e f+","o5 g4 a b g2","o5 e4 d+ e o4 b4 o5 c d","o5 d+2 e2",
"o4 e e e g f+ f e4","o4 e e e g a g f+4","o4 b4 o5 c o4 b a4 g f+","o4 e2. r4",
}),
pulse2={echo="pulse1",delay=16,drop=5},
wave=c("t172 @5 v3 l8 o2 ",h(u,{"e","e","e","b-","e","b","e","b","e","g","e","b","e","e","c","b"})),
noise=c("t172 l8 ",k(p,16)),
},
[b.ROUND]={
pulse1="t180 @1 v12 y0 q8 l8 o4 d f a >d4 f4 e< | >d2 r2",
pulse2="t180 @2 v7 y0 q8 l8 o4 f a >c f4 a4 g< | >f2 r2",
wave="t180 @12 v3 l4 o2 d a d a | d2 r2",
},
[b.KO]={
pulse1="t110 @0 v12 y0 q8 l8 o4 e e- d d- c4 o3 b4 | b-2 a2",
pulse2="t110 @0 v8 y0 q8 l8 o4 b b- a a- g4 f+4 | f2 e2",
wave="t110 @12 v3 l2 o2 e e- | d a",
noise="t110 l4 v12 y3 n{112 113} r r r | r1",
},
[b.WIN]={
pulse1="t170 @1 v12 y0 q7 l8 o4 d f a >d< a >d f4 | >d2 r2",
pulse2="t170 @2 v7 y0 q7 l8 o4 f a >c f c f a4 | f2 r2",
wave="t170 @12 v3 l4 o2 d a d a | d2 r2",
noise="t170 l8 "..g.." "..e.." "..f.." "..e.." "..g.." "..f.." "..f.." r | "..g.." r r r r r r r",
},
[b.LOSE]={
pulse1="t80 @2 v11 y0 q7 l4 o4 f e- d c | o3 b2. r4",
pulse2="t80 @1 v7 y0 q7 l4 o4 d c o3 b- a | o3 a2. r4",
wave="t80 @12 v3 l2 o2 d a | d2. r4",
},
[b.CONTINUE]={
loop=true,
pulse1="t148 @1 v10 y1 l8 o4 d r d r f r e r | d r d r a r g r",
wave="t148 @12 v3 l4 o2 d d d d | d d d d",
noise="t148 l8 v7 y1 n96 r n96 r n96 r n96 r | n96 r n96 r n96 r n96 r",
},
[b.OVER]={
pulse1="t72 @2 v11 y0 q8 l4 o4 d c+ o3 b- a | o3 g+2 a2",
pulse2="t72 @1 v7 y0 q8 l4 o3 b- a g f | f2 e2",
wave="t72 @12 v3 l2 o2 d a | g a",
},
[b.ENDING]={
loop=true,
pulse1=c("t140 @2 v12 y0 q7 l8 ",{
"o4 f4 a o5 c f4 e c","o5 d4 c o4 a b-2","o4 g4 b- o5 d g4 f d","o5 e4 d c o4 a2",
"o4 f4 a o5 c f4 g a","o5 b-4 a g f4 e d","o5 c4 d e f4 g a","o5 f1",
}),
pulse2=c("t140 @1 v7 y0 q7 l8 ",{
"o4 a4 o5 c e a4 g e","o4 b-4 a f g2","o4 b-4 o5 d f b-4 a f","o5 c4 o4 b- a f2",
"o4 a4 o5 c e a4 b- o5 c","o5 d4 c o4 b- a4 g f","o4 a4 b- o5 c d4 e f","o5 a1",
}),
wave=c("t140 @5 v3 l8 o2 ",h(m,{"f","f","g","c","f","b-","c","f"})),
noise=c("t140 l8 ",k(o,8)),
},
[b.TICK]={pulse2="t240 @0 v7 y2 l32 o5 g"},
[b.CONFIRM]={pulse2="t220 @1 v10 y2 l32 o4 a >e a"},
[b.COUNT]={pulse2="t240 @0 v9 y1 l16 o4 d"},
[b.PAUSE]={pulse2="t200 @1 v9 y2 l32 o5 e o4 b"},
[b.HIT_LIGHT]={noise="t240 l32 v10 y1 n{16 48}",pulse2="t240 @3 v7 y3 l32 o3 e"},
[b.HIT_HEAVY]={noise="t240 l16 v12 y2 n{32 80 112}",pulse2="t240 @3 v9 y3 l16 o2 a"},
[b.BLOCK]={pulse2="t240 @1 v9 y3 l32 o6 c o5 g",noise="t240 l32 v6 y1 n48 n48"},
[b.WHOOSH]={noise="t240 l32 v4 y2 n{80 96}"},
[b.JUMP]={pulse1="t240 @1 v6 y2 s1,2 l16 o4 g"},
[b.THUD]={noise="t240 l16 v11 y3 n{96 112 113}"},
[b.SPECIAL]={pulse2="t220 @0 v10 y2 l32 o4 e g b >e",noise="t220 l32 v5 y1 n16 n48 n16 n48"},
[b.PROJECTILE]={pulse1="t200 @1 v8 y2 s3,2 l8 o4 e"},
[b.KO_HIT]={noise="t180 l8 v13 y4 n{16 48 80 113}",pulse2="t180 @0 v11 y3 l16 o3 e o2 b"},
}

SpiffBoy.Tunes.register("StreetBiter",r)
