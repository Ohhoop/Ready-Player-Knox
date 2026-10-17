require"SpiffBoy/Core/Core"

SpiffBoy.Textures=SpiffBoy.Textures or{}
local a=SpiffBoy.Textures

a.generation=0

local h=3

local d={}
local e={}
local f={}

local function i(b)
local c=f[b]
if not c then
local g=getModInfoByID(b)
if not g then
error("SpiffBoy: the mod "..tostring(b).." is not in the mod list of the game")
end
c=g:getVersionDir()
f[b]=c
end
return c
end

local function g(b,c)
return i(b).."/"..c
end

local function j(c)
local k,b=pcall(Texture.new,c)
if k and b and b:getWidth()>0 then
return b
end
return nil
end

local function k(c)
local b=Texture.getSharedTexture(c,h)
if b and SpiffBoy.isDevBuild()then
b:reloadFromFile(c)
end
return b
end

local function l(b)
if SpiffBoy.isDevBuild()then
return j(b)
end
return getTexture(b)
end

function a.get(m,n,o)
local b=g(m,n)
local c=d[b]
if c then
return c
end
if e[b]then
return nil
end
if o then
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

function a.folder(b,c,m)
return function(n)
return a.get(b,c..n..".png",m)
end
end
