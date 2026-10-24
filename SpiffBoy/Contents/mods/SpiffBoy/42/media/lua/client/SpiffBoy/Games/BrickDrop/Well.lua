require"SpiffBoy/Core/Core"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local a={}
a.__index=a
SpiffBoy.BrickDrop.Well=a

a.EMPTY=0
a.KIND_COUNT=7
a.GARBAGE=8
a.PIECES={
{{{0,1},{1,1},{2,1},{3,1}},{{2,0},{2,1},{2,2},{2,3}}},
{{{1,0},{2,0},{1,1},{2,1}}},
{{{1,0},{0,1},{1,1},{2,1}},{{1,0},{1,1},{2,1},{1,2}},{{0,1},{1,1},{2,1},{1,2}},{{1,0},{0,1},{1,1},{1,2}}},
{{{1,0},{2,0},{0,1},{1,1}},{{1,0},{1,1},{2,1},{2,2}}},
{{{0,0},{1,0},{1,1},{2,1}},{{2,0},{1,1},{2,1},{1,2}}},
{{{0,0},{0,1},{1,1},{2,1}},{{1,0},{2,0},{1,1},{1,2}},{{0,1},{1,1},{2,1},{2,2}},{{1,0},{1,1},{0,2},{1,2}}},
{{{2,0},{0,1},{1,1},{2,1}},{{1,0},{1,1},{1,2},{2,2}},{{0,1},{1,1},{2,1},{0,2}},{{0,0},{1,0},{1,1},{1,2}}},
}

local e={0,-1,1,-2,2}

function a.rotationCount(kind)
return#a.PIECES[kind]
end

function a.cells(kind,rotation)
return a.PIECES[kind][rotation]
end

function a.new(columns,rows)
local b=setmetatable({},a)
b.columns=columns
b.rows=rows
b.grid={}
b:clear()
return b
end

function a:clear()
for b=0,self.columns*self.rows-1 do
self.grid[b]=a.EMPTY
end
end

function a:at(column,row)
return self.grid[row*self.columns+column]
end

function a:set(column,row,value)
self.grid[row*self.columns+column]=value
end

function a:fits(kind,rotation,x,y)
local d=a.PIECES[kind][rotation]
for f=1,4 do
local b=x+d[f][1]
local c=y+d[f][2]
if b<0 or b>=self.columns or c>=self.rows then
return false
end
if c>=0 and self:at(b,c)~=a.EMPTY then
return false
end
end
return true
end

function a:kick(kind,rotation,x,y)
for b=1,#e do
if self:fits(kind,rotation,x+e[b],y)then
return e[b]
end
end
return nil
end

function a:landing(kind,rotation,x,y)
while self:fits(kind,rotation,x,y+1)do
y=y+1
end
return y
end

function a:place(kind,rotation,x,y)
local b=a.PIECES[kind][rotation]
local c=true
for d=1,4 do
local f=y+b[d][2]
if f>=0 then
self:set(x+b[d][1],f,kind)
else
c=false
end
end
return c
end

function a:isFull(row)
for b=0,self.columns-1 do
if self:at(b,row)==a.EMPTY then
return false
end
end
return true
end

function a:fullRows()
local b,d={},{}
for c=0,self.rows-1 do
if self:isFull(c)then
b[#b+1]=c
d[c]=true
end
end
return b,d
end

function a:collapse()
local c,b=self:fullRows()
return self:removeRows(b)
end

function a:removeRows(set)
local c=0
local b=self.rows-1
for d=self.rows-1,0,-1 do
if set[d]then
c=c+1
else
if b~=d then
for f=0,self.columns-1 do
self:set(f,b,self:at(f,d))
end
end
b=b-1
end
end
for d=b,0,-1 do
for f=0,self.columns-1 do
self:set(f,d,a.EMPTY)
end
end
return c
end

function a:top()
for b=0,self.rows-1 do
for c=0,self.columns-1 do
if self:at(c,b)~=a.EMPTY then
return b
end
end
end
return self.rows
end

function a:columnTop(column)
for b=0,self.rows-1 do
if self:at(column,b)~=a.EMPTY then
return b
end
end
return self.rows
end

function a:fillGarbage(count,random)
for d=self.rows-count,self.rows-1 do
local f=random:int(0,self.columns-1)
for b=0,self.columns-1 do
if b~=f and random:chance(0.6)then
self:set(b,d,a.GARBAGE)
end
end
local b=0
for c=0,self.columns-1 do
if self:at(c,d)~=a.EMPTY then
b=b+1
end
end
local c=0
while b<math.floor(self.columns/2)do
if c~=f and self:at(c,d)==a.EMPTY then
self:set(c,d,a.GARBAGE)
b=b+1
end
c=c+1
end
end
end

function a.newBag(random)
local b={items={},index=a.KIND_COUNT+1}
function b.draw()
if b.index>a.KIND_COUNT then
for c=1,a.KIND_COUNT do
b.items[c]=c
end
for c=a.KIND_COUNT,2,-1 do
local d=random:int(1,c)
b.items[c],b.items[d]=b.items[d],b.items[c]
end
b.index=1
end
local c=b.items[b.index]
b.index=b.index+1
return c
end
return b
end
