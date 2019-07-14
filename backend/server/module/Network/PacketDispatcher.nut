class Network.PacketDispatcher {
    function checkPacket(pid, packet) {
        Logger.debug(format("Received Networkpackage by %s", getPlayerSerial(pid)));
        local id = packet.readUInt8();
        foreach (package in Network.Packages) {
            if (id == package.id) {
                Logger.debug(format("[%s] has sent %s", getPlayerSerial(pid), package.name));
                package.callback(pid, packet);
                break;
            }
        }
    }
}