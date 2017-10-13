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

<script runat="server">



    int idcat;
    List<string> frontlanguages;
    System.Collections.ArrayList arrCatDb = new System.Collections.ArrayList();
    int idart;

    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bindtoviewstate();


    }
    void updateorigin()
    {

        ViewState["nametokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["nametokens"].ToString(), ViewState["l"].ToString(), tboxname.Text);
        ViewState["descriptiontokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["descriptiontokens"].ToString(), ViewState["l"].ToString(), tareadescription.InnerText);

    }

    void bindtoviewstate()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }


        tboxname.Text = asc.language.getfromstringandlanguagename(ViewState["nametokens"].ToString(), ViewState["l"].ToString());
        tareadescription.InnerHtml = asc.language.getfromstringandlanguagename(ViewState["descriptiontokens"].ToString(), ViewState["l"].ToString());

    }

    void bind()
    {

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();
            string sql;
            OleDbCommand cmd;


            sql =
@"SELECT 
 art_cod
,art_idcat
,art_brand
,art_visibile
,art_rawprice,art_discount, art_pricestartingfrom, art_taxnotappliable
FROM tproducts WHERE art_id=@idart";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@idart", idart));
            OleDbDataReader dr = cmd.ExecuteReader();
            dr.Read();
            cBoxVisibile.Checked = (dr["art_visibile"].ToString()=="1");
            idcat = (int)dr["art_idcat"];
            dListCatSottocat.SelectedValue = idcat.ToString();
            cboxpricestartingfrom.Checked = dr["art_pricestartingfrom"].ToString() == "1";
            tBoxMarca.Text = dr["art_brand"].ToString();
            tBoxCod.Text = dr["art_cod"].ToString();
            tBoxPrezzoIns0.Text = dr["art_rawprice"].ToString();
            tBoxScontoList0.Text = dr["art_discount"].ToString();
            cboxnotax.Checked = dr["art_taxnotappliable"].ToString()=="1";
            dr.Close();

        }














    }


    bool validaInput()
    {

        lblerr.Text = "";

        bool inputValido = true;
        int quanti = 0;
        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {

            cnn.Open();
            OleDbCommand cmd;
            string sql = "SELECT COUNT(*) FROM tproducts where art_cod=@cod and art_id<>@idart";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@cod", tBoxCod.Text));
            cmd.Parameters.Add(new OleDbParameter("@idart", idart));
            quanti = Convert.ToInt32(cmd.ExecuteScalar());

        }

        if (quanti > 0)
        {
            string msg = asc.language.getforadminfromdictionary("admin.product.error.code.exists");
            asc.common.jquerymodalmessage(this.Page, msg);
            inputValido = false;
        }





        if (tBoxCod.Text.Length > asc.common.maxLenCod)
        {

            string msg = String.Format(asc.language.getforadminfromdictionary("admin.products.max.allowed.characters.for.code"), asc.common.maxLenCod);
            asc.common.jquerymodalmessage(this.Page, msg);
            inputValido = false;

        }
        if (tBoxMarca.Text.Length > asc.common.maxLenMarca)
        {

            string msg = String.Format(asc.language.getforadminfromdictionary("admin.products.max.allowed.characters.for.brand"), asc.common.maxLenMarca);
            asc.common.jquerymodalmessage(this.Page, msg);
            inputValido = false;
        }



        TextBox ControlPrezzo = tBoxPrezzoIns0;
        TextBox ControlSconto = tBoxScontoList0;

        try { double prezzo = double.Parse(ControlPrezzo.Text, asc.admin.localization.primarynumberformatinfo); }
        catch
        {

            string msg = "\\n" + asc.language.getforadminfromdictionary("admin.product.insert.a.number.for.price.field");
            asc.common.jquerymodalmessage(this.Page, msg);
            inputValido = false;
        }

        try
        {
            double sconto = double.Parse(ControlSconto.Text, asc.admin.localization.primarynumberformatinfo);
        }
        catch
        {
            string msg = "\\n" + asc.language.getforadminfromdictionary("admin.product.insert.a.number.for.discount.field");
            asc.common.jquerymodalmessage(this.Page, msg);
            inputValido = false;
        }



        return inputValido;
    }



















    void buttAggiorna_click(object sender, EventArgs e)
    {


        //valida input
        if (!validaInput()) return;

        updateorigin();


        string nametokens = ViewState["nametokens"].ToString();

        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            if (asc.language.getfromstringandlanguagename(nametokens, frontlanguages[rip]) == "")
                nametokens = asc.language.addorupdateonetoken_and_removetokenswihoutwords(nametokens, frontlanguages[rip], idart.ToString());
        }


        string marca = tBoxMarca.Text;
        string descriptiontokens = ViewState["descriptiontokens"].ToString();




        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ToString()))
        {
            cnn.Open();



            TextBox ControlPrezzo = tBoxPrezzoIns0;
            TextBox ControlSconto = tBoxScontoList0;

            double price = double.Parse(ControlPrezzo.Text, asc.admin.localization.primarynumberformatinfo);
            double discount = double.Parse(ControlSconto.Text, asc.admin.localization.primarynumberformatinfo);

            string cod = tBoxCod.Text;
            int visibile = cBoxVisibile.Checked ? 1 : 0;
            int cat = int.Parse(dListCatSottocat.SelectedValue);
            int pricestartingfrom = (cboxpricestartingfrom.Checked ? 1 : 0);
            int taxnotappliable = (cboxnotax.Checked ? 1 : 0);

            OleDbCommand cmd;
            string sql;

            sql = "UPDATE tproducts" +
            " SET  art_cod=@cod, art_idcat=@idcat, art_name=@name, art_description=@description" +
            ", art_brand=@marca" +
            ", art_visibile=@visibile" +
            ", art_rawprice=@price, art_discount=@discount, art_pricestartingfrom=@pricestartingfrom, art_taxnotappliable=@taxnotappliable" +
            " WHERE art_id=@idart";
            cmd = new OleDbCommand(sql, cnn);


            cmd.Parameters.Add(new OleDbParameter("@cod", cod));
            cmd.Parameters.Add(new OleDbParameter("@idcat", cat));
            cmd.Parameters.Add(new OleDbParameter("@name", nametokens));
            cmd.Parameters.Add(new OleDbParameter("@description", descriptiontokens));
            cmd.Parameters.Add(new OleDbParameter("@marca", marca));
            cmd.Parameters.Add(new OleDbParameter("@visibile", visibile));
            cmd.Parameters.Add(new OleDbParameter("@price", price));
            cmd.Parameters.Add(new OleDbParameter("@discount", discount));
            cmd.Parameters.Add(new OleDbParameter("@pricestartingfrom", pricestartingfrom));
            cmd.Parameters.Add(new OleDbParameter("@taxnotappliable", taxnotappliable));
            cmd.Parameters.AddWithValue("@idart", idart);
            cmd.ExecuteNonQuery();

        }



        Response.Redirect(Request.Url.AbsoluteUri);
    }



    void Page_Init()
    {

        idart = Convert.ToInt32(Request.QueryString["idart"]);
        if (idart == 0) Response.Redirect("~/admin/admin_products.aspx");

        frontlanguages = ((Dictionary<string, string>)Application["mydictionary"]).Keys.ToList<string>(); ;

        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            Button b = new Button();
            b.CommandArgument = frontlanguages[rip];
            b.Text = frontlanguages[rip];
            b.Click += new EventHandler(changelanguageclick);
            panellanguages.Controls.Add(b);

        }







    }








    void Page_Load()
    {


        if (!Page.IsPostBack)
        {
            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
" &raquo; " +
"<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.products") + "</a>" +
" &raquo; " +
"<a href='admin_product.aspx?idart=" + idart + "'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idart + "</a>" +
" &raquo; " +
asc.language.getforadminfromdictionary("admin.product.where.you.are.main.features");

            // dlistcategory *****************************************************************************
            int quanteCat = 0;
            DataTable dtcat = (DataTable)Application["dtcat"];

            foreach (DataRow row in dtcat.Rows)
            {
                ArrayList arcatid = new ArrayList();
                ArrayList arcatname = new ArrayList();

                arcatid.Add((int)row["cat_id"]);
                arcatname.Add(asc.language.getforadminfromstring((string)row["cat_nome"]));
                int x = (int)row["cat_idpadre"];
                bool loop = true;
                while (loop)
                {

                    DataRow drfound = dtcat.Rows.Find(x);
                    if (drfound == null) loop = false;
                    else
                    {
                        x = (int)drfound["cat_idpadre"];
                        arcatid.Add((int)drfound["cat_id"]);
                        arcatname.Add(asc.language.getforadminfromstring((string)drfound["cat_nome"]));
                    }
                }
                arcatid.Reverse();
                arcatname.Reverse();
                string path = "";
                for (int rip = 0; rip < arcatid.Count; rip++)
                {
                    if (path.Length > 0) path += "-->";
                    path += (string)arcatname[rip];
                }
                dListCatSottocat.Items.Add(new ListItem(path, row["cat_id"].ToString()));
                quanteCat++;

            }


            if (quanteCat == 0 && idart == 0)
                asc.problema.redirect(
    asc.language.getforadminfromdictionary("admin.product.error.must.create.one.category")
    , "admin_products.aspx");

            // end dlistcategory ************************************************************************************************************




            buttAggiorna.Text = asc.language.getforadminfromdictionary("admin.product.button.save");
            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];


            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                cnn.Open();

                ViewState["nametokens"] = (string)asc.helpDb.getScalarByOpenCnn(cnn, "select art_name from tproducts where art_id=@idart", new OleDbParameter("idart", idart));
                ViewState["descriptiontokens"] = (string)asc.helpDb.getScalarByOpenCnn(cnn, "select art_description from tproducts where art_id=@idart", new OleDbParameter("idart", idart));


            }
            bindtoviewstate();
            bind();


        }


    }



</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server">
    <script type="text/javascript">
        function doopenwindow() {

            window.open('<%=ResolveUrl("~/admin/admin_artpreview.aspx?idart=" + idart)%>');

        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>

        <div class="big">
            <%= asc.language.getforadminfromdictionary("admin.product.where.you.are.main.features")%>
        </div>

        <div align="left" style="font-size: 15px; color: Red; font-weight: bold">
            <asp:Label ID="lblerr" runat="server" />
        </div>



        <div>

            <asp:LinkButton ID="buttAggiorna" OnClick="buttAggiorna_click" runat="server" />
            <p></p>
            <asp:Panel runat="server" ID="panellanguages" />
            <p></p>

        </div>
        <table align="center" cellpadding="5" cellspacing="1" border="0" width="100%">


            <!-- here i define width of columns-->
            <tr class="admin_sfondo">
                <td><%=asc.language.getforadminfromdictionary("admin.product.visible") %>&nbsp;&nbsp;</td>
                <td>
                    <asp:CheckBox EnableViewState="false" ID="cBoxVisibile" runat="server" />
                </td>
            </tr>




            <tr class="admin_sfondo">
                <td><%=asc.language.getforadminfromdictionary("admin.product.category") %></td>
                <td>
                    <asp:DropDownList ID="dListCatSottocat" runat="server" EnableViewState="TRUE" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td width="322"><%=asc.language.getforadminfromdictionary("admin.product.code") %>&nbsp;&nbsp;</td>
                <td width="718">
                    <asp:TextBox ID="tBoxCod" runat="server" /></td>
            </tr>
            <!-- end definition -->


            <tr class="admin_sfondo">
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.product.name") %>:&nbsp;&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="tboxname" runat="server" />
                </td>
            </tr>


            <tr class="admin_sfondo">
                <td valign="middle"><%=asc.language.getforadminfromdictionary("admin.product.prices.and.discounts") %><br />
                </td>
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.product.price") %>
                    <%=asc.admin.localization.primarynumberformatinfo.CurrencySymbol %>&nbsp;<asp:TextBox EnableViewState="false" Text="0" ID="tBoxPrezzoIns0" CssClass="short" Style="text-align: right" runat="server" />
                    &nbsp;&nbsp;            
                        <%=asc.language.getforadminfromdictionary("admin.product.discountpercent") %>%
                        <asp:TextBox EnableViewState="false" Text="0" ID="tBoxScontoList0" CssClass="short" Style="text-align: right" runat="server" />
                    &nbsp;&nbsp;
                        <%=asc.language.getforadminfromdictionary("admin.product.starting.from") %>
                        &nbsp;<asp:CheckBox runat="server" ID="cboxpricestartingfrom" />

                    &nbsp;&nbsp;
                        <%=asc.language.getforadminfromdictionary("admin.product.label.tax.not.appliable") %>
                        &nbsp;<asp:CheckBox runat="server" ID="cboxnotax" />

                    <p><%=asc.language.getforadminfromdictionary("admin.product.type.minus.one.to.not.to.show")%></p>
                </td>
            </tr>







            <tr class="admin_sfondo">
                <td><%=asc.language.getforadminfromdictionary("admin.product.brand") %></td>
                <td>
                    <asp:TextBox ID="tBoxMarca" runat="server" /></td>
            </tr>








            <tr class="admin_sfondo">
                <td colspan="2">
                    <p><%=asc.language.getforadminfromdictionary("admin.product.description") %></p>
                    <div>
                        <textarea id="tareadescription" runat="server" validaterequestmode="disabled"></textarea>
                    </div>
                </td>
            </tr>




        </table>


        <asp:Label EnableViewState="false" ID="lblErrore" ForeColor="red" runat="server" />

        <p></p>
        <br />
    </form>
</asp:Content>
