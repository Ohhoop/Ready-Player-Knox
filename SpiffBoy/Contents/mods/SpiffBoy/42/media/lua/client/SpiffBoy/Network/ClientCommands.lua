require"SpiffBoy/Core/Core"
require"SpiffBoy/Core/Commands"
require"SpiffBoy/Network/RemoteSpeakers"
require"SpiffBoy/Link/NetworkLink"

SpiffBoy.Commands.fromServer(SpiffBoy.COMMAND_CHIP,SpiffBoy.RemoteSpeakers.handle)

Events.OnServerCommand.Add(SpiffBoy.Commands.onServerCommand)
