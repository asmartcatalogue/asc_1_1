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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" %>

<%@ MasterType VirtualPath="~/admin/admin_master.master" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="AjaxControlToolkit" %>
<%@ Import Namespace="System.IO" %>

<script runat="server">



    int idcat;
    List<string> frontlanguages;
    int idart;

    void buttinsertaddfields_click(object o, EventArgs e)
    {

        Response.Redirect(ResolveUrl("~/admin/admin_product_addfields.aspx?idart=" + idart));


    }

    public void butdelete_click(object o, EventArgs e)
    {

        asc.product.delete(idart);
        Response.Redirect(ResolveUrl("~/admin/admin_products.aspx"));




    }

    void buttmainimage_click(object o, EventArgs e)
    {

        Response.Redirect("~/admin/admin_product_mainimg.aspx?idart=" + idart.ToString());

    }



    void buttmainfeat_click(object o, EventArgs e)
    {

        Response.Redirect("~/admin/admin_product_mainfeat.aspx?idart=" + idart.ToString());

    }







    void buttzoom_click(object o, EventArgs e)
    {

        Response.Redirect("~/admin/admin_product_otherimages.aspx?idart=" + idart.ToString());

    }

    void buttrelated_click(object o, EventArgs e)
    {

        Response.Redirect("~/admin/admin_product_relatedproducts.aspx?idart=" + idart.ToString());


    }


    void buttmetatag_click(object o, EventArgs e)
    {

        Response.Redirect("~/admin/admin_product_metatag.aspx?idart=" + idart.ToString());


    }














    void Page_Load()
    {
        idart = Convert.ToInt32(Request.QueryString["idart"]);
        frontlanguages = ((Dictionary<string, string>)Application["mydictionary"]).Keys.ToList<string>(); ;


        if (idart == 0)
        {

            // I create new product

            int idartnew = 0;
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {

                cnn.Open();
                OleDbCommand cmd;
                string sql;

                sql = "select count(*) from tcategorie";
                cmd = new OleDbCommand(sql, cnn);
                int quanteCat = Convert.ToInt32(cmd.ExecuteScalar());
                if (quanteCat < 1)
                {
                    asc.problema.redirect(asc.language.getforadminfromdictionary("admin.product.error.must.create.one.category"));
                }

                sql = "SELECT MIN(cat_id) FROM tcategorie";
                cmd = new OleDbCommand(sql, cnn);
                int minidcat = (int)cmd.ExecuteScalar();


                sql = "INSERT INTO tproducts (art_idcat, art_rawprice, art_metadescription, art_metakeywords)" +
                        " values " +
                        " ( @minidcat, -1, @metadesc, @metakeyw)";
                cmd = new OleDbCommand(sql, cnn);
                cmd.Parameters.AddWithValue("minidcat", minidcat);
                cmd.Parameters.AddWithValue("metadesc", asc.language.getforfrontfromdictionaryindefaultlanguage("admin.product.default.metatag.description"));
                cmd.Parameters.AddWithValue("metakeyw", "{product_name}, {product_category}, {product_brand}, {site_name}");
                cmd.ExecuteNonQuery();

                sql = "SELECT MAX(art_id) FROM tproducts";
                cmd = new OleDbCommand(sql, cnn);
                idartnew = (int)cmd.ExecuteScalar();




                // produce un codice product automatico diverso da tutti gli altri
                sql = "SELECT COUNT(*) FROM tproducts where art_cod=@cod";
                cmd = new OleDbCommand(sql, cnn);
                cmd.Parameters.Add(new OleDbParameter("cod", idartnew.ToString()));
                int quantiCodiciUgualiPresenti = Convert.ToInt32(cmd.ExecuteScalar());

                string codiceAutomatico = idartnew.ToString();
                if (quantiCodiciUgualiPresenti > 0) codiceAutomatico += ("_" + (quantiCodiciUgualiPresenti + 1).ToString());

                sql = "update tproducts set art_cod=@cod where art_id=@idart";
                cmd = new OleDbCommand(sql, cnn);
                cmd.Parameters.Add(new OleDbParameter("cod", codiceAutomatico));
                cmd.Parameters.Add(new OleDbParameter("idart", idartnew.ToString()));
                cmd.ExecuteNonQuery();
                // *******************************************************************
            }
            // now I reload
            Response.Redirect("admin_product.aspx?idart=" + idartnew.ToString());



        }
        else
        {


            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
    " &raquo; " +
    "<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.products") + "</a>" +
    " &raquo; " +
    asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idart;

            buttrelated.Text = asc.language.getforadminfromdictionary("admin.product.button.related.articles");
            buttonZoom.Text = asc.language.getforadminfromdictionary("admin.product.button.large.images");
            buttopen.Text = asc.language.getforadminfromdictionary("admin.product.button.open.product.page");
            buttdelete.Attributes["onclick"] = "return confirm ('" + asc.language.getforadminfromdictionary("admin.product.confirm.deletion") + "')";
            buttdelete.Text = asc.language.getforadminfromdictionary("common.button.delete");
            buttmainfeat.Text = asc.language.getforadminfromdictionary("admin.product.button.main.features");
            buttmainimage.Text = asc.language.getforadminfromdictionary("admin.product.main.image");
            buttinsertaddfields.Text = asc.language.getforadminfromdictionary("admin.product.insert.additional.fields");
            buttmetatag.Text = asc.language.getforadminfromdictionary("admin.product.metatag");
            if (!IsPostBack)
            {
                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    cnn.Open();
                    string tokensartname = (string)asc.helpDb.getScalarByOpenCnn(cnn, "select art_name from tproducts where art_id=@idart", new OleDbParameter("idart", idart));
                    for (int rip = 0; rip < frontlanguages.Count; rip++)
                    {
                        if (asc.language.getfromstringandlanguagename(tokensartname, frontlanguages[rip]) == "") tokensartname = asc.language.addorupdateonetoken_and_removetokenswihoutwords(tokensartname, frontlanguages[rip], idart.ToString());
                    }
                    asc.helpDb.nonQueryByOpenCnn(cnn, "update tproducts set art_name=@name where art_id=@idart", new OleDbParameter("@name", tokensartname), new OleDbParameter("idart", idart));
                }

            }
        }

    }




</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server">
    <script type="text/javascript">
        function doopenwindow() {

            window.open('<%=ResolveUrl("~/admin/admin_artpreview.aspx?id=" + idart)%>');

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










    <form enctype="multipart/form-data" runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>



        <div align="left" style="font-size: 15px; color: Red; font-weight: bold">
            <asp:Label ID="lblerr" runat="server" />
        </div>


        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idart%>
        </div>
        <p></p>
        <img src=<%=ResolveUrl("~/image.aspx?type=0&id=" + idart.ToString())  %> alt="" width="60" />
        <p></p>
        <asp:LinkButton runat="server" OnClick="buttmainfeat_click" ID="buttmainfeat" /><p></p>
        <asp:LinkButton runat="server" OnClick="buttmainimage_click" ID="buttmainimage" /><p></p>
        <asp:LinkButton runat="server" OnClick="buttinsertaddfields_click" ID="buttinsertaddfields" /><p></p>
        <asp:LinkButton runat="server" OnClick="buttzoom_click" ID="buttonZoom" /><p></p>
        <asp:LinkButton runat="server" OnClick="buttrelated_click" ID="buttrelated" /><p></p>
        <asp:LinkButton runat="server" OnClick="buttmetatag_click" ID="buttmetatag" /><p></p>
        <asp:LinkButton runat="server" OnClick="butdelete_click" ID="buttdelete" /><p></p>
        <asp:LinkButton runat="server" ID="buttopen" OnClientClick="doopenwindow();return true" /><p></p>
        <p></p>
        <p></p>




    </form>
</asp:Content>
