require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Core/SaveData"

SpiffBoy.Handheld=SpiffBoy.Handheld or{}
local a=SpiffBoy.Handheld

a.BATTERY_PER_MINUTE=0.01
a.ACTION_TIME=60
a.CABLE_REACH=2
a.CARTRIDGE_INSIDE_WEIGHT=0.03
a.CABLE_INSIDE_WEIGHT=0.03
a.HEADPHONES_INSIDE_SHARE=0.7
a.HEADPHONES={
["Base.Headphones"]={worn="SpiffBoy.HeadphonesWorn",kind="headphones"},
["Base.Earbuds"]={worn="SpiffBoy.EarbudsWorn",kind="earbuds"},
}

local d=SpiffBoy.MOD_DATA_KEY
local k=0.0001

function a.data(c)
local b=c:getModData()
if b[d]==nil then
b[d]={}
end
return b[d]
end

local function c(f,g,h)
local b=f:getModData()[d]
local e=b and b[g]
if type(e)~=h then
return nil
end
return e
end

function a.isConsole(b)
return b~=nil and b:getFullType()==SpiffBoy.CONSOLE_ITEM
end

function a.isBattery(b)
return b~=nil and b:getFullType()==SpiffBoy.BATTERY_ITEM
end

function a.getCartridge(e)
local b=c(e,"cartridge","table")
if not b or type(b.type)~="string"then
return nil
end
return b
end

function a.setCartridge(b,e)
a.data(b).cartridge=e
a.refreshWeight(b)
end

function a.getBattery(b)
return c(b,"battery","number")
end

function a.setBattery(b,e)
a.data(b).battery=e
end

function a.isHeadphones(b)
return b~=nil and a.HEADPHONES[b:getFullType()]~=nil
end

function a.getHeadphones(e)
local b=c(e,"headphones","string")
if not b or not a.HEADPHONES[b]then
return nil
end
return b
end

function a.getHeadphonesName(b)
return c(b,"headphonesName","string")
end

function a.setHeadphones(b,e,g)
local f=a.data(b)
f.headphones=e
f.headphonesName=e and g or nil
a.refreshWeight(b)
end

function a.isCable(b)
return b~=nil and b:getFullType()==SpiffBoy.CABLE_ITEM
end

function a.hasCable(b)
return c(b,"cable","boolean")==true
end

function a.setCable(b,f)
local e=a.data(b)
if f then
e.cable=true
else
e.cable=nil
end
a.refreshWeight(b)
end

local function g(b)
return getScriptManager():FindItem(b):getActualWeight()
end

function a.weightOf(e)
local b=g(SpiffBoy.CONSOLE_ITEM)
if a.getCartridge(e)then
b=b+a.CARTRIDGE_INSIDE_WEIGHT
end
if a.hasCable(e)then
b=b+a.CABLE_INSIDE_WEIGHT
end
local f=a.getHeadphones(e)
if f then
b=b+g(f)*a.HEADPHONES_INSIDE_SHARE
end
return b
end

function a.refreshWeight(b)
local e=a.weightOf(b)
if b:isCustomWeight()and math.abs(b:getActualWeight()-e)<k then
return
end
b:setActualWeight(e)
b:setCustomWeight(true)
end

function a.newItem(b)
local e=instanceItem(b)
if not e then
SpiffBoy.log("cannot recreate "..tostring(b))
end
return e
end

function a.cartridgeItem(e)
local b=a.newItem(e.type)
if b then
a.setCartridgeSave(b,a.recordSave(e))
end
return b
end

function a.batteryItem(e)
local b=a.newItem(SpiffBoy.BATTERY_ITEM)
if b then
b:setUsedDelta(SpiffBoy.clamp(e,0,1))
end
return b
end

function a.headphonesItem(f,e)
local b=a.newItem(f)
if b and e then
b:setName(e)
b:setCustomName(true)
end
return b
end

local function f(b,e)
if e then
b[#b+1]=e
end
end

function a.partsInside(b)
local e={}
local h=a.getCartridge(b)
if h then
f(e,a.cartridgeItem(h))
end
local i=a.getBattery(b)
if i~=nil then
f(e,a.batteryItem(i))
end
local j=a.getHeadphones(b)
if j then
f(e,a.headphonesItem(j,a.getHeadphonesName(b)))
end
if a.hasCable(b)then
f(e,a.newItem(SpiffBoy.CABLE_ITEM))
end
return e
end

function a.consoleWithCable(h)
local b=h:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for i=0,b:size()-1 do
local e=b:get(i)
if a.hasCable(e)then
return e
end
end
return nil
end

function a.consoleWithFreePort(h)
local b=h:getInventory():getAllTypeRecurse(SpiffBoy.CONSOLE_ITEM)
for i=0,b:size()-1 do
local e=b:get(i)
if not a.hasCable(e)then
return e
end
end
return nil
end

function a.withinCableReach(b,e)
if math.floor(b:getZ())~=math.floor(e:getZ())then
return false
end
local h=math.abs(b:getX()-e:getX())
local i=math.abs(b:getY()-e:getY())
return math.max(h,i)<=a.CABLE_REACH
end

function a.characterName(b)
if isClient()or isServer()then
return b:getUsername()
end
return b:getDescriptor():getForename()
end

function a.getVolume(b)
return c(b,"volume","number")
end

function a.setVolume(b,e)
a.data(b).volume=e
end

function a.applySaved(b,e,h,i)
if i~=nil then
a.setVolume(b,SpiffBoy.clamp(i,0,1))
end
if e~=nil then
local j=a.getCartridge(b)
if j then
a.setRecordSave(j,e)
end
end
if h~=nil and a.getBattery(b)~=nil then
a.setBattery(b,SpiffBoy.clamp(h,0,1))
end
end

function a.cartridgeSave(b)
return SpiffBoy.SaveData.fromStore(b:getModData()[d])
end

function a.setCartridgeSave(b,e)
SpiffBoy.SaveData.toStore(a.data(b),e)
end

function a.recordSave(b)
return SpiffBoy.SaveData.fromStore(b)
end

function a.setRecordSave(b,e)
SpiffBoy.SaveData.toStore(b,e)
end

function a.newRecord(b,e)
return{type=b,save=e}
end

function a.recordFromCartridge(b)
return a.newRecord(b:getFullType(),a.cartridgeSave(b))
end
