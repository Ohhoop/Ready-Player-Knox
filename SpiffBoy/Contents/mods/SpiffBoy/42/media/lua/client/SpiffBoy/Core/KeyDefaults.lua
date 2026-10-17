require"OptionScreens/MainOptions"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/KeyBinds"

local d=SpiffBoy.KeyBinds

local g="keysB42.ini"
local b=false

local function h()
local a={}
local c=getFileReader(g,false)
if not c then
return a
end
while true do
local e=c:readLine()
if e==nil then
break
end
local f=string.match(e,"^([^=%[]+)=")
if f then
a[f]=true
end
end
c:close()
return a
end

local function i(c,e,f)
if not MainOptions.keys then
return
end
for j,a in ipairs(MainOptions.keys)do
if a.value==c then
a.key=e
a.altCode=f
end
end
end

local function e()
local j=h()
local f=getCore()
for l,k in ipairs(d.ORDER)do
local a=d.BINDS[k]
if a.movement and not j[a.id]then
local c=f:getKey(a.movement)
f:addKeyBinding(a.id,c,Keyboard.KEY_NONE,b,b,b)
i(a.id,c,Keyboard.KEY_NONE)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("key "..a.id.." seeded from "..a.movement..": "..tostring(c))
end
end
end
end

local a=MainOptions.loadKeys

MainOptions.loadKeys=function(...)
local c=a(...)
e()
return c
end

Events.OnGameStart.Add(e)
