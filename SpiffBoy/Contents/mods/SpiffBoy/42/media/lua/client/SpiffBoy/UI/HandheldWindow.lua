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
local n=384
local o=252
local as=102
local at=60
local au=0.5
local av=0.62
local U=24
local g={x=47.5,y=125.5,size=72}
local t=3
local C={x=336,y=157}
local D={x=336,y=95}
local v=40
local x=40
local m={x=192,y=228,w=24,h=8}
local V=4
local W=0
local p={x=30,y=30,size=8}
local E=0
local X=1
local Y=2
local e={x=-4,w=4,h=20,onY=41,offY=47,hitMargin=4}
local aw="SpiffBoy_PowerSwitch"
local y=1/4
local F=1
local d={x=n,w=4,h=22,y=43,hitMargin=4}
local Z=e.x-e.hitMargin
local ax=d.x+d.w+d.hitMargin
local z=10
local ay=7
local az="SpiffBoy_VolumeWheel"
local aA=2
local aB=0.15
local j=SpiffBoy.Cartridges.SHADES[4]
local q=SpiffBoy.Cartridges.SHADES[1]
local aC={r=132/255,g=146/255,b=138/255}
local aD=500
local _=1000
local aa=-1
local aE=0
local aF=4
local r={baseRange=8,roomShare=0.4,roomFloor=3,outsideFloor=5,period=120,drain=1.25,loudness=100}
local ab=0.95
local aG=0.135
local aH=0.15
local aI=0.08
local c={size=32,strength=0.6,curve=3,red=0.45,dim=0.5}
local aJ=1
local aK=60
local aL=0.95
local aM=60
local aN=7
local aO=24
local aP=120
local aQ=40
local aR=6
local ac=#SpiffBoy.Cartridges.SHADES
local aS={width=150,padding=6}
local aT="spiffboy"
local G="shell"
local ad="power_switch"
local ae="led"
local af="led_glow_edge"
local ag="led_glow_red"
local ah="button_start"
local aU={x=128,y=0,w=128,h=8}
local b={x=130,y=-3,w=125,h=9,empty="slot_empty",full="slot_cartridge"}
local h={
x=322,
y=o,
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
local k={
x=56,
y=o,
zone={x=55,y=232,w=24},
empty={name="link_empty",w=22,h=3,reach=3},
plugged={name="link_plugged",w=22,h=56,reach=36},
slide={name="plug_link",w=24,h=60,pin=8,dx=-1},
}
local i={travel=40,snap=1,ease=1.5,start=0.10,reach=0.90,gone=0.90}
local aV="SpiffBoy_PartClick"
local aW="SpiffBoyPlugHeadphonesAction"
local aX="SpiffBoyUnplugHeadphonesAction"
local aY="SpiffBoyPlugCableAction"
local aZ="SpiffBoyUnplugCableAction"
local a_="SpiffBoyConnectCableAction"
local a0="SpiffBoyDisconnectCableAction"
local a1="SpiffBoyInsertCartridgeAction"
local ai="SpiffBoyRemoveCartridgeAction"
local a2=2
local a3=600
local f={
name="cartridge",
x=b.x+3,
w=119,
h=100,
mouth=6,
label={x=11,y=29,w=97,h=53,file="label.png",inset=3},
}
local a4={r=238/255,g=232/255,b=214/255}
local a5={r=52/255,g=44/255,b=60/255}
local H={r=96/255,g=62/255,b=116/255}
local I={}
local J={a={[0]="button_a_0",[1]="button_a_1"},b={[0]="button_b_0",[1]="button_b_1"}}
local K={}
local l={G,b.empty,b.full,f.name,ad,ae,af,ag,ah,h.empty.name,k.empty.name,k.plugged.name,k.slide.name}

for a=0,t*t-1 do
I[a]="dpad_"..a
l[#l+1]=I[a]
end
for a=0,z do
K[a]="volume_wheel_"..a
l[#l+1]=K[a]
end
for s,a in pairs(J)do
l[#l+1]=a[0]
l[#l+1]=a[1]
end
for u,a in pairs({h.plugs,h.slides})do
for w,s in pairs(a)do
l[#l+1]=s.name
end
end

local function a6(u)
local a={}
for w=1,#l do
local s=l[w]
a[s]=u(s)
end
return a
end

local function L(a)
return SpiffBoy.Handheld.HEADPHONES[a].kind
end

local function aj(a,M,s,u,w,A,B)
a:sprite(s,u,w,A,B)
end

local function ak(a,s,u,w,A,B,M)
a:tinted(u,w,A,B,M,0,0,0,s)
end

local function M(a,P,s,u,w,A,B,N,O)
a:sheet(s,u,w,A,B,N,O)
end

local function N(a,s,u,w,A,B,O,P,Q)
a:tintedSheet(u,w,A,B,O,P,Q,0,0,0,s)
end

local function a7(a,A,s,u,w)
a:drawCartridgeLabel(s,u,w)
end

local function a8(s,u,B,w,A)
local a=f.label
s.shell:rect(w+a.x,A+a.y,a.w,a.h,0,0,0,u)
end

local function a9(a,s)
a:tap(s)
end

local function ba(a,s)
a[s]=true
end

local function al(A,B,a)
local s=A-a.x
local u=B-a.y
local w=v/2
return s*s+u*u<=w*w
end

local function O(a,s,A)
local u=e.offY
if A then
u=e.onY
end
if a>=e.x-e.hitMargin and a<e.x+e.w+e.hitMargin and s>=u and s<u+e.h then
return"power"
end
if a>=d.x-d.hitMargin and a<d.x+d.w+d.hitMargin and s>=d.y and s<d.y+d.h then
return"volume"
end
local w=g.size/2
if math.abs(a-g.x)<=w and math.abs(s-g.y)<=w then
return"dpad"
end
if al(a,s,C)then
return"a"
end
if al(a,s,D)then
return"b"
end
if math.abs(a-m.x)<=m.w/2+V and math.abs(s-m.y)<=m.h/2+V then
return"start"
end
return nil
end

local function bb(s,u)
local a=g.size/t
local w=g.x-g.size/2
local A=g.y-g.size/2
local B=math.max(0,math.min(t-1,math.floor((s-w)/a)))
local P=math.max(0,math.min(t-1,math.floor((u-A)/a)))
return B-1,P-1
end

local function am(u,B,P,a,s)
if u~="dpad"then
a(s,u)
return
end
local w,A=bb(B,P)
if w<0 then
a(s,"left")
elseif w>0 then
a(s,"right")
end
if A<0 then
a(s,"up")
elseif A>0 then
a(s,"down")
end
end

local function bc(s,u,a)
return s>=a.x and s<a.x+a.w and u>=a.y and u<a.y+a.h
end

local function A(s,u,w,B)
local a=w.zone
return s>=a.x and s<a.x+a.w and u>=a.y and u<w.y+B.reach
end

local function an(a,s)
if a<i.start then
return nil
end
local u=math.min(1,(a-i.start)/(i.reach-i.start))
return i.snap+(s-i.snap)*(1-u)^i.ease
end

local function ao(a,s)
if a>=i.gone then
return nil
end
return i.snap+(s-i.snap)*(a/i.gone)^i.ease
end

local function ap(a,w,B,s)
if w then
local u=an(a,i.travel)
if u then
return{art=s,drop=u}
end
return nil
end
if B then
local u=ao(a,i.travel)
return{art=u and s,drop=u or 0}
end
return nil
end

function SpiffBoyHandheldWindow:openShellMenu(s)
local a=ISContextMenu.get(self.playerNum,getMouseX(),getMouseY())
a:removeFromUIManager()
a:addToUIManager()
a:setAlwaysOnTop(true)
s(a,function(u,w,B,...)
return a:addOption(u,w,B,...)
end)
if a.numOptions<=1 then
a:setVisible(false)
end
self:traceMouse("menu opened with "..tostring(a.numOptions-1).." options, visible "..tostring(a:getIsVisible()).." at "..a:getX()..","..a:getY())
end

function SpiffBoyHandheldWindow:openJackMenu()
self:openShellMenu(function(a,s)
SpiffBoy.HeadphonesMenu.addOptions(a,self.playerObj,self.console,s)
end)
end

function SpiffBoyHandheldWindow:openLinkMenu()
self:openShellMenu(function(a,s)
SpiffBoy.LinkMenu.addOptions(a,self.playerObj,self.console,s)
end)
end

function SpiffBoyHandheldWindow:onRightMouseUp(u,w)
local a,s=self.shell:toLocal(u,w)
local B=bc(a,s,aU)
local P=A(a,s,h,self:jackArt())
local Q=A(a,s,k,self:linkArt())
self:traceMouse("right up at "..u..","..w.." shell "..a..","..s.." inside "..tostring(B).." jack "..tostring(P).." link "..tostring(Q).." paused "..tostring(isGamePaused()))
if isGamePaused()then
return self:isWantMouseEvents()
end
if P then
self:openJackMenu()
elseif Q then
self:openLinkMenu()
elseif B then
self:openCartridgeMenu()
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:openCartridgeMenu()
self:openShellMenu(function(a,s)
SpiffBoy.CartridgeMenu.addOptions(a,self.playerObj,self.console,s,true)
end)
end

function SpiffBoyHandheldWindow:traceMouse(a)
if SpiffBoy.isDevBuild()then
SpiffBoy.log("handheld mouse: "..a)
end
end

function SpiffBoyHandheldWindow:onRightMouseDown(a,s)
self:traceMouse("right down at "..a..","..s.." on frame "..tostring(self:isOnFrame(a,s)))
if self:putAwayOutsideFrame(a,s)then
return false
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:onRightMouseUpOutside(a,s)
self:traceMouse("right up outside at "..a..","..s)
end

function SpiffBoyHandheldWindow:slotArt()
if self.seated then
return self.textures[b.full]
end
return self.textures[b.empty]
end

function SpiffBoyHandheldWindow:paintSlot(B,Q,R,a,P,S)
local u=self.shell
local s=self.slotMotion
if not s then
B(u,a,self:slotArt(),0,0,b.w,P,b.x,b.y)
return
end
B(u,a,self.textures[b.empty],0,0,b.w,P,b.x,b.y)
if not s.lift then
return
end
local w=b.y-math.floor(s.lift+0.5)
self:clipAbove(w,S)
Q(u,a,self.textures[f.name],f.x,w,f.w,f.h)
R(self,a,s.itemType,f.x,w)
self:clearStencilRect()
end

function SpiffBoyHandheldWindow:drawSlot()
self:paintSlot(M,aj,a7,0,b.h,b.y+f.mouth+1)
local a=self.slotMotion
if a and a.lift then
self.shell:rect(f.x+1,b.y+f.mouth,f.w-2,1,H.r,H.g,H.b,1)
end
end

function SpiffBoyHandheldWindow:drawSlotVeil(a)
self:paintSlot(N,ak,a8,a,-b.y,0)
end

function SpiffBoyHandheldWindow:cartridgeTravel()
local a=self.shell
local s=math.ceil((self:getY()+a.y)/a.scale)
return b.y+f.h+s
end

function SpiffBoyHandheldWindow:clipAbove(u,w)
local s=self.shell
local a=s.scale
self:setStencilRect(s.x+f.x*a,s.y+u*a,f.w*a,(w-u)*a)
end

function SpiffBoyHandheldWindow:drawCartridgeLabel(w,bd,be)
local u=self.shell
local a=f.label
local B,P=bd+a.x,be+a.y
local s=w and SpiffBoy.Cartridges.get(w)
local S=s and s.art and SpiffBoy.Textures.get(s.mod,s.art..a.file,true)
if S then
u:sprite(S,B,P,a.w,a.h)
return
end
local Q,R=a4,a5
u:rect(B,P,a.w,a.h,Q.r,Q.g,Q.b,1)
local aq=u:lineHeight()
local bf=s and s.title or getItemNameFromFullType(w)
local ar=u:wrapText(bf,a.w-2*a.inset)
local bg=P+math.floor((a.h-#ar*aq)/2)
for bh,bi in ipairs(ar)do
u:textCentre(bi,B+math.floor(a.w/2),bg+(bh-1)*aq,R.r,R.g,R.b,1)
end
end

function SpiffBoyHandheldWindow:consoleAction()
local s=ISTimedActionQueue.getTimedActionQueue(self.playerObj).queue
local a=s and s[1]
if not(a and a.action and a.console and a.console:getID()==self.consoleId)then
return nil,0
end
return a,SpiffBoy.clamp(a:getJobDelta(),0,1)
end

function SpiffBoyHandheldWindow:clickOnRise(a,s)
if s and not self[a]and not self.hidden then
SpiffBoy.Audio.playSound(aV)
end
self[a]=s
end

function SpiffBoyHandheldWindow:refreshHardware()
self.seated=SpiffBoy.Handheld.getCartridge(self.console)
self.headphonesType=SpiffBoy.Handheld.getHeadphones(self.console)
self:clickOnRise("headphonesIn",self.headphonesType~=nil)
local s=SpiffBoy.LinkState.of(self.playerNum)
local a=s~=nil and s.seat==a2
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
local a=(getTimestampMs()-self.pullOutStartMs)/a3
if a>=1 then
self.pullOutStartMs=nil
return nil
end
return a
end

function SpiffBoyHandheldWindow:updateSlotMotion(a,u)
local s=self.seated~=nil
self:clickOnRise("cartridgeIn",s)
local w=a~=nil and a.Type==ai and s
self:clickOnRise("cartridgeLeaving",w)
self.slotMotion=nil
if a and a.Type==a1 and a.item and not s then
local B=an(u,self:cartridgeTravel())
if B then
self.slotMotion={lift=B,itemType=a.item:getFullType()}
end
elseif w then
self.slotMotion={lift=ao(u,self:cartridgeTravel()),itemType=self.seated.type}
end
end

function SpiffBoyHandheldWindow:freezeOnRemoval(a)
if a and a.Type==ai and self.powered and self.record and not self:isFrozen()then
self:freeze()
end
end

function SpiffBoyHandheldWindow:updateJackMotion(a,B)
local s=a~=nil and a.Type==aX and self.headphonesType~=nil
self:clickOnRise("headphonesLeaving",s)
local w=a~=nil and a.Type==aW and SpiffBoy.Handheld.isHeadphones(a.item)
local u=nil
if w then
u=h.slides[L(a.item:getFullType())]
elseif s then
u=h.slides[L(self.headphonesType)]
end
self.jackMotion=ap(B,w,s,u)
end

function SpiffBoyHandheldWindow:updateLinkMotion(s,B)
local a=s and s.Type
local u=self:pullOutProgress()
local w=((a==aZ or a==a0)and self.cableIn)or u~=nil
self:clickOnRise("cableLeaving",w)
local P=(a==aY and SpiffBoy.Handheld.isCable(s.item))or(a==a_ and not self.cableIn)
self.linkMotion=ap(u or B,P,w,k.slide)
end

function SpiffBoyHandheldWindow:paintPort(w,B,a,P,Q)
local R=self.shell
if not P then
w(R,B,self.textures[Q.name],0,0,Q.w,Q.h,a.x,a.y)
return
end
local u=a.empty
w(R,B,self.textures[u.name],0,0,u.w,u.h,a.x,a.y)
local s=P.art
if not s then
return
end
local aq=a.y+u.h
local ar=aq-(s.pin-1)+math.floor(P.drop+0.5)
local S=math.max(0,aq-ar)
w(R,B,self.textures[s.name],0,S,s.w,s.h-S,a.x+s.dx,ar+S)
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

function SpiffBoyHandheldWindow:syncGrip(a,u,B,P,Q,R)
if u==a.shown then
return
end
a.shown=u
if not u then
a:removeFromUIManager()
return
end
local w=self.shell
local s=w.scale
a:setX(self:getX()+w.x+B*s)
a:setY(self:getY()+w.y+P*s)
a:setWidth(Q*s)
a:setHeight(R*s)
a:initialise()
a:addToUIManager()
a:setAlwaysOnTop(true)
end

function SpiffBoyHandheldWindow:syncGrips()
local a=not self.hidden and not self.closing
self:syncGrip(self.jackGrip,a and self.headphonesType~=nil,h.x,h.y,h.empty.w,self:jackArt().reach)
self:syncGrip(self.linkGrip,a and self.cableIn,k.x,k.y,k.empty.w,self:linkArt().reach)
self:syncGrip(self.cartridgeGrip,a and self.seated~=nil,b.x,b.y,b.w,-b.y)
end

function SpiffBoyHandheldWindow:hasHeadphones()
return self.headphonesType~=nil
end

function SpiffBoyHandheldWindow:jackArt()
if self.headphonesType then
return h.plugs[L(self.headphonesType)]
end
return h.empty
end

function SpiffBoyHandheldWindow:linkArt()
if self.cableIn then
return k.plugged
end
return k.empty
end

function SpiffBoyHandheldWindow:drawPorts()
self:paintPort(M,0,h,self.jackMotion,self:jackArt())
self:paintPort(M,0,k,self.linkMotion,self:linkArt())
end

function SpiffBoyHandheldWindow:drawPortsVeil(a)
self:paintPort(N,a,h,self.jackMotion,self:jackArt())
self:paintPort(N,a,k,self.linkMotion,self:linkArt())
end

function SpiffBoyHandheldWindow:turnOff()
if self.switchOn then
self:togglePower()
end
self:close()
end

function SpiffBoyHandheldWindow.forPlayer(a)
return SpiffBoyHandheldWindow.instances[a]
end

function SpiffBoyHandheldWindow.anyShown()
for s,a in pairs(SpiffBoyHandheldWindow.instances)do
if not a.hidden then
return a
end
end
return nil
end

function SpiffBoyHandheldWindow.playability(a,u)
if SpiffBoyHandheldWindow.hiddenOn(a)then
return nil
end
if SpiffBoyHandheldWindow.instances[u]then
return"AlreadyPlaying"
end
local s=SpiffBoy.Handheld.getCartridge(a)
if s and not SpiffBoy.Cartridges.get(s.type)then
return"UnknownCartridge"
end
return nil
end

function SpiffBoyHandheldWindow.open(a,s)
local u=a:getPlayerNum()
if SpiffBoyHandheldWindow.instances[u]or SpiffBoyHandheldWindow.playability(s,u)then
return
end
SpiffBoy.Textures.refresh()
local w=SpiffBoyHandheldWindow:new(a,s)
w:show()
w:takeUp()
end

function SpiffBoyHandheldWindow.runningOn(s)
local u=s:getID()
for w,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.consoleId==u then
return a
end
end
return nil
end

function SpiffBoyHandheldWindow.hiddenOn(s)
local a=SpiffBoyHandheldWindow.runningOn(s)
if a and a.hidden then
return a
end
return nil
end

function SpiffBoyHandheldWindow.shownOn(s)
local a=SpiffBoyHandheldWindow.runningOn(s)
if a and not a.hidden then
return a
end
return nil
end

function SpiffBoyHandheldWindow:new(u,s)
local a=ISPanel:new(0,0,getCore():getScreenWidth(),getCore():getScreenHeight())
setmetatable(a,self)
self.__index=self
a.background=false
a.wantKeyEvents=true
a.playerObj=u
a.playerNum=u:getPlayerNum()
a.nextSecondMs=getTimestampMs()+_
a.closing=false
a.hidden=false
a.exitPressed=false
a.console=s
a.consoleId=s:getID()
a.gameMissing=false
a.battery=SpiffBoy.Handheld.getBattery(s)
a.seated=SpiffBoy.Handheld.getCartridge(s)
a.headphonesType=SpiffBoy.Handheld.getHeadphones(s)
a.cableIn=SpiffBoy.Handheld.hasCable(s)
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
a.shell=SpiffBoyScreen.new(a,n,o)
a.screen=SpiffBoyScreen.new(a,SpiffBoy.Cartridges.SCREEN_WIDTH,SpiffBoy.Cartridges.SCREEN_HEIGHT)
a.screen:setPalette(SpiffBoy.Cartridges.SHADES)
a.screen:setWholePixels(true)
a.runtime=SpiffBoyRuntime.new(a.screen)
a.runtime.onCrash=function()
a:onGameCrash()
end
a.art=SpiffBoy.Textures.folder(SpiffBoy.MOD_ID,T)
a.textures=a6(a.art)
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
local w=SpiffBoy.Handheld.getVolume(s)
a.volumeStep=ay
if w then
a.volumeStep=math.floor(w*z+0.5)
end
a.volumeDirty=false
a.volumeDrag=nil
a.mouseControl=nil
a.chip=SpiffBoyChip.new()
a.speaker=SpiffBoySpeaker.new(false)
a.speaker:setVolume(a:volume())
a.link=SpiffBoyChipLink.new(u)
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

function SpiffBoyHandheldWindow:fitTo(a,s,u,w)
self:setWidth(u)
self:setHeight(w)
self:setX(a)
self:setY(s)
end

local function S(u,s)
local a=UIManager.getMoodleUI(u)
if a and a:isVisible()then
return math.min(s,a:getX())
end
return s
end

local function aq(u,s)
local a=getPlayerData(u).equipped
if a and a:isVisible()then
return math.max(s,a:getRight())
end
return s
end

function SpiffBoyHandheldWindow:layoutShell()
local s=self.playerNum
local w,ar=getPlayerScreenLeft(s),getPlayerScreenTop(s)
local B,R=getPlayerScreenWidth(s),getPlayerScreenHeight(s)
local a=math.floor(math.min(B*av/n,R*aL/o))
a=math.max(1,a)
local P=n*a
self.position=SpiffBoy.ConsolePosition.get()
local u
if self.position==SpiffBoy.ConsolePosition.LEFT then
u=math.min(w+B-P,aq(s,w)+U)
elseif self.position==SpiffBoy.ConsolePosition.CENTRE then
u=w+math.floor((B-P)/2)
else
u=math.max(w,S(s,w+B)-P-U)
end
local bd=ar+math.floor((R-o*a)/2)
local Q=u+Z*a
self:fitTo(Q,bd,(ax-Z)*a,o*a)
self.shell:setPlacement(u-Q,0,a)
self.screen:setPlacement(u-Q+as*a,at*a,a)
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
if a:getNextZoom(self.playerNum,aa)~=a:getNextZoom(self.playerNum,aE)then
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

function SpiffBoyHandheldWindow:stopsOn(a)
return a~=nil and a~="hit"
end

function SpiffBoyHandheldWindow:putAway()
if self.powered then
self:hide()
else
self:close()
end
end

function SpiffBoyHandheldWindow:putAwayOutsideFrame(a,s)
if self:isOnFrame(a,s)then
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

function SpiffBoyHandheldWindow:isKeyConsumed(a)
return self:usesKeyboard()and SpiffBoy.Input.isConsumedKey(a)
end

function SpiffBoyHandheldWindow:onKeyPress(a)
if isGamePaused()or not self:usesKeyboard()then
return
end
if a==SpiffBoy.Input.EXIT_KEY then
self.exitPressed=true
return
end
local s=SpiffBoy.Input.actionForKey(a)
if s then
self.input:tap(s)
end
end

function SpiffBoyHandheldWindow:onKeyRelease(a)
if a==SpiffBoy.Input.EXIT_KEY and self.exitPressed then
self.exitPressed=false
self:putAway()
end
end

function SpiffBoyHandheldWindow:onKeyRepeat(a)
end

function SpiffBoyHandheldWindow:readDevices(a)
local s=self.playerObj:getJoypadBind()
if s>=0 then
SpiffBoy.Input.readJoypad(s,a)
end
if self:usesKeyboard()then
SpiffBoy.Input.readKeyboard(a)
SpiffBoy.Input.readRunExit(a)
end
end

function SpiffBoyHandheldWindow:shiftCamera()
local a=self.playerNum
local u,w=getPlayerScreenLeft(a),getPlayerScreenWidth(a)
local P=getPlayerScreenTop(a)+getPlayerScreenHeight(a)/2
local B=self:getX()+self.shell.x
local s
if self.position==SpiffBoy.ConsolePosition.LEFT then
s=(B+n*self.shell.scale+S(a,u+w))/2
elseif self.position==SpiffBoy.ConsolePosition.CENTRE then
s=u+w/2
else
s=(u+B)/2
end
SpiffBoy.CameraShift.begin(self.playerObj,s,P)
end

function SpiffBoyHandheldWindow:isOnFrame(u,w)
local a,s=self.shell:toLocal(u,w)
if a>=0 and a<n and s>=0 and s<o then
return true
end
if A(a,s,h,self:jackArt())or A(a,s,k,self:linkArt())then
return true
end
return O(a,s,self.switchOn)~=nil
end

function SpiffBoyHandheldWindow:onMouseDown(u,w)
if self:putAwayOutsideFrame(u,w)then
return false
end
if isGamePaused()then
return self:isWantMouseEvents()
end
local B,s=self.shell:toLocal(u,w)
local a=O(B,s,self.switchOn)
if a=="power"then
self.mouseControl=nil
self:togglePower()
return self:isWantMouseEvents()
end
if a=="volume"then
self.mouseControl=nil
self.volumeDrag={startY=s,startStep=self.volumeStep,moved=false}
return self:isWantMouseEvents()
end
self.mouseControl=a
if a then
am(a,B,s,a9,self.input)
end
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:releaseMouse()
self.mouseControl=nil
self:releaseVolume()
end

function SpiffBoyHandheldWindow:onMouseUp(a,s)
self:releaseMouse()
return self:isWantMouseEvents()
end

function SpiffBoyHandheldWindow:onMouseUpOutside(a,s)
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
local s=math.floor((a.startY-u)/aA)
if s~=0 then
a.moved=true
end
self:setVolumeStep(a.startStep+s)
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

function SpiffBoyHandheldWindow:readMouse(s)
local a=self.mouseControl
if not a then
return
end
if not isMouseButtonDown(W)then
self.mouseControl=nil
return
end
local u,w=self.shell:toLocal(self:getMouseX(),self:getMouseY())
am(a,u,w,ba,s.held)
end

function SpiffBoyHandheldWindow:drainBattery()
self.battery=self.battery-SpiffBoy.Handheld.BATTERY_PER_MINUTE/aM*getGameTime():getTrueMultiplier()
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
local a,s=self:consoleAction()
self:updateJackMotion(a,s)
self:updateLinkMotion(a,s)
self:updateSlotMotion(a,s)
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
u:sprite(self.textures[G],0,0,n,o)
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

function SpiffBoyHandheldWindow:noiseRange(s)
local a=self:volume()
if s:getRoom()then
return r.roomFloor+math.floor(r.baseRange*r.roomShare*a)
end
return r.outsideFloor+math.floor(r.baseRange*a)
end

function SpiffBoyHandheldWindow:makeNoise()
if isGamePaused()then
return
end
self.noiseCounter=self.noiseCounter-r.drain*getGameTime():getMultiplier()
if self.noiseCounter>0 then
return
end
self.noiseCounter=r.period
local s=self:volume()
local u=self.playerObj
local a=u:getCurrentSquare()
if not self.powered or s<=0 or not a or self:hasHeadphones()or not SpiffBoy.Sandbox.noiseAttractsZombies()then
return
end
addSound(u,a:getX(),a:getY(),a:getZ(),self:noiseRange(a),math.floor(r.loudness*s))
end

function SpiffBoyHandheldWindow:drawGlass()
local a=self.screen
local s=aC
if self.powered or self.flickerFrames>0 then
s=j
end
local w=a.scale
local u=math.floor(w*au)
self.shell.calls=self.shell.calls+1
self:drawRect(a.x-u,a.y-u,a.width*w+2*u,a.height*w+2*u,1,s.r,s.g,s.b)
end

function SpiffBoyHandheldWindow:onMouseWheel(a)
if isGamePaused()then
return false
end
local s,u=self.shell:toLocal(self:getMouseX(),self:getMouseY())
if O(s,u,self.switchOn)~="volume"then
return false
end
self:turnVolume(-a)
return true
end

function SpiffBoyHandheldWindow:volume()
return self.volumeStep/z
end

function SpiffBoyHandheldWindow:turnVolume(a)
self:setVolumeStep(self.volumeStep+a)
end

function SpiffBoyHandheldWindow:setVolumeStep(a)
a=SpiffBoy.clamp(a,0,z)
if a==self.volumeStep then
return
end
self.volumeStep=a
self.volumeDirty=true
self.speaker:setVolume(self:volume())
self.link:setVolume(self:volume())
SpiffBoy.Audio.playSound(az)
end

function SpiffBoyHandheldWindow:togglePower()
SpiffBoy.Audio.playSound(aw)
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
self.flickerFrames=aF
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
self.boot=SpiffBoyBootScreen.new(self.screenArt(aT),self.chip,not self.definition)
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
local s=self.screen.width
local u=self.screen.height
local a={}
for B=1,aN do
local w=ZombRand(aO,aP+1)
a[#a+1]={x=ZombRand(s),y=ZombRand(u),w=w,h=1,shade=ZombRand(ac)+1}
end
for w=1,aQ do
a[#a+1]={x=ZombRand(s),y=ZombRand(u),w=ZombRand(1,aR+1),h=1,shade=ZombRand(ac)+1}
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

function SpiffBoyHandheldWindow:writeHardware(a)
SpiffBoyClientActions.saveHandheld(self.playerObj,self.console,a,self.battery,self:volume())
self.batteryDirty=false
self.volumeDirty=false
end

function SpiffBoyHandheldWindow:persistHardware()
if not self.batteryDirty and not self.volumeDirty then
return
end
self:writeHardware(nil)
end

function SpiffBoyHandheldWindow:persistSave(a)
self:writeHardware(a)
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

function SpiffBoyHandheldWindow:frame(s)
local a=self.screen
a:beginFrame()
s(self,a)
a:endFrame()
end

local function ar(s,a)
a:clear(j.r,j.g,j.b)
end

local function bd(u,a)
a:clear(j.r,j.g,j.b)
local s=a:lineHeight()
a:textCentre(getText("UI_SpiffBoy_GameMissing"),a.width/2,(a.height-s)/2,q.r,q.g,q.b,1)
end

local function be(u,w)
local B=SpiffBoy.Cartridges.SHADES
for P,a in ipairs(u.glitch)do
local s=B[a.shade]
w:rect(a.x,a.y,a.w,a.h,s.r,s.g,s.b,1)
end
end

local function bf(bg,a)
local s=aS
local Q=a:lineHeight()
local B=a:wrapText(getText("UI_SpiffBoy_LinkLost"),s.width-s.padding*2)
local u=#B*Q+s.padding*2
local P=math.floor((a.width-s.width)/2)
local w=math.floor((a.height-u)/2)
a:rect(P,w,s.width,u,q.r,q.g,q.b,1)
a:rect(P+1,w+1,s.width-2,u-2,j.r,j.g,j.b,1)
a:rect(P+2,w+2,s.width-4,u-4,q.r,q.g,q.b,1)
for R=1,#B do
a:textCentre(B[R],a.width/2,w+s.padding+(R-1)*Q,j.r,j.g,j.b,1)
end
end

function SpiffBoyHandheldWindow:drawScreen()
local a=self.runtime
if a.crash then
self:frame(ar)
elseif a.game then
a:draw()
elseif self.gameMissing then
self:frame(bd)
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
local s=self
local u={
seed=SpiffBoy.newSeed(),
definition=self.definition,
art=self.gameArt,
chip=self.chip,
sequencer=self.sequencer,
link=self.channel:view(),
save=SpiffBoy.Handheld.recordSave(self.record),
persist=function(u)
s:persistSave(u)
end,
}
self.runtime:start(a,u)
end

function SpiffBoyHandheldWindow:blinkOn()
return math.floor(getTimestampMs()/aD)%2==0
end

function SpiffBoyHandheldWindow:drawControls()
local a=self.shell
local s=self.textures
local u=self.input.held
local Q,R=self.input:axes()
local bg=(R+1)*t+(Q+1)
a:sprite(s[I[bg]],g.x-g.size/2,g.y-g.size/2,g.size,g.size)
local w=0
if u.a then
w=1
end
local B=0
if u.b then
B=1
end
a:sprite(s[J.a[w]],C.x-v/2,C.y-x/2,v,x)
a:sprite(s[J.b[B]],D.x-v/2,D.y-x/2,v,x)
local P=0
if u.start then
P=1
end
a:sheet(s[ah],P*m.w,0,m.w,m.h,m.x-m.w/2,m.y-m.h/2)
self:drawLed(self:ledFrame())
end

function SpiffBoyHandheldWindow:ledFrame()
if self.powered then
if self.battery<=aB and not self:blinkOn()then
return X
end
return E
end
if self.flickerFrames>0 then
return E
end
return Y
end

function SpiffBoyHandheldWindow:drawLed(a)
self.shell:sheet(self.textures[ae],a*p.size,0,p.size,p.size,p.x-p.size/2,p.y-p.size/2)
end

function SpiffBoyHandheldWindow:ambientLight(s)
local a=s:getLightLevel(self.playerNum)
if self.playerObj:hasTrait(CharacterTrait.NIGHT_VISION)then
a=a+aH
end
return SpiffBoy.clamp(a,0,1)
end

local function bg()
return getGameTime():getWorldAgeHours()*aK
end

function SpiffBoyHandheldWindow:logLight(a)
if not SpiffBoy.isDevBuild()then
return
end
local s=bg()
if s<self.nextLightLogMinutes then
return
end
self.nextLightLogMinutes=s+aJ
SpiffBoy.log("light "..tostring(self.light).." target "..tostring(self.veilTarget).." veil "..tostring(self.veil).." raw "..tostring(a:getLightLevel(self.playerNum)).." setting "..tostring(SandboxVars.NightDarkness).." room "..tostring(a:isInARoom()).." hour "..tostring(getGameTime():getTimeOfDay()))
end

function SpiffBoyHandheldWindow:measureLight()
local a=self.playerObj:getCurrentSquare()
if not a then
return false
end
local s=self:ambientLight(a)
self.light=s
self.veilTarget=SpiffBoy.clamp((ab-s)/(ab-aG),0,1)
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
self.veil=self.veil+(self.veilTarget-self.veil)*aI
end

function SpiffBoyHandheldWindow:drawVeil()
self:updateVeil()
local a=self.veil
if a==nil or a<=0 then
return
end
local w=self.shell
self:drawSideControlsWith(ak,a)
local u=self.textures[G]
local B=p.x-c.size/2
local s=p.y-c.size/2
local P=B+c.size
local Q=s+c.size
w:tintedSheet(u,0,0,n,s,0,0,0,0,0,a)
w:tintedSheet(u,0,Q,n,o-Q,0,Q,0,0,0,a)
w:tintedSheet(u,0,s,B,c.size,0,s,0,0,0,a)
w:tintedSheet(u,P,s,n-P,c.size,P,s,0,0,0,a)
self:drawSlotVeil(a)
self:drawPortsVeil(a)
local R=self:ledFrame()
self:drawLampLight(u,R,a,B,s)
if R~=Y then
self:drawLed(R)
end
end

function SpiffBoyHandheldWindow:drawLampLight(bh,R,s,u,w)
local B=self.shell
local a=0
if R==E then
a=c.strength*s^c.curve
elseif R==X then
a=c.strength*c.dim*s^c.curve
end
local P=s*(1-a)
local Q=0
if P<1 then
Q=1-(1-s)/(1-P)
end
B:tintedSheet(bh,u,w,c.size,c.size,u,w,0,0,0,P)
if Q>0 then
B:sprite(self.textures[af],u,w,c.size,c.size,Q)
end
if a>0 then
B:sprite(self.textures[ag],u,w,c.size,c.size,c.red*a/c.strength)
end
end

function SpiffBoyHandheldWindow:drawSideControls()
self:drawSideControlsWith(aj,0)
end

function SpiffBoyHandheldWindow:drawSideControlsWith(a,s)
local u=self.shell
local w=e.offY
if self.switchOn then
w=e.onY
end
a(u,s,self.textures[ad],e.x-y,w-y,e.w+F+2*y,e.h+2*y)
a(u,s,self.textures[K[self.volumeStep]],d.x-F,d.y,d.w+F,d.h)
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
for s,a in pairs(SpiffBoyHandheldWindow.instances)do
if a.hidden then
a:step()
end
end
end

local function s()
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
Events.OnMouseDown.Add(s)
Events.OnRightMouseDown.Add(s)
