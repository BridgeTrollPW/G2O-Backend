Connection <- {}

class Connection.Dispatcher {
    pid = null;
    connectedClients = {};

    constructor() {}

    function buildClient(pid)
    {
        local temp = Client();
        temp.pid = pid;
        temp.ip = getPlayerIP(pid);
        temp.serial = getPlayerSerial(pid);
        temp.macAddress = getPlayerMacAddr(pid);
        temp.name = getPlayerName(pid);
        return temp;
    }

    // onPlayerJoin(pid) -> Event Callback
    function clientJoin(pid)
    {
        connectedClients.pid <- buildClient(pid);
        sendMessageToAll(0, 255, 0, connectedClients.pid.name + " connected to the server.");
        //local ClientService = Service.ClientService();
        //ClientService.getUserBySerial(connectedClients.serial);
    }

    // onPlayerDisconnect(pid, reason) -> Event Callback
    function clientLeave(pid, reason)
    {
        local client = connectedClients.pid;
        delete connectedClients.pid;
        switch (reason)
        {
	        case DISCONNECTED:
	            sendMessageToAll(255, 0, 0, client.name + " disconnected from the server.");
	        	break;

	        case LOST_CONNECTION:
	        	sendMessageToAll(255, 0, 0, client.name + " lost connection with the server.");
	        	break;

	        case HAS_CRASHED:
	        	sendMessageToAll(255, 0, 0, client.name + " has crashed.");
	        	break;
	    }
    }

    function getClientList()
    {
        return connectedClients;
    }
}