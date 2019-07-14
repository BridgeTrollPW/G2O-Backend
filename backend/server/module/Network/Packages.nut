Network.Packages <- [];

Network.Packages.append(Package(PackageType.Login, Network.Events.tryPlayerLogin, function(pid, packet) {
    callEvent(Network.Events.tryPlayerLogin, pid, packet);
}));