require"TimedActions/ISBaseTimedAction"
require"TimedActions/ISTimedActionQueue"
require"SpiffBoy/Core/Core"

SpiffBoyPlayHandheldAction=ISBaseTimedAction:derive("SpiffBoyPlayHandheldAction")

local c="SBPlayHandheld"
local d="SpiffBoyHandheldInHand"

function SpiffBoyPlayHandheldAction:isValid()
return self.window~=nil and not self.window.closing
end

function SpiffBoyPlayHandheldAction:start()
self:setActionAnim(c)
self:setOverrideHandModelsString(nil,d)
end

function SpiffBoyPlayHandheldAction:new(b,e)
local a=ISBaseTimedAction.new(self,b)
a.window=e
a.maxTime=-1
a.useProgressBar=false
a.stopOnWalk=false
a.stopOnRun=false
a.stopOnAim=false
return a
end

function SpiffBoyPlayHandheldAction.startFor(a,e)
ISTimedActionQueue.clear(a)
local b=SpiffBoyPlayHandheldAction:new(a,e)
ISTimedActionQueue.add(b)
return b
end

function SpiffBoyPlayHandheldAction.finishFor(a)
if a and a.action then
a:forceComplete()
end
end

function SpiffBoyPlayHandheldAction.stopFor(a)
if a and a.action then
a:forceStop()
end
end
