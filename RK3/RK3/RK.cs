using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Reflection;

namespace RK3
{
    class RK
    {
        // Connection string to database
        private static string connectionString = @"Data Source= DESKTOP-QNDK93O;Initial Catalog=RK3; Integrated Security=True";

        // 1.1 LINQ Студенты без науч рука
        public void firstLinq()
        {
            DataContext db = new DataContext(connectionString);

            var stud = from s in db.GetTable<Student>()
                               where s.nauchruk == 0
                               select s;

            foreach (var v in stud)
                Console.WriteLine(v.FIO, v.kafedra);
        }

        // 1.2 ADO.NET Студенты без науч рука
        public void firstADO()
        {
            const string queryString = @"select FIO, kafedra 
                                        from student 
                                        where nauchruk = 0";

            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();

            SqlCommand command = new SqlCommand(queryString, connection);

            SqlDataReader dataReader = command.ExecuteReader();
            while (dataReader.Read())
                Console.WriteLine(dataReader[0].ToString());

            dataReader.Close();
            connection.Close();
        }

        // 2.1 LINQ Для студентов без нау рука вывести свободных науч руков
        public void secondLinq()
        {
            DataContext db = new DataContext(connectionString);

            var vacancies = from v in db.GetTable<Vacancy>()
                            join j in db.GetTable<JobSeekers>() on v.id equals j.id
                            where v.specialty.ToString() != j.specialty.ToString()
                            select j.FIO;

            foreach (var vacancy in vacancies)
                Console.WriteLine(vacancy);
        }

        // 2.2 LINQ  Для студентов без нау рука вывести свободных науч руков
        public void secondADO()
        {
            const string queryString = @"SELECT specialty, company
                                        FROM Vacancy
                                        WHERE (SELECT COUNT(*) FROM JobSeekers as J JOIN Vacancy AS V ON J.id = V.id WHERE J.specialty = V.specialty) > 5";

            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();

            SqlCommand command = new SqlCommand(queryString, connection);

            SqlDataReader dataReader = command.ExecuteReader();
            while (dataReader.Read())
                Console.WriteLine(dataReader[0].ToString());

            dataReader.Close();
            connection.Close();
        }


        // 3.1 Преподаватели, у которых не студентов
        public void thirdLinq()
        {
            DataContext db = new DataContext(connectionString);

            var prepods = from v in db.GetTable<Teacher>()
                          where v.studNum == 0
                          select v.FIO;

            foreach (var prepod in prepods)
                Console.WriteLine(prepod);
        }

        // 1.5 Преподаватели, у которых не студентов
        public void thirdADO()
        {
            const string queryString = @"select FIO 
                                         from teacher
                                         where studNum = 0";
            
            SqlConnection connection = new SqlConnection(connectionString);
            connection.Open();

            SqlCommand command = new SqlCommand(queryString, connection);

            SqlDataReader dataReader = command.ExecuteReader();
            while (dataReader.Read())
                Console.WriteLine(dataReader[0].ToString());

            dataReader.Close();
            connection.Close();
        }

        public RK() {
            //firstLinq();
            //firstADO();
            //secondLinq();
            //secondADO();
            thirdLinq();
            thirdADO();
        }
    }
}
