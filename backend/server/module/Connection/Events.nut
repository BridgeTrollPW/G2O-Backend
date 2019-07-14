local Authorisation = Connection.Authorisation();
addEventHandler(Network.Events.tryPlayerLogin, function(pid, packet) {
    Authorisation.login(pid, "test", "tset,");
    local test = packet.readString();
    Logger.debug(format("Got a Login request for %s", test));
})