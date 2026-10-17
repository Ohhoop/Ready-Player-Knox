require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/KeyBinds"

SpiffBoy.Input=SpiffBoy.Input or{}
local a=SpiffBoy.Input
local i=SpiffBoy.KeyBinds

a.ACTIONS=i.BUTTONS
a.EXIT_KEY=Keyboard.KEY_ESCAPE

local d=0.45
local f="exit"

local e={}
for b=1,#a.ACTIONS do
e[b]=a.ACTIONS[b]
end
e[#e+1]=f

local g={}
for c,b in ipairs(a.ACTIONS)do
g[b]={Keyboard.KEY_NONE,Keyboard.KEY_NONE}
end

function a.refreshProfile()
local b=getCore()
for k,c in ipairs(a.ACTIONS)do
local h=g[c]
local j=i.BINDS[c].id
h[1]=b:getKey(j)
h[2]=b:getAltKey(j)
end
end

function a.actionForKey(b)
for j,c in ipairs(a.ACTIONS)do
local h=g[c]
if h[1]==b or h[2]==b then
return c
end
end
return nil
end

function a.isConsumedKey(b)
return b==a.EXIT_KEY or a.actionForKey(b)~=nil
end

function a.readKeyboard(j)
local c=j.held
for k,b in ipairs(a.ACTIONS)do
local h=g[b]
c[b]=c[b]or isKeyDown(h[1])or isKeyDown(h[2])
end
end

local j=nil

local function n(b,c,h)
if not SpiffBoy.isDevBuild()then
return
end
local k=tostring(b).." "..tostring(c).." "..tostring(h)
if k~=j then
j=k
SpiffBoy.log("run key "..tostring(b).." action "..tostring(c).." down "..tostring(h).." client "..tostring(isClient()))
end
end

function a.readRunExit(k)
local b=getCore():getKey(KeybindId.RUN)
local c=a.actionForKey(b)
local h=isKeyDown(b)
n(b,c,h)
if b~=Keyboard.KEY_NONE and c==nil and h then
k.held.exit=true
end
end

function a.readJoypad(c,o)
local b=o.held
local h=getJoypadMovementAxisX(c)
local k=getJoypadMovementAxisY(c)
local l=getControllerPovX(c)
local m=getControllerPovY(c)
b.up=b.up or k<-d or m<-d
b.down=b.down or k>d or m>d
b.left=b.left or h<-d or l<-d
b.right=b.right or h>d or l>d
b.a=b.a or JoypadButton.A:isDown(c)
b.b=b.b or JoypadButton.B:isDown(c)
b.start=b.start or JoypadButton.Start:isDown(c)
b.exit=b.exit or JoypadButton.X:isDown(c)or isJoypadLTPressed(c)
end

SpiffBoyInputState={}
SpiffBoyInputState.__index=SpiffBoyInputState

function SpiffBoyInputState.new()
local b=setmetatable({},SpiffBoyInputState)
b.held={}
b.previous={}
b.pressed={}
b.tapped={}
for h,c in ipairs(e)do
b.held[c]=false
b.previous[c]=false
b.pressed[c]=false
end
for h,c in ipairs(a.ACTIONS)do
b.tapped[c]=false
end
b.exitThisReading=false
return b
end

function SpiffBoyInputState:clearHeld()
local b=self.held
for h,c in ipairs(e)do
b[c]=false
end
self.exitThisReading=false
end

function SpiffBoyInputState:tap(b)
if self.tapped[b]~=nil then
self.tapped[b]=true
end
end

function SpiffBoyInputState:latch()
local h,k,c,l=self.held,self.previous,self.pressed,self.tapped
for m,b in ipairs(e)do
c[b]=(h[b]and not k[b])or l[b]==true
k[b]=h[b]
end
c[f]=c[f]or self.exitThisReading
self.exitThisReading=c[f]
for m,b in ipairs(a.ACTIONS)do
l[b]=false
end
end

function SpiffBoyInputState:axes()
local h=self.held
local b,c=0,0
if h.left then
b=b-1
end
if h.right then
b=b+1
end
if h.up then
c=c-1
end
if h.down then
c=c+1
end
return b,c
end
