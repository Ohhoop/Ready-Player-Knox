require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"
require"SpiffBoy/Games/Lanterways/Base"

local n=SpiffBoy.Lanterways

local b={}
n.Music=b

b.MIX_STEPS=10
b.TITLE="title"
b.HOME="home"
b.ROAD="road"
b.VILLAGE="village"
b.CAVE="cave"
b.TOWN="town"
b.CITY="city"
b.VAULT="vault"
b.UNDER="under"
b.GROVE="grove"
b.BELLS="bells"
b.SPIRE="spire"
b.BATTLE="battle"
b.BOSS="boss"
b.FINAL="final"
b.VICTORY="victory"
b.DEFEAT="defeat"
b.OVER="over"
b.CHAPTER="chapter"
b.INN="inn"
b.SAD="sad"
b.COMIC="comic"
b.LOVE="love"
b.TENSION="tension"
b.ENDING="ending"
b.TRIAL="trial"
b.SECRET="secret"

local e="v10 y1 n{40 88 115}"
local i="v7 y2 n66"
local j="v3 y1 n82"
local K="l2 v10 y5 n{18 34 50} r2"
local k={
road=e.." r "..j.." r r "..e.." "..j.." r",
village=e.." r v5 y2 n66 r "..e.." r v5 y2 n66 r",
shanty=e.." r r "..i.." r r",
march=e.." r "..i.." "..i.." "..e.." r "..i.." r",
drive=e.." "..j.." "..i.." "..j.." "..e.." "..e.." "..i.." "..j,
fight=e.." "..j.." "..i.." "..j.." "..e.." "..j.." "..i.." "..i,
homeTap="r4. "..j.." r4",
waltzTap="r4 "..j.." r "..j.." r",
}
local o={
A="{a>c+e}",Am="{a>ce}",B="{b>d+f+}",Bb="{b->df}",Bm="{b>df+}",C="{ceg}",["C#"]="{c+fg+}",["C#m"]="{c+eg+}",
Cm="{ce-g}",D="{df+a}",Dm="{dfa}",E="{eg+b}",Eb="{e-gb-}",Em="{egb}",F="{fa>c}",["F#"]="{f+a+>c+}",
["F#m"]="{f+a>c+}",Fm="{fa->c}",G="{gb>d}",["G#"]="{g+>cd+}",Gm="{gb->d}",Ab="{a->ce-}",
}
local L={
A="a",Am="a",B="b",Bb="b-",Bm="b",C="c",["C#"]="c+",["C#m"]="c+",Cm="c",D="d",Dm="d",E="e",
Eb="e-",Em="e",F="f",["F#"]="f+",["F#m"]="f+",Fm="f",G="g",["G#"]="g+",Gm="g",Ab="a-",
}
local M={
a="e",b="f+",["b-"]="f",c="g",["c+"]="g+",d="a",e="b",["e-"]="b-",f="c",["f+"]="c+",g="d",["g+"]="d+",["a-"]="e-",
}

local function a(header,bars)
return header..table.concat(bars," | ")
end

local function g(bar,count)
local c={}
for d=1,count do
c[d]=bar
end
return c
end

local function h(names,length)
local c={}
for d,f in ipairs(names)do
c[d]=o[f]..length
end
return c
end

local function m(names)
local d={}
for f,l in ipairs(names)do
local c=o[l].."8"
d[f]="r "..c.." r "..c.." r "..c.." r "..c
end
return d
end

local function d(names,pattern)
local c={}
for l,p in ipairs(names)do
local f=L[p]
c[l]=pattern(f,M[f])
end
return c
end

local c={}

local p={"Dm","G","Em","C","Am","F","G","Am","Dm","F","G","Am","Dm","G","Am","Dm"}
c[b.TITLE]={
loop=true,
pulse1=a("t92 @2 v11 y0 q7 l8 ",{
"o4 d4 f a o5 c o4 a","o4 g4. f e d","o4 e4 g b o5 d4","o5 c2.",
"o4 a4 o5 c d e4","o5 f4. e d c","o4 b4 o5 c o4 b a g","o4 a2.",
"o5 d4 c o4 a g4","o4 f4. g a4","o4 b4 o5 c d4 e","o5 f4. e4.",
"o5 d4 o4 a f a4","o4 g4. a b4","o4 a4 g f e4","o4 d2.",
}),
pulse2=a("t92 @2 v5 y0 q8 x2 o3 ",h(p,"2.")),
wave=a("t92 @12 v3 l4 o2 ",d(p,function(r,f)return r.." "..f.." >"..r.."<"end)),
}

local N={"G","C","G","D","G","Em","D","G","G","C","G","Am","C","G","D","G"}
c[b.HOME]={
loop=true,
pulse1=a("t108 @2 v11 y0 q7 l8 ",{
"o4 g4 a b4 g","o4 a4 b o5 c4 o4 a","o4 b4 o5 c d4 o4 b","o5 c4. o4 a4.",
"o4 g4 b o5 d4 c","o4 b4 a g4 e","o4 f+4 g a4 f+","o4 g2.",
"o5 d4. e4 d","o5 c4 o4 b a4 g","o4 b4. o5 c4 o4 b","o4 a4. e4.",
"o4 g4 a b4 o5 c","o5 d4 e d4 o4 b","o4 a4 b a4 f+","o4 g2.",
}),
pulse2={echo="pulse1",delay=4,drop=5},
wave=a("t108 @12 v3 l8 o2 ",d(N,function(r,f)return r.."4. "..f.."4."end)),
noise=a("t108 l8 ",g(k.homeTap,16)),
}

local q={"Am","Am","F","E","Am","Dm","E","Am","C","F","G","C","F","Dm","E","Am"}
c[b.ROAD]={
loop=true,
pulse1=a("t132 @1 v11 y0 q7 l8 ",{
"o4 a4 o5 c e d4 c o4 b","o4 a4. g a2","o4 f4 a o5 c o4 b4 a g","o4 e2. r4",
"o4 a4 o5 c e g4 f e","o5 d4. c d2","o5 e4 d c o4 b4 g+4","o4 a2. r4",
"o5 c4 c d e4 g4","o5 f4. e d2","o5 c4 o4 b a b4 o5 d4","o5 e2. r4",
"o5 a4 g f e4 d c","o5 d4. c o4 b2","o4 a4 b o5 c o4 b4 g+4","o4 a2. r4",
}),
pulse2=a("t132 @2 v5 y0 q8 x1 l1 o3 ",h(q,"")),
wave=a("t132 @5 v3 l8 o2 ",d(q,function(r,f)return r.."4 "..r.." "..f.." >"..r.."4< "..f.."4"end)),
noise=a("t132 l8 ",g(k.road,16)),
}

local s={"F","Bb","F","C","F","Bb","C","F","F","Dm","C","C","F","Bb","C","F"}
c[b.VILLAGE]={
loop=true,
pulse1=a("t116 @2 v11 y0 q6 l8 ",{
"o4 f4 a o5 c4 o4 a o5 c4","o5 d4 c o4 b- a4 g4","o4 a4 b- o5 c d4 c4","o4 g2. r4",
"o4 f4 a o5 c4 f e4","o5 d4 c o4 b- a4 b-4","o5 c4 o4 a g a4 g4","o4 f2. r4",
"o4 a4 a b- o5 c4 c4","o5 d4 d e f4 f4","o5 e4 d c d4 o4 b-4","o5 c2. r4",
"o5 f4 e d c4 o4 a4","o4 b-4 o5 c d c4 o4 a4","o4 g4 a b- o5 c4 o4 e4","o4 f2. r4",
}),
pulse2=a("t116 @1 v6 y0 q8 x2 l1 o3 ",h(s,"")),
wave=a("t116 @11 v3 l8 o2 ",d(s,function(r,f)return r.." r >"..r.."< r "..f.." r >"..r.."< r"end)),
noise=a("t116 l8 ",g(k.village,16)),
}

c[b.CAVE]={
loop=true,
pulse1=a("t84 @1 v9 y4 q8 l8 ",{
"r4 o5 e r r2","r2 o5 f r r4","r4 o4 b r o5 c r r4","r1",
"r4 o5 g r r2","r2 o5 f e r4","r4 o5 d r o4 b r r4","r1",
}),
pulse2=a("t84 @2 v4 y0 q8 x3 l1 o3 ",h({"Em","F","Em","F","Em","G","F","Em"},"")),
wave=a("t84 @7 v2 l1 o2 ",{"e","f","e","f","e","g","f","e"}),
noise=a("t84 l8 ",{"v6 y3 n115 r4. r2","r1","v6 y3 n115 r4. r2","r1","v6 y3 n115 r4. r2","r1","v6 y3 n115 r4. r2","r1"}),
}

local t={"Bb","Bb","Eb","F","Bb","Cm","F","Bb","Bb","F","Gm","F","Eb","Bb","F","Bb"}
c[b.TOWN]={
loop=true,
pulse1=a("t126 @2 v11 y0 q7 l8 ",{
"o4 f4 b- o5 d4 c","o4 b-4 a b-4 f","o4 g4 a b-4 o5 c","o5 d4. c4.",
"o5 d4 e- f4 d","o5 c4 d e-4 c","o4 b-4 a g4 a","o4 b-2.",
"o5 f4 f e-4 d","o5 c4 c d4 e-","o5 d4 c o4 b-4 g","o4 a4. f4.",
"o4 b-4 o5 c d4 e-","o5 f4 g f4 d","o5 c4 d c4 o4 a","o4 b-2.",
}),
pulse2=a("t126 @1 v6 y0 q8 x2 o3 ",h(t,"2.")),
wave=a("t126 @25 v3 l8 o2 ",d(t,function(r,f)return r.."4. "..f.."4."end)),
noise=a("t126 l8 ",g(k.shanty,16)),
}

local u={"Cm","Cm","G","Cm","Cm","G","G","Cm","Cm","Ab","Fm","G","Cm","Fm","G","Cm"}
c[b.CITY]={
loop=true,
pulse1=a("t108 @1 v11 y0 q7 l8 ",{
"o4 c4. c e-4 g4","o5 c4. o4 b- a-4 g4","o4 f4. e- d4 g4","o4 c2. r4",
"o4 e-4. f g4 o5 c4","o5 d4. e- d4 c4","o4 b4 o5 c d c4 o4 g4","o5 c2. r4",
"o5 e-4. d c4 o4 g4","o4 a-4. g f4 e-4","o4 f4. g a-4 b4","o5 c2 o4 g2",
"o5 e-4. f g4 e-4","o5 f4. e- d4 o4 b4","o5 c4 o4 g e- f4 d4","o4 c2. r4",
}),
pulse2=a("t108 @2 v5 y0 q8 x2 l1 o3 ",h(u,"")),
wave=a("t108 @25 v3 l4 o2 ",d(u,function(r,f)return r.." "..f.." "..r.." "..f end)),
noise=a("t108 l8 ",g(k.march,16)),
}

local v={"Bm","F#","Em","F#","G","Bm","F#","Bm"}
local O={
Bm="o4 b o5 d f+ d o4 b o5 d f+ d",["F#"]="o4 f+ a+ o5 c+ o4 a+ f+ a+ o5 c+ o4 a+",
Em="o4 e g b g e g b g",G="o4 g b o5 d o4 b g b o5 d o4 b",
}
local w={}
for f,l in ipairs(v)do
w[f]=O[l]
end
c[b.VAULT]={
loop=true,
pulse1=a("t96 @1 v10 y0 q7 l8 ",{
"o4 b2 o5 d2","o5 c+2. o4 b4","o4 a2 g2","o4 f+1","o4 g2 b2","o5 d2. c+4","o4 b2 a+2","o4 b1",
}),
pulse2=a("t96 @0 v5 y2 q8 l8 ",w),
wave=a("t96 @5 v3 l4 o2 ",d(v,function(r)return r.." r "..r.." r"end)),
noise=a("t96 l8 ",g("v2 y1 n21 r v2 y1 n21 r v2 y1 n21 r v2 y1 n21 r",8)),
}

local x={"Eb","Eb","F","F","Eb","Bb","F","Bb"}
c[b.UNDER]={
loop=true,
pulse1=a("t72 @0 v9 y0 q8 l8 ~3,24,20 ",{
"o4 e-2 g4","o4 b-2.","o4 a2 g4","o4 f2.","o4 g2 b-4","o5 d2 c4","o4 b-2 a4","o4 b-2.",
}),
pulse2=a("t72 @2 v4 y0 q8 x4 o4 ",h(x,"2.")),
wave=a("t72 @27 v2 l8 o2 ",d(x,function(r)return r.."2."end)),
}

local y={"A","A","D","E","A","D","E","A"}
c[b.GROVE]={
loop=true,
pulse1=a("t88 @2 v10 y3 q8 l8 ",{
"o5 e4 c+ e a4 g+ f+","o5 e2 c+2","o5 d4 f+ a g+4 e4","o5 e2. r4",
"o5 c+4 e a b4 a g+","o5 f+2 d2","o5 e4 d c+ o4 b4 g+4","o4 a2. r4",
}),
pulse2=a("t88 @1 v4 y0 q8 x3 l1 o3 ",h(y,"")),
wave=a("t88 @14 v2 l2 o2 ",d(y,function(r,f)return r.." "..f end)),
}

c[b.BELLS]={
loop=true,
pulse1=a("t120 @0 v11 y5 q8 l4 ",{
"o5 d a f d","o5 e c o4 a2","o5 d f g a","o5 e2. r4","o5 f e d c","o4 b- o5 c d2","o5 e c+ o4 a o5 e","o5 d2. r4",
}),
pulse2=a("t120 @0 v6 y5 q8 l2 ",{
"o4 d a","o4 c a","o4 b- g","o4 a c+","o4 d a","o4 g b-","o4 a c+","o4 d r",
}),
wave=a("t120 @28 v2 l1 o2 ",{"d","a","g","a","d","g","a","d"}),
noise=a("t120 l8 ",g("v4 y5 n24 r4. r2",8)),
}

local z={"F#m","D","F#m","E","D","Bm","D","C#","F#m","D","F#m","E","F#m","Bm","Bm","C#"}
local l="o4 f+ f+ a f+ o5 c+ o4 f+ o5 e o4 f+"
local A="o5 d c+ o4 b a b a g+ e"
local B="o5 d c+ o4 b o5 c+ d e f+4"
c[b.SPIRE]={
loop=true,
pulse1=a("t144 @1 v11 y0 q6 l8 ",{
l,A,l,B,
"o5 f+4. e d4 c+4","o4 b4. a b4 o5 c+4","o5 d4. c+ o4 b4 a4","o4 g+2 o5 c+2",
l,A,l,B,
"o5 a4. g+ f+4 e4","o5 d4. c+ d4 e4","o5 f+4 e d c+4 o4 b4","o5 c+2. r4",
}),
pulse2=a("t144 @2 v5 y0 q4 x1 l8 o3 ",m(z)),
wave=a("t144 @5 v3 l8 o2 ",d(z,function(r)return r.." "..r.." >"..r.."< "..r.." "..r.." "..r.." >"..r.."< "..r end)),
noise=a("t144 l8 ",g(k.drive,16)),
}

local C={"Em","Am","Em","C","C","Am","D","B","Em","D","G","C","Em","C","B","Em"}
c[b.BATTLE]={
loop=true,
pulse1=a("t168 @1 v11 y0 q6 l8 ",{
"o4 e e g e a e b e","o5 c o4 b a g f+ g a b","o4 e e g e a e b e","o5 d c o4 b o5 c d4 e4",
"o5 e4. d c4 o4 b4","o4 a4. g f+4 g4","o4 a4. b o5 c4 d4","o4 b2 d+2",
"o5 e4 o4 b g e4 g4","o4 a4 o5 c o4 a f+4 a4","o4 b4 o5 d o4 b g4 b4","o5 c2 o4 b2",
"o5 e4. f+ g4 f+4","o5 e4. d c4 o4 b4","o4 a4 b o5 c o4 b4 d+4","o4 e2. r4",
}),
pulse2=a("t168 @2 v5 y0 q4 x1 l8 o3 ",m(C)),
wave=a("t168 @5 v3 l8 o2 ",d(C,function(r)return r.." >"..r.."< "..r.." >"..r.."< "..r.." >"..r.."< "..r.." >"..r.."<"end)),
noise=a("t168 l8 ",g(k.fight,16)),
}

local D={"C#m","C#m","G#","G#","A","F#m","A","G#"}
c[b.BOSS]={
loop=true,
pulse1=a("t176 @1 v11 y0 q6 l8 ",{
"o4 c+ c+ e c+ g+ c+ f+ e","o4 c+ c+ e c+ a g+ f+ e","o4 d+ d+ f+ d+ a d+ g+ f+","o4 g+ a g+ f+ e d+ e f+",
"o5 c+4. o4 b a4 g+4","o4 a4. b o5 c+4 d+4","o5 e4 d+ c+ o4 b4 a4","o4 g+2 o5 c2",
}),
pulse2=a("t176 @2 v5 y0 q4 x1 l8 o3 ",m(D)),
wave=a("t176 @5 v3 l8 o2 ",d(D,function(r)return r.." "..r.." >"..r.."< "..r.." "..r.." >"..r.."< "..r.." "..r end)),
noise=a("t176 l8 ",g(k.drive,8)),
}

local E={"Gm","Gm","F","D","Eb","F","D","Gm","Cm","Fm","Bb","F","Eb","Cm","D","Gm"}
c[b.FINAL]={
loop=true,
pulse1=a("t152 @1 v12 y0 q7 l8 ",{
"o4 g4 b- o5 d g4 f e-","o5 d4. c o4 b-2","o4 a4 b- o5 c d4 e-4","o5 d2. r4",
"o5 g4 f e- d4 c o4 b-","o4 a4. b- o5 c2","o4 b-4 a g f+4 a4","o4 g2. r4",
"o5 e-4 d e- f4 g4","o5 a-4. g f2","o5 e-4 d c d4 o4 b-4","o5 c2 d2",
"o5 g4. a- g4 f4","o5 e-4. f e-4 d4","o5 c4 d e- d4 f+4","o5 g2. r4",
}),
pulse2=a("t152 @2 v6 y0 q8 x1 l1 o3 ",h(E,"")),
wave=a("t152 @5 v3 l8 o2 ",d(E,function(r)return r.." "..r.." "..r.." >"..r.."< "..r.." "..r.." "..r.." >"..r.."<"end)),
noise=a("t152 l8 ",g(k.fight,16)),
}

c[b.VICTORY]={
pulse1="t150 @2 v12 y0 q7 l8 o4 g b o5 d g4 f+ g a | o5 b2. r4",
pulse2="t150 @1 v7 y0 q7 l8 o4 d g b o5 d4 c o4 b o5 c | o5 d2. r4",
wave="t150 @12 v3 l4 o2 g >d< g >d< | g2. r4",
noise="t150 l8 "..e.." r "..i.." r "..e.." "..e.." "..i.." r | "..K,
}
c[b.DEFEAT]={
pulse1="t90 @2 v11 y0 q7 l8 o4 e d c o3 b a4 e4 | o3 a2. r4",
pulse2="t90 @1 v6 y0 q7 l8 o3 a g f e c4 o2 a4 | o2 a2. r4",
wave="t90 @12 v3 l4 o2 a e f e | a2. r4",
}
c[b.OVER]={
loop=true,
pulse1="t66 @2 v9 y0 q8 l8 o4 e2 c2 | o3 b2 a2 | o4 c2 o3 b2 | o3 a1",
wave="t66 @12 v2 l1 o2 a | e | f | a",
}
c[b.CHAPTER]={
pulse1="t100 @0 v11 y4 q8 l4 o5 d a f d | o5 e1",
pulse2="t100 @0 v7 y4 q8 l4 o4 a o5 d o4 a f | o4 a1",
wave="t100 @2 v3 l1 o2 d | a",
}
c[b.INN]={
pulse1="t84 @2 v10 y0 q8 l8 o4 c e g o5 c4 o4 g e g | o4 c1",
pulse2="t84 @1 v6 y0 q8 l4 o3 e g e g | o3 e1",
wave="t84 @12 v3 l2 o2 c g | c1",
}

local F={"Am","Am","F","E","F","Dm","E","Am"}
c[b.SAD]={
loop=true,
pulse1=a("t66 @2 v10 y0 q8 l8 ",{"o4 e2 a4 b4","o5 c2. o4 b4","o4 a2 g4 f4","o4 e1","o4 f2 a4 o5 c4","o5 d2. c4","o4 b2 g+2","o4 a1"}),
pulse2=a("t66 @2 v4 y0 q8 x4 l1 o3 ",h(F,"")),
wave=a("t66 @12 v2 l1 o2 ",d(F,function(r)return r end)),
}

local P={"C","F","C","G","C","F","G","C"}
c[b.COMIC]={
loop=true,
pulse1=a("t152 @3 v10 y2 q4 l8 ",{
"o4 c r e r g r e r","o4 f r a r g4 r4","o4 e r g r o5 c r o4 b r","o4 a4 g4 r2",
"o4 c r e r g r o5 c r","o5 d r c r o4 a4 f4","o4 g r b r o5 d r o4 b r","o5 c4 o4 g4 o5 c4 r4",
}),
wave=a("t152 @5 v3 l8 o2 ",d(P,function(r,f)return r.." r "..f.." r "..r.." r "..f.." r"end)),
noise=a("t152 l8 ",g("v4 y1 n90 r v4 y1 n70 r v4 y1 n90 r v4 y1 n70 r",8)),
}

local G={"F","C","F","C","Bb","F","C","F"}
c[b.LOVE]={
loop=true,
pulse1=a("t76 @2 v10 y0 q8 l8 ",{"o4 a2 o5 c4 o4 a4","o4 g2. f4","o4 f4 a o5 c f2","o5 e2. r4","o5 d2 c4 o4 b-4","o4 a2. g4","o4 a4 b- o5 c d4 e4","o5 f1"}),
pulse2=a("t76 @1 v4 y0 q8 x3 l1 o3 ",h(G,"")),
wave=a("t76 @12 v2 l2 o2 ",d(G,function(r,f)return r.." "..f end)),
}

c[b.TENSION]={
loop=true,
pulse1=a("t100 @1 v8 y0 q8 l8 ",{"o4 a1","o4 b-1","o4 a1","o4 g+1"}),
pulse2=a("t100 @0 v6 y2 q8 l8 ",g("o4 d d e- d d d e- d",4)),
wave=a("t100 @5 v3 l8 o2 ",g("d r d r d r d r",4)),
noise=a("t100 l8 ",g("v8 y2 n115 v6 y2 n115 r4. r4.",4)),
}

local H={"G","C","Am","D","G","Em","C","D","G","C","G","D","G","D","D","G"}
c[b.ENDING]={
loop=true,
pulse1=a("t96 @2 v11 y0 q7 l8 ",{
"o4 g4 b o5 d f+ d","o5 c4. o4 b a g","o4 a4 o5 c e g4","o5 f+2.",
"o5 d4 f+ g a4","o5 b4. a g f+","o5 e4 f+ e d c","o5 d2.",
"o5 g4 f+ d o4 b4","o5 c4. d e4","o5 d4 o4 b g b4","o4 a2.",
"o4 g4 b o5 d g4","o5 f+4. e d4","o5 c4 o4 a f+ a4","o4 g2.",
}),
pulse2=a("t96 @2 v5 y0 q8 x2 o3 ",h(H,"2.")),
wave=a("t96 @12 v3 l8 o2 ",d(H,function(r,f)return r.."2 "..f.."4"end)),
noise=a("t96 l8 ",g(k.waltzTap,16)),
}

local I={"Bm","G","D","F#","Bm","G","Em","F#"}
c[b.TRIAL]={
loop=true,
pulse1=a("t104 @0 v9 y2 q8 l8 ",{
"o4 f+2 b4 a4","o4 g2. r4","o4 f+4 a4 o5 d4 c+4","o4 a+2. r4",
"o4 b4 o5 c+ d c+4 o4 b4","o4 g2 a4 b4","o4 e4 g b a4 g4","o4 f+1",
}),
pulse2=a("t104 @2 v4 y0 q8 x3 l1 o3 ",h(I,"")),
wave=a("t104 @12 v2 l2 o2 ",d(I,function(r,f)return r.." "..f end)),
noise=a("t104 l8 ",g("r4 v3 y1 n82 r r4 v3 y1 n82 r",8)),
}

local J={"F#m","D","E","C#","F#m","D","B","C#"}
c[b.SECRET]={
loop=true,
pulse1=a("t160 @1 v12 y0 q6 l8 ",{
"o4 f+ a o5 c+ f+ e4 c+4","o5 d4. c+ o4 b2","o4 g+ b o5 e g+ f+4 e4","o5 f2. r4",
"o5 f+4 e d c+ o4 b4 a","o4 b4. o5 c+ d2","o5 d+4 e f+ d+4 o4 b4","o5 f1",
}),
pulse2=a("t160 @2 v6 y0 q8 x1 l1 o3 ",h(J,"")),
wave=a("t160 @5 v3 l8 o2 ",d(J,function(r,f)return r.." "..r.." "..f.." "..r.." >"..r.."< "..f.." "..r.." "..f end)),
noise=a("t160 l8 ",g(e.." "..e.." "..i.." r "..e.." r "..i.." "..j,8)),
}

local r={
cursor={pulse2="t240 @0 v7 y1 l32 o6 d"},
confirm={pulse2="t220 @2 v9 y2 l32 o5 g >d"},
cancel={pulse2="t220 @2 v8 y2 l32 o5 d <a"},
buzz={pulse2="t200 @3 v9 y1 l32 o3 c c+ c"},
open={pulse2="t240 @1 v8 y1 l32 o5 a >e a"},
talk={pulse2="t255 @0 v4 y1 l64 o5 a"},
hit={noise="t240 l16 v12 y2 n{36 70}"},
crit={noise="t240 l16 v13 y3 n{20 52 84}",pulse1="t240 @0 v9 y2 s1,-2 l16 o5 c"},
miss={noise="t240 l16 v5 y1 n{18 22}"},
heal={pulse2="t200 @2 v9 y2 l32 o5 c e g >c e"},
status={pulse2="t220 @1 v8 y2 l32 o4 g+ d g+ d"},
fall={noise="t140 l8 v11 y4 n{50 82 114}",pulse1="t160 @2 v8 y3 s2,-2 l8 o4 e"},
turn={pulse2="t240 @2 v6 y1 l32 o5 e b"},
guard={pulse2="t240 @3 v8 y2 l16 o3 g"},
flee={pulse1="t200 @2 v8 y2 s2,3 l8 o4 c"},
bright={pulse1="t180 @2 v12 y3 s1,3 l8 o4 g",noise="t180 l4 v10 y5 n{17 33}"},
door={noise="t240 l16 v7 y2 n{60 92}"},
chest={pulse2="t200 @1 v9 y1 l32 o5 e g+ b >e"},
lamp={pulse1="t160 @2 v10 y4 s3,4 l8 o4 a",noise="t160 l16 v5 y2 n19"},
join={pulse2="t180 @2 v10 y1 l16 o5 d f+ a >d"},
rumble={noise="t60 l2 v10 y6 n{119 118}"},
save={pulse2="t200 @2 v9 y2 l16 o5 a >c+ e a"},
buy={pulse2="t240 @1 v9 y1 l32 o6 c o5 g o6 e"},
item={pulse2="t180 @2 v10 y1 l16 o5 g >c e g"},
bump={noise="t240 l32 v6 y1 n100"},
ambush={pulse1="t200 @1 v10 y2 s1,-1 l8 o5 e",noise="t200 l8 v8 y2 n{25 57 89}"},
emote={pulse2="t240 @2 v7 y1 l32 o6 c e"},
equip={noise="t240 l32 v8 y1 n{40 56}",pulse2="t240 @1 v7 y1 l32 o4 g"},
bell={pulse1="t120 @0 v11 y6 l2 o5 d",pulse2="t120 @0 v7 y6 l2 o4 a"},
}

b.EFFECTS={}
for f,Q in pairs(r)do
c["fx_"..f]=Q
b.EFFECTS[f]=true
end

function b.effectName(name)
if not b.EFFECTS[name]then
error("Lanterways: no sound effect named "..tostring(name))
end
return"fx_"..name
end

b.TUNES=c

SpiffBoy.Tunes.register(n.ID,c)
