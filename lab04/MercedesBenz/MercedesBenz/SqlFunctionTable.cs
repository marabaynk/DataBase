using System;
using System.Collections;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(FillRowMethodName = "FillRow",
           TableDefinition = "charpart nchar(1), intpart int")]
    public static IEnumerable TableFunction(string input)
    {
        yield return new NameRow(input, input.Length);
    }

    public static void FillRow(object row, out SqlString word, out int len)
    {
        word = ((NameRow)row).word;
        len = ((NameRow)row).length;
    }

    public class NameRow
    {
        public SqlString word;
        public Int32 length;

        public NameRow(SqlString c, Int32 i)
        {
            word = c;
            length = i;
        }
    }
}
