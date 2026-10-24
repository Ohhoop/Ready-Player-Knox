require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Clock"
require"SpiffBoy/Core/PixelFont"

SpiffBoyScreen={}
SpiffBoyScreen.__index=SpiffBoyScreen

local d=SpiffBoy.PixelFont
local n=math.floor

local z=10
local A=48

SpiffBoyScreen.MAX_CALLS=300
local B={"clear","rect","sprite","tinted","sheet","layers","rotated","number","text","textCentre","textRight","textWidth","wrapText","lineHeight"}

local function f(texture)
return texture~=nil and texture:isReady()
end

local function c(screen,value)
if screen.wholePixels then
return n(value)
end
return value
end

local function e(screen)
if screen.calls>=SpiffBoyScreen.MAX_CALLS then
error("SpiffBoy: a frame went past "..SpiffBoyScreen.MAX_CALLS.." draw calls")
end
screen.calls=screen.calls+1
end

function SpiffBoyScreen.new(owner,width,height)
local a=setmetatable({},SpiffBoyScreen)
a.owner=owner
a.width=width
a.height=height
a.x=0
a.y=0
a.scale=1
a.calls=0
a.palette=nil
a.wholePixels=false
return a
end

function SpiffBoyScreen:setWholePixels(enabled)
self.wholePixels=enabled
end

function SpiffBoyScreen:setPalette(shades)
self.palette=shades
end

function SpiffBoyScreen:paint(r,g,b,a)
local i=self.palette
if not i then
return r,g,b,a or 1
end
local j,k=i[1],nil
for q=1,#i do
local h=i[q]
if h.r==r and h.g==g and h.b==b then
return r,g,b,1
end
local l,m,o=h.r-r,h.g-g,h.b-b
local p=l*l+m*m+o*o
if not k or p<k then
j,k=h,p
end
end
return j.r,j.g,j.b,1
end

function SpiffBoyScreen:tint(shadeIndex,a)
local g=self.palette
if not g then
return 1,1,1,a or 1
end
local b=g[shadeIndex or 1]
if not b then
error("SpiffBoy: the palette of the screen has no shade "..tostring(shadeIndex))
end
return b.r,b.g,b.b,1
end

function SpiffBoyScreen:setPlacement(x,y,scale)
self.x=x
self.y=y
self.scale=scale
end

function SpiffBoyScreen:toLocal(x,y)
return(x-self.x)/self.scale,(y-self.y)/self.scale
end

function SpiffBoyScreen:beginFrame()
self.calls=0
self.owner:setStencilRect(self.x,self.y,self.width*self.scale,self.height*self.scale)
end

function SpiffBoyScreen:endFrame()
self.owner:clearStencilRect()
end

function SpiffBoyScreen:clear(r,g,b)
r,g,b=self:paint(r,g,b,1)
e(self)
self.owner:drawRect(self.x,self.y,self.width*self.scale,self.height*self.scale,1,r,g,b)
end

function SpiffBoyScreen:rect(x,y,w,h,r,g,b,a)
local i=self.scale
x,y,w,h=c(self,x),c(self,y),c(self,w),c(self,h)
r,g,b,a=self:paint(r,g,b,a)
e(self)
self.owner:drawRect(self.x+x*i,self.y+y*i,w*i,h*i,a,r,g,b)
end

function SpiffBoyScreen:sprite(texture,x,y,w,h,a,shadeIndex)
if not f(texture)then
return
end
local b=self.scale
x,y=c(self,x),c(self,y)
w,h=c(self,w or texture:getWidth()),c(self,h or texture:getHeight())
local g,i,j
g,i,j,a=self:tint(shadeIndex,a)
e(self)
self.owner:drawTextureScaled(texture,self.x+x*b,self.y+y*b,w*b,h*b,a,g,i,j)
end

function SpiffBoyScreen:tinted(texture,x,y,w,h,r,g,b,a)
if not f(texture)then
return
end
local i=self.scale
x,y=c(self,x),c(self,y)
w,h=c(self,w or texture:getWidth()),c(self,h or texture:getHeight())
r,g,b,a=self:paint(r,g,b,a)
e(self)
self.owner:drawTextureScaled(texture,self.x+x*i,self.y+y*i,w*i,h*i,a,r,g,b)
end

function SpiffBoyScreen:sheet(texture,sx,sy,sw,sh,x,y,a,shadeIndex)
if not f(texture)then
return
end
local b=self.scale
x,y=c(self,x),c(self,y)
local g,h,i
g,h,i,a=self:tint(shadeIndex,a)
e(self)
self.owner:drawSubTexture(texture,sx,sy,sw,sh,self.x+x*b,self.y+y*b,sw*b,sh*b,a,g,h,i)
end

function SpiffBoyScreen:tintedSheet(texture,sx,sy,sw,sh,x,y,r,g,b,a)
if not f(texture)then
return
end
local h=self.scale
x,y=c(self,x),c(self,y)
r,g,b,a=self:paint(r,g,b,a)
e(self)
self.owner:drawSubTexture(texture,sx,sy,sw,sh,self.x+x*h,self.y+y*h,sw*h,sh*h,a,r,g,b)
end

local function o(screen,texture,sx,sw,sh,left,top,width,height,shadeIndex)
local a,b,g,h=screen:tint(shadeIndex,1)
e(screen)
screen.owner:drawSubTexture(texture,sx,(shadeIndex-1)*sh,sw,sh,left,top,width,height,h,a,b,g)
end

function SpiffBoyScreen:layers(texture,sx,sw,sh,x,y,shadeIndexes)
if not f(texture)then
return
end
local a=self.scale
local b,g=self.x+c(self,x)*a,self.y+c(self,y)*a
local h,i=sw*a,sh*a
if shadeIndexes then
for j=1,#shadeIndexes do
o(self,texture,sx,sw,sh,b,g,h,i,shadeIndexes[j])
end
return
end
local j=self.palette and#self.palette or 1
for k=1,j do
o(self,texture,sx,sw,sh,b,g,h,i,k)
end
end

function SpiffBoyScreen:rotated(texture,cx,cy,degrees,w,h,a,shadeIndex)
if not f(texture)then
return
end
local b=self.scale
local p=math.rad(degrees)
local q,r=math.cos(p),math.sin(p)
local s,t=w/2,h/2
cx,cy=c(self,cx),c(self,cy)
local g,i=self.x+cx*b,self.y+cy*b
local j,k=s*q*b,s*r*b
local l,m=-t*r*b,t*q*b
local u,v,x
u,v,x,a=self:tint(shadeIndex,a)
e(self)
self.owner:drawTextureAllPoint(texture,
g-j-l,i-k-m,
g+j-l,i+k-m,
g+j+l,i+k+m,
g-j+l,i-k+m,
u,v,x,a)
end

function SpiffBoyScreen:number(value,x,y,digits,align,minDigits,shadeIndex)
if not digits then
return
end
local g=tostring(n(value))
local a=string.len(g)
local h=(minDigits or 0)-a
if h>0 then
g=string.rep("0",h)..g
a=a+h
end
local b=digits:getWidth()/z
local k=digits:getHeight()
local i=x
if align=="right"then
i=x-a*b
elseif align=="centre"then
i=x-a*b/2
end
for j=1,a do
local l=string.byte(g,j)-A
self:sheet(digits,l*b,0,b,k,i+(j-1)*b,y,1,shadeIndex)
end
end

function SpiffBoyScreen:text(str,x,y,r,g,b,a)
r,g,b,a=self:paint(r or 1,g or 1,b or 1,a)
local j=self.scale
local q=self.owner
local l=d.shape(str)
local s,t=d.origin(c(self,x),c(self,y))
local m,p=d.CELL_WIDTH,d.CELL_HEIGHT
local u,v=m*j,p*j
local k,i=nil,nil
for w=1,#l do
local h=l[w]
if h.page then
if h.page~=k then
k=h.page
i=d.pageTexture(k)
if not f(i)then
i=nil
end
end
if i then
e(self)
q:drawSubTexture(i,h.cellX,h.cellY,m,p,self.x+(s+h.x)*j,self.y+(t-h.y)*j,u,v,a,r,g,b)
end
end
end
end

function SpiffBoyScreen:textCentre(str,x,y,r,g,b,a)
self:text(str,x-n(d.measure(str)/2),y,r,g,b,a)
end

function SpiffBoyScreen:textRight(str,x,y,r,g,b,a)
self:text(str,x-d.measure(str),y,r,g,b,a)
end

function SpiffBoyScreen:textWidth(str)
return d.measure(str)
end

function SpiffBoyScreen:wrapText(str,maxWidth)
return d.wrap(str,maxWidth)
end

function SpiffBoyScreen:lineHeight()
return d.LINE_HEIGHT
end

SpiffBoyRuntime={}
SpiffBoyRuntime.__index=SpiffBoyRuntime

local function h(screen)
local a=setmetatable({width=screen.width,height=screen.height},{
__index=function(_,key)
if key=="calls"then
return screen.calls
end
return nil
end,
})
for i,b in ipairs(B)do
local g=SpiffBoyScreen[b]
a[b]=function(_,...)
return g(screen,...)
end
end
return setmetatable({},{
__index=a,
__newindex=function()
error("a game cannot change the screen of the console")
end,
__metatable=false,
})
end

function SpiffBoyRuntime.new(screen)
local a=setmetatable({},SpiffBoyRuntime)
a.screen=screen
a.view=h(screen)
a.game=nil
a.devices={}
a.clock=SpiffBoyClock.new()
a.tick=0
a.ticksThisFrame=0
a.frameMs=0
a.crash=nil
a.onCrash=nil
return a
end

function SpiffBoyRuntime:setGame(game)
self.game=game
self.crash=nil
self.clock:reset()
self.tick=0
self.ticksThisFrame=0
end

function SpiffBoyRuntime:setDevices(devices)
self.devices=devices
end

function SpiffBoyRuntime:fail(stage,gameType,message)
self.crash={stage=stage,message=tostring(message)}
SpiffBoy.log("the game "..tostring(gameType).." crashed in "..stage..": "..self.crash.message)
if self.onCrash then
self.onCrash(self.crash)
end
end

function SpiffBoyRuntime:start(gameClass,context)
self:setGame(nil)
local b,a=pcall(gameClass.new,gameClass,self,context)
if b then
self:setGame(a)
return true
end
self:fail("init",gameClass.Type,a)
return false
end

function SpiffBoyRuntime:guard(stage,method,...)
local a,b=pcall(method,self.game,...)
if a then
return true
end
self:fail(stage,self.game.Type,b)
return false
end

function SpiffBoyRuntime:advance(inputs,paused,rate)
local a=UIManager.getMillisSinceLastRender()
self.frameMs=a
self.ticksThisFrame=0
if not self.game or paused or self.crash then
return
end
local i=self.clock:advance(a,rate)
local b=self.devices
for k=1,i do
self.tick=self.tick+1
local g=inputs[1]
if g then
g:latch()
end
if not self:guard("tick",self.game.tick,inputs,self.tick)then
return
end
for j=1,#b do
b[j]:step()
end
self.ticksThisFrame=self.ticksThisFrame+1
end
end

function SpiffBoyRuntime:draw()
local a=self.screen
a:beginFrame()
if self.game and not self.crash then
self:guard("draw",self.game.draw,self.view)
end
a:endFrame()
end
