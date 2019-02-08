using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Lab07
{
    class Cars
    {
        public string CarModel { get; set; }
        //public System.DateTime DateOfIssue { get; set; }
        public int HorsePower { get; set; }
        public int isTransmission { get; set; }
    }

    class Dealers
    {
        public string City { get; set; }
        public string DealerName { get; set; }
        public int CarAmount { get; set; }
    }

    class FirstTask
    {
        public FirstTask()
        {
            IList<Cars> carsList = new List<Cars>
            {
                new Cars() { CarModel="E-Classe", HorsePower=555, isTransmission = 1 },
                new Cars() { CarModel="A-Classe", HorsePower=654, isTransmission = 1 },
                new Cars() { CarModel="GLS-Classe", HorsePower=344, isTransmission = 0 },
                new Cars() { CarModel="S-Classe", HorsePower=263, isTransmission = 1 },
                new Cars() { CarModel="E-Classe", HorsePower=453, isTransmission = 0 }
            };

            IList<Dealers> dealersList = new List<Dealers>
            {
                new Dealers() { City="Moscow", DealerName="Avilon", CarAmount=35 },
                new Dealers() { City="Yerevan", DealerName="AMG", CarAmount=234 },
                new Dealers() { City="Ufa", DealerName="Panavto", CarAmount=162 },
                new Dealers() { City="Sochi", DealerName="AMG", CarAmount=358 },
                new Dealers() { City="Tula", DealerName="Izmaylovo", CarAmount=97 }
            };

            // Вывод всех значений
            foreach (var i in carsList)
                Console.WriteLine(i.CarModel + " | " + i.HorsePower + " | " + i.isTransmission);


            Console.WriteLine();
            // 1. Запрос: модели больше 400
            Console.WriteLine("1. Запрос: ");
            var _1result = from c in carsList
                           let minHP = 400
                           where c.HorsePower > minHP
                           select c.CarModel;

            foreach (var i in _1result)
                Console.WriteLine(i);

            Console.WriteLine();
            // 2. Запрос: E-classe и сортировка по трансмиссии 
            Console.WriteLine("2. Запрос: ");
            var _2result = from c in carsList
                               where c.CarModel == "E-Classe"
                           orderby c.isTransmission descending
                               select $"HP is {c.HorsePower}";
                               
            foreach (var i in _2result)
                Console.WriteLine(i);

            Console.WriteLine();
            // 3. Запрос ofType Cars - HP
            Console.WriteLine("3. Запрос: ");
            var _3result = from c in carsList.OfType<Cars>()
                              select c.HorsePower;

            foreach (var i in _3result)
                Console.WriteLine(i);

            Console.WriteLine();
            // 4. Запрос oderby HP thenby isTransmission
            
            Console.WriteLine("4. Запрос: ");
            var _4result = from c in carsList
                               orderby c.HorsePower, c.isTransmission
                               select c;

            foreach (var i in _4result)
                Console.WriteLine(i.HorsePower + " - " + i.isTransmission);


            Console.WriteLine();
            // 5. Запрос ofType HP
            Console.WriteLine("5. Запрос: ");
            var _5result = from c in carsList
                           group c by c.HorsePower into hpGroup
                           select new { first = hpGroup.Key, words = hpGroup.Count() };

            foreach (var item in _5result)
                Console.WriteLine("{0} имеет {1} элементов", item.first, item.words);


            Console.WriteLine();
            // 6. Запрос ofType Cars - Dealer
            Console.WriteLine("6. Запрос: ");
            var _6result = from c in carsList
                           select new { carname = c.CarModel, carhp = c.HorsePower };


            foreach (var item in _6result)
                Console.WriteLine("{0} автомобиль имеет {1} лошадиных сил", item.carname, item.carhp);
        }
    }
}
