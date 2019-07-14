local Authorisation = Connection.Authorisation();
addEventHandler(Network.Event.PlayerLoginAttempt, function(pid, packet) {
    local test = packet.readString();
    Logger.debug(format("Got a Login request for %s", test));
    Authorisation.login(pid, "test", "tset,");
})