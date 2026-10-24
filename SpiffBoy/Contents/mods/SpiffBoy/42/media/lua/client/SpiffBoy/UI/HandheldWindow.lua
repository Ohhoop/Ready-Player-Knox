require"ISUI/ISPanel"
require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Sandbox"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Handheld/Handheld"
require"SpiffBoy/Core/Runtime"
require"SpiffBoy/Core/Input"
require"SpiffBoy/Core/Audio"
require"SpiffBoy/Core/Chip"
require"SpiffBoy/Core/Speaker"
require"SpiffBoy/Core/Sequencer"
require"SpiffBoy/Core/Tunes"
require"SpiffBoy/Core/Textures"
require"SpiffBoy/Core/Mood"
require"SpiffBoy/Core/PlayerGuard"
require"SpiffBoy/Core/DevOverlay"
require"SpiffBoy/Menus/ClientActions"
require"SpiffBoy/Network/ChipLink"
require"SpiffBoy/Link/LinkState"
require"SpiffBoy/Link/LinkChannel"
require"SpiffBoy/Core/CameraShift"
require"SpiffBoy/Core/ConsolePosition"
require"SpiffBoy/Handheld/PlayHandheldAction"
require"SpiffBoy/Handheld/ConsoleStatus"
require"SpiffBoy/Handheld/BootScreen"
require"SpiffBoy/Menus/CartridgeMenu"
require"SpiffBoy/Menus/HeadphonesMenu"
require"SpiffBoy/Menus/LinkMenu"
require"SpiffBoy/Handheld/WornHeadphonesClient"
require"SpiffBoy/UI/ZoomLock"
require"SpiffBoy/UI/JackGrip"
require"SpiffBoy/UI/CartridgeGrip"
require"SpiffBoy/UI/LinkGrip"

SpiffBoyHandheldWindow=ISPanel:derive("SpiffBoyHandheldWindow")
SpiffBoyHandheldWindow.instances={}

local T="media/ui/SpiffBoy/handheld/"
local o=384
local p=252
local at=102
local au=60
local av=0.5
local aw=0.62
local U=24
local g={x=47.5,y=125.5,size=72}
local t=3
local D={x=336,y=157}
local E={x=336,y=95}
local v=40
local z=40
local n={x=192,y=228,w=24,h=8}
local V=4
local W=0
local q={x=30,y=30,size=8}
local F=0
local X=1
local Y=2
local e={x=-4,w=4,h=20,onY=41,offY=47,hitMargin=4}
local ax="SpiffBoy_PowerSwitch"
local A=1/4
local G=1
local d={x=o,w=4,h=22,y=43,hitMargin=4}
local Z=e.x-e.hitMargin
local ay=d.x+d.w+d.hitMargin
local B=10
local az=7
local aA="SpiffBoy_VolumeWheel"
local aB=2
local aC=0.15
local k=SpiffBoy.Cartridges.SHADES[4]
local r=SpiffBoy.Cartridges.SHADES[1]
local aD={r=132/255,g=146/255,b=138/255}
local aE=500
local _=1000
local aa=-1
local aF=0
local aG=4
local s={baseRange=8,roomShare=0.4,roomFloor=3,outsideFloor=5,period=120,drain=1.25,loudness=100}
local ab=0.95
local aH=0.135
local aI=0.15
local aJ=0.08
local c={size=32,strength=0.6,curve=3,red=0.45,dim=0.5}
local aK=1
local aL=60
local aM=0.95
local aN=60
local aO=7
local aP=24
local aQ=120
local aR=40
local aS=6
local ac=#SpiffBoy.Cartridges.SHADES
local aT={width=150,padding=6}
local aU="spiffboy"
local H="shell"
local ad="power_switch"
local ae="led"
local af="led_glow_edge"
local ag="led_glow_red"
local ah="button_start"
local aV={x=128,y=0,w=128,h=8}
local b={x=130,y=-3,w=125,h=9,empty="slot_empty",full="slot_cartridge"}
local i={
x=322,
y=p,
zone={x=318,y=232,w=24},
empty={name="jack_empty",w=16,h=3,reach=3},
plugs={
headphones={name="jack_plugged",w=24,h=58,reach=38},
earbuds={name="jack_plugged_earbuds",w=24,h=52,reach=32},
},
slides={
headphones={name="plug_headphones",w=24,h=79,pin=25,dx=0},
earbuds={name="plug_earbuds",w=24,h=73,pin=25,dx=0},
},
}
local l={
x=56,
y=p,
zone={x=55,y=232,w=24},
empty={name="link_empty",w=22,h=3,reach=3},
plugged={name="link_plugged",w=22,h=56,reach=36},
slide={name="plug_link",w=24,h=60,pin=8,dx=-1},
}
local j={travel=40,snap=1,ease=1.5,start=0.10,reach=0.90,gone=0.90}
local aW="SpiffBoy_PartClick"
local aX="SpiffBoyPlugHeadphonesAction"
local aY="SpiffBoyUnplugHeadphonesAction"
local aZ="SpiffBoyPlugCableAction"
local a_="SpiffBoyUnplugCableAction"
local a0="SpiffBoyConnectCableAction"
local a1="SpiffBoyDisconnectCableAction"
local a2="SpiffBoyInsertCartridgeAction"
local ai="SpiffBoyRemoveCartridgeAction"
local a3=2
local a4=600
local f={
name="cartridge",
x=b.x+3,
w=119,
h=100,
mouth=6,
label={x=11,y=29,w=97,h=53,file="label.png",inset=3},
}
local a5={r=238/255,g=232/255,b=214/255}
local a6={r=52/255,g=44/255,b=60/255}
local I={r=96/255,g=62/255,b=116/255}
local J={}
local K={a={[0]="button_a_0",[1]="button_a_1"},b={[0]="button_b_0",[1]="button_b_1"}}
local L={}
local m={H,b.empty,b.full,f.name,ad,ae,af,ag,ah,i.empty.name,l.empty.name,l.plugged.name,l.slide.name}

for a=0,t*t-1 do
J[a]="dpad_"..a
m[#m+1]=J[a]
end
for a=0,B do
L[a]="volume_wheel_"..a
m[#m+1]=L[a]
end
for h,a in pairs(K)do
m[#m+1]=a[0]
m[#m+1]=a[1]
end
for u,a in pairs({i.plugs,i.slides})do
for w,h in pairs(a)do
m[#m+1]=h.name
end
end

local function a7(art)
local a={}
for u=1,#m do
local h=m[u]
a[h]=art(h)
end
return a
end

local function M(itemType)
return SpiffBoy.Handheld.HEADPHONES[itemType].kind
end

local function aj(shell,veil,texture,x,y,w,h)
shell:sprite(texture,x,y,w,h)
end

local function ak(shell,veil,texture,x,y,w,h)
shell:tinted(texture,x,y,w,h,0,0,0,veil)
end

local function N(shell,veil,texture,sx,sy,w,h,x,y)
shell:sheet(texture,sx,sy,w,h,x,y)
end

local function O(shell,veil,texture,sx,sy,w,h,x,y)
shell:tintedSheet(texture,sx,sy,w,h,x,y,0,0,0,veil)
end

local function a8(window,veil,itemType,x,y)
window:drawCartridgeLabel(itemType,x,y)
end

local function a9(window,veil,itemType,x,y)
local a=f.label
window.shell:rect(x+a.x,y+a.y,a.w,a.h,0,0,0,veil)
end

local function ba(input,action)
input:tap(action)
end

local function bb(held,action)
held[action]=true
end

local function al(x,y,centre)
local a=x-centre.x
local h=y-centre.y
local u=v/2
return a*a+h*h<=u*u
end

local function P(x,y,powered)
local a=e.offY
if powered then
a=e.onY
end
if x>=e.x-e.hitMargin and x<e.x+e.w+e.hitMargin and y>=a and y<a+e.h then
return"power"
end
if x>=d.x-d.hitMargin and x<d.x+d.w+d.hitMargin and y>=d.y and y<d.y+d.h then
return"volume"
end
local h=g.size/2
if math.abs(x-g.x)<=h and math.abs(y-g.y)<=h then
return"dpad"
end
if al(x,y,D)then
return"a"
end
if al(x,y,E)then
return"b"
end
if math.abs(x-n.x)<=n.w/2+V and math.abs(y-n.y)<=n.h/2+V then
return"start"
end
return nil
end

local function bc(x,y)
local a=g.size/t
local h=g.x-g.size/2
local u=g.y-g.size/2
local w=math.max(0,math.min(t-1,math.floor((x-h)/a)))
local C=math.max(0,math.min(t-1,math.floor((y-u)/a)))
return w-1,C-1
end

local function am(control,x,y,visitor,target)
if control~="dpad"then
visitor(target,control)
return
end
local a,h=bc(x,y)
if a<0 then
visitor(target,"left")
elseif a>0 then
visitor(target,"right")
end
if h<0 then
visitor(target,"up")
elseif h>0 then
visitor(target,"down")
end
end

local function bd(x,y,zone)
return x>=zone.x and x<zone.x+zone.w and y>=zone.y and y<zone.y+zone.h
end

local function C(x,y,port,art)
local a=port.zone
return x>=a.x and x<a.x+a.w and y>=a.y and y<port.y+art.reach
end

local function an(progress,travel)
if progress<j.start then
return nil
end
local a=math.min(1,(progress-j.start)/(j.reach-j.start))
return j.snap+(travel-j.snap)*(1-a)^j.ease
end

local function ao(progress,travel)
if progress>=j.gone then
return nil
end
return j.snap+(travel-j.snap)*(progress/j.gone)^j.ease
end

local function ap(progress,plugging,unplugging,slide)
if plugging then
local a=an(progress,j.travel)
if a then
return{art=slide,drop=a}
end
return nil
end
if unplugging then
local a=ao(progress,j.travel)
return{art=a and slide,drop=a or 0}
end
return nil
end

function SpiffBoyHandheldWindow:openShellMenu(fill)
local a=ISContextMenu.get(self.playerNum,getMouseX(),getMouseY())
a:removeFromUIManager()
a:addToUIManager()
a:setAlwaysOnTop(true)
fill(a,function(label,target,onSelect,...)
return a:addOption(label,target,onSelect,...)
end)
if a.numOptions<=1 then
a:setVisible(false)
end
self:traceMouse("menu opened with "..tostring(a.numOptions-1).." options, visible "..tostring(a:getIsVisible()).." at "..a:getX()..","..a:getY())
end

function SpiffBoyHandheldWindow:openJackMenu()
self:openShellMenu(function(context,add)
SpiffBoy.HeadphonesMenu.addOptions(context,self.playerObj,self.console,add)
end)
end

function SpiffBoyHandheldWindow:openLinkMenu()
self:openShellMenu(function(context,add)
SpiffBoy.LinkMenu.addOptions(context,self.playerObj,self.console,add)
end)
end

function SpiffBoyHandheldWindow:onRightMouseUp(x,y)
local a,h=self.shell:toLocal(x,y)
local u=bd(a,h,aV)
local w=C(a,h,i,self:jackArt())
local Q=C(a,h,l,self:linkArt())
self:traceMouse("right up at "..x..","..y.." shell "..a..","..h.." inside "..tostring(u).." jack "..tostring(w).." link "..tostring(Q).." paused "..tostring(isGamePaused()))
if isGamePaused()then
return self:isWantMouseEvents()
end
if w then
self:openJackMenu()
elseif Q then
self:openLinkMenu()
elseif u then
self:openCartridgeMenu()
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:openCartridgeMenu()
self:openShellMenu(function(context,add)
SpiffBoy.CartridgeMenu.addOptions(context,self.playerObj,self.console,add,true)
end)
end

function SpiffBoyHandheldWindow:traceMouse(message)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("handheld mouse: "..message)
end
end

function SpiffBoyHandheldWindow:onRightMouseDown(x,y)
self:traceMouse("right down at "..x..","..y.." on frame "..tostring(self:isOnFrame(x,y)))
if self:putAwayOutsideFrame(x,y)then
return false
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:onRightMouseUpOutside(x,y)
self:traceMouse("right up outside at "..x..","..y)
end

function SpiffBoyHandheldWindow:slotArt()
if self.seated then
return self.textures[b.full]
end
return self.textures[b.empty]
end

function SpiffBoyHandheldWindow:paintSlot(paintArea,paintPart,paintLabelOf,veil,rows,bottom)
local h=self.shell
local a=self.slotMotion
if not a then
paintArea(h,veil,self:slotArt(),0,0,b.w,rows,b.x,b.y)
return
end
paintArea(h,veil,self.textures[b.empty],0,0,b.w,rows,b.x,b.y)
if not a.lift then
return
end
local u=b.y-math.floor(a.lift+0.5)
self:clipAbove(u,bottom)
paintPart(h,veil,self.textures[f.name],f.x,u,f.w,f.h)
paintLabelOf(self,veil,a.itemType,f.x,u)
self:clearStencilRect()
end

function SpiffBoyHandheldWindow:drawSlot()
self:paintSlot(N,aj,a8,0,b.h,b.y+f.mouth+1)
local a=self.slotMotion
if a and a.lift then
self.shell:rect(f.x+1,b.y+f.mouth,f.w-2,1,I.r,I.g,I.b,1)
end
end

function SpiffBoyHandheldWindow:drawSlotVeil(veil)
self:paintSlot(O,ak,a9,veil,-b.y,0)
end

function SpiffBoyHandheldWindow:cartridgeTravel()
local a=self.shell
local h=math.ceil((self:getY()+a.y)/a.scale)
return b.y+f.h+h
end

function SpiffBoyHandheldWindow:clipAbove(top,bottom)
local h=self.shell
local a=h.scale
self:setStencilRect(h.x+f.x*a,h.y+top*a,f.w*a,(bottom-top)*a)
end

function SpiffBoyHandheldWindow:drawCartridgeLabel(itemType,x,y)
local u=self.shell
local a=f.label
local w,Q=x+a.x,y+a.y
local h=itemType and SpiffBoy.Cartridges.get(itemType)
local aq=h and h.art and SpiffBoy.Textures.get(h.mod,h.art..a.file,true)
if aq then
u:sprite(aq,w,Q,a.w,a.h)
return
end
local R,S=a5,a6
u:rect(w,Q,a.w,a.h,R.r,R.g,R.b,1)
local ar=u:lineHeight()
local be=h and h.title or getItemNameFromFullType(itemType)
local as=u:wrapText(be,a.w-2*a.inset)
local bf=Q+math.floor((a.h-#as*ar)/2)
for bg,bh in ipairs(as)do
u:textCentre(bh,w+math.floor(a.w/2),bf+(bg-1)*ar,S.r,S.g,S.b,1)
end
end

function SpiffBoyHandheldWindow:consoleAction()
local h=ISTimedActionQueue.getTimedActionQueue(self.playerObj).queue
local a=h and h[1]
if not(a and a.action and a.console and a.console:getID()==self.consoleId)then
return nil,0
end
return a,SpiffBoy.clamp(a:getJobDelta(),0,1)
end

function SpiffBoyHandheldWindow:clickOnRise(flag,condition)
if condition and not self[flag]and not self.hidden then
SpiffBoy.Audio.playSound(aW)
end
self[flag]=condition
end

function SpiffBoyHandheldWindow:refreshHardware()
self.seated=SpiffBoy.Handheld.getCartridge(self.console)
self.headphonesType=SpiffBoy.Handheld.getHeadphones(self.console)
self:clickOnRise("headphonesIn",self.headphonesType~=nil)
local h=SpiffBoy.LinkState.of(self.playerNum)
local a=h~=nil and h.seat==a3
if self.guestCable and not a and not self.cableLeaving then
self.pullOutStartMs=getTimestampMs()
end
self.guestCable=a
self.cableIn=SpiffBoy.Handheld.hasCable(self.console)or a
self:clickOnRise("cableSeated",self.cableIn)
end

function SpiffBoyHandheldWindow:pullOutProgress()
if not self.pullOutStartMs then
return nil
end
local a=(getTimestampMs()-self.pullOutStartMs)/a4
if a>=1 then
self.pullOutStartMs=nil
return nil
end
return a
end

function SpiffBoyHandheldWindow:updateSlotMotion(current,progress)
local a=self.seated~=nil
self:clickOnRise("cartridgeIn",a)
local h=current~=nil and current.Type==ai and a
self:clickOnRise("cartridgeLeaving",h)
self.slotMotion=nil
if current and current.Type==a2 and current.item and not a then
local u=an(progress,self:cartridgeTravel())
if u then
self.slotMotion={lift=u,itemType=current.item:getFullType()}
end
elseif h then
self.slotMotion={lift=ao(progress,self:cartridgeTravel()),itemType=self.seated.type}
end
end

function SpiffBoyHandheldWindow:freezeOnRemoval(current)
if current and current.Type==ai and self.powered and self.record and not self:isFrozen()then
self:freeze()
end
end

function SpiffBoyHandheldWindow:updateJackMotion(current,progress)
local a=current~=nil and current.Type==aY and self.headphonesType~=nil
self:clickOnRise("headphonesLeaving",a)
local u=current~=nil and current.Type==aX and SpiffBoy.Handheld.isHeadphones(current.item)
local h=nil
if u then
h=i.slides[M(current.item:getFullType())]
elseif a then
h=i.slides[M(self.headphonesType)]
end
self.jackMotion=ap(progress,u,a,h)
end

function SpiffBoyHandheldWindow:updateLinkMotion(current,progress)
local a=current and current.Type
local h=self:pullOutProgress()
local u=((a==a_ or a==a1)and self.cableIn)or h~=nil
self:clickOnRise("cableLeaving",u)
local w=(a==aZ and SpiffBoy.Handheld.isCable(current.item))or(a==a0 and not self.cableIn)
self.linkMotion=ap(h or progress,w,u,l.slide)
end

function SpiffBoyHandheldWindow:paintPort(paint,veil,port,motion,art)
local u=self.shell
if not motion then
paint(u,veil,self.textures[art.name],0,0,art.w,art.h,port.x,port.y)
return
end
local h=port.empty
paint(u,veil,self.textures[h.name],0,0,h.w,h.h,port.x,port.y)
local a=motion.art
if not a then
return
end
local x=port.y+h.h
local y=x-(a.pin-1)+math.floor(motion.drop+0.5)
local w=math.max(0,x-y)
paint(u,veil,self.textures[a.name],0,w,a.w,a.h-w,port.x+a.dx,y+w)
end

function SpiffBoyHandheldWindow:syncWornHeadphones()
local a=nil
if not self.hidden and not self.closing and self.headphonesType then
a=SpiffBoy.Handheld.HEADPHONES[self.headphonesType].worn
end
if a~=self.wornHeadphones then
self.wornHeadphones=a
SpiffBoy.WornHeadphones.wear(self.playerObj,a)
end
end

function SpiffBoyHandheldWindow:syncGrip(grip,wanted,x,y,w,h)
if wanted==grip.shown then
return
end
grip.shown=wanted
if not wanted then
grip:removeFromUIManager()
return
end
local u=self.shell
local a=u.scale
grip:setX(self:getX()+u.x+x*a)
grip:setY(self:getY()+u.y+y*a)
grip:setWidth(w*a)
grip:setHeight(h*a)
grip:initialise()
grip:addToUIManager()
grip:setAlwaysOnTop(true)
end

function SpiffBoyHandheldWindow:syncGrips()
local a=not self.hidden and not self.closing
self:syncGrip(self.jackGrip,a and self.headphonesType~=nil,i.x,i.y,i.empty.w,self:jackArt().reach)
self:syncGrip(self.linkGrip,a and self.cableIn,l.x,l.y,l.empty.w,self:linkArt().reach)
self:syncGrip(self.cartridgeGrip,a and self.seated~=nil,b.x,b.y,b.w,-b.y)
end

function SpiffBoyHandheldWindow:hasHeadphones()
return self.headphonesType~=nil
end

function SpiffBoyHandheldWindow:jackArt()
if self.headphonesType then
return i.plugs[M(self.headphonesType)]
end
return i.empty
end

function SpiffBoyHandheldWindow:linkArt()
if self.cableIn then
return l.plugged
end
return l.empty
end

function SpiffBoyHandheldWindow:drawPorts()
self:paintPort(N,0,i,self.jackMotion,self:jackArt())
self:paintPort(N,0,l,self.linkMotion,self:linkArt())
end

function SpiffBoyHandheldWindow:drawPortsVeil(veil)
self:paintPort(O,veil,i,self.jackMotion,self:jackArt())
self:paintPort(O,veil,l,self.linkMotion,self:linkArt())
end

function SpiffBoyHandheldWindow:turnOff()
if self.switchOn then
self:togglePower()
end
self:close()
end

function SpiffBoyHandheldWindow.forPlayer(playerNum)
return SpiffBoyHandheldWindow.instances[playerNum]
end

function SpiffBoyHandheldWindow.anyShown()
for h,a in pairs(SpiffBoyHandheldWindow.instances)do
if not a.hidden then
return a
end
end
return nil
end

function SpiffBoyHandheldWindow.playability(console,playerNum)
if SpiffBoyHandheldWindow.hiddenOn(console)then
return nil
end
if SpiffBoyHandheldWindow.instances[playerNum]then
return"AlreadyPlaying"
end
local a=SpiffBoy.Handheld.getCartridge(console)
if a and not SpiffBoy.Cartridges.get(a.type)then
return"UnknownCartridge"
end
return nil
end

function SpiffBoyHandheldWindow.open(playerObj,console)
local a=playerObj:getPlayerNum()
if SpiffBoyHandheldWindow.instances[a]or SpiffBoyHandheldWindow.playability(console,a)then
return
end
SpiffBoy.Textures.refresh()
local h=SpiffBoyHandheldWindow:new(playerObj,console)
h:show()
h:takeUp()
end

function SpiffBoyHandheldWindow.runningOn(console)
local h=console:getID()
for u,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.consoleId==h then
return a
end
end
return nil
end

function SpiffBoyHandheldWindow.hiddenOn(console)
local a=SpiffBoyHandheldWindow.runningOn(console)
if a and a.hidden then
return a
end
return nil
end

function SpiffBoyHandheldWindow.shownOn(console)
local a=SpiffBoyHandheldWindow.runningOn(console)
if a and not a.hidden then
return a
end
return nil
end

function SpiffBoyHandheldWindow:new(playerObj,console)
local a=ISPanel:new(0,0,getCore():getScreenWidth(),getCore():getScreenHeight())
setmetatable(a,self)
self.__index=self
a.background=false
a.wantKeyEvents=true
a.playerObj=playerObj
a.playerNum=playerObj:getPlayerNum()
a.nextSecondMs=getTimestampMs()+_
a.closing=false
a.hidden=false
a.exitPressed=false
a.console=console
a.consoleId=console:getID()
a.gameMissing=false
a.battery=SpiffBoy.Handheld.getBattery(console)
a.seated=SpiffBoy.Handheld.getCartridge(console)
a.headphonesType=SpiffBoy.Handheld.getHeadphones(console)
a.cableIn=SpiffBoy.Handheld.hasCable(console)
a.cartridgeIn=a.seated~=nil
a.cartridgeLeaving=false
a.headphonesIn=a.headphonesType~=nil
a.headphonesLeaving=false
a.cableSeated=a.cableIn
a.guestCable=false
a.pullOutStartMs=nil
a.cableLeaving=false
a.jackGrip=SpiffBoyJackGrip:new(a)
a.linkGrip=SpiffBoyLinkGrip:new(a)
a.cartridgeGrip=SpiffBoyCartridgeGrip:new(a)
a.batteryDirty=false
a.shell=SpiffBoyScreen.new(a,o,p)
a.screen=SpiffBoyScreen.new(a,SpiffBoy.Cartridges.SCREEN_WIDTH,SpiffBoy.Cartridges.SCREEN_HEIGHT)
a.screen:setPalette(SpiffBoy.Cartridges.SHADES)
a.screen:setWholePixels(true)
a.runtime=SpiffBoyRuntime.new(a.screen)
a.runtime.onCrash=function()
a:onGameCrash()
end
a.art=SpiffBoy.Textures.folder(SpiffBoy.MOD_ID,T)
a.textures=a7(a.art)
a.screenArt=SpiffBoy.Textures.folder(SpiffBoy.MOD_ID,T,true)
a.boot=nil
a.input=SpiffBoyInputState.new()
a.inputs={a.input}
a.powered=false
a.switchOn=false
a.flickerFrames=0
a.veil=nil
a.light=nil
a.veilTarget=nil
a.nextLightLogMinutes=0
local h=SpiffBoy.Handheld.getVolume(console)
a.volumeStep=az
if h then
a.volumeStep=math.floor(h*B+0.5)
end
a.volumeDirty=false
a.volumeDrag=nil
a.mouseControl=nil
a.chip=SpiffBoyChip.new()
a.speaker=SpiffBoySpeaker.new(false)
a.speaker:setVolume(a:volume())
a.link=SpiffBoyChipLink.new(playerObj)
a.chip.listener=a.link
a.channel=SpiffBoyLinkChannel.new(a)
a.sequencer=nil
a.glitch=nil
a.linkLost=false
a.noiseCounter=0
a:loadCartridge()
a:layoutShell()
return a
end

function SpiffBoyHandheldWindow:show()
self:initialise()
self:addToUIManager()
self:setAlwaysOnTop(true)
SpiffBoyHandheldWindow.instances[self.playerNum]=self
SpiffBoy.PlayerGuard.hold(self.playerObj,self)
SpiffBoyZoomLock.engage()
end

function SpiffBoyHandheldWindow:dismiss()
SpiffBoy.PlayerGuard.release(self.playerObj)
SpiffBoyZoomLock.release()
self:setVisible(false)
self:removeFromUIManager()
if SpiffBoyHandheldWindow.instances[self.playerNum]==self then
SpiffBoyHandheldWindow.instances[self.playerNum]=nil
end
end

function SpiffBoyHandheldWindow:fitTo(x,y,width,height)
self:setWidth(width)
self:setHeight(height)
self:setX(x)
self:setY(y)
end

local function S(playerNum,right)
local a=UIManager.getMoodleUI(playerNum)
if a and a:isVisible()then
return math.min(right,a:getX())
end
return right
end

local function aq(playerNum,left)
local a=getPlayerData(playerNum).equipped
if a and a:isVisible()then
return math.max(left,a:getRight())
end
return left
end

function SpiffBoyHandheldWindow:layoutShell()
local h=self.playerNum
local w,ar=getPlayerScreenLeft(h),getPlayerScreenTop(h)
local x,R=getPlayerScreenWidth(h),getPlayerScreenHeight(h)
local a=math.floor(math.min(x*aw/o,R*aM/p))
a=math.max(1,a)
local y=o*a
self.position=SpiffBoy.ConsolePosition.get()
local u
if self.position==SpiffBoy.ConsolePosition.LEFT then
u=math.min(w+x-y,aq(h,w)+U)
elseif self.position==SpiffBoy.ConsolePosition.CENTRE then
u=w+math.floor((x-y)/2)
else
u=math.max(w,S(h,w+x)-y-U)
end
local as=ar+math.floor((R-p*a)/2)
local Q=u+Z*a
self:fitTo(Q,as,(ay-Z)*a,p*a)
self.shell:setPlacement(u-Q,0,a)
self.screen:setPlacement(u-Q+at*a,au*a,a)
end

function SpiffBoyHandheldWindow:prerender()
if self.closing then
return
end
if getGameSpeed()>1 then
setGameSpeed(1)
end
self:holdZoomIn()
self:step()
end

function SpiffBoyHandheldWindow:holdZoomIn()
local a=getCore()
if a:getNextZoom(self.playerNum,aa)~=a:getNextZoom(self.playerNum,aF)then
a:doZoomScroll(self.playerNum,aa)
end
end

function SpiffBoyHandheldWindow:render()
if self.closing then
return
end
SpiffBoy.DevOverlay.draw(self)
end

function SpiffBoyHandheldWindow:takeUp()
self:shiftCamera()
self:resetVeil()
self.poseAction=SpiffBoyPlayHandheldAction.startFor(self.playerObj,self)
end

function SpiffBoyHandheldWindow:putDown()
SpiffBoy.CameraShift.finish()
SpiffBoyPlayHandheldAction.stopFor(self.poseAction)
self.poseAction=nil
end

function SpiffBoyHandheldWindow:hide()
if self.hidden or self.closing then
return
end
self.hidden=true
self.exitPressed=false
self:setVisible(false)
self:removeFromUIManager()
SpiffBoy.PlayerGuard.release(self.playerObj)
SpiffBoyZoomLock.release()
self.mouseControl=nil
self.volumeDrag=nil
self:putDown()
end

function SpiffBoyHandheldWindow:reveal()
if not self.hidden or self.closing then
return
end
self.hidden=false
self:setVisible(true)
self:addToUIManager()
self:setAlwaysOnTop(true)
SpiffBoy.PlayerGuard.hold(self.playerObj,self)
SpiffBoyZoomLock.engage()
self:takeUp()
end

function SpiffBoyHandheldWindow:stopsOn(reason)
return reason~=nil and reason~="hit"
end

function SpiffBoyHandheldWindow:putAway()
if self.powered then
self:hide()
else
self:close()
end
end

function SpiffBoyHandheldWindow:putAwayOutsideFrame(x,y)
if self:isOnFrame(x,y)then
return false
end
self:putAway()
return true
end

function SpiffBoyHandheldWindow:secondElapsed()
local a=getTimestampMs()
if a<self.nextSecondMs then
return false
end
self.nextSecondMs=a+_
return true
end

function SpiffBoyHandheldWindow:usesKeyboard()
return self.playerObj:getJoypadBind()<0 or getNumActivePlayers()==1
end

function SpiffBoyHandheldWindow:isKeyConsumed(key)
return self:usesKeyboard()and SpiffBoy.Input.isConsumedKey(key)
end

function SpiffBoyHandheldWindow:onKeyPress(key)
if isGamePaused()or not self:usesKeyboard()then
return
end
if key==SpiffBoy.Input.EXIT_KEY then
self.exitPressed=true
return
end
local a=SpiffBoy.Input.actionForKey(key)
if a then
self.input:tap(a)
end
end

function SpiffBoyHandheldWindow:onKeyRelease(key)
if key==SpiffBoy.Input.EXIT_KEY and self.exitPressed then
self.exitPressed=false
self:putAway()
end
end

function SpiffBoyHandheldWindow:onKeyRepeat(key)
end

function SpiffBoyHandheldWindow:readDevices(input)
local a=self.playerObj:getJoypadBind()
if a>=0 then
SpiffBoy.Input.readJoypad(a,input)
end
if self:usesKeyboard()then
SpiffBoy.Input.readKeyboard(input)
SpiffBoy.Input.readRunExit(input)
end
end

function SpiffBoyHandheldWindow:shiftCamera()
local a=self.playerNum
local u,w=getPlayerScreenLeft(a),getPlayerScreenWidth(a)
local y=getPlayerScreenTop(a)+getPlayerScreenHeight(a)/2
local x=self:getX()+self.shell.x
local h
if self.position==SpiffBoy.ConsolePosition.LEFT then
h=(x+o*self.shell.scale+S(a,u+w))/2
elseif self.position==SpiffBoy.ConsolePosition.CENTRE then
h=u+w/2
else
h=(u+x)/2
end
SpiffBoy.CameraShift.begin(self.playerObj,h,y)
end

function SpiffBoyHandheldWindow:isOnFrame(x,y)
local a,h=self.shell:toLocal(x,y)
if a>=0 and a<o and h>=0 and h<p then
return true
end
if C(a,h,i,self:jackArt())or C(a,h,l,self:linkArt())then
return true
end
return P(a,h,self.switchOn)~=nil
end

function SpiffBoyHandheldWindow:onMouseDown(x,y)
if self:putAwayOutsideFrame(x,y)then
return false
end
if isGamePaused()then
return self:isWantMouseEvents()
end
local u,h=self.shell:toLocal(x,y)
local a=P(u,h,self.switchOn)
if a=="power"then
self.mouseControl=nil
self:togglePower()
return self:isWantMouseEvents()
end
if a=="volume"then
self.mouseControl=nil
self.volumeDrag={startY=h,startStep=self.volumeStep,moved=false}
return self:isWantMouseEvents()
end
self.mouseControl=a
if a then
am(a,u,h,ba,self.input)
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:releaseMouse()
self.mouseControl=nil
self:releaseVolume()
end

function SpiffBoyHandheldWindow:onMouseUp(x,y)
self:releaseMouse()
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:onMouseUpOutside(x,y)
self:releaseMouse()
end

function SpiffBoyHandheldWindow:dragVolume()
local a=self.volumeDrag
if not a then
return
end
if not isMouseButtonDown(W)then
self:releaseVolume()
return
end
local w,u=self.shell:toLocal(self:getMouseX(),self:getMouseY())
local h=math.floor((a.startY-u)/aB)
if h~=0 then
a.moved=true
end
self:setVolumeStep(a.startStep+h)
end

function SpiffBoyHandheldWindow:releaseVolume()
local a=self.volumeDrag
if not a then
return
end
self.volumeDrag=nil
if a.moved then
return
end
if a.startY<d.y+d.h/2 then
self:turnVolume(1)
else
self:turnVolume(-1)
end
end

function SpiffBoyHandheldWindow:readMouse(input)
local a=self.mouseControl
if not a then
return
end
if not isMouseButtonDown(W)then
self.mouseControl=nil
return
end
local h,u=self.shell:toLocal(self:getMouseX(),self:getMouseY())
am(a,h,u,bb,input.held)
end

function SpiffBoyHandheldWindow:drainBattery()
self.battery=self.battery-SpiffBoy.Handheld.BATTERY_PER_MINUTE/aN*getGameTime():getTrueMultiplier()
self.batteryDirty=true
end

function SpiffBoyHandheldWindow:batteryDied()
self:powerOff()
SpiffBoy.ConsoleStatus.refreshName(self.console)
end

function SpiffBoyHandheldWindow:checkGuards()
local a=SpiffBoy.PlayerGuard.hitReason(self.playerObj)
if self:stopsOn(a)then
return a
end
if a=="hit"and not self.hidden then
self:putAway()
return nil
end
if not self:secondElapsed()then
return nil
end
if not self.playerObj:getInventory():containsID(self.consoleId)then
return"lost"
end
if self.battery~=nil and SpiffBoy.Handheld.getBattery(self.console)==nil then
return"unplugged"
end
return self:everySecond()
end

function SpiffBoyHandheldWindow:everySecond()
if not self.powered then
return nil
end
if not isGamePaused()and SpiffBoy.Sandbox.batteriesDrain()then
self:drainBattery()
end
if not self.hidden then
SpiffBoy.Mood.applySecond(self.playerObj)
end
if self.battery>0 then
return nil
end
self.battery=0
if self.hidden then
return"battery"
end
self:batteryDied()
return nil
end

function SpiffBoyHandheldWindow:readInput()
SpiffBoy.Input.refreshProfile()
local a=self.input
a:clearHeld()
if isGamePaused()or self.hidden then
self.mouseControl=nil
self.volumeDrag=nil
return
end
self:readDevices(a)
self:readMouse(a)
self:dragVolume()
end

function SpiffBoyHandheldWindow:step()
local w=self:checkGuards()
if w then
self:close()
return
end
if self.closing then
return
end
SpiffBoy.Audio.beginFrame()
self:refreshHardware()
local a,h=self:consoleAction()
self:updateJackMotion(a,h)
self:updateLinkMotion(a,h)
self:updateSlotMotion(a,h)
self:freezeOnRemoval(a)
self:syncWornHeadphones()
self:syncGrips()
self:readInput()
self:advance()
if self.closing then
return
end
self.channel:flush()
if not self.hidden then
local u=self.shell
u.calls=0
self:drawSideControls()
u:sprite(self.textures[H],0,0,o,p)
self:drawSlot()
self:drawPorts()
self:drawGlass()
self:drawScreen()
self:drawControls()
self:drawVeil()
if self.flickerFrames>0 then
self.flickerFrames=self.flickerFrames-1
end
end
self:sound()
end

function SpiffBoyHandheldWindow:sound()
self.speaker:play(self.chip)
self.link:setPrivate(self:hasHeadphones())
self.link:flush(self.sequencer)
self:makeNoise()
end

function SpiffBoyHandheldWindow:noiseRange(square)
local a=self:volume()
if square:getRoom()then
return s.roomFloor+math.floor(s.baseRange*s.roomShare*a)
end
return s.outsideFloor+math.floor(s.baseRange*a)
end

function SpiffBoyHandheldWindow:makeNoise()
if isGamePaused()then
return
end
self.noiseCounter=self.noiseCounter-s.drain*getGameTime():getMultiplier()
if self.noiseCounter>0 then
return
end
self.noiseCounter=s.period
local h=self:volume()
local u=self.playerObj
local a=u:getCurrentSquare()
if not self.powered or h<=0 or not a or self:hasHeadphones()or not SpiffBoy.Sandbox.noiseAttractsZombies()then
return
end
addSound(u,a:getX(),a:getY(),a:getZ(),self:noiseRange(a),math.floor(s.loudness*h))
end

function SpiffBoyHandheldWindow:drawGlass()
local a=self.screen
local h=aD
if self.powered or self.flickerFrames>0 then
h=k
end
local w=a.scale
local u=math.floor(w*av)
self.shell.calls=self.shell.calls+1
self:drawRect(a.x-u,a.y-u,a.width*w+2*u,a.height*w+2*u,1,h.r,h.g,h.b)
end

function SpiffBoyHandheldWindow:onMouseWheel(delta)
if isGamePaused()then
return false
end
local a,h=self.shell:toLocal(self:getMouseX(),self:getMouseY())
if P(a,h,self.switchOn)~="volume"then
return false
end
self:turnVolume(-delta)
return true
end

function SpiffBoyHandheldWindow:volume()
return self.volumeStep/B
end

function SpiffBoyHandheldWindow:turnVolume(notches)
self:setVolumeStep(self.volumeStep+notches)
end

function SpiffBoyHandheldWindow:setVolumeStep(step)
step=SpiffBoy.clamp(step,0,B)
if step==self.volumeStep then
return
end
self.volumeStep=step
self.volumeDirty=true
self.speaker:setVolume(self:volume())
self.link:setVolume(self:volume())
SpiffBoy.Audio.playSound(aA)
end

function SpiffBoyHandheldWindow:togglePower()
SpiffBoy.Audio.playSound(ax)
if self.switchOn then
self.switchOn=false
self.flickerFrames=0
if self.powered then
self:powerOff()
end
else
self.switchOn=true
if self.battery~=nil and self.battery>0 then
self:powerOn()
elseif self.battery~=nil then
self.flickerFrames=aG
end
end
SpiffBoy.ConsoleStatus.refreshName(self.console)
end

function SpiffBoyHandheldWindow:powerOn()
self.powered=true
self.chip:boot()
self:loadCartridge()
if self.definition then
self.link:powerOn(self.definition.item,self:volume())
end
self.channel:announce()
self.boot=SpiffBoyBootScreen.new(self.screenArt(aU),self.chip,not self.definition)
self.runtime:setDevices({self.chip,self.link,self.channel})
self.runtime:setGame(self.boot)
end

function SpiffBoyHandheldWindow:loadCartridge()
local a=SpiffBoy.Handheld.getCartridge(self.console)
self.record=a
self.definition=a and SpiffBoy.Cartridges.get(a.type)
self.gameArt=self.definition and SpiffBoy.Textures.folder(self.definition.mod,self.definition.art,true)
end

function SpiffBoyHandheldWindow:freeze()
local h=self.screen.width
local u=self.screen.height
local a={}
for x=1,aO do
local w=ZombRand(aP,aQ+1)
a[#a+1]={x=ZombRand(h),y=ZombRand(u),w=w,h=1,shade=ZombRand(ac)+1}
end
for w=1,aR do
a[#a+1]={x=ZombRand(h),y=ZombRand(u),w=ZombRand(1,aS+1),h=1,shade=ZombRand(ac)+1}
end
self.glitch=a
self.link:freeze()
end

function SpiffBoyHandheldWindow:isFrozen()
return self.glitch~=nil or self.linkLost
end

function SpiffBoyHandheldWindow:onLinkLost()
if not self.powered or self:isFrozen()then
return
end
self.linkLost=true
self.link:freeze()
end

function SpiffBoyHandheldWindow:powerOff()
self.powered=false
self.gameMissing=false
self.boot=nil
self.glitch=nil
self.linkLost=false
self.runtime:setGame(nil)
self.runtime:setDevices({})
self.sequencer=nil
self.chip:halt()
self.link:powerOff()
self.channel:announce()
self:persistHardware()
end

function SpiffBoyHandheldWindow:writeHardware(save)
SpiffBoyClientActions.saveHandheld(self.playerObj,self.console,save,self.battery,self:volume())
self.batteryDirty=false
self.volumeDirty=false
end

function SpiffBoyHandheldWindow:persistHardware()
if not self.batteryDirty and not self.volumeDirty then
return
end
self:writeHardware(nil)
end

function SpiffBoyHandheldWindow:persistSave(save)
self:writeHardware(save)
end

function SpiffBoyHandheldWindow:advance()
local a=self.runtime
if a.game and not self:isFrozen()then
a:advance(self.inputs,isGamePaused(),SpiffBoy.consoleRate())
else
self.input:latch()
end
if self.boot and not self:isFrozen()and self.boot:isDone()then
self.boot=nil
self:startGame()
end
if self.input.pressed.exit then
self:putAway()
end
end

function SpiffBoyHandheldWindow:onGameCrash()
self:freeze()
end

function SpiffBoyHandheldWindow:frame(draw)
local a=self.screen
a:beginFrame()
draw(self,a)
a:endFrame()
end

local function ar(window,screen)
screen:clear(k.r,k.g,k.b)
end

local function as(window,screen)
screen:clear(k.r,k.g,k.b)
local a=screen:lineHeight()
screen:textCentre(getText("UI_SpiffBoy_GameMissing"),screen.width/2,(screen.height-a)/2,r.r,r.g,r.b,1)
end

local function be(window,screen)
local u=SpiffBoy.Cartridges.SHADES
for w,a in ipairs(window.glitch)do
local h=u[a.shade]
screen:rect(a.x,a.y,a.w,a.h,h.r,h.g,h.b,1)
end
end

local function bf(window,screen)
local a=aT
local y=screen:lineHeight()
local w=screen:wrapText(getText("UI_SpiffBoy_LinkLost"),a.width-a.padding*2)
local h=#w*y+a.padding*2
local x=math.floor((screen.width-a.width)/2)
local u=math.floor((screen.height-h)/2)
screen:rect(x,u,a.width,h,r.r,r.g,r.b,1)
screen:rect(x+1,u+1,a.width-2,h-2,k.r,k.g,k.b,1)
screen:rect(x+2,u+2,a.width-4,h-4,r.r,r.g,r.b,1)
for Q=1,#w do
screen:textCentre(w[Q],screen.width/2,u+a.padding+(Q-1)*y,k.r,k.g,k.b,1)
end
end

function SpiffBoyHandheldWindow:drawScreen()
local a=self.runtime
if a.crash then
self:frame(ar)
elseif a.game then
a:draw()
elseif self.gameMissing then
self:frame(as)
end
if self.glitch then
self:frame(be)
end
if self.linkLost then
self:frame(bf)
end
end

function SpiffBoyHandheldWindow:startGame()
local a=SpiffBoy.Cartridges.resolveGame(self.definition)
if not a then
self.runtime:setGame(nil)
SpiffBoy.log("no game class named "..tostring(self.definition.game))
self.gameMissing=true
return
end
self.sequencer=SpiffBoySequencer.new(self.chip,SpiffBoy.Tunes.set(self.definition.id))
self.sequencer.listener=self.link
self.runtime:setDevices({self.sequencer,self.chip,self.link,self.channel})
local h=self
local u={
seed=SpiffBoy.newSeed(),
definition=self.definition,
art=self.gameArt,
chip=self.chip,
sequencer=self.sequencer,
link=self.channel:view(),
save=SpiffBoy.Handheld.recordSave(self.record),
persist=function(save)
h:persistSave(save)
end,
}
self.runtime:start(a,u)
end

function SpiffBoyHandheldWindow:blinkOn()
return math.floor(getTimestampMs()/aE)%2==0
end

function SpiffBoyHandheldWindow:drawControls()
local a=self.shell
local h=self.textures
local u=self.input.held
local Q,R=self.input:axes()
local bg=(R+1)*t+(Q+1)
a:sprite(h[J[bg]],g.x-g.size/2,g.y-g.size/2,g.size,g.size)
local w=0
if u.a then
w=1
end
local x=0
if u.b then
x=1
end
a:sprite(h[K.a[w]],D.x-v/2,D.y-z/2,v,z)
a:sprite(h[K.b[x]],E.x-v/2,E.y-z/2,v,z)
local y=0
if u.start then
y=1
end
a:sheet(h[ah],y*n.w,0,n.w,n.h,n.x-n.w/2,n.y-n.h/2)
self:drawLed(self:ledFrame())
end

function SpiffBoyHandheldWindow:ledFrame()
if self.powered then
if self.battery<=aC and not self:blinkOn()then
return X
end
return F
end
if self.flickerFrames>0 then
return F
end
return Y
end

function SpiffBoyHandheldWindow:drawLed(frame)
self.shell:sheet(self.textures[ae],frame*q.size,0,q.size,q.size,q.x-q.size/2,q.y-q.size/2)
end

function SpiffBoyHandheldWindow:ambientLight(square)
local a=square:getLightLevel(self.playerNum)
if self.playerObj:hasTrait(CharacterTrait.NIGHT_VISION)then
a=a+aI
end
return SpiffBoy.clamp(a,0,1)
end

local function bg()
return getGameTime():getWorldAgeHours()*aL
end

function SpiffBoyHandheldWindow:logLight(square)
if not SpiffBoy.isDevBuild()then
return
end
local a=bg()
if a<self.nextLightLogMinutes then
return
end
self.nextLightLogMinutes=a+aK
SpiffBoy.log("light "..tostring(self.light).." target "..tostring(self.veilTarget).." veil "..tostring(self.veil).." raw "..tostring(square:getLightLevel(self.playerNum)).." setting "..tostring(SandboxVars.NightDarkness).." room "..tostring(square:isInARoom()).." hour "..tostring(getGameTime():getTimeOfDay()))
end

function SpiffBoyHandheldWindow:measureLight()
local a=self.playerObj:getCurrentSquare()
if not a then
return false
end
local h=self:ambientLight(a)
self.light=h
self.veilTarget=SpiffBoy.clamp((ab-h)/(ab-aH),0,1)
self:logLight(a)
return true
end

function SpiffBoyHandheldWindow:resetVeil()
if self:measureLight()then
self.veil=self.veilTarget
end
end

function SpiffBoyHandheldWindow:updateVeil()
self:measureLight()
if self.veilTarget==nil then
return
end
if self.veil==nil then
self.veil=self.veilTarget
return
end
self.veil=self.veil+(self.veilTarget-self.veil)*aJ
end

function SpiffBoyHandheldWindow:drawVeil()
self:updateVeil()
local a=self.veil
if a==nil or a<=0 then
return
end
local w=self.shell
self:drawSideControlsWith(ak,a)
local u=self.textures[H]
local x=q.x-c.size/2
local h=q.y-c.size/2
local y=x+c.size
local Q=h+c.size
w:tintedSheet(u,0,0,o,h,0,0,0,0,0,a)
w:tintedSheet(u,0,Q,o,p-Q,0,Q,0,0,0,a)
w:tintedSheet(u,0,h,x,c.size,0,h,0,0,0,a)
w:tintedSheet(u,y,h,o-y,c.size,y,h,0,0,0,a)
self:drawSlotVeil(a)
self:drawPortsVeil(a)
local R=self:ledFrame()
self:drawLampLight(u,R,a,x,h)
if R~=Y then
self:drawLed(R)
end
end

function SpiffBoyHandheldWindow:drawLampLight(face,frame,veil,left,top)
local h=self.shell
local a=0
if frame==F then
a=c.strength*veil^c.curve
elseif frame==X then
a=c.strength*c.dim*veil^c.curve
end
local u=veil*(1-a)
local w=0
if u<1 then
w=1-(1-veil)/(1-u)
end
h:tintedSheet(face,left,top,c.size,c.size,left,top,0,0,0,u)
if w>0 then
h:sprite(self.textures[af],left,top,c.size,c.size,w)
end
if a>0 then
h:sprite(self.textures[ag],left,top,c.size,c.size,c.red*a/c.strength)
end
end

function SpiffBoyHandheldWindow:drawSideControls()
self:drawSideControlsWith(aj,0)
end

function SpiffBoyHandheldWindow:drawSideControlsWith(paint,veil)
local a=self.shell
local h=e.offY
if self.switchOn then
h=e.onY
end
paint(a,veil,self.textures[ad],e.x-A,h-A,e.w+G+2*A,e.h+2*A)
paint(a,veil,self.textures[L[self.volumeStep]],d.x-G,d.y,d.w+G,d.h)
end

function SpiffBoyHandheldWindow:close()
if self.closing then
return
end
self.closing=true
self:syncWornHeadphones()
self:syncGrips()
self.runtime:setGame(nil)
self:persistHardware()
self.link:close()
self.speaker:destroy()
self:putDown()
self:dismiss()
SpiffBoy.ConsoleStatus.refreshName(self.console)
end

local function u()
for h,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.hidden then
a:step()
end
end
end

local function h()
for w,a in pairs(SpiffBoyHandheldWindow.instances)do
if not a.hidden and a.playerObj:getJoypadBind()<0 then
if SpiffBoy.isDevBuild()then
SpiffBoy.log("play window put away by a press the interface did not take")
end
a:putAway()
end
end
end

Events.OnPreUIDraw.Add(u)
Events.OnMouseDown.Add(h)
Events.OnRightMouseDown.Add(h)
