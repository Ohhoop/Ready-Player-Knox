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

local i={{2,2},{3,2},{2,3}}
local j=5
local h="exit"

function a.distance(b,c,d,e)
return math.abs(b-d)+math.abs(c-e)
end

local function k(c,d)
for e,b in ipairs(i)do
if b[1]==c and b[2]==d then
return true
end
end
return false
end

function a.new(e,g,l,m)
local b=setmetatable({},a)
b.columns=e
b.rows=g
b.cells={}
b.hidden={}
b.items={}
b.breaking={}
b.exitIndex=nil
b.exitShown=false
b.exitOpen=false
for c=1,g do
for d=1,e do
local f=a.EMPTY
if d==1 or c==1 or d==e or c==g then
f=a.WALL
elseif d%2==1 and c%2==1 then
f=a.PILLAR
elseif not k(d,c)and m:chance(l)then
f=a.CRATE
end
b.cells[(c-1)*e+d]=f
end
end
return b
end

function a:index(b,c)
return(c-1)*self.columns+b
end

function a:cellOf(b)
local c=math.floor((b-1)/self.columns)+1
return b-(c-1)*self.columns,c
end

function a:kind(b,c)
if b<1 or c<1 or b>self.columns or c>self.rows then
return a.WALL
end
return self.cells[(c-1)*self.columns+b]
end

function a:isSolid(b,c)
return self:kind(b,c)~=a.EMPTY
end

function a:isCrate(c,d)
local b=self:kind(c,d)
return b==a.CRATE or b==a.BREAKING
end

function a:isHard(c,d)
local b=self:kind(c,d)
return b==a.WALL or b==a.PILLAR
end

function a:freeCrates(d)
local b={}
for c,e in ipairs(self.cells)do
if e==a.CRATE and not self.hidden[c]then
local f,g=self:cellOf(c)
if a.distance(f,g,a.START.column,a.START.row)>=d then
b[#b+1]=c
end
end
end
return b
end

function a:addCrate(e,f)
local b=self:emptyCells(a.START.column,a.START.row,f)
local c=b[e:int(1,#b)]
local d=self:index(c[1],c[2])
self.cells[d]=a.CRATE
return d
end

function a:hide(f,d,e)
local c=self:freeCrates(e)
local b
if#c>0 then
b=c[d:int(1,#c)]
else
b=self:addCrate(d,e)
end
self.hidden[b]=f
return b
end

function a:hideExit(b)
self.exitIndex=self:hide(h,b,j)
end

function a:revealExit(c,d)
local b=self:index(c,d)
self.cells[b]=a.EMPTY
self.items[b]=nil
self.exitIndex=b
self.exitShown=true
self.exitOpen=true
end

function a:emptyCells(e,f,g)
local b={}
for l,m in ipairs(self.cells)do
if m==a.EMPTY then
local c,d=self:cellOf(l)
if a.distance(c,d,e,f)>=g then
b[#b+1]={c,d}
end
end
end
return b
end

function a:breakCrate(c,d)
local b=self:index(c,d)
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
if c==h then
self.exitShown=true
elseif c then
self.items[b.index]=c
end
end
end
end

function a:itemAt(b,c)
return self.items[self:index(b,c)]
end

function a:takeItem(c,d)
local b=self:index(c,d)
local e=self.items[b]
self.items[b]=nil
return e
end

function a:isExit(b,c)
return self.exitShown and self.exitIndex==self:index(b,c)
end
