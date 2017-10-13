using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.OleDb;
using System.Data;
using System.Web.UI.HtmlControls;
using asc;

public partial class articolipertermine : System.Web.UI.Page
{
    int artPerPag;
    string termineIn;
    int pageIn;


    public void change(object o, EventArgs e)
    {
        datapager.SetPageProperties(0, datapager.PageSize, false);

        bindArticoli();
    }


    public void ListView1_PagePropertiesChanging(object o, PagePropertiesChangingEventArgs e)
    {

        datapager.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);

        bindArticoli();

    }

    public void listaarticoli_databound(object sender, ListViewItemEventArgs e)
    {
        if (e.Item.ItemType == ListViewItemType.DataItem)
        {

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
    }

    void bindArticoli()
    {



        datapager.PageSize = (int)Application["config_artPerPag"];


        DataTable dt = new DataTable();





        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            string sql =
" SELECT " + asc.products.commaseparatedfields + " from tproducts WHERE art_visibile=1 AND art_name like @termine"; 


            OleDbParameter myParameter = new OleDbParameter();
            myParameter.ParameterName = "@termine";
            myParameter.Value = "%" + termineIn + "%";

            List<product> l = asc.products.get(sql, myParameter);    

            if (l.Count > 0)
            {
                listaarticoli.DataSource = l;
                listaarticoli.DataBind();
            }
        }



        //**************





    }





    void Page_Load()
    {

        string worktitle =
             asc.language.getforfrontfromdictionaryindefaultlanguage("resultsearch.you.are.here.search") +
             " | " + Application["config_nomesito"].ToString();
        Page.Title = asc.filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);


        artPerPag = (int)Application["config_artPerPag"];
        Label lblbreadcrumbsMaster = (Label)(Master.FindControl("lblbreadcrumbs"));
        lblbreadcrumbsMaster.Text = 
            common.linkescaped(
                asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home"), "main.aspx", "breadcrumbs"
            ) +
            "&nbsp;&raquo;&nbsp;" + asc.language.getforfrontfromdictionaryincurrentlanguage("resultsearch.label.search.results");

        if (Request.QueryString["termine"] == null || Request.QueryString["termine"] == "" || Request.QueryString["termine"].ToString().Length < 3)
        {
            lblerr.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("resultsearch.warning.type.more.characters.to.find");

        }
        else
        {

            termineIn = (string)Request.QueryString["termine"];

            lblbreadcrumbsMaster.Text += " " + asc.language.getforfrontfromdictionaryincurrentlanguage("resultsearch.label.for") + " <b>" + asc.sicurezza.xss.getreplacedencoded(termineIn) + "</b>";



            bindArticoli();
            if (!IsPostBack)
            {
                Page.Title = asc.language.getforfrontfromdictionaryindefaultlanguage("resultsearch.title");



            }
        }
    }





}