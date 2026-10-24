require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Grid"
require"SpiffBoy/Games/PipeBomber/Bombs"
require"SpiffBoy/Games/PipeBomber/Actors"
require"SpiffBoy/Games/PipeBomber/Bosses"

local d=SpiffBoyPipeBomberGame
local m=SpiffBoy.PipeBomber
local J=m.Zones
local j=m.Grid
local z=m.Bombs
local A=m.Actors
local K=m.Bosses

local q=SpiffBoy.Cartridges.SHADES
local e=q[4]
local i=q[1]
local s=SpiffBoy.Cartridges.SCREEN_WIDTH
local c=J.TILE
local g=d.gameText

local h={top=12,width=180,height=108}
local n={1,2,3,4}
local L={1,2,3}
local B={1,2,3}
local M=25
local N={1,2,3}
local O={2,4}
local P={2,3,4}
local o={size=16,left=2,up=4}
local C={normal=24,big=32}
local Q={breaking=4}
local R={pipe=0,aerosol=2,molotov=4,grenade=0}
local S=12
local D={closed=0,open=1}
local T=15
local U=10
local E={range=0,count=1,speed=2,detonator=3,kick=4,pass=5,vest=6,aerosol=7,molotov=8}
local V={5,4,2}
local F=5.5
local W=1
local X={ball={size=3,shade=4},bile={size=4,shade=2}}
local f={height=12,headX=2,headY=2,livesX=12,iconX=22,timeX=40,scoreRight=178,textY=-2,warn=180,warnBlink=8,scoreDigits=6}
local Y="%0"..f.scoreDigits.."d"
local p={y=34,height=52,first=38,second=54,third=70}
local Z=15
local _={"detonator","kick","pass","vest"}

function d:camera()
local a=self.grid
local b=self.survivor
local k=a.columns*c-h.width
local l=a.rows*c-h.height
local r=math.floor(b.x+c/2-h.width/2)
local t=math.floor(b.y+c/2-h.height/2)
return SpiffBoy.clamp(r,0,k),SpiffBoy.clamp(t,0,l)
end

function d:drawArena(screen)
local b=self.art.arenas[self.zone.key]
local k=self.grid.rows*c
for l,a in ipairs(L)do
screen:sheet(b,self.camX,(a-1)*k+self.camY,h.width,h.height,0,h.top,1,a)
end
end

function d:toScreen(x,y)
return math.floor(x-self.camX),math.floor(y-self.camY)+h.top
end

function d:visibleCells()
local a=self.grid
local b=math.floor(self.camX/c)+1
local k=math.min(a.columns,math.floor((self.camX+h.width-1)/c)+1)
local l=math.floor(self.camY/c)+1
local r=math.min(a.rows,math.floor((self.camY+h.height-1)/c)+1)
return b,k,l,r
end

function d:drawCrateRun(screen,column,row,count,down)
local b,k=self:toScreen((column-1)*c,(row-1)*c)
local l=self.zone.key
for r,a in ipairs(B)do
if down then
screen:sheet(self.art.crateColumns[l],0,(a-1)*M*c,c,count*c,b,k,1,a)
else
screen:sheet(self.art.crates[l],0,(a-1)*c,count*c,c,b,k,1,a)
end
end
end

function d:drawCrates(screen,first,last,top,bottom)
local b=self.grid
local l={}
for k=top,bottom do
local a=first
while a<=last do
if b:kind(a,k)==j.CRATE then
local r=a
while a+1<=last and b:kind(a+1,k)==j.CRATE do
a=a+1
end
if a>r then
self:drawCrateRun(screen,r,k,a-r+1,false)
for t=r,a do
l[b:index(t,k)]=true
end
end
end
a=a+1
end
end
for k=first,last do
local a=top
while a<=bottom do
if b:kind(k,a)==j.CRATE then
local r=a
local t=l[b:index(k,a)]and 0 or 1
while a+1<=bottom and b:kind(k,a+1)==j.CRATE do
a=a+1
if not l[b:index(k,a)]then
t=t+1
end
end
if t>=2 then
self:drawCrateRun(screen,k,r,a-r+1,true)
for u=r,a do
l[b:index(k,u)]=true
end
end
end
a=a+1
end
end
for a=top,bottom do
for k=first,last do
if b:kind(k,a)==j.CRATE and not l[b:index(k,a)]then
self:drawCrateRun(screen,k,a,1,false)
end
end
end
end

function d:drawCell(screen,texture,frame,x,y,shades)
local a,b=self:toScreen(x,y)
screen:layers(texture,frame*c,c,c,a,b,shades)
end

function d:drawFloorThings(screen,first,last,top,bottom)
local a=self.grid
local r=self.art.tiles[self.zone.key]
for u,b in ipairs(a.breaking)do
local k,l=a:cellOf(b.index)
local t=math.min(2,math.floor((j.BREAK_TICKS-b.timer)*3/j.BREAK_TICKS))
self:drawCell(screen,r,Q.breaking+t,(k-1)*c,(l-1)*c,B)
end
if a.exitShown then
local k,l=a:cellOf(a.exitIndex)
local b=D.closed
if a.exitOpen then
b=D.open+math.floor(self.clock/T)%2
end
self:drawCell(screen,self.art.hatch,b,(k-1)*c,(l-1)*c,n)
end
for b=top,bottom do
for k=first,last do
local l=a:itemAt(k,b)
if l then
self:drawCell(screen,self.art.bonuses,E[l],(k-1)*c,(b-1)*c,n)
end
end
end
end

function d:drawBombs(screen)
local b=math.floor(self.clock/S)%2
for k,a in ipairs(self.bombs.list)do
self:drawCell(screen,self.art.bombs,R[a.kind]+b,a.x,a.y,n)
end
local k=math.floor(self.clock/U)%2
for u,a in ipairs(self.bombs.fires)do
if a.timer<=z.FIRE_TICKS then
for v,l in ipairs(a.cells)do
local r,t=self.grid:cellOf(l)
self:drawCell(screen,self.art.fire,k,(r-1)*c,(t-1)*c,N)
end
end
end
end

function d:drawBlasts(screen)
for ad,b in ipairs(self.bombs.blasts)do
local aa=V[z.strength(b)]
local t,u=(b.column-1)*c,(b.row-1)*c
local k=b.arms
local G,ab=t-k.left*c,t+(k.right+1)*c
local H,ac=u-k.up*c,u+(k.down+1)*c
for v=0,3 do
local w=aa+0.5-v
if w>=0.5 then
local l=math.ceil(F-w)
local I=math.floor(F+w)
local r=W+v
local a=q[v+1]
local x,y=self:toScreen(G+r,u+l)
screen:rect(x,y,ab-G-r*2,I-l+1,a.r,a.g,a.b,1)
x,y=self:toScreen(t+l,H+r)
screen:rect(x,y,I-l+1,ac-H-r*2,a.r,a.g,a.b,1)
end
end
end
end

function d:drawActor(screen,texture,frame,actor)
local a,b=self:toScreen(actor.x-o.left,actor.y-o.up)
screen:layers(texture,frame*o.size,o.size,o.size,a,b,n)
end

function d:drawBoss(screen)
local a=self.boss
local b=a.stats.big and C.big or C.normal
local k,l=self:toScreen(a.x+c/2-b/2,a.y+c-b)
screen:layers(self.art.bosses[a.kind],K.frame(a,self.clock)*b,b,b,k,l,n)
end

local function u(timer)
return timer>0 and math.floor(timer/4)%2==1
end

local y={}
local v=nil

local function G(a,b)
if a.y~=b.y then
return a.y<b.y
end
return a==v
end

function d:drawActors(screen)
local l=self.survivor
local a=y
local H=#a
a[1]=l
local b=1
for r,k in ipairs(self.zombies)do
b=b+1
a[b]=k
end
if self.boss then
b=b+1
a[b]=self.boss
end
for k=b+1,H do
a[k]=nil
end
v=l
table.sort(a,G)
for r,k in ipairs(a)do
if k==l then
if not u(l.safe)then
self:drawActor(screen,self.art.survivor,A.survivorFrame(l),l)
end
elseif k==self.boss then
self:drawBoss(screen)
elseif not(k.state~="dying"and u(k.flash))then
self:drawActor(screen,self.art.zombies[k.kind],A.zombieFrame(k),k)
end
end
for I,r in ipairs(self.shots)do
local k=X[r.kind]
local w,x=self:toScreen(r.x-k.size/2,r.y-k.size/2)
screen:rect(w-1,x-1,k.size+2,k.size+2,i.r,i.g,i.b,1)
local t=q[k.shade]
screen:rect(w,x,k.size,k.size,t.r,t.g,t.b,1)
end
end

function d:shownPower()
local b,a=nil,nil
for r,l in ipairs(_)do
local k=self.timed[l]
if k>0 and(not a or k<a)then
b,a=l,k
end
end
if b then
return b,a
end
if self.special then
return self.special.kind,nil
end
return nil,nil
end

function d:clockText()
local a=math.ceil(self.timeLeft/SpiffBoy.TICK_RATE)
return string.format("%d:%02d",math.floor(a/60),a%60)
end

function d:drawHud(screen)
screen:rect(0,0,s,f.height,i.r,i.g,i.b,1)
screen:layers(self.art.hud,0,8,8,f.headX,f.headY,O)
screen:text(tostring(self.lives),f.livesX,f.textY,e.r,e.g,e.b,1)
local b,a=self:shownPower()
if b and not(a and a<f.warn and math.floor(a/f.warnBlink)%2==1)then
screen:layers(self.art.bonuses,E[b]*c,c,c,f.iconX,0,P)
end
local k=g("Time").." "..self:clockText()
screen:text(k,f.timeX,f.textY,e.r,e.g,e.b,1)
screen:textRight(string.format(Y,self.score),f.scoreRight,f.textY,e.r,e.g,e.b,1)
end

local function a(screen,first,second,third)
screen:rect(0,p.y,s,p.height,i.r,i.g,i.b,1)
local k=s/2
local l={{first,p.first},{second,p.second},{third,p.third}}
for r,b in ipairs(l)do
if b[1]then
screen:textCentre(b[1],k,b[2],e.r,e.g,e.b,1)
end
end
end

function d:drawIntro(screen)
local b=g(self.zone.name)
if self.level==1 then
local k=nil
if self.zone.password then
k=g("Password").." "..self.zone.password
end
a(screen,g("Zone",self.zoneIndex),b,k)
elseif self.bossLevel then
a(screen,g("Boss"),b,nil)
else
a(screen,g("Level",self.zoneIndex,self.level),b,nil)
end
end

function d:drawRun(screen)
screen:clear(e.r,e.g,e.b)
self.camX,self.camY=self:camera()
local k,l,r,t=self:visibleCells()
self:drawArena(screen)
self:drawCrates(screen,k,l,r,t)
self:drawFloorThings(screen,k,l,r,t)
self:drawBombs(screen)
self:drawBlasts(screen)
self:drawActors(screen)
self:drawHud(screen)
local b=self.phase
if b==d.PHASE_INTRO then
self:drawIntro(screen)
elseif self.paused then
a(screen,nil,getText("UI_SpiffBoy_Paused"),nil)
elseif b==d.PHASE_CLEAR then
a(screen,nil,g("LevelClear"),nil)
elseif b==d.PHASE_OVER then
a(screen,nil,g("GameOver"),nil)
elseif b==d.PHASE_ENDING then
a(screen,g("Ending"),nil,g("Score").." "..tostring(self.score))
elseif self.bannerTimer>0 and math.floor((d.BANNER_TICKS-self.bannerTimer)/Z)%2==0 then
a(screen,nil,g("Horde"),nil)
end
end

function d:draw(screen)
if self.mode==d.MODE_RUN then
self:drawRun(screen)
else
self:drawMenu(screen)
end
end
