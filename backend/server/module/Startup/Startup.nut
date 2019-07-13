class Startup
{
    constructor() {
        Logger.info("Startup is doing preloader/config stuff");

        local DatabaseConnection = Service.MySQL();
        local connected = DatabaseConnection.check();
        if(!connected)
        {

        } else
        {
            Logger.info("Database connection successful");
        }
    }
}