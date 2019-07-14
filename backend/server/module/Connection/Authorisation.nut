class Connection.Authorisation {
    PlayerService = null;

    constructor() {
        PlayerService = Service.PlayerService();
    }

    function login(pid, name, password) {
        local awaitingClient = Client(pid);
        Logger.info("Connection received from " + awaitingClient);

        local player = PlayerService.getPlayerBySerial(awaitingClient.serial);
        if (player == null) {
            Logger.info("Player not found in database");
            local packet = Packet();
            packet.writeUInt8(PackageTypes.PlayerLoginError);
            packet.writeString(
            @"Your user was not found in the database,
             please register");
            packet.send(pid, RELIABLE_ORDERED);
        } else {
            spawnPlayer(pid);
            Logger.info("Player found in database");
            local packet = Packet();
            packet.writeUInt8(PackageTypes.PlayerLoginSuccess);
            packet.writeString(
            @"Success, wait for spawn");
            packet.send(pid, RELIABLE_ORDERED);
            setPlayerPosition(pid, player.pos.x, player.pos.y, player.pos.z);
        }
    }

    function register() {
        if (player == null) {
            Logger.info("New player detected, saving");
            PlayerService.createPlayer(awaitingClient.name, "1", awaitingClient.serial, awaitingClient.macAddress);
        } else {
            Logger.info("Player " + player.name + " was loaded");
            Connections.pid <- player;
            setPlayerPosition(pid, player.pos.x, player.pos.y, player.pos.z);
        }
    }

    function logout(pid) {
        if (isPlayerSpawned(pid)) {
            local player = Connections.pid;
            Logger.info("Disconnecting: " + player);
            local playerPosition = getPlayerPosition(pid);
            PlayerService.savePlayer(player.serial, playerPosition.x, playerPosition.y, playerPosition.z);
        }
        delete Connections.pid;
    }
}