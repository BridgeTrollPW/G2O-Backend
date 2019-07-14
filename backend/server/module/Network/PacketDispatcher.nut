class Network.PacketDispatcher
{
    function checkPacket(pid, packet)
    {
        Logger.debug(format("Received Networkpackage by %s", Connections.pid.serial));
        local id = packet.ReadUInt8();
        foreach(package in Network.Packages)
        {
            if(id == package.id)
            {
                Logger.debug(format("[%s] has sent %s", Connections.pid.serial, package.name));
                package.callback(pid, packet);
                break;
            }
        }
    }
}