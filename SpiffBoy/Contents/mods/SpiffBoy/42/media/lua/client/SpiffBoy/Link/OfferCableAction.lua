require"TimedActions/ISBaseTimedAction"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Handheld/Handheld"

SpiffBoyOfferCableAction=ISBaseTimedAction:derive("SpiffBoyOfferCableAction")

local b=SpiffBoy.Handheld

function SpiffBoyOfferCableAction:findConsole()
return self.character:getInventory():getItemById(self.consoleId)
end

function SpiffBoyOfferCableAction:isValid()
return self:findConsole()~=nil and self.peer~=nil and not self.peer:isDead()
end

function SpiffBoyOfferCableAction:update()
local a=self:findConsole()
if a and b.hasCable(a)then
self:forceComplete()
end
end

function SpiffBoyOfferCableAction:perform()
ISBaseTimedAction.perform(self)
SpiffBoy.LinkMenu.offer(self.character,self.peer)
end

function SpiffBoyOfferCableAction:new(character,console,peer)
local a=ISBaseTimedAction.new(self,character)
a.consoleId=console:getID()
a.peer=peer
a.maxTime=-1
a.useProgressBar=false
a.stopOnWalk=false
a.stopOnRun=false
return a
end
