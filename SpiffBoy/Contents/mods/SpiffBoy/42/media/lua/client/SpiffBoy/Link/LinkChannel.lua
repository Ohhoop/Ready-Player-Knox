require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Link/LinkState"
require"SpiffBoy/Link/LocalLink"
require"SpiffBoy/Link/NetworkLink"

SpiffBoyLinkChannel={}
SpiffBoyLinkChannel.__index=SpiffBoyLinkChannel
local a=SpiffBoyLinkChannel
local d=SpiffBoy.LinkState

local e=100
local f=1000
local g=256
local h=SpiffBoy.LINK_MESSAGES_PER_TICK
local i=SpiffBoy.LINK_BATCH_MAX

function a.new(window)
local b=setmetatable({},a)
b.window=window
if isClient()then
b.carrier=SpiffBoy.NetworkLink
else
b.carrier=SpiffBoy.LocalLink
end
b.outgoing={}
b.incoming={}
b.pending=0
b.sequence=0
b.lastReceived=nil
b.lastSendMs=0
b.lastUsedMs=nil
b.peerCartridge=nil
b.peerOn=false
return b
end

function a:link()
return d.of(self.window.playerNum)
end

function a:isConnected()
local b=self.window
return self:link()~=nil and b.powered and self.peerOn and b.definition~=nil and self.peerCartridge==b.definition.item
end

function a:seat()
local b=self:link()
if not b then
return nil
end
return b.seat
end

function a:send(message)
if not SpiffBoy.isLinkMessage(message)then
error("SpiffBoy: a link message is a text of 1 to "..SpiffBoy.LINK_MESSAGE_MAX.." bytes")
end
self.lastUsedMs=getTimestampMs()
if not self:isConnected()or self.pending>=h then
return false
end
self.pending=self.pending+1
self.outgoing[#self.outgoing+1]=message
return true
end

function a:receive()
if#self.incoming==0 then
return nil
end
self.lastUsedMs=getTimestampMs()
return table.remove(self.incoming,1)
end

function a:inUse()
return self.lastUsedMs~=nil and getTimestampMs()-self.lastUsedMs<f
end

function a:step()
self.pending=0
end

function a:flush()
local b=#self.outgoing
if b==0 then
return
end
local c=getTimestampMs()
if b<i and c-self.lastSendMs<e then
return
end
self.carrier.sendData(self.window.playerObj,self.sequence,self.outgoing)
self.sequence=self.sequence+1
self.outgoing={}
self.lastSendMs=c
end

function a:announce()
local b=self.window.definition
local c=nil
if b then
c=b.item
end
self.carrier.sendState(self.window.playerObj,c,self.window.powered)
end

function a:onData(sequence,messages)
if self.lastReceived~=nil and sequence<=self.lastReceived then
return
end
self.lastReceived=sequence
local b=self.incoming
for c=1,#messages do
b[#b+1]=messages[c]
end
while#b>g do
table.remove(b,1)
end
end

function a:onState(cartridge,on)
local b=self:isConnected()
self.peerCartridge=cartridge
self.peerOn=on
if b and not self:isConnected()and self:inUse()then
self.window:onLinkLost()
end
end

function a:onConnected()
self.outgoing={}
self.incoming={}
self.pending=0
self.sequence=0
self.lastReceived=nil
self:announce()
end

function a:onDisconnected()
self.outgoing={}
self.incoming={}
self.peerCartridge=nil
self.peerOn=false
if self:inUse()then
self.window:onLinkLost()
end
end

function a:view()
local b=self
local c={
isConnected=function()
return b:isConnected()
end,
seat=function()
return b:seat()
end,
send=function(_,message)
return b:send(message)
end,
receive=function()
return b:receive()
end,
}
return setmetatable({},{
__index=c,
__newindex=function()
error("a game cannot change the link port of the console")
end,
__metatable=false,
})
end
