require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Tunes"
require"SpiffBoy/Games/QuickStart/Base"

local o=SpiffBoy.QuickStart

local a={}
o.Music=a

a.TITLE="title"
a.MENU="menu"
a.SELECT="select"
a.MAP="map"
a.INTRO="intro"
a.RESULTS="results"
a.PODIUM="podium"
a.GOAL="goal"
a.LOST="lost"
a.RECORD="record"
a.TRACKS={
Muldraugh="muldraugh",Riverside="riverside",MarchRidge="marchridge",EchoCreek="echocreek",
WestPoint="westpoint",Rosewood="rosewood",Louisville="louisville",KnoxBase="knoxbase",
GasStation="gasstation",SpiffosLot="spiffoslot",
}
a.FAST="_fast"
a.TICK="tick"
a.CONFIRM="confirm"
a.BACK="back"
a.LIGHT="light"
a.GO="go"
a.CRATE="crate"
a.ROULETTE="roulette"
a.THROW="throw"
a.BOOST="boost"
a.SPIN="spin"
a.BOOM="boom"
a.SHOT="shot"
a.CHOPPER="chopper"
a.THUNDER="thunder"
a.MONEY="money"
a.BUMP="bump"
a.SPLASH="splash"
a.LAP="lap"
a.HOP="hop"
a.RIOT="riot"
a.CAN="can"

local c="v13 y1 n{36 88 120}"
local d="v10 y2 n{52 68}"
local g="v3 y1 n104"
local m="v6 y4 n72"
local k="v8 y1 n{60 76}"

local s={
road={c,g,d,g,c,c,d,g},
swing={c,g,g,d,g,g,c,d},
drive={c,g,d,g,c,g,d,m},
march={c,k,d,k,c,k,d,d},
funk={c,g,d,c,g,c,d,g},
punk={c,d,c,d,c,d,c,d},
}
local t=table.concat({c,d,d,d,c,k,k,m}," ")

local u={
c="{ceg}",f="{fa>c}",g="{gb>d}",am="{ace}",dm="{dfa}",em="{egb}",d="{df+a}",a="{ac+e}",
e="{eg+b}",bm="{bd>f+}",["b-"]="{b->df}",["e-"]="{e-gb-}",gm="{gb->d}",cm="{ce-g}",fm="{fa->c}",
b="{bd+f+}",["f+m"]="{f+ac+}",
}

local function l(header,bars)
return header..table.concat(bars," | ")
end

local function p(groove,count)
local f=table.concat(s[groove]," ")
local b={}
for e=1,count do
b[e]=(e%8==0)and t or f
end
return b
end

local function v(root,fifth)
return root.." "..root.." "..fifth.." "..root.." >"..root.."< "..fifth.." "..root.." "..fifth
end

local function w(root)
return root.." "..root.." "..root.." "..root.." "..root.." "..root.." >"..root.."< "..root
end

local function x(chord)
return chord.."4 r "..chord.." r "..chord.." "..chord.."4"
end

local function j(chord)
return"r "..chord.." r "..chord.." r "..chord.." r "..chord
end

local function q(builder,list)
local e={}
for f,b in ipairs(list)do
if type(b)=="table"then
e[f]=builder(b[1],b[2])
else
e[f]=builder(b)
end
end
return e
end

local function y(names)
local b={}
for e,f in ipairs(names)do
b[e]=u[f]
end
return b
end

local function e(tempo,lead,melody,harmony,roots,groove,compStyle)
local b="t"..tempo.." "
local f=q(compStyle or x,y(harmony))
return{
loop=true,
pulse1=l(b.."@"..lead.." v12 y0 q6 l8 ",melody),
pulse2=l(b.."@2 v6 y0 q5 l8 o3 ",f),
wave=l(b.."@5 v3 l8 o2 ",q(groove=="march"and w or v,roots)),
noise=l(b.."l8 ",p(groove,#melody)),
}
end

local b={}

b[a.TRACKS.Muldraugh]=e(156,1,{
"o5 c4 e g e4 d c","o4 a4 o5 c d e2","o5 f4 e d c4 o4 a o5 c","o5 d2 r4 o4 g4",
"o5 c4 e g a4 g e","o5 f4 e d e2","o5 d4 c o4 a g4 a b","o5 c2. r4",
},{"c","am","f","g","c","f","g","c"},{{"c","g"},{"a","e"},{"f","c"},{"g","d"},{"c","g"},{"f","c"},{"g","d"},{"c","g"}},"road")

b[a.TRACKS.Riverside]=e(148,2,{
"o4 g4 b o5 d e4 d o4 b","o5 c4 o4 a f+ g2","o4 g4 b o5 d g4 f+ e","o5 d2 r2",
"o5 e4 d c o4 b4 a g","o4 a4 b o5 c d2","o5 e4 f+ g d4 c o4 a","o4 g2. r4",
},{"g","d","g","d","c","d","c","g"},{{"g","d"},{"d","a"},{"g","d"},{"d","a"},{"c","g"},{"d","a"},{"c","g"},{"g","d"}},"swing",j)

b[a.TRACKS.MarchRidge]=e(152,2,{
"o4 a4 o5 c e d4 c o4 b","o4 a4 g e a2","o5 c4 d e g4 e d","o5 e2 r4 e4",
"o5 f4 e d c4 o4 b a","o4 g4 a b o5 c2","o4 b4 o5 c d e4 d o4 b","o4 a2. r4",
},{"am","em","am","em","dm","g","em","am"},{{"a","e"},{"e","b"},{"a","e"},{"e","b"},{"d","a"},{"g","d"},{"e","b"},{"a","e"}},"road")

b[a.TRACKS.EchoCreek]=e(164,3,{
"o4 d4 f+ a o5 d4 o4 b a","o4 f+4 e d e2","o4 g4 b o5 d e4 d o4 b","o4 a2 r4 a4",
"o5 d4 c+ o4 b a4 f+ a","o4 b4 a g f+2","o4 e4 f+ g a4 b o5 c+","o5 d2. r4",
},{"d","d","g","a","d","g","a","d"},{{"d","a"},{"d","a"},{"g","d"},{"a","e"},{"d","a"},{"g","d"},{"a","e"},{"d","a"}},"swing")

b[a.TRACKS.WestPoint]=e(158,1,{
"o5 f4 a o6 c o5 a4 g f","o5 e4 g b- a2","o5 d4 f a g4 f d","o5 e2 r4 c4",
"o5 f4 a o6 c d4 c o5 a","o5 b-4 a g a2","o5 g4 a b- o6 c4 o5 b- g","o5 f2. r4",
},{"f","c","dm","c","f","b-","c","f"},{{"f","c"},{"c","g"},{"d","a"},{"c","g"},{"f","c"},{"b-","f"},{"c","g"},{"f","c"}},"funk",j)

b[a.TRACKS.Rosewood]=e(166,1,{
"o4 e4 e g f+ e4 b","o5 c4 o4 b a b2","o4 e4 e g a b4 o5 d","o5 c2 o4 b2",
"o5 e4 d c o4 b4 a g","o4 f+4 g a b2","o5 c4 o4 b a g4 f+ d+","o4 e2. r4",
},{"em","am","em","am","em","b","am","em"},{{"e","b"},{"a","e"},{"e","b"},{"a","e"},{"e","b"},{"b","f+"},{"a","e"},{"e","b"}},"drive")

b[a.TRACKS.Louisville]=e(172,1,{
"o4 a4 o5 c+ e a4 g+ e","o5 f+4 e c+ e2","o5 d4 c+ o4 b a4 b o5 c+","o4 b2 r4 e4",
"o5 a4 g+ f+ e4 c+ e","o5 f+4 g+ a b2","o5 a4 f+ e d4 c+ o4 b","o4 a2. r4",
},{"a","f+m","d","e","a","d","e","a"},{{"a","e"},{"f+","c+"},{"d","a"},{"e","b"},{"a","e"},{"d","a"},{"e","b"},{"a","e"}},"drive")

b[a.TRACKS.KnoxBase]=e(160,2,{
"o4 b-4 b- b- o5 d4 c o4 b-","o5 c4 o4 a f a2","o4 b-4 b- o5 d f4 e- d","o5 c2 r4 f4",
"o5 f4 e- d c4 o4 b- a","o4 b-4 o5 c d e-2","o5 d4 c o4 b- a4 g f","o4 b-2. r4",
},{"b-","f","b-","f","b-","e-","f","b-"},{"b-","f","b-","f","b-","e-","f","b-"},"march")

b[a.TRACKS.GasStation]=e(184,1,{
"o4 e e g e a4 g e","o4 b4 a g e2","o4 e e g e a4 b o5 d","o5 e2 r2",
"o5 d4 o4 b g a4 g e","o4 g4 a b o5 c2","o4 b4 g e g4 f+ d","o4 e2. r4",
},{"em","em","em","em","g","c","em","em"},{{"e","b"},{"e","b"},{"e","b"},{"e","b"},{"g","d"},{"c","g"},{"e","b"},{"e","b"}},"punk",j)

b[a.TRACKS.SpiffosLot]=e(150,3,{
"o5 g4 e c e4 g a","o5 g4 e d c2","o5 a4 f d f4 a b","o5 a4 g f g2",
"o5 g4 e c e4 g o6 c","o6 d4 c o5 b a2","o5 g4 a b o6 c4 o5 b a","o5 g2. r4",
},{"c","c","dm","g","c","g","g","c"},{{"c","g"},{"c","g"},{"d","a"},{"g","d"},{"c","g"},{"g","d"},{"g","d"},{"c","g"}},"funk")

b[a.TITLE]=e(144,1,{
"o5 c4 c d e4 g4","o5 a4 g e d2","o5 c4 c d e4 g a","o5 g2 r4 e4",
"o5 f4 a g e4 c4","o5 d4 e f e2","o5 c4 d e f4 e d","o5 c2. r4",
},{"c","f","c","g","f","g","c","c"},{{"c","g"},{"f","c"},{"c","g"},{"g","d"},{"f","c"},{"g","d"},{"c","g"},{"c","g"}},"road")

b[a.MENU]=e(132,3,{
"o4 g4 a b o5 d4 c o4 b","o4 a4 b o5 c d2","o4 g4 a b o5 d4 e d","o5 c2 o4 b2",
},{"g","am","g","c"},{{"g","d"},{"a","e"},{"g","d"},{"c","g"}},"swing",j)

b[a.SELECT]=e(140,2,{
"o5 e4 d c d4 e g","o5 a4 g e g2","o5 f4 e d e4 f a","o5 g2. r4",
},{"c","am","dm","g"},{{"c","g"},{"a","e"},{"d","a"},{"g","d"}},"funk")

b[a.MAP]=e(120,3,{
"o4 e4 g a b2","o4 a4 g e d2","o4 e4 g a b4 o5 d4","o5 c2 o4 b2",
},{"em","am","em","g"},{{"e","b"},{"a","e"},{"e","b"},{"g","d"}},"swing",j)

b[a.INTRO]={pulse1="t150 @1 v12 y2 l8 o5 c e g >c4 r <g >c2",pulse2="t150 @2 v7 y2 l8 o4 e g >c e4 r c e2",wave="t150 @5 v3 l4 o2 c g c2",noise="t150 l4 "..c.." "..d.." l2 "..m}
b[a.RESULTS]=e(128,2,{
"o5 c4 e g a4 g e","o5 f4 e d c2","o4 a4 o5 c e g4 e c","o5 d2. r4",
},{"c","f","am","g"},{{"c","g"},{"f","c"},{"a","e"},{"g","d"}},"swing",j)
b[a.PODIUM]={pulse1="t132 @1 v12 y0 q7 l8 o5 c4 e g >c4 <b >c | d4 c <b >c2 | <a4 >c e d4 c <a | g2 >c2",pulse2="t132 @2 v7 y0 q6 l8 o4 e4 g >c e4 d e | f4 e d e2 | c4 e a f4 e c | <b2 >e2",wave="t132 @5 v3 l4 o2 c g f g | f c g g | a e f d | g g c2",noise="t132 l8 "..table.concat(p("road",4)," | ")}
b[a.GOAL]={pulse1="t180 @1 v13 y1 l16 o5 c e g >c <g >c e g >c4",pulse2="t180 @2 v8 y1 l16 o4 e g >c e c e g >c e4"}
b[a.LOST]={pulse1="t110 @2 v11 y2 l8 o4 e d c <b4 a4",pulse2="t110 @2 v6 y2 l8 o3 g f e d4 c4"}
b[a.RECORD]={pulse1="t170 @1 v13 y1 l16 o5 g >c e g e c <g >c4 e4",pulse2="t170 @2 v8 y1 l16 o5 e g >c e c <g e g4 >c4"}

b[a.TICK]={pulse2="t240 @2 v8 y1 l32 o6 c"}
b[a.CONFIRM]={pulse2="t240 @1 v10 y1 l32 o5 g >c e"}
b[a.BACK]={pulse2="t240 @1 v9 y1 l32 o5 e c <g"}
b[a.LIGHT]={pulse1="t120 @2 v12 y2 l4 o4 a"}
b[a.GO]={pulse1="t120 @2 v13 y2 l2 o5 a"}
b[a.CRATE]={pulse2="t240 @1 v10 y1 l32 o5 c g >c"}
b[a.ROULETTE]={pulse2="t240 @3 v6 y1 l64 o6 c"}
b[a.THROW]={noise="t240 l16 v10 y1 n{32 48 64}"}
b[a.BOOST]={pulse1="t200 @3 v11 y2 s2,3 l8 o4 c"}
b[a.SPIN]={pulse1="t200 @2 v10 y1 l32 o5 c <g >c <g >c <g",noise="t200 l8 v6 y2 n40"}
b[a.BOOM]={noise="t160 l4 v15 y3 n{24 56 88 120}"}
b[a.SHOT]={noise="t240 l16 v13 y1 n{20 36}"}
b[a.CHOPPER]={noise="t240 l32 v9 y1 n100 r v9 n100 r v9 n100 r v9 n100 r"}
b[a.THUNDER]={noise="t100 l2 v15 y5 n{28 60 92 124}"}
b[a.MONEY]={pulse2="t240 @1 v9 y1 l32 o6 e a"}
b[a.BUMP]={noise="t240 l32 v8 y1 n96"}
b[a.SPLASH]={noise="t180 l8 v12 y3 n{44 28 12}"}
b[a.LAP]={pulse2="t200 @1 v10 y1 l16 o5 c e g e g >c4"}
b[a.HOP]={pulse1="t240 @2 v7 y1 l32 o4 g >d"}
b[a.RIOT]={pulse1="t220 @1 v11 y0 l16 o5 c d e f g a b >c4"}
b[a.CAN]={pulse2="t200 @2 v10 y2 l16 o4 e c <a4"}

local function z(text,amount)
local i={}
local f,r=1,string.len(text)
while f<=r do
local n=string.sub(text,f,f)
local A=f==1 or string.sub(text,f-1,f-1)==" "
if n=="t"and A then
local h=f+1
while h<=r and string.byte(text,h)>=48 and string.byte(text,h)<=57 do
h=h+1
end
if h>f+1 then
i[#i+1]="t"..(tonumber(string.sub(text,f+1,h-1))+amount)
f=h
else
i[#i+1]=n
f=f+1
end
else
i[#i+1]=n
f=f+1
end
end
return table.concat(i)
end

local function i(tune,amount)
local f={loop=tune.loop}
for n,h in pairs(tune)do
if type(h)=="string"then
f[n]=z(h,amount)
end
end
return f
end

for h,f in pairs(a.TRACKS)do
b[f..a.FAST]=i(b[f],18)
end

a.TUNES=b

SpiffBoy.Tunes.register(o.ID,b)
