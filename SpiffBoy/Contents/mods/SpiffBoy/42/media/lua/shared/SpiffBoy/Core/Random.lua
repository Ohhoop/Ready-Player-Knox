SpiffBoyRandom={}
SpiffBoyRandom.__index=SpiffBoyRandom

SpiffBoyRandom.MODULUS=2147483647

local a=SpiffBoyRandom.MODULUS
local d=16807

function SpiffBoyRandom.new(c)
local b=setmetatable({},SpiffBoyRandom)
b:reseed(c)
return b
end

function SpiffBoyRandom:reseed(b)
if type(b)~="number"then
error("SpiffBoy: a seed is a number, not "..tostring(b))
end
local c=math.floor(math.abs(b))%a
if c==0 then
c=1
end
self.state=c
end

function SpiffBoyRandom:next()
self.state=(d*self.state)%a
return self.state
end

function SpiffBoyRandom:float()
return(self:next()-1)/(a-1)
end

function SpiffBoyRandom:int(b,c)
return b+math.floor(self:float()*(c-b+1))
end

function SpiffBoyRandom:range(b,c)
return b+self:float()*(c-b)
end

function SpiffBoyRandom:chance(b)
return self:float()<b
end
