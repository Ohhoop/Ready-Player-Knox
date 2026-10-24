require"SpiffBoy/Core/Core"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local a={}
SpiffBoy.BrickBash.Records=a

a.INITIALS_LENGTH=3
a.SIZE=10
a.MODES={"c","e"}

local f="^([A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]):(%d+)$"
local g=9

local function h(saved)
local b={}
if type(saved)~="table"then
return b
end
for i=1,a.SIZE do
local c=saved[i]
if type(c)=="string"then
local d,e=string.match(c,f)
if d and string.len(e)<=g then
b[#b+1]={initials=d,score=tonumber(e)}
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
local b={}
local d=save.records
for i,c in ipairs(a.MODES)do
if type(d)=="table"then
b[c]=h(d[c])
else
b[c]={}
end
end
return b
end

function a.write(records)
local b={}
for d,c in ipairs(a.MODES)do
b[c]=e(records[c])
end
return b
end

function a.rankOf(list,score)
if score<=0 then
return nil
end
for b=1,#list do
if score>list[b].score then
return b
end
end
if#list<a.SIZE then
return#list+1
end
return nil
end

function a.insert(list,initials,score)
local b=a.rankOf(list,score)
if not b then
return nil
end
table.insert(list,b,{initials=initials,score=score})
while#list>a.SIZE do
table.remove(list)
end
return b
end
