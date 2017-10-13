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




    public class pagine
    {


        public static void delete(int id)
        {

            string sql = "delete  FROM tpagine WHERE pa_id=@id";

            OleDbParameter p1 = new OleDbParameter("id", id);
            helpDb.nonQuery(sql, p1);
        }

        public static DataRow leggi(int id)
        {
            string sql = "SELECT pa_nome, pa_testo, pa_type FROM tpagine WHERE pa_id=@id";
            DataTable dt = asc.helpDb.getDataTable(sql, new OleDbParameter("id", id));
            DataRow dr = dt.Rows[0];
            return dr;
        }








    }




}
























