require"ISUI/ISInventoryPane"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/ConsoleStatus"

local c={r=0.6,g=0.8,b=0.5,a=0.6}
local d={r=0.0,g=0.0,b=0.5,a=0.7}

local e=ISInventoryPane.drawItemDetails

function ISInventoryPane:drawItemDetails(item,y,xoff,yoff,red)
if not item or not SpiffBoy.Handheld.isConsole(item)then
return e(self,item,y,xoff,yoff,red)
end
local f=self.headerHgt+y*self.itemHgt+yoff
local a=getCore():getGoodHighlitedColor()
local g={r=a:getR(),g=a:getG(),b=a:getB(),a=1}
local b=c
if red then
b=d
end
self:drawTextAndProgressBar(getText("IGUI_invpanel_Remaining")..":",SpiffBoy.ConsoleStatus.charge(item),xoff,f,b,g)
end
