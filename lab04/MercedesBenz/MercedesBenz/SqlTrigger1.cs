using System;
using System.Data;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public partial class Triggers
{
    public static void SqlTrigger1()
    {
        SqlTriggerContext triggerContext = SqlContext.TriggerContext;

        if (triggerContext.TriggerAction == TriggerAction.Delete)
            SqlContext.Pipe.Send("Failed! Deletion is aborted.");

        if (triggerContext.TriggerAction == TriggerAction.Insert)
            SqlContext.Pipe.Send("Error!Not insert");
    }
}

