require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Rounds"
require"SpiffBoy/Games/BrickBash/Music"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local n=SpiffBoy.BrickBash.Rounds
local j=SpiffBoy.BrickBash.Music

local a={}
a.__index=a
SpiffBoy.BrickBash.Field=a

a.LEFT=4
a.RIGHT=176
a.TOP=16
a.BOTTOM=120
a.BRICKS_LEFT=6
a.BRICKS_TOP=22
a.CELL_W=12
a.CELL_H=6

local s=n.KINDS
local g=n.COLUMNS
local d=a.CELL_W
local f=a.CELL_H
local t=8
local u=0.25
local e={width=14,height=10,frames=3,ticks=5,shades={1,3}}
local i={row=8,fall=12}
local v={{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}

function a.new(definition)
local b=setmetatable({},a)
b.rows={}
b.remaining=0
b.bursts={}
local k={}
for h,c in ipairs(definition.moving)do
k[c]=true
end
for l,o in ipairs(definition.rows)do
local m={cells={},offset=0,direction=1,moving=k[l]or false}
for h=1,g do
local p=string.sub(o,h,h)
local c=s[p]
if c then
m.cells[h]={kind=c,hits=c.hits,shine=0}
if not c.unbreakable then
b.remaining=b.remaining+1
end
end
end
b.rows[l]=m
end
return b
end

local function z(row)
local b,h=nil,nil
for c=1,g do
if row.cells[c]then
b=b or c
h=c
end
end
return b,h
end

function a:update()
for m,b in ipairs(self.rows)do
if b.moving then
local c,l=z(b)
if c then
local h=-(c-1)*d
local k=(g-l)*d
b.offset=b.offset+u*b.direction
if b.offset<=h then
b.offset=h
b.direction=1
elseif b.offset>=k then
b.offset=k
b.direction=-1
end
end
end
for h=1,g do
local c=b.cells[h]
if c and c.shine>0 then
c.shine=c.shine-1
end
end
end
for c=#self.bursts,1,-1 do
local b=self.bursts[c]
b.timer=b.timer+1
if b.timer>=e.frames*e.ticks then
table.remove(self.bursts,c)
end
end
end

function a:cellPosition(r,c)
local b=self.rows[r]
return a.BRICKS_LEFT+(c-1)*d+math.floor(b.offset),a.BRICKS_TOP+(r-1)*f
end

function a:overlap(x,y,w,h)
local m=math.max(1,math.floor((y-a.BRICKS_TOP)/f)+1)
local o=math.min(#self.rows,math.floor((y+h-1-a.BRICKS_TOP)/f)+1)
for b=m,o do
local c=self.rows[b]
local k=a.BRICKS_LEFT+math.floor(c.offset)
local p=math.max(1,math.floor((x-k)/d)+1)
local q=math.min(g,math.floor((x+w-1-k)/d)+1)
for l=p,q do
if c.cells[l]then
return b,l
end
end
end
return nil
end

function a:remove(r,c,world)
local b=self.rows[r].cells[c]
self.rows[r].cells[c]=nil
self.remaining=self.remaining-1
world:addScore(b.kind.points)
local h,k=self:cellPosition(r,c)
self.bursts[#self.bursts+1]={x=h+d/2-e.width/2,y=k+f/2-e.height/2,timer=0}
end

function a:explode(r,c,world)
local b={{r,c}}
self:remove(r,c,world)
local h=1
while h<=#b do
local o=b[h]
h=h+1
for w,p in ipairs(v)do
local k,l=o[1]+p[2],o[2]+p[1]
local q=self.rows[k]
local m=q and q.cells[l]
if m and not m.kind.unbreakable then
self:remove(k,l,world)
if m.kind.explosive then
b[#b+1]={k,l}
end
end
end
end
world:effect(j.EXPLODE)
end

function a:strike(r,c,world)
local b=self.rows[r].cells[c]
local h=b.kind
if h.unbreakable then
b.shine=t
world:effect(j.METAL)
return
end
if h.explosive then
self:explode(r,c,world)
return
end
b.hits=b.hits-1
if b.hits>0 then
world:effect(j.TOUGH)
return
end
local k,l=self:cellPosition(r,c)
self:remove(r,c,world)
world:effect(j.BRICK)
world:brickBroken(k+d/2,l+f/2)
end

local function h(brick)
local b=brick.kind
if b.cells then
return b.cells[brick.hits],b.shades
end
if brick.shine>0 then
return b.shineCell,b.shineShades
end
return b.cell,b.shades
end

function a:buildTicks()
return#self.rows*i.row+i.fall
end

function a:landedRows(elapsed)
return SpiffBoy.clamp(math.floor((elapsed-i.fall)/i.row)+1,0,#self.rows)
end

function a:drawRow(screen,bricks,r,row,drop)
for b=1,g do
local c=row.cells[b]
if c then
local k,l=h(c)
local m,o=self:cellPosition(r,b)
screen:layers(bricks,k*d,d,f,m,o-drop,l)
end
end
end

function a:drawBuilding(screen,bricks,elapsed)
local k=#self.rows
for b,l in ipairs(self.rows)do
local m=(k-b)*i.row
local c=(elapsed-m)/i.fall
if c>0 then
local q,o=self:cellPosition(b,1)
local p=math.floor((o-a.TOP+f)*(1-math.min(1,c)))
self:drawRow(screen,bricks,b,l,p)
end
end
end

function a:draw(screen,bricks,burst)
for b,c in ipairs(self.rows)do
self:drawRow(screen,bricks,b,c,0)
end
for k,b in ipairs(self.bursts)do
local c=math.floor(b.timer/e.ticks)
screen:layers(burst,c*e.width,e.width,e.height,b.x,b.y,e.shades)
end
end
