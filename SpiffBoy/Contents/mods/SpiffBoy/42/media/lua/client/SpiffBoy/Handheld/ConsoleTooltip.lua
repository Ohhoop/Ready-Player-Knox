require"ISUI/ISToolTipInv"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Handheld/ConsoleStatus"

local r=80
local s=80
local a={r=1,g=1,b=0.8}
local t="0"

local u=ISToolTipInv.render

local function v(tooltip,charge)
local b=tooltip:beginLayout()
b:setMinLabelWidth(r)
b:setMinValueWidth(s)
local d=b:addItem()
d:setLabel(getText("IGUI_invpanel_Remaining")..": ",a.r,a.g,a.b,1)
local c=ColorInfo.new()
getCore():getBadHighlitedColor():interp(getCore():getGoodHighlitedColor(),charge,c)
d:setProgress(charge,c:getR(),c:getG(),c:getB(),1)
return b
end

local function w(console)
local b=SpiffBoy.Handheld
local c=b.getHeadphones(console)
if not c then
return nil
end
return b.getHeadphonesName(console)or getItemNameFromFullType(c)
end

local function x(tooltip,charge,headphones,cable)
local b=v(tooltip,charge)
if headphones then
local c=b:addItem()
c:setLabel(getText("UI_SpiffBoy_HeadphonesPlugged",headphones),a.r,a.g,a.b,1)
end
if cable then
local c=b:addItem()
c:setLabel(getText("UI_SpiffBoy_CablePlugged"),a.r,a.g,a.b,1)
end
return b
end

local function i(tooltip,charge,headphones,cable,left,top)
local b=x(tooltip,charge,headphones,cable)
local c=b:render(left,top,tooltip)
tooltip:endLayout(b)
return c
end

function ISToolTipInv:render()
u(self)
local d=self.item
if not d or not SpiffBoy.Handheld.isConsole(d)then
return
end
if ISContextMenu.instance and ISContextMenu.instance.visibleCheck then
return
end
local b=self.tooltip
local j=getTextManager():MeasureStringX(b:getFont(),t)
local k=j
local l=math.floor(j/2)
local m=b:getWidth()
local e=b:getHeight()
local n=e-l
local o=SpiffBoy.ConsoleStatus.charge(d)
local p=w(d)
local q=SpiffBoy.Handheld.hasCable(d)
b:setMeasureOnly(true)
local y=i(b,o,p,q,k,n)
b:setMeasureOnly(false)
local f=b:getWidth()
local g=y+l
b:setHeight(g)
self:setWidth(f)
self:setHeight(g)
local c=self.backgroundColor
local h=self.borderColor
self:drawRect(m-1,0,f-m+1,e,c.a,c.r,c.g,c.b)
self:drawRect(0,e-1,f,g-e+1,c.a,c.r,c.g,c.b)
self:drawRectBorder(0,0,f,g,h.a,h.r,h.g,h.b)
i(b,o,p,q,k,n)
end
