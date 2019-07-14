Network.Event <- {
    PlayerLoginFailed = "PlayerLoginFailed",
    PlayerLoginSuccess = "PlayerLoginSuccess"
};

foreach (event in Network.Event) {
    addEvent(event);
}

addEventHandler("onPacket", function(packet) {
    Network.PacketDispatcher.checkPacket(packet);
});