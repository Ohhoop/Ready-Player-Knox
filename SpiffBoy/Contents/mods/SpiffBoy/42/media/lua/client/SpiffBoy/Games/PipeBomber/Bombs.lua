require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/PipeBomber/Zones"

local b=SpiffBoy.PipeBomber.Zones.TILE

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

function a.new(grid)
local c=setmetatable({},a)
c.grid=grid
c.list={}
c.blasts={}
c.fires={}
c.danger={}
c.serial=0
return c
end

function a:at(column,row)
for d,c in ipairs(self.list)do
if c.column==column and c.row==row then
return c
end
end
return nil
end

function a:countOf(owner)
local c=0
for e,d in ipairs(self.list)do
if d.owner==owner then
c=c+1
end
end
return c
end

function a:place(column,row,kind,owner,range,fuse)
self.serial=self.serial+1
local c={
column=column,row=row,x=(column-1)*b,y=(row-1)*b,
kind=kind,owner=owner,range=range,timer=fuse,serial=self.serial,
}
self.list[#self.list+1]=c
return c
end

function a:kick(bomb,dx,dy)
bomb.slideX=dx
bomb.slideY=dy
end

function a:detonate(owner)
local c=nil
for e,d in ipairs(self.list)do
if d.owner==owner and not d.timer and(not c or d.serial<c.serial)then
c=d
end
end
if not c then
return false
end
c.timer=0
return true
end

function a:lightAll(owner)
for d,c in ipairs(self.list)do
if c.owner==owner and not c.timer then
c.timer=a.FUSE
end
end
end

function a:slideOpen(bomb,column,row,world)
if self.grid:isSolid(column,row)or self.grid:itemAt(column,row)or world:occupied(column,row)then
return false
end
local c=self:at(column,row)
return c==nil or c==bomb
end

function a:slide(bomb,world)
local d=(bomb.column-1)*b
local e=(bomb.row-1)*b
if bomb.x==d and bomb.y==e then
local c,f=bomb.column+bomb.slideX,bomb.row+bomb.slideY
if not self:slideOpen(bomb,c,f,world)then
bomb.slideX=nil
bomb.slideY=nil
return
end
bomb.column=c
bomb.row=f
d=(c-1)*b
e=(f-1)*b
end
local c=a.SLIDE_SPEED
bomb.x=bomb.x+SpiffBoy.clamp(d-bomb.x,-c,c)
bomb.y=bomb.y+SpiffBoy.clamp(e-bomb.y,-c,c)
end

local function m(bomb)
if bomb.kind=="aerosol"then
return bomb.range+a.AEROSOL_EXTRA
end
return bomb.range
end

function a:explode(bomb,world)
for c=#self.list,1,-1 do
if self.list[c]==bomb then
table.remove(self.list,c)
end
end
local c=self.grid
local g=math.floor(bomb.x/b+0.5)+1
local h=math.floor(bomb.y/b+0.5)+1
local f={column=g,row=h,timer=a.BLAST_TICKS,owner=bomb.owner,arms={},cells={c:index(g,h)}}
local n=m(bomb)
for o,i in ipairs(a.ARMS)do
local k=0
for j=1,n do
local d,e=g+i.dx*j,h+i.dy*j
if c:isHard(d,e)then
break
end
if c:isCrate(d,e)then
if c:breakCrate(d,e)then
world:crateBroken(bomb.owner)
end
break
end
k=j
f.cells[#f.cells+1]=c:index(d,e)
if c:takeItem(d,e)then
world:itemBurnt()
break
end
local l=self:at(d,e)
if l then
l.timer=0
break
end
end
f.arms[i.name]=k
end
self.blasts[#self.blasts+1]=f
if bomb.kind=="molotov"then
self.fires[#self.fires+1]={cells=f.cells,timer=a.BLAST_TICKS+a.FIRE_TICKS,owner=bomb.owner}
end
world:bombExploded(bomb)
end

function a:update(world)
for d,c in ipairs(self.list)do
if c.slideX then
self:slide(c,world)
end
if c.timer and c.timer>0 then
c.timer=c.timer-1
end
end
local c=true
while c do
c=false
for e,d in ipairs(self.list)do
if d.timer and d.timer<=0 then
self:explode(d,world)
c=true
break
end
end
end
for e=#self.blasts,1,-1 do
local d=self.blasts[e]
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.blasts,e)
end
end
for e=#self.fires,1,-1 do
local d=self.fires[e]
d.timer=d.timer-1
if d.timer<=0 then
table.remove(self.fires,e)
end
end
self:listDanger()
end

local function d(danger,flames)
for f,c in ipairs(flames)do
for g,e in ipairs(c.cells)do
if danger[e]~=a.PLAYER then
danger[e]=c.owner
end
end
end
end

function a:listDanger()
local c={}
d(c,self.blasts)
d(c,self.fires)
self.danger=c
end

function a:dangerAt(column,row)
return self.danger[self.grid:index(column,row)]
end

function a.strength(blast)
local c=a.BLAST_TICKS/3
if blast.timer>c*2 then
return 2
elseif blast.timer>c then
return 1
end
return 3
end
