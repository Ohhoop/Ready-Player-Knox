require"SpiffBoy/Core/Core"

SpiffBoy.DevOverlay=SpiffBoy.DevOverlay or{}
local k=SpiffBoy.DevOverlay

local h=8
local l=14

local function a(value,decimals)
local b=10^decimals
return tostring(math.floor(value*b)/b)
end

function k.draw(window)
if not SpiffBoy.isDevBuild()then
return
end
local c=window.runtime
local i=window.shell
local e=window.screen.calls
if i then
e=e+i.calls
end
local b={
"frame "..a(c.frameMs,1).." ms  ticks "..tostring(c.ticksThisFrame).."  tick "..tostring(c.tick),
"calls "..tostring(e).."  scale "..tostring(window.screen.scale),
"mode "..tostring(c.game and c.game.mode),
}
if window.veil~=nil then
local f=window.playerObj:getCurrentSquare()
local d="light "..a(window.light,3).."  veil "..a(window.veil,3)
if f then
d=d.."  darkMulti "..a(f:getDarkMulti(window.playerNum),3)
end
d=d.."  daylight "..a(getClimateManager():getDayLightStrength(),3)
b[#b+1]=d
end
local f=window.chip
if f then
for g=1,#f.voices do
local d=f.voices[g]
local j="voice "..tostring(g).." off"
if d.on then
j="voice "..tostring(g).." "..tostring(d.sound).."  pitch "..a(d.pitch,3).."  gain "..a(d.gain,2)
end
b[#b+1]=j
end
end
for d=1,#b do
window:drawText(b[d],h-window:getX(),h-window:getY()+(d-1)*l,0.4,1,0.4,1,UIFont.Small)
end
end
