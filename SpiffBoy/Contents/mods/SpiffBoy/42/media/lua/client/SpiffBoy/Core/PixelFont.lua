require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Textures"
require"SpiffBoy/Core/FontData"

SpiffBoy.PixelFont=SpiffBoy.PixelFont or{}
local d=SpiffBoy.PixelFont
local b=SpiffBoy.FontData
local m=SpiffBoy.Textures
local a=b.thai

local u="media/ui/SpiffBoy/font/"
local v=256
local w="0123456789abcdef"
local k=32
local x=0xD800
local M=0xDBFF
local y=0xDC00
local N=0xDFFF
local O=0x10000
local P=0x400
local Q=65536
local R=0x0E00
local S=0x0E7F
local T=0xE000
local U=0xE0FF
local V="Gpos0Sub0Mark0"
local W="Gpos0Sub0Mark1"
local X="Gpos7Sub0Mark0"
local Y="Gpos8Sub0Mark0"
local Z={{X,V},{Y,W}}
local _=256
local aa={CN="zh_hans",CH="zh_hant",JP="ja",KO="ko"}
local ab={CN="cjk",CH="cjk",JP="cjk",KO="hangul",TH="thai"}
local ac="zh_hans"
local z={[0x0E0D]="low",[0x0E10]="low",[0x0E0E]="short",[0x0E0F]="short"}
local ad="latin"
local ae={0x2E80,0x303F,0x3040,0x30FF,0x3200,0x9FFF,0xF900,0xFAFF,0xFE30,0xFE4F,0xFF00,0xFF60,0xFFE0,0xFFE6}

local l=b.runs
local af=#l/3
local A={}
local n={}
local h={}
local B=nil
local C=nil
local D=nil

local E=Translator.getLanguage():name()
local ag=aa[E]or ac
local ah=ab[E]or ad
local F=math.max(b.ascents.latin,b.ascents[ah])

d.LINE_HEIGHT=F+b.descent
d.CELL_WIDTH=b.cellWidth
d.CELL_HEIGHT=b.cellHeight

local function G(i)
local c,e=1,af
while c<=e do
local f=math.floor((c+e)/2)
local g=(f-1)*3
if i<l[g+1]then
e=f-1
elseif i>l[g+2]then
c=f+1
else
return l[g+3]
end
end
return nil
end

local function H(e,c)
for f=1,#c,2 do
if e>=c[f]and e<=c[f+1]then
return true
end
end
return false
end

local function I(c)
return H(c,b.ignorable)
end

local function J(c)
return H(c,ae)
end

local function o(c)
return(c>=R and c<=S)or(c>=T and c<=U)
end

local function ai(i)
local c=math.floor(i/v)
local e=math.floor(c/16)+1
local f=c%16+1
local g=string.sub(w,e,e)..string.sub(w,f,f)..".png"
if b.formPages[c]then
return u..ag.."/"..g
end
return u..g
end

local function aj(c)
if A[c]then
return
end
A[c]=true
SpiffBoy.log("pixel font has no glyph for code point "..c)
end

function d.decode(f)
local g,i={},{}
local p=string.len(f)
local c=1
while c<=p do
local e=string.byte(f,c)
local q=c
if e>=x and e<=M and c<p then
local j=string.byte(f,c+1)
if j>=y and j<=N then
e=O+(e-x)*P+(j-y)
c=c+1
end
end
g[#g+1]=e
i[#i+1]=q
c=c+1
end
return g,i
end

function d.advance(c)
if b.marks[c]or I(c)then
return 0
end
local e=G(c)
if not e then
aj(c)
return 0
end
return e
end

local function ak(p)
local c={}
local i=1
while i<=#p do
local e=p[i]
local f=p[i+1]
local g=f and a.ligatures[e*Q+f]
if g then
c[#c+1]=g
i=i+2
else
c[#c+1]=e
i=i+1
end
end
for f=1,#c do
local e=c[f]
local g=c[f-1]
local q=c[f-2]
local j=c[f+1]
if j and a.belowMarks[j]and z[e]then
c[f]=a[z[e]][e]
elseif j and a.shortBases[e]and(a.aboveVowels[j]or a.tones[j])then
c[f]=a.short[e]
elseif g and a.belowMarks[e]and(g==a.short[0x0E0E]or g==a.short[0x0E0F])then
c[f]=a.small[e]
elseif g and a.tallBases[g]and a.aboveVowels[e]then
c[f]=a.narrow[e]
elseif g and a.tallBases[g]and a.tones[e]then
c[f]=a.narrow[e]
elseif q and a.tallBases[q]and a.belowMarks[g]and a.tones[e]then
c[f]=a.narrow[e]
elseif g and(a.aboveVowels[g]or a.aboveVowelsNarrow[g])and a.tones[e]then
c[f]=a.small[e]
end
end
return c
end

local function K(e,f)
local c=a.markClasses[e]
return c and c[f]
end

local function al(j,c,e)
for t,p in ipairs(Z)do
local q,r=p[1],p[2]
local f=K(q,j)
if f and e then
local i=a.markAnchors[e.code]
local g=i and i[q]
if g then
return e.x+g[1]-f[1],e.y+g[2]-f[2]
end
end
local g=K(r,j)
if g and c then
local s=a.baseAnchors[c.code]
local i=s and s[r]
if i then
return c.x+i[1]-g[1],c.y+i[2]-g[2]
end
end
end
return nil
end

local function am()
local e=math.floor(#h/2)
for c=1,e do
n[h[c]]=nil
end
local c={}
for f=e+1,#h do
c[#c+1]=h[f]
end
h=c
end

function d.shape(g)
local j=n[g]
if j then
return j.glyphs,j.width
end
local q=ak(d.decode(g))
local i={}
local f=0
local r,p=nil,nil
for L=1,#q do
local c=q[L]
if not I(c)then
local e={code=c,x=f,y=0,page=nil,cellX=0,cellY=0}
if c~=k and G(c)then
local s=c%v
e.page=ai(c)
e.cellX=(s%b.columns)*b.cellWidth
e.cellY=math.floor(s/b.columns)*b.cellHeight
end
if b.marks[c]then
local s,t=nil,nil
if o(c)then
s,t=al(c,r,p)
end
e.x=s or f
e.y=t or 0
p=e
else
r,p=e,nil
f=f+d.advance(c)
end
i[#i+1]=e
end
end
if#h>=_ then
am()
end
n[g]={glyphs=i,width=f}
h[#h+1]=g
return i,f
end

function d.measure(c)
local f,e=d.shape(c)
return e
end

local function an(c,e)
if c==k then
return true
end
if b.marks[e]then
return false
end
if J(c)or J(e)then
return true
end
return o(c)and o(e)
end

function d.wrap(p,ao)
local i,q=d.decode(p)
local f={}
local g,j=1,0
local r=nil
local s=#i
local e=1
while e<=s do
local t=i[e]
local L=d.advance(t)
if e>g and an(i[e-1],t)then
r=e
end
if j+L>ao and e>g and t~=k then
local c=r
if not c or c<=g then
c=e
while c>g+1 and b.marks[i[c]]do
c=c-1
end
end
f[#f+1]=string.sub(p,q[g],q[c]-1)
while c<=s and i[c]==k do
c=c+1
end
g,j,r=c,0,nil
e=c
else
j=j+L
e=e+1
end
end
if g<=s then
f[#f+1]=string.sub(p,q[g])
end
for c=1,#f do
f[c]=string.gsub(f[c]," +$","")
end
return f
end

function d.origin(c,e)
return c-b.cellLeft,e+F-b.cellBaseline
end

function d.pageTexture(c)
if c~=B or m.generation~=D then
B=c
D=m.generation
C=m.get(c,true)
end
return C
end
