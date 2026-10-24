require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Textures"
require"SpiffBoy/Core/FontData"

SpiffBoy.PixelFont=SpiffBoy.PixelFont or{}
local d=SpiffBoy.PixelFont
local b=SpiffBoy.FontData
local m=SpiffBoy.Textures
local a=b.thai

local t="media/ui/SpiffBoy/font/"
local u=256
local v="0123456789abcdef"
local k=32
local w=0xD800
local M=0xDBFF
local z=0xDC00
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
local A={[0x0E0D]="low",[0x0E10]="low",[0x0E0E]="short",[0x0E0F]="short"}
local ad="latin"
local ae={0x2E80,0x303F,0x3040,0x30FF,0x3200,0x9FFF,0xF900,0xFAFF,0xFE30,0xFE4F,0xFF00,0xFF60,0xFFE0,0xFFE6}

local l=b.runs
local af=#l/3
local B={}
local n={}
local h={}
local C=nil
local D=nil
local E=nil

local F=Translator.getLanguage():name()
local ag=aa[F]or ac
local ah=ab[F]or ad
local G=math.max(b.ascents.latin,b.ascents[ah])

d.LINE_HEIGHT=G+b.descent
d.CELL_WIDTH=b.cellWidth
d.CELL_HEIGHT=b.cellHeight

local function H(code)
local c,e=1,af
while c<=e do
local f=math.floor((c+e)/2)
local g=(f-1)*3
if code<l[g+1]then
e=f-1
elseif code>l[g+2]then
c=f+1
else
return l[g+3]
end
end
return nil
end

local function I(code,ranges)
for c=1,#ranges,2 do
if code>=ranges[c]and code<=ranges[c+1]then
return true
end
end
return false
end

local function J(code)
return I(code,b.ignorable)
end

local function K(code)
return I(code,ae)
end

local function o(code)
return(code>=R and code<=S)or(code>=T and code<=U)
end

local function ai(code)
local c=math.floor(code/u)
local e=math.floor(c/16)+1
local f=c%16+1
local g=string.sub(v,e,e)..string.sub(v,f,f)..".png"
if b.formPages[c]then
return t..ag.."/"..g
end
return t..g
end

local function aj(code)
if B[code]then
return
end
B[code]=true
SpiffBoy.log("pixel font has no glyph for code point "..code)
end

function d.decode(str)
local f,g={},{}
local j=string.len(str)
local c=1
while c<=j do
local e=string.byte(str,c)
local p=c
if e>=w and e<=M and c<j then
local i=string.byte(str,c+1)
if i>=z and i<=N then
e=O+(e-w)*P+(i-z)
c=c+1
end
end
f[#f+1]=e
g[#g+1]=p
c=c+1
end
return f,g
end

function d.advance(code)
if b.marks[code]or J(code)then
return 0
end
local c=H(code)
if not c then
aj(code)
return 0
end
return c
end

local function ak(codes)
local c={}
local i=1
while i<=#codes do
local e=codes[i]
local f=codes[i+1]
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
local p=c[f-2]
local j=c[f+1]
if j and a.belowMarks[j]and A[e]then
c[f]=a[A[e]][e]
elseif j and a.shortBases[e]and(a.aboveVowels[j]or a.tones[j])then
c[f]=a.short[e]
elseif g and a.belowMarks[e]and(g==a.short[0x0E0E]or g==a.short[0x0E0F])then
c[f]=a.small[e]
elseif g and a.tallBases[g]and a.aboveVowels[e]then
c[f]=a.narrow[e]
elseif g and a.tallBases[g]and a.tones[e]then
c[f]=a.narrow[e]
elseif p and a.tallBases[p]and a.belowMarks[g]and a.tones[e]then
c[f]=a.narrow[e]
elseif g and(a.aboveVowels[g]or a.aboveVowelsNarrow[g])and a.tones[e]then
c[f]=a.small[e]
end
end
return c
end

local function L(class,code)
local c=a.markClasses[class]
return c and c[code]
end

local function al(code,base,previousMark)
for q,g in ipairs(Z)do
local i,j=g[1],g[2]
local c=L(i,code)
if c and previousMark then
local f=a.markAnchors[previousMark.code]
local e=f and f[i]
if e then
return previousMark.x+e[1]-c[1],previousMark.y+e[2]-c[2]
end
end
local e=L(j,code)
if e and base then
local p=a.baseAnchors[base.code]
local f=p and p[j]
if f then
return base.x+f[1]-e[1],base.y+f[2]-e[2]
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

function d.shape(str)
local i=n[str]
if i then
return i.glyphs,i.width
end
local p=ak(d.decode(str))
local g={}
local f=0
local q,j=nil,nil
for x=1,#p do
local c=p[x]
if not J(c)then
local e={code=c,x=f,y=0,page=nil,cellX=0,cellY=0}
if c~=k and H(c)then
local r=c%u
e.page=ai(c)
e.cellX=(r%b.columns)*b.cellWidth
e.cellY=math.floor(r/b.columns)*b.cellHeight
end
if b.marks[c]then
local r,s=nil,nil
if o(c)then
r,s=al(c,q,j)
end
e.x=r or f
e.y=s or 0
j=e
else
q,j=e,nil
f=f+d.advance(c)
end
g[#g+1]=e
end
end
if#h>=_ then
am()
end
n[str]={glyphs=g,width=f}
h[#h+1]=str
return g,f
end

function d.measure(str)
local e,c=d.shape(str)
return c
end

local function an(previous,code)
if previous==k then
return true
end
if b.marks[code]then
return false
end
if K(previous)or K(code)then
return true
end
return o(previous)and o(code)
end

function d.wrap(str,maxWidth)
local i,p=d.decode(str)
local f={}
local g,j=1,0
local q=nil
local r=#i
local e=1
while e<=r do
local s=i[e]
local x=d.advance(s)
if e>g and an(i[e-1],s)then
q=e
end
if j+x>maxWidth and e>g and s~=k then
local c=q
if not c or c<=g then
c=e
while c>g+1 and b.marks[i[c]]do
c=c-1
end
end
f[#f+1]=string.sub(str,p[g],p[c]-1)
while c<=r and i[c]==k do
c=c+1
end
g,j,q=c,0,nil
e=c
else
j=j+x
e=e+1
end
end
if g<=r then
f[#f+1]=string.sub(str,p[g])
end
for c=1,#f do
f[c]=string.gsub(f[c]," +$","")
end
return f
end

function d.origin(x,y)
return x-b.cellLeft,y+G-b.cellBaseline
end

function d.pageTexture(page)
if page~=C or m.generation~=E then
C=page
E=m.generation
D=m.get(SpiffBoy.MOD_ID,page,true)
end
return D
end
