require"ISUI/ISPanel"
require"ISUI/ISButton"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Dev/DevItems"

if not SpiffBoy.isDevBuild()then
return
end

local c=SpiffBoy.DevItems

SpiffBoyDevMenu=ISPanel:derive("SpiffBoyDevMenu")

local h="SpiffBoyDevMenu"
local f="SB DEV"
local l="No room: "

local m=240
local n=Keyboard.KEY_F9

local a=nil

local function i(b,g,d,e)
if not b then
return
end
if d>0 then
HaloTextHelper.addText(b,"+"..tostring(d).." "..g,"",HaloTextHelper.getColorGreen())
end
if e>0 then
HaloTextHelper.addText(b,l..tostring(e),"",HaloTextHelper.getColorRed())
end
end

local function o(d)
local b=getPlayer()
if not b or b:isDead()then
return
end
if isClient()then
sendClientCommand(b,SpiffBoy.COMMAND_MODULE,c.COMMAND_SPAWN,{device=d})
return
end
local e,g=c.give(b,d)
i(b,c.device(d).title,e,g)
end

local function p(j)
local g=getTextManager()
local e=g:getFontHeight(UIFont.Small)
local b=math.ceil(e*0.3)
local d=g:MeasureStringX(UIFont.Small,f)
for q,k in ipairs(j)do
d=math.max(d,g:MeasureStringX(UIFont.Small,k.title)+b*4)
end
d=math.max(d,m)
local k=e+b*2
return{
font=UIFont.Small,
fontHeight=e,
padding=b,
buttonHeight=k,
panelWidth=d+b*2,
panelHeight=b*2+e+#j*(k+b)+b*2,
}
end

function SpiffBoyDevMenu:new(d,e,g,j,k,q)
local b=ISPanel:new(d,e,g,j)
setmetatable(b,self)
self.__index=self
b.backgroundColor={r=0,g=0,b=0,a=0.7}
b.borderColor={r=0.3,g=0.6,b=0.8,a=0.6}
b.moveWithMouse=true
b.devices=k
b.layout=q
return b
end

function SpiffBoyDevMenu:createChildren()
ISPanel.createChildren(self)
local b=self.layout
local e=b.padding*2+b.fontHeight
local j=self.width-b.padding*2
for q,g in ipairs(self.devices)do
local k=g.id
local d=ISButton:new(b.padding,e,j,b.buttonHeight,g.title,self,function()
o(k)
end)
d:initialise()
d:instantiate()
d.backgroundColor={r=0.05,g=0.15,b=0.25,a=0.9}
d.backgroundColorMouseOver={r=0.1,g=0.3,b=0.5,a=0.95}
d.borderColor={r=0.35,g=0.6,b=0.8,a=0.5}
self:addChild(d)
e=e+b.buttonHeight+b.padding
end
end

function SpiffBoyDevMenu:prerender()
ISPanel.prerender(self)
local b=SpiffBoyHandheldWindow and SpiffBoyHandheldWindow.anyShown()
if b and self.raisedFor~=b then
self:addToUIManager()
end
self.raisedFor=b
end

function SpiffBoyDevMenu:render()
ISPanel.render(self)
local b=self.layout
local d=getTextManager():MeasureStringX(b.font,f)
self:drawText(f,(self.width-d)/2,b.padding,0.6,0.8,0.95,1,b.font)
end

function SpiffBoyDevMenu:RestoreLayout(j,b)
local d=tonumber(b and b.x)
local e=tonumber(b and b.y)
if not d or not e then
return
end
local g=getCore()
self:setX(math.max(0,math.min(d,g:getScreenWidth()-self.width)))
self:setY(math.max(0,math.min(e,g:getScreenHeight()-self.height)))
end

function SpiffBoyDevMenu:SaveLayout(d,b)
b.x=self:getX()
b.y=self:getY()
end

local function d()
if a then
return
end
local e=c.DEVICES
local b=p(e)
local g=getCore()
local j=g:getScreenWidth()-b.panelWidth-b.padding*4
local k=math.floor(g:getScreenHeight()*0.45)
a=SpiffBoyDevMenu:new(j,k,b.panelWidth,b.panelHeight,e,b)
a:initialise()
a:instantiate()
a:addToUIManager()
a:setAlwaysOnTop(true)
a:setVisible(false)
SpiffBoyDevMenuPrevious=a
ISLayoutManager.RegisterWindow(h,SpiffBoyDevMenu,a)
end

local function g()
d()
if a:isVisible()then
a:setVisible(false)
return
end
a:setVisible(true)
a:bringToTop()
end

local function j()
if a then
a:setVisible(false)
end
end

local function k(b)
if b==n and not isGamePaused()and getPlayer()then
g()
end
end

local function q()
if not a then
return
end
ISLayoutManager.windows[h]=nil
a:setVisible(false)
a:removeFromUIManager()
a=nil
SpiffBoyDevMenuPrevious=nil
end

local function r(b)
if type(b)~="table"then
return
end
local e=c.device(b.device)
if not e then
return
end
i(getPlayer(),e.title,tonumber(b.added)or 0,tonumber(b.skipped)or 0)
end

Events.OnGameStart.Add(d)
Events.OnCreatePlayer.Add(d)
Events.OnPlayerDeath.Add(j)
Events.OnMainMenuEnter.Add(q)
Events.OnKeyStartPressed.Add(k)
SpiffBoy.Commands.fromServer(c.COMMAND_SPAWNED,r)

if SpiffBoyDevMenuPrevious then
SpiffBoyDevMenuPrevious:setVisible(false)
SpiffBoyDevMenuPrevious:removeFromUIManager()
SpiffBoyDevMenuPrevious=nil
end
if getPlayer()then
d()
end
