require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.GameTexts=SpiffBoy.GameTexts or{}
local b=SpiffBoy.GameTexts
local r=SpiffBoy.Cartridges

b.REFERENCE_LANGUAGE="EN"
b.SECTION="UI"

local s={['"']='"',["\\"]="\\",["/"]="/",b="\b",f="\f",n="\n",r="\r",t="\t"}
local j={["true"]=true,["false"]=false}
local t="null"

local k={}
local l={}

local h

local function e(a,c)
error("SpiffBoy: invalid JSON, "..a.." at character "..tostring(c))
end

local function d(a,c)
local g,f=string.find(a,"^[ \t\r\n]*",c)
return f+1
end

local function m(f,i)
local c={}
local g=i+1
while true do
local a=string.find(f,'["\\]',g)
if not a then
e("unfinished string",i)
end
c[#c+1]=string.sub(f,g,a-1)
if string.sub(f,a,a)=='"'then
return table.concat(c),a+1
end
local n=string.sub(f,a+1,a+1)
if n=="u"then
local o=string.sub(f,a+2,a+5)
if not string.find(o,"^%x%x%x%x$")then
e("bad unicode escape",a)
end
c[#c+1]=string.char(tonumber(o,16))
g=a+6
else
local o=s[n]
if not o then
e("bad escape",a)
end
c[#c+1]=o
g=a+2
end
end
end

local function u(c,n)
local f={}
local a=d(c,n+1)
if string.sub(c,a,a)=="}"then
return f,a+1
end
while true do
if string.sub(c,a,a)~='"'then
e("expected a key",a)
end
local g
g,a=m(c,a)
a=d(c,a)
if string.sub(c,a,a)~=":"then
e("expected a colon",a)
end
f[g],a=h(c,d(c,a+1))
a=d(c,a)
local i=string.sub(c,a,a)
if i=="}"then
return f,a+1
end
if i~=","then
e("expected a comma",a)
end
a=d(c,a+1)
end
end

local function v(c,i)
local f={}
local a=d(c,i+1)
if string.sub(c,a,a)=="]"then
return f,a+1
end
while true do
f[#f+1],a=h(c,a)
a=d(c,a)
local g=string.sub(c,a,a)
if g=="]"then
return f,a+1
end
if g~=","then
e("expected a comma",a)
end
a=d(c,a+1)
end
end

h=function(c,a)
local i=string.sub(c,a,a)
if i=="{"then
return u(c,a)
elseif i=="["then
return v(c,a)
elseif i=='"'then
return m(c,a)
end
local f=string.match(c,"^%a+",a)
if f and j[f]~=nil then
return j[f],a+string.len(f)
elseif f==t then
return nil,a+string.len(f)
end
local g=string.match(c,"^-?%d+%.?%d*[eE]?[-+]?%d*",a)
if g and tonumber(g)then
return tonumber(g),a+string.len(g)
end
e("unexpected character",a)
end

function b.decode(a)
local f,c=h(a,d(a,1))
if d(a,c)<=string.len(a)then
e("unexpected text after the value",c)
end
return f
end

local function w(g,i)
local a=getModFileReader(g,i,false)
if not a then
return nil
end
local c={}
local f=a:readLine()
while f do
c[#c+1]=f
f=a:readLine()
end
a:close()
return table.concat(c,"\n")
end

local function x(a,f,g,i)
local n,c=pcall(b.decode,i)
if not n then
error("SpiffBoy: the texts of "..a.id.." in "..f..", file "..g.." of the mod "..a.mod..", cannot be read: "..tostring(c))
end
return c
end

local function n(a,c)
local g=k[a.id]
if not g then
g={}
k[a.id]=g
end
local f=g[c]
if f then
return f
end
local i=a.texts..c..".json"
local o=w(a.mod,i)
f={}
if o then
local p=x(a,c,i,o)
if type(p)~="table"then
error("SpiffBoy: the texts of "..a.id.." in "..c..", file "..i.." of the mod "..a.mod..", hold no JSON object")
end
local q=p[b.SECTION]
if type(q)~="table"then
error("SpiffBoy: the texts of "..a.id.." in "..c.." have no "..b.SECTION.." section")
end
f=q
end
g[c]=f
return f
end

local function o(a)
if a==nil then
return""
end
if type(a)=="number"and a==math.floor(a)then
return string.format("%d",a)
end
return tostring(a)
end

local function p(c,...)
local f={...}
return(string.gsub(c,"%%([%%1-9])",function(a)
if a=="%"then
return"%"
end
return o(f[tonumber(a)])
end))
end

function b.text(c,a,...)
local g=Translator.getLanguage():name()
local f=n(c,g)[a]
if f==nil and g~=b.REFERENCE_LANGUAGE then
f=n(c,b.REFERENCE_LANGUAGE)[a]
end
if f==nil then
local i=c.id.."."..a
if not l[i]then
l[i]=true
SpiffBoy.log("the game "..c.id.." has no text "..a)
end
return a
end
return p(f,...)
end

function b.of(c)
local a=nil
return function(f,...)
if not a then
a=r.byId(c)
if not a then
error("SpiffBoy: no cartridge registered with the id "..tostring(c))
end
end
return b.text(a,f,...)
end
end
