require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"

SpiffBoy.SaveData=SpiffBoy.SaveData or{}
local a=SpiffBoy.SaveData

a.MAX_DEPTH=6
a.MAX_ENTRIES=512
a.MAX_STRING=128
a.MAX_KEY=32

local function f(b)
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

local function g(b,e,c)
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
if d~="table"or e>=a.MAX_DEPTH then
return nil
end
local h={}
for k,l in pairs(b)do
if c.left<=0 then
break
end
local i=f(k)
if i~=nil then
c.left=c.left-1
local j=g(l,e+1,c)
if j~=nil then
h[i]=j
end
end
end
return h
end

function a.clean(b)
if type(b)~="table"then
return{}
end
return g(b,0,{left=a.MAX_ENTRIES})or{}
end

local function k(b,c)
if c==nil then
return tostring(b)
end
return tostring(b).."."..c
end

local function h(b,i,d)
local c=type(b)
if c=="number"then
if not SpiffBoy.isFinite(b)then
return"holds a number that is not finite"
end
return nil
end
if c=="boolean"then
return nil
end
if c=="string"then
if string.len(b)>a.MAX_STRING then
return"holds a string of "..string.len(b).." characters, at most "..a.MAX_STRING.." are kept"
end
return nil
end
if c~="table"then
return"holds a "..c..", only numbers, strings, booleans and tables are kept"
end
if i>=a.MAX_DEPTH then
return"holds a table nested deeper than "..a.MAX_DEPTH.." levels"
end
for e,l in pairs(b)do
if f(e)==nil then
return"holds the key "..tostring(e)..", keys are whole numbers or strings of at most "..a.MAX_KEY.." characters"
end
d.left=d.left-1
if d.left<0 then
return"holds more than "..a.MAX_ENTRIES.." entries"
end
local j,m=h(l,i+1,d)
if j then
return j,k(e,m)
end
end
return nil
end

function a.check(b)
if type(b)~="table"then
return"the save is a "..type(b)..", not a table"
end
local c,d=h(b,0,{left=a.MAX_ENTRIES})
if c==nil then
return nil
end
if d==nil then
return"the save "..c
end
return"the save at "..d.." "..c
end

local function c(i,d)
local b=0
for j,e in pairs(i)do
b=b+1
if type(e)=="table"and d+1<a.MAX_DEPTH then
b=b+c(e,d+1)
end
end
return b
end

function a.measure(b)
if type(b)~="table"then
error("SpiffBoy: a save is measured as a table, not a "..type(b))
end
return c(b,0)
end

function a.fromStore(b)
if type(b)~="table"then
return{}
end
return a.clean(b.save)
end

function a.toStore(b,d)
b.save=a.clean(d)
end
