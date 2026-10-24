require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Sandbox"
require"SpiffBoy/Core/Commands"

SpiffBoyChipLink={}
SpiffBoyChipLink.__index=SpiffBoyChipLink
local a=SpiffBoyChipLink

local k=100
local l=2000
local d=SpiffBoy.CHIP_MAX_EVENTS
local c=1
local m=5000

function a.new(playerObj)
local b=setmetatable({},a)
b.playerObj=playerObj
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

function a:push(event)
if not self.networked or self.private then
return
end
event.t=self.tick
self.events[#self.events+1]=event
if#self.events>=d then
self:send()
end
end

function a:traceSend(now)
if not SpiffBoy.isDevBuild()then
return
end
if self.traceStartMs==0 then
SpiffBoy.log("chip link: first batch sent, cartridge "..tostring(self.cartridge)..", private "..tostring(self.private))
self.traceStartMs=now
end
self.tracedBatches=self.tracedBatches+1
if now-self.traceStartMs>=m then
SpiffBoy.log("chip link: "..tostring(self.tracedBatches).." batches sent in "..tostring(now-self.traceStartMs).." ms, tick "..tostring(self.tick)..", cartridge "..tostring(self.cartridge)..", private "..tostring(self.private))
self.traceStartMs=now
self.tracedBatches=0
end
end

function a:send()
sendClientCommand(self.playerObj,SpiffBoy.COMMAND_MODULE,SpiffBoy.COMMAND_CHIP,{t=self.tick,e=SpiffBoy.wireList(self.events)})
self.events={}
self.lastSendMs=getTimestampMs()
self:traceSend(self.lastSendMs)
end

local function e(link)
link:push({k=SpiffBoy.CHIP_EVENT_ON,c=link.cartridge,v=link.volume})
end

local function f(link)
link:push({k=SpiffBoy.CHIP_EVENT_OFF})
end

function a:powerOn(cartridge,volume)
self.cartridge=cartridge
self.volume=volume
self.frozen=false
e(self)
end

function a:powerOff()
if not self.cartridge then
return
end
self.cartridge=nil
self.frozen=false
f(self)
end

function a:freeze()
if not self.cartridge or self.frozen then
return
end
self.frozen=true
self:push({k=SpiffBoy.CHIP_EVENT_FREEZE})
end

function a:setVolume(volume)
self.volume=volume
if self.cartridge then
self:push({k=SpiffBoy.CHIP_EVENT_VOLUME,v=volume})
end
end

function a:setPrivate(private)
if self.private==private then
return
end
if SpiffBoy.isDevBuild()then
SpiffBoy.log("chip link: private "..tostring(private))
end
if private then
if self.cartridge then
f(self)
end
self.private=true
return
end
self.private=false
if self.cartridge then
e(self)
self.lastBeatMs=0
end
end

function a:onChipWrite(register,value)
self:push({k=SpiffBoy.CHIP_EVENT_WRITE,r=register,v=value})
end

function a:onChipWave(name)
self:push({k=SpiffBoy.CHIP_EVENT_WAVE,n=name})
end

function a:onSequencerPlay(name)
self:push({k=SpiffBoy.CHIP_EVENT_PLAY,n=name})
end

function a:onSequencerStop()
self:push({k=SpiffBoy.CHIP_EVENT_STOP})
end

function a:onSequencerEffect(name)
self:push({k=SpiffBoy.CHIP_EVENT_EFFECT,n=name})
end

function a:onSequencerMix(music,effects)
self:push({k=SpiffBoy.CHIP_EVENT_MIX,m=music,f=effects})
end

function a:step()
self.tick=self.tick+1
end

function a:flush(sequencer)
if not self.networked then
return
end
local b=getTimestampMs()
if self.cartridge and not self.private and b-self.lastBeatMs>=l then
self.lastBeatMs=b
local g,h=nil,0
local i,j=c,c
if sequencer then
g,h=sequencer:state()
i,j=sequencer:mix()
end
self:push({k=SpiffBoy.CHIP_EVENT_BEAT,c=self.cartridge,v=self.volume,n=g,p=h,m=i,f=j,z=self.frozen})
end
local g=#self.events
if g==0 then
return
end
if g<d and b-self.lastSendMs<k then
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
