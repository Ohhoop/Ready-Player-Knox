require"ISUI/ISInventoryPage"
require"SpiffBoy/Core/Core"

SpiffBoy.PlayerGuard=SpiffBoy.PlayerGuard or{}
local d=SpiffBoy.PlayerGuard

local a={}

local g=ISInventoryPage.onMouseMove

function ISInventoryPage:onMouseMove(dx,dy)
if self.isCollapsed and a[self.player]then
self.mouseOver=true
return
end
g(self,dx,dy)
end

local function e(playerNum)
return{getPlayerInventory(playerNum),getPlayerLoot(playerNum)}
end

local function h(playerNum,guard)
guard.pinned={}
for c,b in ipairs(e(playerNum))do
if b then
guard.pinned[c]=b.pin==true
b:collapse()
b:collapseNow()
end
end
end

local function i(playerNum,guard)
for c,b in ipairs(e(playerNum))do
if b and guard.pinned and guard.pinned[c]then
b:setPinned()
end
end
end

function d.hold(playerObj,window)
local b=playerObj:getPlayerNum()
if a[b]then
return
end
local c={
playerObj=playerObj,
window=window,
shove=playerObj:isAuthorizeShoveStomp(),
melee=playerObj:isAuthorizeMeleeAction(),
}
playerObj:setBlockMovement(true)
playerObj:setAuthorizeShoveStomp(false)
playerObj:setAuthorizeMeleeAction(false)
h(b,c)
local f=getJoypadData(b)
if f then
c.previousFocus=f.focus
setJoypadFocus(b,window)
end
a[b]=c
end

function d.release(playerObj)
local c=playerObj:getPlayerNum()
local b=a[c]
if not b then
return
end
a[c]=nil
playerObj:setBlockMovement(false)
playerObj:setAuthorizeShoveStomp(b.shove)
playerObj:setAuthorizeMeleeAction(b.melee)
i(c,b)
local f=getJoypadData(c)
if f and f.focus==b.window then
setJoypadFocus(c,b.previousFocus)
end
end

function d.hitReason(playerObj)
if playerObj:isDead()then
return"dead"
end
if playerObj:hasHitReaction()or playerObj:isStaggerBack()then
return"hit"
end
return nil
end

local function c()
for f,b in pairs(a)do
b.playerObj:setBlockMovement(false)
b.playerObj:setAuthorizeShoveStomp(true)
b.playerObj:setAuthorizeMeleeAction(true)
end
a={}
end

Events.OnGameStart.Add(c)
Events.OnCreatePlayer.Add(c)
