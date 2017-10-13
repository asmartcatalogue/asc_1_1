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

using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Web;
using System.IO;
using System.Globalization;
using System.Threading;


namespace asc
{

    public class products
    {
        public static string commaseparatedfields =
            " art_id, art_cod, art_name, art_rawprice, art_discount, art_pricestartingfrom" +
            ",art_idcat, art_brand, art_description, art_metadescription, art_metakeywords, art_taxnotappliable ";

        public static List<asc.product> get(string sql, params OleDbParameter[] list)
        {

            List<product> worklistproducts = new List<product>();
            DataTable dt = new DataTable();
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {

                OleDbCommand cmd = new OleDbCommand(sql, cnn);
                for (int rip = 0; rip < list.Length; rip++)
                {
                    cmd.Parameters.Add(list[rip]);
                }
                OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                da.Fill(dt);
            }

            foreach (DataRow dr in dt.Rows)
            {

                asc.product workprod = new asc.product
                     (
                     (int)dr["art_id"],
                     (string)dr["art_cod"],
                     (string)dr["art_name"],
                     (double)dr["art_rawprice"],
                     (double)dr["art_discount"],
                     (int)dr["art_pricestartingfrom"],
                     (int)dr["art_idcat"],
                     (string)dr["art_brand"],
                     (string)dr["art_description"],
                     (string)dr["art_metadescription"],
                     (string)dr["art_metakeywords"],
                     (int)dr["art_taxnotappliable"]
                     );

                worklistproducts.Add(workprod);



            }

            return worklistproducts;
        }

    }





    public class product
    {





        public string Namealllang { get; private set; }
        public int Id { get; private set; }
        public string Code { get; private set; }
        public int Pricestartingfrom { get; private set; }
        public int Idcat { get; private set; }
        public string Brand { get; private set; }
        public string Description { get; private set; }
        public string Metadescription { get; private set; }
        public string Metakeywords { get; private set; }
        public int Taxnotappliable { get; private set; }
        public Dictionary<string, string> Additionalfields = new Dictionary<string, string>();

        // calculated
        public string Nameforfrontincurrentlanguage { get; private set; }
        public string Linkart { get; private set; }
        private double basicprice;
        private double basicpricepluspossibletax;
        private double priceafterdisc;
        private double priceafterdiscpluspossibletax;
        public string Finalpriceformatted { get; private set; }



        public product(

            int _id,
            string _cod,
            string _namealllang,
            double _rawprice,
            double _proddiscount,
            int _pricestartingfrom,
            int _idcat,
            string _brand,
            string _description,
            string _metadescription,
            string _metakeywords,
            int _taxnotappliable
        )

        {


            this.Id = _id;
            this.Code = _cod;
            this.Namealllang = _namealllang;
            this.Nameforfrontincurrentlanguage = asc.language.getforfrontfromstringincurrentlanguage(_namealllang);
            this.Idcat = _idcat;
            this.Brand = _brand;
            this.Description = _description;
            this.Metadescription = _metadescription;
            this.Metakeywords = _metakeywords;
            this.Taxnotappliable = _taxnotappliable;
            this.Pricestartingfrom = _pricestartingfrom;

            // price **********************************************************************************************************************



            if (_rawprice == -1) this.Finalpriceformatted = "";
            else
            {
                CultureInfo modified = new CultureInfo(Thread.CurrentThread.CurrentCulture.Name);
                Thread.CurrentThread.CurrentCulture = modified;
                modified.NumberFormat = asc.currencies.usernumberformatinfo((asc.currency)(HttpContext.Current.Session["frontendcurrency"]));

                basicprice = asc.currencies.todefinedcurrencyfrommaster(_rawprice, ((asc.currency)(HttpContext.Current.Session["frontendcurrency"])).cambio);
                priceafterdisc = basicprice * (1 - _proddiscount / 100);

                if ((int)HttpContext.Current.Application["config_showtaxincluded"]==1  && _taxnotappliable==0)
                {
                    basicpricepluspossibletax = basicprice * (1 + (double)HttpContext.Current.Application["config_taxrate"] / 100);
                    priceafterdiscpluspossibletax = priceafterdisc * (1 + (double)HttpContext.Current.Application["config_taxrate"] / 100);
                }
                else
                {
                    priceafterdiscpluspossibletax = priceafterdisc;
                    basicpricepluspossibletax = basicprice;
                }

                if (_proddiscount == 0)
                {
                    this.Finalpriceformatted =
                         "<span class='smallprice'>" +
                         basicpricepluspossibletax.ToString("C") +
                         "</span>";
                }
                else
                {
                    this.Finalpriceformatted =
                     "<span class='smallstrikedprice'>" +
                      basicpricepluspossibletax.ToString("C") +
                     "</span>&nbsp;<span class='smalldiscountedprice'>" +
                      priceafterdiscpluspossibletax.ToString("C") +
                     "</span>";

                }

                if (_taxnotappliable==0)
                {
                    if ((int)HttpContext.Current.Application["config_showtaxincluded"] == 1)
                        this.Finalpriceformatted += " " + asc.language.getforfrontfromdictionaryincurrentlanguage("common.label.price.tax.included");
                    else this.Finalpriceformatted += " " + asc.language.getforfrontfromdictionaryincurrentlanguage("common.label.price.tax.excluded");

                }

                if (this.Pricestartingfrom==1 && this.Finalpriceformatted != "")
                    this.Finalpriceformatted = asc.language.getforfrontfromdictionaryincurrentlanguage("common.label.starting.from.before.price") + " " + this.Finalpriceformatted;


                //end formatted price ******************************************************************************************************************



            }



            // ***************************************************************************************************************************************
            string worklinkart = asc.filtertext.getonlyallowedcharsforcorrecturl(
                  asc.language.getfromstringandlanguagename(_namealllang, System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"])
                  );

            if (worklinkart == "") worklinkart = "-";

            this.Linkart += "~/prod/" + System.Web.HttpUtility.UrlEncode(worklinkart) +
                                             "/" + this.Id; ;





        }



        public static void delete(int idart)
        {


            asc.helpDb.nonQuery(
                "delete from tproducts where art_id=@idart",
                 new OleDbParameter("idart", idart)
            );

            string relativepath;

            relativepath = "~/app_data/p/" + idart.ToString();
            if (File.Exists(HttpContext.Current.Server.MapPath(relativepath))) File.Delete(HttpContext.Current.Server.MapPath(relativepath));

            relativepath = "~/app_data/morep/" + idart.ToString();
            if (Directory.Exists(HttpContext.Current.Server.MapPath(relativepath))) Directory.Delete(HttpContext.Current.Server.MapPath(relativepath), true);


        }

    }
}