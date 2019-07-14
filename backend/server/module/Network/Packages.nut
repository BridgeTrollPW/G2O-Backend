Network.Packages <- [];

Network.Packages.append(Package(PackageTypes.Login, Network.Events.tryPlayerLogin, function(pid, packet) {
    callEvent(Network.Events.tryPlayerLogin, pid, packet);
}));