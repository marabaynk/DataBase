using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data.Linq.Mapping;

namespace RK3
{
    [Table(Name = "teacher")]
    public class Teacher
    {
        [Column(IsPrimaryKey = true)]
        public int id { get; set; }

        [Column]
        public string FIO { get; set; }

        [Column]
        public string kafedra { get; set; }

        [Column]
        public int studNum { get; set; }

    }

    [Table(Name = "student")]
    public class Student
    {
        [Column(IsPrimaryKey = true)]
        public int id { get; set; }

        [Column]
        public string FIO { get; set; }

        [Column]
        public DateTime dateofbirth { get; set; }

        [Column]
        public string kafedra { get; set; }

        [Column]
        public string theme { get; set; }

        [Column]
        public int nauchruk { get; set; }

    }
}