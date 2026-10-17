require"TimedActions/ISBaseTimedAction"
require"TimedActions/ISTimedActionQueue"
require"ISUI/ISInventoryPaneContextMenu"
require"SpiffBoy/Core/Core"
require"SpiffBoy/UI/HandheldWindow"

SpiffBoyOpenHandheldAction=ISBaseTimedAction:derive("SpiffBoyOpenHandheldAction")

local function c(d,a)
local b=SpiffBoyHandheldWindow.hiddenOn(a)
if b then
b:reveal()
return
end
SpiffBoyHandheldWindow.open(d,a)
end

function SpiffBoyOpenHandheldAction:isValid()
return self.character:getInventory():containsID(self.consoleId)
end

function SpiffBoyOpenHandheldAction:perform()
ISBaseTimedAction.perform(self)
local a=self.character:getInventory():getItemById(self.consoleId)
if a then
c(self.character,a)
end
end

function SpiffBoyOpenHandheldAction:new(b,d)
local a=ISBaseTimedAction.new(self,b)
a.consoleId=d:getID()
a.maxTime=1
a.useProgressBar=false
a.stopOnWalk=false
a.stopOnRun=false
return a
end

function SpiffBoyOpenHandheldAction.playFor(a,b)
if b:getContainer()==a:getInventory()then
c(a,b)
return
end
ISInventoryPaneContextMenu.transferIfNeeded(a,b)
ISTimedActionQueue.add(SpiffBoyOpenHandheldAction:new(a,b))
end
