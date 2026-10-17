require"SpiffBoy/Games/QuickStart/Base"

local j=SpiffBoy.QuickStart

local b={}
j.Records=b

b.VERSION=1
b.GHOST_PARTS=48

function b.prepare(c)
if type(c.qs)~="table"or c.qs.version~=b.VERSION then
c.qs={version=b.VERSION}
end
local a=c.qs
a.unlocks=type(a.unlocks)=="table"and a.unlocks or{}
a.best=type(a.best)=="table"and a.best or{}
a.ghosts=type(a.ghosts)=="table"and a.ghosts or{}
a.options=type(a.options)=="table"and a.options or{music=true}
a.last=type(a.last)=="table"and a.last or{}
return a
end

function b.best(a,c)
return a.best[c]
end

function b.submit(c,d,e,f,g,h)
local a=c.best[d]
local i=not a or f<a.time
if not a then
a={time=f,lap=g,driver=e}
c.best[d]=a
end
if g<a.lap then
a.lap=g
end
if i then
a.time=f
a.driver=e
if#h<=b.GHOST_PARTS then
c.ghosts[d]={driver=e,parts=h}
else
c.ghosts[d]=nil
end
end
return i
end

function b.ghost(a,c)
return a.ghosts[c]
end

function b.unlocked(a,c)
return a.unlocks[c]==true
end

function b.unlock(a,c)
if a.unlocks[c]then
return false
end
a.unlocks[c]=true
return true
end
