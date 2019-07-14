Network.Packages <- [];

Network.Packages.append(Package(PackageTypes.PlayerLoginError, Network.Event.PlayerLoginFailed, function(packet) {
    callEvent(Network.Event.PlayerLoginFailed, packet);
}));

Network.Packages.append(Package(PackageTypes.PlayerLoginSuccess, Network.Event.PlayerLoginSuccess, function(packet) {
    callEvent(Network.Event.PlayerLoginSuccess, packet);
}));