addEventHandler("onInit", Startup());

local ConnectionDispatcher = Connection.Dispatcher();

addEventHandler("onPlayerJoin", function(pid) {
    ConnectionDispatcher.clientJoin(pid);
    spawnPlayer(pid);
});
addEventHandler("onPlayerDisconnect", function(pid, reason) {
    ConnectionDispatcher.clientLeave(pid, reason);
});

addEventHandler("onPlayerCommand", function (pid, cmd, params) {
    Administration.Commands.handleCommand(pid, cmd, params);
});

addEventHandler("onPlayerMessage", function (pid, msg) {
    PlayerChat.Dispatcher.localChat(pid, msg);
});