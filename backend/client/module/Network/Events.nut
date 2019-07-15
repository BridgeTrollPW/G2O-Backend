Client.Network.Event <- {
    PlayerLoginFailed = "PlayerLoginFailed",
    PlayerLoginSuccess = "PlayerLoginSuccess"
};

foreach (event in Client.Network.Event) {
    addEvent(event);
}

addEventHandler("onPacket", function(packet) {
    Client.Network.PacketDispatcher.checkPacket(packet);
});