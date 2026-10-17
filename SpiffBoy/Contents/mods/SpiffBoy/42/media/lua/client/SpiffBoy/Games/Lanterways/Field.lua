require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Tiles"
require"SpiffBoy/Games/Lanterways/Party"

local c=SpiffBoy.Lanterways
local p=c.Tiles
local f=c.Party

local a={}
a.__index=a
c.Field=a

local e=c.TILE
a.WALK_SPEED=1
a.RUN_SPEED=2
a.WANDER={min=90,max=240,reach=2}
a.ROAM={min=40,max=140,reach=5}
a.ENCOUNTER_MIN=0.6
a.ENCOUNTER_MAX=1.4
a.RARE_CHANCE=1/32
a.LAMP_REACH=4
a.WATCH_REACH=7
a.ISLET_RIM=1
a.HALO=5
a.VEIL_STEPS=4
a.WALL_ROWS=2
a.BRAZIER_SIZE=2

local function d(b,g,h)
return h*b.width+g+1
end

local function v(b)
local g={}
for h=0,b.h-1 do
for i=0,b.w-1 do
local j=b.door~=nil and b.to~=nil and h==b.h-1 and i==b.door
if not j then
g[#g+1]={b.x+i,b.y+h}
end
end
end
return g
end

function a.prepare(b)
if b.prepared then
return b
end
b.height=#b.rows
b.width=string.len(b.rows[1])
local h={}
for g=0,b.height-1 do
local i=b.rows[g+1]
if string.len(i)~=b.width then
error("Lanterways: row "..(g+1).." of map "..tostring(b.id).." is "..string.len(i).." tiles wide instead of "..b.width)
end
for j=0,b.width-1 do
local k=string.sub(i,j+1,j+1)
local l=p.get(k)
if not l then
error("Lanterways: unknown tile '"..k.."' in map "..tostring(b.id))
end
h[d(b,j,g)]=not l.walk
end
end
b.warps=b.warps or{}
for j,g in ipairs(b.objects)do
for k,i in ipairs(v(g))do
h[d(b,i[1],i[2])]=true
end
if g.to then
b.warps[#b.warps+1]={
x=g.x+g.door,y=g.y+g.h-1,w=1,h=1,
to=g.to,tx=g.tx,ty=g.ty,dir=g.dir or"up",price=g.price,when=g.when,
}
end
end
b.solid=h
b.npcs=b.npcs or{}
b.events=b.events or{}
b.chests=b.chests or{}
b.lamps=b.lamps or{}
b.signs=b.signs or{}
b.notes=b.notes or{}
b.echoes=b.echoes or{}
b.walls=b.walls or{}
if b.fog then
a.prepareFog(b)
end
for i,g in ipairs(b.warps)do
if g.to==b.id then
a.prepareFloors(b)
break
end
end
b.prepared=true
return b
end

function a.prepareFloors(b)
local h,i={},{}
for j=0,b.height-1 do
for k=0,b.width-1 do
local s=d(b,k,j)
if not h[s]and p.get(a.charAt(b,k,j)).walk then
local g={x0=k,y0=j,x1=k,y1=j}
i[#i+1]=g
h[s]=#i
local l={{k,j}}
local m=1
while l[m]do
local q,r=l[m][1],l[m][2]
m=m+1
g.x0,g.y0=math.min(g.x0,q),math.min(g.y0,r)
g.x1,g.y1=math.max(g.x1,q),math.max(g.y1,r)
for w=1,4 do
local t=c.DIRECTIONS[w]
local n,o=q+t.dx,r+t.dy
if n>=0 and o>=0 and n<b.width and o<b.height then
local u=d(b,n,o)
if not h[u]and p.get(a.charAt(b,n,o)).walk then
h[u]=#i
l[#l+1]={n,o}
end
end
end
end
end
end
end
b.floorOf=h
b.floorBoxes=i
end

function a:floorBox()
local g=self.map
if not g.floorBoxes then
return nil
end
local b=g.floorBoxes[g.floorOf[d(g,self.player.x,self.player.y)]]
return{x=b.x0-1,y=b.y0-a.WALL_ROWS,w=b.x1-b.x0+3,h=b.y1-b.y0+a.WALL_ROWS+2}
end

function a.prepareFog(b)
local h=c.MurkSea
local j={}
local i={}
for l,g in ipairs(h.islets)do
local k={code=g.code,id=g.id,region=g.region,tiles={},lights={}}
j[#j+1]=k
i[g.code]=k
end
for l=0,b.height-1 do
local m=h.isletRows[l+1]
for g=0,b.width-1 do
local k=i[string.sub(m,g+1,g+1)]
if k then
k.tiles[#k.tiles+1]=d(b,g,l)
end
end
end
for l,g in ipairs(b.lamps)do
local k=i[string.sub(h.isletRows[g.y+1],g.x+1,g.x+1)]
k.lights[#k.lights+1]=g.flag
end
for m,g in ipairs(b.objects)do
if g.kind=="watchlight"then
local l=g.y+g.h-1
local k=i[string.sub(h.isletRows[l+1],g.x+g.door+1,g.x+g.door+1)]
k.lights[#k.lights+1]=g.flag
end
end
b.islets=j
b.regionRows=h.regionRows
b.regions=h.regions
b.walls=h.walls
end

function a.charAt(g,b,h)
if b<0 or h<0 or b>=g.width or h>=g.height then
return nil
end
return string.sub(g.rows[h+1],b+1,b+1)
end

function a.new(h,g,i,j,k)
local l=a.prepare(c.Maps[g])
local b=setmetatable({},a)
b.game=h
b.map=l
b.id=g
b.actors={}
b.player=b:newActor("player","pell",i,j,k)
b.followers={}
b:refreshParty()
b.npcs={}
b:refreshNpcs()
if b.map.fog then
b:refreshReveal()
end
b.encounterSteps=0
b:resetEncounter()
b.camera={x=0,y=0}
b:updateCamera()
return b
end

function a:newActor(h,i,b,g,j)
return{
id=h,sprite=i,x=b,y=g,px=b*e,py=g*e,
dir=j or 1,moving=false,fromX=b,fromY=g,walked=0,frame=0,
speed=a.WALK_SPEED,path=nil,
}
end

function a:refreshParty()
local j=self.game.state
local b=f.active(j)
self.player.sprite=b[1].id
local i={}
for g=2,#b do
local h=self.followers[g-1]
if h then
h.sprite=b[g].id
else
h=self:newActor("follower"..g,b[g].id,self.player.x,self.player.y,self.player.dir)
end
i[#i+1]=h
end
self.followers=i
end

function a:gatherFollowers()
for g,b in ipairs(self.followers)do
b.x,b.y=self.player.x,self.player.y
b.px,b.py=self.player.px,self.player.py
b.dir=self.player.dir
b.moving=false
end
end

function a:npcShown(b)
return f.meets(self.game.state,b.show)
end

function a:refreshNpcs()
local h={}
for i,b in ipairs(self.map.npcs)do
if self:npcShown(b)then
local g=self.npcs[b.id]
if not g then
g=self:newActor(b.id,b.sprite,b.x,b.y,c.DIRECTION_INDEX[b.dir or"down"])
g.definition=b
g.home={x=b.x,y=b.y}
g.wanderTimer=a.WANDER.min
end
h[b.id]=g
end
end
for b,g in pairs(self.npcs)do
if g.spawned and not h[b]then
h[b]=g
end
end
self.npcs=h
end

function a:spawn(g,h,i,j,k)
local b=self:newActor(g,h,i,j,c.DIRECTION_INDEX[k or"down"])
b.spawned=true
self.npcs[g]=b
return b
end

function a:despawn(b)
self.npcs[b]=nil
end

function a:actor(b)
if b=="player"then
return self.player
end
for h,g in ipairs(self.followers)do
if g.id==b or g.sprite==b then
return g
end
end
return self.npcs[b]
end

function a:lampAt(h,i)
for j,b in ipairs(self.map.lamps)do
local g=1
if b.brazier then
g=a.BRAZIER_SIZE
end
if h>=b.x and h<b.x+g and i>=b.y and i<b.y+g then
return b
end
end
return nil
end

function a:lampLit(b)
return b.flag==nil or f.hasFlag(self.game.state,b.flag)
end

function a:gateClosed(g,h)
for j,i in ipairs(self.map.lamps)do
local b=i.gate
if b and not self:lampLit(i)and g>=b.x and g<b.x+b.w and h>=b.y and h<b.y+b.h then
return true
end
end
return false
end

local function r(i,l,g,h,b)
for j=math.max(0,h-b),math.min(i.height-1,h+b)do
for k=math.max(0,g-b),math.min(i.width-1,g+b)do
if(k-g)*(k-g)+(j-h)*(j-h)<=b*b then
l[d(i,k,j)]=true
end
end
end
end

function a.wholeIslets(i,j)
local g={}
for l,b in ipairs(i.islets)do
local h=#b.lights>0
for m,k in ipairs(b.lights)do
if not f.hasFlag(j,k)then
h=false
end
end
if h then
g[b.id]=true
end
end
return g
end

function a.revealFor(b,i)
local h={}
for j,g in ipairs(b.lamps)do
if g.flag==nil or f.hasFlag(i,g.flag)then
r(b,h,g.x,g.y,a.LAMP_REACH)
end
end
for j,g in ipairs(b.objects)do
if g.kind=="watchlight"and f.hasFlag(i,g.flag)then
r(b,h,g.x+g.door,g.y+g.h-1,a.WATCH_REACH)
end
end
local g=a.wholeIslets(b,i)
for q,j in ipairs(b.islets)do
if g[j.id]then
for s,k in ipairs(j.tiles)do
local l,m=(k-1)%b.width,math.floor((k-1)/b.width)
for n=math.max(0,m-a.ISLET_RIM),math.min(b.height-1,m+a.ISLET_RIM)do
for o=math.max(0,l-a.ISLET_RIM),math.min(b.width-1,l+a.ISLET_RIM)do
h[d(b,o,n)]=true
end
end
end
end
end
return h,g
end

function a:refreshReveal()
local h,g=a.revealFor(self.map,self.game.state)
local b=0
if self.whole then
for i in pairs(g)do
if not self.whole[i]then
b=b+1
end
end
end
self.revealed=h
self.whole=g
return b
end

function a:revealedAt(b,g)
if not self.map.fog then
return true
end
return self.revealed[d(self.map,b,g)]==true
end

function a:seenAt(b,g)
if self:revealedAt(b,g)then
return true
end
local h,i=b-self.player.x,g-self.player.y
return h*h+i*i<=a.HALO
end

function a:regionAt(b,g)
local h=self.map.regionRows
if not h or b<0 or g<0 or b>=self.map.width or g>=self.map.height then
return nil
end
return self.map.regions[tonumber(string.sub(h[g+1],b+1,b+1))]
end

function a:wallAt(g,h)
for i,b in ipairs(self.map.walls)do
if g>=b.x and g<b.x+b.w and h>=b.y and h<b.y+b.h and not f.hasFlag(self.game.state,b.flag)then
return b
end
end
return nil
end

function a:fixtureAt(i,g,h)
for j,b in ipairs(i)do
if b.x==g and b.y==h and self:revealedAt(g,h)then
return b
end
end
return nil
end

function a:chestAt(b,g)
return self:fixtureAt(self.map.chests,b,g)
end

function a:noteAt(g,h)
local b=self:fixtureAt(self.map.notes,g,h)
if b and not f.hasFlag(self.game.state,"p_"..b.page)then
return b
end
return nil
end

function a:echoAt(g,h)
local b=self:fixtureAt(self.map.echoes,g,h)
if b and not f.hasFlag(self.game.state,"e_"..b.echo)then
return b
end
return nil
end

function a:bellpostAt(g,h)
local b=self.map.bellpost
return b~=nil and b.x==g and b.y==h and f.meets(self.game.state,b.when)
end

function a:npcAt(g,h)
for i,b in pairs(self.npcs)do
if(b.x==g and b.y==h)or(b.moving and b.fromX==g and b.fromY==h)then
return b
end
end
return nil
end

function a:blocked(b,g,i)
local h=self.map
if b<0 or g<0 or b>=h.width or g>=h.height then
return true
end
if h.solid[d(h,b,g)]then
return true
end
if self:gateClosed(b,g)or self:wallAt(b,g)or self:chestAt(b,g)or self:noteAt(b,g)or self:echoAt(b,g)or self:lampAt(b,g)or self:bellpostAt(b,g)then
return true
end
if self:npcAt(b,g)then
return true
end
if not i and self.player.x==b and self.player.y==g then
return true
end
return false
end

function a:startStep(b,g,i)
local h=c.DIRECTIONS[g]
b.dir=g
b.fromX,b.fromY=b.x,b.y
b.x,b.y=b.x+h.dx,b.y+h.dy
b.moving=true
b.walked=0
b.speed=i
end

function a:advanceActor(b)
if not b.moving then
return false
end
b.walked=b.walked+b.speed
b.frame=b.frame+1
local g=c.DIRECTIONS[b.dir]
if b.walked>=e then
b.moving=false
b.px,b.py=b.x*e,b.y*e
return true
end
b.px=b.fromX*e+g.dx*b.walked
b.py=b.fromY*e+g.dy*b.walked
return false
end

local function w(g,h,i,j)
for k,b in ipairs(c.DIRECTIONS)do
if g+b.dx==i and h+b.dy==j then
return k
end
end
return nil
end

function a:pullFollowers(j,k,l)
local g,h=j,k
for o,b in ipairs(self.followers)do
local m,n=b.x,b.y
if b.x~=g or b.y~=h then
local i=w(b.x,b.y,g,h)
if i then
self:startStep(b,i,l)
else
b.x,b.y=g,h
b.px,b.py=g*e,h*e
end
end
g,h=m,n
end
end

function a:walkPlayer(g,j)
local b=self.player
local i=c.DIRECTIONS[g]
b.dir=g
if self:blocked(b.x+i.dx,b.y+i.dy,true)then
return false
end
local k,l=b.x,b.y
local h=a.WALK_SPEED
if j then
h=a.RUN_SPEED
end
self:startStep(b,g,h)
self:pullFollowers(k,l,h)
return true
end

function a:encountersHere()
local b=self.map.encounters
if b and b.zones then
return b.zones[self:regionAt(self.player.x,self.player.y)]
end
return b
end

function a:resetEncounter()
local b=self:encountersHere()
if b then
local g=self.game.random
self.encounterSteps=g:int(math.floor(b.rate*a.ENCOUNTER_MIN),math.floor(b.rate*a.ENCOUNTER_MAX))
end
end

function a:countStep()
local b=self:encountersHere()
local h=self.game.state
if not b or not f.meets(h,b.when)then
return nil
end
local i=self.player
if self:revealedAt(i.x,i.y)then
self.encounterSteps=self.encounterSteps-1
else
self.encounterSteps=self.encounterSteps-a.VEIL_STEPS
end
if self.encounterSteps>0 then
return nil
end
self:resetEncounter()
local j=self.game.random
local g=b.troops
if b.late and f.meets(h,b.late.when)then
g=b.late.troops
end
if b.rares and j:chance(a.RARE_CHANCE)then
g=b.rares
end
return g[j:int(1,#g)]
end

function a:warpAt(g,h)
for k,b in ipairs(self.map.warps)do
local i,j=b.w or 1,b.h or 1
if g>=b.x and g<b.x+i and h>=b.y and h<b.y+j and f.meets(self.game.state,b.when)then
return b
end
end
return nil
end

function a:besideWarp(b,g)
if self:warpAt(b,g)then
return true
end
for i=1,4 do
local h=c.DIRECTIONS[i]
if self:warpAt(b+h.dx,g+h.dy)then
return true
end
end
return false
end

function a:eventAt(g,h)
for k,b in ipairs(self.map.events)do
local i,j=b.w or 1,b.h or 1
if g>=b.x and g<b.x+i and h>=b.y and h<b.y+j and f.meets(self.game.state,b.when)then
return b
end
end
return nil
end

function a:facingTile()
local b=c.DIRECTIONS[self.player.dir]
return self.player.x+b.dx,self.player.y+b.dy
end

function a:signAt(g,h)
for i,b in ipairs(self.map.signs)do
if b.x==g and b.y==h then
return b
end
end
return nil
end

function a:interactionAhead()
local b,g=self:facingTile()
local h=c.DIRECTIONS[self.player.dir]
local i=1
local j=a.charAt(self.map,b,g)
if j and p.get(j).kind=="counter"then
b,g=b+h.dx,g+h.dy
i=2
end
local k=self:npcAt(b,g)
if k then
return"npc",k
end
if i==1 then
local l=self:chestAt(b,g)
if l then
return"chest",l
end
local m=self:noteAt(b,g)
if m then
return"note",m
end
local n=self:echoAt(b,g)
if n then
return"echo",n
end
local o=self:lampAt(b,g)
if o then
return"lamp",o
end
local q=self:signAt(b,g)
if q then
return"sign",q
end
if self:bellpostAt(b,g)then
return"bell",self.map.bellpost
end
end
return nil,nil
end

function a:wanderNpcs()
local l=self.game.random
for q,b in pairs(self.npcs)do
local j=b.definition
if j and j.wander and not b.moving and not b.path then
local i=a.WANDER
if j.roam then
i=a.ROAM
end
b.wanderTimer=b.wanderTimer-1
if b.wanderTimer<=0 then
b.wanderTimer=l:int(i.min,i.max)
local k=l:int(1,4)
local m=c.DIRECTIONS[k]
local g,h=b.x+m.dx,b.y+m.dy
local n=math.abs(g-b.home.x)<=i.reach and math.abs(h-b.home.y)<=i.reach
local o=not j.roam or(not self:besideWarp(g,h)and not self:eventAt(g,h)and a.charAt(self.map,g,h)~="=")
b.dir=k
if n and o and not self:blocked(g,h)and not self:followerOn(g,h)then
self:startStep(b,k,a.WALK_SPEED)
end
end
end
end
end

function a:followerOn(g,h)
for i,b in ipairs(self.followers)do
if b.x==g and b.y==h then
return true
end
end
return false
end

function a:offScreen(g,h)
local b=self.camera
return(g+1)*e<=b.x or g*e>=b.x+c.WIDTH or(h+1)*e<=b.y or h*e>=b.y+c.HEIGHT
end

function a:stepsFrom(k)
local b=self.map
local l={[d(b,k.x,k.y)]=0}
local g={{k.x,k.y}}
local h=1
while h<=#g do
local m,n=g[h][1],g[h][2]
h=h+1
local s=l[d(b,m,n)]
for t=1,4 do
local o=c.DIRECTIONS[t]
local i,j=m+o.dx,n+o.dy
if i>=0 and j>=0 and i<b.width and j<b.height then
local q=d(b,i,j)
if l[q]==nil and not self:blocked(i,j,true)then
l[q]=s+1
g[#g+1]={i,j}
end
end
end
end
return l
end

function a:pathOffScreen(n,x)
local y=self:stepsFrom(x)
local b=self.map
local z=d(b,n.x,n.y)
local g={[z]=false}
local h={{n.x,n.y}}
local i=1
local A={"d","u","l","r"}
local o,s=nil,nil
while i<=#h do
local j,k=h[i][1],h[i][2]
i=i+1
if self:offScreen(j,k)then
local l=y[d(b,j,k)]
if l and(not o or l<s)then
o,s=d(b,j,k),l
end
else
for t=1,4 do
local u=c.DIRECTIONS[t]
local l,m=j+u.dx,k+u.dy
local q=l>=0 and m>=0 and l<b.width and m<b.height and d(b,l,m)
if q and g[q]==nil and not self:blocked(l,m,true)then
g[q]={index=d(b,j,k),letter=A[t]}
h[#h+1]={l,m}
end
end
end
end
if not o then
return nil
end
local k={}
local j=o
while g[j]do
table.insert(k,1,g[j].letter)
j=g[j].index
end
return table.concat(k)
end

function a:setPath(i,g)
local b={}
local j={d=1,u=2,l=3,r=4}
for h=1,string.len(g)do
b[#b+1]=j[string.sub(g,h,h)]
end
i.path=b
end

function a:advancePaths()
local h=false
local g={self.player}
for i,b in pairs(self.npcs)do
g[#g+1]=b
end
for l,b in ipairs(g)do
if b.path and not b.moving then
if#b.path==0 then
b.path=nil
else
local i=table.remove(b.path,1)
if b==self.player then
local j,k=b.x,b.y
self:startStep(b,i,a.WALK_SPEED)
self:pullFollowers(j,k,a.WALK_SPEED)
else
self:startStep(b,i,a.WALK_SPEED)
end
end
end
if b.path then
h=true
end
end
return h
end

function a:advanceActors()
local b=self:advanceActor(self.player)
for h,g in ipairs(self.followers)do
self:advanceActor(g)
end
for h,g in pairs(self.npcs)do
self:advanceActor(g)
end
return b
end

function a:updateCamera()
local j=self.map
local h,i=j.width*e,j.height*e
local b=self.player.px+e/2-c.WIDTH/2
local g=self.player.py+e/2-c.HEIGHT/2
if h<=c.WIDTH then
b=(h-c.WIDTH)/2
else
b=SpiffBoy.clamp(b,0,h-c.WIDTH)
end
if i<=c.HEIGHT then
g=(i-c.HEIGHT)/2
else
g=SpiffBoy.clamp(g,0,i-c.HEIGHT)
end
self.camera.x=math.floor(b)
self.camera.y=math.floor(g)
end

function a:drawOrder()
local b={}
for h,g in pairs(self.npcs)do
b[#b+1]=g
end
for g=#self.followers,1,-1 do
b[#b+1]=self.followers[g]
end
b[#b+1]=self.player
table.sort(b,function(g,h)
if g.py==h.py then
return g.id<h.id
end
return g.py<h.py
end)
return b
end
