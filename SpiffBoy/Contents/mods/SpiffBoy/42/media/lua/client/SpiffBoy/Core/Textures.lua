require"SpiffBoy/Core/Core"

SpiffBoy.Textures=SpiffBoy.Textures or{}
local a=SpiffBoy.Textures

a.generation=0

local h=3

local d={}
local e={}
local f=nil

local function i()
if not f then
local b=getModInfoByID(SpiffBoy.MOD_ID)
if not b then
error("SpiffBoy: the mod "..SpiffBoy.MOD_ID.." is not in the mod list of the game")
end
f=b:getVersionDir()
end
return f
end

local function j(b)
return i().."/"..b
end

local function k(c)
local g,b=pcall(Texture.new,c)
if g and b and b:getWidth()>0 then
return b
end
return nil
end

local function l(c)
local b=Texture.getSharedTexture(c,h)
if b and SpiffBoy.isDevBuild()then
b:reloadFromFile(c)
end
return b
end

local function m(b)
if SpiffBoy.isDevBuild()then
return k(b)
end
return getTexture(b)
end

function a.get(c,n)
local b=d[c]
if b then
return b
end
if e[c]then
return nil
end
local g=j(c)
if n then
b=l(g)
else
b=m(g)
end
if b then
d[c]=b
else
e[c]=true
SpiffBoy.log("missing texture "..c)
end
return b
end

function a.refresh()
if not SpiffBoy.isDevBuild()then
return
end
d={}
e={}
a.generation=a.generation+1
end

function a.folder(b,c)
return function(g)
return a.get(b..g..".png",c)
end
end
