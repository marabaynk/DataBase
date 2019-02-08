using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml;
using System.Xml.Linq;


namespace Lab07
{
    class SecondTask
    {
        private XDocument xdoc = XDocument.Load("Dealers.xml");

        public void readFromXML()
        {
            foreach (XElement element in xdoc.Elements("Rows").Elements("row"))
            {
                XElement dilerNumberElement = element.Element("DealerNumber");
                XElement CityElement = element.Element("City");
                XElement DealerNameElement = element.Element("DealerName");
                XElement CarAmountElement = element.Element("CarAmount");

                Console.WriteLine("Номер дилера: " + dilerNumberElement.Value);
                Console.WriteLine("Город дилера: " + CityElement.Value);
                Console.WriteLine("Название дилера: " + DealerNameElement.Value);
                Console.WriteLine("Количество машин в наличии: " + CarAmountElement.Value);
                Console.WriteLine();
            }
        }

        public void updateXML()
        {
            var root = xdoc.Elements("Rows");

            Console.WriteLine("\nВведите номер дилера для изменения: ");
            var elementID = Console.ReadLine();

            Console.WriteLine("\nВведите название элемента для изменения: ");
            var elementTag= Console.ReadLine();

            Console.WriteLine("\nВведите новое значение для элемента: ");
            var newElementValue = Console.ReadLine();
            //xe.Remove();
            foreach (XElement xe in root.Elements("row").ToList())
            {
                if (xe.Element("DealerNumber").Value == elementID)
                {
                    xe.Element(elementTag).Value = newElementValue;
                }
            }
            xdoc.Save("DealersUpdated.xml");
        }

        public void addToXML()
        {
            Console.Write("Введите номер дилера: ");
            var DealerNumber = Console.ReadLine();

            Console.WriteLine();
            Console.Write("Введите город дилера: ");
            var City = Console.ReadLine();

            Console.WriteLine();
            Console.Write("Введите имя дилера: ");
            var DealerName = Console.ReadLine();

            Console.WriteLine();
            Console.Write("Введите количество машин в наличии: ");
            var CarAmount = Console.ReadLine();

            xdoc.Element("Rows").Add(new XElement("row",
                                  new XElement("DealerNumber", DealerNumber),
                                  new XElement("City", City),
                                  new XElement("DealerName", DealerName),
                                  new XElement("CarAmount", CarAmount)
                                  ));
            xdoc.Save("DealersUpdated.xml");
            Console.WriteLine("Сохранение выполнено успешно. Файл: DealersUpdated.xml");
        }

        public SecondTask()
        {
            bool flag = true;

            while (flag)
            {
                Console.WriteLine("\nМеню:");
                Console.WriteLine("0. Назад.");
                Console.WriteLine("1. Чтение из XML документа.");
                Console.WriteLine("2. Обновление XML документа.");
                Console.WriteLine("3. Запись (Добавление) в XML документ.");
                Console.Write("Ввод: ");

                var input = Console.ReadLine();
                switch (input)
                {
                    case "0":
                        flag = false;
                        break;
                    case "1":
                        readFromXML();
                        break;
                    case "2":
                        updateXML();
                        break;
                    case "3":
                        addToXML();
                        break;
                    default:
                        Console.WriteLine("Попробуйте еще раз.");
                        break;
                }
            }
        }
    }
}
