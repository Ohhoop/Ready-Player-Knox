require"PZAPI/ModOptions"
require"SpiffBoy/Core/Core"

SpiffBoy.ConsolePosition=SpiffBoy.ConsolePosition or{}
local a=SpiffBoy.ConsolePosition

a.RIGHT="right"
a.LEFT="left"
a.CENTRE="centre"

local c={
{position=a.RIGHT,name="UI_SpiffBoy_ConsolePositionRight"},
{position=a.LEFT,name="UI_SpiffBoy_ConsolePositionLeft"},
{position=a.CENTRE,name="UI_SpiffBoy_ConsolePositionCentre"},
}

local e=PZAPI.ModOptions:create(SpiffBoy.MOD_ID,"UI_SpiffBoy_ModOptions")
local b=e:addComboBox("ConsolePosition","UI_SpiffBoy_ConsolePosition","UI_SpiffBoy_ConsolePosition_tt")
for d,f in ipairs(c)do
b:addItem(f.name,d==1)
end

function a.get()
local d=c[b:getValue()]
if not d then
error("SpiffBoy: the mod options hold no console position "..tostring(b:getValue()))
end
return d.position
end
