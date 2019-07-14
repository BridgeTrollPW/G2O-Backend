class Network.PacketDispatcher {
    function checkPacket(packet) {
        local id = packet.readUInt8();
        foreach (package in Network.Packages) {
            if (id == package.id) {
                package.callback(packet);
                break;
            }
        }
    }
}