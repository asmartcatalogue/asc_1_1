//Copyright (C) 2017 Maurizio Ferrera

//This file is part of asmartcatalogue

//asmartcatalogue is free software: you can redistribute it and/or modify
//it under the terms of the GNU General Public License as published by
//the Free Software Foundation, either version 3 of the License, or
//(at your option) any later version.

//asmartcatalogue is distributed in the hope that it will be useful,
//but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//GNU General Public License for more details.

//You should have received a copy of the GNU General Public License
//along with asmartcatalogue.  If not, see <http://www.gnu.org/licenses/>.


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Collections;
using asc;
public partial class MasterPageClass : MasterPage
{

    int user;
    public int withmenulink;

    public void timer1_tick(object o, EventArgs e)
    {
        // on some server this is needed to keep the session active. 


    }

    public void buttCerca_click(object sender, EventArgs e)
    {
        Response.Redirect("~/shop/search.aspx?termine=" + Server.UrlEncode(tBoxSearch.Text));

    }












    public void itempagine_databound(Object Sender, RepeaterItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            PlaceHolder pholdpagina = (PlaceHolder)e.Item.FindControl("pholdpagina");

            string link = ((DataRowView)e.Item.DataItem).Row["link"].ToString();
            string nome = ((DataRowView)e.Item.DataItem).Row["nameonelang"].ToString();

            System.Web.UI.HtmlControls.HtmlAnchor anchor = (System.Web.UI.HtmlControls.HtmlAnchor)e.Item.FindControl("anchor");

            anchor.HRef = ResolveUrl(link);

            anchor.InnerHtml = nome;



        }

    }






    protected void Page_Init(object sender, EventArgs e)
    {


        Page.Header.DataBind();
        if (((int)HttpContext.Current.Application["config_openClose"]) == 1)
        {

            Response.Write(Application["config_msgChiusura"].ToString());
            Response.End();
        }














        footer.InnerHtml = asc.language.getforfrontfromstringincurrentlanguage(HttpContext.Current.Application["config_piede"].ToString());
        footer.InnerHtml += "<div style='text-align:center; padding-bottom:10px; padding-top:18px;'><a  target='_blank' href='http://asmartcatalogue.maurizioferrera.com' style='color:#222;  text-decoration:none'>open source software &copy; 2017 asmartcatalogue</a></div>";


    }

    protected void Page_Load(object sender, EventArgs e)
    {

        asc.other.RestartIfLanguagesHaveChanges();

        linksitename.HRef = ResolveUrl("~/shop/main.aspx");

        inheadtag.Text =
                "<link rel='stylesheet' href='" + ResolveUrl("~/css/struttura.css") + "' type='text/css' />" +
                "<script type='text/javascript' src='" + ResolveUrl("~/js/jquery.min.js") + "'></script>" + "\n";


        if ((int)Application["config_showcookiebar"] == 1)
        {
                inheadtag.Text +=
                "<script type = \"text/javascript\" >" +
                "window.cookieconsent_options = {" +
                " 'message':\"" + asc.language.getforfrontfromstringincurrentlanguage(Application["config_messageincookiebar"].ToString()) + "\"" +
                ",'dismiss':\"" + asc.language.getforfrontfromstringincurrentlanguage(Application["config_buttmessageincookiebar"].ToString()) + "\"" +
                ",'theme':'dark-bottom'};" +
                "</script>" +
                "<script type = \"text/javascript\" src = \"" + ResolveUrl("~/cookiebar/cookieconsent.min.js") + "\" ></script>";
        }



        // currencies
        DataTable dtcurrencies = (DataTable)Application["dtcurrenciesavailable"];
        foreach (DataRow drcurrency in dtcurrencies.Rows)
        {
            lblcurrencies.Text += "<a href = '" +
                ResolveUrl("~/shop/changeandreturn.aspx?idcurrency=" + drcurrency["id"].ToString()) +
                "' > " +
                drcurrency["nome"].ToString() +
                " </a>";

        }


        // languages
        List<string> frontlanguages = System.Configuration.ConfigurationManager.AppSettings["frontlanguages"].Split(',').ToList<string>();

        foreach (KeyValuePair<string, string> entry in (Dictionary<string, string>)Application["mydictionary"])
        {
            if (frontlanguages.Contains(entry.Key)) lbllanguages.Text += "<br><a href='" + ResolveUrl("~/shop/changeandreturn.aspx?idlanguage=" + entry.Key) + "'>" + entry.Key + "</a>";
        }


        // other pages
        DataTable dtrawotherpages = asc.helpDb.getDataTable("select pa_id, pa_nome, pa_type from tpagine");
        DataTable dtotherpages = new DataTable();
        dtotherpages.Columns.Add(new DataColumn("pa_id", typeof(int)));
        dtotherpages.Columns.Add(new DataColumn("nameonelang", typeof(string)));
        dtotherpages.Columns.Add(new DataColumn("link", typeof(string)));

        DataRow myrow;

        foreach (DataRow rawrow in dtrawotherpages.Rows)
        {

            myrow = dtotherpages.NewRow();
            myrow["nameonelang"] = asc.language.getforfrontfromstringincurrentlanguage(rawrow["pa_nome"].ToString());
            myrow["link"] = "~/shop/pagina.aspx?id=" + rawrow["pa_id"].ToString();
            dtotherpages.Rows.Add(myrow);


        }


        myrow = dtotherpages.NewRow();
        myrow["nameonelang"] = asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.menu.newsletter");
        myrow["link"] = "~/shop/newsletter.aspx";
        dtotherpages.Rows.Add(myrow);




        dtotherpages.DefaultView.Sort = "nameonelang";
        dlistotherpages.DataSource = dtotherpages;
        dlistotherpages.DataBind();

        // end other pages


        tBoxSearch.DataBind();
        buttCerca.DataBind();











    }





    void Page_Prerender()
    {





        // page title
        if (Page.Title == null || Page.Title.ToString() == "")
            Page.Title = filtertext.getonlyallowedcharsfortitleandmetatag(HttpContext.Current.Application["config_nomesito"].ToString());




        // metatag description
        if (Page.MetaDescription == null || Page.MetaDescription == "")
        {
            Page.MetaDescription = filtertext.getonlyallowedcharsfortitleandmetatag(
                HttpContext.Current.Application["config_metatagdescription"].ToString()
            );
        }

        // metatag keywords
        if (Page.MetaKeywords == null || Page.MetaKeywords == "")
        {
            Page.MetaKeywords = filtertext.getonlyallowedcharsfortitleandmetatag(
                HttpContext.Current.Application["config_metatagkeywords"].ToString()
            );
        }





    }
}