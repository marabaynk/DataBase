using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.IO;

namespace Lab06
{
    class Lab
    {

        XmlDocument document = new XmlDocument();

        public Lab()
        {
            try
            {
                FileStream myFile = new FileStream("Z:/Desktop/DataBase/lab06/laba6/DealerDTD.xml", FileMode.Open);
                document.Load(myFile);
            }
            catch (Exception ex)
            {
                Console.WriteLine("\nОшибка: " + ex.Message);
                Console.Read();
                Environment.Exit(-1);
            }

            do
            {
                Console.WriteLine("\nМеню:");
                Console.WriteLine("0. Выход.");
                Console.WriteLine("1. Поиск информации, содержащейся в документе");
                Console.WriteLine("2. Доступ к содержимому узлов");
                Console.WriteLine("3. Внесение изменений в документ");
                Console.Write("Выбор: ");

                try
                {
                    int input = Convert.ToInt32(Console.ReadLine());

                    switch (input)
                    {
                        case 0:
                            Environment.Exit(0);
                            break;
                        case 1:
                            searchInfo();
                            break;
                        case 2:
                            accessToNodes();
                            break;
                        case 3:
                            docChanges();
                            break;
                        default:
                            Console.WriteLine("Попробуйте еще раз.");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nОшибка: " + ex.Message);
                }


            } while (true);
        }



        // 2. Поиск информации, содержащейся в документе
        private void searchInfo()
        {
            bool flag = true;
            do
            {
                Console.WriteLine("\nМеню поиска информации:");
                Console.WriteLine("0. Назад.");
                Console.WriteLine("1. с помощью метода GetElementsByTagName");
                Console.WriteLine("2. с помощью метода GetElementsById");
                Console.WriteLine("3. с помощью метода SelectNodes");
                Console.WriteLine("4. с помощью метода SelectSingleNode");
                Console.WriteLine("5. удаление комментариев");
                Console.Write("Выбор: ");

                try
                {
                    int input = Convert.ToInt32(Console.ReadLine());

                    switch (input)
                    {
                        case 0:
                            flag = false;
                            break;
                        case 1:
                            byTagName();
                            break;
                        case 2:
                            byID();
                            break;
                        case 3:
                            Nodes();
                            break;
                        case 4:
                            SingleNode();
                            break;
                        default:
                            Console.WriteLine("Попробуйте еще раз.");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nОшибка: " + ex.Message);
                }

            } while (flag);
        }



        private void byTagName()
        {
            Console.Write("\nВведите тэг: ");
            var tag = Console.ReadLine();
            XmlNodeList byTag = document.GetElementsByTagName(tag);
            if (byTag.Count == 0)
                Console.WriteLine("\nИнформация по тэгу \"" + tag + "\" отсутсвует.");
            else
            {
                Console.WriteLine("\nИнформация по тэгу \"" + tag + "\":");
                for (int i = 0; i < byTag.Count; i++)
                    Console.Write(byTag[i].ChildNodes[0].Value + "\r\n");
            }
        }
         
        private void byID()
        {
            Console.Write("\nВведите ID: ");
            var ID = Console.ReadLine();
            XmlElement _byID = document.GetElementById(ID);
            Console.Write("\nДилер по ID \"" + ID + "\": " + _byID.ChildNodes[0].ChildNodes[0].Value + "\r\n");
        }

        private void Nodes()
        {
            Console.Write("\nВведите название дилера: ");
            var DealerName = Console.ReadLine();
            XmlNodeList Dealer = document.SelectNodes("//Cars/Dealer/CarAmount/text()[../../ DealerName / text() = '" + DealerName + "']");

            if (Dealer.Count == 0)
                Console.WriteLine("\nДилера \"" + DealerName + "\" отсутсвует.");
            else
            { 
                Console.WriteLine("\nКоличество автомобилей в наличии у дилеров \"" + DealerName + "\":");
                for (int i = 0; i < Dealer.Count; i++)
                    Console.Write(Dealer[i].Value + "\r\n");
            }
        }

        private void SingleNode()
        {
            Console.Write("\nВведите название дилера: ");
            var DealerName = Console.ReadLine();
            XmlNode Amount = document.SelectSingleNode("//Cars/Dealer/City/text()[../../ DealerName / text() = '" + DealerName + "']");

            Console.Write("\nГород расположения дилера: " + Amount.Value + "\r\n");
        }



        // 3. Доступ к содержимому узлов: 
        private void accessToNodes()
        {
            bool flag = true;
            do
            {
                Console.WriteLine("\nМеню доступа к узлам:");
                Console.WriteLine("0. Назад.");
                Console.WriteLine("1. к узлам типа XmlElement (Получить элемент)");
                Console.WriteLine("2. к узлам типа XmlТext (Получить текстовое значение элемента)");
                Console.WriteLine("3. к узлам типа XmlComment (Получить содержимое комментария");
                Console.WriteLine("4. к узлам типа XmlProcessingInstruction (Получить инструкцию по обработке XML<xsl>)");
                Console.WriteLine("5. к атрибутам узлов");
                Console.Write("Выбор: ");

                try
                {
                    int input = Convert.ToInt32(Console.ReadLine());

                    switch (input)
                    {
                        case 0:
                            flag = false;
                            break;
                        case 1:
                            getXmlElement();
                            break;
                        case 2:
                            getXmlТext();
                            break;
                        case 3:
                            getXmlComment();
                            break;
                        case 4:
                            getXmlProcessingInstruction();
                            break;
                        case 5:
                            getAttributes();
                            break;
                        default:
                            Console.WriteLine("Попробуйте еще раз.");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nОшибка: " + ex.Message);
                }

            } while (flag);
        }

        private void getXmlElement()
        {
            Console.WriteLine("\nXmlElement:");
            Console.WriteLine(document.DocumentElement.ChildNodes[1].ChildNodes[2].InnerText);
        }

        private void getXmlТext()
        {
            Console.WriteLine("\nXmlТext:");
            Console.Write(document.DocumentElement.ChildNodes[1].InnerText + "\r\n");
        }

        private void getXmlComment()
        {
            Console.WriteLine("\nXmlComment:");
            Console.WriteLine(document.DocumentElement.ChildNodes[1].ChildNodes[3].Value);
        }

        private void getXmlProcessingInstruction()
        {
            Console.WriteLine("\nXmlProcessingInstruction:");
            XmlProcessingInstruction ProcessingInstruction = (XmlProcessingInstruction)document.DocumentElement.ChildNodes[0];
            Console.Write("Name: " + ProcessingInstruction.Name + "\r\n");
            Console.Write("Data: " + ProcessingInstruction.Data + "\r\n");
        }

        private void getAttributes()
        {
            Console.WriteLine("\nАтрибуты:");

            Console.WriteLine("Атрибут ID: " + document.DocumentElement.GetAttribute("Id"));

            foreach (XmlNode node in document.ChildNodes)
            {
                foreach (XmlNode nodeChildNode in node.ChildNodes)
                {
                    XmlAttributeCollection attributes = nodeChildNode.Attributes;
                    if (attributes != null)
                    {
                        foreach (XmlAttribute atr in attributes)
                        {
                            Console.Write("Атрибут: " + atr.Name + " = " + atr.Value + "\r\n");
                        }
                    }
                }
            }
        }




        // 4.
        private void docChanges()
        {
            bool flag = true;
            do
            {
                Console.WriteLine("\nМеню внесения изменений в документ:");
                Console.WriteLine("0. Назад.");
                Console.WriteLine("1. удаление содержимого");
                Console.WriteLine("2. внесение изменений в содержимое");
                Console.WriteLine("3. создание нового содержимого");
                Console.WriteLine("4. вставка содержимого");
                Console.WriteLine("5. добавление атрибутов");
                Console.WriteLine("6. удаление комментариев");
                Console.Write("Выбор: ");

                try
                {
                    int input = Convert.ToInt32(Console.ReadLine());

                    switch (input)
                    {
                        case 0:
                            flag = false;
                            break;
                        case 1:
                            deleteFromDoc();
                            break;
                        case 2:
                            changeInDoc();
                            break;
                        case 3:
                            newInDoc();
                            break;
                        case 4:
                            insertInDoc();
                            break;
                        case 5:
                            insertAttrsInDoc();
                            break;
                        case 6:
                            deleteComments();
                            break;
                        default:
                            Console.WriteLine("Попробуйте еще раз.");
                            break;
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("\nОшибка: " + ex.Message);
                }

            } while (flag);
        }

        private void SaveChanges(string name)
        {
            var files = Directory.GetFiles(Directory.GetCurrentDirectory(), "DealerDTD.xml");
            var last = files.Max(file => file);
            last = last.Replace("DealerDTD", "");
            last = last.Replace(".xml", "");
            last = last.Replace(Directory.GetCurrentDirectory() + "\\", "");

            string filename = $"Cars" + name + ".xml";
            document.Save(filename);
            Console.WriteLine($"\nФайл {filename} сохранен.");
        }

        private void deleteFromDoc()
        {
            Console.WriteLine("Выполняется удаление...");
            Console.Write("Введение тэг: ");
            var tag = Console.ReadLine();
            XmlElement removeElement = (XmlElement)document.GetElementsByTagName(tag)[0];
            document.DocumentElement.RemoveChild(removeElement);
            SaveChanges("_removeSectionForDelete");
            Console.WriteLine("\nУдаление успешно выполнено.");
        }

        private void changeInDoc()
        {
            Console.WriteLine("Выполняется изменение...");
            Console.Write("Введение атрибут элемента: ");
            var tag = Console.ReadLine();
            XmlNodeList nodeList = document.SelectNodes("//Cars/Dealer/" + tag + "/text()");
            if (nodeList.Count == 0)
                Console.Write("Неправильный тег");

            Console.Write("\nВведение значение: ");
            var value = Console.ReadLine();

            Console.Write("\nВведите id: ");
            var i = Console.ReadLine();
            int x = Convert.ToInt32(i);

            nodeList[x].Value = value;
            SaveChanges("_changeTestName");
            Console.WriteLine("Изменение успешно выполнено.");
        }

        private void newInDoc()
        {
            Console.WriteLine("Вставка в конец:");
            Console.Write("Введение название элемента: ");
            var tag = Console.ReadLine();
            XmlElement cityElement = document.CreateElement(tag);
            Console.Write("Введение текст элемента: ");
            var text = Console.ReadLine();
            XmlText cityText = document.CreateTextNode(text);
            cityElement.AppendChild(cityText);
            document.DocumentElement.AppendChild(cityElement);
            SaveChanges("_newInDoc");
        }

        private void insertInDoc()
        {
            Console.WriteLine("Вставка содержимого в Dealer с id = 1");
            Console.Write("Введите название тега: ");
            var tag = Console.ReadLine();

            Console.Write("Введите содержимое тега: ");
            var text = Console.ReadLine();

            XmlElement cityElement = document.CreateElement(tag);
            XmlText cityText = document.CreateTextNode(text);
            cityElement.AppendChild(cityText);
            document.DocumentElement.ChildNodes[1].AppendChild(cityElement);
            SaveChanges("_insertInDoc");
        }

        private void insertAttrsInDoc()
        {
            Console.Write("Введение название атрибута: ");
            var attr = Console.ReadLine();
            Console.Write("Введение значение атрибута: ");
            var value = Console.ReadLine();
            document.DocumentElement.SetAttribute(attr, value);
            SaveChanges("_insertAttrsInDoc");
        }

        private void findAndDelete()
        { 

            for (int i = 0; i < document.ChildNodes.Count; i++)
            {
                for (int j = 0; j < document.ChildNodes[i].ChildNodes.Count; j++)
                {
                    if (document.ChildNodes[i].ChildNodes[j].GetType().ToString() == "System.Xml.XmlComment")
                    {
                        document.ChildNodes[i].RemoveChild(document.ChildNodes[i].ChildNodes[j]);
                    }
                    for (int k = 0; k < document.ChildNodes[i].ChildNodes[j].ChildNodes.Count; k++)
                    {
                        if (document.ChildNodes[i].ChildNodes[j].ChildNodes[k].GetType().ToString() == "System.Xml.XmlComment")
                        {
                            document.ChildNodes[i].ChildNodes[j].RemoveChild(document.ChildNodes[i].ChildNodes[j].ChildNodes[k]);
                        }
                    }
                }
                    
            }
        }

        private void deleteComments()
        {
            findAndDelete();
            document.Save(@"Z:\Desktop\DataBase\lab06\laba6\comDel.xml");
        }
    }
}


//удалить все комментарии из xml
