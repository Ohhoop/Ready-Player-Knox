require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Framework/GameTexts"

SpiffBoy.QuickStart=SpiffBoy.QuickStart or{}

local a=SpiffBoy.QuickStart

a.ID="QuickStart"
a.gameText=SpiffBoy.GameTexts.of("QuickStart")
a.WIDTH=SpiffBoy.Cartridges.SCREEN_WIDTH
a.HEIGHT=SpiffBoy.Cartridges.SCREEN_HEIGHT
a.SHADES=SpiffBoy.Cartridges.SHADES
a.INK=1
a.DARK=2
a.MID=3
a.PAPER=4
a.TILE=2
a.Maps=a.Maps or{}

function a.mod(value,divisor)
return(value%divisor+divisor)%divisor
end

function a.wrapIndex(index,count)
return a.mod(index-1,count)+1
end
