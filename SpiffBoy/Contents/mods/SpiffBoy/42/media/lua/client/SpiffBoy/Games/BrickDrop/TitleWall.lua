require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickDrop/Well"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local c=SpiffBoy.BrickDrop.Well

local a={}
a.__index=a
SpiffBoy.BrickDrop.TitleWall=a

local o=1
local g=18
local l=6
local p=3
local q=8
local r=7
local s=0.5
local t=0.3
local u=0.6

function a.new(random,columns,rows,cell,dropHeight)
local b=setmetatable({},a)
b.random=random
b.cell=cell
b.dropHeight=dropHeight
b.well=c.new(columns,rows)
b.bag=c.newBag(random)
b.piece=nil
b.flashRows=nil
b.flashTimer=0
b.spawnTimer=g
return b
end

function a:rate(kind,rotation,x,y)
local b=self.well
local e=c.cells(kind,rotation)
for d=1,4 do
if y+e[d][2]<0 then
return nil
end
end
b:place(kind,rotation,x,y)
local f=0
for d=0,b.rows-1 do
if b:isFull(d)then
f=f+1
end
end
local h,i,j,k=0,0,0,nil
for m=0,b.columns-1 do
local d=b:columnTop(m)
i=i+(b.rows-d)
for n=d+1,b.rows-1 do
if b:at(m,n)==c.EMPTY then
h=h+1
end
end
if k then
j=j+math.abs(d-k)
end
k=d
end
for d=1,4 do
b:set(x+e[d][1],y+e[d][2],c.EMPTY)
end
return f*q-h*r-i*s-j*t+self.random:float()*u
end

function a:spawn()
local b=self.bag.draw()
local h=self.well
local d,k,m,i=nil,nil,nil,nil
for e=1,c.rotationCount(b)do
for f=-2,h.columns-1 do
if h:fits(b,e,f,-4)then
local n=h:landing(b,e,f,-4)
local j=self:rate(b,e,f,n)
if j and(not d or j>d)then
d,k,m,i=j,e,f,n
end
end
end
end
if not d then
return false
end
self.piece={kind=b,rotation=k,x=m,row=i,offset=-self.dropHeight-i*self.cell}
return true
end

function a:startFlash(rows)
self.flashRows=rows
self.flashTimer=l*p*2
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
b.offset=b.offset+o
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

function a:rowHidden(row)
if not self.flashRows or not self.flashRows[row]then
return false
end
return math.floor(self.flashTimer/l)%2==1
end

function a:draw(left,top,rowPainter,brickPainter)
local d,e=self.well,self.cell
for b=0,d.rows-1 do
if not self:rowHidden(b)then
local f={}
for h=0,d.columns-1 do
f[h+1]=d:at(h,b)~=c.EMPTY
end
rowPainter(left,top+b*e,b,f)
end
end
local b=self.piece
if b then
local f=c.cells(b.kind,b.rotation)
for h=1,4 do
local i=b.row+f[h][2]
brickPainter(left+(b.x+f[h][1])*e,top+i*e+b.offset,i)
end
end
end
