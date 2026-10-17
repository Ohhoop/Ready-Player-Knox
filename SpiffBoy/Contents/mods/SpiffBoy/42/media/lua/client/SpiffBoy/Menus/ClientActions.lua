require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/SaveData"
require"SpiffBoy/Handheld/Handheld"

SpiffBoyClientActions={}

function SpiffBoyClientActions.saveHandheld(e,b,a,c,d)
if isClient()then
local f=a and SpiffBoy.SaveData.clean(a)or nil
sendClientCommand(e,SpiffBoy.COMMAND_MODULE,SpiffBoy.COMMAND_SAVE_HANDHELD,{itemId=b:getID(),battery=c,volume=d,save=f})
return
end
SpiffBoy.Handheld.applySaved(b,a,c,d)
end
