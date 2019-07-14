Network.Event <- {
    PlayerLoginAttempt = "PlayerLoginAttempt"
};

foreach (event in Network.Event) {
    addEvent(event);
}

addEventHandler("onPacket", function(pid, packet) {
    Network.PacketDispatcher.checkPacket(pid, packet);
});