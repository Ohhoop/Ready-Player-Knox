require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickBash/Rounds"
require"SpiffBoy/Games/BrickBash/Music"

SpiffBoy.BrickBash=SpiffBoy.BrickBash or{}

local n=SpiffBoy.BrickBash.Rounds
local i=SpiffBoy.BrickBash.Music

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

local t=n.KINDS
local f=n.COLUMNS
local c=a.CELL_W
local e=a.CELL_H
local u=8
local v=0.25
local d={width=14,height=10,frames=3,ticks=5,shades={1,3}}
local g={row=8,fall=12}
local w={{-1,-1},{0,-1},{1,-1},{-1,0},{1,0},{-1,1},{0,1},{1,1}}

function a.new(k)
local b=setmetatable({},a)
b.rows={}
b.remaining=0
b.bursts={}
local l={}
for j,h in ipairs(k.moving)do
l[h]=true
end
for m,p in ipairs(k.rows)do
local o={cells={},offset=0,direction=1,moving=l[m]or false}
for j=1,f do
local q=string.sub(p,j,j)
local h=t[q]
if h then
o.cells[j]={kind=h,hits=h.hits,shine=0}
if not h.unbreakable then
b.remaining=b.remaining+1
end
end
end
b.rows[m]=o
end
return b
end

local function x(k)
local b,j=nil,nil
for h=1,f do
if k.cells[h]then
b=b or h
j=h
end
end
return b,j
end

function a:update()
for m,b in ipairs(self.rows)do
if b.moving then
local h,l=x(b)
if h then
local j=-(h-1)*c
local k=(f-l)*c
b.offset=b.offset+v*b.direction
if b.offset<=j then
b.offset=j
b.direction=1
elseif b.offset>=k then
b.offset=k
b.direction=-1
end
end
end
for j=1,f do
local h=b.cells[j]
if h and h.shine>0 then
h.shine=h.shine-1
end
end
end
for h=#self.bursts,1,-1 do
local b=self.bursts[h]
b.timer=b.timer+1
if b.timer>=d.frames*d.ticks then
table.remove(self.bursts,h)
end
end
end

function a:cellPosition(b,h)
local j=self.rows[b]
return a.BRICKS_LEFT+(h-1)*c+math.floor(j.offset),a.BRICKS_TOP+(b-1)*e
end

function a:overlap(b,h,o,p)
local q=math.max(1,math.floor((h-a.BRICKS_TOP)/e)+1)
local r=math.min(#self.rows,math.floor((h+p-1-a.BRICKS_TOP)/e)+1)
for j=q,r do
local k=self.rows[j]
local l=a.BRICKS_LEFT+math.floor(k.offset)
local s=math.max(1,math.floor((b-l)/c)+1)
local y=math.min(f,math.floor((b+o-1-l)/c)+1)
for m=s,y do
if k.cells[m]then
return j,m
end
end
end
return nil
end

function a:remove(b,h,j)
local k=self.rows[b].cells[h]
self.rows[b].cells[h]=nil
self.remaining=self.remaining-1
j:addScore(k.kind.points)
local l,m=self:cellPosition(b,h)
self.bursts[#self.bursts+1]={x=l+c/2-d.width/2,y=m+e/2-d.height/2,timer=0}
end

function a:explode(o,p,j)
local b={{o,p}}
self:remove(o,p,j)
local h=1
while h<=#b do
local q=b[h]
h=h+1
for y,r in ipairs(w)do
local k,l=q[1]+r[2],q[2]+r[1]
local s=self.rows[k]
local m=s and s.cells[l]
if m and not m.kind.unbreakable then
self:remove(k,l,j)
if m.kind.explosive then
b[#b+1]={k,l}
end
end
end
end
j:effect(i.EXPLODE)
end

function a:strike(j,k,b)
local h=self.rows[j].cells[k]
local l=h.kind
if l.unbreakable then
h.shine=u
b:effect(i.METAL)
return
end
if l.explosive then
self:explode(j,k,b)
return
end
h.hits=h.hits-1
if h.hits>0 then
b:effect(i.TOUGH)
return
end
local m,o=self:cellPosition(j,k)
self:remove(j,k,b)
b:effect(i.BRICK)
b:brickBroken(m+c/2,o+e/2)
end

local function j(h)
local b=h.kind
if b.cells then
return b.cells[h.hits],b.shades
end
if h.shine>0 then
return b.shineCell,b.shineShades
end
return b.cell,b.shades
end

function a:buildTicks()
return#self.rows*g.row+g.fall
end

function a:landedRows(b)
return SpiffBoy.clamp(math.floor((b-g.fall)/g.row)+1,0,#self.rows)
end

function a:drawRow(k,l,m,o,p)
for b=1,f do
local h=o.cells[b]
if h then
local q,r=j(h)
local s,y=self:cellPosition(m,b)
k:layers(l,q*c,c,e,s,y-p,r)
end
end
end

function a:drawBuilding(k,l,m)
local o=#self.rows
for b,p in ipairs(self.rows)do
local q=(o-b)*g.row
local h=(m-q)/g.fall
if h>0 then
local y,r=self:cellPosition(b,1)
local s=math.floor((r-a.TOP+e)*(1-math.min(1,h)))
self:drawRow(k,l,b,p,s)
end
end
end

function a:draw(h,k,l)
for b,m in ipairs(self.rows)do
self:drawRow(h,k,b,m,0)
end
for o,b in ipairs(self.bursts)do
local m=math.floor(b.timer/d.ticks)
h:layers(l,m*d.width,d.width,d.height,b.x,b.y,d.shades)
end
end
