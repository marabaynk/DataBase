using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;



public partial class StoredProcedures
{
    [Microsoft.SqlServer.Server.SqlProcedure]
    public static void AvgCarNum(string Car_Model)
    {
        using (SqlConnection contextConnection = new SqlConnection("context connection = true"))
        {

            SqlCommand contextCommand =

               new SqlCommand(

               "Select AVG(HorsePower) from Car " +

               "where CarModel = @name", contextConnection);



            contextCommand.Parameters.AddWithValue("@name", Car_Model);

            contextConnection.Open();



            SqlContext.Pipe.ExecuteAndSend(contextCommand);

        }



    }

}