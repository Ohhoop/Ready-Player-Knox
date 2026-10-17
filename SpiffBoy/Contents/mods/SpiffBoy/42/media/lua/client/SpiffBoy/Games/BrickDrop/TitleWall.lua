require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickDrop/Well"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local c=SpiffBoy.BrickDrop.Well

local a={}
a.__index=a
SpiffBoy.BrickDrop.TitleWall=a

local r=1
local g=18
local m=6
local s=3
local t=8
local u=7
local v=0.5
local w=0.3
local x=0.6

function a.new(d,e,f,h,i)
local b=setmetatable({},a)
b.random=d
b.cell=h
b.dropHeight=i
b.well=c.new(e,f)
b.bag=c.newBag(d)
b.piece=nil
b.flashRows=nil
b.flashTimer=0
b.spawnTimer=g
return b
end

function a:rate(n,o,p,e)
local b=self.well
local f=c.cells(n,o)
for d=1,4 do
if e+f[d][2]<0 then
return nil
end
end
b:place(n,o,p,e)
local h=0
for d=0,b.rows-1 do
if b:isFull(d)then
h=h+1
end
end
local i,j,k,l=0,0,0,nil
for q=0,b.columns-1 do
local d=b:columnTop(q)
j=j+(b.rows-d)
for y=d+1,b.rows-1 do
if b:at(q,y)==c.EMPTY then
i=i+1
end
end
if l then
k=k+math.abs(d-l)
end
l=d
end
for d=1,4 do
b:set(p+f[d][1],e+f[d][2],c.EMPTY)
end
return h*t-i*u-j*v-k*w+self.random:float()*x
end

function a:spawn()
local b=self.bag.draw()
local h=self.well
local d,k,l,i=nil,nil,nil,nil
for e=1,c.rotationCount(b)do
for f=-2,h.columns-1 do
if h:fits(b,e,f,-4)then
local n=h:landing(b,e,f,-4)
local j=self:rate(b,e,f,n)
if j and(not d or j>d)then
d,k,l,i=j,e,f,n
end
end
end
end
if not d then
return false
end
self.piece={kind=b,rotation=k,x=l,row=i,offset=-self.dropHeight-i*self.cell}
return true
end

function a:startFlash(b)
self.flashRows=b
self.flashTimer=m*s*2
end

function a:flashAll()
local b={}
for d=0,self.well.rows-1 do
for e=0,self.well.columns-1 do
if self.well:at(e,d)~=c.EMPTY then
b[d]=true
break
end
end
end
self:startFlash(b)
end

function a:tick()
if self.flashRows then
self.flashTimer=self.flashTimer-1
if self.flashTimer<=0 then
self.well:removeRows(self.flashRows)
self.flashRows=nil
self.spawnTimer=g
end
return nil
end
local b=self.piece
if b then
b.offset=b.offset+r
if b.offset<0 then
return nil
end
self.well:place(b.kind,b.rotation,b.x,b.row)
self.piece=nil
self.spawnTimer=g
local d,e=self.well:fullRows()
if#d>0 then
self:startFlash(e)
return"row"
end
return"land"
end
self.spawnTimer=self.spawnTimer-1
if self.spawnTimer<=0 and not self:spawn()then
self:flashAll()
return"row"
end
return nil
end

function a:rowHidden(b)
if not self.flashRows or not self.flashRows[b]then
return false
end
return math.floor(self.flashTimer/m)%2==1
end

function a:draw(f,h,l,n)
local d,e=self.well,self.cell
for b=0,d.rows-1 do
if not self:rowHidden(b)then
local i={}
for j=0,d.columns-1 do
i[j+1]=d:at(j,b)~=c.EMPTY
end
l(f,h+b*e,b,i)
end
end
local b=self.piece
if b then
local i=c.cells(b.kind,b.rotation)
for j=1,4 do
local k=b.row+i[j][2]
n(f+(b.x+i[j][1])*e,h+k*e+b.offset,k)
end
end
end
