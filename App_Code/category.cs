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

using System.IO;
using System.Data;
using System.Data.OleDb;
using System.Web;

namespace asc
{

    public class Category
    {


    
		public static string Linkforrouting(int idcat, string catname)		{

            string textoflink = asc.filtertext.getonlyallowedcharsforcorrecturl(asc.language.getforfrontfromstringindefaultlanguage( catname));

            if (textoflink== "") textoflink = "-";


			return System.Web.VirtualPathUtility.ToAbsolute("~/catalog/" + textoflink + "/" + idcat.ToString());


		}


        public static void delete (int idcat )
        {

            DataTable dtwork = asc.helpDb.getDataTable("select art_id from tproducts where art_idcat=@idcat", new OleDbParameter("idcat", idcat));
            foreach ( DataRow rowwork in dtwork.Rows)
            {
                string relativeprodpath;

                relativeprodpath = "~/app_data/p/" + rowwork["art_id"].ToString();
                if (File.Exists(HttpContext.Current.Server.MapPath(relativeprodpath))) File.Delete(HttpContext.Current.Server.MapPath(relativeprodpath));


                string relativedirotherimagespath;

                relativedirotherimagespath = "~/app_data/morep/" + rowwork["art_id"].ToString();
                if (Directory.Exists(HttpContext.Current.Server.MapPath(relativedirotherimagespath)))
                    Directory.Delete(HttpContext.Current.Server.MapPath(relativedirotherimagespath), true);


            }

            string strSql = "delete  FROM tcategorie WHERE cat_id=@idcat";
            asc.helpDb.nonQuery(strSql, new OleDbParameter("idcat", idcat));
            asc.caching.cacheallcategories();

            string relativepath;

            relativepath = "~/app_data/c/" + idcat.ToString();
            if (File.Exists(HttpContext.Current.Server.MapPath(relativepath))) File.Delete(HttpContext.Current.Server.MapPath(relativepath));



        }


    }

}