class Client {
    pid = null;
    ip = null;
    serial = null;
    macAddress = null;
    name = null;

    constructor(playerId) {
        pid = playerId;
        ip = getPlayerIP(pid);
        serial = getPlayerSerial(pid);
        macAddress = getPlayerMacAddr(pid);
        name = getPlayerName(pid);
    }
    function _tostring()
    {
        return "Client: " + format("pid: %d, ip: %s, serial: %s, macAddr: %s", pid, ip, serial, macAddress);
    }
}
