require"SpiffBoy/Core/Core"

SpiffBoy.Links=SpiffBoy.Links or{}
local a=SpiffBoy.Links

a.registry=nil

function a.install(registry)
a.registry=registry
end

function a.connect(character,console,peerId,peerNum)
a.registry.connect(character,console,peerId,peerNum)
end

function a.disconnect(character,console)
a.registry.disconnect(character,console)
end
