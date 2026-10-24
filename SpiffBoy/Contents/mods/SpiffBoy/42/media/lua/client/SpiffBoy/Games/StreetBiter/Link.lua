require"SpiffBoy/Core/Core"

SpiffBoy.StreetBiter=SpiffBoy.StreetBiter or{}

local a={}
a.__index=a
SpiffBoy.StreetBiter.Link=a

a.KIND_HELLO="W"
a.KIND_PING="P"
a.KIND_PONG="Q"
a.KIND_CHOICE="C"
a.KIND_START="S"
a.KIND_INPUT="I"

a.MIN_DELAY=8
a.MAX_DELAY=20
a.EXTRA_DELAY=3
a.PINGS=4
a.TICK_MODULUS=65536

local g={up=1,down=2,left=4,right=8,a=16,b=32}
local h={"up","down","left","right","a","b"}

function a.new(port)
local b=setmetatable({},a)
b.port=port
b.local_={}
b.remote={}
b.pingSent=nil
b.pings=0
b.roundTrip=nil
b.matchId=0
return b
end

function a:isConnected()
return self.port:isConnected()
end

function a:seat()
return self.port:seat()
end

function a:leads()
return self:seat()==1
end

function a.packInput(held)
local b=0
for d,c in ipairs(h)do
if held[c]then
b=b+g[c]
end
end
return b
end

function a.unpackInput(value)
local b={}
for e,c in ipairs(h)do
local d=g[c]
b[c]=math.floor(value/d)%2==1
end
return b
end

local function i(tick)
local b=tick%a.TICK_MODULUS
return string.char(math.floor(b/256),b%256)
end

local function j(message,position)
return string.byte(message,position)*256+string.byte(message,position+1)
end

function a:send(message)
self.port:send(message)
end

function a:hello()
self:send(a.KIND_HELLO)
end

function a:ping(tick)
self.pingSent=tick
self.pings=self.pings+1
self:send(a.KIND_PING..i(tick))
end

function a:needsPing()
return self.pings<a.PINGS and self.pingSent==nil
end

function a:sendChoice(index)
self:send(a.KIND_CHOICE..string.char(index))
end

function a:nextMatch()
self.matchId=(self.matchId+1)%256
self:reset()
end

function a:sendStart(seed,delay)
local c=seed
local b={}
for d=4,1,-1 do
b[d]=c%256
c=math.floor(c/256)
end
self:send(a.KIND_START..string.char(self.matchId,b[1],b[2],b[3],b[4],delay))
end

function a:sendInput(tick,held)
local b=a.packInput(held)
self.local_[tick]=b
self:send(a.KIND_INPUT..string.char(self.matchId)..i(tick)..string.char(b))
end

function a:reset()
self.local_={}
self.remote={}
self.pingSent=nil
end

function a:forgetMeasure()
self.pings=0
self.roundTrip=nil
self.pingSent=nil
end

function a:delay()
if not self.roundTrip then
return a.MAX_DELAY
end
local b=math.ceil(self.roundTrip/2)
return SpiffBoy.clamp(b+a.EXTRA_DELAY,a.MIN_DELAY,a.MAX_DELAY)
end

function a:remoteInput(tick)
local b=self.remote[tick]
if b==nil then
return nil
end
return a.unpackInput(b)
end

function a:localInput(tick)
local b=self.local_[tick]
if b==nil then
return nil
end
return a.unpackInput(b)
end

function a:poll(tick)
local d={}
while true do
local b=self.port:receive()
if b==nil then
break
end
local c=string.sub(b,1,1)
local e=string.len(b)
if c==a.KIND_INPUT and e==5 then
if string.byte(b,2)==self.matchId then
self.remote[j(b,3)]=string.byte(b,5)
end
elseif c==a.KIND_PING and e==3 then
self:send(a.KIND_PONG..string.sub(b,2,3))
elseif c==a.KIND_PONG and e==3 then
if self.pingSent and j(b,2)==self.pingSent%a.TICK_MODULUS then
self.roundTrip=math.max(self.roundTrip or 0,tick-self.pingSent)
self.pingSent=nil
end
elseif c==a.KIND_CHOICE and e==2 then
d[#d+1]={kind=c,index=string.byte(b,2)}
elseif c==a.KIND_START and e==7 then
local f=0
for k=3,6 do
f=f*256+string.byte(b,k)
end
self.matchId=string.byte(b,2)
self:reset()
d[#d+1]={kind=c,seed=f,delay=SpiffBoy.clamp(string.byte(b,7),a.MIN_DELAY,a.MAX_DELAY)}
elseif c==a.KIND_HELLO then
d[#d+1]={kind=c}
end
end
return d
end
