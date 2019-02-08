using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace Lab08
{
    class Program
    {
        // Fields
        private static string connectionString = @"Data Source= DESKTOP-QNDK93O;Initial Catalog=MercedesBenz; Integrated Security=True";

        // Main
        static void Main(string[] args)
        {
            Program program = new Program();

            try
            {
                bool flag = true;

                while (flag) {
                    Console.WriteLine("Menu:");
                    Console.WriteLine("0. Exit");
                    Console.WriteLine("Connected:");
                    Console.WriteLine("1. Connection Info");
                    Console.WriteLine("2. Data Reader");
                    Console.WriteLine("3. SqlCommand, Parameters, Select");
                    Console.WriteLine("4. SqlCommand, Parameters, Insert");
                    Console.WriteLine("5. StoredProcedure without parameters");
                    Console.WriteLine("6. StoredProcedure with parameters");
                    Console.WriteLine("Disconnected:");
                    Console.WriteLine("7. DataTableCollection");
                    Console.WriteLine("8. DataTableCollection with filter");
                    Console.WriteLine("9. Delete");
                    Console.WriteLine("10. Insert");
                    Console.WriteLine("11. XML");

                    string input = Console.ReadLine();
                    switch (input) {
                        case "0":
                            flag = false;
                            break;
                        case "1":
                            program.createConnection();
                            break;
                        case "2":
                            program.FirstQuery();
                            break;
                        case "3":
                            program.SecondQuery();
                            break;
                        case "4":
                            program.ThirdQuery();
                            break;
                        case "5":
                            program.FourthQuery();
                            break;
                        case "6":
                            program.FifthQuery();
                            break;
                        case "7":
                            program.SixthQuery();
                            break;
                        case "8":
                            program.SeventhQuery();
                            break;
                        case "9":
                            program.EighthQuery();
                            break;
                        case "10":
                            program.NinthQuery();
                            break;
                        case "11":
                            program.TenQuery();
                            break;
                        default:
                            Console.WriteLine("Try again..");
                            break;
                    }   
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error. Message: " + ex.Message);
            }
        }

        // Methods for lab
        // Connected
        // 1.
        // Create connection, shows info, close connection
        void createConnection()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                Console.WriteLine("Connection has been opened.");
                Console.WriteLine("Connection properties:");
                Console.WriteLine("\tConnection string: {0}", connection.ConnectionString);
                Console.WriteLine("\tDatabase:          {0}", connection.Database);
                Console.WriteLine("\tData Source:       {0}", connection.DataSource);
                Console.WriteLine("\tServer version:    {0}", connection.ServerVersion);
                Console.WriteLine("\tConnection state:  {0}", connection.State);
                Console.WriteLine("\tWorkstation id:    {0}", connection.WorkstationId);
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Connection error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
                Console.WriteLine("Connection has been closed.");
            }
            Console.ReadKey();
        }

        // 2.
        public void FirstQuery()
        {
            const string queryString = @"SELECT COUNT(*) FROM Dealer";

            SqlConnection connection = new SqlConnection(connectionString);

            SqlCommand command = new SqlCommand(queryString, connection);
            try
            {
                connection.Open();
                Console.WriteLine("Number of Dealers equals " + command.ExecuteScalar());
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 3.
        public void SecondQuery()
        {
            const string queryString = @"SELECT  count(CarModel)
                                        FROM Car    
                                        WHERE HorsePower > 400";

            SqlConnection connection = new SqlConnection(connectionString);

            SqlCommand command = new SqlCommand(queryString, connection);
            try
            {
                /*
                connection.Open();
                SqlDataReader dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    Console.WriteLine("CarModel {0};  DateOfIssue: {1};  HorsePower: {2};  IsTransmission: {3};", dataReader.GetValue(0),
                                                                                                         dataReader.GetValue(1),
                                                                                                         dataReader.GetValue(2),
                                                                                                         dataReader.GetValue(3));
                }

                dataReader.Close();
                */
                connection.Open();
                Console.WriteLine(command.ExecuteScalar());
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 4.
        public void ThirdQuery()
        {
            const string maxIDQuery = @"SELECT MAX(id) FROM Dealer";
            const string insertQuery = @"INSERT INTO Dealer(id, City, DealerName, CarAmount)
                                                     VALUES(@id, @dCity, @dDealerName, @dCarAmount)";

            SqlConnection connection = new SqlConnection(connectionString);

            SqlCommand maxIDCommand = new SqlCommand(maxIDQuery, connection);
            SqlCommand insertCommand = new SqlCommand(insertQuery, connection);
            insertCommand.Parameters.Add("@id", SqlDbType.Int);
            insertCommand.Parameters.Add("@dCity", SqlDbType.NVarChar, 255);
            insertCommand.Parameters.Add("@dDealerName", SqlDbType.NVarChar, 255);
            insertCommand.Parameters.Add("@dCarAmount", SqlDbType.Int);
            try
            {
                connection.Open();
                int maxID = Convert.ToInt32(maxIDCommand.ExecuteScalar());

                Console.WriteLine("Enter city: ");
                var dCity = Console.ReadLine();

                Console.WriteLine("Enter dealer name: ");
                var dDealerName = Console.ReadLine();

                Console.WriteLine("Enter car amount: ");
                int dCarAmount = Convert.ToInt32(Console.ReadLine());

                maxID += 1; // Inc ID to be next after max

                insertCommand.Parameters["@id"].Value = maxID;
                insertCommand.Parameters["@dCity"].Value = dCity;
                insertCommand.Parameters["@dDealerName"].Value = dDealerName;
                insertCommand.Parameters["@dCarAmount"].Value = dCarAmount;

                insertCommand.ExecuteNonQuery();
                Console.WriteLine("Insert completed successfully.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 5.
        public void FourthQuery()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();

                SqlCommand command = connection.CreateCommand();
                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "GetTablesList";

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                    Console.WriteLine(dataReader[0].ToString());

                dataReader.Close();
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 6.
        public void FifthQuery()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = connection.CreateCommand();

                command.CommandType = CommandType.StoredProcedure;
                command.CommandText = "GetHPByID";

                SqlParameter inParameter = command.Parameters.Add("@id", SqlDbType.Int);
                inParameter.Direction = ParameterDirection.Input;
                Console.WriteLine("Enter id:");
                int id = Convert.ToInt32(Console.ReadLine());
                inParameter.Value = id;

                SqlParameter outParameter = command.Parameters.Add("@hp", SqlDbType.Int);
                outParameter.Direction = ParameterDirection.Output;

                SqlDataReader dataReader = command.ExecuteReader();

                while (dataReader.Read())
                {
                    Console.WriteLine(dataReader[0].ToString());
                }

                dataReader.Close();

                Console.WriteLine("Car № " + id + " has " + command.Parameters["@hp"].Value + "horse power.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // Disconnected
        // 7.
        public void SixthQuery()
        {
            const string queryString = @"SELECT * FROM Car
                                        WHERE DateOfIssue > '2018-01-09'";
            SqlConnection connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();

                SqlDataAdapter dataAdapter = new SqlDataAdapter(queryString, connection);
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "Car");

                DataTable dataTable = dataSet.Tables["Car"];

                foreach (DataRow row in dataTable.Rows)
                {
                    foreach (DataColumn column in dataTable.Columns)
                    {
                        Console.WriteLine(row[column]);
                    }
                    Console.WriteLine();
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 8.
        public void SeventhQuery()
        {
            const string queryString = @"SELECT * FROM Dealer";
            SqlConnection connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();
                SqlDataAdapter dataAdapter = new SqlDataAdapter();

                dataAdapter.SelectCommand = new SqlCommand(queryString, connection);

                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "Dealer");
                DataTableCollection dataTableCollection = dataSet.Tables;

                string filter = "CarAmount > 100";
                string sort = "CarAmount asc";

                foreach (DataRow row in dataTableCollection["Dealer"].Select(filter, sort))
                {
                    Console.WriteLine(row["DealerName"] + "   " + (row["CarAmount"].ToString()));
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 9.
        public void EighthQuery()
        {
            const string dataQuery = @"SELECT * FROM Dealer";
            const string deleteQuery = @"DELETE FROM Dealer WHERE id = @id";
            SqlConnection connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();
                Console.WriteLine("Enter id of dealer to delete: ");
                int id = Convert.ToInt32(Console.ReadLine());

                SqlDataAdapter dataAdapter = new SqlDataAdapter(new SqlCommand(dataQuery, connection));
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "Dealer");
                DataTable table = dataSet.Tables["Dealer"];

                string filter = "id = " + id;

                foreach (DataRow row in table.Select(filter))
                {
                    row.Delete();
                }

                SqlCommand deleteCommand = new SqlCommand(deleteQuery, connection);
                deleteCommand.Parameters.Add("@id", SqlDbType.Int, 4, "id");
                dataAdapter.DeleteCommand = deleteCommand;
                dataAdapter.Update(dataSet, "Dealer");

                Console.WriteLine("Deleted successfully.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 10.
        public void NinthQuery()
        {
            const string dataQuery = @"SELECT * FROM Dealer";
            const string insertQuery = @"INSERT INTO Dealer(City, DealerName, CarAmount) VALUES (@City, @DealerName, @CarAmount)";
            SqlConnection connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();

                Console.WriteLine("Enter city: ");
                var city = Console.ReadLine();

                Console.WriteLine("Enter dealer name: ");
                var name = Console.ReadLine();

                Console.WriteLine("Enter car amount: ");
                int amount = Convert.ToInt32(Console.ReadLine());

                int id = 102;

                SqlDataAdapter dataAdapter = new SqlDataAdapter(new SqlCommand(dataQuery, connection));
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "Dealer");
                DataTable table = dataSet.Tables["Dealer"];

                DataRow insertingRow = table.NewRow();
                insertingRow["id"] = id;
                insertingRow["City"] = city;
                insertingRow["DealerName"] = name;
                insertingRow["CarAmount"] = amount;

                table.Rows.Add(insertingRow);

                SqlCommand insertQueryCommand = new SqlCommand(insertQuery, connection);
                insertQueryCommand.Parameters.Add("@id", SqlDbType.Int, 4, "id");
                insertQueryCommand.Parameters.Add("@City", SqlDbType.VarChar, 255, "City");
                insertQueryCommand.Parameters.Add("@DealerName", SqlDbType.VarChar, 255, "DealerName");
                insertQueryCommand.Parameters.Add("@CarAmount", SqlDbType.Int, 4, "CarAmount");

                dataAdapter.InsertCommand = insertQueryCommand;
                dataAdapter.Update(dataSet, "Dealer");

                Console.WriteLine("Inserted successfully.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }

        // 11.
        public void TenQuery()
        {
            const string query = "SELECT * FROM Dealer";
            SqlConnection connection = new SqlConnection(connectionString);

            try
            {
                connection.Open();

                SqlDataAdapter dataAdapter = new SqlDataAdapter(query, connection);
                DataSet dataSet = new DataSet();
                dataAdapter.Fill(dataSet, "Dealer");
                DataTable table = dataSet.Tables["Dealer"];

                dataSet.WriteXml("Dealer.xml");
                Console.WriteLine("XML file created successfully.");
            }
            catch (SqlException ex)
            {
                Console.WriteLine("Error! Message: " + ex.Message);
            }
            finally
            {
                connection.Close();
            }
            Console.ReadKey();
        }
    }
}
