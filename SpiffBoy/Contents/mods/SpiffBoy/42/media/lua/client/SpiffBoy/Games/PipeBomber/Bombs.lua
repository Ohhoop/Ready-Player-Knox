require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"

local c=SpiffBoy.PipeBomber.Zones.TILE

local a={}
a.__index=a
SpiffBoy.PipeBomber.Bombs=a

a.FUSE=150
a.BLAST_TICKS=36
a.FIRE_TICKS=240
a.SLIDE_SPEED=2.5
a.AEROSOL_EXTRA=3
a.GRENADE_RANGE=2
a.GRENADE_FUSE=90
a.PLAYER="player"
a.ENEMY="enemy"
a.ARMS={
{dx=-1,dy=0,name="left"},
{dx=1,dy=0,name="right"},
{dx=0,dy=-1,name="up"},
{dx=0,dy=1,name="down"},
}

function a.new(d)
local b=setmetatable({},a)
b.grid=d
b.list={}
b.blasts={}
b.fires={}
b.danger={}
b.serial=0
return b
end

function a:at(d,e)
for f,b in ipairs(self.list)do
if b.column==d and b.row==e then
return b
end
end
return nil
end

function a:countOf(d)
local b=0
for f,e in ipairs(self.list)do
if e.owner==d then
b=b+1
end
end
return b
end

function a:place(b,d,f,g,h,i)
self.serial=self.serial+1
local e={
column=b,row=d,x=(b-1)*c,y=(d-1)*c,
kind=f,owner=g,range=h,timer=i,serial=self.serial,
}
self.list[#self.list+1]=e
return e
end

function a:kick(b,d,e)
b.slideX=d
b.slideY=e
end

function a:detonate(e)
local b=nil
for f,d in ipairs(self.list)do
if d.owner==e and not d.timer and(not b or d.serial<b.serial)then
b=d
end
end
if not b then
return false
end
b.timer=0
return true
end

function a:lightAll(d)
for e,b in ipairs(self.list)do
if b.owner==d and not b.timer then
b.timer=a.FUSE
end
end
end

function a:slideOpen(f,b,d,g)
if self.grid:isSolid(b,d)or self.grid:itemAt(b,d)or g:occupied(b,d)then
return false
end
local e=self:at(b,d)
return e==nil or e==f
end

function a:slide(b,h)
local e=(b.column-1)*c
local f=(b.row-1)*c
if b.x==e and b.y==f then
local d,g=b.column+b.slideX,b.row+b.slideY
if not self:slideOpen(b,d,g,h)then
b.slideX=nil
b.slideY=nil
return
end
b.column=d
b.row=g
e=(d-1)*c
f=(g-1)*c
end
local d=a.SLIDE_SPEED
b.x=b.x+SpiffBoy.clamp(e-b.x,-d,d)
b.y=b.y+SpiffBoy.clamp(f-b.y,-d,d)
end

local function o(b)
if b.kind=="aerosol"then
return b.range+a.AEROSOL_EXTRA
end
return b.range
end

function a:explode(b,h)
for d=#self.list,1,-1 do
if self.list[d]==b then
table.remove(self.list,d)
end
end
local d=self.grid
local i=math.floor(b.x/c+0.5)+1
local j=math.floor(b.y/c+0.5)+1
local g={column=i,row=j,timer=a.BLAST_TICKS,owner=b.owner,arms={},cells={d:index(i,j)}}
local p=o(b)
for q,k in ipairs(a.ARMS)do
local m=0
for l=1,p do
local e,f=i+k.dx*l,j+k.dy*l
if d:isHard(e,f)then
break
end
if d:isCrate(e,f)then
if d:breakCrate(e,f)then
h:crateBroken(b.owner)
end
break
end
m=l
g.cells[#g.cells+1]=d:index(e,f)
if d:takeItem(e,f)then
h:itemBurnt()
break
end
local n=self:at(e,f)
if n then
n.timer=0
break
end
end
g.arms[k.name]=m
end
self.blasts[#self.blasts+1]=g
if b.kind=="molotov"then
self.fires[#self.fires+1]={cells=g.cells,timer=a.BLAST_TICKS+a.FIRE_TICKS,owner=b.owner}
end
h:bombExploded(b)
end

function a:update(e)
for d,b in ipairs(self.list)do
if b.slideX then
self:slide(b,e)
end
if b.timer and b.timer>0 then
b.timer=b.timer-1
end
end
local b=true
while b do
b=false
for f,d in ipairs(self.list)do
if d.timer and d.timer<=0 then
self:explode(d,e)
b=true
break
end
end
end
for f=#self.blasts,1,-1 do
local d=self.blasts[f]
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.blasts,f)
end
end
for f=#self.fires,1,-1 do
local d=self.fires[f]
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.fires,f)
end
end
self:listDanger()
end

local function d(b,g)
for h,e in ipairs(g)do
for i,f in ipairs(e.cells)do
if b[f]~=a.PLAYER then
b[f]=e.owner
end
end
end
end

function a:listDanger()
local b={}
d(b,self.blasts)
d(b,self.fires)
self.danger=b
end

function a:dangerAt(b,e)
return self.danger[self.grid:index(b,e)]
end

function a.strength(b)
local e=a.BLAST_TICKS/3
if b.timer>e*2 then
return 2
elseif b.timer>e then
return 1
end
return 3
end
