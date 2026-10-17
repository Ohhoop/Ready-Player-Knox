require"SpiffBoy/Core/Runtime"
require"SpiffBoy/Games/QuickStart/Game"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Road"

local a=SpiffBoyQuickStartGame
local b=SpiffBoy.QuickStart
local i=b.Atlas
local z=b.Tracks
local j=b.Road
local m=b.Roster
local r=b.Race
local g=b.Music
local A=b.Records
local k=b.Fixed

local f=math.floor
local s=b.SHADES
local d=b.WIDTH
local n=b.HEIGHT
local B=b.gameText

a.MENU={
cruiseSpeed=1.3,
fastSpeed=6,
speedStep=0.1,
lookAhead=32,
cruiseTrack="MenuHighway",
signTicks=30,
signY=4,
nameTop=6,
exitGap=2,
nameWidth=136,
arrowGap=8,
limitDigitsTop=38,
limitDigitGap=2,
titleKarts=4,
titleGap=40,
titleAccel=0.05,
titleTop=2.6,
titleTopStep=0.12,
lightTicks=50,
}

local c=a.MENU

function a:fill(h,l,o,p,q,t)
local e=s[l]
h:rect(o,p,q,t,e.r,e.g,e.b,1)
end

function a:write(h,l,o,p,q)
local e=s[q]
h:text(l,o,p,e.r,e.g,e.b,1)
end

function a:centre(h,l,o,p,q)
local e=s[q]
h:textCentre(l,o,p,e.r,e.g,e.b,1)
end

function a:say(e,...)
return B(e,...)
end

function a:image(l,h,o,p)
local e=i[h]
l:layers(self:art(h),0,e.w,e.h,o,p,e.shades)
end

local function e(h,l)
return h~=nil and h.pressed[l]==true
end
a.pressed=e

function a:moveCursor(q,l,t,u,o,p)
o,p=o or"up",p or"down"
local v=e(q,o)and-1 or e(q,p)and 1 or 0
if v==0 then
return l
end
local h=l
for w=1,t do
h=b.wrapIndex(h+v,t)
if not u or u(h)then
self:effect(g.TICK)
return h
end
end
return l
end

function a:cruiseOn(h)
if not self.cruiseTrack then
self.cruiseTrack=z.load(c.cruiseTrack,false)
end
self.cruisePath=h
self.cruiseAt=self.cruiseTrack.paths[h].loopFrom
self.cruiseSpeed=c.cruiseSpeed
self.cruiseLeaving=false
end

function a:cruiseTick()
local l=self.cruiseTrack.paths[self.cruisePath]
local h=c.cruiseSpeed
if self.cruiseLeaving then
local o=self.cruiseTrack.paths.exit.loopFrom-self.cruiseAt
local p=(self.cruiseSpeed*self.cruiseSpeed-c.cruiseSpeed*c.cruiseSpeed)/(2*c.speedStep)
if o>p then
h=c.fastSpeed
end
end
if self.cruiseSpeed<h then
self.cruiseSpeed=math.min(h,self.cruiseSpeed+c.speedStep)
else
self.cruiseSpeed=math.max(h,self.cruiseSpeed-c.speedStep)
end
self.cruiseAt=self.cruiseAt+self.cruiseSpeed
local o=l.loopFrom+l.loopLength
if self.cruiseAt>=o and self.cruiseAt-self.cruiseSpeed<o then
if self.cruiseLeaving and self.cruisePath=="highway"then
self.cruisePath="exit"
elseif not self.cruiseLeaving then
self.cruiseAt=self.cruiseAt-l.loopLength
end
end
end

local function x(h,p)
local q=math.sqrt((h[2].x-h[1].x)^2+(h[2].y-h[1].y)^2)
local o=SpiffBoy.clamp(f(p/q)+1,1,#h-1)
local t=math.min(1,p/q-(o-1))
local l,u=h[o],h[o+1]
return l.x+(u.x-l.x)*t,l.y+(u.y-l.y)*t
end

function a:cruiseCamera()
local l=self.cruiseTrack.paths[self.cruisePath].points
local o,p=x(l,self.cruiseAt)
local q,t=x(l,self.cruiseAt+c.lookAhead)
local h=f(k.atan2(t-p,q-o)/k.FINE)
return{x=o-j.BEHIND*k.cos(h)/k.ONE,y=p-j.BEHIND*k.sin(h)/k.ONE,angle=h}
end

function a:drawCruise(h,l,q)
local o=self.context.art
j.draw(h,self.cruiseTrack,l,o,i)
local p=j.newScene()
j.addDecor(p,l,self.cruiseTrack)
j.drawScene(h,p,o,SpiffBoyScreen.MAX_CALLS-h.calls-q)
end

function a:openTitle()
self.screen=a.SCREEN_TITLE
self.titleIndex=self.titleIndex or 1
self.titleClock=0
self.twoPlayer=false
self.paused=false
self.world=nil
self.gp=nil
self.port:reset()
self:music(g.TITLE)
end

function a:titleAllowed(h)
return h~=2 or self.port:isConnected()
end

function a:tick_title(h)
self.titleClock=self.titleClock+1
if not self:titleAllowed(self.titleIndex)then
self.titleIndex=1
end
self.titleIndex=self:moveCursor(h,self.titleIndex,3,function(l)return self:titleAllowed(l)end)
if e(h,"a")or e(h,"start")then
self:effect(g.CONFIRM)
if self.titleIndex==1 then
self.twoPlayer=false
self:openHighway()
elseif self.titleIndex==2 then
self:openWaiting()
else
self:openOptions()
end
end
end

local function C(h,l)
local o=l/c.titleAccel
if h<=o then
return c.titleAccel*h*h/2
end
return l*o/2+l*(h-o)
end

function a:draw_title(h)
self:fill(h,b.PAPER,0,0,d,n)
self:fill(h,b.MID,0,74,d,n-74)
self:fill(h,b.DARK,0,82,d,18)
for l=0,d,16 do
self:fill(h,b.PAPER,l+(self.titleClock%16),90,8,2)
end
local o=i.light
local u=math.min(4,f(self.titleClock/c.lightTicks)+1)
self:fill(h,b.INK,0,2,d,1)
h:layers(self:art("light"),(u-1)*o.frame,o.frame,o.h,6,3,o.shades)
local y=i.logo
self:image(h,"logo",f((d-y.w)/2)+8,10)
if u==4 then
local D=self.titleClock-3*c.lightTicks
for p=1,c.titleKarts do
local v=m.LIST[(p*2-1)%#m.LIST+1]
local q=i["kart_"..v.id]
local l=q.steps[2]
local t=C(D,c.titleTop-(p-1)*c.titleTopStep)-(p-1)*c.titleGap
local w=t-l.w
if t>=0 then
w=b.mod(t,d+2*l.w)-l.w
end
h:layers(self:art("kart_"..v.id),l.x+2*l.w,l.w,q.h,f(w),86-q.h+(p%2)*8,q.shades)
end
end
local t={"Title_1P","Title_2P","Title_Options"}
for l,v in ipairs(t)do
local p=38+(l-1)*12
local q=self:titleAllowed(l)and b.INK or b.MID
if l==self.titleIndex then
self:fill(h,b.INK,40,p,100,12)
q=b.PAPER
end
self:centre(h,self:say(v),d/2,p-2,q)
end
end

function a:openOptions()
self.screen=a.SCREEN_OPTIONS
end

function a:tick_options(h)
if e(h,"left")or e(h,"right")or e(h,"a")then
self.data.options.music=not self.data.options.music
self:applyMusic()
self:effect(g.TICK)
self:store()
end
if e(h,"b")or e(h,"start")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:draw_options(h)
self:fill(h,b.PAPER,0,0,d,n)
self:centre(h,self:say("Title_Options"),d/2,12,b.INK)
local l=self:say(self.data.options.music and"On"or"Off")
self:centre(h,self:say("Options_Music"),d/2,46,b.INK)
self:fill(h,b.INK,50,64,80,16)
self:centre(h,"< "..l.." >",d/2,64,b.PAPER)
end

function a:openWaiting()
self.screen=a.SCREEN_WAITING
self.twoPlayer=true
self.port:reset()
self.port:forgetMeasure()
self.port:hello()
self.waitClock=0
end

function a:tick_waiting(h)
self.waitClock=self.waitClock+1
if self.waitClock%60==0 then
self.port:hello()
end
if e(h,"b")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:draw_waiting(h)
self:fill(h,b.PAPER,0,0,d,n)
self:centre(h,self:say("WaitingP2"),d/2,52,b.INK)
end

function a:openGuest()
self.screen=a.SCREEN_GUEST
self:cruiseOn("highway")
end

function a:tick_guest(h)
self:cruiseTick()
if self.port:needsPing()then
self.port:ping(self.clock)
end
end

function a:draw_guest(h)
self:drawCruise(h,self:cruiseCamera(),40)
self:fill(h,b.INK,0,52,d,18)
self:centre(h,self:say("P1Choosing"),d/2,53,b.PAPER)
end

function a:modeAllowed(h)
return not(self.twoPlayer and a.MODES[h]==r.MODE_TT)
end

function a:openHighway()
self.screen=a.SCREEN_HIGHWAY
self.gp=nil
self.signTimer=nil
self:cruiseOn("highway")
if not self:modeAllowed(self.setup.mode)then
self.setup.mode=1
end
self:music(g.MENU)
end

function a:tick_highway(h)
if self.port:needsPing()and self.twoPlayer then
self.port:ping(self.clock)
end
self:cruiseTick()
if self.cruiseLeaving then
self.signTimer=self.signTimer+1
if self.cruisePath=="exit"and self.cruiseAt>=self.cruiseTrack.paths.exit.loopFrom then
local l=self:modeOf()
if l==r.MODE_GP or l==r.MODE_VS then
self:openCc()
else
self:openMap()
end
end
return
end
self.setup.mode=self:moveCursor(h,self.setup.mode,#a.MODES,function(l)return self:modeAllowed(l)end,"left","right")
if e(h,"a")then
self:effect(g.CONFIRM)
self.cruiseLeaving=true
self.signTimer=0
elseif e(h,"b")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:drawExitSign(h,o)
local p=i.exit_sign
self:image(h,"exit_sign",f((d-p.w)/2),o)
local q=h:wrapText(self:say(a.MODE_KEYS[self.setup.mode]),c.nameWidth)
local l=o+c.nameTop
for t,u in ipairs(q)do
if t<=2 then
self:centre(h,u,d/2,l,b.PAPER)
l=l+h:lineHeight()
end
end
self:centre(h,self:say("Exit").." "..tostring(self.setup.mode),d/2,l+c.exitGap,b.MID)
end

function a:draw_highway(h)
self:drawCruise(h,self:cruiseCamera(),120)
local l=i.exit_sign
local o=c.signY
if self.signTimer then
if self.signTimer>=c.signTicks then
return
end
o=c.signY-f((l.h+c.signY)*self.signTimer/c.signTicks)
else
local p=f((d-l.w)/2)
local q=o+f(l.h/2)-f(h:lineHeight()/2)
self:centre(h,"<",p-c.arrowGap,q,b.INK)
self:centre(h,">",p+l.w+c.arrowGap,q,b.INK)
end
self:drawExitSign(h,o)
end

function a:ccAllowed(h)
return not m.CC[h].mirrored or A.unlocked(self.data,"mirror")
end

function a:openCc()
self.screen=a.SCREEN_CC
if self.cruisePath~="exit"then
self:cruiseOn("exit")
end
self.cruiseLeaving=false
if not self:ccAllowed(self.setup.cc)then
self.setup.cc=1
end
end

function a:tick_cc(h)
self:cruiseTick()
self.setup.cc=self:moveCursor(h,self.setup.cc,#m.CC,function(l)return self:ccAllowed(l)end,"left","right")
if e(h,"a")then
self:effect(g.CONFIRM)
self:openMap()
elseif e(h,"b")then
self:effect(g.BACK)
self:openHighway()
end
end

function a:draw_cc(h)
self:drawCruise(h,self:cruiseCamera(),60)
local p=i.speed_sign
local q,o=f((d-p.w)/2),c.signY
self:image(h,"speed_sign",q,o)
local l=m.CC[self.setup.cc]
if l.mirrored then
self:centre(h,self:say("Mirror"),d/2,o+c.limitDigitsTop,b.INK)
else
local t=i.limitdigits
local u=-c.limitDigitGap
for v=1,#l.id do
u=u+t.glyphs[string.sub(l.id,v,v)][2]+c.limitDigitGap
end
local v=f((d-u)/2)
for y=1,#l.id do
local w=t.glyphs[string.sub(l.id,y,y)]
h:sheet(self:art("limitdigits"),w[1],0,w[2],t.h,v,o+c.limitDigitsTop,1,b.INK)
v=v+w[2]+c.limitDigitGap
end
end
local t=o+f(p.h/2)-f(h:lineHeight()/2)
self:centre(h,"<",q-c.arrowGap,t,b.INK)
self:centre(h,">",q+p.w+c.arrowGap,t,b.INK)
end

function a:openPause()
self.paused=true
self.pauseIndex=1
self:effect(g.CONFIRM)
end

function a:tickPause(h)
self.pauseIndex=self:moveCursor(h,self.pauseIndex,3)
if e(h,"start")then
self.paused=false
return
end
if e(h,"a")then
self:effect(g.CONFIRM)
self.paused=false
if self.pauseIndex==2 then
self:startSoloRace()
elseif self.pauseIndex==3 then
self.gp=nil
self:openHighway()
end
end
end

function a:drawPause(h)
self:fill(h,b.INK,40,30,100,56)
self:fill(h,b.PAPER,42,32,96,52)
local q={"Pause_Continue","Pause_Restart","Pause_Quit"}
for l,t in ipairs(q)do
local o=34+(l-1)*16
local p=b.INK
if l==self.pauseIndex then
self:fill(h,b.INK,44,o+1,92,15)
p=b.PAPER
end
self:centre(h,self:say(t),d/2,o,p)
end
end
