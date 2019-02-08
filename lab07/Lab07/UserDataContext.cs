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
    public class UserDataContext
    {
        public class UserDataContext1 : DataContext
        {
            public UserDataContext1(string connectionString) : base(connectionString)
            {

            }
            
            [Function(Name = "GetDiffHP")]
            [return: Parameter(DbType = "Int")]
            public int GetDiffHP(
                [Parameter(Name = "Fir" +
                "stHP", DbType = "Int")] ref int _FirstHP,
                [Parameter(Name = "SecondHP", DbType = "Int")] ref int _SecondHP)
            {
                IExecuteResult result = this.ExecuteMethodCall(this, (MethodInfo)MethodInfo.GetCurrentMethod(), _FirstHP, _SecondHP);
                _FirstHP = (int)result.GetParameterValue(0);
                _SecondHP = (int)result.GetParameterValue(1);

                return (int)result.ReturnValue;
            }
        }
    }
}