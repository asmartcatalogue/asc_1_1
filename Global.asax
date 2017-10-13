
<%--  
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
--%>

<%@ Application Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Routing" %>
<script RunAt="server">




    private static void defineroutes(RouteCollection routes)
    {

        routes.MapPageRoute("prod",
             "prod/{nomeprodotto}/{idArt}", "~/shop/articoli.aspx");
        routes.MapPageRoute("cat",
             "catalog/{nomecategoria}/{idCatSelected}", "~/shop/preview.aspx");
    }


    public void Application_Start(Object sender, EventArgs e)
    {


        defineroutes(RouteTable.Routes);



        asc.language.loadlanguages();











        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            OleDbCommand cmd;
            OleDbDataAdapter da;
            string sql;

            DataTable dtcurrencies = new DataTable();
            sql = "SELECT id, cambio, decimali, decimalseparatorsymbol, nome, groupseparatorsymbol FROM tcurrencies where cambio>0 order by nome";
            cmd = new OleDbCommand(sql, cnn);
            da = new OleDbDataAdapter(cmd);
            da.Fill(dtcurrencies);
            dtcurrencies.PrimaryKey = new DataColumn[] { dtcurrencies.Columns["id"] };
            Application["dtcurrenciesavailable"] = dtcurrencies;




        }

        asc.config.storeConfig(); // setta variabili di applicazione
        asc.caching.cacheallcategories();

    }




        void Session_OnStart()
    {

        HttpContext.Current.Session["currentfrontlanguage"] = System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"];

        int idcurrency = (int)HttpContext.Current.Application["config_idmastercurrency"];
        DataRow rowcurrentcurrency = ((DataTable)Application["dtcurrenciesavailable"]).Rows.Find(idcurrency);
        asc.currency curr = new asc.currency(
                            (int)rowcurrentcurrency["id"],
                            (double)rowcurrentcurrency["cambio"],
                            rowcurrentcurrency["nome"].ToString(),
                            rowcurrentcurrency["decimalseparatorsymbol"].ToString(),
                            (int)rowcurrentcurrency["decimali"],
                            (string)rowcurrentcurrency["groupseparatorsymbol"]
                            );
        Session["frontendcurrency"] = curr;

        HttpContext.Current.Session["coda"] = new System.Collections.Generic.List<asc.product>();


        HttpContext context = HttpContext.Current;
        HttpCookieCollection cookies = context.Request.Cookies;
        if (cookies["starttime"] == null)
        {
            HttpCookie cookie = new HttpCookie("starttime", DateTime.Now.ToString());
            cookie.Path = "/";
            context.Response.Cookies.Add(cookie);
        }
        else
        {
            if (Request.Path.ToLower().IndexOf("admin_") > 0 || Request.Path.IndexOf("admin.aspx") > 0) { }
            else context.Response.Redirect("~/shop/timeout.aspx");
        }


    }




</script>

