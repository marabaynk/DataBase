using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Lab07
{
    class Program
    {
        static void Main(string[] args)
        {

            try
            {
                bool flag = true;

                while (flag)
                {
                    Console.WriteLine("\nМеню:");
                    Console.WriteLine("0. Выход");
                    Console.WriteLine("1. Запросы");
                    Console.WriteLine("2. LINQ to XML");
                    Console.WriteLine("3. LINQ to SQL");
                    Console.Write("Ввод: ");

                    var input = Console.ReadLine();
                    switch (input)
                    {
                        case "0":
                            flag = false;
                            break;
                        case "1":
                            FirstTask first = new FirstTask();
                            break;
                        case "2":
                            SecondTask second = new SecondTask();
                            break;
                        case "3":
                            ThirdTask third = new ThirdTask();
                            break;
                        default:
                            Console.WriteLine("Попробуйте еще раз.");
                            break;
                    }
                }
            }
            catch (Exception ex)
            {

                Console.WriteLine("Ошибка. " + ex.Message);
            }
            Console.ReadKey();
        }

    }
}
