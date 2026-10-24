require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Core/SaveData"
require"SpiffBoy/Handheld/Handheld"

SpiffBoyClientActions={}

function SpiffBoyClientActions.saveHandheld(playerObj,console,save,battery,volume)
if isClient()then
local a=save and SpiffBoy.SaveData.clean(save)or nil
sendClientCommand(playerObj,SpiffBoy.COMMAND_MODULE,SpiffBoy.COMMAND_SAVE_HANDHELD,{itemId=console:getID(),battery=battery,volume=volume,save=a})
return
end
SpiffBoy.Handheld.applySaved(console,save,battery,volume)
end
