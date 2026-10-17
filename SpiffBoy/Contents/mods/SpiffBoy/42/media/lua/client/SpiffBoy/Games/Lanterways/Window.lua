require"SpiffBoy/Games/Lanterways/Base"

local b=SpiffBoy.Lanterways

local a={}
b.Window=a

local g={1}
local p={1,2,3}

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

function a.gearIcon(c)
if c.element then
return a.ELEMENT_ICONS[c.element]
elseif c.ward then
return a.ELEMENT_ICONS[c.ward]
elseif c.guard then
return"status"..string.upper(string.sub(c.guard,1,1))..string.sub(c.guard,2)
end
return nil
end
a.LINE=16

function a.text(c,d,e,f,h)
local i,j,k=b.shade(h or b.INK)
c:text(d,e,f,i,j,k,1)
end

function a.textCentre(c,d,e,f,h)
local i,j,k=b.shade(h or b.INK)
c:textCentre(d,e,f,i,j,k,1)
end

function a.textRight(c,d,e,f,h)
local i,j,k=b.shade(h or b.INK)
c:textRight(d,e,f,i,j,k,1)
end

function a.fill(c,d,e,f,h,i)
local j,k,l=b.shade(i)
c:rect(d,e,f,h,j,k,l,1)
end

function a.icon(d,e,f,h,i,j)
local c=a.CELLS[f]
d:layers(e,c[1],c[2],a.UI_HEIGHT,h,i,j)
end

function a.frame(c,i,d,e,f,h)
a.fill(c,d,e,f,h,b.INK)
a.fill(c,d+1,e+1,f-2,h-2,b.PAPER)
a.fill(c,d+2,e+h-3,f-4,1,b.MID)
a.fill(c,d+2,e+2,1,h-5,b.MID)
if i then
a.icon(c,i,"corner",d-2,e-3,g)
a.icon(c,i,"corner",d+f-5,e-3,g)
end
end

function a.cursor(c,d,e,f,h)
if math.floor(h/8)%2==0 then
a.icon(c,d,"flame1",e,f,p)
else
a.icon(c,d,"flame2",e,f,p)
end
end

function a.scroll(d,c,e,f)
if d<c then
c=d
elseif d>c+e-1 then
c=d-e+1
end
return SpiffBoy.clamp(c,1,math.max(1,f-e+1))
end

function a.list(c,k,q,e,l,f,m,r,h,s,t)
local u=#q
for n=0,m-1 do
local d=q[h+n]
if d then
local i=l+n*a.LINE
local j=b.INK
if d.disabled then
j=b.MID
end
if h+n==r and t then
a.fill(c,e+8,i+1,f-10,a.LINE-2,b.MID)
if d.disabled then
j=b.DARK
end
a.cursor(c,k,e,i+4,s)
end
local o=f-12
if d.right then
o=o-c:textWidth(d.right)-4
a.textRight(c,d.right,e+f-2,i,j)
end
a.text(c,a.fit(c,d.label,o),e+10,i,j)
end
end
if h>1 then
a.icon(c,k,"arrowUp",e+f-8,l-6,g)
end
if h+m-1<u then
a.icon(c,k,"arrowDown",e+f-8,l+m*a.LINE-2,g)
end
end

function a.fit(d,c,e)
if d:textWidth(c)<=e then
return c
end
local f=d:wrapText(c,e-8)
return(f[1]or"").."."
end
