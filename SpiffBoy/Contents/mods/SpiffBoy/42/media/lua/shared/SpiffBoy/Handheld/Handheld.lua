require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/SaveData"

SpiffBoy.Handheld=SpiffBoy.Handheld or{}
local c=SpiffBoy.Handheld

c.BATTERY_PER_MINUTE=0.01
c.ACTION_TIME=60
c.CABLE_REACH=2
c.CARTRIDGE_INSIDE_WEIGHT=0.03
c.CABLE_INSIDE_WEIGHT=0.03
c.HEADPHONES_INSIDE_SHARE=0.7
c.HEADPHONES={
["Base.Headphones"]={worn="SpiffBoy.HeadphonesWorn",kind="headphones"},
["Base.Earbuds"]={worn="SpiffBoy.EarbudsWorn",kind="earbuds"},
}

local e=SpiffBoy.MOD_DATA_KEY
local j=0.0001

function c.data(item)
local a=item:getModData()
if a[e]==nil then
a[e]={}
end
return a[e]
end

local function d(console,field,kind)
local a=console:getModData()[e]
local b=a and a[field]
if type(b)~=kind then
return nil
end
return b
end

function c.isConsole(item)
return item~=nil and item:getFullType()==SpiffBoy.CONSOLE_ITEM
end

function c.isBattery(item)
return item~=nil and item:getFullType()==SpiffBoy.BATTERY_ITEM
end

function c.getCartridge(console)
local a=d(console,"cartridge","table")
if not a or type(a.type)~="string"then
return nil
end
return a
end

function c.setCartridge(console,record)
c.data(console).cartridge=record
c.refreshWeight(console)
end

function c.getBattery(console)
return d(console,"battery","number")
end

function c.setBattery(console,value)
c.data(console).battery=value
end

function c.isHeadphones(item)
return item~=nil and c.HEADPHONES[item:getFullType()]~=nil
end

function c.getHeadphones(console)
local a=d(console,"headphones","string")
if not a or not c.HEADPHONES[a]then
return nil
end
return a
end

function c.getHeadphonesName(console)
return d(console,"headphonesName","string")
end

function c.setHeadphones(console,itemType,customName)
local a=c.data(console)
a.headphones=itemType
a.headphonesName=itemType and customName or nil
c.refreshWeight(console)
end

function c.isCable(item)
return item~=nil and item:getFullType()==SpiffBoy.CABLE_ITEM
end

function c.hasCable(console)
return d(console,"cable","boolean")==true
end

function c.setCable(console,plugged)
local a=c.data(console)
if plugged then
a.cable=true
else
a.cable=nil
end
c.refreshWeight(console)
end

local function g(fullType)
return getScriptManager():FindItem(fullType):getActualWeight()
end

function c.weightOf(console)
local a=g(SpiffBoy.CONSOLE_ITEM)
if c.getCartridge(console)then
a=a+c.CARTRIDGE_INSIDE_WEIGHT
end
if c.hasCable(console)then
a=a+c.CABLE_INSIDE_WEIGHT
end
local b=c.getHeadphones(console)
if b then
a=a+g(b)*c.HEADPHONES_INSIDE_SHARE
end
return a
end

function c.refreshWeight(console)
local a=c.weightOf(console)
if console:isCustomWeight()and math.abs(console:getActualWeight()-a)<j then
return
end
console:setActualWeight(a)
console:setCustomWeight(true)
end

function c.newItem(itemType)
local a=instanceItem(itemType)
if not a then
SpiffBoy.log("cannot recreate "..tostring(itemType))
end
return a
end

function c.cartridgeItem(record)
if not getScriptManager():FindItem(record.type)then
SpiffBoy.log("cannot recreate the cartridge "..record.type..": no loaded mod defines that item")
return nil
end
local a=c.newItem(record.type)
if a then
c.setCartridgeSave(a,c.recordSave(record))
end
return a
end

function c.batteryItem(charge)
local a=c.newItem(SpiffBoy.BATTERY_ITEM)
if a then
a:setUsedDelta(SpiffBoy.clamp(charge,0,1))
end
return a
end

function c.headphonesItem(itemType,customName)
local a=c.newItem(itemType)
if a and customName then
a:setName(customName)
a:setCustomName(true)
end
return a
end

local function f(parts,item)
if item then
parts[#parts+1]=item
end
end

function c.partsInside(console)
local a={}
local b=c.getCartridge(console)
if b then
f(a,c.cartridgeItem(b))
end
local h=c.getBattery(console)
if h~=nil then
f(a,c.batteryItem(h))
end
local i=c.getHeadphones(console)
if i then
f(a,c.headphonesItem(i,c.getHeadphonesName(console)))
end
if c.hasCable(console)then
f(a,c.newItem(SpiffBoy.CABLE_ITEM))
end
return a
end

function c.consoleWithCable(character)
local a=character:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for h=0,a:size()-1 do
local b=a:get(h)
if c.hasCable(b)then
return b
end
end
return nil
end

function c.consoleWithFreePort(character)
local a=character:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for h=0,a:size()-1 do
local b=a:get(h)
if not c.hasCable(b)then
return b
end
end
return nil
end

function c.withinCableReach(a,b)
if math.floor(a:getZ())~=math.floor(b:getZ())then
return false
end
local h=math.abs(a:getX()-b:getX())
local i=math.abs(a:getY()-b:getY())
return math.max(h,i)<=c.CABLE_REACH
end

function c.characterName(character)
if isClient()or isServer()then
return character:getUsername()
end
return character:getDescriptor():getForename()
end

function c.getVolume(console)
return d(console,"volume","number")
end

function c.setVolume(console,value)
c.data(console).volume=value
end

function c.applySaved(console,save,battery,volume)
if volume~=nil then
c.setVolume(console,SpiffBoy.clamp(volume,0,1))
end
if save~=nil then
local a=c.getCartridge(console)
if a then
c.setRecordSave(a,save)
end
end
if battery~=nil and c.getBattery(console)~=nil then
c.setBattery(console,SpiffBoy.clamp(battery,0,1))
end
end

function c.cartridgeSave(cartridge)
return SpiffBoy.SaveData.fromStore(cartridge:getModData()[e])
end

function c.setCartridgeSave(cartridge,save)
SpiffBoy.SaveData.toStore(c.data(cartridge),save)
end

function c.recordSave(record)
return SpiffBoy.SaveData.fromStore(record)
end

function c.setRecordSave(record,save)
SpiffBoy.SaveData.toStore(record,save)
end

function c.newRecord(itemType,save)
return{type=itemType,save=save}
end

function c.recordFromCartridge(cartridge)
return c.newRecord(cartridge:getFullType(),c.cartridgeSave(cartridge))
end
