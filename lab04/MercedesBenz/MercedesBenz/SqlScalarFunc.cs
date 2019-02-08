using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class SqlFunc

{

    [Microsoft.SqlServer.Server.SqlFunction]

    public static SqlInt32 myfunc(SqlInt32 num, SqlInt32 degree)

    {
        int number = num.Value;
        int stp = degree.Value;
        int a = 1;
        while (stp > 0)
        {
            a *= number;
            stp--;
        }
        return a;

    }

}
