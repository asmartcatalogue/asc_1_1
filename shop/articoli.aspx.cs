// articoli.aspx.cs

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


namespace asc
{
    using System;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.WebControls;
    using System.Web.UI.HtmlControls;
    using System.Data.OleDb;
    using System.Data;
    using System.Collections.Generic;
    public partial class behindArticoliAspx : Page
    {







        public asc.product product;
        asc.Category cat;

        public int a = 0;
        public int c = 0;

        int idart;


        public string title;
        public string description;






        public void buttinfo_click(object o, EventArgs e)
        {
            lblerrinfo.Text = "";
            tabcontainer.ActiveTabIndex = (tabcontainer.Tabs.Count - 1);


            string fromemail = tboxinfoemail.Text.Trim();
            bool isvalidemail = true;

            try
            {
                var workemail = new System.Net.Mail.MailAddress(fromemail);
            }
            catch
            {
                isvalidemail = false;

            }

            if (!isvalidemail)
            {
                lblerrinfo.Text += asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.invalid.email.format");
            }

            if (tboxinfosubject.Text.Trim() == "")
            {

                lblerrinfo.Text += "<br>" + asc.language.getforfrontfromstringincurrentlanguage("product.request.info.missing.subject");
            }

            if (tboxinfoname.Text.Trim() == "")
            {

                lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.missing.name");
            }

            if (tareainfo.InnerText.Trim() == "")
            {

                lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.missing.body");
            }
            if (!cboxprivacy.Checked)
            {

                lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.missing.consent");
            }

            if (lblerrinfo.Text.Length == 0)
            {

                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    string sql = "insert into trequests (r_when, r_subject, r_name, r_email, r_body) values (@when, @subject, @name, @email, @body)";

                    asc.helpDb.nonQuery(
                        sql,
                        new OleDbParameter("when", System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")),
                        new OleDbParameter("subject", tboxinfosubject.Text),
                        new OleDbParameter("name", tboxinfoname.Text),
                        new OleDbParameter("email", tboxinfoemail.Text),
                        new OleDbParameter("body", tareainfo.InnerText)
                        );
                }



                string to = System.Configuration.ConfigurationManager.AppSettings["youremail"];
                string from = Server.HtmlEncode(tboxinfoemail.Text.Trim());
                string subject = Server.HtmlEncode(tboxinfosubject.Text.Trim());
                string body = Server.HtmlEncode(tareainfo.InnerText.Trim());

                try
                {
                    asc.email.send(from, to, subject, body, true);

                }
                catch (Exception E)
                {  }

                lblerrinfo.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.message.sent");
                lblerrinfo.ForeColor = System.Drawing.Color.Blue;



            }

        }

        public void listsecondaryimages_databound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string text = asc.language.getforfrontfromstringincurrentlanguage(((DataRowView)e.Item.DataItem)["z_text"].ToString());

                HtmlImage img = (HtmlImage)e.Item.FindControl("secondaryimage");
                string imgpath = ResolveUrl("~/image.aspx?type=2&id=" + ((DataRowView)e.Item.DataItem)["z_id"].ToString() + "&idart=" + idart.ToString());
                img.Src = imgpath;
                string w = ((DataRowView)e.Item.DataItem)["z_w"].ToString();
                string h = ((DataRowView)e.Item.DataItem)["z_h"].ToString();

                HtmlAnchor anchorsecondaryimage = (HtmlAnchor)e.Item.FindControl("anchorsecondaryimage");
                anchorsecondaryimage.Attributes["onclick"] =
                    "$('#modaltable').show(); jQuery('#maintable').css('opacity', '0.6');" +
                     "jQuery('#modalid').html(\"" +
                     "<img src='" + imgpath + "' style='max-width:1200px' /><p></p>" +
                     (text == "" ? "" : HttpUtility.JavaScriptStringEncode(text)) +
                     "\")" +
                    ";return false";


                tabpanelsecondayimages.Visible = true;
            }
        }
        public void listrelatedproucts_databound(object sender, RepeaterItemEventArgs e)
        {


            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {


                asc.product myproduct = (asc.product)e.Item.DataItem;



                HtmlImage img = (HtmlImage)e.Item.FindControl("img");


                img.Alt = String.Format(
                        asc.language.getforfrontfromdictionaryincurrentlanguage("preview.products.tooltip.see.details"),
                        myproduct.Nameforfrontincurrentlanguage);

                img.Src = "~/image.aspx?type=0&id=" + myproduct.Id.ToString();
                ((HtmlAnchor)e.Item.FindControl("linkimg")).HRef = ResolveUrl(myproduct.Linkart);

                HyperLink linkartname = ((HyperLink)e.Item.FindControl("linkartname"));
                linkartname.Text = myproduct.Nameforfrontincurrentlanguage;
                linkartname.NavigateUrl = ResolveUrl(myproduct.Linkart);
                linkartname.ToolTip = String.Format(
                        asc.language.getforfrontfromdictionaryincurrentlanguage("preview.products.tooltip.see.details"),
                        myproduct.Nameforfrontincurrentlanguage);








                Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblPrezzoArticolo"));


                lblPrezzoArticolo.Text = myproduct.Finalpriceformatted;

            }
        }
















        void Page_Load()
        {
            idart = Convert.ToInt32(Page.RouteData.Values["idart"]);
            string sql0 = "select " + asc.products.commaseparatedfields + " from tproducts where art_id=@idart";
            List<product> l = asc.products.get(sql0, new OleDbParameter("idart", idart));
            if (l.Count < 1)
            {
                HttpContext.Current.Response.Status = "404 Not Found";
                HttpContext.Current.Response.StatusCode = 404;
                HttpContext.Current.Response.End();

            }
            else
            {
                product = l[0];

                lblprodname.Text = product.Nameforfrontincurrentlanguage;

                lblCodArticolo.Text = product.Code;

                string artdescription = asc.language.getforfrontfromstringincurrentlanguage(product.Description);

                if (artdescription != "")
                {
                    lblDescrizioneArticolo.Text = artdescription;
                    tabpaneldescrizione.Visible = true;
                }



                string brand = product.Brand;
                if (brand != "")
                {
                    lblbrand.Text = brand;
                    pholderbrand.Visible = true;
                }

                mainimg.Src = ResolveUrl("~/image.aspx?type=0&id=" + idart.ToString());

                // show.product.price




                if (product.Finalpriceformatted=="") pholderprice.Visible = false;
                lblPrezzoArticolo.Text = product.Finalpriceformatted;

                


                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    OleDbCommand cmd;
                    OleDbDataReader dr;
                    cnn.Open();



                    // additional fields
                    string sql1 = "select b.value as b_value, a.name as a_name from tadditionalfields a inner join tadditionalfields_tarticoli b on a.id = b.idfield where b.idart = @idart order by a.id";
                    cmd = new OleDbCommand(sql1, cnn);
                    cmd.Parameters.AddWithValue("idart", idart);
                    dr = cmd.ExecuteReader();
                    while (dr.Read())
                    {
                        string addfieldvalue = asc.language.getforfrontfromstringincurrentlanguage(dr["b_value"].ToString());
                        if (addfieldvalue != "")
                            lbladdfields.Text += "<div class='feature'><b>" + asc.language.getforfrontfromstringincurrentlanguage(dr["a_name"].ToString()) + "</b>: " + addfieldvalue + "</div>";

                    }


                    // other images
                    string sql2 = "SELECT z_id, z_text, z_w, z_h FROM tzoom WHERE z_idart=@idart ORDER BY z_id";
                    cmd = new OleDbCommand(sql2, cnn);
                    cmd.Parameters.AddWithValue("idart", idart);
                    dr = cmd.ExecuteReader();
                    DataTable workdt = new DataTable();
                    workdt.Load(dr);
                    dr.Close();
                    if (workdt.Rows.Count > 0)
                    {
                        listsecondaryimages.DataSource = workdt;
                        listsecondaryimages.DataBind();
                    }

                }

                // related products
                string sql3 = "SELECT " + asc.products.commaseparatedfields + " from tcorrelati c inner join tproducts a on a.art_id=c.idartcorr where idart=@idart and art_visibile=1";
                List<product> lrelprods = asc.products.get(sql3, new OleDbParameter("idart", idart));
                if (lrelprods.Count > 0)
                {
                    tabpanelrelatedproducts.Visible = true;
                    listrelatedproucts.DataSource = lrelprods;
                    listrelatedproucts.DataBind();
                }





                buttinfo.DataBind();

                if (!Page.IsPostBack)
                {

                    // request info module
                    tboxinfosubject.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.subject.predefined") + " " + product.Code;


                    // aggiunge product alla coda articoli gia visti
                    List<product> coda = (List<product>)Session["coda"];
                    foreach (product a in coda)
                    {
                        if (a.Id == idart)
                        {
                            coda.Remove(a);
                            break;
                        }
                    }
                    coda.Add(product);
                    if (coda.Count >= 4) coda.RemoveAt(0);
                    Session["coda"] = coda;
                    Session["lastVisit"] = HttpContext.Current.Request.RawUrl;

                }












                //}
                // end product details ****************************************************************************************************



                Page.Header.DataBind();
                Label lblbreadcrumbsMaster = (Label)(Master.FindControl("lblbreadcrumbs"));

                int idcat = product.Idcat;

                DataTable dtcat = (DataTable)Application["dtcat"];
                List<DataRow> ParentCatsIncludingCurrent = new List<DataRow>();
                int loopidcat = idcat;
                while (true)
                {
                    DataRow foundrow = dtcat.Rows.Find(loopidcat);
                    ParentCatsIncludingCurrent.Add(foundrow);

                    if ((int)foundrow["cat_idpadre"] == 0) break;
                    loopidcat = (int)foundrow["cat_idpadre"];
                }

                // output where are you **************************************************************************************************************
                lblbreadcrumbsMaster.Text = common.linkescaped(asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home"), ResolveUrl("~/shop/main.aspx"), "breadcrumbs");
                for (int rip = ParentCatsIncludingCurrent.Count - 1; rip >= 0; rip--)
                {
                    lblbreadcrumbsMaster.Text +=
    "&nbsp;&raquo;&nbsp;" +
    "<a class=breadcrumbs" +
    " href='" + asc.Category.Linkforrouting((int)ParentCatsIncludingCurrent[rip]["cat_id"], (string)ParentCatsIncludingCurrent[rip]["cat_nome"]) + "'>" +
    asc.language.getforfrontfromstringincurrentlanguage(ParentCatsIncludingCurrent[rip]["cat_nome"].ToString()) +
    "</a>";
                }
                lblbreadcrumbsMaster.Text += "&nbsp;&raquo;&nbsp;<span class='breadcrumbs'>" + product.Nameforfrontincurrentlanguage + "</span>";
                // *************************************************************************************************************************************


                // page title
                string worktitle = "";
                worktitle = asc.language.getforfrontfromstringindefaultlanguage(product.Namealllang) + " | " + Application["config_nomesito"].ToString();
                Page.Title = filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);


                Page.MetaDescription =
                    filtertext.getonlyallowedcharsfortitleandmetatag(
                        product.Metadescription
                            .Replace("{site_name}", Application["config_nomesito"].ToString())
                            .Replace("{product_name}", asc.language.getfromstringandlanguagename(product.Namealllang, System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]))
                            .Replace(
                                "{product_category}",
                                asc.language.getfromstringandlanguagename(ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_nome"].ToString(), System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]))
                            .Replace("{product_brand}", product.Brand
                        )
                    );


                // meta keywords
                Page.MetaKeywords =
                    filtertext.getonlyallowedcharsfortitleandmetatag(
                        product.Metakeywords
                            .Replace("{site_name}", Application["config_nomesito"].ToString())
                            .Replace("{product_name}", asc.language.getfromstringandlanguagename(product.Namealllang, System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]))
                            .Replace("{product_category}", asc.language.getfromstringandlanguagename(ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_nome"].ToString(), System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]))
                            .Replace("{product_brand}", product.Brand
                        )
                    );




            }

        } // page load


















    }

}


