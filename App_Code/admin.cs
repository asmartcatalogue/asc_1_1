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

using System;

using System.Text;
using System.Data.OleDb;
using System.Data;
using System.Web;
using System.Globalization;
using System.Threading;
using System.Security.Cryptography;

namespace asc
{

    namespace admin
    {

        public class Category
        {
            public int Id;
            public string Name;
            public int ParentId;
            public string Img;
            public string Strpath;
            public Category(int _id, int _idpadre, string _name, string _strpath)
            {

                this.Id = _id;
                this.ParentId = _idpadre;
                this.Name = _name;
                this.Strpath = _strpath;
            }
        }

        public class localization
        {
            public static NumberFormatInfo primarynumberformatinfo
            {
                get
                {
                    return numberformatinfobyidcurrency((int)HttpContext.Current.Application["config_idmastercurrency"]);

                }
            }

            public static NumberFormatInfo numberformatinfobyidcurrency(int idcurrency)
            {
                NumberFormatInfo worknumberformatinfo;

                DataRow rowcurrency = ((DataTable)HttpContext.Current.Application["dtcurrenciesavailable"]).Rows.Find(idcurrency);
                CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
                worknumberformatinfo = modified.NumberFormat;
                worknumberformatinfo.CurrencySymbol = rowcurrency["nome"].ToString();
                worknumberformatinfo.CurrencyDecimalDigits = (int)rowcurrency["decimali"];
                worknumberformatinfo.CurrencyDecimalSeparator = (string)rowcurrency["decimalseparatorsymbol"];
                worknumberformatinfo.CurrencyGroupSeparator = (string)rowcurrency["groupseparatorsymbol"];



                worknumberformatinfo.NumberDecimalSeparator = (string)rowcurrency["decimalseparatorsymbol"];
                worknumberformatinfo.NumberGroupSeparator = "";
                return worknumberformatinfo;

            }


        }









        public class sicurezza
        {

            public static bool adminAutenticato(string pass)
            {


                OleDbCommand cmd;
                string sql;
                int quanti = 0;

                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    cnn.Open();
                    sql = "SELECT COUNT(*) FROM tconfig where config_pwadmin=@pass";
                    cmd = new OleDbCommand(sql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@pass", asc.sicurezza.crittmd5.encoda(pass)));
                    quanti = Convert.ToInt32(cmd.ExecuteScalar().ToString());
                    cnn.Close();
                }
                return quanti > 0;

            }


            public static void cambioPass(string pass)
            {

                OleDbCommand cmd;
                string strSql;


                MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();
                byte[] hashedDataBytes = null;
                UTF8Encoding encoder = new UTF8Encoding();
                hashedDataBytes = md5Hasher.ComputeHash(encoder.GetBytes(pass));



                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    strSql = "UPDATE tconfig SET config_pwadmin=@pass";

                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@pass", hashedDataBytes));

                    cnn.Open();
                    cmd.ExecuteNonQuery();
                    cnn.Close();
                }
                asc.config.storeConfig();
            }



        }


        public class pagine
        {
            public static DataRow leggi(int id)
            {
                string sql = "SELECT pa_nome, pa_testo FROM tpagine WHERE pa_id=@id";
                DataTable dt = asc.helpDb.getDataTable(sql, new OleDbParameter("id", id));
                DataRow dr = dt.Rows[0];
                return dr;
            }
        }


        public class spedizione
        {


            public static DataSet adminGetPesi()
            {
                DataSet ds = new DataSet();

                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    string strSql = "SELECT * FROM tpesi ORDER BY p_a";
                    OleDbDataAdapter da = new OleDbDataAdapter();
                    OleDbCommand cmd = new OleDbCommand(strSql, cnn);
                    da.SelectCommand = cmd;
                    cnn.Open();
                    da.Fill(ds, "pesi");
                    cnn.Close();
                }

                ds.Tables["pesi"].PrimaryKey = new DataColumn[] { ds.Tables["pesi"].Columns["p_id"] };
                return ds;
            }


            public static void adminAddFasciaPeso(double a, double prezzo)
            {


                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {

                    string strSql;
                    OleDbCommand cmd;
                    cnn.Open();
                    strSql = "INSERT INTO tpesi (p_a, p_prezzo) VALUES (@a, @prezzo)";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@a", a));
                    cmd.Parameters.Add(new OleDbParameter("@prezzo", prezzo));
                    cmd.ExecuteNonQuery();
                    cnn.Close();
                }
            }

            public static void adminDelFasciaPeso(int id)
            {


                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {

                    string strSql;
                    OleDbCommand cmd;
                    cnn.Open();

                    strSql = "delete  FROM tpesi" +
                    " WHERE p_id=@id";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@id", id));
                    cmd.ExecuteNonQuery();

                    cnn.Close();
                }
            }


            public static void adminUpdateFascePrezzo(int id, double a, double prezzo)
            {


                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {

                    cnn.Open();
                    string strSql;
                    OleDbCommand cmd;

                    strSql = "UPDATE tpesi SET " +
                    " p_a=@a, p_prezzo=@prezzo" +
                    " WHERE p_id=@id";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@a", a));
                    cmd.Parameters.Add(new OleDbParameter("@prezzo", prezzo));
                    cmd.Parameters.Add(new OleDbParameter("@id", id));
                    cmd.ExecuteNonQuery();

                    cnn.Close();
                }
            }



            public static void updateSovrappr(int id, double prezzo, int modalita)
            {
                string sql = "UPDATE tipipagamento SET" +
                    " prezzo=@prezzo, modalita=@modalita WHERE id=@id";

                OleDbParameter p1 = new OleDbParameter("prezzo", prezzo);
                OleDbParameter p2 = new OleDbParameter("modalita", modalita);
                OleDbParameter p3 = new OleDbParameter("id", id);

                helpDb.nonQuery(sql, p1, p2, p3);
            }



        }

    }
}