require"SpiffBoy/Games/QuickStart/Base"

local e=SpiffBoy.QuickStart

local c={}
e.GrandPrix=c

c.CUPS={
{id="spiffo",tracks={"Muldraugh","Riverside","MarchRidge","EchoCreek"}},
{id="knox",tracks={"WestPoint","Rosewood","Louisville","KnoxBase"}},
}
c.ARENAS={"GasStation","SpiffosLot"}
c.POINTS={10,8,6,4,3,2,1,0}
c.PODIUM=3

function c.new(cupIndex,drivers)
local d={}
for b,a in ipairs(drivers)do
d[b]={driver=a.driver,seat=a.seat,points=0,last=0}
end
table.sort(d,function(a,b)
if(a.seat~=nil)~=(b.seat~=nil)then
return a.seat==nil
end
return a.driver<b.driver
end)
return{cup=cupIndex,race=1,standings=d}
end

function c.track(gp)
return c.CUPS[gp.cup].tracks[gp.race]
end

function c.grid(gp)
local a={}
for d,b in ipairs(gp.standings)do
a[d]={driver=b.driver,seat=b.seat}
end
return a
end

function c.score(gp,world)
for d,b in ipairs(world.karts)do
local a=gp.standings[d]
a.gained=c.POINTS[b.rank]or 0
a.points=a.points+a.gained
a.last=b.rank
end
table.sort(gp.standings,function(a,b)
if a.points~=b.points then
return a.points>b.points
end
return a.last<b.last
end)
end

function c.advance(gp)
if gp.race>=#c.CUPS[gp.cup].tracks then
return false
end
gp.race=gp.race+1
return true
end

function c.placeOfPlayers(gp)
for a,b in ipairs(gp.standings)do
if b.seat then
return a
end
end
return#gp.standings
end
