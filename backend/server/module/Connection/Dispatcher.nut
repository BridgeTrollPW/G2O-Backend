Connections <- {}

class Connection.Dispatcher {
    auth = null;
    constructor() {
        auth = Connection.Authorisation();
    }

    function buildClient(pid) {
        local temp = Client(pid);
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
        Connections.pid <- Client(pid);
    }

// onPlayerDisconnect(pid, reason) -> Event Callback
    function clientLeave(pid, reason) {
        local client = Connections.pid;
        auth.logout(pid);
        sendMessageToAll(255, 0, 0, client.name + " disconnected from the server.");
        switch (reason) {
            case DISCONNECTED:
                Logger.info(format("Player %s disconnected", client.serial));
                break;

            case LOST_CONNECTION:
                Logger.info(format("Player %s lost connection", client.serial));
                break;

            case HAS_CRASHED:
                Logger.info(format("Player %s crashed", client.serial));
                break;
        }
    }

    function getClientList() {
        return Connections;
    }
}