require"SpiffBoy/Games/QuickStart/Base"
require"SpiffBoy/Games/QuickStart/Fixed"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Art"

local g=SpiffBoy.QuickStart
local i=g.Fixed
local T=g.Tracks

local a={}
g.Road=a

a.HORIZON=36
a.FOCAL=100
a.HEIGHT=20
a.BEHIND=28
a.FAR=420
a.FLOOR_FAR=340
a.FLOOR_BUDGET=160
a.STEP=2
a.MERGE_DEPTH=140
a.SKY_WIDTH=768
a.STEP_SCALES={3.57,2.52,1.76,1.18,0.76}
a.DECOR_LIMIT=0.5
a.DECOR_MARGIN=64

local h=a.HORIZON
local p=a.FOCAL
local I=a.HEIGHT
local U=a.FAR
local V=a.FLOOR_FAR
local l=a.STEP
local W=a.MERGE_DEPTH
local J=a.SKY_WIDTH
local X=a.STEP_SCALES
local f=g.WIDTH
local v=g.HEIGHT
local Y=g.TILE
local K=1/Y
local Z=g.SHADES
local L=i.ONE
local D=i.TURN
local _=T.CHECKER
local d=math.floor
local aa=math.log

local M={g.INK,g.PAPER}
local N=8
local ab=2

local ac={{8,1},{8,2},{8,3},{6,4},{2,6}}
local q={}
do
local b=0
for k,e in ipairs(ac)do
for m=1,e[1]do
local c=e[2]
local j=b+c/2
q[#q+1]={top=h+b,height=c,z=I*p/j}
b=b+c
end
end
if h+b~=v then
error("QuickStart: the floor bands cover "..b.." rows instead of "..(v-h))
end
end

local function n(c,e,j,k,m,o)
local b=Z[e]
c:rect(j,k,m,o,b.r,b.g,b.b,1)
end
a.fill=n

local function ad(e,b,c)
if e==_ then
return M[(d(b/N)+d(c/N))%2+1]
end
return M[d((b+c)/ab)%2+1]
end

local O,E,F

local function r(b)
if b~=O then
O=b
E,F=i.cos(b)/L,i.sin(b)/L
end
return E,F,-F,E
end
a.axes=r

function a.cameraBehind(c,e,b)
local j,k=r(b)
return{x=c-j*a.BEHIND,y=e-k*a.BEHIND,angle=b}
end

function a.project(c,m,o)
local s,t,u,w=r(c.angle)
local j,k=m-c.x,o-c.y
local b=j*s+k*t
if b<=4 or b>U then
return nil
end
local e=p/b
return f/2+(j*u+k*w)*e,h+I*e,e,b
end

local c,b={},{}

local function ae(e,s)
while e>math.max(1,s)do
local k,m=1,nil
for j=1,e do
local o=b[j+1]-b[j]
if not m or o<m then
k,m=j,o
end
end
if k==1 then
c[1]=c[2]
end
for j=math.max(2,k),e do
c[j]=c[j+1]
b[j]=b[j+1]
end
e=e-1
b[e+1]=f
local j=1
for o=2,e do
if c[o]~=c[j]then
j=j+1
c[j],b[j]=c[o],b[o]
end
end
e=j
b[e+1]=f
end
return e
end

local function af(z,H,j,P,A,ag,ah,Q,R,ai)
local m=A.z
if m>V then
return
end
local w=m/p
local S=f/2
local o=P.x+ag*m+Q*(l/2-S)*w
local s=P.y+ah*m+R*(l/2-S)*w
local aj,ak=Q*l*w,R*l*w
local al,B=H.shadeGrid,H.size
local e=0
for x=0,f-l,l do
local k=j
if o>=0 and s>=0 then
local t=o*K
t=t-t%1
local u=s*K
u=u-u%1
if t<B and u<B then
k=al[u*B+t+1]
if k<0 then
k=ad(k,o,s)
end
end
end
if e==0 or k~=c[e]then
e=e+1
c[e],b[e]=k,x
end
o,s=o+aj,s+ak
end
b[e+1]=f
if m>W then
local k=1
for t=2,e do
local u=b[t+1]-b[t]>l
if u and c[t]~=c[k]then
k=k+1
c[k],b[k]=c[t],b[t]
end
end
e=k
b[e+1]=f
end
e=ae(e,ai)
local k,u=nil,nil
for t=1,e do
if c[t]~=j then
k=k or t
u=t
end
end
if not k then
return
end
local x,y=j,0
for t=1,e do
if c[t]~=j then
y=y+1
end
end
for C=1,4 do
if C~=j then
local t=1
for G=k,u do
if c[G]~=C then
t=t+1
end
end
if t<y then
x,y=C,t
end
end
end
local C,G=A.top,A.height
if x~=j then
n(z,x,b[k],C,b[u+1]-b[k],G)
for t=k,u do
if c[t]~=x then
n(z,c[t],b[t],C,b[t+1]-b[t],G)
end
end
return
end
for t=1,e do
if c[t]~=j then
n(z,c[t],b[t],C,b[t+1]-b[t],G)
end
end
end

local function S(j,s,t,u,w)
n(j,g.PAPER,0,0,f,h)
local e=w[s.style.sky]
local m=u(s.style.sky)
local o=d(i.wrap(t.angle)*J/D)
local k=J-o
if k>=f then
j:layers(m,o,f,e.h,0,h-e.h,e.shades)
return
end
j:layers(m,o,k,e.h,0,h-e.h,e.shades)
j:layers(m,0,f-k,e.h,k,h-e.h,e.shades)
end

function a.draw(e,j,k,t,u)
local m=j.style
local o=m.shades[m.clear]
n(e,o,0,h,f,v-h)
S(e,j,k,t,u)
local w,x,y,z=r(k.angle)
local A=e.calls
for s=1,#q do
local B=a.FLOOR_BUDGET-(e.calls-A)
af(e,j,o,k,q[s],w,x,y,z,d(B/(#q-s+1))+1)
end
end

function a.stepOf(s,e)
e=e or X
local k,j=1,nil
for m=1,#e do
local o=math.abs(aa(s/e[m]))
if not j or o<j then
k,j=m,o
end
end
return k
end

function a.frameOf(e,j,k,m)
local o=i.atan2(d(k-e.y),d(j-e.x))/i.FINE
local s=i.wrap(d(m-o+D/16))
return d(s*8/D)+1
end

local G,P,m={},{},{}
local s=0

function a.newScene()
for e=#G,1,-1 do
G[e]=nil
end
s=0
return G
end

local function ag()
s=s+1
local e=P[s]
if not e then
e={}
P[s]=e
end
return e
end

local function ah(e,j)
if e.priority~=j.priority then
return e.priority>j.priority
end
return e.z<j.z
end

local function ai(e,j)
return e.z>j.z
end

function a.addEntry(w,z,A,j,B,C,H,Q,x)
local y,R,k,aj=a.project(z,B,C)
if not y then
return
end
if x==0 and k<a.DECOR_LIMIT then
return
end
local o=j.steps[a.stepOf(k,j.scales)]
local t=d(y-o.ax)
local u=d(R-H*k-j.h)
if t+o.w<=0 or t>=f or u+j.h<=0 or u>=v then
return
end
local e=ag()
e.z,e.name,e.entry,e.step,e.frame,e.priority,e.x,e.y=aj,A,j,o,Q or 1,x,t,u
w[#w+1]=e
end

function a.add(j,k,e,o,t,u,w,x)
a.addEntry(j,k,e,g.Atlas[e],o,t,u,w,x)
end

function a.addDecor(aj,e,Q)
local u,w,x,y=r(e.angle)
local t=p/a.DECOR_LIMIT
local o=a.DECOR_MARGIN
local z=o
local A=t*(f/2)/p+o
local j={
e.x-u*o+x*z,e.x-u*o-x*z,
e.x+u*t+x*A,e.x+u*t-x*A,
}
local k={
e.y-w*o+y*z,e.y-w*o-y*z,
e.y+w*t+y*A,e.y+w*t-y*A,
}
local B=g.Tracks.DECOR_CELL
local H=Q.decorCount
local ak,al=math.min(j[1],j[2],j[3],j[4]),math.max(j[1],j[2],j[3],j[4])
local am,an=math.min(k[1],k[2],k[3],k[4]),math.max(k[1],k[2],k[3],k[4])
local ao,ap=math.max(0,d(ak/B)),math.min(H-1,d(al/B))
local aq,ar=math.max(0,d(am/B)),math.min(H-1,d(an/B))
local as=Q.decorCells
for at=aq,ar do
for au=ao,ap do
local R=as[at*H+au+1]
for av=1,#R do
local C=R[av]
a.addEntry(aj,e,C.art,C.entry,C.x,C.y,0,1,0)
end
end
end
end

function a.drawScene(u,k,w,x)
table.sort(k,ah)
for e=#m,1,-1 do
m[e]=nil
end
local j=0
for t=1,#k do
local e=k[t]
local o=#e.entry.shades
if j+o<=x then
m[#m+1]=e
j=j+o
end
end
table.sort(m,ai)
for y=1,#m do
local e=m[y]
local o,t=e.step,e.entry
u:layers(w(e.name),o.x+(e.frame-1)*o.w,o.w,t.h,e.x,e.y,t.shades)
end
return j
end
