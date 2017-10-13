/*
 
    Copyright (C) 2017 Maurizio Ferrera
 
    This file is part of asmartcatalogue

    asmartcatalogue is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    asmartcatalogue is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with asmartcatalogue.  If not, see <http://www.gnu.org/licenses/>.
 
*/


using System.Data;
using System.Data.OleDb;
using System.Data.SqlTypes;

namespace asc
{








    public class helpDb
    {
        public static object getScalar(string sql, params OleDbParameter[] list)
        {
            object result = null;
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ToString()))
            {
                cnn.Open();


                OleDbCommand cmd = new OleDbCommand(sql, cnn);
                for (int rip = 0; rip < list.Length; rip++)
                {
                    cmd.Parameters.Add(list[rip]);
                }

                result = cmd.ExecuteScalar();

            }

            return result;

        }

        public static object getScalarByOpenCnn(OleDbConnection cnn, string sql, params OleDbParameter[] list)
        {


            OleDbCommand cmd = new OleDbCommand(sql, cnn);
            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }

            object result = cmd.ExecuteScalar();


            return result;

        }
        public static DataTable getDataTable(string sql, params OleDbParameter[] list)
        {
            DataTable dt = new DataTable();
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                using (OleDbCommand cmd = new OleDbCommand(sql, cnn))
                {
                    for (int rip = 0; rip < list.Length; rip++)
                    {
                        cmd.Parameters.Add(list[rip]);
                    }
                    OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                    da.Fill(dt);
                }
            }

            return dt;

        }
        public static DataRow getFirstRow(string sql, params OleDbParameter[] list)
        {

            return (asc.helpDb.getDataTable(sql, list)).Rows[0];

        }
        public static DataRow getFirstRowByOpenCnn(OleDbConnection cnn, string sql, params OleDbParameter[] list)
        {

            return (asc.helpDb.getDataTableByOpenCnn(cnn, sql, list)).Rows[0];

        }


        public static DataTable getDataTableByCnn(string strCnn, string sql, params OleDbParameter[] list)
        {
            DataSet ds;

            using (OleDbConnection cnn = new OleDbConnection(strCnn))
            {

                cnn.Open();

                ds = new DataSet();
                OleDbDataAdapter da = new OleDbDataAdapter();
                OleDbCommand cmd = new OleDbCommand(sql, cnn);

                for (int rip = 0; rip < list.Length; rip++)
                {
                    cmd.Parameters.Add(list[rip]);
                }


                da.SelectCommand = cmd;
                da.Fill(ds, "tabella");

                cnn.Close();
            }

            return ds.Tables["tabella"];

        }

        public static DataTable getDataTableByOpenCnn(OleDbConnection cnn, string sql, params OleDbParameter[] list)
        {
            DataSet ds;
            OleDbDataAdapter da;
            OleDbCommand cmd;


            ds = new DataSet();
            da = new OleDbDataAdapter();
            cmd = new OleDbCommand(sql, cnn);

            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }


            da.SelectCommand = cmd;
            da.Fill(ds, "tabella");


            return ds.Tables[0];

        }







        public static void nonQuery(string sql, params OleDbParameter[] list)
        {



            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                OleDbCommand cmd;
                cnn.Open();

                cmd = new OleDbCommand(sql, cnn);
                for (int rip = 0; rip < list.Length; rip++)
                {
                    cmd.Parameters.Add(list[rip]);
                }

                cmd.ExecuteNonQuery();

                cnn.Close();
            }

        }

        public static void nonQueryByOpenCnn(OleDbConnection c, string sql, params OleDbParameter[] list)
        {


            OleDbCommand cmd;

            cmd = new OleDbCommand(sql, c);
            for (int rip = 0; rip < list.Length; rip++)
            {
                cmd.Parameters.Add(list[rip]);
            }

            cmd.ExecuteNonQuery();




        }










    }










}
























