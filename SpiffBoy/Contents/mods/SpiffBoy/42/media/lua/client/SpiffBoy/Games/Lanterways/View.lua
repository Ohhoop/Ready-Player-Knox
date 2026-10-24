require"SpiffBoy/Games/Lanterways/Base"
require"SpiffBoy/Games/Lanterways/Window"

local b=SpiffBoyLanterwaysGame
local a=SpiffBoy.Lanterways
local d=a.Window
local m=a.Party

local c=a.TILE
local v,n=12,16
local w,o=12,24
local g={lampDark=0,lampLit=1,chestClosed=3,chestOpen=4,gate=5,bellpost=7,note=8,echo=9,murk=11,brazierDark=13,brazierLit=15}
local h={span=8,grid=16,frames=2,frameTicks=40,shades={3,4}}
local i={w=48,h=24,frames=4,ticks=8,rise=34}
local e={y=66,h=54,textX=7,textY=69,tagX=4,tagY=51,tagH=16}
local D=110
local E=5
local F={1}
local G={1,2}
local H={1,4}
local A={3,4}
local I={1,2,3}
local J={2,3,4}
local z={1,2,3,4}

function b:darkShade(shade,darkness)
return math.max(1,shade-darkness)
end

function b:drawRegion(screen,texture,sx,sy,sw,sh,rowHeight,x,y,rows,darkness)
for j,f in ipairs(rows)do
screen:sheet(texture,sx,sy+(f-1)*rowHeight,sw,sh,x,y,1,self:darkShade(f,darkness))
end
end

function b:drawMapLayer(screen,texture,darkness,rows)
local f=self.field
local l=f.map
local u,p=l.width*c,l.height*c
local q,r=f.camera.x+self:shakeOffset(),f.camera.y
local j,k=math.max(0,q),math.max(0,r)
local s=math.min(a.WIDTH,u-j)
local t=math.min(a.HEIGHT,p-k)
if s<=0 or t<=0 then
return
end
self:drawRegion(screen,texture,j,k,s,t,p,j-q,k-r,rows,darkness)
end

function b:drawChunkedLayer(screen,layer,darkness,rows)
local l=self.field
local p=l.map
local q,f=p.chunk.w*c,p.chunk.h*c
local j,k=l.camera.x+self:shakeOffset(),l.camera.y
for x=math.floor(math.max(0,k)/f),math.floor((k+a.HEIGHT-1)/f)do
for y=math.floor(math.max(0,j)/q),math.floor((j+a.WIDTH-1)/q)do
local r,s=y*q,x*f
local t,u=math.max(0,j-r),math.max(0,k-s)
local B=math.min(q-t,j+a.WIDTH-r-t)
local C=math.min(f-u,k+a.HEIGHT-s-u)
if B>0 and C>0 and r<p.width*c and s<p.height*c then
local K=self:art(layer.."_"..l.id.."_"..y.."_"..x)
self:drawRegion(screen,K,t,u,B,C,f,r+t-j,s+u-k,rows,darkness)
end
end
end
end

function b:drawLayer(screen,layer,darkness,rows)
if self.field.map.chunk then
self:drawChunkedLayer(screen,layer,darkness,rows)
else
self:drawMapLayer(screen,self:art(layer.."_"..self.field.id),darkness,rows)
end
end

function b:drawVeil(screen,darkness)
local j=self.field
local r=j.map
local s,l=j.camera.x+self:shakeOffset(),j.camera.y
local y=self:art("veil")
local t=h.span*c
local B=256/h.grid*c
local C=math.floor(self.clock/h.frameTicks)%h.frames
local u=math.floor(s/c)
for k=math.floor(l/c),math.floor((l+a.HEIGHT-1)/c)do
for x=0,1 do
local f,p=0,1
for K=0,h.span-1 do
local q=u+x*h.span+K
if q>=0 and k>=0 and q<r.width and k<r.height and not j:seenAt(q,k)then
f=f+p
end
p=p*2
end
if f>0 then
local q=(u+x*h.span)*c-s
local K=k*c-l
for L,M in ipairs(h.shades)do
local N=C*#h.shades+L-1
screen:sheet(y,f%h.grid*t,N*B+math.floor(f/h.grid)*c,t,c,q,K,1,self:darkShade(M,darkness))
end
end
end
end
end

function b:drawMurkWalls(screen,darkness)
local l=self.field
local p=math.floor(self.clock/10)%2
for q,f in ipairs(l.map.walls)do
if not m.hasFlag(self.state,f.flag)then
for j=f.y,f.y+f.h-1 do
for k=f.x,f.x+f.w-1 do
self:drawObject(screen,g.murk+(k+j+p)%2,k,j,darkness,G)
end
end
end
end
end

function b:drawBeams(screen,darkness)
local j=self.field
local p=math.floor(self.clock/i.ticks)%i.frames
for q,f in ipairs(j.map.objects)do
if f.kind=="watchlight"and m.hasFlag(self.state,f.flag)then
local k=f.x*c+f.w*c/2-i.w/2-j.camera.x+self:shakeOffset()
local l=f.y*c-i.rise-j.camera.y
if k>-i.w and k<a.WIDTH and l>-i.h and l<a.HEIGHT then
self:drawRegion(screen,self:art("beam"),p*i.w,0,i.w,i.h,i.h,k,l,A,darkness)
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

local function t(actor)
local f=0
if actor.moving then
f=1+math.floor(actor.frame/6)%2
end
return(actor.dir-1)*3+f
end

function b:drawActor(screen,actor,darkness)
local k=self.field
local f=actor.px-k.camera.x+self:shakeOffset()
local j=actor.py-k.camera.y-(n-c)
if f<-v or f>a.WIDTH or j<-n or j>a.HEIGHT then
return
end
local p=self:art("walk_"..actor.sprite)
self:drawRegion(screen,p,t(actor)*v,0,v,n,n,f,j,z,darkness)
local l=self.emotes[actor.id]
if l then
d.icon(screen,self.artUi,l.kind,f+1,j-11,H)
end
end

function b:drawObject(screen,cell,tileX,tileY,darkness,rows)
local k=self.field
local f=tileX*c-k.camera.x+self:shakeOffset()
local j=tileY*c-k.camera.y-(o-c)
if f<-w or f>a.WIDTH or j<-o or j>a.HEIGHT then
return
end
self:drawRegion(screen,self.artObjects,cell*w,0,w,o,o,f,j,rows or z,darkness)
end

function b:drawFixtures(screen,darkness)
local l=self.field
local j=l.map
local p=math.floor(self.clock/12)%2
for s,f in ipairs(j.lamps)do
if f.brazier then
local k=g.brazierDark
if l:lampLit(f)then
k=g.brazierLit+p*2
end
self:drawObject(screen,k,f.x,f.y+1,darkness)
self:drawObject(screen,k+1,f.x+1,f.y+1,darkness)
elseif l:lampLit(f)then
self:drawObject(screen,g.lampLit+p,f.x,f.y,darkness)
else
self:drawObject(screen,g.lampDark,f.x,f.y,darkness)
local k=f.gate
if k then
for q=k.y,k.y+k.h-1 do
for r=k.x,k.x+k.w-1 do
self:drawObject(screen,g.gate+(r+q+p)%2,r,q,darkness,A)
end
end
end
end
end
for q,f in ipairs(j.chests)do
if l:revealedAt(f.x,f.y)then
local k=g.chestClosed
if m.hasFlag(self.state,f.flag)then
k=g.chestOpen
end
self:drawObject(screen,k,f.x,f.y,darkness)
end
end
for k,f in ipairs(j.notes)do
if l:noteAt(f.x,f.y)then
self:drawObject(screen,g.note,f.x,f.y,darkness)
end
end
for k,f in ipairs(j.echoes)do
if l:echoAt(f.x,f.y)then
self:drawObject(screen,g.echo+p,f.x,f.y,darkness)
end
end
if j.bellpost and m.meets(self.state,j.bellpost.when)then
self:drawObject(screen,g.bellpost,j.bellpost.x,j.bellpost.y,darkness)
end
end

function b:drawWisps(screen,darkness)
if not self.field.map.wisps then
return
end
for f=1,E do
local l=0.15+f*0.05
local j=(f*53+self.clock*l)%(a.WIDTH+40)-30
local k=(f*37)%(a.HEIGHT-10)
d.fill(screen,j,k,14+(f%3)*6,1,self:darkShade(a.PAPER,darkness))
d.fill(screen,j+5,k+2,10,1,self:darkShade(a.PAPER,darkness))
end
end

function b:swirlDarkness()
local f=self.pendingBattle.timer
if f<12 then
return 3
end
return(math.floor(f/5)%2==0)and 2 or 0
end

function b:drawField(screen)
local j=self.field
local f=self:darkness()
if self.pendingBattle then
f=self:swirlDarkness()
end
local k=j.map
screen:clear(a.shade(self:darkShade(a.PAPER,f)))
self:drawLayer(screen,"map",f,I)
self:drawFixtures(screen,f)
for p,l in ipairs(j:drawOrder())do
self:drawActor(screen,l,f)
end
if k.overlay~=false then
self:drawLayer(screen,"over",f,z)
end
self:drawOtherFloorsHidden(screen,f)
if k.fog then
self:drawBeams(screen,f)
self:drawVeil(screen,f)
self:drawMurkWalls(screen,f)
end
self:drawWisps(screen,f)
self:drawBanner(screen)
if self.dialog and not self.dialog.card then
self:drawDialog(screen)
end
if self.choice then
self:drawChoice(screen)
end
end

function b:drawOtherFloorsHidden(screen,darkness)
local f=self.field:floorBox()
if not f then
return
end
local j,k,l=a.shade(self:darkShade(a.PAPER,darkness))
local q=f.x*c-self.field.camera.x+self:shakeOffset()
local p=f.y*c-self.field.camera.y
local r,s=q+f.w*c,p+f.h*c
screen:rect(0,0,a.WIDTH,math.max(0,p),j,k,l,1)
screen:rect(0,s,a.WIDTH,math.max(0,a.HEIGHT-s),j,k,l,1)
screen:rect(0,p,math.max(0,q),f.h*c,j,k,l,1)
screen:rect(r,p,math.max(0,a.WIDTH-r),f.h*c,j,k,l,1)
end

function b:drawBanner(screen)
local f=self.banner
if not f then
return
end
f.timer=f.timer-1
if f.timer<=0 then
self.banner=nil
return
end
local j=screen:textWidth(f.text)+16
local k=math.floor((a.WIDTH-j)/2)
d.frame(screen,self.artUi,k,6,j,21)
d.textCentre(screen,f.text,a.WIDTH/2,8)
end

function b:showBanner()
local f=self.field.map
if f.banner then
self.banner={text=a.text("Map_"..f.banner),timer=D}
end
end

local function r(line,count)
if count>=string.len(line)then
return line
end
local f=count
local j=string.byte(line,f)
if j and j>=0xD800 and j<=0xDBFF then
f=f+1
end
return string.sub(line,1,f)
end

function b:drawDialog(screen)
local f=self.dialog
local l=self.artUi
d.frame(screen,l,0,e.y,a.WIDTH,e.h)
if f.speaker then
local p=a.text("Name_"..f.speaker)
local j=a.Characters.BY_ID[f.speaker]
local q=screen:textWidth(p)+10
local k=0
if j then
k=11
end
d.fill(screen,e.tagX,e.tagY,q+k,e.tagH,a.INK)
if j then
screen:layers(self.artHeads,(j.index-1)*8,8,8,e.tagX+4,e.tagY+4,J)
end
d.text(screen,p,e.tagX+5+k,e.tagY,a.PAPER)
end
local p=f.pages[f.page]or{}
local j=f.shown
for q,k in ipairs(p)do
if j<=0 then
break
end
d.text(screen,r(k,j),e.textX,e.textY+(q-1)*d.LINE)
j=j-string.len(k)
end
local k=0
for s,q in ipairs(p)do
k=k+string.len(q)
end
if f.shown>=k and not f.holding and math.floor(self.clock/16)%2==0 then
d.icon(screen,l,"arrowDown",a.WIDTH-11,a.HEIGHT-10,F)
end
end

function b:drawChoice(screen)
local p=self.choice
local f=0
local j={}
for l,q in ipairs(p.options)do
local k=a.text(q)
j[l]={label=k}
f=math.max(f,screen:textWidth(k))
end
f=f+22
local k=#j*d.LINE+6
local q=a.WIDTH-f-4
local l=e.y-k-2
if not self.dialog then
l=a.HEIGHT-k-4
end
d.frame(screen,self.artUi,q,l,f,k)
d.list(screen,self.artUi,j,q+3,l+3,f-6,#j,p.selected,1,self.clock,true)
end

function b:drawCard(screen)
local j=self.card
screen:clear(a.shade(a.INK))
local l=screen:wrapText(a.text(j.key),a.WIDTH-20)
local f=34
for p,k in ipairs(l)do
d.textCentre(screen,k,a.WIDTH/2,f,a.PAPER)
f=f+d.LINE
end
if j.subKey then
local k=screen:wrapText(a.text(j.subKey),a.WIDTH-20)
f=f+6
for q,p in ipairs(k)do
d.textCentre(screen,p,a.WIDTH/2,f,a.MID)
f=f+d.LINE
end
end
local k=math.min(120,j.timer*3)
d.fill(screen,(a.WIDTH-k)/2,28,k,1,a.DARK)
end

function b:draw(screen)
local f=self.mode
if f==b.MODE_FIELD then
self:drawField(screen)
elseif f==b.MODE_BATTLE then
self.battleScene:draw(screen)
elseif f==b.MODE_MENU then
if self:menuCoversScreen()then
screen:clear(a.shade(a.PAPER))
else
self:drawField(screen)
end
self:drawMenu(screen)
elseif f==b.MODE_SHOP then
if self.dialog or self.shop.screen~="choose"then
screen:clear(a.shade(a.PAPER))
else
self:drawField(screen)
end
self:drawShop(screen)
elseif f==b.MODE_CARD then
self:drawCard(screen)
elseif f==b.MODE_OVER then
self:drawOver(screen)
elseif f==b.MODE_ENDING then
self:drawEnding(screen)
else
self:drawTitle(screen)
end
end
