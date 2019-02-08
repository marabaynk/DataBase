using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data.SqlClient;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Reflection;


namespace Lab07
{
    class ThirdTask
    {
       
        public ThirdTask()
        {
            string connectionString = @"Data Source= DESKTOP-QNDK93O;Initial Catalog=MercedesBenz; Integrated Security=True";
            DataContext db = new DataContext(connectionString);

            // 1.
            Console.WriteLine("\nОднотабличный запрос на выборку.");
            var amounts = from f in db.GetTable<DealersTable>()
                         where f.CarAmount < 300
                         select f;

            Console.WriteLine("Названия дилеров, у которых в наличии <300 автомобилей: ");
           // foreach (var amount in amounts)
               // Console.WriteLine(amount.DealerName);
            Console.WriteLine(amounts.Count());



            // 2.
            Console.WriteLine();
            Console.WriteLine("\nМноготабличный запрос на выборку.");
            var dealers = from d in db.GetTable<DealersTable>()
                       join f in db.GetTable<FactoriesTable>() on d.CarAmount equals f.CarAmount
                       select new { dealername = d.DealerName, amn1 = d.CarAmount, amn2 = f.CarAmount};

            Console.WriteLine("Дилеры,  у которых совпадает количесвто машин с заводом: ");
            foreach (var dealer in dealers)
                Console.WriteLine(dealer);


            // 3.
            Console.WriteLine();
            Console.WriteLine("\nТри запроса на добавление, изменение и удаление данных в базе данных.");
            // Добавление
            Console.WriteLine("Добавление новой записи");
            Console.Write("Введите город дилера:");
            var city = Console.ReadLine();
            Console.Write("Введите название дилера:");
            var dealerName = Console.ReadLine();
            Console.Write("Введите количество машин в наличии у дилера:");
            var carAmount = Convert.ToInt32(Console.ReadLine());

            var IDs = from dealer in db.GetTable<DealersTable>()
                      select dealer.id;

            int maxID = IDs.Max() + 1;

            DealersTable newDealer = new DealersTable()
            {
                id = maxID,
                City = city,
                DealerName = dealerName,
                CarAmount = carAmount
            };
            db.GetTable<DealersTable>().InsertOnSubmit(newDealer);
            Console.WriteLine("Сохранение...");
            db.SubmitChanges();
            Console.WriteLine("Добавление выполенено успешно.");
            Console.ReadKey();
            
            // Изменение
            Console.WriteLine("\n\nИзменение записи в таблице ");
            Console.WriteLine("Введите новое значение города дилера: ");
            var newValue = Console.ReadLine();

            var changeDB = db.GetTable<DealersTable>().Where(p => p.id == 1).FirstOrDefault();
            changeDB.City = newValue;
            Console.WriteLine("Сохранение...");
            db.SubmitChanges();
            Console.WriteLine("Изменение выполенено успешно.");
            Console.ReadKey();
            /*
            // Удаление
            Console.WriteLine("\n\nУдаление записи в таблице ");
            var delDB = db.GetTable<DealersTable>().Where(p => p.id == 50).FirstOrDefault();
            db.GetTable<DealersTable>().DeleteOnSubmit(delDB);
            Console.WriteLine("Сохранение...");
            db.SubmitChanges();
            Console.WriteLine("Удаление выполенено успешно.");

            Console.ReadKey();
            */

            // Получение доступа к данным, выполняя только хранимую процедуру.
            UserDataContext.UserDataContext1 db1 = new UserDataContext.UserDataContext1(connectionString);
            int _firstHP, _secondHP;
            
            Console.WriteLine("Хранимая процедура: ");
            Console.WriteLine("\nВведите HP первого автомобиля:");
            _firstHP = Convert.ToInt32(Console.ReadLine());
            Console.WriteLine("\nВведите HP второго автомобиля:");
            _secondHP = Convert.ToInt32(Console.ReadLine());

            var obj = db1.GetDiffHP(ref _firstHP, ref _secondHP);
            Console.WriteLine($"HP первого автомобиля: {_firstHP}, HP второго автомобиля: {_secondHP}. Их разница составила: " + System.Math.Abs(obj) + " лошадиных сил.");
        }
    }
}
