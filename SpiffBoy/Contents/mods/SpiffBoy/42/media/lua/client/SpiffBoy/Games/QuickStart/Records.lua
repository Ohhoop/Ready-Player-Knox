require"SpiffBoy/Games/QuickStart/Base"

local d=SpiffBoy.QuickStart

local b={}
d.Records=b

b.VERSION=1
b.GHOST_PARTS=48

function b.prepare(save)
if type(save.qs)~="table"or save.qs.version~=b.VERSION then
save.qs={version=b.VERSION}
end
local a=save.qs
a.unlocks=type(a.unlocks)=="table"and a.unlocks or{}
a.best=type(a.best)=="table"and a.best or{}
a.ghosts=type(a.ghosts)=="table"and a.ghosts or{}
a.options=type(a.options)=="table"and a.options or{music=true}
a.last=type(a.last)=="table"and a.last or{}
return a
end

function b.best(data,track)
return data.best[track]
end

function b.submit(data,track,driver,ticks,bestLap,parts)
local a=data.best[track]
local c=not a or ticks<a.time
if not a then
a={time=ticks,lap=bestLap,driver=driver}
data.best[track]=a
end
if bestLap<a.lap then
a.lap=bestLap
end
if c then
a.time=ticks
a.driver=driver
if#parts<=b.GHOST_PARTS then
data.ghosts[track]={driver=driver,parts=parts}
else
data.ghosts[track]=nil
end
end
return c
end

function b.ghost(data,track)
return data.ghosts[track]
end

function b.unlocked(data,name)
return data.unlocks[name]==true
end

function b.unlock(data,name)
if data.unlocks[name]then
return false
end
data.unlocks[name]=true
return true
end
