class Connection.Dispatcher {
    auth = null;
    constructor() {
        auth = Connection.Authorisation();
    }

    function buildClient(pid) {
        local temp = Client();
        temp.pid = pid;
        temp.ip = getPlayerIP(pid);
        temp.serial = getPlayerSerial(pid);
        temp.macAddress = getPlayerMacAddr(pid);
        temp.name = getPlayerName(pid);
        return temp;
    }

// onPlayerJoin(pid) -> Event Callback
    function login(pid) {
        //auth.login(pid);
    }

// onPlayerDisconnect(pid, reason) -> Event Callback
    function clientLeave(pid, reason) {
        local player = Connections.pid;
        auth.logout(pid);
        switch (reason) {
            case DISCONNECTED:
                sendMessageToAll(255, 0, 0, player.name + " disconnected from the server.");
                break;

            case LOST_CONNECTION:
                sendMessageToAll(255, 0, 0, player.name + " lost connection with the server.");
                break;

            case HAS_CRASHED:
                sendMessageToAll(255, 0, 0, player.name + " has crashed.");
                break;
        }
    }

    function getClientList() {
        return Connections;
    }
}