Network.Events = {
    tryPlayerLogin = "tryPlayerLogin"
};

foreach (event in Network.Events) {
    addEvent(event);
}

addEventHandler("onPacket", Network.PacketDispatcher.checkPacket(pid, packet));