require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Link/LinkState"
require"SpiffBoy/Link/LocalLink"
require"SpiffBoy/Link/NetworkLink"

SpiffBoyLinkChannel={}
SpiffBoyLinkChannel.__index=SpiffBoyLinkChannel
local a=SpiffBoyLinkChannel
local e=SpiffBoy.LinkState

local f=100
local g=1000
local h=256
local i=SpiffBoy.LINK_MESSAGES_PER_TICK
local j=SpiffBoy.LINK_BATCH_MAX

function a.new(c)
local b=setmetatable({},a)
b.window=c
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
return e.of(self.window.playerNum)
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

function a:send(b)
if not SpiffBoy.isLinkMessage(b)then
error("SpiffBoy: a link message is a text of 1 to "..SpiffBoy.LINK_MESSAGE_MAX.." bytes")
end
self.lastUsedMs=getTimestampMs()
if not self:isConnected()or self.pending>=i then
return false
end
self.pending=self.pending+1
self.outgoing[#self.outgoing+1]=b
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
return self.lastUsedMs~=nil and getTimestampMs()-self.lastUsedMs<g
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
if b<j and c-self.lastSendMs<f then
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

function a:onData(c,d)
if self.lastReceived~=nil and c<=self.lastReceived then
return
end
self.lastReceived=c
local b=self.incoming
for k=1,#d do
b[#b+1]=d[k]
end
while#b>h do
table.remove(b,1)
end
end

function a:onState(b,c)
local d=self:isConnected()
self.peerCartridge=b
self.peerOn=c
if d and not self:isConnected()and self:inUse()then
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
send=function(d,c)
return b:send(c)
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
