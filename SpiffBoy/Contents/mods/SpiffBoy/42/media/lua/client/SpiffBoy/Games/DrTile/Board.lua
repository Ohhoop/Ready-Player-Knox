require"SpiffBoy/Core/Core"

SpiffBoy.DrTile=SpiffBoy.DrTile or{}

local a={}
a.__index=a
SpiffBoy.DrTile.Board=a

a.EMPTY=0
a.GLITCH=1
a.HALF=2
a.COLOURS=3
a.LINK_NONE=0
a.LINK_RIGHT=1
a.LINK_LEFT=2
a.LINK_DOWN=3
a.LINK_UP=4
a.MATCH=4
a.MAX_LEVEL=20

local j=3
local p=4
local q={{level=19,rows=13},{level=17,rows=12},{level=15,rows=11},{level=0,rows=10}}

function a.patchCells(b,c,d)
if d==0 then
return b,c,b+1,c
elseif d==1 then
return b,c-1,b,c
elseif d==2 then
return b+1,c,b,c
end
return b,c,b,c-1
end

function a.isFlat(b)
return b==0 or b==2
end

function a.new(c,d)
local b=setmetatable({},a)
b.columns=c
b.rows=d
b.kind={}
b.colour={}
b.link={}
b:clear()
return b
end

function a:key(b,c)
return c*self.columns+b
end

function a:clear()
for b=0,self.columns*self.rows-1 do
self.kind[b]=a.EMPTY
self.colour[b]=0
self.link[b]=a.LINK_NONE
end
end

function a:inside(b,c)
return b>=0 and b<self.columns and c>=0 and c<self.rows
end

function a:kindAt(b,c)
return self.kind[self:key(b,c)]
end

function a:colourAt(b,c)
return self.colour[self:key(b,c)]
end

function a:linkAt(b,c)
return self.link[self:key(b,c)]
end

function a:free(b,c)
if b<0 or b>=self.columns or c>=self.rows then
return false
end
return c<0 or self:kindAt(b,c)==a.EMPTY
end

function a:set(c,d,e,f,g)
local b=self:key(c,d)
self.kind[b]=e
self.colour[b]=f
self.link[b]=g
end

function a:empty(b,c)
self:set(b,c,a.EMPTY,0,a.LINK_NONE)
end

function a:move(c,d,e,f)
local b=self:key(c,d)
self:set(e,f,self.kind[b],self.colour[b],self.link[b])
self:empty(c,d)
end

function a:fits(b,c,d)
local e,f,g,h=a.patchCells(b,c,d)
return self:free(e,f)and self:free(g,h)
end

function a.patchLinks(b)
if b==0 then
return a.LINK_RIGHT,a.LINK_LEFT
elseif b==1 then
return a.LINK_DOWN,a.LINK_UP
elseif b==2 then
return a.LINK_LEFT,a.LINK_RIGHT
end
return a.LINK_UP,a.LINK_DOWN
end

function a:place(e,f,b,g,h)
local i,c,k,d=a.patchCells(e,f,b)
if c<0 or d<0 then
return false
end
local l,m=a.patchLinks(b)
self:set(i,c,a.HALF,g,l)
self:set(k,d,a.HALF,h,m)
return true
end

function a:runThrough(g,h,i,e,f)
local d=1
local b,c=g+e,h+f
while self:inside(b,c)and self:colourAt(b,c)==i do
d=d+1
b,c=b+e,c+f
end
b,c=g-e,h-f
while self:inside(b,c)and self:colourAt(b,c)==i do
d=d+1
b,c=b-e,c-f
end
return d
end

function a:makesRun(b,c,d)
return self:runThrough(b,c,d,1,0)>=j or self:runThrough(b,c,d,0,1)>=j
end

function a.glitchesFor(b)
return(math.min(b,a.MAX_LEVEL)+1)*p
end

function a.heightFor(c)
for d,b in ipairs(q)do
if c>=b.level then
return b.rows
end
end
end

function a:putGlitch(b,c,e)
for f=0,a.COLOURS-1 do
local d=(e-1+f)%a.COLOURS+1
if not self:makesRun(b,c,d)then
self:set(b,c,a.GLITCH,d,a.LINK_NONE)
return true
end
end
return false
end

function a:shuffledEmpty(e,f,g)
local b={}
for c=e,f do
for d=0,self.columns-1 do
if self:kindAt(d,c)==a.EMPTY then
b[#b+1]=self:key(d,c)
end
end
end
for c=#b,2,-1 do
local d=g:int(1,c)
b[c],b[d]=b[d],b[c]
end
return b
end

function a:scatter(e,f,g,h,i)
local b=0
local c=self:shuffledEmpty(e,f,i)
for k=1,#c do
if b>=g then
break
end
local d=c[k]
local l=d%self.columns
local m=math.floor(d/self.columns)
if self:putGlitch(l,m,(h+b)%a.COLOURS+1)then
b=b+1
end
end
return b
end

function a:fillGlitches(b,c)
local d=self.rows-math.min(a.heightFor(b),self.rows)
return self:scatter(d,self.rows-1,a.glitchesFor(b),0,c)
end

function a:glitchCounts()
local b={}
for c=1,a.COLOURS do
b[c]=0
end
for c=0,self.columns*self.rows-1 do
if self.kind[c]==a.GLITCH then
local d=self.colour[c]
b[d]=b[d]+1
end
end
return b
end

function a:highestRow()
for b=0,self.rows-1 do
for c=0,self.columns-1 do
if self:kindAt(c,b)~=a.EMPTY then
return b
end
end
end
return self.rows
end

function a:collectRuns(k,r,d)
local l,f=self.rows,self.columns
if d==1 then
l,f=self.columns,self.rows
end
local g=0
for e=0,l-1 do
local b=0
while b<f do
local h,i=b,e
if d==1 then
h,i=e,b
end
local m=self:colourAt(h,i)
local c=b+1
if m~=0 then
while c<f do
local n,o=c,e
if d==1 then
n,o=e,c
end
if self:colourAt(n,o)~=m then
break
end
c=c+1
end
if c-b>=a.MATCH then
for n=b,c-1 do
local o=self:key(h+(n-b)*r,i+(n-b)*d)
if not k[o]then
k[o]=true
g=g+1
end
end
end
end
b=c
end
end
return g
end

function a:matches()
local b={}
local c=self:collectRuns(b,1,0)
c=c+self:collectRuns(b,0,1)
return b,c
end

function a:partnerOf(b,c)
local d=self:linkAt(b,c)
if d==a.LINK_RIGHT then
return b+1,c
elseif d==a.LINK_LEFT then
return b-1,c
elseif d==a.LINK_DOWN then
return b,c+1
elseif d==a.LINK_UP then
return b,c-1
end
return nil
end

function a:remove(g)
local b=0
for c=0,self.rows-1 do
for d=0,self.columns-1 do
local e=self:key(d,c)
if g[e]then
if self.kind[e]==a.GLITCH then
b=b+1
elseif self.kind[e]==a.HALF then
local f,h=self:partnerOf(d,c)
if f and not g[self:key(f,h)]then
self.link[self:key(f,h)]=a.LINK_NONE
end
end
self:empty(d,c)
end
end
end
return b
end

function a:settle()
local e=false
for b=self.rows-2,0,-1 do
for c=0,self.columns-1 do
if self:kindAt(c,b)==a.HALF then
local d=self:linkAt(c,b)
if d==a.LINK_NONE or d==a.LINK_UP then
if self:free(c,b+1)then
self:move(c,b,c,b+1)
if d==a.LINK_UP then
self:move(c,b-1,c,b)
end
e=true
end
elseif d==a.LINK_RIGHT then
if self:free(c,b+1)and self:free(c+1,b+1)then
self:move(c,b,c,b+1)
self:move(c+1,b,c+1,b+1)
e=true
end
end
end
end
end
return e
end

function a:rise(e,b)
for c=0,self.columns-1 do
if self:kindAt(c,0)~=a.EMPTY then
return false
end
end
for c=1,self.rows-1 do
for d=0,self.columns-1 do
self:move(d,c,d,c-1)
end
end
local c=self.rows-1
self:scatter(c,c,e,b:int(0,a.COLOURS-1),b)
return true
end
