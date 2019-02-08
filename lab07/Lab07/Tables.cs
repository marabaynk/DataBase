using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Data.SqlClient;
using System.Data.Linq.Mapping;

namespace Lab07
{
    [Table (Name = "Dealer")]
    public class DealersTable
    {
        [Column (IsPrimaryKey = true, IsDbGenerated = true)]
        public int id { get; set; }
        [Column]
        public string City { get; set; }

        [Column]
        public string DealerName { get; set; }

        [Column]
        public int CarAmount { get; set; }
    }

    [Table (Name = "Factory")]
    public class FactoriesTable
    {
        [Column (IsPrimaryKey = true, IsDbGenerated = true)]
        public int id { get; set; }

        [Column]
        public string City { get; set; }

        [Column]
        public int CarAmount { get; set; }
    }

    [Table (Name = "MercedesBenz")]
    public class MercedesBenzTable
    {
        [Column (IsPrimaryKey = true, IsDbGenerated = true)]
        public int id { get; set; }

        [Column]
        public int CarId { get; set; }

        [Column]
        public int FactoryId { get; set; }

        [Column]
        public int DealerId { get; set; }

        [Column]
        public System.DateTime DeliveryDate { get; set; }

    }

    [Table (Name="Car")]
    public class CarsTable
    {
        [Column (IsPrimaryKey = true, IsDbGenerated = true)]
        public int id { get; set; }

        [Column]
        public string CarModel { get; set; }

        [Column]
        public System.DateTime DateOfIssue { get; set; }

        [Column]
        public int HorsePower { get; set; }

        [Column]
        public int isTransmission { get; set; }
    }
}
