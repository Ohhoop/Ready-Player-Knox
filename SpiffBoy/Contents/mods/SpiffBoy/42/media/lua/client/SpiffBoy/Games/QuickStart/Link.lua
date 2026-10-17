require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/QuickStart/Base"

local i=SpiffBoy.QuickStart

local a={}
a.__index=a
i.Link=a

a.KIND_HELLO="W"
a.KIND_PING="P"
a.KIND_PONG="Q"
a.KIND_SETUP="M"
a.KIND_CHOICE="C"
a.KIND_START="S"
a.KIND_INPUT="I"
a.KIND_SUM="K"
a.KIND_NEXT="N"

a.MIN_DELAY=8
a.MAX_DELAY=20
a.EXTRA_DELAY=3
a.PINGS=4
a.TICK_MODULUS=65536

function a.new(c)
local b=setmetatable({},a)
b.port=c
b.local_={}
b.remote={}
b.sums={}
b.pingSent=nil
b.pings=0
b.roundTrip=nil
b.matchId=0
b.mismatches=0
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

local function f(b)
b=b%a.TICK_MODULUS
return string.char(math.floor(b/256),b%256)
end

local function g(b,c)
return string.byte(b,c)*256+string.byte(b,c+1)
end

function a:send(b)
self.port:send(b)
end

function a:hello()
self:send(a.KIND_HELLO)
end

function a:ping(b)
self.pingSent=b
self.pings=self.pings+1
self:send(a.KIND_PING..f(b))
end

function a:needsPing()
return self.pings<a.PINGS and self.pingSent==nil
end

function a:sendSetup(b,c,d)
self:send(a.KIND_SETUP..string.char(b,c,d))
end

function a:sendChoice(b)
self:send(a.KIND_CHOICE..string.char(b))
end

function a:sendNext(b)
self:send(a.KIND_NEXT..string.char(b))
end

function a:nextMatch()
self.matchId=(self.matchId+1)%256
self:reset()
end

function a:sendStart(d,e)
local c=d
local b={}
for h=4,1,-1 do
b[h]=c%256
c=math.floor(c/256)
end
self:send(a.KIND_START..string.char(self.matchId,b[1],b[2],b[3],b[4],e))
end

function a:sendInput(b,c)
self.local_[b]=c
self:send(a.KIND_INPUT..string.char(self.matchId)..f(b)..string.char(c))
end

function a:sendSum(b,c)
self.sums[b]=c
self:send(a.KIND_SUM..string.char(self.matchId)..f(b)..f(c))
end

function a:reset()
self.local_={}
self.remote={}
self.sums={}
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

function a:remoteInput(b)
return self.remote[b%a.TICK_MODULUS]
end

function a:localInput(b)
return self.local_[b]
end

local function j(self,c,d)
local b=self.sums[c]
if b and b~=d then
self.mismatches=self.mismatches+1
SpiffBoy.log("QuickStart: the two consoles disagree at tick "..c.." ("..b.." against "..d..")")
end
end

function a:poll(k)
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
self.remote[g(b,3)]=string.byte(b,5)
end
elseif c==a.KIND_SUM and e==6 then
if string.byte(b,2)==self.matchId then
j(self,g(b,3),g(b,5))
end
elseif c==a.KIND_PING and e==3 then
self:send(a.KIND_PONG..string.sub(b,2,3))
elseif c==a.KIND_PONG and e==3 then
if self.pingSent and g(b,2)==self.pingSent%a.TICK_MODULUS then
self.roundTrip=math.max(self.roundTrip or 0,k-self.pingSent)
self.pingSent=nil
end
elseif c==a.KIND_SETUP and e==4 then
d[#d+1]={kind=c,mode=string.byte(b,2),cc=string.byte(b,3),course=string.byte(b,4)}
elseif c==a.KIND_CHOICE and e==2 then
d[#d+1]={kind=c,index=string.byte(b,2)}
elseif c==a.KIND_NEXT and e==2 then
d[#d+1]={kind=c,choice=string.byte(b,2)}
elseif c==a.KIND_START and e==7 then
local h=0
for l=3,6 do
h=h*256+string.byte(b,l)
end
self.matchId=string.byte(b,2)
self:reset()
d[#d+1]={kind=c,seed=h,delay=SpiffBoy.clamp(string.byte(b,7),a.MIN_DELAY,a.MAX_DELAY)}
elseif c==a.KIND_HELLO then
d[#d+1]={kind=c}
end
end
return d
end
