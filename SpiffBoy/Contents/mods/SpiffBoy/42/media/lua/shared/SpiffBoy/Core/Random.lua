SpiffBoyRandom={}
SpiffBoyRandom.__index=SpiffBoyRandom

SpiffBoyRandom.MODULUS=2147483647

local a=SpiffBoyRandom.MODULUS
local c=16807

function SpiffBoyRandom.new(seed)
local b=setmetatable({},SpiffBoyRandom)
b:reseed(seed)
return b
end

function SpiffBoyRandom:reseed(seed)
if type(seed)~="number"then
error("SpiffBoy: a seed is a number, not "..tostring(seed))
end
local b=math.floor(math.abs(seed))%a
if b==0 then
b=1
end
self.state=b
end

function SpiffBoyRandom:next()
self.state=(c*self.state)%a
return self.state
end

function SpiffBoyRandom:float()
return(self:next()-1)/(a-1)
end

function SpiffBoyRandom:int(low,high)
return low+math.floor(self:float()*(high-low+1))
end

function SpiffBoyRandom:range(low,high)
return low+self:float()*(high-low)
end

function SpiffBoyRandom:chance(probability)
return self:float()<probability
end
