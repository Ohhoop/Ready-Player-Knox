require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/KeyBinds"

SpiffBoy.Input=SpiffBoy.Input or{}
local a=SpiffBoy.Input
local i=SpiffBoy.KeyBinds

a.ACTIONS=i.BUTTONS
a.EXIT_KEY=Keyboard.KEY_ESCAPE

local c=0.45
local f="exit"

local d={}
for b=1,#a.ACTIONS do
d[b]=a.ACTIONS[b]
end
d[#d+1]=f

local g={}
for e,b in ipairs(a.ACTIONS)do
g[b]={Keyboard.KEY_NONE,Keyboard.KEY_NONE}
end

function a.refreshProfile()
local b=getCore()
for k,e in ipairs(a.ACTIONS)do
local h=g[e]
local j=i.BINDS[e].id
h[1]=b:getKey(j)
h[2]=b:getAltKey(j)
end
end

function a.actionForKey(key)
for h,b in ipairs(a.ACTIONS)do
local e=g[b]
if e[1]==key or e[2]==key then
return b
end
end
return nil
end

function a.isConsumedKey(key)
return key==a.EXIT_KEY or a.actionForKey(key)~=nil
end

function a.readKeyboard(state)
local e=state.held
for j,b in ipairs(a.ACTIONS)do
local h=g[b]
e[b]=e[b]or isKeyDown(h[1])or isKeyDown(h[2])
end
end

local j=nil

local function m(key,action,down)
if not SpiffBoy.isDevBuild()then
return
end
local b=tostring(key).." "..tostring(action).." "..tostring(down)
if b~=j then
j=b
SpiffBoy.log("run key "..tostring(key).." action "..tostring(action).." down "..tostring(down).." client "..tostring(isClient()))
end
end

function a.readRunExit(state)
local b=getCore():getKey(KeybindId.RUN)
local e=a.actionForKey(b)
local h=isKeyDown(b)
m(b,e,h)
if b~=Keyboard.KEY_NONE and e==nil and h then
state.held.exit=true
end
end

function a.readJoypad(joypadId,state)
local b=state.held
local e=getJoypadMovementAxisX(joypadId)
local h=getJoypadMovementAxisY(joypadId)
local k=getControllerPovX(joypadId)
local l=getControllerPovY(joypadId)
b.up=b.up or h<-c or l<-c
b.down=b.down or h>c or l>c
b.left=b.left or e<-c or k<-c
b.right=b.right or e>c or k>c
b.a=b.a or JoypadButton.A:isDown(joypadId)
b.b=b.b or JoypadButton.B:isDown(joypadId)
b.start=b.start or JoypadButton.Start:isDown(joypadId)
b.exit=b.exit or JoypadButton.X:isDown(joypadId)or isJoypadLTPressed(joypadId)
end

SpiffBoyInputState={}
SpiffBoyInputState.__index=SpiffBoyInputState

function SpiffBoyInputState.new()
local b=setmetatable({},SpiffBoyInputState)
b.held={}
b.previous={}
b.pressed={}
b.tapped={}
for h,e in ipairs(d)do
b.held[e]=false
b.previous[e]=false
b.pressed[e]=false
end
for h,e in ipairs(a.ACTIONS)do
b.tapped[e]=false
end
b.exitThisReading=false
return b
end

function SpiffBoyInputState:clearHeld()
local b=self.held
for h,e in ipairs(d)do
b[e]=false
end
self.exitThisReading=false
end

function SpiffBoyInputState:tap(action)
if self.tapped[action]~=nil then
self.tapped[action]=true
end
end

function SpiffBoyInputState:latch()
local h,k,e,l=self.held,self.previous,self.pressed,self.tapped
for n,b in ipairs(d)do
e[b]=(h[b]and not k[b])or l[b]==true
k[b]=h[b]
end
e[f]=e[f]or self.exitThisReading
self.exitThisReading=e[f]
for n,b in ipairs(a.ACTIONS)do
l[b]=false
end
end

function SpiffBoyInputState:axes()
local h=self.held
local b,e=0,0
if h.left then
b=b-1
end
if h.right then
b=b+1
end
if h.up then
e=e-1
end
if h.down then
e=e+1
end
return b,e
end
