enum FETCH_STYLE {
    ROW,
    ASSOC
}

class Service.MySQL
{
    connection = null;
    result = null;
    constructor()
    {
        connection = mysql_connect(Config.mysql.host, Config.mysql.user, Config.mysql.password, Config.mysql.database);
        if(connection == null || connection == 0)
        {
            throw SQLException("Database Connection could not be extablished");
        }

    }

    function close()
    {
        mysql_free_result(result);
        mysql_close(connection);
    }

    function exec(query)
    {
        result = mysql_query(connection, query);
    }

    function countRows()
    {
        return mysql_num_rows(result);
    }

    function countColumns()
    {
        return mysql_num_fields(result);
    }

    function fetch(style = 0)
    {
        switch (style) 
        {
            case FETCH_STYLE.ASSOC:
                return mysql_fetch_assoc(result);
            break;
            default:
                return mysql_fetch_row(result);
            break;
        }
    }

    function check()
    {
        return mysql_ping(connection);
    }

    function lastErrorMessage()
    {
        return mysql_error(connection);
    }

    function lastErrorId()
    {
        return mysql_errno(connection);
    }
}