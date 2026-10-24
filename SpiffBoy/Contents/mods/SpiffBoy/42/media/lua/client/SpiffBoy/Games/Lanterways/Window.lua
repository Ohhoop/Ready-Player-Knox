require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways

local a={}
b.Window=a

local d={1}
local i={1,2,3}

a.UI_HEIGHT=16
a.CELLS={
flame1={0,6},flame2={6,6},corner={12,7},
attack={19,14},skill={33,14},item={47,14},guard={61,14},run={75,14},
arrowUp={89,7},arrowDown={96,7},arrowLeft={103,7},arrowRight={110,7},
heart={117,11},bang={128,9},ask={137,9},dots={146,9},note={155,9},
coin={164,8},lampIcon={172,11},bell={183,9},glow={192,10},target={202,9},
statusBlind={211,8},statusSleep={219,8},statusSoot={227,8},statusStun={235,8},
statusUp={243,8},statusDown={251,8},statusRegen={259,8},statusVeil={267,8},statusTaunt={275,8},
elemFlame={283,8},elemSound={291,8},elemMurk={299,8},xp={307,7},
heartSmall={314,7},lampSmall={321,7},slash={328,4},
}
a.ELEMENT_ICONS={flame="elemFlame",sound="elemSound",murk="elemMurk"}

function a.gearIcon(item)
if item.element then
return a.ELEMENT_ICONS[item.element]
elseif item.ward then
return a.ELEMENT_ICONS[item.ward]
elseif item.guard then
return"status"..string.upper(string.sub(item.guard,1,1))..string.sub(item.guard,2)
end
return nil
end
a.LINE=16

function a.text(screen,label,x,y,shade)
local c,e,f=b.shade(shade or b.INK)
screen:text(label,x,y,c,e,f,1)
end

function a.textCentre(screen,label,x,y,shade)
local c,e,f=b.shade(shade or b.INK)
screen:textCentre(label,x,y,c,e,f,1)
end

function a.textRight(screen,label,x,y,shade)
local c,e,f=b.shade(shade or b.INK)
screen:textRight(label,x,y,c,e,f,1)
end

function a.fill(screen,x,y,w,h,shade)
local c,e,f=b.shade(shade)
screen:rect(x,y,w,h,c,e,f,1)
end

function a.icon(screen,ui,name,x,y,shades)
local c=a.CELLS[name]
screen:layers(ui,c[1],c[2],a.UI_HEIGHT,x,y,shades)
end

function a.frame(screen,ui,x,y,w,h)
a.fill(screen,x,y,w,h,b.INK)
a.fill(screen,x+1,y+1,w-2,h-2,b.PAPER)
a.fill(screen,x+2,y+h-3,w-4,1,b.MID)
a.fill(screen,x+2,y+2,1,h-5,b.MID)
if ui then
a.icon(screen,ui,"corner",x-2,y-3,d)
a.icon(screen,ui,"corner",x+w-5,y-3,d)
end
end

function a.cursor(screen,ui,x,y,clock)
if math.floor(clock/8)%2==0 then
a.icon(screen,ui,"flame1",x,y,i)
else
a.icon(screen,ui,"flame2",x,y,i)
end
end

function a.scroll(selected,top,visible,count)
if selected<top then
top=selected
elseif selected>top+visible-1 then
top=selected-visible+1
end
return SpiffBoy.clamp(top,1,math.max(1,count-visible+1))
end

function a.list(screen,ui,rows,x,y,w,visible,selected,top,clock,focused)
local j=#rows
for g=0,visible-1 do
local c=rows[top+g]
if c then
local e=y+g*a.LINE
local f=b.INK
if c.disabled then
f=b.MID
end
if top+g==selected and focused then
a.fill(screen,x+8,e+1,w-10,a.LINE-2,b.MID)
if c.disabled then
f=b.DARK
end
a.cursor(screen,ui,x,e+4,clock)
end
local h=w-12
if c.right then
h=h-screen:textWidth(c.right)-4
a.textRight(screen,c.right,x+w-2,e,f)
end
a.text(screen,a.fit(screen,c.label,h),x+10,e,f)
end
end
if top>1 then
a.icon(screen,ui,"arrowUp",x+w-8,y-6,d)
end
if top+visible-1<j then
a.icon(screen,ui,"arrowDown",x+w-8,y+visible*a.LINE-2,d)
end
end

function a.fit(screen,label,width)
if screen:textWidth(label)<=width then
return label
end
local c=screen:wrapText(label,width-8)
return(c[1]or"").."."
end
