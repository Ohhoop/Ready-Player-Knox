require"SpiffBoy/Games/QuickStart/Base"

local d=SpiffBoy.QuickStart

local a={}
d.Roster=a

a.CLASSES={
light={top=98,accel=130,turn=105,weight=1,offroad=112},
medium={top=100,accel=100,turn=100,weight=2,offroad=100},
heavy={top=103,accel=80,turn=92,weight=3,offroad=92},
handling={top=99,accel=105,turn=125,weight=2,offroad=100},
}

a.LIST={
{id="kate",class="light",portrait=2},
{id="fitness",class="light",portrait=3},
{id="baldspot",class="medium",portrait=4},
{id="worker",class="medium",portrait=5},
{id="firefighter",class="heavy",portrait=6},
{id="shambler",class="heavy",portrait=7},
{id="spiffo",class="handling",portrait=1},
{id="sprinter",class="handling",portrait=8},
}

a.CC={
{id="50",top=320,ai=88},
{id="100",top=395,ai=94},
{id="150",top=470,ai=100},
{id="mirror",top=470,ai=100,mirrored=true},
}

function a.statsOf(b)
local c=a.LIST[b]
if not c then
error("QuickStart: no driver "..tostring(b))
end
return a.CLASSES[c.class]
end

function a.artOf(b)
return"kart_"..a.LIST[b].id
end
