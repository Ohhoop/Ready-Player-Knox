require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Framework/GameTexts"

SpiffBoy.Lanterways=SpiffBoy.Lanterways or{}

local a=SpiffBoy.Lanterways

a.ID="Lanterways"
a.TILE=12
a.WIDTH=SpiffBoy.Cartridges.SCREEN_WIDTH
a.HEIGHT=SpiffBoy.Cartridges.SCREEN_HEIGHT
a.SHADES=SpiffBoy.Cartridges.SHADES
a.INK=1
a.DARK=2
a.MID=3
a.PAPER=4
a.DIRECTIONS={
{name="down",dx=0,dy=1},
{name="up",dx=0,dy=-1},
{name="left",dx=-1,dy=0},
{name="right",dx=1,dy=0},
}
a.DIRECTION_INDEX={down=1,up=2,left=3,right=4}
a.PARTY_SIZE=4
a.LEVEL_CAP=30

a.Maps=a.Maps or{}
a.Scripts=a.Scripts or{}

a.text=SpiffBoy.GameTexts.of("Lanterways")

function a.wrap(value,count)
return(value-1+count)%count+1
end

function a.shade(index)
local b=a.SHADES[index]
return b.r,b.g,b.b
end

function a.verticalStep(pressed)
if pressed.up then
return-1
elseif pressed.down then
return 1
end
return 0
end

function a.horizontalStep(pressed)
if pressed.left then
return-1
elseif pressed.right then
return 1
end
return 0
end

function a.filter(list,test)
local b={}
for c=1,#list do
if test(list[c])then
b[#b+1]=list[c]
end
end
return b
end

function a.indexOf(list,value)
for b=1,#list do
if list[b]==value then
return b
end
end
return nil
end

function a.trace(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("Lanterways: "..message)
end
end
