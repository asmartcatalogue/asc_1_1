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
using System.Data;
using System.Data.OleDb;


namespace asc
{



	public class mailing
	{






		public static DataTable getEmailsNewsletter()
		{
			string sql;

			sql = "SELECT * FROM tmailing";

			return helpDb.getDataTable(sql);
		}



		public static void deleteEmail(string email)
		{

			using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
			{
				cnn.Open();

				OleDbCommand cmd;
				string strSql;

				strSql = "delete  FROM tmailing WHERE m_email=@email";
				cmd = new OleDbCommand(strSql, cnn);
				cmd.Parameters.Add(new OleDbParameter("@email", email));
				cmd.ExecuteNonQuery();

				cnn.Close();
			}
		}


	}


}
























