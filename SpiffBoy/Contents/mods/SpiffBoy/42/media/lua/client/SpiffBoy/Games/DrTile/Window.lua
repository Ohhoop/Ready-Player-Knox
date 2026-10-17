require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.DrTile=SpiffBoy.DrTile or{}

local c={}
c.__index=c
SpiffBoy.DrTile.Window=c

local a=SpiffBoy.Cartridges.SHADES[4]
local b=SpiffBoy.Cartridges.SHADES[1]
local d=SpiffBoy.Cartridges.SCREEN_WIDTH
local f=SpiffBoy.Cartridges.SCREEN_HEIGHT

local l=17
local p=5
local q=5
local m=15
local n=1
local g=11
local o=3
local r=1
local s=13
local t=4
local h=5

c.ROW_LEFT=6
c.ROW_RIGHT=d-6
c.TUBE_TICKS=14

function c.new(i,j,k)
local e=setmetatable({},c)
e.sheet=i
e.crossX=j
e.crossSize=k
return e
end

function c:draw(e,k)
e:clear(a.r,a.g,a.b)
e:rect(0,0,d,f,b.r,b.g,b.b,1)
e:rect(1,l,d-2,f-l-1,a.r,a.g,a.b,1)
e:sheet(self.sheet,self.crossX,0,self.crossSize,self.crossSize,p,q,1,t)
e:text(k,m,n,a.r,a.g,a.b,1)
local i=d-o-g
local j=o
e:rect(i,j,g,g,a.r,a.g,a.b,1)
e:textCentre("x",i+math.floor(g/2)+1,j-math.floor((e:lineHeight()-g)/2)-1,b.r,b.g,b.b,1)
end

function c.titleNote(e,i,j,k)
local u=m+e:textWidth(i)+j
e:text(k,u,n,a.r,a.g,a.b,1)
end

function c.rowBar(i,e,j,k)
i:rect(e,k+r,j-e,s,b.r,b.g,b.b,1)
end

function c.drawTube(e,u)
local j=c.TUBE_TICKS-u
local i=math.floor(f/2)
if j<h then
e:rect(0,0,d,f,b.r,b.g,b.b,1)
local k=math.floor(d*(j+1)/h)
e:rect(math.floor((d-k)/2),i,k,1,a.r,a.g,a.b,1)
return
end
local v=(j-h+1)/(c.TUBE_TICKS-h)
local k=math.floor(f*v/2)
e:rect(0,0,d,i-k,b.r,b.g,b.b,1)
e:rect(0,i+k,d,f-i-k,b.r,b.g,b.b,1)
end
