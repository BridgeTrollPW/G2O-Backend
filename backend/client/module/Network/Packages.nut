Client.Network.Packages <- [];

Client.Network.Packages.append(Package(PackageTypes.PlayerLoginError, Client.Network.Event.PlayerLoginFailed, function(packet) {
    callEvent(Client.Network.Event.PlayerLoginFailed, packet);
}));

Client.Network.Packages.append(Package(PackageTypes.PlayerLoginSuccess, Client.Network.Event.PlayerLoginSuccess, function(packet) {
    callEvent(Client.Network.Event.PlayerLoginSuccess, packet);
}));