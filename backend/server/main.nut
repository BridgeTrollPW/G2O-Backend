addEventHandler("onInit", Startup());


local ConnectionDispatcher = Connection.Dispatcher();

function callbackPlayerJoin(pid)
{
    ConnectionDispatcher.clientJoin(pid);
}

function callbackPlayerDisconnect(pid, reason)
{
    ConnectionDispatcher.clientLeave(pid, reason);
}

addEventHandler("onPlayerJoin", function(pid) {ConnectionDispatcher.clientJoin(pid)});
addEventHandler("onPlayerDisconnect", callbackPlayerDisconnect);


function callbackPlayerCommand(pid, cmd, params)
{
    Administration.Commands.handleCommand(pid, cmd, params);
}
addEventHandler("onPlayerCommand", callbackPlayerCommand);