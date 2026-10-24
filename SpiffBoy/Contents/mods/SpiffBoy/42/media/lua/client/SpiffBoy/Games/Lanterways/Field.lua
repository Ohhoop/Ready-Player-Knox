require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Data/Tiles"
require"SpiffBoy/Games/Lanterways/Party"

local d=SpiffBoy.Lanterways
local o=d.Tiles
local g=d.Party

local c={}
c.__index=c
d.Field=c

local f=d.TILE
c.WALK_SPEED=1
c.RUN_SPEED=2
c.WANDER={min=90,max=240,reach=2}
c.ROAM={min=40,max=140,reach=5}
c.ENCOUNTER_MIN=0.6
c.ENCOUNTER_MAX=1.4
c.RARE_CHANCE=1/32
c.LAMP_REACH=4
c.WATCH_REACH=7
c.ISLET_RIM=1
c.HALO=5
c.VEIL_STEPS=4
c.WALL_ROWS=2
c.BRAZIER_SIZE=2

local function e(map,x,y)
return y*map.width+x+1
end

local function u(object)
local a={}
for b=0,object.h-1 do
for h=0,object.w-1 do
local i=object.door~=nil and object.to~=nil and b==object.h-1 and h==object.door
if not i then
a[#a+1]={object.x+h,object.y+b}
end
end
end
return a
end

function c.prepare(map)
if map.prepared then
return map
end
map.height=#map.rows
map.width=string.len(map.rows[1])
local b={}
for a=0,map.height-1 do
local h=map.rows[a+1]
if string.len(h)~=map.width then
error("Lanterways: row "..(a+1).." of map "..tostring(map.id).." is "..string.len(h).." tiles wide instead of "..map.width)
end
for i=0,map.width-1 do
local j=string.sub(h,i+1,i+1)
local k=o.get(j)
if not k then
error("Lanterways: unknown tile '"..j.."' in map "..tostring(map.id))
end
b[e(map,i,a)]=not k.walk
end
end
map.warps=map.warps or{}
for i,a in ipairs(map.objects)do
for j,h in ipairs(u(a))do
b[e(map,h[1],h[2])]=true
end
if a.to then
map.warps[#map.warps+1]={
x=a.x+a.door,y=a.y+a.h-1,w=1,h=1,
to=a.to,tx=a.tx,ty=a.ty,dir=a.dir or"up",price=a.price,when=a.when,
}
end
end
map.solid=b
map.npcs=map.npcs or{}
map.events=map.events or{}
map.chests=map.chests or{}
map.lamps=map.lamps or{}
map.signs=map.signs or{}
map.notes=map.notes or{}
map.echoes=map.echoes or{}
map.walls=map.walls or{}
if map.fog then
c.prepareFog(map)
end
for h,a in ipairs(map.warps)do
if a.to==map.id then
c.prepareFloors(map)
break
end
end
map.prepared=true
return map
end

function c.prepareFloors(map)
local b,h={},{}
for i=0,map.height-1 do
for j=0,map.width-1 do
local r=e(map,j,i)
if not b[r]and o.get(c.charAt(map,j,i)).walk then
local a={x0=j,y0=i,x1=j,y1=i}
h[#h+1]=a
b[r]=#h
local k={{j,i}}
local l=1
while k[l]do
local p,q=k[l][1],k[l][2]
l=l+1
a.x0,a.y0=math.min(a.x0,p),math.min(a.y0,q)
a.x1,a.y1=math.max(a.x1,p),math.max(a.y1,q)
for v=1,4 do
local s=d.DIRECTIONS[v]
local m,n=p+s.dx,q+s.dy
if m>=0 and n>=0 and m<map.width and n<map.height then
local t=e(map,m,n)
if not b[t]and o.get(c.charAt(map,m,n)).walk then
b[t]=#h
k[#k+1]={m,n}
end
end
end
end
end
end
end
map.floorOf=b
map.floorBoxes=h
end

function c:floorBox()
local b=self.map
if not b.floorBoxes then
return nil
end
local a=b.floorBoxes[b.floorOf[e(b,self.player.x,self.player.y)]]
return{x=a.x0-1,y=a.y0-c.WALL_ROWS,w=a.x1-a.x0+3,h=a.y1-a.y0+c.WALL_ROWS+2}
end

function c.prepareFog(map)
local b=d.MurkSea
local i={}
local h={}
for k,a in ipairs(b.islets)do
local j={code=a.code,id=a.id,region=a.region,tiles={},lights={}}
i[#i+1]=j
h[a.code]=j
end
for k=0,map.height-1 do
local l=b.isletRows[k+1]
for a=0,map.width-1 do
local j=h[string.sub(l,a+1,a+1)]
if j then
j.tiles[#j.tiles+1]=e(map,a,k)
end
end
end
for k,a in ipairs(map.lamps)do
local j=h[string.sub(b.isletRows[a.y+1],a.x+1,a.x+1)]
j.lights[#j.lights+1]=a.flag
end
for l,a in ipairs(map.objects)do
if a.kind=="watchlight"then
local k=a.y+a.h-1
local j=h[string.sub(b.isletRows[k+1],a.x+a.door+1,a.x+a.door+1)]
j.lights[#j.lights+1]=a.flag
end
end
map.islets=i
map.regionRows=b.regionRows
map.regions=b.regions
map.walls=b.walls
end

function c.charAt(map,x,y)
if x<0 or y<0 or x>=map.width or y>=map.height then
return nil
end
return string.sub(map.rows[y+1],x+1,x+1)
end

function c.new(game,mapId,x,y,dir)
local b=c.prepare(d.Maps[mapId])
local a=setmetatable({},c)
a.game=game
a.map=b
a.id=mapId
a.actors={}
a.player=a:newActor("player","pell",x,y,dir)
a.followers={}
a:refreshParty()
a.npcs={}
a:refreshNpcs()
if a.map.fog then
a:refreshReveal()
end
a.encounterSteps=0
a:resetEncounter()
a.camera={x=0,y=0}
a:updateCamera()
return a
end

function c:newActor(id,sprite,x,y,dir)
return{
id=id,sprite=sprite,x=x,y=y,px=x*f,py=y*f,
dir=dir or 1,moving=false,fromX=x,fromY=y,walked=0,frame=0,
speed=c.WALK_SPEED,path=nil,
}
end

function c:refreshParty()
local j=self.game.state
local a=g.active(j)
self.player.sprite=a[1].id
local i={}
for b=2,#a do
local h=self.followers[b-1]
if h then
h.sprite=a[b].id
else
h=self:newActor("follower"..b,a[b].id,self.player.x,self.player.y,self.player.dir)
end
i[#i+1]=h
end
self.followers=i
end

function c:gatherFollowers()
for b,a in ipairs(self.followers)do
a.x,a.y=self.player.x,self.player.y
a.px,a.py=self.player.px,self.player.py
a.dir=self.player.dir
a.moving=false
end
end

function c:npcShown(definition)
return g.meets(self.game.state,definition.show)
end

function c:refreshNpcs()
local h={}
for i,a in ipairs(self.map.npcs)do
if self:npcShown(a)then
local b=self.npcs[a.id]
if not b then
b=self:newActor(a.id,a.sprite,a.x,a.y,d.DIRECTION_INDEX[a.dir or"down"])
b.definition=a
b.home={x=a.x,y=a.y}
b.wanderTimer=c.WANDER.min
end
h[a.id]=b
end
end
for a,b in pairs(self.npcs)do
if b.spawned and not h[a]then
h[a]=b
end
end
self.npcs=h
end

function c:spawn(id,sprite,x,y,dir)
local a=self:newActor(id,sprite,x,y,d.DIRECTION_INDEX[dir or"down"])
a.spawned=true
self.npcs[id]=a
return a
end

function c:despawn(id)
self.npcs[id]=nil
end

function c:actor(id)
if id=="player"then
return self.player
end
for b,a in ipairs(self.followers)do
if a.id==id or a.sprite==id then
return a
end
end
return self.npcs[id]
end

function c:lampAt(x,y)
for h,a in ipairs(self.map.lamps)do
local b=1
if a.brazier then
b=c.BRAZIER_SIZE
end
if x>=a.x and x<a.x+b and y>=a.y and y<a.y+b then
return a
end
end
return nil
end

function c:lampLit(lamp)
return lamp.flag==nil or g.hasFlag(self.game.state,lamp.flag)
end

function c:gateClosed(x,y)
for h,b in ipairs(self.map.lamps)do
local a=b.gate
if a and not self:lampLit(b)and x>=a.x and x<a.x+a.w and y>=a.y and y<a.y+a.h then
return true
end
end
return false
end

local function q(map,revealed,cx,cy,reach)
for a=math.max(0,cy-reach),math.min(map.height-1,cy+reach)do
for b=math.max(0,cx-reach),math.min(map.width-1,cx+reach)do
if(b-cx)*(b-cx)+(a-cy)*(a-cy)<=reach*reach then
revealed[e(map,b,a)]=true
end
end
end
end

function c.wholeIslets(map,state)
local b={}
for j,a in ipairs(map.islets)do
local h=#a.lights>0
for k,i in ipairs(a.lights)do
if not g.hasFlag(state,i)then
h=false
end
end
if h then
b[a.id]=true
end
end
return b
end

function c.revealFor(map,state)
local b={}
for h,a in ipairs(map.lamps)do
if a.flag==nil or g.hasFlag(state,a.flag)then
q(map,b,a.x,a.y,c.LAMP_REACH)
end
end
for h,a in ipairs(map.objects)do
if a.kind=="watchlight"and g.hasFlag(state,a.flag)then
q(map,b,a.x+a.door,a.y+a.h-1,c.WATCH_REACH)
end
end
local a=c.wholeIslets(map,state)
for n,h in ipairs(map.islets)do
if a[h.id]then
for p,i in ipairs(h.tiles)do
local j,k=(i-1)%map.width,math.floor((i-1)/map.width)
for l=math.max(0,k-c.ISLET_RIM),math.min(map.height-1,k+c.ISLET_RIM)do
for m=math.max(0,j-c.ISLET_RIM),math.min(map.width-1,j+c.ISLET_RIM)do
b[e(map,m,l)]=true
end
end
end
end
end
return b,a
end

function c:refreshReveal()
local h,b=c.revealFor(self.map,self.game.state)
local a=0
if self.whole then
for i in pairs(b)do
if not self.whole[i]then
a=a+1
end
end
end
self.revealed=h
self.whole=b
return a
end

function c:revealedAt(x,y)
if not self.map.fog then
return true
end
return self.revealed[e(self.map,x,y)]==true
end

function c:seenAt(x,y)
if self:revealedAt(x,y)then
return true
end
local a,b=x-self.player.x,y-self.player.y
return a*a+b*b<=c.HALO
end

function c:regionAt(x,y)
local a=self.map.regionRows
if not a or x<0 or y<0 or x>=self.map.width or y>=self.map.height then
return nil
end
return self.map.regions[tonumber(string.sub(a[y+1],x+1,x+1))]
end

function c:wallAt(x,y)
for b,a in ipairs(self.map.walls)do
if x>=a.x and x<a.x+a.w and y>=a.y and y<a.y+a.h and not g.hasFlag(self.game.state,a.flag)then
return a
end
end
return nil
end

function c:fixtureAt(list,x,y)
for b,a in ipairs(list)do
if a.x==x and a.y==y and self:revealedAt(x,y)then
return a
end
end
return nil
end

function c:chestAt(x,y)
return self:fixtureAt(self.map.chests,x,y)
end

function c:noteAt(x,y)
local a=self:fixtureAt(self.map.notes,x,y)
if a and not g.hasFlag(self.game.state,"p_"..a.page)then
return a
end
return nil
end

function c:echoAt(x,y)
local a=self:fixtureAt(self.map.echoes,x,y)
if a and not g.hasFlag(self.game.state,"e_"..a.echo)then
return a
end
return nil
end

function c:bellpostAt(x,y)
local a=self.map.bellpost
return a~=nil and a.x==x and a.y==y and g.meets(self.game.state,a.when)
end

function c:npcAt(x,y)
for b,a in pairs(self.npcs)do
if(a.x==x and a.y==y)or(a.moving and a.fromX==x and a.fromY==y)then
return a
end
end
return nil
end

function c:blocked(x,y,ignorePlayer)
local a=self.map
if x<0 or y<0 or x>=a.width or y>=a.height then
return true
end
if a.solid[e(a,x,y)]then
return true
end
if self:gateClosed(x,y)or self:wallAt(x,y)or self:chestAt(x,y)or self:noteAt(x,y)or self:echoAt(x,y)or self:lampAt(x,y)or self:bellpostAt(x,y)then
return true
end
if self:npcAt(x,y)then
return true
end
if not ignorePlayer and self.player.x==x and self.player.y==y then
return true
end
return false
end

function c:startStep(actor,dir,speed)
local a=d.DIRECTIONS[dir]
actor.dir=dir
actor.fromX,actor.fromY=actor.x,actor.y
actor.x,actor.y=actor.x+a.dx,actor.y+a.dy
actor.moving=true
actor.walked=0
actor.speed=speed
end

function c:advanceActor(actor)
if not actor.moving then
return false
end
actor.walked=actor.walked+actor.speed
actor.frame=actor.frame+1
local a=d.DIRECTIONS[actor.dir]
if actor.walked>=f then
actor.moving=false
actor.px,actor.py=actor.x*f,actor.y*f
return true
end
actor.px=actor.fromX*f+a.dx*actor.walked
actor.py=actor.fromY*f+a.dy*actor.walked
return false
end

local function v(fromX,fromY,toX,toY)
for b,a in ipairs(d.DIRECTIONS)do
if fromX+a.dx==toX and fromY+a.dy==toY then
return b
end
end
return nil
end

function c:pullFollowers(leaderFromX,leaderFromY,speed)
local b,h=leaderFromX,leaderFromY
for l,a in ipairs(self.followers)do
local j,k=a.x,a.y
if a.x~=b or a.y~=h then
local i=v(a.x,a.y,b,h)
if i then
self:startStep(a,i,speed)
else
a.x,a.y=b,h
a.px,a.py=b*f,h*f
end
end
b,h=j,k
end
end

function c:walkPlayer(dir,running)
local a=self.player
local h=d.DIRECTIONS[dir]
a.dir=dir
if self:blocked(a.x+h.dx,a.y+h.dy,true)then
return false
end
local i,j=a.x,a.y
local b=c.WALK_SPEED
if running then
b=c.RUN_SPEED
end
self:startStep(a,dir,b)
self:pullFollowers(i,j,b)
return true
end

function c:encountersHere()
local a=self.map.encounters
if a and a.zones then
return a.zones[self:regionAt(self.player.x,self.player.y)]
end
return a
end

function c:resetEncounter()
local a=self:encountersHere()
if a then
local b=self.game.random
self.encounterSteps=b:int(math.floor(a.rate*c.ENCOUNTER_MIN),math.floor(a.rate*c.ENCOUNTER_MAX))
end
end

function c:countStep()
local a=self:encountersHere()
local h=self.game.state
if not a or not g.meets(h,a.when)then
return nil
end
local i=self.player
if self:revealedAt(i.x,i.y)then
self.encounterSteps=self.encounterSteps-1
else
self.encounterSteps=self.encounterSteps-c.VEIL_STEPS
end
if self.encounterSteps>0 then
return nil
end
self:resetEncounter()
local j=self.game.random
local b=a.troops
if a.late and g.meets(h,a.late.when)then
b=a.late.troops
end
if a.rares and j:chance(c.RARE_CHANCE)then
b=a.rares
end
return b[j:int(1,#b)]
end

function c:warpAt(x,y)
for i,a in ipairs(self.map.warps)do
local b,h=a.w or 1,a.h or 1
if x>=a.x and x<a.x+b and y>=a.y and y<a.y+h and g.meets(self.game.state,a.when)then
return a
end
end
return nil
end

function c:besideWarp(x,y)
if self:warpAt(x,y)then
return true
end
for b=1,4 do
local a=d.DIRECTIONS[b]
if self:warpAt(x+a.dx,y+a.dy)then
return true
end
end
return false
end

function c:eventAt(x,y)
for i,a in ipairs(self.map.events)do
local b,h=a.w or 1,a.h or 1
if x>=a.x and x<a.x+b and y>=a.y and y<a.y+h and g.meets(self.game.state,a.when)then
return a
end
end
return nil
end

function c:facingTile()
local a=d.DIRECTIONS[self.player.dir]
return self.player.x+a.dx,self.player.y+a.dy
end

function c:signAt(x,y)
for b,a in ipairs(self.map.signs)do
if a.x==x and a.y==y then
return a
end
end
return nil
end

function c:interactionAhead()
local a,b=self:facingTile()
local h=d.DIRECTIONS[self.player.dir]
local i=1
local j=c.charAt(self.map,a,b)
if j and o.get(j).kind=="counter"then
a,b=a+h.dx,b+h.dy
i=2
end
local k=self:npcAt(a,b)
if k then
return"npc",k
end
if i==1 then
local l=self:chestAt(a,b)
if l then
return"chest",l
end
local m=self:noteAt(a,b)
if m then
return"note",m
end
local n=self:echoAt(a,b)
if n then
return"echo",n
end
local p=self:lampAt(a,b)
if p then
return"lamp",p
end
local r=self:signAt(a,b)
if r then
return"sign",r
end
if self:bellpostAt(a,b)then
return"bell",self.map.bellpost
end
end
return nil,nil
end

function c:wanderNpcs()
local l=self.game.random
for r,a in pairs(self.npcs)do
local j=a.definition
if j and j.wander and not a.moving and not a.path then
local i=c.WANDER
if j.roam then
i=c.ROAM
end
a.wanderTimer=a.wanderTimer-1
if a.wanderTimer<=0 then
a.wanderTimer=l:int(i.min,i.max)
local k=l:int(1,4)
local m=d.DIRECTIONS[k]
local b,h=a.x+m.dx,a.y+m.dy
local n=math.abs(b-a.home.x)<=i.reach and math.abs(h-a.home.y)<=i.reach
local p=not j.roam or(not self:besideWarp(b,h)and not self:eventAt(b,h)and c.charAt(self.map,b,h)~="=")
a.dir=k
if n and p and not self:blocked(b,h)and not self:followerOn(b,h)then
self:startStep(a,k,c.WALK_SPEED)
end
end
end
end
end

function c:followerOn(x,y)
for b,a in ipairs(self.followers)do
if a.x==x and a.y==y then
return true
end
end
return false
end

function c:offScreen(x,y)
local a=self.camera
return(x+1)*f<=a.x or x*f>=a.x+d.WIDTH or(y+1)*f<=a.y or y*f>=a.y+d.HEIGHT
end

function c:stepsFrom(goal)
local a=self.map
local k={[e(a,goal.x,goal.y)]=0}
local b={{goal.x,goal.y}}
local h=1
while h<=#b do
local l,m=b[h][1],b[h][2]
h=h+1
local r=k[e(a,l,m)]
for s=1,4 do
local n=d.DIRECTIONS[s]
local i,j=l+n.dx,m+n.dy
if i>=0 and j>=0 and i<a.width and j<a.height then
local p=e(a,i,j)
if k[p]==nil and not self:blocked(i,j,true)then
k[p]=r+1
b[#b+1]={i,j}
end
end
end
end
return k
end

function c:pathOffScreen(actor,goal)
local w=self:stepsFrom(goal)
local a=self.map
local x=e(a,actor.x,actor.y)
local b={[x]=false}
local h={{actor.x,actor.y}}
local i=1
local y={"d","u","l","r"}
local n,r=nil,nil
while i<=#h do
local j,k=h[i][1],h[i][2]
i=i+1
if self:offScreen(j,k)then
local l=w[e(a,j,k)]
if l and(not n or l<r)then
n,r=e(a,j,k),l
end
else
for s=1,4 do
local t=d.DIRECTIONS[s]
local l,m=j+t.dx,k+t.dy
local p=l>=0 and m>=0 and l<a.width and m<a.height and e(a,l,m)
if p and b[p]==nil and not self:blocked(l,m,true)then
b[p]={index=e(a,j,k),letter=y[s]}
h[#h+1]={l,m}
end
end
end
end
if not n then
return nil
end
local k={}
local j=n
while b[j]do
table.insert(k,1,b[j].letter)
j=b[j].index
end
return table.concat(k)
end

function c:setPath(actor,letters)
local a={}
local h={d=1,u=2,l=3,r=4}
for b=1,string.len(letters)do
a[#a+1]=h[string.sub(letters,b,b)]
end
actor.path=a
end

function c:advancePaths()
local h=false
local b={self.player}
for i,a in pairs(self.npcs)do
b[#b+1]=a
end
for l,a in ipairs(b)do
if a.path and not a.moving then
if#a.path==0 then
a.path=nil
else
local i=table.remove(a.path,1)
if a==self.player then
local j,k=a.x,a.y
self:startStep(a,i,c.WALK_SPEED)
self:pullFollowers(j,k,c.WALK_SPEED)
else
self:startStep(a,i,c.WALK_SPEED)
end
end
end
if a.path then
h=true
end
end
return h
end

function c:advanceActors()
local a=self:advanceActor(self.player)
for h,b in ipairs(self.followers)do
self:advanceActor(b)
end
for h,b in pairs(self.npcs)do
self:advanceActor(b)
end
return a
end

function c:updateCamera()
local j=self.map
local h,i=j.width*f,j.height*f
local a=self.player.px+f/2-d.WIDTH/2
local b=self.player.py+f/2-d.HEIGHT/2
if h<=d.WIDTH then
a=(h-d.WIDTH)/2
else
a=SpiffBoy.clamp(a,0,h-d.WIDTH)
end
if i<=d.HEIGHT then
b=(i-d.HEIGHT)/2
else
b=SpiffBoy.clamp(b,0,i-d.HEIGHT)
end
self.camera.x=math.floor(a)
self.camera.y=math.floor(b)
end

function c:drawOrder()
local h={}
for b,a in pairs(self.npcs)do
h[#h+1]=a
end
for a=#self.followers,1,-1 do
h[#h+1]=self.followers[a]
end
h[#h+1]=self.player
table.sort(h,function(a,b)
if a.py==b.py then
return a.id<b.id
end
return a.py<b.py
end)
return h
end
