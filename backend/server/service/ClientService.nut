Service <- {}

class Service.ClientService{
    db = null;
    constructor()
    {
        db = Service.MySQL();
    }

    function getUserBySerial(serial)
    {
        db.exec("CALL getUserBySerial()");
        local resultSet = db.fetch(FETCH_STYLE.ROW);
        print(resultSet);
    }
}