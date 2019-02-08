using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Schema;

namespace ConsoleApp1
{
    class Program
    {
        private static bool flag;
        static void Main(string[] args)
        {
            flag = true;
            XmlSchemaCollection sc = new XmlSchemaCollection();
            sc.Add("", "Z:/Desktop/DataBase/lab05/testDTD.xsd");

            XmlTextReader tr = new XmlTextReader("Z:/Desktop/DataBase/lab05/testDTD.xml");

            XmlValidatingReader vr = new XmlValidatingReader(tr);

            vr.ValidationType = ValidationType.Schema;

            vr.Schemas.Add(sc);

            vr.ValidationEventHandler += new ValidationEventHandler(MyHandler);

            try
            {
                while (vr.Read())
                {
                    if (vr.NodeType == XmlNodeType.Element && vr.LocalName == "CarAmount")
                    {
                        string name = vr.ReadElementString();
                        for (var i = 0; i < name.Length; i++)
                        {
                            int n;
                            if (int.TryParse(name.Substring(i), out n)) { }
                            else
                                throw new XmlException("CarAmount cannot consider latters ");
                        }
                        int number = Convert.ToInt32(name);
                        if (number > 1000)
                        {
                            throw new XmlException("CarAmount cannot be more then 1000 ");
                        }
                        else if (number < 5)
                        {
                            throw new XmlException("CarAmount cannot be less then 5 ");
                        }
                        //Console.WriteLine("CarAmount: " + number);
                    }
                    if (vr.NodeType == XmlNodeType.Element && vr.LocalName == "DealerName")
                    {
                        string name = vr.ReadElementString();
                        if (name == "")
                        {
                            throw new XmlException("DealerName must exist! ");
                        }

                        for (var i = 0; i < name.Length; i++)
                        {
                            int n;
                            if (int.TryParse(name.Substring(i), out n))
                            {
                                throw new XmlException("DealerName can`t consider numbers! ");
                            }

                        }
                    }
                    if (vr.NodeType == XmlNodeType.Element && vr.LocalName == "DealerName")
                    {
                        string name = vr.ReadElementString();
                        if (name == "")
                        {
                            throw new XmlException("DealerName should be" + vr.XmlLang);
                        }
                        for (var i = 0; i < name.Length; i++)
                        {
                            int n;
                            if (int.TryParse(name.Substring(i), out n))
                            {
                                throw new XmlException("DealerName can`t consider numbers! ");
                            }
                        }
                    }
                }
            }
            catch (XmlException ex)
            {
                flag = false;
                Console.WriteLine("XmlException: " + ex.Message);
            }
            finally
            {
                vr.Close();
            }
            if (flag == true)
            {
                Console.WriteLine("Success!");
            }
            Console.ReadKey();
        }

        public static void MyHandler(object sender, ValidationEventArgs e)
        {
            flag = false;
            Console.WriteLine("Validation failed! Error message: " + e.Message);
        }
    }
}