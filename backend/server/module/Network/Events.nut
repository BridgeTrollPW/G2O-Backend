Network.Events <- {
    tryPlayerLogin = "tryPlayerLogin"
};

foreach (event in Network.Events) {
    addEvent(event);
}

addEventHandler("onPacket", function(pid, packet) {
    Network.PacketDispatcher.checkPacket(pid, packet);
});