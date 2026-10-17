require"SpiffBoy/Core/Core"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local a={}
SpiffBoy.BrickDrop.Records=a

a.INITIALS_LENGTH=3
a.TABLE_SIZES={a=10,b=3,c=10}

local i="^([A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]):(%d+)$"
local j=9
local k={}

function a.lineKey(b,c)
return"L"..tostring(b).."H"..tostring(c)
end

local function d(c,h)
local b={}
if type(c)~="table"then
return b
end
for l=1,h do
local e=c[l]
if type(e)=="string"then
local f,g=string.match(e,i)
if f and string.len(g)<=j then
b[#b+1]={initials=f,score=tonumber(g)}
end
end
end
return b
end

local function e(b)
local f={}
for c=1,#b do
f[c]=b[c].initials..":"..tostring(b[c].score)
end
return f
end

function a.read(g)
local b={a={},c={},b={}}
local c=g.records
if type(c)~="table"then
return b
end
b.a=d(c.a,a.TABLE_SIZES.a)
b.c=d(c.c,a.TABLE_SIZES.c)
if type(c.b)=="table"then
for f,h in pairs(c.b)do
if type(f)=="string"and string.match(f,"^L%dH%d$")then
b.b[f]=d(h,a.TABLE_SIZES.b)
end
end
end
return b
end

function a.write(b)
local c={a=e(b.a),c=e(b.c),b={}}
for g,f in pairs(b.b)do
if#f>0 then
c.b[g]=e(f)
end
end
return c
end

local function f(b,c,g,h)
if c~="b"then
return b[c]
end
return b.b[a.lineKey(g,h)]
end

function a.list(b,c,g,h)
return f(b,c,g,h)or k
end

function a.ensureList(c,l,g,h)
local b=f(c,l,g,h)
if b then
return b
end
b={}
c.b[a.lineKey(g,h)]=b
return b
end

function a.rankOf(b,h,c)
if c<=0 then
return nil
end
for g=1,#b do
if c>b[g].score then
return g
end
end
if#b<h then
return#b+1
end
return nil
end

function a.insert(b,g,l,h)
local c=a.rankOf(b,g,h)
if not c then
return nil
end
table.insert(b,c,{initials=l,score=h})
while#b>g do
table.remove(b)
end
return c
end
