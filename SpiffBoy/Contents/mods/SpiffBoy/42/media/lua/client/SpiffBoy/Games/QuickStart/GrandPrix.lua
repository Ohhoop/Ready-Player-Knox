require"SpiffBoy/Games/QuickStart/Base"

local e=SpiffBoy.QuickStart

local a={}
e.GrandPrix=a

a.CUPS={
{id="spiffo",tracks={"Muldraugh","Riverside","MarchRidge","EchoCreek"}},
{id="knox",tracks={"WestPoint","Rosewood","Louisville","KnoxBase"}},
}
a.ARENAS={"GasStation","SpiffosLot"}
a.POINTS={10,8,6,4,3,2,1,0}
a.PODIUM=3

function a.new(f,g)
local b={}
for d,c in ipairs(g)do
b[d]={driver=c.driver,seat=c.seat,points=0,last=0}
end
table.sort(b,function(c,d)
if(c.seat~=nil)~=(d.seat~=nil)then
return c.seat==nil
end
return c.driver<d.driver
end)
return{cup=f,race=1,standings=b}
end

function a.track(b)
return a.CUPS[b.cup].tracks[b.race]
end

function a.grid(d)
local b={}
for f,c in ipairs(d.standings)do
b[f]={driver=c.driver,seat=c.seat}
end
return b
end

function a.score(d,f)
for g,c in ipairs(f.karts)do
local b=d.standings[g]
b.gained=a.POINTS[c.rank]or 0
b.points=b.points+b.gained
b.last=c.rank
end
table.sort(d.standings,function(b,c)
if b.points~=c.points then
return b.points>c.points
end
return b.last<c.last
end)
end

function a.advance(b)
if b.race>=#a.CUPS[b.cup].tracks then
return false
end
b.race=b.race+1
return true
end

function a.placeOfPlayers(b)
for c,d in ipairs(b.standings)do
if d.seat then
return c
end
end
return#b.standings
end
