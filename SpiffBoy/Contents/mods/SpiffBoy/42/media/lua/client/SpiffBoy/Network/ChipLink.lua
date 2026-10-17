require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Sandbox"
require"SpiffBoy/Core/Commands"

SpiffBoyChipLink={}
SpiffBoyChipLink.__index=SpiffBoyChipLink
local a=SpiffBoyChipLink

local l=100
local m=2000
local e=SpiffBoy.CHIP_MAX_EVENTS
local c=1
local n=5000

function a.new(d)
local b=setmetatable({},a)
b.playerObj=d
b.networked=isClient()and SpiffBoy.Sandbox.othersHearConsole()
b.tick=0
b.events={}
b.lastSendMs=0
b.lastBeatMs=0
b.cartridge=nil
b.volume=c
b.frozen=false
b.private=false
b.traceStartMs=0
b.tracedBatches=0
return b
end

function a:push(b)
if not self.networked or self.private then
return
end
b.t=self.tick
self.events[#self.events+1]=b
if#self.events>=e then
self:send()
end
end

function a:traceSend(b)
if not SpiffBoy.isDevBuild()then
return
end
if self.traceStartMs==0 then
SpiffBoy.log("chip link: first batch sent, cartridge "..tostring(self.cartridge)..", private "..tostring(self.private))
self.traceStartMs=b
end
self.tracedBatches=self.tracedBatches+1
if b-self.traceStartMs>=n then
SpiffBoy.log("chip link: "..tostring(self.tracedBatches).." batches sent in "..tostring(b-self.traceStartMs).." ms, tick "..tostring(self.tick)..", cartridge "..tostring(self.cartridge)..", private "..tostring(self.private))
self.traceStartMs=b
self.tracedBatches=0
end
end

function a:send()
sendClientCommand(self.playerObj,SpiffBoy.COMMAND_MODULE,SpiffBoy.COMMAND_CHIP,{t=self.tick,e=SpiffBoy.wireList(self.events)})
self.events={}
self.lastSendMs=getTimestampMs()
self:traceSend(self.lastSendMs)
end

local function f(b)
b:push({k=SpiffBoy.CHIP_EVENT_ON,c=b.cartridge,v=b.volume})
end

local function g(b)
b:push({k=SpiffBoy.CHIP_EVENT_OFF})
end

function a:powerOn(b,d)
self.cartridge=b
self.volume=d
self.frozen=false
f(self)
end

function a:powerOff()
if not self.cartridge then
return
end
self.cartridge=nil
self.frozen=false
g(self)
end

function a:freeze()
if not self.cartridge or self.frozen then
return
end
self.frozen=true
self:push({k=SpiffBoy.CHIP_EVENT_FREEZE})
end

function a:setVolume(b)
self.volume=b
if self.cartridge then
self:push({k=SpiffBoy.CHIP_EVENT_VOLUME,v=b})
end
end

function a:setPrivate(b)
if self.private==b then
return
end
if SpiffBoy.isDevBuild()then
SpiffBoy.log("chip link: private "..tostring(b))
end
if b then
if self.cartridge then
g(self)
end
self.private=true
return
end
self.private=false
if self.cartridge then
f(self)
self.lastBeatMs=0
end
end

function a:onChipWrite(b,d)
self:push({k=SpiffBoy.CHIP_EVENT_WRITE,r=b,v=d})
end

function a:onChipWave(b)
self:push({k=SpiffBoy.CHIP_EVENT_WAVE,n=b})
end

function a:onSequencerPlay(b)
self:push({k=SpiffBoy.CHIP_EVENT_PLAY,n=b})
end

function a:onSequencerStop()
self:push({k=SpiffBoy.CHIP_EVENT_STOP})
end

function a:onSequencerEffect(b)
self:push({k=SpiffBoy.CHIP_EVENT_EFFECT,n=b})
end

function a:onSequencerMix(b,d)
self:push({k=SpiffBoy.CHIP_EVENT_MIX,m=b,f=d})
end

function a:step()
self.tick=self.tick+1
end

function a:flush(b)
if not self.networked then
return
end
local d=getTimestampMs()
if self.cartridge and not self.private and d-self.lastBeatMs>=m then
self.lastBeatMs=d
local h,i=nil,0
local j,k=c,c
if b then
h,i=b:state()
j,k=b:mix()
end
self:push({k=SpiffBoy.CHIP_EVENT_BEAT,c=self.cartridge,v=self.volume,n=h,p=i,m=j,f=k,z=self.frozen})
end
local h=#self.events
if h==0 then
return
end
if h<e and d-self.lastSendMs<l then
return
end
self:send()
end

function a:close()
self:powerOff()
if self.networked and#self.events>0 then
self:send()
end
end
