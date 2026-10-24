require"SpiffBoy/Core/Core"

SpiffBoy.Textures=SpiffBoy.Textures or{}
local a=SpiffBoy.Textures

a.generation=0

local g=3

local d={}
local e={}
local f={}

local function h(modId)
local b=f[modId]
if not b then
local c=getModInfoByID(modId)
if not c then
error("SpiffBoy: the mod "..tostring(modId).." is not in the mod list of the game")
end
b=c:getVersionDir()
f[modId]=b
end
return b
end

local function i(modId,path)
return h(modId).."/"..path
end

local function j(path)
local c,b=pcall(Texture.new,path)
if c and b and b:getWidth()>0 then
return b
end
return nil
end

local function k(path)
local b=Texture.getSharedTexture(path,g)
if b and SpiffBoy.isDevBuild()then
b:reloadFromFile(path)
end
return b
end

local function l(path)
if SpiffBoy.isDevBuild()then
return j(path)
end
return getTexture(path)
end

function a.get(modId,path,nearest)
local b=i(modId,path)
local c=d[b]
if c then
return c
end
if e[b]then
return nil
end
if nearest then
c=k(b)
else
c=l(b)
end
if c then
d[b]=c
else
e[b]=true
SpiffBoy.log("missing texture "..b)
end
return c
end

function a.refresh()
if not SpiffBoy.isDevBuild()then
return
end
d={}
e={}
a.generation=a.generation+1
end

function a.folder(modId,base,nearest)
return function(name)
return a.get(modId,base..name..".png",nearest)
end
end
