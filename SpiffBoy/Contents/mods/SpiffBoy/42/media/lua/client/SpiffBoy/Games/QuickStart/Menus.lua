require"SpiffBoy/Core/Runtime"
require"SpiffBoy/Games/QuickStart/Game"
require"SpiffBoy/Games/QuickStart/Tracks"
require"SpiffBoy/Games/QuickStart/Road"

local a=SpiffBoyQuickStartGame
local b=SpiffBoy.QuickStart
local j=b.Atlas
local z=b.Tracks
local k=b.Road
local m=b.Roster
local q=b.Race
local g=b.Music
local A=b.Records
local l=b.Fixed

local f=math.floor
local r=b.SHADES
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

function a:fill(screen,shade,x,y,w,h)
local e=r[shade]
screen:rect(x,y,w,h,e.r,e.g,e.b,1)
end

function a:write(screen,text,x,y,shade)
local e=r[shade]
screen:text(text,x,y,e.r,e.g,e.b,1)
end

function a:centre(screen,text,x,y,shade)
local e=r[shade]
screen:textCentre(text,x,y,e.r,e.g,e.b,1)
end

function a:say(key,...)
return B(key,...)
end

function a:image(screen,name,x,y)
local e=j[name]
screen:layers(self:art(name),0,e.w,e.h,x,y,e.shades)
end

local function e(input,button)
return input~=nil and input.pressed[button]==true
end
a.pressed=e

function a:moveCursor(input,index,count,allowed,back,forth)
back,forth=back or"up",forth or"down"
local i=e(input,back)and-1 or e(input,forth)and 1 or 0
if i==0 then
return index
end
local h=index
for o=1,count do
h=b.wrapIndex(h+i,count)
if not allowed or allowed(h)then
self:effect(g.TICK)
return h
end
end
return index
end

function a:cruiseOn(name)
if not self.cruiseTrack then
self.cruiseTrack=z.load(c.cruiseTrack,false)
end
self.cruisePath=name
self.cruiseAt=self.cruiseTrack.paths[name].loopFrom
self.cruiseSpeed=c.cruiseSpeed
self.cruiseLeaving=false
end

function a:cruiseTick()
local i=self.cruiseTrack.paths[self.cruisePath]
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
local o=i.loopFrom+i.loopLength
if self.cruiseAt>=o and self.cruiseAt-self.cruiseSpeed<o then
if self.cruiseLeaving and self.cruisePath=="highway"then
self.cruisePath="exit"
elseif not self.cruiseLeaving then
self.cruiseAt=self.cruiseAt-i.loopLength
end
end
end

local function w(points,at)
local o=math.sqrt((points[2].x-points[1].x)^2+(points[2].y-points[1].y)^2)
local i=SpiffBoy.clamp(f(at/o)+1,1,#points-1)
local p=math.min(1,at/o-(i-1))
local h,s=points[i],points[i+1]
return h.x+(s.x-h.x)*p,h.y+(s.y-h.y)*p
end

function a:cruiseCamera()
local i=self.cruiseTrack.paths[self.cruisePath].points
local o,p=w(i,self.cruiseAt)
local s,t=w(i,self.cruiseAt+c.lookAhead)
local h=f(l.atan2(t-p,s-o)/l.FINE)
return{x=o-k.BEHIND*l.cos(h)/l.ONE,y=p-k.BEHIND*l.sin(h)/l.ONE,angle=h}
end

function a:drawCruise(screen,camera,reserve)
local h=self.context.art
k.draw(screen,self.cruiseTrack,camera,h,j)
local i=k.newScene()
k.addDecor(i,camera,self.cruiseTrack)
k.drawScene(screen,i,h,SpiffBoyScreen.MAX_CALLS-screen.calls-reserve)
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

function a:titleAllowed(index)
return index~=2 or self.port:isConnected()
end

function a:tick_title(input)
self.titleClock=self.titleClock+1
if not self:titleAllowed(self.titleIndex)then
self.titleIndex=1
end
self.titleIndex=self:moveCursor(input,self.titleIndex,3,function(i)return self:titleAllowed(i)end)
if e(input,"a")or e(input,"start")then
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

local function y(ticks,top)
local h=top/c.titleAccel
if ticks<=h then
return c.titleAccel*ticks*ticks/2
end
return top*h/2+top*(ticks-h)
end

function a:draw_title(screen)
self:fill(screen,b.PAPER,0,0,d,n)
self:fill(screen,b.MID,0,74,d,n-74)
self:fill(screen,b.DARK,0,82,d,18)
for h=0,d,16 do
self:fill(screen,b.PAPER,h+(self.titleClock%16),90,8,2)
end
local i=j.light
local t=math.min(4,f(self.titleClock/c.lightTicks)+1)
self:fill(screen,b.INK,0,2,d,1)
screen:layers(self:art("light"),(t-1)*i.frame,i.frame,i.h,6,3,i.shades)
local x=j.logo
self:image(screen,"logo",f((d-x.w)/2)+8,10)
if t==4 then
local C=self.titleClock-3*c.lightTicks
for o=1,c.titleKarts do
local u=m.LIST[(o*2-1)%#m.LIST+1]
local p=j["kart_"..u.id]
local h=p.steps[2]
local s=y(C,c.titleTop-(o-1)*c.titleTopStep)-(o-1)*c.titleGap
local v=s-h.w
if s>=0 then
v=b.mod(s,d+2*h.w)-h.w
end
screen:layers(self:art("kart_"..u.id),h.x+2*h.w,h.w,p.h,f(v),86-p.h+(o%2)*8,p.shades)
end
end
local s={"Title_1P","Title_2P","Title_Options"}
for h,u in ipairs(s)do
local o=38+(h-1)*12
local p=self:titleAllowed(h)and b.INK or b.MID
if h==self.titleIndex then
self:fill(screen,b.INK,40,o,100,12)
p=b.PAPER
end
self:centre(screen,self:say(u),d/2,o-2,p)
end
end

function a:openOptions()
self.screen=a.SCREEN_OPTIONS
end

function a:tick_options(input)
if e(input,"left")or e(input,"right")or e(input,"a")then
self.data.options.music=not self.data.options.music
self:applyMusic()
self:effect(g.TICK)
self:store()
end
if e(input,"b")or e(input,"start")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:draw_options(screen)
self:fill(screen,b.PAPER,0,0,d,n)
self:centre(screen,self:say("Title_Options"),d/2,12,b.INK)
local h=self:say(self.data.options.music and"On"or"Off")
self:centre(screen,self:say("Options_Music"),d/2,46,b.INK)
self:fill(screen,b.INK,50,64,80,16)
self:centre(screen,"< "..h.." >",d/2,64,b.PAPER)
end

function a:openWaiting()
self.screen=a.SCREEN_WAITING
self.twoPlayer=true
self.port:reset()
self.port:forgetMeasure()
self.port:hello()
self.waitClock=0
end

function a:tick_waiting(input)
self.waitClock=self.waitClock+1
if self.waitClock%60==0 then
self.port:hello()
end
if e(input,"b")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:draw_waiting(screen)
self:fill(screen,b.PAPER,0,0,d,n)
self:centre(screen,self:say("WaitingP2"),d/2,52,b.INK)
end

function a:openGuest()
self.screen=a.SCREEN_GUEST
self:cruiseOn("highway")
end

function a:tick_guest(input)
self:cruiseTick()
if self.port:needsPing()then
self.port:ping(self.clock)
end
end

function a:draw_guest(screen)
self:drawCruise(screen,self:cruiseCamera(),40)
self:fill(screen,b.INK,0,52,d,18)
self:centre(screen,self:say("P1Choosing"),d/2,53,b.PAPER)
end

function a:modeAllowed(index)
return not(self.twoPlayer and a.MODES[index]==q.MODE_TT)
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

function a:tick_highway(input)
if self.port:needsPing()and self.twoPlayer then
self.port:ping(self.clock)
end
self:cruiseTick()
if self.cruiseLeaving then
self.signTimer=self.signTimer+1
if self.cruisePath=="exit"and self.cruiseAt>=self.cruiseTrack.paths.exit.loopFrom then
local h=self:modeOf()
if h==q.MODE_GP or h==q.MODE_VS then
self:openCc()
else
self:openMap()
end
end
return
end
self.setup.mode=self:moveCursor(input,self.setup.mode,#a.MODES,function(i)return self:modeAllowed(i)end,"left","right")
if e(input,"a")then
self:effect(g.CONFIRM)
self.cruiseLeaving=true
self.signTimer=0
elseif e(input,"b")then
self:effect(g.BACK)
self:openTitle()
end
end

function a:drawExitSign(screen,top)
local i=j.exit_sign
self:image(screen,"exit_sign",f((d-i.w)/2),top)
local o=screen:wrapText(self:say(a.MODE_KEYS[self.setup.mode]),c.nameWidth)
local h=top+c.nameTop
for p,s in ipairs(o)do
if p<=2 then
self:centre(screen,s,d/2,h,b.PAPER)
h=h+screen:lineHeight()
end
end
self:centre(screen,self:say("Exit").." "..tostring(self.setup.mode),d/2,h+c.exitGap,b.MID)
end

function a:draw_highway(screen)
self:drawCruise(screen,self:cruiseCamera(),120)
local h=j.exit_sign
local i=c.signY
if self.signTimer then
if self.signTimer>=c.signTicks then
return
end
i=c.signY-f((h.h+c.signY)*self.signTimer/c.signTicks)
else
local o=f((d-h.w)/2)
local p=i+f(h.h/2)-f(screen:lineHeight()/2)
self:centre(screen,"<",o-c.arrowGap,p,b.INK)
self:centre(screen,">",o+h.w+c.arrowGap,p,b.INK)
end
self:drawExitSign(screen,i)
end

function a:ccAllowed(index)
return not m.CC[index].mirrored or A.unlocked(self.data,"mirror")
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

function a:tick_cc(input)
self:cruiseTick()
self.setup.cc=self:moveCursor(input,self.setup.cc,#m.CC,function(i)return self:ccAllowed(i)end,"left","right")
if e(input,"a")then
self:effect(g.CONFIRM)
self:openMap()
elseif e(input,"b")then
self:effect(g.BACK)
self:openHighway()
end
end

function a:draw_cc(screen)
self:drawCruise(screen,self:cruiseCamera(),60)
local o=j.speed_sign
local p,i=f((d-o.w)/2),c.signY
self:image(screen,"speed_sign",p,i)
local h=m.CC[self.setup.cc]
if h.mirrored then
self:centre(screen,self:say("Mirror"),d/2,i+c.limitDigitsTop,b.INK)
else
local s=j.limitdigits
local t=-c.limitDigitGap
for u=1,#h.id do
t=t+s.glyphs[string.sub(h.id,u,u)][2]+c.limitDigitGap
end
local u=f((d-t)/2)
for x=1,#h.id do
local v=s.glyphs[string.sub(h.id,x,x)]
screen:sheet(self:art("limitdigits"),v[1],0,v[2],s.h,u,i+c.limitDigitsTop,1,b.INK)
u=u+v[2]+c.limitDigitGap
end
end
local s=i+f(o.h/2)-f(screen:lineHeight()/2)
self:centre(screen,"<",p-c.arrowGap,s,b.INK)
self:centre(screen,">",p+o.w+c.arrowGap,s,b.INK)
end

function a:openPause()
self.paused=true
self.pauseIndex=1
self:effect(g.CONFIRM)
end

function a:tickPause(input)
self.pauseIndex=self:moveCursor(input,self.pauseIndex,3)
if e(input,"start")then
self.paused=false
return
end
if e(input,"a")then
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

function a:drawPause(screen)
self:fill(screen,b.INK,40,30,100,56)
self:fill(screen,b.PAPER,42,32,96,52)
local p={"Pause_Continue","Pause_Restart","Pause_Quit"}
for h,s in ipairs(p)do
local i=34+(h-1)*16
local o=b.INK
if h==self.pauseIndex then
self:fill(screen,b.INK,44,i+1,92,15)
o=b.PAPER
end
self:centre(screen,self:say(s),d/2,i,o)
end
end
