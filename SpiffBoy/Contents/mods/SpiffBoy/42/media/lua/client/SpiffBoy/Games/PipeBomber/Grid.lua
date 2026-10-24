require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"

local a={}
a.__index=a
SpiffBoy.PipeBomber.Grid=a

a.EMPTY=0
a.WALL=1
a.PILLAR=2
a.CRATE=3
a.BREAKING=4
a.BREAK_TICKS=24
a.START={column=2,row=2}

local g={{2,2},{3,2},{2,3}}
local h=5
local f="exit"

function a.distance(c1,r1,c2,r2)
return math.abs(c1-c2)+math.abs(r1-r2)
end

local function i(column,row)
for c,b in ipairs(g)do
if b[1]==column and b[2]==row then
return true
end
end
return false
end

function a.new(columns,rows,crateShare,random)
local b=setmetatable({},a)
b.columns=columns
b.rows=rows
b.cells={}
b.hidden={}
b.items={}
b.breaking={}
b.exitIndex=nil
b.exitShown=false
b.exitOpen=false
for c=1,rows do
for d=1,columns do
local e=a.EMPTY
if d==1 or c==1 or d==columns or c==rows then
e=a.WALL
elseif d%2==1 and c%2==1 then
e=a.PILLAR
elseif not i(d,c)and random:chance(crateShare)then
e=a.CRATE
end
b.cells[(c-1)*columns+d]=e
end
end
return b
end

function a:index(column,row)
return(row-1)*self.columns+column
end

function a:cellOf(index)
local b=math.floor((index-1)/self.columns)+1
return index-(b-1)*self.columns,b
end

function a:kind(column,row)
if column<1 or row<1 or column>self.columns or row>self.rows then
return a.WALL
end
return self.cells[(row-1)*self.columns+column]
end

function a:isSolid(column,row)
return self:kind(column,row)~=a.EMPTY
end

function a:isCrate(column,row)
local b=self:kind(column,row)
return b==a.CRATE or b==a.BREAKING
end

function a:isHard(column,row)
local b=self:kind(column,row)
return b==a.WALL or b==a.PILLAR
end

function a:freeCrates(minDistance)
local b={}
for c,d in ipairs(self.cells)do
if d==a.CRATE and not self.hidden[c]then
local e,j=self:cellOf(c)
if a.distance(e,j,a.START.column,a.START.row)>=minDistance then
b[#b+1]=c
end
end
end
return b
end

function a:addCrate(random,minDistance)
local b=self:emptyCells(a.START.column,a.START.row,minDistance)
local c=b[random:int(1,#b)]
local d=self:index(c[1],c[2])
self.cells[d]=a.CRATE
return d
end

function a:hide(what,random,minDistance)
local c=self:freeCrates(minDistance)
local b
if#c>0 then
b=c[random:int(1,#c)]
else
b=self:addCrate(random,minDistance)
end
self.hidden[b]=what
return b
end

function a:hideExit(random)
self.exitIndex=self:hide(f,random,h)
end

function a:revealExit(column,row)
local b=self:index(column,row)
self.cells[b]=a.EMPTY
self.items[b]=nil
self.exitIndex=b
self.exitShown=true
self.exitOpen=true
end

function a:emptyCells(column,row,minDistance)
local b={}
for e,j in ipairs(self.cells)do
if j==a.EMPTY then
local c,d=self:cellOf(e)
if a.distance(c,d,column,row)>=minDistance then
b[#b+1]={c,d}
end
end
end
return b
end

function a:breakCrate(column,row)
local b=self:index(column,row)
if self.cells[b]~=a.CRATE then
return false
end
self.cells[b]=a.BREAKING
self.breaking[#self.breaking+1]={index=b,timer=a.BREAK_TICKS}
return true
end

function a:update()
for d=#self.breaking,1,-1 do
local b=self.breaking[d]
b.timer=b.timer-1
if b.timer<=0 then
table.remove(self.breaking,d)
self.cells[b.index]=a.EMPTY
local c=self.hidden[b.index]
self.hidden[b.index]=nil
if c==f then
self.exitShown=true
elseif c then
self.items[b.index]=c
end
end
end
end

function a:itemAt(column,row)
return self.items[self:index(column,row)]
end

function a:takeItem(column,row)
local b=self:index(column,row)
local c=self.items[b]
self.items[b]=nil
return c
end

function a:isExit(column,row)
return self.exitShown and self.exitIndex==self:index(column,row)
end
