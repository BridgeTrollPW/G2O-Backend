class AuthException extends Exception
{
    constructor(msg, c = 0)
    {
        base.constructor("AuthException", msg, c);
    }
}