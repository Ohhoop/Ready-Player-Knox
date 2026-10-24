require"TimedActions/ISBaseTimedAction"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Link/Links"

SpiffBoyHandheldAction=ISBaseTimedAction:derive("SpiffBoyHandheldAction")

local a=SpiffBoy.Handheld

function SpiffBoyHandheldAction:isValid()
local b=self.character:getInventory()
if isClient()then
if not b:containsID(self.console:getID())then
return false
end
return self.item==nil or b:containsID(self.item:getID())
end
if not b:contains(self.console)then
return false
end
return self.item==nil or b:contains(self.item)
end

function SpiffBoyHandheldAction:start()
if isClient()then
local b=self.character:getInventory()
self.console=b:getItemById(self.console:getID())
if self.item then
self.item=b:getItemById(self.item:getID())
end
end
self:setActionAnim("Craft")
end

function SpiffBoyHandheldAction:update()
self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function SpiffBoyHandheldAction:takeItem(item)
local b=self.character:getInventory()
b:Remove(item)
sendRemoveItemFromContainer(b,item)
end

function SpiffBoyHandheldAction:giveItem(item)
local b=self.character:getInventory()
b:AddItem(item)
sendAddItemToContainer(b,item)
end

function SpiffBoyHandheldAction:syncConsole()
syncItemModData(self.character,self.console)
end

function SpiffBoyHandheldAction:getDuration()
if self.character:isTimedActionInstant()then
return 1
end
return a.ACTION_TIME
end

function SpiffBoyHandheldAction:new(character,console,item)
local b=ISBaseTimedAction.new(self,character)
b.console=console
b.item=item
b.maxTime=b:getDuration()
return b
end

SpiffBoyInsertCartridgeAction=SpiffBoyHandheldAction:derive("SpiffBoyInsertCartridgeAction")

function SpiffBoyInsertCartridgeAction:complete()
if a.getCartridge(self.console)then
return true
end
a.setCartridge(self.console,a.recordFromCartridge(self.item))
self:syncConsole()
self:takeItem(self.item)
return true
end

SpiffBoyRemoveCartridgeAction=SpiffBoyHandheldAction:derive("SpiffBoyRemoveCartridgeAction")

function SpiffBoyRemoveCartridgeAction:complete()
local b=a.getCartridge(self.console)
if not b then
return true
end
local c=a.cartridgeItem(b)
if not c then
return true
end
self:giveItem(c)
a.setCartridge(self.console,nil)
self:syncConsole()
return true
end

SpiffBoyInsertBatteryAction=SpiffBoyHandheldAction:derive("SpiffBoyInsertBatteryAction")

function SpiffBoyInsertBatteryAction:complete()
if a.getBattery(self.console)~=nil then
return true
end
a.setBattery(self.console,self.item:getCurrentUsesFloat())
self:syncConsole()
self:takeItem(self.item)
return true
end

SpiffBoyRemoveBatteryAction=SpiffBoyHandheldAction:derive("SpiffBoyRemoveBatteryAction")

function SpiffBoyRemoveBatteryAction:complete()
local b=a.getBattery(self.console)
if b==nil then
return true
end
local c=a.batteryItem(b)
if not c then
return true
end
self:giveItem(c)
a.setBattery(self.console,nil)
self:syncConsole()
return true
end

SpiffBoyPlugHeadphonesAction=SpiffBoyHandheldAction:derive("SpiffBoyPlugHeadphonesAction")

function SpiffBoyPlugHeadphonesAction:complete()
if a.getHeadphones(self.console)or not a.isHeadphones(self.item)then
return true
end
local b=nil
if self.item:isCustomName()then
b=self.item:getName()
end
a.setHeadphones(self.console,self.item:getFullType(),b)
self:syncConsole()
self:takeItem(self.item)
return true
end

SpiffBoyUnplugHeadphonesAction=SpiffBoyHandheldAction:derive("SpiffBoyUnplugHeadphonesAction")

function SpiffBoyUnplugHeadphonesAction:complete()
local b=a.getHeadphones(self.console)
if not b then
return true
end
local c=a.headphonesItem(b,a.getHeadphonesName(self.console))
if not c then
return true
end
self:giveItem(c)
a.setHeadphones(self.console,nil)
self:syncConsole()
return true
end

SpiffBoyPlugCableAction=SpiffBoyHandheldAction:derive("SpiffBoyPlugCableAction")

function SpiffBoyPlugCableAction:complete()
if a.hasCable(self.console)or not a.isCable(self.item)then
return true
end
a.setCable(self.console,true)
self:syncConsole()
self:takeItem(self.item)
return true
end

SpiffBoyUnplugCableAction=SpiffBoyHandheldAction:derive("SpiffBoyUnplugCableAction")

function SpiffBoyUnplugCableAction:complete()
if not a.hasCable(self.console)then
return true
end
local b=a.newItem(SpiffBoy.CABLE_ITEM)
if not b then
return true
end
SpiffBoy.Links.disconnect(self.character,self.console)
self:giveItem(b)
a.setCable(self.console,false)
self:syncConsole()
return true
end

SpiffBoyConnectCableAction=SpiffBoyHandheldAction:derive("SpiffBoyConnectCableAction")

function SpiffBoyConnectCableAction:new(character,console,peerId,peerNum)
local b=SpiffBoyHandheldAction.new(self,character,console,nil)
b.peerId=peerId
b.peerNum=peerNum
return b
end

function SpiffBoyConnectCableAction:complete()
SpiffBoy.Links.connect(self.character,self.console,self.peerId,self.peerNum)
return true
end

SpiffBoyDisconnectCableAction=SpiffBoyHandheldAction:derive("SpiffBoyDisconnectCableAction")

function SpiffBoyDisconnectCableAction:complete()
SpiffBoy.Links.disconnect(self.character,self.console)
return true
end
