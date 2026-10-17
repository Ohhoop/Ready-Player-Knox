require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local b=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local d=a.Window
local o=a.Party

local c=a.TILE
local v,p=12,16
local w,q=12,24
local g={lampDark=0,lampLit=1,chestClosed=3,chestOpen=4,gate=5,bellpost=7,note=8,echo=9,murk=11,brazierDark=13,brazierLit=15}
local h={span=8,grid=16,frames=2,frameTicks=40,shades={3,4}}
local j={w=48,h=24,frames=4,ticks=8,rise=34}
local f={y=66,h=54,textX=7,textY=69,tagX=4,tagY=51,tagH=16}
local D=110
local E=5
local F={1}
local G={1,2}
local H={1,4}
local y={3,4}
local I={1,2,3}
local J={2,3,4}
local x={1,2,3,4}

function b:darkShade(e,i)
return math.max(1,e-i)
end

function b:drawRegion(i,k,l,m,n,r,s,t,u,z,A)
for B,e in ipairs(z)do
i:sheet(k,l,m+(e-1)*s,n,r,t,u,1,self:darkShade(e,A))
end
end

function b:drawMapLayer(u,z,A,B)
local e=self.field
local l=e.map
local C,m=l.width*c,l.height*c
local n,r=e.camera.x+self:shakeOffset(),e.camera.y
local i,k=math.max(0,n),math.max(0,r)
local s=math.min(a.WIDTH,C-i)
local t=math.min(a.HEIGHT,m-k)
if s<=0 or t<=0 then
return
end
self:drawRegion(u,z,i,k,s,t,m,i-n,k-r,B,A)
end

function b:drawChunkedLayer(K,L,M,N)
local l=self.field
local m=l.map
local n,e=m.chunk.w*c,m.chunk.h*c
local i,k=l.camera.x+self:shakeOffset(),l.camera.y
for z=math.floor(math.max(0,k)/e),math.floor((k+a.HEIGHT-1)/e)do
for A=math.floor(math.max(0,i)/n),math.floor((i+a.WIDTH-1)/n)do
local r,s=A*n,z*e
local t,u=math.max(0,i-r),math.max(0,k-s)
local B=math.min(n-t,i+a.WIDTH-r-t)
local C=math.min(e-u,k+a.HEIGHT-s-u)
if B>0 and C>0 and r<m.width*c and s<m.height*c then
local O=self:art(L.."_"..l.id.."_"..A.."_"..z)
self:drawRegion(K,O,t,u,B,C,e,r+t-i,s+u-k,N,M)
end
end
end
end

function b:drawLayer(e,i,k,l)
if self.field.map.chunk then
self:drawChunkedLayer(e,i,k,l)
else
self:drawMapLayer(e,self:art(i.."_"..self.field.id),k,l)
end
end

function b:drawVeil(A,B)
local i=self.field
local r=i.map
local s,l=i.camera.x+self:shakeOffset(),i.camera.y
local C=self:art("veil")
local t=h.span*c
local K=256/h.grid*c
local L=math.floor(self.clock/h.frameTicks)%h.frames
local u=math.floor(s/c)
for k=math.floor(l/c),math.floor((l+a.HEIGHT-1)/c)do
for z=0,1 do
local e,m=0,1
for M=0,h.span-1 do
local n=u+z*h.span+M
if n>=0 and k>=0 and n<r.width and k<r.height and not i:seenAt(n,k)then
e=e+m
end
m=m*2
end
if e>0 then
local n=(u+z*h.span)*c-s
local M=k*c-l
for N,O in ipairs(h.shades)do
local P=L*#h.shades+N-1
A:sheet(C,e%h.grid*t,P*K+math.floor(e/h.grid)*c,t,c,n,M,1,self:darkShade(O,B))
end
end
end
end
end

function b:drawMurkWalls(l,m)
local n=self.field
local r=math.floor(self.clock/10)%2
for s,e in ipairs(n.map.walls)do
if not o.hasFlag(self.state,e.flag)then
for i=e.y,e.y+e.h-1 do
for k=e.x,e.x+e.w-1 do
self:drawObject(l,g.murk+(k+i+r)%2,k,i,m,G)
end
end
end
end
end

function b:drawBeams(m,n)
local i=self.field
local r=math.floor(self.clock/j.ticks)%j.frames
for s,e in ipairs(i.map.objects)do
if e.kind=="watchlight"and o.hasFlag(self.state,e.flag)then
local k=e.x*c+e.w*c/2-j.w/2-i.camera.x+self:shakeOffset()
local l=e.y*c-j.rise-i.camera.y
if k>-j.w and k<a.WIDTH and l>-j.h and l<a.HEIGHT then
self:drawRegion(m,self:art("beam"),r*j.w,0,j.w,j.h,j.h,k,l,y,n)
end
end
end
end

function b:shakeOffset()
if self.shake>0 then
return(self.shake%4<2)and 2 or-2
end
return 0
end

local function u(e)
local i=0
if e.moving then
i=1+math.floor(e.frame/6)%2
end
return(e.dir-1)*3+i
end

function b:drawActor(l,e,r)
local m=self.field
local i=e.px-m.camera.x+self:shakeOffset()
local k=e.py-m.camera.y-(p-c)
if i<-v or i>a.WIDTH or k<-p or k>a.HEIGHT then
return
end
local s=self:art("walk_"..e.sprite)
self:drawRegion(l,s,u(e)*v,0,v,p,p,i,k,x,r)
local n=self.emotes[e.id]
if n then
d.icon(l,self.artUi,n.kind,i+1,k-11,H)
end
end

function b:drawObject(l,m,n,r,s,t)
local k=self.field
local e=n*c-k.camera.x+self:shakeOffset()
local i=r*c-k.camera.y-(q-c)
if e<-w or e>a.WIDTH or i<-q or i>a.HEIGHT then
return
end
self:drawRegion(l,self.artObjects,m*w,0,w,q,q,e,i,t or x,s)
end

function b:drawFixtures(i,k)
local n=self.field
local l=n.map
local r=math.floor(self.clock/12)%2
for z,e in ipairs(l.lamps)do
if e.brazier then
local m=g.brazierDark
if n:lampLit(e)then
m=g.brazierLit+r*2
end
self:drawObject(i,m,e.x,e.y+1,k)
self:drawObject(i,m+1,e.x+1,e.y+1,k)
elseif n:lampLit(e)then
self:drawObject(i,g.lampLit+r,e.x,e.y,k)
else
self:drawObject(i,g.lampDark,e.x,e.y,k)
local m=e.gate
if m then
for s=m.y,m.y+m.h-1 do
for t=m.x,m.x+m.w-1 do
self:drawObject(i,g.gate+(t+s+r)%2,t,s,k,y)
end
end
end
end
end
for s,e in ipairs(l.chests)do
if n:revealedAt(e.x,e.y)then
local m=g.chestClosed
if o.hasFlag(self.state,e.flag)then
m=g.chestOpen
end
self:drawObject(i,m,e.x,e.y,k)
end
end
for m,e in ipairs(l.notes)do
if n:noteAt(e.x,e.y)then
self:drawObject(i,g.note,e.x,e.y,k)
end
end
for m,e in ipairs(l.echoes)do
if n:echoAt(e.x,e.y)then
self:drawObject(i,g.echo+r,e.x,e.y,k)
end
end
if l.bellpost and o.meets(self.state,l.bellpost.when)then
self:drawObject(i,g.bellpost,l.bellpost.x,l.bellpost.y,k)
end
end

function b:drawWisps(i,k)
if not self.field.map.wisps then
return
end
for e=1,E do
local n=0.15+e*0.05
local l=(e*53+self.clock*n)%(a.WIDTH+40)-30
local m=(e*37)%(a.HEIGHT-10)
d.fill(i,l,m,14+(e%3)*6,1,self:darkShade(a.PAPER,k))
d.fill(i,l+5,m+2,10,1,self:darkShade(a.PAPER,k))
end
end

function b:swirlDarkness()
local e=self.pendingBattle.timer
if e<12 then
return 3
end
return(math.floor(e/5)%2==0)and 2 or 0
end

function b:drawField(e)
local k=self.field
local i=self:darkness()
if self.pendingBattle then
i=self:swirlDarkness()
end
local l=k.map
e:clear(a.shade(self:darkShade(a.PAPER,i)))
self:drawLayer(e,"map",i,I)
self:drawFixtures(e,i)
for n,m in ipairs(k:drawOrder())do
self:drawActor(e,m,i)
end
if l.overlay~=false then
self:drawLayer(e,"over",i,x)
end
self:drawOtherFloorsHidden(e,i)
if l.fog then
self:drawBeams(e,i)
self:drawVeil(e,i)
self:drawMurkWalls(e,i)
end
self:drawWisps(e,i)
self:drawBanner(e)
if self.dialog and not self.dialog.card then
self:drawDialog(e)
end
if self.choice then
self:drawChoice(e)
end
end

function b:drawOtherFloorsHidden(i,z)
local e=self.field:floorBox()
if not e then
return
end
local k,l,m=a.shade(self:darkShade(a.PAPER,z))
local r=e.x*c-self.field.camera.x+self:shakeOffset()
local n=e.y*c-self.field.camera.y
local s,t=r+e.w*c,n+e.h*c
i:rect(0,0,a.WIDTH,math.max(0,n),k,l,m,1)
i:rect(0,t,a.WIDTH,math.max(0,a.HEIGHT-t),k,l,m,1)
i:rect(0,n,math.max(0,r),e.h*c,k,l,m,1)
i:rect(s,n,math.max(0,a.WIDTH-s),e.h*c,k,l,m,1)
end

function b:drawBanner(i)
local e=self.banner
if not e then
return
end
e.timer=e.timer-1
if e.timer<=0 then
self.banner=nil
return
end
local k=i:textWidth(e.text)+16
local l=math.floor((a.WIDTH-k)/2)
d.frame(i,self.artUi,l,6,k,21)
d.textCentre(i,e.text,a.WIDTH/2,8)
end

function b:showBanner()
local e=self.field.map
if e.banner then
self.banner={text=a.text("Map_"..e.banner),timer=D}
end
end

local function s(e,l)
if l>=string.len(e)then
return e
end
local i=l
local k=string.byte(e,i)
if k and k>=0xD800 and k<=0xDBFF then
i=i+1
end
return string.sub(e,1,i)
end

function b:drawDialog(i)
local e=self.dialog
local m=self.artUi
d.frame(i,m,0,f.y,a.WIDTH,f.h)
if e.speaker then
local n=a.text("Name_"..e.speaker)
local k=a.Characters.BY_ID[e.speaker]
local r=i:textWidth(n)+10
local l=0
if k then
l=11
end
d.fill(i,f.tagX,f.tagY,r+l,f.tagH,a.INK)
if k then
i:layers(self.artHeads,(k.index-1)*8,8,8,f.tagX+4,f.tagY+4,J)
end
d.text(i,n,f.tagX+5+l,f.tagY,a.PAPER)
end
local n=e.pages[e.page]or{}
local k=e.shown
for r,l in ipairs(n)do
if k<=0 then
break
end
d.text(i,s(l,k),f.textX,f.textY+(r-1)*d.LINE)
k=k-string.len(l)
end
local l=0
for t,r in ipairs(n)do
l=l+string.len(r)
end
if e.shown>=l and not e.holding and math.floor(self.clock/16)%2==0 then
d.icon(i,m,"arrowDown",a.WIDTH-11,a.HEIGHT-10,F)
end
end

function b:drawChoice(k)
local n=self.choice
local e=0
local i={}
for m,r in ipairs(n.options)do
local l=a.text(r)
i[m]={label=l}
e=math.max(e,k:textWidth(l))
end
e=e+22
local l=#i*d.LINE+6
local r=a.WIDTH-e-4
local m=f.y-l-2
if not self.dialog then
m=a.HEIGHT-l-4
end
d.frame(k,self.artUi,r,m,e,l)
d.list(k,self.artUi,i,r+3,m+3,e-6,#i,n.selected,1,self.clock,true)
end

function b:drawCard(i)
local k=self.card
i:clear(a.shade(a.INK))
local m=i:wrapText(a.text(k.key),a.WIDTH-20)
local e=34
for n,l in ipairs(m)do
d.textCentre(i,l,a.WIDTH/2,e,a.PAPER)
e=e+d.LINE
end
if k.subKey then
local l=i:wrapText(a.text(k.subKey),a.WIDTH-20)
e=e+6
for r,n in ipairs(l)do
d.textCentre(i,n,a.WIDTH/2,e,a.MID)
e=e+d.LINE
end
end
local l=math.min(120,k.timer*3)
d.fill(i,(a.WIDTH-l)/2,28,l,1,a.DARK)
end

function b:draw(e)
local i=self.mode
if i==b.MODE_FIELD then
self:drawField(e)
elseif i==b.MODE_BATTLE then
self.battleScene:draw(e)
elseif i==b.MODE_MENU then
if self:menuCoversScreen()then
e:clear(a.shade(a.PAPER))
else
self:drawField(e)
end
self:drawMenu(e)
elseif i==b.MODE_SHOP then
if self.dialog or self.shop.screen~="choose"then
e:clear(a.shade(a.PAPER))
else
self:drawField(e)
end
self:drawShop(e)
elseif i==b.MODE_CARD then
self:drawCard(e)
elseif i==b.MODE_OVER then
self:drawOver(e)
elseif i==b.MODE_ENDING then
self:drawEnding(e)
else
self:drawTitle(e)
end
end
