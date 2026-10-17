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

function a.rotationCount(b)
return#a.PIECES[b]
end

function a.cells(b,c)
return a.PIECES[b][c]
end

function a.new(c,d)
local b=setmetatable({},a)
b.columns=c
b.rows=d
b.grid={}
b:clear()
return b
end

function a:clear()
for b=0,self.columns*self.rows-1 do
self.grid[b]=a.EMPTY
end
end

function a:at(b,c)
return self.grid[c*self.columns+b]
end

function a:set(b,c,d)
self.grid[c*self.columns+b]=d
end

function a:fits(g,h,i,j)
local d=a.PIECES[g][h]
for f=1,4 do
local b=i+d[f][1]
local c=j+d[f][2]
if b<0 or b>=self.columns or c>=self.rows then
return false
end
if c>=0 and self:at(b,c)~=a.EMPTY then
return false
end
end
return true
end

function a:kick(c,d,f,g)
for b=1,#e do
if self:fits(c,d,f+e[b],g)then
return e[b]
end
end
return nil
end

function a:landing(c,d,f,b)
while self:fits(c,d,f,b+1)do
b=b+1
end
return b
end

function a:place(b,h,i,j)
local c=a.PIECES[b][h]
local d=true
for f=1,4 do
local g=j+c[f][2]
if g>=0 then
self:set(i+c[f][1],g,b)
else
d=false
end
end
return d
end

function a:isFull(b)
for c=0,self.columns-1 do
if self:at(c,b)==a.EMPTY then
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

function a:removeRows(g)
local c=0
local b=self.rows-1
for d=self.rows-1,0,-1 do
if g[d]then
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

function a:columnTop(c)
for b=0,self.rows-1 do
if self:at(c,b)~=a.EMPTY then
return b
end
end
return self.rows
end

function a:fillGarbage(h,f)
for d=self.rows-h,self.rows-1 do
local g=f:int(0,self.columns-1)
for b=0,self.columns-1 do
if b~=g and f:chance(0.6)then
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
if c~=g and self:at(c,d)==a.EMPTY then
self:set(c,d,a.GARBAGE)
b=b+1
end
c=c+1
end
end
end

function a.newBag(f)
local b={items={},index=a.KIND_COUNT+1}
function b.draw()
if b.index>a.KIND_COUNT then
for c=1,a.KIND_COUNT do
b.items[c]=c
end
for c=a.KIND_COUNT,2,-1 do
local d=f:int(1,c)
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
