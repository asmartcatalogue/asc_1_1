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
    using System.Collections;
    using System.Collections.Generic;
    using System.Data;
    using System.Data.OleDb;
    using System.Web;
    using System.Web.UI;
    using System.Web.UI.HtmlControls;
    using System.Web.UI.WebControls;
    using System.Linq;

    public partial class behindPreviewAspx : Page
    {

        public int a = 0;
        protected int idCatSelected;
        int page = 1;
        string brand = "-1";
        int ord = -1;
        string sqlord = "art_id";



        public void dlistsubcat_databound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                DataRow dr = (DataRow)e.Item.DataItem;

                ((HtmlAnchor)e.Item.FindControl("ancorImg")).HRef = asc.Category.Linkforrouting((int)dr["cat_id"], (string)dr["cat_nome"]);
                ((HyperLink)e.Item.FindControl("linknamesubcat")).Text = asc.language.getforfrontfromstringincurrentlanguage((string)dr["cat_nome"]);
                ((HyperLink)e.Item.FindControl("linknamesubcat")).NavigateUrl = ((HtmlAnchor)e.Item.FindControl("ancorImg")).HRef;
                ((HtmlImage)e.Item.FindControl("imgcat")).Src = "~/image.aspx?type=1&id=" + dr["cat_id"].ToString();

            }
        }


        public void gocart_click(object o, EventArgs e)
        {

            Response.Redirect(ResolveUrl("~/shop/cart.aspx"));
        }


        public void proseguipaginaprodotto_click(object o, EventArgs e)
        {

            Response.Redirect(((Button)o).CommandArgument);
        }










        public void listaarticoli_databound(object sender, ListViewItemEventArgs e)
        {
            // sane
            if (e.Item.ItemType == ListViewItemType.DataItem)
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





                Label lblPrezzoArticolo = ((Label)e.Item.FindControl("lblPrezzo"));



                lblPrezzoArticolo.Text = myproduct.Finalpriceformatted;


            }
        }
























        void Page_Load()
        {
            if (!Int32.TryParse((string)Page.RouteData.Values["idCatselected"], out idCatSelected))
                throw new Exception();

            DataTable dtcat = (DataTable)Application["dtcat"];
            DataRow r = dtcat.Rows.Find(idCatSelected);
            if (r == null)
            {
                HttpContext.Current.Response.Status = "404 Not Found";
                HttpContext.Current.Response.StatusCode = 404;
                HttpContext.Current.Response.End();

            }
            else
            {



                List<DataRow> ParentCatsIncludingCurrent = new List<DataRow>();




                // breadcrumbs & title & metatag


                int loopidcat = idCatSelected;
                while (true)
                {
                    DataRow foundrow = dtcat.Rows.Find(loopidcat);
                    ParentCatsIncludingCurrent.Add(foundrow);
                    if ((int)foundrow["cat_idpadre"] == 0) break;
                    loopidcat = (int)foundrow["cat_idpadre"];
                }
                Label lblbreadcrumbsMaster = (Label)(Page.Master.FindControl("lblbreadcrumbs"));
                lblbreadcrumbsMaster.Text += common.linkescaped(asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home"), ResolveUrl("~/shop/main.aspx"), "breadcrumbs");

                for (int rip = ParentCatsIncludingCurrent.Count - 1; rip >= 0; rip--)
                {
                    if (rip > 0)
                    {
                        lblbreadcrumbsMaster.Text +=
                            "&nbsp;&raquo;&nbsp;" +
                            common.linkescaped(
                                asc.language.getforfrontfromstringincurrentlanguage(ParentCatsIncludingCurrent[rip]["cat_nome"].ToString()),
                                Category.Linkforrouting((int)ParentCatsIncludingCurrent[rip]["cat_id"], (string)ParentCatsIncludingCurrent[rip]["cat_nome"]),
                                "breadcrumbs"
                            );
                    }
                    else
                    {
                        lblbreadcrumbsMaster.Text += "&nbsp;&raquo;&nbsp;" + asc.language.getforfrontfromstringincurrentlanguage(ParentCatsIncludingCurrent[rip]["cat_nome"].ToString());
                    }
                }


                // page title
                string worktitle = "";
                for (int rip = ParentCatsIncludingCurrent.Count - 1; rip >= 0; rip--)
                {
                    if (worktitle.Length > 0) worktitle += " - ";
                    worktitle += asc.language.getforfrontfromstringindefaultlanguage(ParentCatsIncludingCurrent[rip]["cat_nome"].ToString());
                }
                worktitle += " | " + Application["config_nomesito"].ToString();
                Page.Title = asc.filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);

                Page.MetaDescription = asc.filtertext.getonlyallowedcharsfortitleandmetatag(
                    ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_metadescription"].ToString()
                    .Replace(
                        "{category_name}",
                        asc.language.getforfrontfromstringindefaultlanguage(ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_nome"].ToString()))
                    .Replace(
                        "{site_name}",
                        Application["config_nomesito"].ToString())

                );

                Page.MetaKeywords = asc.filtertext.getonlyallowedcharsfortitleandmetatag(
                    ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_metakeywords"].ToString()
                    .Replace(
                        "{category_name}",
                        asc.language.getforfrontfromstringindefaultlanguage(ParentCatsIncludingCurrent[ParentCatsIncludingCurrent.Count - 1]["cat_nome"].ToString()))
                    .Replace(
                        "{site_name}",
                        Application["config_nomesito"].ToString())

                );



                // categories/subcategories


                if (idCatSelected > 0)
                {


                    var listchildcats = (from row in dtcat.AsEnumerable()
                                         where row.Field<int>("cat_idpadre") == idCatSelected
                                         orderby (asc.language.getforfrontfromstringincurrentlanguage(row.Field<string>("cat_nome")))
                                         select row).ToList<DataRow>();



                    if (listchildcats.Count > 0)
                    {
                        dlistsubcat.DataSource = listchildcats;
                        dlistsubcat.DataBind();
                        panelsubcat.Visible = true;

                    }
                }






                // products in category
                if (Request.QueryString["page"] != null) page = Convert.ToInt32(Request.QueryString["page"].ToString());
                if (Request.QueryString["ord"] != null) ord = int.Parse(Request.QueryString["ord"]);


                dlistord.Items.Add(new ListItem(asc.language.getforfrontfromdictionaryincurrentlanguage("preview.products.orderbyselect.order.by"), "-1"));
                dlistord.Items.Add(new ListItem(asc.language.getforfrontfromdictionaryincurrentlanguage("preview.products.orderbyselect.order.by.price.ascending"), "0"));
                dlistord.Items.Add(new ListItem(asc.language.getforfrontfromdictionaryincurrentlanguage("preview.products.orderbyselect.order.by.price.descending"), "1"));
                dlistord.SelectedValue = ord.ToString();
                dlistord.Attributes["onLoad"] = "focus.blur()";


                string sql = "select " + asc.products.commaseparatedfields + " from tproducts where art_idcat=@idcat and art_visibile=1";
                switch (ord)
                {
                    case 0:
                        sql += " order by art_rawprice*(1-art_discount/100)";
                        break;

                    case 1:
                        sql += " order by art_rawprice*(1-art_discount/100) desc";
                        break;
                    default:
                        sql += " order by art_id";
                        break;
                }

                List<asc.product> l = asc.products.get(sql, new OleDbParameter("idcat", idCatSelected));

                int howmany = l.Select(p => p.Id).Count();

                if (howmany > 0)
                {

                    var l1 = l.Skip((page - 1) * (int)Application["config_artPerPag"]).Take((int)Application["config_artPerPag"]);

                    if (l1.Any())
                    {
                        panelArticoli.Visible = true;
                        list.DataSource = l1;
                        list.DataBind();

                        // show pager
                        int restoZeroUno = (howmany % (int)Application["config_artPerPag"] > 0) ? 1 : 0;
                        int totPag = (int)(restoZeroUno + Math.Floor((double)howmany / (int)Application["config_artPerPag"]));
                        for (int a = 1; a <= totPag; a++)
                        {
                            if (page == a)
                            {
                                lblpaging.Text += " <span class='paging'>" + Convert.ToString(a) + "</span> ";
                            }
                            else
                            {

                                lblpaging.Text += "<span class='paging'>" + asc.common.linkescaped(
                                        Convert.ToString(a),
                                        asc.Category.Linkforrouting((int)ParentCatsIncludingCurrent[0]["cat_id"], (string)ParentCatsIncludingCurrent[0]["cat_nome"]) + "?nosense=1" + "&page=" + a + "&ord=" + ord.ToString(), "paging"
                                ) + "</span> ";

                            }
                        }
                    }
                }
            }
        }
    }
}


