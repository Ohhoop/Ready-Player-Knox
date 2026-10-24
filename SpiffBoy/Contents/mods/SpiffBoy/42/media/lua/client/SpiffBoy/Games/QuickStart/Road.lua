require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Art"

local i=SpiffBoy.QuickStart
local k=i.Fixed
local Q=i.Tracks

local c={}
i.Road=c

c.HORIZON=36
c.FOCAL=100
c.HEIGHT=20
c.BEHIND=28
c.FAR=420
c.FLOOR_FAR=340
c.FLOOR_BUDGET=160
c.STEP=2
c.MERGE_DEPTH=140
c.SKY_WIDTH=768
c.STEP_SCALES={3.57,2.52,1.76,1.18,0.76}
c.DECOR_LIMIT=0.5
c.DECOR_MARGIN=64

local j=c.HORIZON
local o=c.FOCAL
local H=c.HEIGHT
local R=c.FAR
local S=c.FLOOR_FAR
local l=c.STEP
local T=c.MERGE_DEPTH
local I=c.SKY_WIDTH
local U=c.STEP_SCALES
local g=i.WIDTH
local u=i.HEIGHT
local V=i.TILE
local J=1/V
local W=i.SHADES
local K=k.ONE
local C=k.TURN
local X=Q.CHECKER
local f=math.floor
local Y=math.log

local L={i.INK,i.PAPER}
local M=8
local Z=2

local _={{8,1},{8,2},{8,3},{6,4},{2,6}}
local p={}
do
local a=0
for h,d in ipairs(_)do
for m=1,d[1]do
local b=d[2]
local e=a+b/2
p[#p+1]={top=j+a,height=b,z=H*o/e}
a=a+b
end
end
if j+a~=u then
error("QuickStart: the floor bands cover "..a.." rows instead of "..(u-j))
end
end

local function m(screen,shadeIndex,x,y,w,h)
local a=W[shadeIndex]
screen:rect(x,y,w,h,a.r,a.g,a.b,1)
end
c.fill=m

local function aa(mark,wx,wy)
if mark==X then
return L[(f(wx/M)+f(wy/M))%2+1]
end
return L[f((wx+wy)/Z)%2+1]
end

local N,D,E

local function q(angle)
if angle~=N then
N=angle
D,E=k.cos(angle)/K,k.sin(angle)/K
end
return D,E,-E,D
end
c.axes=q

function c.cameraBehind(x,y,angle)
local a,b=q(angle)
return{x=x-a*c.BEHIND,y=y-b*c.BEHIND,angle=angle}
end

function c.project(camera,wx,wy)
local h,n,r,s=q(camera.angle)
local d,e=wx-camera.x,wy-camera.y
local a=d*h+e*n
if a<=4 or a>R then
return nil
end
local b=o/a
return g/2+(d*r+e*s)*b,j+H*b,b,a
end

local e,d={},{}

local function ab(count,allowed)
while count>math.max(1,allowed)do
local b,h=1,nil
for a=1,count do
local n=d[a+1]-d[a]
if not h or n<h then
b,h=a,n
end
end
if b==1 then
e[1]=e[2]
end
for a=math.max(2,b),count do
e[a]=e[a+1]
d[a]=d[a+1]
end
count=count-1
d[count+1]=g
local a=1
for n=2,count do
if e[n]~=e[a]then
a=a+1
e[a],d[a]=e[n],d[n]
end
end
count=a
d[count+1]=g
end
return count
end

local function ac(screen,track,clear,camera,band,fx,fy,rx,ry,allowed)
local h=band.z
if h>S then
return
end
local v=h/o
local B=g/2
local n=camera.x+fx*h+rx*(l/2-B)*v
local r=camera.y+fy*h+ry*(l/2-B)*v
local F,G=rx*l*v,ry*l*v
local O,y=track.shadeGrid,track.size
local a=0
for w=0,g-l,l do
local b=clear
if n>=0 and r>=0 then
local s=n*J
s=s-s%1
local t=r*J
t=t-t%1
if s<y and t<y then
b=O[t*y+s+1]
if b<0 then
b=aa(b,n,r)
end
end
end
if a==0 or b~=e[a]then
a=a+1
e[a],d[a]=b,w
end
n,r=n+F,r+G
end
d[a+1]=g
if h>T then
local b=1
for s=2,a do
local t=d[s+1]-d[s]>l
if t and e[s]~=e[b]then
b=b+1
e[b],d[b]=e[s],d[s]
end
end
a=b
d[a+1]=g
end
a=ab(a,allowed)
local b,t=nil,nil
for s=1,a do
if e[s]~=clear then
b=b or s
t=s
end
end
if not b then
return
end
local w,x=clear,0
for s=1,a do
if e[s]~=clear then
x=x+1
end
end
for z=1,4 do
if z~=clear then
local s=1
for A=b,t do
if e[A]~=z then
s=s+1
end
end
if s<x then
w,x=z,s
end
end
end
local z,A=band.top,band.height
if w~=clear then
m(screen,w,d[b],z,d[t+1]-d[b],A)
for s=b,t do
if e[s]~=w then
m(screen,e[s],d[s],z,d[s+1]-d[s],A)
end
end
return
end
for s=1,a do
if e[s]~=clear then
m(screen,e[s],d[s],z,d[s+1]-d[s],A)
end
end
end

local function ad(screen,track,camera,art,atlas)
m(screen,i.PAPER,0,0,g,j)
local a=atlas[track.style.sky]
local h=art(track.style.sky)
local n=f(k.wrap(camera.angle)*I/C)
local b=I-n
if b>=g then
screen:layers(h,n,g,a.h,0,j-a.h,a.shades)
return
end
screen:layers(h,n,b,a.h,0,j-a.h,a.shades)
screen:layers(h,0,g-b,a.h,b,j-a.h,a.shades)
end

function c.draw(screen,track,camera,art,atlas)
local a=track.style
local b=a.shades[a.clear]
m(screen,b,0,j,g,u-j)
ad(screen,track,camera,art,atlas)
local n,r,s,t=q(camera.angle)
local v=screen.calls
for h=1,#p do
local w=c.FLOOR_BUDGET-(screen.calls-v)
ac(screen,track,b,camera,p[h],n,r,s,t,f(w/(#p-h+1))+1)
end
end

function c.stepOf(scale,scales)
scales=scales or U
local b,a=1,nil
for h=1,#scales do
local n=math.abs(Y(scale/scales[h]))
if not a or n<a then
b,a=h,n
end
end
return b
end

function c.frameOf(camera,x,y,angle)
local a=k.atan2(f(y-camera.y),f(x-camera.x))/k.FINE
local b=k.wrap(f(angle-a+C/16))
return f(b*8/C)+1
end

local F,O,h={},{},{}
local r=0

function c.newScene()
for a=#F,1,-1 do
F[a]=nil
end
r=0
return F
end

local function ae()
r=r+1
local a=O[r]
if not a then
a={}
O[r]=a
end
return a
end

local function af(a,b)
if a.priority~=b.priority then
return a.priority>b.priority
end
return a.z<b.z
end

local function ag(a,b)
return a.z>b.z
end

function c.addEntry(scene,camera,name,entry,x,y,lift,frame,priority)
local v,w,b,z=c.project(camera,x,y)
if not v then
return
end
if priority==0 and b<c.DECOR_LIMIT then
return
end
local n=entry.steps[c.stepOf(b,entry.scales)]
local s=f(v-n.ax)
local t=f(w-lift*b-entry.h)
if s+n.w<=0 or s>=g or t+entry.h<=0 or t>=u then
return
end
local a=ae()
a.z,a.name,a.entry,a.step,a.frame,a.priority,a.x,a.y=z,name,entry,n,frame or 1,priority,s,t
scene[#scene+1]=a
end

function c.add(scene,camera,name,x,y,lift,frame,priority)
c.addEntry(scene,camera,name,i.Atlas[name],x,y,lift,frame,priority)
end

function c.addDecor(scene,camera,track)
local t,v,w,x=q(camera.angle)
local s=o/c.DECOR_LIMIT
local n=c.DECOR_MARGIN
local y=n
local z=s*(g/2)/o+n
local a={
camera.x-t*n+w*y,camera.x-t*n-w*y,
camera.x+t*s+w*z,camera.x+t*s-w*z,
}
local b={
camera.y-v*n+x*y,camera.y-v*n-x*y,
camera.y+v*s+x*z,camera.y+v*s-x*z,
}
local A=i.Tracks.DECOR_CELL
local G=track.decorCount
local ah,ai=math.min(a[1],a[2],a[3],a[4]),math.max(a[1],a[2],a[3],a[4])
local aj,ak=math.min(b[1],b[2],b[3],b[4]),math.max(b[1],b[2],b[3],b[4])
local al,am=math.max(0,f(ah/A)),math.min(G-1,f(ai/A))
local an,ao=math.max(0,f(aj/A)),math.min(G-1,f(ak/A))
local ap=track.decorCells
for aq=an,ao do
for ar=al,am do
local P=ap[aq*G+ar+1]
for as=1,#P do
local B=P[as]
c.addEntry(scene,camera,B.art,B.entry,B.x,B.y,0,1,0)
end
end
end
end

function c.drawScene(screen,scene,art,budget)
table.sort(scene,af)
for a=#h,1,-1 do
h[a]=nil
end
local b=0
for s=1,#scene do
local a=scene[s]
local n=#a.entry.shades
if b+n<=budget then
h[#h+1]=a
b=b+n
end
end
table.sort(h,ag)
for t=1,#h do
local a=h[t]
local n,s=a.step,a.entry
screen:layers(art(a.name),n.x+(a.frame-1)*n.w,n.w,s.h,a.x,a.y,s.shades)
end
return b
end
