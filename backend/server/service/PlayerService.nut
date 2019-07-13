class Service.PlayerService {

    function getPlayerBySerial(serial) {
        local db = Service.MySQL();
        db.exec("CALL getPlayerBySerial('" + serial + "');");
        local result = db.fetch(FETCH_STYLE.ASSOC);
        db.close();
        if (db.countRows() == 1) {
            local player = Player();

            player.id = result.id;
            player.name = result.name;
            player.serial = result.serial;
            player.pos.x = result.pos_x;
            player.pos.y = result.pos_y;
            player.pos.z = result.pos_z;

            Logger.debug("CHECK SERIAL" + player);
            return player;
        } else {
            return null;
        }
    }

    function createPlayer(name, password, serial, macAddress) {
        local db = Service.MySQL();
        db.exec("CALL createPlayer('" + name + "', '" + password + "', '" + serial + "', '" + macAddress + "');");
        local result = db.fetch(FETCH_STYLE.ASSOC);
        db.close();
        if (db.countRows() == 1 && result.serial == serial) {
            local player = Player();

            player.id = result.id;
            player.name = result.name;
            player.serial = result.serial;
            player.pos.x = result.pos_x;
            player.pos.y = result.pos_y;
            player.pos.z = result.pos_z;

            Logger.debug("CREATE / INSERT" + player);
            return player;
        }
        throw AuthException("Player " + serial + " was not successfully created after registration");
    }

    function savePlayer(serial, x, y, z) {
        local db = Service.MySQL();
        db.exec("CALL savePlayer('" + serial + "', '" + x + "', '" + y + "', '" + z + "');");
        local result = db.fetch(FETCH_STYLE.ASSOC);
        db.close();

        if (db.countRows() == 1 && result.serial == serial) {
            local player = Player();

            player.id = result.id;
            player.name = result.name;
            player.serial = result.serial;
            player.pos.x = result.pos_x;
            player.pos.y = result.pos_y;
            player.pos.z = result.pos_z;

            Logger.debug("RELOAD/SAVE: " + player);
            return player;
        }
        throw AuthException("Player " + serial + " was not successfully saved after logout");
    }
}