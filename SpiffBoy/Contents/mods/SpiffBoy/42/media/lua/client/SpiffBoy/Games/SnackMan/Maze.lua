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
local m="S"
local n="-"
local o="="

local function i(b)
return(b-1+a.COLUMNS)%a.COLUMNS+1
end

local function j(l,e)
local b=0
local c=nil
for d=1,a.COLUMNS+1 do
local k=d<=a.COLUMNS and l[d]==f
if k and not c then
c=d
elseif not k and c then
b=b+1
e[b*2-1]=c
e[b*2]=d-1
c=nil
end
end
return b
end

function a.new(k)
local l=SpiffBoy.SnackMan.Layouts[k]
local b=setmetatable({},a)
b.index=k
b.decor=l.decor
b.tiles={}
b.chips={}
b.bats={}
b.runs={}
b.runCounts={}
b.total=0
b.left=0
for c=1,a.ROWS do
local p=l.rows[c]
b.tiles[c]={}
b.chips[c]={}
for d=1,a.COLUMNS do
local e=string.sub(p,d,d)
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
if e==m then
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

function a:isOpen(d,b)
if b<1 or b>a.ROWS then
return false
end
local c=self.tiles[b][i(d)]
return c~=h and c~=n and c~=o
end

function a:isTunnel(b,c)
return c==self.tunnelRow and(b<=a.TUNNEL or b>a.COLUMNS-a.TUNNEL)
end

function a:eat(k,c)
local e=i(k)
local b=self.chips[c]
if not b then
return nil
end
local d=b[e]
if not d then
return nil
end
b[e]=false
self.left=self.left-1
if d==f then
self.runCounts[c]=j(b,self.runs[c])
end
return d
end

function a:eaten()
return self.total-self.left
end

function a:chipRuns(b)
return self.runs[b],self.runCounts[b]
end

function a:hasBat(b,c)
return self.chips[c][b]==g
end

function a.centre(b,c)
return(b-1)*a.TILE+a.TILE/2,(c-1)*a.TILE+a.TILE/2
end

function a.tileAt(b,c)
return math.floor(b/a.TILE)+1,math.floor(c/a.TILE)+1
end
