class PlayerChat.Dispatcher
{
    function localChat(pid, message)
    {
        local sender_pos = getPlayerPosition(pid);

        for (local i = 0; i < getMaxSlots(); ++i)
        {
            if (isPlayerConnected(i) && isPlayerSpawned(i))
            {
                local pos = getPlayerPosition(i);

                if (getDistance3d(sender_pos.x, sender_pos.y, sender_pos.z, pos.x, pos.y, pos.z) <= Config.modules.PlayerChat.DISTANCE)
                {
                    sendPlayerMessageToPlayer(pid, i, 255, 255, 255, message);
                }
            }
        }
    }
}