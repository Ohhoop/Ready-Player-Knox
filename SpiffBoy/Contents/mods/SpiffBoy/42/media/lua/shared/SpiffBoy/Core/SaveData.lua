require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"

SpiffBoy.SaveData=SpiffBoy.SaveData or{}
local a=SpiffBoy.SaveData

a.MAX_DEPTH=6
a.MAX_ENTRIES=512
a.MAX_STRING=128
a.MAX_KEY=32

local function d(key)
if type(key)=="string"then
if string.len(key)>a.MAX_KEY then
return nil
end
return key
end
if SpiffBoy.isInteger(key)then
return key
end
return nil
end

local function e(value,depth,budget)
local b=type(value)
if b=="number"then
if not SpiffBoy.isFinite(value)then
return nil
end
return value
end
if b=="boolean"then
return value
end
if b=="string"then
if string.len(value)>a.MAX_STRING then
return string.sub(value,1,a.MAX_STRING)
end
return value
end
if b~="table"or depth>=a.MAX_DEPTH then
return nil
end
local c={}
for h,i in pairs(value)do
if budget.left<=0 then
break
end
local f=d(h)
if f~=nil then
budget.left=budget.left-1
local g=e(i,depth+1,budget)
if g~=nil then
c[f]=g
end
end
end
return c
end

function a.clean(value)
if type(value)~="table"then
return{}
end
return e(value,0,{left=a.MAX_ENTRIES})or{}
end

local function h(key,inner)
if inner==nil then
return tostring(key)
end
return tostring(key).."."..inner
end

local function f(value,depth,budget)
local b=type(value)
if b=="number"then
if not SpiffBoy.isFinite(value)then
return"holds a number that is not finite"
end
return nil
end
if b=="boolean"then
return nil
end
if b=="string"then
if string.len(value)>a.MAX_STRING then
return"holds a string of "..string.len(value).." characters, at most "..a.MAX_STRING.." are kept"
end
return nil
end
if b~="table"then
return"holds a "..b..", only numbers, strings, booleans and tables are kept"
end
if depth>=a.MAX_DEPTH then
return"holds a table nested deeper than "..a.MAX_DEPTH.." levels"
end
for c,i in pairs(value)do
if d(c)==nil then
return"holds the key "..tostring(c)..", keys are whole numbers or strings of at most "..a.MAX_KEY.." characters"
end
budget.left=budget.left-1
if budget.left<0 then
return"holds more than "..a.MAX_ENTRIES.." entries"
end
local g,j=f(i,depth+1,budget)
if g then
return g,h(c,j)
end
end
return nil
end

function a.check(save)
if type(save)~="table"then
return"the save is a "..type(save)..", not a table"
end
local b,c=f(save,0,{left=a.MAX_ENTRIES})
if b==nil then
return nil
end
if c==nil then
return"the save "..b
end
return"the save at "..c.." "..b
end

local function c(value,depth)
local b=0
for i,g in pairs(value)do
b=b+1
if type(g)=="table"and depth+1<a.MAX_DEPTH then
b=b+c(g,depth+1)
end
end
return b
end

function a.measure(save)
if type(save)~="table"then
error("SpiffBoy: a save is measured as a table, not a "..type(save))
end
return c(save,0)
end

function a.fromStore(store)
if type(store)~="table"then
return{}
end
return a.clean(store.save)
end

function a.toStore(store,save)
store.save=a.clean(save)
end
