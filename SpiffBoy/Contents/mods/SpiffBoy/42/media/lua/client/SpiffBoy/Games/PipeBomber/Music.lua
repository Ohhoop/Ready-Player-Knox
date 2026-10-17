require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"

SpiffBoy.PipeBomber=SpiffBoy.PipeBomber or{}

local a={}
SpiffBoy.PipeBomber.Music=a

a.TITLE="title"
a.ZONE={
rosewood="rosewood",muldraugh="muldraugh",marchridge="marchridge",westpoint="westpoint",
riverside="riverside",ekron="ekron",base="base",louisville="louisville",
}
a.BOSS="boss"
a.FINAL="final"
a.HURRY="hurry"
a.START="start"
a.CLEAR="clear"
a.DEATH="death"
a.OVER="over"
a.ENDING="ending"
a.TICK="tick"
a.CONFIRM="confirm"
a.STEP="step"
a.COUNT="count"
a.WRONG="wrong"
a.PLACE="place"
a.BLAST="blast"
a.KICK="kick"
a.CLICK="click"
a.PICKUP="pickup"
a.ZOMBIE="zombie"
a.BOSS_HIT="bossHit"
a.BOSS_DOWN="bossDown"
a.OPEN="open"
a.SHOT="shot"
a.THUD="thud"
a.CALL="call"
a.THROW="throw"
a.STRIKE="strike"
a.BURN="burn"

local n={"c","d","e","f","g","a","b",">c",">d",">e",">f"}
a.MIX_STEPS=#n-1

local b="v11 y1 n{48 80 113}"
local d="v8 y2 n64"
local e="v3 y1 n80"
local c={
march=b.." r "..d.." r "..b.." r "..d.." r",
machine=b.." "..e.." "..d.." "..e.." "..b.." "..e.." "..d.." "..e,
bounce=b.." r "..e.." "..b.." "..d.." r "..e.." r",
school=b.." "..e.." "..d.." "..e.." "..b.." "..b.." "..d.." "..e,
soft="r r "..e.." r r r "..e.." r",
lilt=b.." r "..e.." r "..d.." r "..e.." "..e,
farm=b.." "..e.." "..d.." "..b.." "..b.." "..e.." "..d.." "..e,
drill=b.." r "..d.." "..d.." "..b.." r "..d.." "..d,
drive=b.." "..e.." "..d.." "..e.." "..b.." "..b.." "..d.." "..e,
}
local i=b.." r "..d.." r "..d.." n64 v9 y2 n64 n64"
local j="r "..e.." r n80"
local o="l2 v12 y5 n{16 32 48} r"
local k={
C="{ceg}",Cm="{ce-g}",D="{df+a}",Dm="{dfa}",Db="{d-fa-}",E="{eg+b}",Em="{egb}",
F="{fa>c}",Fm="{fa->c}",["F#"]="{f+a+>c+}",G="{gb>d}",Gm="{gb->d}",Ab="{a->ce-}",
A="{a>c+e}",Am="{a>ce}",Bb="{b->df}",B="{b>d+f+}",Bm="{b>df+}",
}

local function f(g,h)
return g..table.concat(h," | ")
end

local function g(h)
return h.." >"..h.."< "..h.." "..h.." >"..h.."< "..h.." "..h.." >"..h.."<"
end

local function q(h)
return"l4 "..h.." >"..h.."< "..h.." >"..h.."< l8"
end

local function l(m,p)
local h={}
for r,s in ipairs(m)do
h[r]=p(s)
end
return h
end

local function r(m)
local h={}
for p,s in ipairs(m)do
h[p]=k[s]
end
return h
end

local function s(p,t)
local h={}
for m=1,t do
if m%8==0 then
h[m]=i
else
h[m]=p
end
end
return h
end

local function h(t,u,p,v,w,x,y)
local m="t"..t
return{
loop=true,
pulse1=f(m.." @"..u.." v11 y0 q7 l8 ",p),
pulse2=f(m.." @2 v6 y0 q8 x1 l1 o3 ",r(v)),
wave=f(m.." @5 v3 l8 o2 ",l(w,x)),
noise=f(m.." l8 ",s(y,#p)),
}
end

local m={
[a.TITLE]={
loop=true,
pulse1=f("t126 @2 v11 y0 q7 l8 ",{
"o4 g4 b- o5 d c4 o4 b- a","o4 g4 d g a2","o4 b-4 o5 d f e-4 d c","o5 d2. r4",
"o4 g4 b- o5 d g4 f d","o5 e-4 d c o4 b-4 a g","o4 a4 b- o5 c d4 c o4 a","o4 g2. r4",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=f("t126 @12 v3 l4 o2 ",{
"g >d< g >d<","g >d< d a","e- b- e- b-","d a d a",
"g >d< g >d<","c g c g","d a d f+","g2. r4",
}),
noise=f("t126 l4 ",{j,j,j,j,j,j,j,"r "..e.." r r"}),
},
[a.ZONE.rosewood]=h(132,2,{
"o4 d4 f a o5 d4 c o4 a","o4 b-4 a g a2","o4 b-4 o5 d f e4 d c+","o5 d2 o4 a2",
"o4 d4 f a o5 d4 e f","o5 g4 f e f4 d4","o5 e4 c+ o4 a b-4 g4","o4 a2. r4",
"o5 f4 e d c4 o4 b- a","o4 b-4 a g f4 e d","o4 a4 o5 c f a4 g f","o5 g2 e2",
"o5 f4 e d e4 f g","o5 a4 g f e4 d c+","o5 d4 o4 a f e4 c+4","o4 d2. r4",
},{"Dm","Dm","Bb","A","Dm","Gm","A","A","Bb","Gm","F","C","Dm","A","A","Dm"},
{"d","d","b-","a","d","g","a","a","b-","g","f","c","d","a","a","d"},g,c.march),
[a.ZONE.muldraugh]=h(140,1,{
"o4 e g b g o5 e o4 b g b","o4 e g b g o5 f+ o4 b g b","o4 c e g e o5 e o4 g e g","o4 d f+ a f+ o5 d4 o4 b4",
"o4 e g b g o5 e o4 b g b","o4 e g b g o5 g f+ e d","o4 c e g e o5 c o4 b a g","o4 b2 d+2",
"o5 e4. d c4 o4 b4","o4 a4. b o5 c4 o4 a4","o4 b4. o5 c d4 o4 b4","o5 e2 o4 b2",
"o5 e4. f+ g4 f+4","o5 e4. d c4 o4 a4","o4 b4 o5 c o4 b a4 f+4","o4 e2. r4",
},{"Em","Em","C","D","Em","Em","C","B","C","Am","G","Em","C","Am","B","Em"},
{"e","e","c","d","e","e","c","b","c","a","g","e","c","a","b","e"},g,c.machine),
[a.ZONE.marchridge]=h(144,2,{
"o4 g4 b o5 d g4 f+ d","o5 e4 c o4 a b4 g4","o4 a4 b o5 c d4 o4 b g","o4 a2 d2",
"o4 g4 b o5 d g4 a b","o5 c4 o4 b a g4 e4","o5 d4 c o4 b a4 f+4","o4 g2. r4",
"o4 e4 g b o5 e4 d c","o5 d4 o4 b g a4 b4","o5 c4 o4 a f+ g4 a b","o5 c2 o4 a2",
"o4 b4 o5 d g f+4 e d","o5 e4 g f+ e4 d c","o4 b4 a g a4 f+4","o4 g2. r4",
},{"G","C","D","D","G","C","D","G","Em","C","D","Am","G","C","D","G"},
{"g","c","d","d","g","c","d","g","e","c","d","a","g","c","d","g"},g,c.bounce),
[a.ZONE.westpoint]=h(150,2,{
"q6 o4 c e g o5 c o4 g e c4","o4 d f a o5 d o4 a f d4","o4 e g b o5 e o4 b g e4","q7 o4 f2 g2",
"q6 o4 c e g o5 c e d c4","o4 a o5 c e a g f e4","q7 o5 d4 c o4 b o5 c4 o4 b a","o4 g2. r4",
"o5 c4 o4 g o5 c e4 d c","o4 b4 g b o5 d4 c o4 b","o4 a4 f a o5 c4 o4 b a","o4 g2 e2",
"o4 f4 a o5 c f4 e d","o5 e4 c o4 a b4 g4","o4 f4 e d g4 b4","o5 c2. r4",
},{"C","Dm","Em","F","C","Am","G","G","C","G","F","C","F","Am","G","C"},
{"c","d","e","f","c","a","g","g","c","g","f","c","f","a","g","c"},g,c.school),
[a.ZONE.riverside]=h(128,2,{
"o4 f2 a4 o5 c4","o5 d2 c4 o4 a4","o4 g2 b-4 o5 d4","o5 c2. r4",
"o4 f2 a4 o5 c4","o5 f2 e4 d4","o5 c4 o4 b- a g4 a4","o4 f2. r4",
"o4 a2 b-4 o5 c4","o5 d2 f4 e4","o5 d4 c o4 b- a4 g4","o4 a2 o5 c2",
"o5 d2 e4 f4","o5 g2 f4 e4","o5 d4 c o4 b- a4 g4","o4 f2. r4",
},{"F","Bb","Gm","C","F","Dm","C","F","F","Bb","Gm","F","Bb","C","C","F"},
{"f","b-","g","c","f","d","c","f","f","b-","g","f","b-","c","c","f"},q,c.lilt),
[a.ZONE.ekron]=h(148,2,{
"o4 a o5 c+ e c+ o4 a o5 c+ e4","o5 d f+ a f+ d f+ a4","o5 e d c+ o4 b a b o5 c+ d","o5 e2 o4 e2",
"o4 a o5 c+ e c+ o4 a o5 c+ e4","o5 d f+ a f+ e d c+4","o4 b o5 c+ d e d c+ o4 b4","o4 a2. r4",
"o5 c+4 e a4 e c+4","o5 d4 f+ a4 f+ d4","o5 e4 g+ b4 g+ e4","o5 a2 e2",
"o5 c+ d e f+ e d c+ o4 b","o4 a b o5 c+ d c+ o4 b a4","o4 g+ a b o5 c+ o4 b4 g+4","o4 a2. r4",
},{"A","D","A","E","A","D","E","A","A","D","E","A","A","D","E","A"},
{"a","d","a","e","a","d","e","a","a","d","e","a","a","d","e","a"},g,c.farm),
[a.ZONE.base]=h(156,1,{
"o4 b4. b b4 o5 d4","o5 c+4. o4 b a+4 f+4","o4 b4. b b4 o5 d4","o5 f+2 e2",
"o5 d4. c+ o4 b4 o5 d4","o5 c+4. o4 b a4 o5 c+4","o4 b4 a g f+4 e4","o4 f+2. r4",
"o5 f+4. e d4 c+4","o5 d4. c+ o4 b4 a4","o4 g4. a b4 o5 c+4","o5 d2 c+2",
"o5 f+4. g a4 g4","o5 f+4. e d4 c+4","o4 b4 o5 c+ d c+4 o4 a+4","o4 b2. r4",
},{"Bm","F#","Bm","Em","G","A","Em","F#","Bm","G","Em","A","D","G","F#","Bm"},
{"b","f+","b","e","g","a","e","f+","b","g","e","a","d","g","f+","b"},g,c.drill),
[a.ZONE.louisville]=h(160,1,{
"o4 c e- g c e- g o5 c4","o4 b- o5 d f d o4 b- o5 d f4","o4 a- o5 c e- c o4 a- o5 c e-4","o4 g b o5 d f e- d o4 b4",
"o4 c e- g c e- g o5 c4","o5 d e- f g f e- d4","o5 e- d c d o4 b g b4","o5 c2. r4",
"o5 g4. f e-4 d4","o5 f4. e- d4 c4","o5 e-4. d c4 o4 b-4","o4 b2 o5 d2",
"o5 g4. a- g4 f4","o5 e-4. f g4 a-4","o5 g4 f e- d4 o4 b4","o5 c2. r4",
},{"Cm","Bb","Ab","G","Cm","Fm","G","Cm","Cm","Bb","Ab","G","Cm","Ab","G","Cm"},
{"c","b-","a-","g","c","f","g","c","c","b-","a-","g","c","a-","g","c"},g,c.drive),
[a.BOSS]={
loop=true,
pulse1=f("t164 @1 v11 y0 q6 l8 ",{
"o4 a a o5 c o4 a o5 d o4 a o5 e o4 a","o4 a a o5 c o4 a o5 f e d c","o4 a a o5 c o4 a o5 d o4 a o5 e o4 a","o5 f e d c o4 b g+ a b",
"o5 e4 d c d4 c o4 b","o5 c4 o4 b a b4 a g+","o5 f4 e d e4 d c","o4 b2 g+2",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=f("t164 @5 v3 l8 o2 ",l({"a","a","a","e","a","a","d","e"},g)),
noise=f("t164 l8 ",{c.drive,c.drive,c.drive,i,c.drive,c.drive,c.drive,i}),
},
[a.FINAL]={
loop=true,
pulse1=f("t172 @1 v11 y0 q6 l8 ",{
"o4 f f a- f b f o5 c o4 f","o4 f f a- f o5 d- c o4 b- a-","o4 f f a- f b f o5 c o4 f","o4 g a- b- o5 c d- c o4 b- g",
"o5 f4 e- d- c4 o4 b- a-","o5 d-4 c o4 b- o5 c4 o4 a- g","o4 a-4 b- o5 c d-4 e-4","o5 c2 e2",
}),
pulse2={echo="pulse1",delay=8,drop=5},
wave=f("t172 @5 v3 l8 o2 ",l({"f","f","f","c","d-","b-","d-","c"},g)),
noise=f("t172 l8 ",{c.drive,c.drill,c.drive,i,c.drive,c.drill,c.drive,i}),
},
[a.HURRY]={
loop=true,
pulse1=f("t180 @1 v11 y0 q6 l8 ",{"o4 e f e f e f e d+","o4 e f e f g f e d+","o4 e f e f e f e d+","o4 e2 b2"}),
pulse2=f("t180 @2 v6 y0 q8 x1 l1 o3 ",{k.Em,k.Em,k.Em,k.B}),
wave=f("t180 @5 v3 l8 o2 ",l({"e","e","e","b"},g)),
noise=f("t180 l8 ",{c.drill,c.drill,c.drill,i}),
},
[a.START]={
pulse1="t150 @2 v12 y0 q7 l8 o4 g o5 c e g4 e g4 | o5 c2 r2",
pulse2="t150 @1 v7 y0 q7 l8 o4 e g o5 c e4 c e4 | o4 g2 r2",
wave="t150 @12 v3 l4 o2 c g c g | c2 r2",
noise="t150 l8 "..b.." r "..d.." r "..b.." "..b.." "..d.." r | "..b.." r r r r r r r",
},
[a.CLEAR]={
pulse1="t150 @2 v12 y0 q7 l8 o4 c e g o5 c4 o4 g o5 c4 | o5 e2 r2",
pulse2="t150 @1 v7 y0 q7 l8 o3 g o4 c e g4 e g4 | o5 c2 r2",
wave="t150 @12 v3 l4 o2 c >c< g >c< | c2 r2",
noise="t150 l8 "..b.." r "..d.." r "..b.." "..b.." "..d.." r | "..o,
},
[a.DEATH]={
pulse1="t100 @2 v12 y0 q7 l8 o5 c o4 b b- a a- g4. | o4 f+2 r2",
pulse2="t100 @1 v7 y0 q7 l8 o4 e- d d- c o3 b b-4. | o3 a2 r2",
noise="t100 l8 r r r r r r r r | v10 y4 n{64 96 113} r r r r2",
},
[a.OVER]={
pulse1="t84 @2 v11 y0 q7 l8 o4 d c o3 b- a g4 d4 | o3 g2. r4",
pulse2="t84 @1 v7 y0 q7 l8 o3 b- a g f+ d4 o2 b-4 | o2 b-2. r4",
wave="t84 @12 v3 l4 o2 g d e- d | g2. r4",
},
[a.ENDING]={
pulse1="t116 @2 v12 y0 q7 l8 o4 c e g o5 c4 o4 g o5 c e | o5 d4 c o4 b o5 c2 | o4 a o5 c f a4 g f e | o5 d2 g2 | o5 c1",
pulse2="t116 @1 v7 y0 q7 l8 o4 e g o5 c e4 c e g | o4 b4 a g a2 | o4 f a o5 c f4 e d c | o4 b2 o5 d2 | o4 g1",
wave="t116 @12 v3 l4 o2 c g c g | g >d< g >d< | f >c< f >c< | g >d< g >d< | c1",
noise="t116 l8 "..c.bounce.." | "..c.bounce.." | "..c.bounce.." | "..i.." | "..o,
},
[a.TICK]={pulse2="t240 @1 v8 y1 l16 o5 e"},
[a.CONFIRM]={pulse2="t200 @2 v10 y2 l16 o5 c e g"},
[a.COUNT]={pulse2="t240 @2 v9 y1 l16 o5 g"},
[a.WRONG]={pulse2="t200 @1 v10 y2 l16 o4 c r o3 b"},
[a.PLACE]={pulse2="t240 @1 v8 y2 l32 o3 g c"},
[a.BLAST]={noise="t120 l4 v13 y4 n{32 48 64 80 96 113}"},
[a.KICK]={noise="t240 l16 v10 y2 n{48 80}"},
[a.CLICK]={pulse2="t240 @1 v9 y1 l32 o5 c o6 c"},
[a.PICKUP]={pulse2="t240 @2 v10 y1 l32 o5 c e g >c e"},
[a.ZOMBIE]={noise="t200 l16 v10 y3 n{64 96 113}",pulse2="t200 @1 v7 y2 l32 o3 c o2 g"},
[a.BOSS_HIT]={pulse2="t240 @3 v11 y3 l16 o4 c o3 c",noise="t240 l32 v9 y1 n{32 48}"},
[a.BOSS_DOWN]={noise="t100 l2 v13 y5 n{32 48 64 80 96 113}",pulse1="t120 @1 v10 y3 l4 o3 c p20 o2 g"},
[a.OPEN]={pulse2="t200 @2 v10 y1 l32 o5 e g b >e"},
[a.SHOT]={pulse1="t240 @0 v9 y2 s1,-2 o5 c8"},
[a.THUD]={noise="t240 l8 v12 y3 n{113 112}"},
[a.CALL]={pulse2="t240 @2 v10 y1 l32 o6 c d c d c d"},
[a.THROW]={pulse1="t200 @2 v9 y2 s2,-3 l8 o5 c"},
[a.STRIKE]={noise="t240 l16 v12 y2 n{48 64}"},
[a.BURN]={noise="t240 l16 v8 y2 n32"},
}

for p=0,a.MIX_STEPS do
m[a.STEP..p]={pulse2="t240 @2 v10 y1 l16 o5 "..n[p+1]}
end

SpiffBoy.Tunes.register("PipeBomber",m)
