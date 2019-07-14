Network.Packages <- [];

Network.Packages.append(Package(PackageTypes.PlayerLogin, Network.Event.PlayerLoginAttempt, function(pid, packet) {
    callEvent(Network.Event.PlayerLoginAttempt, pid, packet);
}));