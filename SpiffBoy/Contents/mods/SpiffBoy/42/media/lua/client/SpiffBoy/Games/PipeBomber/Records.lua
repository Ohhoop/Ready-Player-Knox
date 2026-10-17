require"SpiffBoy/Core/Core"

SpiffBoy.PipeBomber=SpiffBoy.PipeBomber or{}

local a={}
SpiffBoy.PipeBomber.Records=a

a.INITIALS_LENGTH=3
a.SIZE=10
a.MODES={"e","n","h"}

local g="^([A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]):(%d+)$"
local h=9

local function i(c)
local b={}
if type(c)~="table"then
return b
end
for j=1,a.SIZE do
local d=c[j]
if type(d)=="string"then
local e,f=string.match(d,g)
if e and string.len(f)<=h then
b[#b+1]={initials=e,score=tonumber(f)}
end
end
end
return b
end

local function e(b)
local d={}
for c=1,#b do
d[c]=b[c].initials..":"..tostring(b[c].score)
end
return d
end

function a.read(f)
local b={}
local d=f.records
for j,c in ipairs(a.MODES)do
if type(d)=="table"then
b[c]=i(d[c])
else
b[c]={}
end
end
return b
end

function a.write(d)
local b={}
for f,c in ipairs(a.MODES)do
b[c]=e(d[c])
end
return b
end

function a.rankOf(b,c)
if c<=0 then
return nil
end
for d=1,#b do
if c>b[d].score then
return d
end
end
if#b<a.SIZE then
return#b+1
end
return nil
end

function a.insert(b,f,d)
local c=a.rankOf(b,d)
if not c then
return nil
end
table.insert(b,c,{initials=f,score=d})
while#b>a.SIZE do
table.remove(b)
end
return c
end
