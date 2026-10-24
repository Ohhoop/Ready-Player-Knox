require"TimedActions/ISBaseTimedAction"
require"TimedActions/ISTimedActionQueue"
require"ISUI/ISInventoryPaneContextMenu"
require"SpiffBoy/Core/Core"
require"SpiffBoy/UI/HandheldWindow"

SpiffBoyOpenHandheldAction=ISBaseTimedAction:derive("SpiffBoyOpenHandheldAction")

local function b(playerObj,console)
local a=SpiffBoyHandheldWindow.hiddenOn(console)
if a then
a:reveal()
return
end
SpiffBoyHandheldWindow.open(playerObj,console)
end

function SpiffBoyOpenHandheldAction:isValid()
return self.character:getInventory():containsID(self.consoleId)
end

function SpiffBoyOpenHandheldAction:perform()
ISBaseTimedAction.perform(self)
local a=self.character:getInventory():getItemById(self.consoleId)
if a then
b(self.character,a)
end
end

function SpiffBoyOpenHandheldAction:new(character,console)
local a=ISBaseTimedAction.new(self,character)
a.consoleId=console:getID()
a.maxTime=1
a.useProgressBar=false
a.stopOnWalk=false
a.stopOnRun=false
return a
end

function SpiffBoyOpenHandheldAction.playFor(playerObj,console)
if console:getContainer()==playerObj:getInventory()then
b(playerObj,console)
return
end
ISInventoryPaneContextMenu.transferIfNeeded(playerObj,console)
ISTimedActionQueue.add(SpiffBoyOpenHandheldAction:new(playerObj,console))
end
