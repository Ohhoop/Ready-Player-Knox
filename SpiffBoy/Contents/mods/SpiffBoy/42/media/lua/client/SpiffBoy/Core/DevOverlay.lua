require"SpiffBoy/Core/Core"

SpiffBoy.DevOverlay=SpiffBoy.DevOverlay or{}
local l=SpiffBoy.DevOverlay

local i=8
local m=14

local function b(c,d)
local a=10^d
return tostring(math.floor(c*a)/a)
end

function l.draw(a)
if not SpiffBoy.isDevBuild()then
return
end
local d=a.runtime
local j=a.shell
local f=a.screen.calls
if j then
f=f+j.calls
end
local c={
"frame "..b(d.frameMs,1).." ms  ticks "..tostring(d.ticksThisFrame).."  tick "..tostring(d.tick),
"calls "..tostring(f).."  scale "..tostring(a.screen.scale),
"mode "..tostring(d.game and d.game.mode),
}
if a.veil~=nil then
local g=a.playerObj:getCurrentSquare()
local e="light "..b(a.light,3).."  veil "..b(a.veil,3)
if g then
e=e.."  darkMulti "..b(g:getDarkMulti(a.playerNum),3)
end
e=e.."  daylight "..b(getClimateManager():getDayLightStrength(),3)
c[#c+1]=e
end
local g=a.chip
if g then
for h=1,#g.voices do
local e=g.voices[h]
local k="voice "..tostring(h).." off"
if e.on then
k="voice "..tostring(h).." "..tostring(e.sound).."  pitch "..b(e.pitch,3).."  gain "..b(e.gain,2)
end
c[#c+1]=k
end
end
for e=1,#c do
a:drawText(c[e],i-a:getX(),i-a:getY()+(e-1)*m,0.4,1,0.4,1,UIFont.Small)
end
end
