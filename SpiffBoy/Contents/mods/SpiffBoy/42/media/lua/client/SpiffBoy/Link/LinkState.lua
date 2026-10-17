require"SpiffBoy/Core/Core"

SpiffBoy.LinkState=SpiffBoy.LinkState or{}
local a=SpiffBoy.LinkState

local b={}

function a.set(c,d,e,f,g)
b[c]={peerName=d,seat=e,peerId=f,peerNum=g}
end

function a.clear(c)
b[c]=nil
end

function a.of(c)
return b[c]
end
