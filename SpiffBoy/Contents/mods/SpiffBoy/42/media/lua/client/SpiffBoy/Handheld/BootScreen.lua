require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Core/Tunes"

SpiffBoyBootScreen={}
SpiffBoyBootScreen.__index=SpiffBoyBootScreen
SpiffBoyBootScreen.Type="SpiffBoyBootScreen"

local d=SpiffBoy.Tunes

local f=SpiffBoy.Cartridges.SHADES[4]
local g=SpiffBoy.Cartridges.SHADES[1]
local e=134
local a=26
local k={1,2,3,4}
local r=0
local s=1
local t=1
local u=0x80
local v=0x40
local h=0xC2
local w=0xC5
local i=0x82
local x=0x84
local y=65
local z={
{registers=d.REGISTERS[SpiffBoyChip.PULSE1],duty=u},
{registers=d.REGISTERS[SpiffBoyChip.PULSE2],duty=v},
}
local l,m,n,A,B=1798,1849,1881,1923,1714
local j={
{tick=0,voice=1,period=l,envelope=h},
{tick=0,voice=2,period=B,envelope=i},
{tick=5,voice=1,period=m,envelope=h},
{tick=5,voice=2,period=l,envelope=i},
{tick=10,voice=1,period=n,envelope=h},
{tick=10,voice=2,period=m,envelope=i},
{tick=15,voice=1,period=A,envelope=w},
{tick=15,voice=2,period=n,envelope=x},
}

function SpiffBoyBootScreen.new(logo,chip,empty)
local b=setmetatable({},SpiffBoyBootScreen)
b.logo=logo
b.chip=chip
b.empty=empty
b.y=-a
b.landedTicks=nil
return b
end

function SpiffBoyBootScreen:note(entry)
local c=self.chip
local o=z[entry.voice]
local b=o.registers
if b.sweep then
c:write(b.sweep,0)
end
c:write(b.duty,o.duty)
c:write(b.envelope,entry.envelope)
local p,q=d.periodBytes(entry.period)
c:write(b.low,p)
c:write(b.high,d.TRIGGER+q)
end

function SpiffBoyBootScreen:tick(inputs,tick)
local b=math.floor((SpiffBoy.Cartridges.SCREEN_HEIGHT-a)/2)
if self.y<b then
self.y=math.min(b,self.y+t)
return
end
if self.empty then
return
end
if self.landedTicks then
self.landedTicks=self.landedTicks+1
else
self.landedTicks=0
end
for c=1,#j do
if j[c].tick==self.landedTicks then
self:note(j[c])
end
end
end

function SpiffBoyBootScreen:isDone()
return self.landedTicks~=nil and self.landedTicks>=y
end

function SpiffBoyBootScreen:draw(screen)
screen:clear(f.r,f.g,f.b)
local c=math.floor(self.y)
local o=math.floor((screen.width-e)/2)
local b=math.max(0,-c)
if b>=a then
return
end
if self.empty then
screen:rect(o,c+b,e,a-b,g.r,g.g,g.b,1)
return
end
local p=r
if self.landedTicks then
p=s
end
for C=1,#k do
local q=k[C]
screen:sheet(self.logo,p*e,(q-1)*a+b,e,a-b,o,c+b,1,q)
end
end
