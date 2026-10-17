require"ISUI/ISInventoryPage"
require"SpiffBoy/Core/Core"

SpiffBoy.PlayerGuard=SpiffBoy.PlayerGuard or{}
local e=SpiffBoy.PlayerGuard

local a={}

local i=ISInventoryPage.onMouseMove

function ISInventoryPage:onMouseMove(b,c)
if self.isCollapsed and a[self.player]then
self.mouseOver=true
return
end
i(self,b,c)
end

local function f(b)
return{getPlayerInventory(b),getPlayerLoot(b)}
end

local function j(d,c)
c.pinned={}
for g,b in ipairs(f(d))do
if b then
c.pinned[g]=b.pin==true
b:collapse()
b:collapseNow()
end
end
end

local function k(d,b)
for g,c in ipairs(f(d))do
if c and b.pinned and b.pinned[g]then
c:setPinned()
end
end
end

function e.hold(b,g)
local c=b:getPlayerNum()
if a[c]then
return
end
local d={
playerObj=b,
window=g,
shove=b:isAuthorizeShoveStomp(),
melee=b:isAuthorizeMeleeAction(),
}
b:setBlockMovement(true)
b:setAuthorizeShoveStomp(false)
b:setAuthorizeMeleeAction(false)
j(c,d)
local h=getJoypadData(c)
if h then
d.previousFocus=h.focus
setJoypadFocus(c,g)
end
a[c]=d
end

function e.release(d)
local c=d:getPlayerNum()
local b=a[c]
if not b then
return
end
a[c]=nil
d:setBlockMovement(false)
d:setAuthorizeShoveStomp(b.shove)
d:setAuthorizeMeleeAction(b.melee)
k(c,b)
local g=getJoypadData(c)
if g and g.focus==b.window then
setJoypadFocus(c,b.previousFocus)
end
end

function e.hitReason(b)
if b:isDead()then
return"dead"
end
if b:hasHitReaction()or b:isStaggerBack()then
return"hit"
end
return nil
end

local function c()
for d,b in pairs(a)do
b.playerObj:setBlockMovement(false)
b.playerObj:setAuthorizeShoveStomp(true)
b.playerObj:setAuthorizeMeleeAction(true)
end
a={}
end

Events.OnGameStart.Add(c)
Events.OnCreatePlayer.Add(c)
