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
local H={2}
local I=0
local J=1
local h=2
local l=24
local m=22
local K=0
local au=1
local L=2
local M=3
local n=4
local N=5
local O=6
local P=0
local Q=1
local R=2
local f=24
local o=16
local S=22
local T=0
local p=2
local U=4
local V=5
local i=18
local q=22
local W=2
local X=4
local r=150
local s=18
local Y=22
local Z=1.5
local _=3
local t=0.8
local j=8
local u=0.5
local aa=1.2
local ab=24
local ac=12
local ad=4
local ae=60
local af=72
local ag=8
local ah=20
local ai=30
local v=0.5
local aj=12
local ak=14
local al=56
local w=700
local x=1300
local am=16
local y=14
local z=12
local an=90
local ao=120
local ap=20
local A={-20,-44,-68}
local aq=96
local B=2
local C=12
local D=36
local ar=90

function a.new(E,F,e,G)
local b=setmetatable({},a)
b.sequencer=E
b.random=F
b.layout=G
b.mechanic=e("mechanic")
b.spear=e("spear")
b.courier=e("courier")
b.zombie=e("zombie")
b.bench=e("bench")
b.projectArt={}
for k=1,#a.PROJECTS do
b.projectArt[k]=e(a.PROJECTS[k].art)
end
b:reset(1)
return b
end

function a:reset(e)
self.needs={}
for b=1,#a.PROJECTS do
self.needs[b]=math.max(1,math.floor(e*a.PROJECTS[b].share+0.5))
end
self.built=0
self.parts=0
self.pending=0
self.courierState=nil
self.cheer=0
self.doneBlink=0
self.camera=0
self.cameraTarget=0
self.cameraSpeed=Z
self.worker={x=a.PROJECTS[1].worker,target=a.PROJECTS[1].worker,face=a.PROJECTS[1].face,timer=0,state="work"}
self.fighter={state="guard",timer=0}
self.stray=nil
self.strayTimer=self.random:int(w,x)
self.horde=nil
self.barricadeBroken=false
end

function a:stage()
return self.built
end

function a:current()
return a.PROJECTS[self.built+1]
end

function a:deliver(b)
if self.built>=#a.PROJECTS or self.horde then
return
end
self.pending=self.pending+b
end

function a:layParts(k)
local e=false
self.parts=self.parts+k
while self.built<#a.PROJECTS and self.parts>=self.needs[self.built+1]do
self.parts=self.parts-self.needs[self.built+1]
self.built=self.built+1
e=true
end
self.cheer=ae
if not e then
self.sequencer:effect(c.BUILD)
return
end
self.doneBlink=af
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
if b.timer>=ab then
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
return a.PROJECTS[1].x-y
end
return f-am
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
elseif b.timer>=an then
self.stray=nil
self.strayTimer=self.random:int(w,x)
end
end

function a:tickFighter()
local b=self.fighter
b.timer=b.timer+1
if b.state=="thrust"and b.timer>=z then
b.state="guard"
end
end

function a:startOverrun()
self.stray=nil
self.courierState=nil
self.pending=0
self.cameraTarget=0
self.cameraSpeed=_
self.worker={x=a.PROJECTS[1].worker,target=a.PROJECTS[1].worker,face=-1,timer=0,state="watch"}
self.fleeing={x=r+s-o+8,timer=0,state="idle"}
self.fighter={state="guard",timer=0}
self.horde={zombies={},timer=0,bangs=0,holding=false,rest=0}
for b=1,#A do
self.horde.zombies[b]={x=A[b],timer=0,state="walk",prey=nil}
end
self.horde.zombies[1].prey="fighter"
self.horde.zombies[2].prey="worker"
self.sequencer:effect(c.GROWL)
end

function a:hordeStop(b)
if self.built>=1 and not self.barricadeBroken then
return a.PROJECTS[1].x-y
end
if b.prey=="fighter"then
return f-C
end
if b.prey=="worker"then
return self.worker.x-C
end
return aq
end

function a:tickHordeZombie(b,k)
b.timer=b.timer+1
if b.state=="eat"then
if b.timer%al==0 then
self.sequencer:effect(c.CHOMP)
end
return
end
local e=self:hordeStop(b)-(k-1)*2
if b.x<e then
b.x=math.min(e,b.x+v)
return
end
if self.built>=1 and not self.barricadeBroken then
self.horde.holding=true
return
end
if b.prey=="fighter"and self.fighter.state~="dead"then
self.fighter.state="dead"
b.state="eat"
b.timer=0
b.x=f+B
self.sequencer:effect(c.CHOMP)
elseif b.prey=="worker"then
self:catchWorker(b)
end
end

function a:catchWorker(e)
local b=self.worker
if b.state=="watch"then
b.state="fright"
b.timer=0
self.fleeing.state="fright"
self.fleeing.timer=0
return
end
if b.state=="fright"and b.timer>=D then
b.state="dead"
e.state="eat"
e.timer=0
e.x=b.x+B
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
if b.bangs%ap==0 then
self.sequencer:effect(c.BANG)
end
if b.bangs>=ao then
self.barricadeBroken=true
b.holding=false
end
end
local k=self.fighter
if k.state~="dead"then
local e=b.zombies[1].x>=self:strayStop()-1
k.state=(e and math.floor(b.timer/z)%2==0)and"thrust"or"guard"
end
local e=self.fleeing
e.timer=e.timer+1
if e.state=="fright"and e.timer>=D/2 then
e.state="run"
elseif e.state=="run"then
e.x=e.x+aa
end
if self.worker.state=="dead"then
b.rest=b.rest+1
end
end

function a:overrunDone()
return self.horde~=nil and self.horde.rest>=ar and self.fleeing.x>=self.camera+g
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

function a:shows(E,b,k)
local e=self.layout.cover
if b+k<=0 or b>=E.width then
return false
end
return b<e.x or b+k>e.x+e.width
end

function a:drawFigure(e,F,G,b,k,as,at)
local E=math.floor(as-self.camera)
if self:shows(e,E,b)then
e:layers(F,G*b,b,k,E,self.layout.ground-k,at)
end
end

function a:drawRisen(k,E,e)
if e<=0 then
return
end
local b=a.PROJECTS[E]
local as=self.projectArt[E]
local F=math.floor(b.x-self.camera)
if not self:shows(k,F,b.width)then
return
end
local at=self.layout.ground-b.height
for G=1,#d do
k:sheet(as,0,(G-1)*b.height+b.height-e,b.width,e,F,at+b.height-e,1,G)
end
end

function a:builtFrame(b,e)
if b==1 and self.barricadeBroken then
return h
end
if b==3 and math.floor(e/ah)%2==0 then
return h
end
if b==4 and math.floor(e/ai)%2==0 then
return h
end
return I
end

function a:drawProjects(k,E)
for b=1,#a.PROJECTS do
local e=a.PROJECTS[b]
if b<=self.built then
local F=b==self.built and self.doneBlink>0
if not F or math.floor(E/ag)%2==0 then
self:drawFigure(k,self.projectArt[b],self:builtFrame(b,E),e.width,e.height,e.x,d)
end
elseif b==self.built+1 and not self.horde then
self:drawFigure(k,self.projectArt[b],J,e.width,e.height,e.x,H)
self:drawRisen(k,b,math.floor(e.height*self.parts/self.needs[b]))
end
end
end

function a:workerFrame(k)
local e=self.worker
if e.state=="dead"then
return N
end
local b
if e.state=="fright"then
b=L
elseif e.state=="watch"then
b=n
elseif e.state=="walk"then
b=M+math.floor(e.timer/j)%2
elseif self.built>=#a.PROJECTS then
b=n
else
local E=self.cheer>0 and ad or ac
b=K+math.floor(k/E)%2
end
if e.face<0 then
b=b+O
end
return b
end

function a:fighterFrame()
local b=self.fighter.state
if b=="dead"then
return R
end
if b=="thrust"then
return Q
end
return P
end

local function E(b)
if b.state=="eat"then
return W+math.floor(b.timer/ak)%2
end
if b.state=="fallen"then
return X
end
return math.floor(b.timer/aj)%2
end

function a:drawHorde(k,F)
if not self.horde then
return
end
local b=self.horde.zombies
for e=1,#b do
if(b[e].state=="eat")==F then
self:drawFigure(k,self.zombie,E(b[e]),i,q,b[e].x,d)
end
end
end

function a:drawCourier(F)
local b,k
if self.horde then
local e=self.fleeing
k=e.x
if e.state=="idle"then
b=U
elseif e.state=="fright"then
b=V
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
b=T
elseif e.phase=="out"then
b=p+b
end
end
self:drawFigure(F,self.courier,b,o,S,k,d)
end

function a:draw(b,k)
local e=self.layout
for G=1,#e.windows do
local F=e.windows[G]
b:rect(F.x,e.ground,F.width,1,e.groundColour.r,e.groundColour.g,e.groundColour.b,1)
end
self:drawFigure(b,self.bench,0,s,Y,r,d)
self:drawProjects(b,k)
self:drawHorde(b,true)
self:drawFigure(b,self.spear,self:fighterFrame(),l,m,f,d)
self:drawFigure(b,self.mechanic,self:workerFrame(k),l,m,self.worker.x,d)
if self.stray then
self:drawFigure(b,self.zombie,E(self.stray),i,q,self.stray.x,d)
end
self:drawHorde(b,false)
self:drawCourier(b)
end
