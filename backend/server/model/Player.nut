class Player {
    id = null;
    name = null;
    serial = null;
    pos = {
        x = null,
        y = null,
        z = null,
    }

    function _tostring() {
        return "Player Object: " + format("id:%d name:%s serial:%s pos x,y,z: %d,%d,%d", id, name, serial, pos.x, pos.y, pos.z);
    }
}