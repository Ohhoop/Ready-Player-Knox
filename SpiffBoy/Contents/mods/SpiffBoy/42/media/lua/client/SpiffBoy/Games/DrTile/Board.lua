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

local i=3
local n=4
local o={{level=19,rows=13},{level=17,rows=12},{level=15,rows=11},{level=0,rows=10}}

function a.patchCells(x,y,orientation)
if orientation==0 then
return x,y,x+1,y
elseif orientation==1 then
return x,y-1,x,y
elseif orientation==2 then
return x+1,y,x,y
end
return x,y,x,y-1
end

function a.isFlat(orientation)
return orientation==0 or orientation==2
end

function a.new(columns,rows)
local b=setmetatable({},a)
b.columns=columns
b.rows=rows
b.kind={}
b.colour={}
b.link={}
b:clear()
return b
end

function a:key(column,row)
return row*self.columns+column
end

function a:clear()
for b=0,self.columns*self.rows-1 do
self.kind[b]=a.EMPTY
self.colour[b]=0
self.link[b]=a.LINK_NONE
end
end

function a:inside(column,row)
return column>=0 and column<self.columns and row>=0 and row<self.rows
end

function a:kindAt(column,row)
return self.kind[self:key(column,row)]
end

function a:colourAt(column,row)
return self.colour[self:key(column,row)]
end

function a:linkAt(column,row)
return self.link[self:key(column,row)]
end

function a:free(column,row)
if column<0 or column>=self.columns or row>=self.rows then
return false
end
return row<0 or self:kindAt(column,row)==a.EMPTY
end

function a:set(column,row,kind,colour,link)
local b=self:key(column,row)
self.kind[b]=kind
self.colour[b]=colour
self.link[b]=link
end

function a:empty(column,row)
self:set(column,row,a.EMPTY,0,a.LINK_NONE)
end

function a:move(column,row,toColumn,toRow)
local b=self:key(column,row)
self:set(toColumn,toRow,self.kind[b],self.colour[b],self.link[b])
self:empty(column,row)
end

function a:fits(x,y,orientation)
local b,c,d,e=a.patchCells(x,y,orientation)
return self:free(b,c)and self:free(d,e)
end

function a.patchLinks(orientation)
if orientation==0 then
return a.LINK_RIGHT,a.LINK_LEFT
elseif orientation==1 then
return a.LINK_DOWN,a.LINK_UP
elseif orientation==2 then
return a.LINK_LEFT,a.LINK_RIGHT
end
return a.LINK_UP,a.LINK_DOWN
end

function a:place(x,y,orientation,first,second)
local d,b,e,c=a.patchCells(x,y,orientation)
if b<0 or c<0 then
return false
end
local f,g=a.patchLinks(orientation)
self:set(d,b,a.HALF,first,f)
self:set(e,c,a.HALF,second,g)
return true
end

function a:runThrough(column,row,colour,dx,dy)
local d=1
local b,c=column+dx,row+dy
while self:inside(b,c)and self:colourAt(b,c)==colour do
d=d+1
b,c=b+dx,c+dy
end
b,c=column-dx,row-dy
while self:inside(b,c)and self:colourAt(b,c)==colour do
d=d+1
b,c=b-dx,c-dy
end
return d
end

function a:makesRun(column,row,colour)
return self:runThrough(column,row,colour,1,0)>=i or self:runThrough(column,row,colour,0,1)>=i
end

function a.glitchesFor(level)
return(math.min(level,a.MAX_LEVEL)+1)*n
end

function a.heightFor(level)
for c,b in ipairs(o)do
if level>=b.level then
return b.rows
end
end
end

function a:putGlitch(column,row,preferred)
for c=0,a.COLOURS-1 do
local b=(preferred-1+c)%a.COLOURS+1
if not self:makesRun(column,row,b)then
self:set(column,row,a.GLITCH,b,a.LINK_NONE)
return true
end
end
return false
end

function a:shuffledEmpty(top,bottom,random)
local b={}
for c=top,bottom do
for d=0,self.columns-1 do
if self:kindAt(d,c)==a.EMPTY then
b[#b+1]=self:key(d,c)
end
end
end
for c=#b,2,-1 do
local d=random:int(1,c)
b[c],b[d]=b[d],b[c]
end
return b
end

function a:scatter(top,bottom,wanted,offset,random)
local b=0
local c=self:shuffledEmpty(top,bottom,random)
for e=1,#c do
if b>=wanted then
break
end
local d=c[e]
local f=d%self.columns
local g=math.floor(d/self.columns)
if self:putGlitch(f,g,(offset+b)%a.COLOURS+1)then
b=b+1
end
end
return b
end

function a:fillGlitches(level,random)
local b=self.rows-math.min(a.heightFor(level),self.rows)
return self:scatter(b,self.rows-1,a.glitchesFor(level),0,random)
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

function a:collectRuns(set,dx,dy)
local j,e=self.rows,self.columns
if dy==1 then
j,e=self.columns,self.rows
end
local f=0
for d=0,j-1 do
local b=0
while b<e do
local g,h=b,d
if dy==1 then
g,h=d,b
end
local k=self:colourAt(g,h)
local c=b+1
if k~=0 then
while c<e do
local l,m=c,d
if dy==1 then
l,m=d,c
end
if self:colourAt(l,m)~=k then
break
end
c=c+1
end
if c-b>=a.MATCH then
for l=b,c-1 do
local m=self:key(g+(l-b)*dx,h+(l-b)*dy)
if not set[m]then
set[m]=true
f=f+1
end
end
end
end
b=c
end
end
return f
end

function a:matches()
local b={}
local c=self:collectRuns(b,1,0)
c=c+self:collectRuns(b,0,1)
return b,c
end

function a:partnerOf(column,row)
local b=self:linkAt(column,row)
if b==a.LINK_RIGHT then
return column+1,row
elseif b==a.LINK_LEFT then
return column-1,row
elseif b==a.LINK_DOWN then
return column,row+1
elseif b==a.LINK_UP then
return column,row-1
end
return nil
end

function a:remove(set)
local b=0
for c=0,self.rows-1 do
for d=0,self.columns-1 do
local e=self:key(d,c)
if set[e]then
if self.kind[e]==a.GLITCH then
b=b+1
elseif self.kind[e]==a.HALF then
local f,g=self:partnerOf(d,c)
if f and not set[self:key(f,g)]then
self.link[self:key(f,g)]=a.LINK_NONE
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

function a:rise(count,random)
for b=0,self.columns-1 do
if self:kindAt(b,0)~=a.EMPTY then
return false
end
end
for b=1,self.rows-1 do
for c=0,self.columns-1 do
self:move(c,b,c,b-1)
end
end
local b=self.rows-1
self:scatter(b,b,count,random:int(0,a.COLOURS-1),random)
return true
end
