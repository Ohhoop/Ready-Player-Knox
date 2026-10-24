require"SpiffBoy/Core/Core"

SpiffBoy.LinkState=SpiffBoy.LinkState or{}
local a=SpiffBoy.LinkState

local b={}

function a.set(playerNum,peerName,seat,peerId,peerNum)
b[playerNum]={peerName=peerName,seat=seat,peerId=peerId,peerNum=peerNum}
end

function a.clear(playerNum)
b[playerNum]=nil
end

function a.of(playerNum)
return b[playerNum]
end
