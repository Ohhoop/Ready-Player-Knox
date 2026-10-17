require"SpiffBoy/Games/QuickStart/Base"

local k=SpiffBoy.QuickStart

local b={}
k.Ghost=b

b.PART=128
b.RUN_MAX=60
b.ZERO=48

local l=b.PART
local m=b.RUN_MAX
local c=b.ZERO
local e=string.char
local j=string.byte

function b.recorder()
return{runs={},bits=nil,count=0,ticks=0}
end

function b.record(a,d)
a.ticks=a.ticks+1
if d==a.bits and a.count<m then
a.count=a.count+1
return
end
if a.bits then
a.runs[#a.runs+1]=e(c+a.bits)..e(c+a.count)
end
a.bits,a.count=d,1
end

function b.parts(f)
local g={}
for a,d in ipairs(f.runs)do
g[a]=d
end
if f.bits then
g[#g+1]=e(c+f.bits)..e(c+f.count)
end
local d,a={},{}
local h=0
for n,i in ipairs(g)do
if h+#i>l then
d[#d+1]=table.concat(a)
a,h={},0
end
a[#a+1]=i
h=h+#i
end
if#a>0 then
d[#d+1]=table.concat(a)
end
return d
end

function b.reader(d)
local f=table.concat(d)
local a={data=f,at=1,left=0,bits=0}
function a:next()
while self.left==0 do
if self.at>#self.data then
return 0
end
self.bits=j(self.data,self.at)-c
self.left=j(self.data,self.at+1)-c
self.at=self.at+2
end
self.left=self.left-1
return self.bits
end
return a
end
