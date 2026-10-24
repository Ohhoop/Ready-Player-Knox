require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.GameTexts=SpiffBoy.GameTexts or{}
local b=SpiffBoy.GameTexts
local p=SpiffBoy.Cartridges

b.REFERENCE_LANGUAGE="EN"
b.SECTION="UI"

local q={['"']='"',["\\"]="\\",["/"]="/",b="\b",f="\f",n="\n",r="\r",t="\t"}
local h={["true"]=true,["false"]=false}
local r="null"

local i={}
local j={}

local f

local function d(message,pos)
error("SpiffBoy: invalid JSON, "..message.." at character "..tostring(pos))
end

local function c(text,pos)
local e,a=string.find(text,"^[ \t\r\n]*",pos)
return a+1
end

local function k(text,pos)
local e={}
local g=pos+1
while true do
local a=string.find(text,'["\\]',g)
if not a then
d("unfinished string",pos)
end
e[#e+1]=string.sub(text,g,a-1)
if string.sub(text,a,a)=='"'then
return table.concat(e),a+1
end
local l=string.sub(text,a+1,a+1)
if l=="u"then
local m=string.sub(text,a+2,a+5)
if not string.find(m,"^%x%x%x%x$")then
d("bad unicode escape",a)
end
e[#e+1]=string.char(tonumber(m,16))
g=a+6
else
local m=q[l]
if not m then
d("bad escape",a)
end
e[#e+1]=m
g=a+2
end
end
end

local function s(text,pos)
local e={}
local a=c(text,pos+1)
if string.sub(text,a,a)=="}"then
return e,a+1
end
while true do
if string.sub(text,a,a)~='"'then
d("expected a key",a)
end
local g
g,a=k(text,a)
a=c(text,a)
if string.sub(text,a,a)~=":"then
d("expected a colon",a)
end
e[g],a=f(text,c(text,a+1))
a=c(text,a)
local l=string.sub(text,a,a)
if l=="}"then
return e,a+1
end
if l~=","then
d("expected a comma",a)
end
a=c(text,a+1)
end
end

local function t(text,pos)
local e={}
local a=c(text,pos+1)
if string.sub(text,a,a)=="]"then
return e,a+1
end
while true do
e[#e+1],a=f(text,a)
a=c(text,a)
local g=string.sub(text,a,a)
if g=="]"then
return e,a+1
end
if g~=","then
d("expected a comma",a)
end
a=c(text,a+1)
end
end

f=function(text,pos)
local g=string.sub(text,pos,pos)
if g=="{"then
return s(text,pos)
elseif g=="["then
return t(text,pos)
elseif g=='"'then
return k(text,pos)
end
local a=string.match(text,"^%a+",pos)
if a and h[a]~=nil then
return h[a],pos+string.len(a)
elseif a==r then
return nil,pos+string.len(a)
end
local e=string.match(text,"^-?%d+%.?%d*[eE]?[-+]?%d*",pos)
if e and tonumber(e)then
return tonumber(e),pos+string.len(e)
end
d("unexpected character",pos)
end

function b.decode(text)
local e,a=f(text,c(text,1))
if c(text,a)<=string.len(text)then
d("unexpected text after the value",a)
end
return e
end

local function u(modId,path)
local a=getModFileReader(modId,path,false)
if not a then
return nil
end
local e={}
local g=a:readLine()
while g do
e[#e+1]=g
g=a:readLine()
end
a:close()
return table.concat(e,"\n")
end

local function v(definition,language,path,content)
local e,a=pcall(b.decode,content)
if not e then
error("SpiffBoy: the texts of "..definition.id.." in "..language..", file "..path.." of the mod "..definition.mod..", cannot be read: "..tostring(a))
end
return a
end

local function l(definition,language)
local e=i[definition.id]
if not e then
e={}
i[definition.id]=e
end
local a=e[language]
if a then
return a
end
local g=definition.texts..language..".json"
local m=u(definition.mod,g)
a={}
if m then
local n=v(definition,language,g,m)
if type(n)~="table"then
error("SpiffBoy: the texts of "..definition.id.." in "..language..", file "..g.." of the mod "..definition.mod..", hold no JSON object")
end
local o=n[b.SECTION]
if type(o)~="table"then
error("SpiffBoy: the texts of "..definition.id.." in "..language.." have no "..b.SECTION.." section")
end
a=o
end
e[language]=a
return a
end

local function m(value)
if value==nil then
return""
end
if type(value)=="number"and value==math.floor(value)then
return string.format("%d",value)
end
return tostring(value)
end

local function n(text,...)
local a={...}
return(string.gsub(text,"%%([%%1-9])",function(token)
if token=="%"then
return"%"
end
return m(a[tonumber(token)])
end))
end

function b.text(definition,key,...)
local e=Translator.getLanguage():name()
local a=l(definition,e)[key]
if a==nil and e~=b.REFERENCE_LANGUAGE then
a=l(definition,b.REFERENCE_LANGUAGE)[key]
end
if a==nil then
local g=definition.id.."."..key
if not j[g]then
j[g]=true
SpiffBoy.log("the game "..definition.id.." has no text "..key)
end
return key
end
return n(a,...)
end

function b.of(gameId)
local a=nil
return function(key,...)
if not a then
a=p.byId(gameId)
if not a then
error("SpiffBoy: no cartridge registered with the id "..tostring(gameId))
end
end
return b.text(a,key,...)
end
end
