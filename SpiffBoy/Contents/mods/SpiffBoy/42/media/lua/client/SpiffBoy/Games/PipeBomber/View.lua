require"SpiffBoy/Core/Core"
require"SpiffBoy/Framework/Cartridges"
require"SpiffBoy/Games/PipeBomber/Zones"
require"SpiffBoy/Games/PipeBomber/Grid"
require"SpiffBoy/Games/PipeBomber/Bombs"
require"SpiffBoy/Games/PipeBomber/Actors"
require"SpiffBoy/Games/PipeBomber/Bosses"

local b=SpiffBoyPipeBomberGame
local m=SpiffBoy.PipeBomber
local K=m.Zones
local j=m.Grid
local z=m.Bombs
local A=m.Actors
local L=m.Bosses

local r=SpiffBoy.Cartridges.SHADES
local c=r[4]
local i=r[1]
local u=SpiffBoy.Cartridges.SCREEN_WIDTH
local a=K.TILE
local f=b.gameText

local g={top=12,width=180,height=108}
local n={1,2,3,4}
local M={1,2,3}
local B={1,2,3}
local N=25
local O={1,2,3}
local P={2,4}
local Q={2,3,4}
local o={size=16,left=2,up=4}
local C={normal=24,big=32}
local R={breaking=4}
local S={pipe=0,aerosol=2,molotov=4,grenade=0}
local T=12
local D={closed=0,open=1}
local U=15
local V=10
local E={range=0,count=1,speed=2,detonator=3,kick=4,pass=5,vest=6,aerosol=7,molotov=8}
local W={5,4,2}
local F=5.5
local X=1
local Y={ball={size=3,shade=4},bile={size=4,shade=2}}
local e={height=12,headX=2,headY=2,livesX=12,iconX=22,timeX=40,scoreRight=178,textY=-2,warn=180,warnBlink=8,scoreDigits=6}
local Z="%0"..e.scoreDigits.."d"
local p={y=34,height=52,first=38,second=54,third=70}
local _=15
local aa={"detonator","kick","pass","vest"}

function b:camera()
local d=self.grid
local h=self.survivor
local k=d.columns*a-g.width
local l=d.rows*a-g.height
local q=math.floor(h.x+a/2-g.width/2)
local s=math.floor(h.y+a/2-g.height/2)
return SpiffBoy.clamp(q,0,k),SpiffBoy.clamp(s,0,l)
end

function b:drawArena(h)
local k=self.art.arenas[self.zone.key]
local l=self.grid.rows*a
for q,d in ipairs(M)do
h:sheet(k,self.camX,(d-1)*l+self.camY,g.width,g.height,0,g.top,1,d)
end
end

function b:toScreen(d,h)
return math.floor(d-self.camX),math.floor(h-self.camY)+g.top
end

function b:visibleCells()
local d=self.grid
local h=math.floor(self.camX/a)+1
local k=math.min(d.columns,math.floor((self.camX+g.width-1)/a)+1)
local l=math.floor(self.camY/a)+1
local q=math.min(d.rows,math.floor((self.camY+g.height-1)/a)+1)
return h,k,l,q
end

function b:drawCrateRun(h,t,v,k,w)
local l,q=self:toScreen((t-1)*a,(v-1)*a)
local s=self.zone.key
for x,d in ipairs(B)do
if w then
h:sheet(self.art.crateColumns[s],0,(d-1)*N*a,a,k*a,l,q,1,d)
else
h:sheet(self.art.crates[s],0,(d-1)*a,k*a,a,l,q,1,d)
end
end
end

function b:drawCrates(v,w,q,x,s)
local h=self.grid
local l={}
for k=x,s do
local d=w
while d<=q do
if h:kind(d,k)==j.CRATE then
local t=d
while d+1<=q and h:kind(d+1,k)==j.CRATE do
d=d+1
end
if d>t then
self:drawCrateRun(v,t,k,d-t+1,false)
for y=t,d do
l[h:index(y,k)]=true
end
end
end
d=d+1
end
end
for k=w,q do
local d=x
while d<=s do
if h:kind(k,d)==j.CRATE then
local t=d
local y=l[h:index(k,d)]and 0 or 1
while d+1<=s and h:kind(k,d+1)==j.CRATE do
d=d+1
if not l[h:index(k,d)]then
y=y+1
end
end
if y>=2 then
self:drawCrateRun(v,k,t,d-t+1,true)
for G=t,d do
l[h:index(k,G)]=true
end
end
end
d=d+1
end
end
for d=x,s do
for k=w,q do
if h:kind(k,d)==j.CRATE and not l[h:index(k,d)]then
self:drawCrateRun(v,k,d,1,false)
end
end
end
end

function b:drawCell(d,h,k,l,q,s)
local t,v=self:toScreen(l,q)
d:layers(h,k*a,a,a,t,v,s)
end

function b:drawFloorThings(h,s,t,v,w)
local d=self.grid
local x=self.art.tiles[self.zone.key]
for G,k in ipairs(d.breaking)do
local l,q=d:cellOf(k.index)
local y=math.min(2,math.floor((j.BREAK_TICKS-k.timer)*3/j.BREAK_TICKS))
self:drawCell(h,x,R.breaking+y,(l-1)*a,(q-1)*a,B)
end
if d.exitShown then
local l,q=d:cellOf(d.exitIndex)
local k=D.closed
if d.exitOpen then
k=D.open+math.floor(self.clock/U)%2
end
self:drawCell(h,self.art.hatch,k,(l-1)*a,(q-1)*a,n)
end
for k=v,w do
for l=s,t do
local q=d:itemAt(l,k)
if q then
self:drawCell(h,self.art.bonuses,E[q],(l-1)*a,(k-1)*a,n)
end
end
end
end

function b:drawBombs(h)
local k=math.floor(self.clock/T)%2
for l,d in ipairs(self.bombs.list)do
self:drawCell(h,self.art.bombs,S[d.kind]+k,d.x,d.y,n)
end
local l=math.floor(self.clock/V)%2
for v,d in ipairs(self.bombs.fires)do
if d.timer<=z.FIRE_TICKS then
for w,q in ipairs(d.cells)do
local s,t=self.grid:cellOf(q)
self:drawCell(h,self.art.fire,l,(s-1)*a,(t-1)*a,O)
end
end
end
end

function b:drawBlasts(G)
for ae,h in ipairs(self.bombs.blasts)do
local ab=W[z.strength(h)]
local s,t=(h.column-1)*a,(h.row-1)*a
local k=h.arms
local H,ac=s-k.left*a,s+(k.right+1)*a
local I,ad=t-k.up*a,t+(k.down+1)*a
for v=0,3 do
local w=ab+0.5-v
if w>=0.5 then
local l=math.ceil(F-w)
local J=math.floor(F+w)
local q=X+v
local d=r[v+1]
local x,y=self:toScreen(H+q,t+l)
G:rect(x,y,ac-H-q*2,J-l+1,d.r,d.g,d.b,1)
x,y=self:toScreen(s+l,I+q)
G:rect(x,y,J-l+1,ad-I-q*2,d.r,d.g,d.b,1)
end
end
end
end

function b:drawActor(h,k,l,d)
local q,s=self:toScreen(d.x-o.left,d.y-o.up)
h:layers(k,l*o.size,o.size,o.size,q,s,n)
end

function b:drawBoss(k)
local d=self.boss
local h=d.stats.big and C.big or C.normal
local l,q=self:toScreen(d.x+a/2-h/2,d.y+a-h)
k:layers(self.art.bosses[d.kind],L.frame(d,self.clock)*h,h,h,l,q,n)
end

local function v(d)
return d>0 and math.floor(d/4)%2==1
end

local G={}
local w=nil

local function H(d,h)
if d.y~=h.y then
return d.y<h.y
end
return d==w
end

function b:drawActors(q)
local l=self.survivor
local d=G
local I=#d
d[1]=l
local h=1
for s,k in ipairs(self.zombies)do
h=h+1
d[h]=k
end
if self.boss then
h=h+1
d[h]=self.boss
end
for k=h+1,I do
d[k]=nil
end
w=l
table.sort(d,H)
for s,k in ipairs(d)do
if k==l then
if not v(l.safe)then
self:drawActor(q,self.art.survivor,A.survivorFrame(l),l)
end
elseif k==self.boss then
self:drawBoss(q)
elseif not(k.state~="dying"and v(k.flash))then
self:drawActor(q,self.art.zombies[k.kind],A.zombieFrame(k),k)
end
end
for J,s in ipairs(self.shots)do
local k=Y[s.kind]
local x,y=self:toScreen(s.x-k.size/2,s.y-k.size/2)
q:rect(x-1,y-1,k.size+2,k.size+2,i.r,i.g,i.b,1)
local t=r[k.shade]
q:rect(x,y,k.size,k.size,t.r,t.g,t.b,1)
end
end

function b:shownPower()
local h,d=nil,nil
for q,l in ipairs(aa)do
local k=self.timed[l]
if k>0 and(not d or k<d)then
h,d=l,k
end
end
if h then
return h,d
end
if self.special then
return self.special.kind,nil
end
return nil,nil
end

function b:clockText()
local d=math.ceil(self.timeLeft/SpiffBoy.TICK_RATE)
return string.format("%d:%02d",math.floor(d/60),d%60)
end

function b:drawHud(d)
d:rect(0,0,u,e.height,i.r,i.g,i.b,1)
d:layers(self.art.hud,0,8,8,e.headX,e.headY,P)
d:text(tostring(self.lives),e.livesX,e.textY,c.r,c.g,c.b,1)
local k,h=self:shownPower()
if k and not(h and h<e.warn and math.floor(h/e.warnBlink)%2==1)then
d:layers(self.art.bonuses,E[k]*a,a,a,e.iconX,0,Q)
end
local l=f("Time").." "..self:clockText()
d:text(l,e.timeX,e.textY,c.r,c.g,c.b,1)
d:textRight(string.format(Z,self.score),e.scoreRight,e.textY,c.r,c.g,c.b,1)
end

local function h(k,l,q,s)
k:rect(0,p.y,u,p.height,i.r,i.g,i.b,1)
local t=u/2
local x={{l,p.first},{q,p.second},{s,p.third}}
for y,d in ipairs(x)do
if d[1]then
k:textCentre(d[1],t,d[2],c.r,c.g,c.b,1)
end
end
end

function b:drawIntro(d)
local k=f(self.zone.name)
if self.level==1 then
local l=nil
if self.zone.password then
l=f("Password").." "..self.zone.password
end
h(d,f("Zone",self.zoneIndex),k,l)
elseif self.bossLevel then
h(d,f("Boss"),k,nil)
else
h(d,f("Level",self.zoneIndex,self.level),k,nil)
end
end

function b:drawRun(d)
d:clear(c.r,c.g,c.b)
self.camX,self.camY=self:camera()
local l,q,s,t=self:visibleCells()
self:drawArena(d)
self:drawCrates(d,l,q,s,t)
self:drawFloorThings(d,l,q,s,t)
self:drawBombs(d)
self:drawBlasts(d)
self:drawActors(d)
self:drawHud(d)
local k=self.phase
if k==b.PHASE_INTRO then
self:drawIntro(d)
elseif self.paused then
h(d,nil,getText("UI_SpiffBoy_Paused"),nil)
elseif k==b.PHASE_CLEAR then
h(d,nil,f("LevelClear"),nil)
elseif k==b.PHASE_OVER then
h(d,nil,f("GameOver"),nil)
elseif k==b.PHASE_ENDING then
h(d,f("Ending"),nil,f("Score").." "..tostring(self.score))
elseif self.bannerTimer>0 and math.floor((b.BANNER_TICKS-self.bannerTimer)/_)%2==0 then
h(d,nil,f("Horde"),nil)
end
end

function b:draw(d)
if self.mode==b.MODE_RUN then
self:drawRun(d)
else
self:drawMenu(d)
end
end
