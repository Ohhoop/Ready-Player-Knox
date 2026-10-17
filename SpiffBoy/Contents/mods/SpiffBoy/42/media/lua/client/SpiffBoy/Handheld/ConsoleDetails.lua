require"ISUI/ISInventoryPane"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/ConsoleStatus"

local h={r=0.6,g=0.8,b=0.5,a=0.6}
local i={r=0.0,g=0.0,b=0.5,a=0.7}

local j=ISInventoryPane.drawItemDetails

function ISInventoryPane:drawItemDetails(a,c,d,e,f)
if not a or not SpiffBoy.Handheld.isConsole(a)then
return j(self,a,c,d,e,f)
end
local k=self.headerHgt+c*self.itemHgt+e
local b=getCore():getGoodHighlitedColor()
local l={r=b:getR(),g=b:getG(),b=b:getB(),a=1}
local g=h
if f then
g=i
end
self:drawTextAndProgressBar(getText("IGUI_invpanel_Remaining")..":",SpiffBoy.ConsoleStatus.charge(a),d,k,g,l)
end
