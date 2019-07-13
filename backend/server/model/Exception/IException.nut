class Exception
{
    constructor(exceptionClass, msg, c = 0)
    {
        local dateTime = date();
        local stamp = dateTime.day + "." + dateTime.month + "." + dateTime.year + " - " +dateTime.hour + ":" + dateTime.min + ":" + dateTime.sec;
        error("["+stamp+"] [" + exceptionClass + "]: " + msg + " code: " + c);
    }
}