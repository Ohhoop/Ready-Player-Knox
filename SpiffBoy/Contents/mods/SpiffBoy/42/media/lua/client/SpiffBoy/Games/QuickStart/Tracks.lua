require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Maps/Circuits"
require"SpiffBoy/Games/QuickStart/Art"

local p=SpiffBoy.QuickStart

local a={}
p.Tracks=a

local l=p.TILE
local m=string.byte
local b=math.floor

a.ROAD="road"
a.OFFROAD="offroad"
a.MUD="mud"
a.WATER="water"
a.WALL="wall"
a.BOOST="boost"
a.RAMP="ramp"

a.DECOR_CELL=64
a.SOLID_CELL=32
a.SOLID_MARGIN=4
a.UNIT=256

a.CHECKER=-1
a.STRIPES=-2

local g=a.CHECKER
local d=a.STRIPES

local k,s,x,y,t,z,A=a.ROAD,a.OFFROAD,a.MUD,a.WATER,a.WALL,a.BOOST,a.RAMP

local function e(h,i,j,n)
local c,f={},{}
for o,q in pairs(j)do
c[m(o)]=q
end
for o,q in pairs(n)do
f[m(o)]=q
end
return{clear=m(h),sky=i,shades=c,surfaces=f}
end

local B={["#"]=k,c=k,k=k,f=k,w=k,s=k,b=z,r=A,o=x,["~"]=y,["="]=t,["."]=s}

local function f(h)
local c={}
for i,j in pairs(B)do
c[i]=j
end
for i,j in pairs(h or{})do
c[i]=j
end
return c
end

a.STYLES={
town=e(".","sky_town",{["."]=3,["#"]=2,c=4,w=4,o=2,s=g,b=d,r=1},f()),
docks=e("~","sky_docks",{["~"]=1,["."]=2,["#"]=3,w=4,o=2,s=g,b=d,r=1},f()),
woods=e(".","sky_woods",{["."]=1,["#"]=3,k=4,f=1,o=2,s=g,b=d,r=2},f()),
farm=e(".","sky_farm",{["."]=3,["#"]=4,w=2,["~"]=1,s=g,b=d,r=2},f()),
mall=e(".","sky_mall",{["."]=2,["#"]=3,c=4,w=4,s=g,b=d,r=1},f({w=s})),
prison=e(".","sky_prison",{["."]=4,["#"]=2,k=1,f=4,["="]=1,s=g,b=d,r=1},f()),
highway=e(".","sky_highway",{["."]=3,["#"]=1,c=4,w=2,s=g,b=d,r=2},f()),
military=e(".","sky_military",{["."]=4,["#"]=2,k=1,f=4,w=3,["="]=1,s=g,b=d,r=1},f()),
station=e("#","sky_station",{["#"]=2,["="]=4,w=4,c=3,o=1,b=d,["."]=3},f({w=t})),
lot=e("#","sky_lot",{["#"]=2,["="]=4,w=4,["."]=3,b=d},f()),
}

a.DECOR={
house={art="house",radius=10},tree={art="tree",radius=4},lamp={art="lamp",radius=2},
mailbox={art="mailbox",radius=2},car={art="car",radius=7},bollard={art="bollard",radius=2},
crate_stack={art="crate_stack",radius=6},barrel={art="barrel",radius=3},boat={art="boat",radius=0},
buoy={art="buoy",radius=0},pine={art="pine",radius=4},stump={art="stump",radius=3},
rock={art="rock",radius=5},fence={art="fence",radius=3},hay={art="hay",radius=5},
scarecrow={art="scarecrow",radius=2},corn={art="corn",radius=3},barn={art="barn",radius=20},
silo={art="silo",radius=10},cart={art="cart",radius=3},cone={art="cone",radius=2},
sign={art="sign",radius=2},fencepost={art="fencepost",radius=2},light={art="light",radius=2},
tower={art="tower",radius=8},bench={art="bench",radius=3},guardrail={art="guardrail",radius=3},
billboard={art="billboard",radius=4},sandbag={art="sandbag",radius=5},tank={art="tank",radius=12},
barracks={art="barracks",radius=18},jeep={art="jeep",radius=7},pump={art="pump",radius=4},
house2={art="house2",radius=10},
garage_house={art="garage_house",radius=12},
picket={art="picket",radius=3},
hydrant={art="hydrant",radius=2},
trashcans={art="trashcans",radius=2},
busstop={art="busstop",radius=6},
policecar={art="policecar",radius=7},
warehouse={art="warehouse",radius=16},
container={art="container",radius=7},
quaycrane={art="quaycrane",radius=6},
forklift={art="forklift",radius=4},
pallets={art="pallets",radius=4},
shack={art="shack",radius=5},
cabin={art="cabin",radius=9},
logpile={art="logpile",radius=5},
fallenlog={art="fallenlog",radius=6},
bush={art="bush",radius=3},
camp={art="camp",radius=5},
deerstand={art="deerstand",radius=3},
tractor={art="tractor",radius=5},
windmill={art="windmill",radius=3},
well={art="well",radius=3},
coop={art="coop",radius=4},
pumpkins={art="pumpkins",radius=0},
wagon={art="wagon",radius=6},
van={art="van",radius=7},
pickup={art="pickup",radius=7},
cartcorral={art="cartcorral",radius=5},
planter={art="planter",radius=3},
mallsign={art="mallsign",radius=3},
barricade={art="barricade",radius=4},
barbed={art="barbed",radius=3},
prisonbus={art="prisonbus",radius=12},
hoop={art="hoop",radius=2},
weights={art="weights",radius=3},
booth={art="booth",radius=4},
searchlight={art="searchlight",radius=2},
pillar={art="pillar",radius=4},
jersey={art="jersey",radius=6},
truck={art="truck",radius=12},
burningcar={art="burningcar",radius=7},
bus={art="bus",radius=13},
exitsign={art="exitsign",radius=2},
helipad={art="helipad",radius=10},
humvee={art="humvee",radius=7},
ammo={art="ammo",radius=3},
armytent={art="armytent",radius=8},
radar={art="radar",radius=3},
flagpole={art="flagpole",radius=1},
carwash={art="carwash",radius=0},
icebox={art="icebox",radius=4},
propane={art="propane",radius=4},
tires={art="tires",radius=3},
statue={art="statue",radius=4},
drivethru={art="drivethru",radius=2},
picnic={art="picnic",radius=4},
storefront={art="storefront",radius=0},
spiffos={art="spiffos",radius=0},
dumpster={art="dumpster",radius=5},
}

local function C(q,r)
local i=a.DECOR_CELL
local c=math.ceil(r/i)
local j={}
for h=1,c*c do
j[h]={}
end
for D,h in ipairs(q)do
if a.DECOR[h.kind]then
local n="decor_"..h.kind
local u={art=n,entry=p.Atlas[n],x=h.x,y=h.y}
local v=math.min(c-1,math.max(0,b(h.x/i)))
local w=math.min(c-1,math.max(0,b(h.y/i)))
local o=j[w*c+v+1]
o[#o+1]=u
end
end
return j,c
end

local function D(r,u)
local i=a.SOLID_CELL
local h=math.ceil(u/i)
local o={}
for c=1,h*h do
o[c]={}
end
for J,c in ipairs(r)do
local j=a.DECOR[c.kind]
if j and j.radius>0 then
local v={x=c.x*a.UNIT,y=c.y*a.UNIT,radius=j.radius*a.UNIT}
local n=j.radius+a.SOLID_MARGIN+1
local w,E=math.max(0,b((c.x-n)/i)),math.min(h-1,b((c.x+n)/i))
local F,G=math.max(0,b((c.y-n)/i)),math.min(h-1,b((c.y+n)/i))
for H=F,G do
for I=w,E do
local q=o[H*h+I+1]
q[#q+1]=v
end
end
end
end
return o,h
end

function a.solidsNear(c,o,q)
local n=a.SOLID_CELL*a.UNIT
local h,i=b(o/n),b(q/n)
local j=c.solidCount
if h<0 or i<0 or h>=j or i>=j then
return c.noSolids
end
return c.solidCells[i*j+h+1]
end

local function E(n,u,v,o,w,F)
local c=0
local i,r=1,#n
while i<=r do
local G=m(n,i)
local h=i+1
local j=0
while h<=r do
local q=m(n,h)-48
if q<0 or q>9 then
break
end
j=j*10+q
h=h+1
end
for H=1,j do
local q=c+H-1
local I=w and(o-1-q)or q
u[v+I+1]=G
end
c=c+j
i=h
end
if c~=o then
error("QuickStart: a row of map "..F.." decodes to "..c.." tiles instead of "..o)
end
end

local function q(i,j,n)
local h={}
for o,c in ipairs(i or{})do
h[o]={x=n and(j-c[1])or c[1],y=c[2]}
end
return h
end

local function F(i,j,n)
local h={}
for o,c in pairs(i or{})do
h[o]={points=q(c.points,j,n),loopFrom=c.loop[1],loopLength=c.loop[2]}
end
return h
end

function a.load(n,i)
local c=p.Maps[n]
if not c then
error("QuickStart: no map named "..tostring(n))
end
local j=c.size
local u={}
for h=1,j do
E(c.rows[h],u,(h-1)*j,j,i,n)
end
local h=j*l
local r={}
for v,o in ipairs(c.objects)do
r[v]={kind=o[1],x=i and(h-o[2])or o[2],y=o[3]}
end
local o=a.STYLES[c.style]
if not o then
error("QuickStart: map "..n.." has no style "..tostring(c.style))
end
local G,H=C(r,h)
local I,J=D(r,h)
local v={}
local K=o.shades[o.clear]
for w=1,j*j do
v[w]=o.shades[u[w]]or K
end
return{
id=n,kind=c.kind,mirrored=i,size=j,extent=h,cells=u,style=o,shadeGrid=v,
decorCells=G,decorCount=H,solidCells=I,solidCount=J,noSolids={},
waypoints=q(c.waypoints,h,i),spawns=q(c.spawns,h,i),
targets=q(c.targets,h,i),paths=F(c.paths,h,i),objects=r,
}
end

function a.at(c,n,o)
local h,i=b(n/l),b(o/l)
local j=c.size
if h<0 or i<0 or h>=j or i>=j then
return c.style.clear
end
return c.cells[i*j+h+1]
end

function a.surfaceAt(c,n,o)
local h,i=b(n/l),b(o/l)
local j=c.size
if h<0 or i<0 or h>=j or i>=j then
return t
end
return c.style.surfaces[c.cells[i*j+h+1]]or s
end
