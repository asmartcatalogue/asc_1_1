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

namespace asc
{
    public class caching
    {
        public static void cacheallcategories()
        {
            DataSet ds = new DataSet();
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                cnn.Open();
                OleDbDataAdapter da;
                string sql = "select cat_id, cat_idpadre, cat_nome, cat_metadescription, cat_metakeywords from tcategorie order by cat_idpadre";
                OleDbCommand cmd = new OleDbCommand(sql, cnn);
                da = new OleDbDataAdapter(cmd);
                da.Fill(ds);
                cnn.Close();
            }
            ds.Tables[0].PrimaryKey = new DataColumn[] { ds.Tables[0].Columns["cat_id"] };

            HttpContext.Current.Application["dtcat"] = ds.Tables[0]; 




        }



    }
}