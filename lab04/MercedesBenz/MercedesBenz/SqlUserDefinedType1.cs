using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Text.RegularExpressions;



[Serializable]
[SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
public struct Car : INullable, IBinarySerialize
{
    private string _Car;
    private bool _null;
    public override string ToString()
    {
        return _Car;
    }
    public bool IsNull
    {
        get
        {
            return _null;
        }
    }
    public static Car Null
    {
        get
        {
            Car h = new Car();
            h._null = true;
            return h;
        }
    }
    public static Car Parse(SqlString s)
    {//Преобразование строки из SQL запроса в тип 
        if (s.IsNull)
            return Null;
        Car u = new Car();
        string str = s.ToString();
        if (isValidThreat(str))
        {
            u._Car = str;
        }
        else
        {
            throw new Exception("Invalid data format");
        };
        return u;
    }
    private static bool isValidThreat(string Car)
    {
        if (Car == "0" || Car == "1")
        {
            return true;
        }
        else
            return false;
    }
    void IBinarySerialize.Read(System.IO.BinaryReader r)
    {
        this._Car = r.ReadString();
    }
    void IBinarySerialize.Write(System.IO.BinaryWriter w)
    {
        w.Write(this._Car);
    }
}
