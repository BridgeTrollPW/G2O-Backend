class Logger
{
    function timestamp()
    {
        local dateTime = date();
        return "[" +dateTime.day + "." + dateTime.month + "." + dateTime.year + " - " +dateTime.hour + ":" + dateTime.min + ":" + dateTime.sec + "]";

    }

    function info(msg)
    {
        print(timestamp() + " [INFO] " + msg);
    }

    function debug(msg)
    {
        print(timestamp() + " [DEBUG] " + msg);
    }

    function error(msg)
    {
        error(timestamp() + " [ERROR] " + msg);
    }
}