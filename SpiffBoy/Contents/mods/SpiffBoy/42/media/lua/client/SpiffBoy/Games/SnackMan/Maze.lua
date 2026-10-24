require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/SnackMan/Layouts"

SpiffBoy.SnackMan=SpiffBoy.SnackMan or{}

local a={}
a.__index=a
SpiffBoy.SnackMan.Maze=a

a.TILE=6
a.COLUMNS=21
a.ROWS=19
a.WIDTH=a.TILE*a.COLUMNS
a.HEIGHT=a.TILE*a.ROWS
a.COUNT=#SpiffBoy.SnackMan.Layouts
a.DOOR={x=11,y=9}
a.OUTSIDE={x=11,y=8}
a.PEN={left=9,right=13,y=10}
a.FOOD={x=11,y=12}
a.TUNNEL=4
a.DIRECTIONS={
right={dx=1,dy=0,back="left"},
left={dx=-1,dy=0,back="right"},
up={dx=0,dy=-1,back="down"},
down={dx=0,dy=1,back="up"},
}
a.ORDER={"up","left","down","right"}

local h="#"
local f="."
local g="o"
local l="S"
local m="-"
local n="="

local function i(column)
return(column-1+a.COLUMNS)%a.COLUMNS+1
end

local function j(row,runs)
local b=0
local c=nil
for d=1,a.COLUMNS+1 do
local e=d<=a.COLUMNS and row[d]==f
if e and not c then
c=d
elseif not e and c then
b=b+1
runs[b*2-1]=c
runs[b*2]=d-1
c=nil
end
end
return b
end

function a.new(index)
local k=SpiffBoy.SnackMan.Layouts[index]
local b=setmetatable({},a)
b.index=index
b.decor=k.decor
b.tiles={}
b.chips={}
b.bats={}
b.runs={}
b.runCounts={}
b.total=0
b.left=0
for c=1,a.ROWS do
local o=k.rows[c]
b.tiles[c]={}
b.chips[c]={}
for d=1,a.COLUMNS do
local e=string.sub(o,d,d)
b.tiles[c][d]=e
if e==f or e==g then
b.chips[c][d]=e
b.total=b.total+1
if e==g then
b.bats[#b.bats+1]={x=d,y=c}
end
else
b.chips[c][d]=false
end
if e==l then
b.start={x=d,y=c}
end
end
if b.tiles[c][1]~=h then
b.tunnelRow=c
end
b.runs[c]={}
b.runCounts[c]=j(b.chips[c],b.runs[c])
end
b.left=b.total
return b
end

function a:isOpen(x,y)
if y<1 or y>a.ROWS then
return false
end
local b=self.tiles[y][i(x)]
return b~=h and b~=m and b~=n
end

function a:isTunnel(x,y)
return y==self.tunnelRow and(x<=a.TUNNEL or x>a.COLUMNS-a.TUNNEL)
end

function a:eat(x,y)
local d=i(x)
local b=self.chips[y]
if not b then
return nil
end
local c=b[d]
if not c then
return nil
end
b[d]=false
self.left=self.left-1
if c==f then
self.runCounts[y]=j(b,self.runs[y])
end
return c
end

function a:eaten()
return self.total-self.left
end

function a:chipRuns(y)
return self.runs[y],self.runCounts[y]
end

function a:hasBat(x,y)
return self.chips[y][x]==g
end

function a.centre(x,y)
return(x-1)*a.TILE+a.TILE/2,(y-1)*a.TILE+a.TILE/2
end

function a.tileAt(px,py)
return math.floor(px/a.TILE)+1,math.floor(py/a.TILE)+1
end
