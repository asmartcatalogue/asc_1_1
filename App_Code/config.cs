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
using System.Web;

/// <summary>
/// Descrizione di riepilogo per config
/// </summary>
/// 

namespace asc
{



	public class config
	{

		public static object getCampoByDb(string nomeCampo)
		{


			OleDbCommand cmd;
			string strSql;
			object result;

			using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
			{
				strSql = "SELECT TOP 1 " + nomeCampo + " FROM tconfig order by contatore desc";
				cmd = new OleDbCommand(strSql, cnn);
				cnn.Open();
				result = cmd.ExecuteScalar();
				cnn.Close();
			}
			return result;


		}



		public static void storeConfig()
		{
			using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
			{

				DataSet ds = new DataSet();
				string sql = "SELECT top 1 * FROM tconfig";
				OleDbCommand cmd = new OleDbCommand(sql, cnn);
				cnn.Open();
				OleDbDataReader dr = cmd.ExecuteReader();
				dr.Read();
				for (int rip = 0; rip < dr.FieldCount; rip++)
				{

					HttpContext.Current.Application[dr.GetName(rip)] = dr[rip];
				}

				cnn.Close();
			}
		}

		public static DataTable dataTableConfig()
		{

			string strSql;
			strSql = "SELECT * FROM tconfig";

			return helpDb.getDataTable(strSql);
		}






	}








}