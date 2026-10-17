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

function a.wrap(c,b)
return(c-1+b)%b+1
end

function a.shade(c)
local b=a.SHADES[c]
return b.r,b.g,b.b
end

function a.verticalStep(b)
if b.up then
return-1
elseif b.down then
return 1
end
return 0
end

function a.horizontalStep(b)
if b.left then
return-1
elseif b.right then
return 1
end
return 0
end

function a.filter(b,e)
local c={}
for d=1,#b do
if e(b[d])then
c[#c+1]=b[d]
end
end
return c
end

function a.indexOf(b,d)
for c=1,#b do
if b[c]==d then
return c
end
end
return nil
end

function a.trace(b)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("Lanterways: "..b)
end
end
