require"SpiffBoy/Games/QuickStart/Base"

local j=SpiffBoy.QuickStart

local a={}
j.Ghost=a

a.PART=128
a.RUN_MAX=60
a.ZERO=48

local k=a.PART
local l=a.RUN_MAX
local b=a.ZERO
local e=string.char
local i=string.byte

function a.recorder()
return{runs={},bits=nil,count=0,ticks=0}
end

function a.record(recorder,bits)
recorder.ticks=recorder.ticks+1
if bits==recorder.bits and recorder.count<l then
recorder.count=recorder.count+1
return
end
if recorder.bits then
recorder.runs[#recorder.runs+1]=e(b+recorder.bits)..e(b+recorder.count)
end
recorder.bits,recorder.count=bits,1
end

function a.parts(recorder)
local f={}
for c,d in ipairs(recorder.runs)do
f[c]=d
end
if recorder.bits then
f[#f+1]=e(b+recorder.bits)..e(b+recorder.count)
end
local d,c={},{}
local g=0
for m,h in ipairs(f)do
if g+#h>k then
d[#d+1]=table.concat(c)
c,g={},0
end
c[#c+1]=h
g=g+#h
end
if#c>0 then
d[#d+1]=table.concat(c)
end
return d
end

function a.reader(parts)
local d=table.concat(parts)
local c={data=d,at=1,left=0,bits=0}
function c:next()
while self.left==0 do
if self.at>#self.data then
return 0
end
self.bits=i(self.data,self.at)-b
self.left=i(self.data,self.at+1)-b
self.at=self.at+2
end
self.left=self.left-1
return self.bits
end
return c
end
