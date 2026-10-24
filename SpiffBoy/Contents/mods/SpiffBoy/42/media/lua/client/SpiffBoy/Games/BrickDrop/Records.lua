require"SpiffBoy/Core/Core"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local a={}
SpiffBoy.BrickDrop.Records=a

a.INITIALS_LENGTH=3
a.TABLE_SIZES={a=10,b=3,c=10}

local g="^([A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]):(%d+)$"
local h=9
local i={}

function a.lineKey(level,height)
return"L"..tostring(level).."H"..tostring(height)
end

local function d(saved,size)
local b={}
if type(saved)~="table"then
return b
end
for j=1,size do
local c=saved[j]
if type(c)=="string"then
local e,f=string.match(c,g)
if e and string.len(f)<=h then
b[#b+1]={initials=e,score=tonumber(f)}
end
end
end
return b
end

local function e(list)
local c={}
for b=1,#list do
c[b]=list[b].initials..":"..tostring(list[b].score)
end
return c
end

function a.read(save)
local b={a={},c={},b={}}
local c=save.records
if type(c)~="table"then
return b
end
b.a=d(c.a,a.TABLE_SIZES.a)
b.c=d(c.c,a.TABLE_SIZES.c)
if type(c.b)=="table"then
for f,j in pairs(c.b)do
if type(f)=="string"and string.match(f,"^L%dH%d$")then
b.b[f]=d(j,a.TABLE_SIZES.b)
end
end
end
return b
end

function a.write(records)
local b={a=e(records.a),c=e(records.c),b={}}
for f,c in pairs(records.b)do
if#c>0 then
b.b[f]=e(c)
end
end
return b
end

local function c(records,mode,level,height)
if mode~="b"then
return records[mode]
end
return records.b[a.lineKey(level,height)]
end

function a.list(records,mode,level,height)
return c(records,mode,level,height)or i
end

function a.ensureList(records,mode,level,height)
local b=c(records,mode,level,height)
if b then
return b
end
b={}
records.b[a.lineKey(level,height)]=b
return b
end

function a.rankOf(list,size,score)
if score<=0 then
return nil
end
for b=1,#list do
if score>list[b].score then
return b
end
end
if#list<size then
return#list+1
end
return nil
end

function a.insert(list,size,initials,score)
local b=a.rankOf(list,size,score)
if not b then
return nil
end
table.insert(list,b,{initials=initials,score=score})
while#list>size do
table.remove(list)
end
return b
end
