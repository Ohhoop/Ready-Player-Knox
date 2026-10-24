require"SpiffBoy/Core/Core"
require"SpiffBoy/Games/BrickDrop/Music"

SpiffBoy.BrickDrop=SpiffBoy.BrickDrop or{}

local c=SpiffBoy.BrickDrop.Music

local a={}
a.__index=a
SpiffBoy.BrickDrop.Camp=a

a.PROJECTS={
{art="barricade",width=14,height=22,station=0,x=10,share=0.15,worker=128,face=1,stop=164},
{art="truck",width=36,height=24,station=1,x=182,share=0.35,worker=214,face=-1,stop=340},
{art="generator",width=22,height=18,station=2,x=364,share=0.2,worker=386,face=-1,stop=520},
{art="radio",width=26,height=22,station=2,x=488,share=0.3,worker=512,face=-1,stop=532},
}

local g=180
local d={1,2,3,4}
local F={2}
local G=0
local H=1
local h=2
local l=24
local m=22
local I=0
local ar=1
local J=2
local K=3
local n=4
local L=5
local M=6
local N=0
local O=1
local P=2
local f=24
local o=16
local Q=22
local R=0
local p=2
local S=4
local T=5
local i=18
local q=22
local U=2
local V=4
local r=150
local s=18
local W=22
local X=1.5
local Y=3
local t=0.8
local j=8
local u=0.5
local Z=1.2
local _=24
local aa=12
local ab=4
local ac=60
local ad=72
local ae=8
local af=20
local ag=30
local v=0.5
local ah=12
local ai=14
local aj=56
local w=700
local y=1300
local ak=16
local z=14
local A=12
local al=90
local am=120
local an=20
local B={-20,-44,-68}
local ao=96
local C=2
local D=12
local E=36
local ap=90

function a.new(sequencer,random,art,layout)
local b=setmetatable({},a)
b.sequencer=sequencer
b.random=random
b.layout=layout
b.mechanic=art("mechanic")
b.spear=art("spear")
b.courier=art("courier")
b.zombie=art("zombie")
b.bench=art("bench")
b.projectArt={}
for e=1,#a.PROJECTS do
b.projectArt[e]=art(a.PROJECTS[e].art)
end
b:reset(1)
return b
end

function a:reset(totalParts)
self.needs={}
for b=1,#a.PROJECTS do
self.needs[b]=math.max(1,math.floor(totalParts*a.PROJECTS[b].share+0.5))
end
self.built=0
self.parts=0
self.pending=0
self.courierState=nil
self.cheer=0
self.doneBlink=0
self.camera=0
self.cameraTarget=0
self.cameraSpeed=X
self.worker={x=a.PROJECTS[1].worker,target=a.PROJECTS[1].worker,face=a.PROJECTS[1].face,timer=0,state="work"}
self.fighter={state="guard",timer=0}
self.stray=nil
self.strayTimer=self.random:int(w,y)
self.horde=nil
self.barricadeBroken=false
end

function a:stage()
return self.built
end

function a:current()
return a.PROJECTS[self.built+1]
end

function a:deliver(parts)
if self.built>=#a.PROJECTS or self.horde then
return
end
self.pending=self.pending+parts
end

function a:layParts(load)
local e=false
self.parts=self.parts+load
while self.built<#a.PROJECTS and self.parts>=self.needs[self.built+1]do
self.parts=self.parts-self.needs[self.built+1]
self.built=self.built+1
e=true
end
self.cheer=ac
if not e then
self.sequencer:effect(c.BUILD)
return
end
self.doneBlink=ad
self.sequencer:effect(c.BUILT)
local b=self:current()
if b then
self.worker.target=b.worker
self.worker.face=b.face
self.cameraTarget=b.station*g
else
self.parts=0
end
end

function a:tickCamera()
local b=self.cameraTarget-self.camera
if math.abs(b)<=self.cameraSpeed then
self.camera=self.cameraTarget
else
self.camera=self.camera+self.cameraSpeed*(b>0 and 1 or-1)
end
end

function a:tickWorker()
local b=self.worker
b.timer=b.timer+1
if b.state~="work"and b.state~="walk"then
return
end
local e=b.target-b.x
if math.abs(e)<=t then
b.x=b.target
b.state="work"
else
b.x=b.x+t*(e>0 and 1 or-1)
b.state="walk"
end
end

function a:dropPlace()
local b=self:current()or a.PROJECTS[#a.PROJECTS]
return b.stop
end

function a:tickCourier()
local b=self.courierState
local e=self.camera+g
if not b then
if self.pending>0 then
self.courierState={phase="in",x=e,timer=0,load=self.pending}
self.pending=0
end
return
end
b.timer=b.timer+1
if b.phase=="in"then
b.x=b.x-u
if b.x<=self:dropPlace()then
b.x=self:dropPlace()
b.phase="drop"
b.timer=0
end
elseif b.phase=="drop"then
if b.timer>=_ then
self:layParts(b.load)
b.phase="out"
end
else
b.x=b.x+u
if b.x>=e then
self.courierState=nil
end
end
end

function a:strayStop()
if self.built>=1 and not self.barricadeBroken then
return a.PROJECTS[1].x-z
end
return f-ak
end

function a:tickStray()
local b=self.stray
if not b then
self.strayTimer=self.strayTimer-1
if self.strayTimer<=0 then
self.stray={x=-i,timer=0,state="walk"}
end
return
end
b.timer=b.timer+1
if b.state=="walk"then
b.x=b.x+v
if b.x>=self:strayStop()then
b.x=self:strayStop()
b.state="fallen"
b.timer=0
self.fighter.state="thrust"
self.fighter.timer=0
self.sequencer:effect(c.STAB)
end
elseif b.timer>=al then
self.stray=nil
self.strayTimer=self.random:int(w,y)
end
end

function a:tickFighter()
local b=self.fighter
b.timer=b.timer+1
if b.state=="thrust"and b.timer>=A then
b.state="guard"
end
end

function a:startOverrun()
self.stray=nil
self.courierState=nil
self.pending=0
self.cameraTarget=0
self.cameraSpeed=Y
self.worker={x=a.PROJECTS[1].worker,target=a.PROJECTS[1].worker,face=-1,timer=0,state="watch"}
self.fleeing={x=r+s-o+8,timer=0,state="idle"}
self.fighter={state="guard",timer=0}
self.horde={zombies={},timer=0,bangs=0,holding=false,rest=0}
for b=1,#B do
self.horde.zombies[b]={x=B[b],timer=0,state="walk",prey=nil}
end
self.horde.zombies[1].prey="fighter"
self.horde.zombies[2].prey="worker"
self.sequencer:effect(c.GROWL)
end

function a:hordeStop(zombie)
if self.built>=1 and not self.barricadeBroken then
return a.PROJECTS[1].x-z
end
if zombie.prey=="fighter"then
return f-D
end
if zombie.prey=="worker"then
return self.worker.x-D
end
return ao
end

function a:tickHordeZombie(zombie,index)
zombie.timer=zombie.timer+1
if zombie.state=="eat"then
if zombie.timer%aj==0 then
self.sequencer:effect(c.CHOMP)
end
return
end
local b=self:hordeStop(zombie)-(index-1)*2
if zombie.x<b then
zombie.x=math.min(b,zombie.x+v)
return
end
if self.built>=1 and not self.barricadeBroken then
self.horde.holding=true
return
end
if zombie.prey=="fighter"and self.fighter.state~="dead"then
self.fighter.state="dead"
zombie.state="eat"
zombie.timer=0
zombie.x=f+C
self.sequencer:effect(c.CHOMP)
elseif zombie.prey=="worker"then
self:catchWorker(zombie)
end
end

function a:catchWorker(zombie)
local b=self.worker
if b.state=="watch"then
b.state="fright"
b.timer=0
self.fleeing.state="fright"
self.fleeing.timer=0
return
end
if b.state=="fright"and b.timer>=E then
b.state="dead"
zombie.state="eat"
zombie.timer=0
zombie.x=b.x+C
self.sequencer:effect(c.CHOMP)
end
end

function a:tickOverrun()
local b=self.horde
b.timer=b.timer+1
for e=1,#b.zombies do
self:tickHordeZombie(b.zombies[e],e)
end
if b.holding and not self.barricadeBroken then
b.bangs=b.bangs+1
if b.bangs%an==0 then
self.sequencer:effect(c.BANG)
end
if b.bangs>=am then
self.barricadeBroken=true
b.holding=false
end
end
local k=self.fighter
if k.state~="dead"then
local e=b.zombies[1].x>=self:strayStop()-1
k.state=(e and math.floor(b.timer/A)%2==0)and"thrust"or"guard"
end
local e=self.fleeing
e.timer=e.timer+1
if e.state=="fright"and e.timer>=E/2 then
e.state="run"
elseif e.state=="run"then
e.x=e.x+Z
end
if self.worker.state=="dead"then
b.rest=b.rest+1
end
end

function a:overrunDone()
return self.horde~=nil and self.horde.rest>=ap and self.fleeing.x>=self.camera+g
end

function a:tick()
self:tickCamera()
if self.cheer>0 then
self.cheer=self.cheer-1
end
if self.doneBlink>0 then
self.doneBlink=self.doneBlink-1
end
self:tickWorker()
if self.horde then
self:tickOverrun()
return
end
self:tickFighter()
self:tickCourier()
self:tickStray()
end

function a:shows(screen,x,width)
local b=self.layout.cover
if x+width<=0 or x>=screen.width then
return false
end
return x<b.x or x+width>b.x+b.width
end

function a:drawFigure(screen,texture,frame,width,height,worldX,shades)
local b=math.floor(worldX-self.camera)
if self:shows(screen,b,width)then
screen:layers(texture,frame*width,width,height,b,self.layout.ground-height,shades)
end
end

function a:drawRisen(screen,index,rows)
if rows<=0 then
return
end
local b=a.PROJECTS[index]
local x=self.projectArt[index]
local e=math.floor(b.x-self.camera)
if not self:shows(screen,e,b.width)then
return
end
local aq=self.layout.ground-b.height
for k=1,#d do
screen:sheet(x,0,(k-1)*b.height+b.height-rows,b.width,rows,e,aq+b.height-rows,1,k)
end
end

function a:builtFrame(index,clock)
if index==1 and self.barricadeBroken then
return h
end
if index==3 and math.floor(clock/af)%2==0 then
return h
end
if index==4 and math.floor(clock/ag)%2==0 then
return h
end
return G
end

function a:drawProjects(screen,clock)
for b=1,#a.PROJECTS do
local e=a.PROJECTS[b]
if b<=self.built then
local k=b==self.built and self.doneBlink>0
if not k or math.floor(clock/ae)%2==0 then
self:drawFigure(screen,self.projectArt[b],self:builtFrame(b,clock),e.width,e.height,e.x,d)
end
elseif b==self.built+1 and not self.horde then
self:drawFigure(screen,self.projectArt[b],H,e.width,e.height,e.x,F)
self:drawRisen(screen,b,math.floor(e.height*self.parts/self.needs[b]))
end
end
end

function a:workerFrame(clock)
local e=self.worker
if e.state=="dead"then
return L
end
local b
if e.state=="fright"then
b=J
elseif e.state=="watch"then
b=n
elseif e.state=="walk"then
b=K+math.floor(e.timer/j)%2
elseif self.built>=#a.PROJECTS then
b=n
else
local k=self.cheer>0 and ab or aa
b=I+math.floor(clock/k)%2
end
if e.face<0 then
b=b+M
end
return b
end

function a:fighterFrame()
local b=self.fighter.state
if b=="dead"then
return P
end
if b=="thrust"then
return O
end
return N
end

local function x(zombie)
if zombie.state=="eat"then
return U+math.floor(zombie.timer/ai)%2
end
if zombie.state=="fallen"then
return V
end
return math.floor(zombie.timer/ah)%2
end

function a:drawHorde(screen,feeding)
if not self.horde then
return
end
local b=self.horde.zombies
for e=1,#b do
if(b[e].state=="eat")==feeding then
self:drawFigure(screen,self.zombie,x(b[e]),i,q,b[e].x,d)
end
end
end

function a:drawCourier(screen)
local b,k
if self.horde then
local e=self.fleeing
k=e.x
if e.state=="idle"then
b=S
elseif e.state=="fright"then
b=T
else
b=p+math.floor(e.timer/j)%2
end
else
local e=self.courierState
if not e then
return
end
k=e.x
b=math.floor(e.timer/j)%2
if e.phase=="drop"then
b=R
elseif e.phase=="out"then
b=p+b
end
end
self:drawFigure(screen,self.courier,b,o,Q,k,d)
end

function a:draw(screen,clock)
local b=self.layout
for k=1,#b.windows do
local e=b.windows[k]
screen:rect(e.x,b.ground,e.width,1,b.groundColour.r,b.groundColour.g,b.groundColour.b,1)
end
self:drawFigure(screen,self.bench,0,s,W,r,d)
self:drawProjects(screen,clock)
self:drawHorde(screen,true)
self:drawFigure(screen,self.spear,self:fighterFrame(),l,m,f,d)
self:drawFigure(screen,self.mechanic,self:workerFrame(clock),l,m,self.worker.x,d)
if self.stray then
self:drawFigure(screen,self.zombie,x(self.stray),i,q,self.stray.x,d)
end
self:drawHorde(screen,false)
self:drawCourier(screen)
end
