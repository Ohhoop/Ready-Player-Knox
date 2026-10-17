require"SpiffBoy/Core/Core"

SpiffBoy.Links=SpiffBoy.Links or{}
local a=SpiffBoy.Links

a.registry=nil

function a.install(b)
a.registry=b
end

function a.connect(b,c,d,e)
a.registry.connect(b,c,d,e)
end

function a.disconnect(b,c)
a.registry.disconnect(b,c)
end
