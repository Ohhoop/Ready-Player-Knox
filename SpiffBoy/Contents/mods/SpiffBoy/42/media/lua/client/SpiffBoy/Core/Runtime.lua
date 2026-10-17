require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Clock"
require"SpiffBoy/Core/PixelFont"

SpiffBoyScreen={}
SpiffBoyScreen.__index=SpiffBoyScreen

local c=SpiffBoy.PixelFont
local l=math.floor

local z=10
local A=48

SpiffBoyScreen.MAX_CALLS=300
local B={"clear","rect","sprite","tinted","sheet","layers","rotated","number","text","textCentre","textRight","textWidth","wrapText","lineHeight"}

local function e(a)
return a~=nil and a:isReady()
end

local function a(d,b)
if d.wholePixels then
return l(b)
end
return b
end

local function d(b)
if b.calls>=SpiffBoyScreen.MAX_CALLS then
error("SpiffBoy: a frame went past "..SpiffBoyScreen.MAX_CALLS.." draw calls")
end
b.calls=b.calls+1
end

function SpiffBoyScreen.new(f,g,h)
local b=setmetatable({},SpiffBoyScreen)
b.owner=f
b.width=g
b.height=h
b.x=0
b.y=0
b.scale=1
b.calls=0
b.palette=nil
b.wholePixels=false
return b
end

function SpiffBoyScreen:setWholePixels(b)
self.wholePixels=b
end

function SpiffBoyScreen:setPalette(b)
self.palette=b
end

function SpiffBoyScreen:paint(f,g,h,q)
local i=self.palette
if not i then
return f,g,h,q or 1
end
local j,k=i[1],nil
for r=1,#i do
local b=i[r]
if b.r==f and b.g==g and b.b==h then
return f,g,h,1
end
local m,n,o=b.r-f,b.g-g,b.b-h
local p=m*m+n*n+o*o
if not k or p<k then
j,k=b,p
end
end
return j.r,j.g,j.b,1
end

function SpiffBoyScreen:tint(f,h)
local g=self.palette
if not g then
return 1,1,1,h or 1
end
local b=g[f or 1]
if not b then
error("SpiffBoy: the palette of the screen has no shade "..tostring(f))
end
return b.r,b.g,b.b,1
end

function SpiffBoyScreen:setPlacement(b,f,g)
self.x=b
self.y=f
self.scale=g
end

function SpiffBoyScreen:toLocal(b,f)
return(b-self.x)/self.scale,(f-self.y)/self.scale
end

function SpiffBoyScreen:beginFrame()
self.calls=0
self.owner:setStencilRect(self.x,self.y,self.width*self.scale,self.height*self.scale)
end

function SpiffBoyScreen:endFrame()
self.owner:clearStencilRect()
end

function SpiffBoyScreen:clear(b,f,g)
b,f,g=self:paint(b,f,g,1)
d(self)
self.owner:drawRect(self.x,self.y,self.width*self.scale,self.height*self.scale,1,b,f,g)
end

function SpiffBoyScreen:rect(f,g,h,i,j,k,m,n)
local b=self.scale
f,g,h,i=a(self,f),a(self,g),a(self,h),a(self,i)
j,k,m,n=self:paint(j,k,m,n)
d(self)
self.owner:drawRect(self.x+f*b,self.y+g*b,h*b,i*b,n,j,k,m)
end

function SpiffBoyScreen:sprite(b,g,h,i,j,k,p)
if not e(b)then
return
end
local f=self.scale
g,h=a(self,g),a(self,h)
i,j=a(self,i or b:getWidth()),a(self,j or b:getHeight())
local m,n,o
m,n,o,k=self:tint(p,k)
d(self)
self.owner:drawTextureScaled(b,self.x+g*f,self.y+h*f,i*f,j*f,k,m,n,o)
end

function SpiffBoyScreen:tinted(b,g,h,i,j,k,m,n,o)
if not e(b)then
return
end
local f=self.scale
g,h=a(self,g),a(self,h)
i,j=a(self,i or b:getWidth()),a(self,j or b:getHeight())
k,m,n,o=self:paint(k,m,n,o)
d(self)
self.owner:drawTextureScaled(b,self.x+g*f,self.y+h*f,i*f,j*f,o,k,m,n)
end

function SpiffBoyScreen:sheet(i,p,q,j,k,f,g,h,r)
if not e(i)then
return
end
local b=self.scale
f,g=a(self,f),a(self,g)
local m,n,o
m,n,o,h=self:tint(r,h)
d(self)
self.owner:drawSubTexture(i,p,q,j,k,self.x+f*b,self.y+g*b,j*b,k*b,h,m,n,o)
end

function SpiffBoyScreen:tintedSheet(m,p,q,n,o,f,g,h,i,j,k)
if not e(m)then
return
end
local b=self.scale
f,g=a(self,f),a(self,g)
h,i,j,k=self:paint(h,i,j,k)
d(self)
self.owner:drawSubTexture(m,p,q,n,o,self.x+f*b,self.y+g*b,n*b,o*b,k,h,i,j)
end

local function p(b,h,i,j,f,k,m,n,o,g)
local q,r,s,t=b:tint(g,1)
d(b)
b.owner:drawSubTexture(h,i,(g-1)*f,j,f,k,m,n,o,t,q,r,s)
end

function SpiffBoyScreen:layers(f,j,g,h,q,r,i)
if not e(f)then
return
end
local b=self.scale
local k,m=self.x+a(self,q)*b,self.y+a(self,r)*b
local n,o=g*b,h*b
if i then
for s=1,#i do
p(self,f,j,g,h,k,m,n,o,i[s])
end
return
end
local s=self.palette and#self.palette or 1
for t=1,s do
p(self,f,j,g,h,k,m,n,o,t)
end
end

function SpiffBoyScreen:rotated(q,m,n,C,D,E,o,F)
if not e(q)then
return
end
local b=self.scale
local r=math.rad(C)
local s,t=math.cos(r),math.sin(r)
local u,v=D/2,E/2
m,n=a(self,m),a(self,n)
local f,g=self.x+m*b,self.y+n*b
local h,i=u*s*b,u*t*b
local j,k=-v*t*b,v*s*b
local w,x,y
w,x,y,o=self:tint(F,o)
d(self)
self.owner:drawTextureAllPoint(q,
f-h-j,g-i-k,
f+h-j,g+i-k,
f+h+j,g+i+k,
f-h+j,g-i+k,
w,x,y,o)
end

function SpiffBoyScreen:number(o,i,q,g,m,r,s)
if not g then
return
end
local h=tostring(l(o))
local b=string.len(h)
local j=(r or 0)-b
if j>0 then
h=string.rep("0",j)..h
b=b+j
end
local f=g:getWidth()/z
local t=g:getHeight()
local k=i
if m=="right"then
k=i-b*f
elseif m=="centre"then
k=i-b*f/2
end
for n=1,b do
local u=string.byte(h,n)-A
self:sheet(g,u*f,0,f,t,k+(n-1)*f,q,1,s)
end
end

function SpiffBoyScreen:text(r,s,t,h,i,j,k)
h,i,j,k=self:paint(h or 1,i or 1,j or 1,k)
local g=self.scale
local u=self.owner
local n=c.shape(r)
local v,w=c.origin(a(self,s),a(self,t))
local o,q=c.CELL_WIDTH,c.CELL_HEIGHT
local x,y=o*g,q*g
local m,f=nil,nil
for C=1,#n do
local b=n[C]
if b.page then
if b.page~=m then
m=b.page
f=c.pageTexture(m)
if not e(f)then
f=nil
end
end
if f then
d(self)
u:drawSubTexture(f,b.cellX,b.cellY,o,q,self.x+(v+b.x)*g,self.y+(w-b.y)*g,x,y,k,h,i,j)
end
end
end
end

function SpiffBoyScreen:textCentre(b,f,g,h,i,j,k)
self:text(b,f-l(c.measure(b)/2),g,h,i,j,k)
end

function SpiffBoyScreen:textRight(b,f,g,h,i,j,k)
self:text(b,f-c.measure(b),g,h,i,j,k)
end

function SpiffBoyScreen:textWidth(b)
return c.measure(b)
end

function SpiffBoyScreen:wrapText(b,f)
return c.wrap(b,f)
end

function SpiffBoyScreen:lineHeight()
return c.LINE_HEIGHT
end

SpiffBoyRuntime={}
SpiffBoyRuntime.__index=SpiffBoyRuntime

local function i(b)
local f=setmetatable({width=b.width,height=b.height},{
__index=function(g,f)
if f=="calls"then
return b.calls
end
return nil
end,
})
for j,g in ipairs(B)do
local h=SpiffBoyScreen[g]
f[g]=function(k,...)
return h(b,...)
end
end
return setmetatable({},{
__index=f,
__newindex=function()
error("a game cannot change the screen of the console")
end,
__metatable=false,
})
end

function SpiffBoyRuntime.new(f)
local b=setmetatable({},SpiffBoyRuntime)
b.screen=f
b.view=i(f)
b.game=nil
b.devices={}
b.clock=SpiffBoyClock.new()
b.tick=0
b.ticksThisFrame=0
b.frameMs=0
b.crash=nil
b.onCrash=nil
return b
end

function SpiffBoyRuntime:setGame(b)
self.game=b
self.crash=nil
self.clock:reset()
self.tick=0
self.ticksThisFrame=0
end

function SpiffBoyRuntime:setDevices(b)
self.devices=b
end

function SpiffBoyRuntime:fail(b,f,g)
self.crash={stage=b,message=tostring(g)}
SpiffBoy.log("the game "..tostring(f).." crashed in "..b..": "..self.crash.message)
if self.onCrash then
self.onCrash(self.crash)
end
end

function SpiffBoyRuntime:start(b,g)
self:setGame(nil)
local h,f=pcall(b.new,b,self,g)
if h then
self:setGame(f)
return true
end
self:fail("init",b.Type,f)
return false
end

function SpiffBoyRuntime:guard(b,f,...)
local g,h=pcall(f,self.game,...)
if g then
return true
end
self:fail(b,self.game.Type,h)
return false
end

function SpiffBoyRuntime:advance(b,j,k)
local f=UIManager.getMillisSinceLastRender()
self.frameMs=f
self.ticksThisFrame=0
if not self.game or j or self.crash then
return
end
local m=self.clock:advance(f,k)
local g=self.devices
for o=1,m do
self.tick=self.tick+1
local h=b[1]
if h then
h:latch()
end
if not self:guard("tick",self.game.tick,b,self.tick)then
return
end
for n=1,#g do
g[n]:step()
end
self.ticksThisFrame=self.ticksThisFrame+1
end
end

function SpiffBoyRuntime:draw()
local b=self.screen
b:beginFrame()
if self.game and not self.crash then
self:guard("draw",self.game.draw,self.view)
end
b:endFrame()
end
