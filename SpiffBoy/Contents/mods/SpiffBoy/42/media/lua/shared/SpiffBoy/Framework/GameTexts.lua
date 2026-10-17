require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.GameTexts=SpiffBoy.GameTexts or{}
local b=SpiffBoy.GameTexts
local p=SpiffBoy.Cartridges

b.REFERENCE_LANGUAGE="EN"
b.SECTION="UI"

local q={['"']='"',["\\"]="\\",["/"]="/",b="\b",f="\f",n="\n",r="\r",t="\t"}
local j={["true"]=true,["false"]=false}
local r="null"

local k={}
local l={}

local g

local function e(a,c)
error("SpiffBoy: invalid JSON, "..a.." at character "..tostring(c))
end

local function d(a,c)
local h,f=string.find(a,"^[ \t\r\n]*",c)
return f+1
end

local function m(f,i)
local c={}
local h=i+1
while true do
local a=string.find(f,'["\\]',h)
if not a then
e("unfinished string",i)
end
c[#c+1]=string.sub(f,h,a-1)
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
h=a+6
else
local o=q[n]
if not o then
e("bad escape",a)
end
c[#c+1]=o
h=a+2
end
end
end

local function s(c,n)
local f={}
local a=d(c,n+1)
if string.sub(c,a,a)=="}"then
return f,a+1
end
while true do
if string.sub(c,a,a)~='"'then
e("expected a key",a)
end
local h
h,a=m(c,a)
a=d(c,a)
if string.sub(c,a,a)~=":"then
e("expected a colon",a)
end
f[h],a=g(c,d(c,a+1))
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

local function t(c,i)
local f={}
local a=d(c,i+1)
if string.sub(c,a,a)=="]"then
return f,a+1
end
while true do
f[#f+1],a=g(c,a)
a=d(c,a)
local h=string.sub(c,a,a)
if h=="]"then
return f,a+1
end
if h~=","then
e("expected a comma",a)
end
a=d(c,a+1)
end
end

g=function(c,a)
local i=string.sub(c,a,a)
if i=="{"then
return s(c,a)
elseif i=="["then
return t(c,a)
elseif i=='"'then
return m(c,a)
end
local f=string.match(c,"^%a+",a)
if f and j[f]~=nil then
return j[f],a+string.len(f)
elseif f==r then
return nil,a+string.len(f)
end
local h=string.match(c,"^-?%d+%.?%d*[eE]?[-+]?%d*",a)
if h and tonumber(h)then
return tonumber(h),a+string.len(h)
end
e("unexpected character",a)
end

function b.decode(a)
local f,c=g(a,d(a,1))
if d(a,c)<=string.len(a)then
e("unexpected text after the value",c)
end
return f
end

local function u(h,i)
local a=getModFileReader(h,i,false)
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

local function i(c,h)
local f=k[c.id]
if not f then
f={}
k[c.id]=f
end
local a=f[h]
if a then
return a
end
local n=u(c.mod,c.texts..h..".json")
a={}
if n then
local o=b.decode(n)[b.SECTION]
if type(o)~="table"then
error("SpiffBoy: the texts of "..c.id.." in "..h.." have no "..b.SECTION.." section")
end
a=o
end
f[h]=a
return a
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

local function v(c,...)
local f={...}
return(string.gsub(c,"%%([%%1-9])",function(a)
if a=="%"then
return"%"
end
return o(f[tonumber(a)])
end))
end

function b.text(c,a,...)
local h=Translator.getLanguage():name()
local f=i(c,h)[a]
if f==nil and h~=b.REFERENCE_LANGUAGE then
f=i(c,b.REFERENCE_LANGUAGE)[a]
end
if f==nil then
local n=c.id.."."..a
if not l[n]then
l[n]=true
SpiffBoy.log("the game "..c.id.." has no text "..a)
end
return a
end
return v(f,...)
end

function b.of(c)
local a=nil
return function(f,...)
if not a then
a=p.byId(c)
if not a then
error("SpiffBoy: no cartridge registered with the id "..tostring(c))
end
end
return b.text(a,f,...)
end
end
