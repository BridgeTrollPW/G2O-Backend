class SQLException extends Exception
{
    constructor(msg, c = 0)
    {
        base.constructor("SQLException", msg, c);
    }
}