require"TimedActions/ISBaseTimedAction"
require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"

SpiffBoyPlayHandheldAction=ISBaseTimedAction:derive("SpiffBoyPlayHandheldAction")

local b="SBPlayHandheld"
local c="SpiffBoyHandheldInHand"

function SpiffBoyPlayHandheldAction:isValid()
return self.window~=nil and not self.window.closing
end

function SpiffBoyPlayHandheldAction:start()
self:setActionAnim(b)
self:setOverrideHandModelsString(nil,c)
end

function SpiffBoyPlayHandheldAction:new(character,window)
local a=ISBaseTimedAction.new(self,character)
a.window=window
a.maxTime=-1
a.useProgressBar=false
a.stopOnWalk=false
a.stopOnRun=false
a.stopOnAim=false
return a
end

function SpiffBoyPlayHandheldAction.startFor(playerObj,window)
ISTimedActionQueue.clear(playerObj)
local a=SpiffBoyPlayHandheldAction:new(playerObj,window)
ISTimedActionQueue.add(a)
return a
end

function SpiffBoyPlayHandheldAction.finishFor(action)
if action and action.action then
action:forceComplete()
end
end

function SpiffBoyPlayHandheldAction.stopFor(action)
if action and action.action then
action:forceStop()
end
end
