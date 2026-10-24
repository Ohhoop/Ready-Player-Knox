require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"

SpiffBoy.DrTile=SpiffBoy.DrTile or{}

local c={}
c.__index=c
SpiffBoy.DrTile.Window=c

local a=SpiffBoy.Cartridges.SHADES[4]
local b=SpiffBoy.Cartridges.SHADES[1]
local d=SpiffBoy.Cartridges.SCREEN_WIDTH
local e=SpiffBoy.Cartridges.SCREEN_HEIGHT

local k=17
local o=5
local p=5
local l=15
local m=1
local f=11
local n=3
local q=1
local r=13
local s=4
local g=5

c.ROW_LEFT=6
c.ROW_RIGHT=d-6
c.TUBE_TICKS=14

function c.new(sheet,crossX,crossSize)
local h=setmetatable({},c)
h.sheet=sheet
h.crossX=crossX
h.crossSize=crossSize
return h
end

function c:draw(screen,title)
screen:clear(a.r,a.g,a.b)
screen:rect(0,0,d,e,b.r,b.g,b.b,1)
screen:rect(1,k,d-2,e-k-1,a.r,a.g,a.b,1)
screen:sheet(self.sheet,self.crossX,0,self.crossSize,self.crossSize,o,p,1,s)
screen:text(title,l,m,a.r,a.g,a.b,1)
local h=d-n-f
local i=n
screen:rect(h,i,f,f,a.r,a.g,a.b,1)
screen:textCentre("x",h+math.floor(f/2)+1,i-math.floor((screen:lineHeight()-f)/2)-1,b.r,b.g,b.b,1)
end

function c.titleNote(screen,title,gap,note)
local h=l+screen:textWidth(title)+gap
screen:text(note,h,m,a.r,a.g,a.b,1)
end

function c.rowBar(screen,left,right,y)
screen:rect(left,y+q,right-left,r,b.r,b.g,b.b,1)
end

function c.drawTube(screen,remaining)
local i=c.TUBE_TICKS-remaining
local h=math.floor(e/2)
if i<g then
screen:rect(0,0,d,e,b.r,b.g,b.b,1)
local j=math.floor(d*(i+1)/g)
screen:rect(math.floor((d-j)/2),h,j,1,a.r,a.g,a.b,1)
return
end
local t=(i-g+1)/(c.TUBE_TICKS-g)
local j=math.floor(e*t/2)
screen:rect(0,0,d,h-j,b.r,b.g,b.b,1)
screen:rect(0,h+j,d,e-h-j,b.r,b.g,b.b,1)
end
