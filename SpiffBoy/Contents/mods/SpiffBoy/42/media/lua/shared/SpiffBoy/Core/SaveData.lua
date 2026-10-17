require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"

SpiffBoy.SaveData=SpiffBoy.SaveData or{}
local a=SpiffBoy.SaveData

a.MAX_DEPTH=6
a.MAX_ENTRIES=512
a.MAX_STRING=128
a.MAX_KEY=32

local function j(b)
if type(b)=="string"then
if string.len(b)>a.MAX_KEY then
return nil
end
return b
end
if SpiffBoy.isInteger(b)then
return b
end
return nil
end

local function e(b,f,c)
local d=type(b)
if d=="number"then
if not SpiffBoy.isFinite(b)then
return nil
end
return b
end
if d=="boolean"then
return b
end
if d=="string"then
if string.len(b)>a.MAX_STRING then
return string.sub(b,1,a.MAX_STRING)
end
return b
end
if d~="table"or f>=a.MAX_DEPTH then
return nil
end
local g={}
for k,l in pairs(b)do
if c.left<=0 then
break
end
local h=j(k)
if h~=nil then
c.left=c.left-1
local i=e(l,f+1,c)
if i~=nil then
g[h]=i
end
end
end
return g
end

function a.clean(b)
if type(b)~="table"then
return{}
end
return e(b,0,{left=a.MAX_ENTRIES})or{}
end

function a.fromStore(b)
if type(b)~="table"then
return{}
end
return a.clean(b.save)
end

function a.toStore(b,c)
b.save=a.clean(c)
end
