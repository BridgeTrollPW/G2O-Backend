Administration <- {}

class Administration.Commands{
    function handleCommand(pid, cmd, params)
    {
        print("test");

        switch(cmd)
        {
            case "playerlist":
            case "list":
                sendMessageToPlayer(pid, 0,0,255, "displaying player message");
                local clientList = ConnectionManager.getClientList();
                foreach(client in clientList) 
                {
                    sendMessageToPlayer(pid, 0,0,255, client.pid + " - " + client.name );
                }
            break;
        }
    }
}