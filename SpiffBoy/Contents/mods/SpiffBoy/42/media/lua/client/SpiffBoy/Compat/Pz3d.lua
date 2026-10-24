require"SpiffBoy/UI/HandheldWindow"

local a=false

local function c()
local b=MainScreen and MainScreen.instance
return b~=nil and b.inGame==true and b:isVisible()
end

local function b()
if SpiffBoyHandheldWindow.anyShown()~=nil then
if not PZ3D.menuUi()then
PZ3D.menuUi(true)
end
a=true
elseif a then
a=false
PZ3D.menuUi(c())
end
end

local function d()
if PZ3D then
Events.OnTick.Add(b)
end
end

Events.OnGameStart.Add(d)
