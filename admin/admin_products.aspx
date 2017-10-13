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

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Linq" %>

<script runat="server">

    int artperpag;
    string wheretosearchin;
    string terminein;
    int repin;
    int quantiArt;
    int pagein;




    void buttdelsel_click(object o, EventArgs e)
    {

        for (int rip = 0; rip < dGridArt.Items.Count; rip++)
        {
            CheckBox c = (CheckBox)dGridArt.Items[rip].Cells[6].Controls[1];
            int id = int.Parse(dGridArt.Items[rip].Cells[2].Text);


            if (c.Checked)
            {
                asc.product.delete(id);
            }

        }

        Response.Redirect(Request.Url.GetLeftPart(UriPartial.Path));


    }

    public static string ReplaceQueryStringParam(string currentPageUrl, string paramToReplace, string newValue)
    {
        string urlWithoutQuery = currentPageUrl.IndexOf('?') >= 0
                ? currentPageUrl.Substring(0, currentPageUrl.IndexOf('?'))
                : currentPageUrl;

        string queryString = currentPageUrl.IndexOf('?') >= 0
                ? currentPageUrl.Substring(currentPageUrl.IndexOf('?'))
                : null;

        var queryParamList = queryString != null
                ? HttpUtility.ParseQueryString(queryString)
                : HttpUtility.ParseQueryString(string.Empty);

        if (queryParamList[paramToReplace] != null)
        {
            queryParamList[paramToReplace] = newValue;
        }
        else
        {
            queryParamList.Add(paramToReplace, newValue);
        }
        return String.Format("{0}?{1}", urlWithoutQuery, queryParamList);
    }



    void selAll(object s, EventArgs e)
    {

        foreach (DataGridItem i in dGridArt.Items)
        {

            CheckBox c = (CheckBox)(i.FindControl("cBoxSel"));
            c.Checked = true;

        }


    }

    void unselAll(object s, EventArgs e)
    {

        foreach (DataGridItem i in dGridArt.Items)
        {

            CheckBox c = (CheckBox)(i.FindControl("cBoxSel"));
            c.Checked = false;

        }


    }





    private void item_databound(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            ImageButton myButton = (ImageButton)e.Item.FindControl("lButtDelete");
            myButton.Attributes.Add("onclick", "return confirm_delete();");
        }

    }


    void buttFiltra_click(object sender, EventArgs e)
    {

        redirectwithquerystring();

    }

    void redirectwithquerystring()
    {


        Response.Redirect(ResolveUrl(
        "~/admin/admin_products.aspx" +
        "?page=1" +
        "&artperpag=" + dListArtPerPag.SelectedValue +
        "&wheretosearch=" + Server.UrlEncode(dlistwheretosearch.SelectedValue) +
        "&termine=" + Server.UrlEncode(tBoxSearch.Text) +
        "&rep=" + dDListRep.SelectedValue
        ));


    }


    void bindData()
    {
        artperpag = int.Parse(Request.QueryString["artperpag"]);
        wheretosearchin = Request.QueryString["wheretosearch"].ToString();
        terminein = Request.QueryString["termine"].ToString();
        repin = int.Parse(Request.QueryString["rep"]);
        pagein = int.Parse(Request.QueryString["page"]);

        dlistwheretosearch.SelectedValue = wheretosearchin;
        tBoxSearch.Text = terminein;
        dDListRep.SelectedValue = repin.ToString();
        dListArtPerPag.SelectedValue = artperpag.ToString();

        DataTable dtricerca = new DataTable();

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {

            string sql = "SELECT art_id, art_cod, art_name, art_timestamp FROM tproducts WHERE 1=1";

            if (terminein != "")
            {
                switch (wheretosearchin)
                {

                    case "nome":
                        sql += " AND art_name LIKE @termine";
                        break;

                    default:
                        sql += " AND (art_cod LIKE @termine OR art_cod IS NULL)";
                        break;

                }
            }

            if (repin != -1) sql += " AND art_idcat=" + repin;

            sql += " order by art_id";


            OleDbDataAdapter da = new OleDbDataAdapter();
            OleDbCommand cmd = new OleDbCommand(sql, cnn);
            cnn.Open();


            if (terminein != "")
            {
                OleDbParameter myParameter = new OleDbParameter();
                myParameter.ParameterName = "@termine";
                myParameter.Value = "%" + terminein + "%";
                cmd.Parameters.Add(myParameter);
            }


            cmd.CommandText = sql;
            da.SelectCommand = cmd;
            da.Fill(dtricerca);
        }

        quantiArt = dtricerca.Rows.Count;

        DataRow[] rows = dtricerca.AsEnumerable().Skip((pagein - 1) * artperpag).Take(artperpag).ToArray();

        if (rows.Length > 0)
        {


            DataTable dtbis = rows.CopyToDataTable();


            if (dtbis.Rows.Count > 0)
            {
                dGridArt.DataSource = dtbis;
                dGridArt.DataBind();


                // pager
                if (quantiArt > 0)
                {
                    int restoZeroUno = (quantiArt % artperpag > 0) ? 1 : 0;
                    int totPag = (int)(restoZeroUno + Math.Floor((double)quantiArt / artperpag));
                    for (int a = 1; a <= totPag; a++)
                    {
                        if (pagein == a)
                        {
                            lblpaging.Text += "<b>" + Convert.ToString(a) + "</b> ";
                        }
                        else
                        {
                            string linktonewpage = ReplaceQueryStringParam(Request.Url.AbsoluteUri, "page", a.ToString());
                            lblpaging.Text += asc.common.linkescaped(
                                Convert.ToString(a),
                                 linktonewpage,
                                "paging") + " ";
                        }
                    }
                }

            }
        }




    }

    void dGridArt_itemCommand(object sender, DataGridCommandEventArgs e)


    {

        int idart;

        switch (e.CommandName)
        {

            case "edit":
                idart = int.Parse(e.Item.Cells[2].Text);
                Response.Redirect("admin_product.aspx?idart=" + idart);
                break;


            case "delete":
                idart = int.Parse(e.Item.Cells[2].Text);
                asc.product.delete(idart);
                Response.Redirect(Request.Url.GetLeftPart(UriPartial.Path));
                break;
        }

    }










    void Page_Load()
    {

        if (!int.TryParse(Request.QueryString["page"], out pagein)) pagein = 1;

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; "
                + asc.language.getforadminfromdictionary("admin.whereareyou.products");


        if (!Page.IsPostBack)
        {

            // start prepare controls **********************************************************************************************
            buttFiltra.Text = asc.language.getforadminfromdictionary("admin.products.filter.button");

            dGridArt.Columns[0].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.edit");
            dGridArt.Columns[1].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.delete");
            dGridArt.Columns[2].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.id");
            dGridArt.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.code");
            dGridArt.Columns[4].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.name");
            dGridArt.Columns[5].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.creation.date");
            dGridArt.Columns[6].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.select");
            dGridArt.Columns[7].HeaderText = asc.language.getforadminfromdictionary("admin.products.list.image");

            buttselall.Text = asc.language.getforadminfromdictionary("admin.products.butt.sel.all");
            buttunselall.Text = asc.language.getforadminfromdictionary("admin.products.butt.unsel.all");
            buttdelsel.Text = asc.language.getforadminfromdictionary("admin.products.butt.del.sel");

            dlistwheretosearch.Items[0].Text = asc.language.getforadminfromdictionary("admin.products.filter.by.code");
            dlistwheretosearch.Items[1].Text = asc.language.getforadminfromdictionary("admin.products.filter.by.name");

            dDListRep.Items.Add(new ListItem(asc.language.getforadminfromdictionary("admin.products.any.category"), "-1"));

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
                dDListRep.Items.Add(new ListItem(path, row["cat_id"].ToString()));
            }

            for (int rip = 1; rip <= 200; rip++)
            {
                ListItem li = new ListItem(rip.ToString(), rip.ToString());
                if (rip == 10) li.Selected = true;
                dListArtPerPag.Items.Add(li);
            }


            // end  prepare controls ********************************************************************************************



            if (Request.QueryString["page"] == null) redirectwithquerystring();
            else
            {
                bindData();

            }





        }
    }

</script>




<asp:Content ContentPlaceHolderID="headcontent" runat="server">
    <script>
        function confirm_delete() {
            if (confirm("confermi?") == true)
                return true;
            else
                return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">








    <form runat="server" id="myform">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>

        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.products.filter") %>
        </div>



        <table width="100%" cellpadding="7" cellspacing="1" style="">
            <tr>
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.products.filter.label.belonging to category") %>
                    <asp:DropDownList ID="dDListRep" runat="server" />
                    &nbsp;&nbsp;                        <%=asc.language.getforadminfromdictionary("admin.products.filter.lbl.word") %>:
       <asp:TextBox ID="tBoxSearch" runat="server" EnableViewState="false" CssClass="short" />
                    &nbsp;
       <asp:DropDownList ID="dlistwheretosearch" runat="server">
           <asp:ListItem Value="codice"></asp:ListItem>
           <asp:ListItem Value="nome"></asp:ListItem>
       </asp:DropDownList>
                    &nbsp;&nbsp;                  
                    <asp:DropDownList runat="server" ID="dListArtPerPag" />
                    <%=asc.language.getforadminfromdictionary("admin.products.filter.lbl.results.per.page") %>
&nbsp;&nbsp;                  
                    <asp:Button ID="buttFiltra" runat="server" OnClick="buttFiltra_click" />

                </td>
            </tr>
        </table>
        <br>

        <br>



        <center><asp:label enableviewstate="false" id="lblErrore" forecolor="red" runat="server" style="font-size:18px"/></center>

        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.products.lbl.product.list") %>
        </div>


        <asp:DataGrid
            GridLines="None"
            OnItemCommand="dGridArt_itemCommand"
            CellPadding="2"
            CellSpacing="1"
            ID="dGridArt"
            runat="server"
            Width="100%"
            AutoGenerateColumns="false"
            OnItemDataBound="item_databound"
            EnableViewState="true">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <AlternatingItemStyle CssClass="admin_sfondobis" />
            <Columns>
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="40"></ItemStyle>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:ImageButton CommandName="edit" runat="server" ImageUrl="~/immagini/edit.gif" />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemStyle Width="40"></ItemStyle>
                    <ItemTemplate>
                        <asp:ImageButton ID="lButtDelete" CommandName="delete" runat="server" ImageUrl="~/immagini/delete.gif" />
                    </ItemTemplate>
                </asp:TemplateColumn>



                <asp:BoundColumn DataField="art_id" HeaderStyle-HorizontalAlign="Center" />
                <asp:BoundColumn DataField="art_cod" HeaderStyle-HorizontalAlign="Center" />
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" Height="28" />
                    <ItemStyle Width="410" />
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#asc.language.getforadminfromstring(Eval("art_name").ToString()) %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="art_timestamp" ItemStyle-Width="130" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="right" />
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="45" HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:CheckBox runat="server" ID="cBoxSel" />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="45" />
                    <ItemTemplate>
                        <center><asp:image runat="server" imageurl='<%#"~/image.aspx?type=0&id=" + Eval("art_id").ToString()  %>' alt="" width="60" /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>


            </Columns>
        </asp:DataGrid>

        <table style="width: 100%">
            <tr>
                <td class="paging">
                    <asp:Label ID="lblpaging" runat="server" EnableViewState="false" />
                </td>
            </tr>

        </table>


        <div>
            <asp:LinkButton runat="server" CssClass="command" OnClick="selAll" ID="buttselall" />
            &nbsp;
             <asp:LinkButton runat="server" CssClass="command" OnClick="unselAll" ID="buttunselall" />
            &nbsp;
            <asp:LinkButton runat="server" CssClass="command" OnClick="buttdelsel_click" ID="buttdelsel" />
            &nbsp;
            <a class="command" href="#" onclick="window.location.href = 'admin_product.aspx'; return false;"><%=asc.language.getforadminfromdictionary("admin.products.butt.add.new") %></a>


        </div>



        <p>
            <br />
        </p>


    </form>
</asp:Content>
