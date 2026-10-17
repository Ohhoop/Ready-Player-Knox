require"SpiffBoy/Core/Core"

SpiffBoy.Sandbox=SpiffBoy.Sandbox or{}
local a=SpiffBoy.Sandbox

a.LOOT_SCALES={0,0.5,1,2}

local function b()
return SandboxVars.SpiffBoy
end

function a.playingEasesMood()
return b().PlayingEasesMood
end

function a.noiseAttractsZombies()
return b().NoiseAttractsZombies
end

function a.batteriesDrain()
return b().BatteriesDrain
end

function a.dismantling()
return b().Dismantling
end

function a.cartridgeLootScale()
return a.LOOT_SCALES[b().CartridgeLoot]
end

function a.linkCableLootScale()
return a.LOOT_SCALES[b().LinkCableLoot]
end

function a.consoleCartridgeChance()
return b().ConsoleCartridgeChance
end

function a.zombiesCarryCartridges()
return b().ZombiesCarryCartridges
end

function a.othersHearConsole()
return b().OthersHearConsole
end
