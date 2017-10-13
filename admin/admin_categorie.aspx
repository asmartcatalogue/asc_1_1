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

<%@ Import Namespace="asc" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<script runat="server" id="{">


    private void item_Created(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            LinkButton myButton = (LinkButton)e.Item.FindControl("lButtDelete");
            myButton.Attributes.Add("onclick", "return confirm_delete();");


            cc workcc = (cc)e.Item.DataItem;

            Image myImg = (Image)e.Item.FindControl("img");
            myImg.ImageUrl = ResolveUrl("~/image.aspx?type=1&id=" + workcc.Id);

            LinkButton linkButtModifica = (LinkButton)e.Item.FindControl("linkButtModifica");






            Label lblpathcat = (Label)(e.Item.FindControl("lblpathcat"));
            lblpathcat.Text = workcc.Path;

            Label lblId = (Label)(e.Item.FindControl("lblId"));
            lblId.Text = workcc.Id.ToString();




        }

    }

    class c
    {
        public int Id;
        public string Name;

        public c(int _id, string _name)
        {

            this.Id = _id;
            this.Name = _name;
        }
    }

    class cc
    {
        public int Id;
        public string Path;

        public cc(int _id, string _path)
        {

            this.Id = _id;
            this.Path = _path;
        }
    }

    void bindData()
    {

        DataTable dtcat = (DataTable)Application["dtcat"];
        List<cc> listcc = new List<cc>();

        foreach (DataRow row in dtcat.Rows)
        {
            List<c> listc = new List<c>();
            int x = (int)row["cat_idpadre"];
            bool dorepeat = true;
            listc.Add(new c((int)row["cat_id"], asc.language.getforadminfromstring((string)row["cat_nome"])));
            while (dorepeat)
            {
                if (x == 0) dorepeat = false;
                else
                {
                    DataRow foundrow = dtcat.Rows.Find(x);
                    listc.Add(new c((int)foundrow["cat_id"], asc.language.getforadminfromstring((string)foundrow["cat_nome"])));
                    x = (int)foundrow["cat_idpadre"];
                }
            }
            listc.Reverse();
            string path = "";
            foreach (c workc in listc)
            {
                if (path.Length > 0) path += "--->";
                path += workc.Name;

            }
            if (listc.Count > 0) listcc.Add(new cc(listc[listc.Count - 1].Id, path));
        }
        List<cc> SortedList = listcc.OrderBy(o => o.Path).ToList();
        lista.DataSource = SortedList;
        lista.DataBind();

    }






















    void comando(object sender, DataGridCommandEventArgs e)
    {

        if (e.CommandName != "delete")
        {


            int idCat = int.Parse(((Label)(e.Item.FindControl("lblId"))).Text);

            Response.Redirect("admin_catsottocat.aspx?id=" + idCat);
        }
    }





    void dGridRep_delete(object sender, DataGridCommandEventArgs e)
    {



        int idcat = int.Parse(((Label)(e.Item.FindControl("lblId"))).Text);

        OleDbCommand cmd;
        string strSql;

        int howmany;

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            strSql = "select count(*) from tcategorie where cat_idpadre=@parentid";
            cmd = new OleDbCommand(strSql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@parentid", idcat));

            howmany= Convert.ToInt32(cmd.ExecuteScalar());
        }

        if (howmany > 0)
        {
            asc.common.jquerymodalmessage(this.Page,asc.language.getforadminfromdictionary("admin.categories.alert.category.has.children"));

        }
        else
        {
            asc.Category.delete(idcat);
            Response.Redirect(Request.Url.AbsoluteUri);
        }






    }





    void buttNewCat_click(object sender, EventArgs e)
    {


        Response.Redirect("admin_catsottocat.aspx");


    }








    void lista_edit(object sender, DataGridCommandEventArgs e)
    {


        int idSottocat = int.Parse(e.Item.Cells[1].Text);

        Response.Redirect("admin_catsottocat.aspx?id=" + idSottocat);


    }



    void buttNewSottocat_click(object sender, EventArgs e)
    {


        Response.Redirect("admin_catsottocat.aspx");



    }


    void Page_Init()
    {



    }

    void Page_Load()
    {


        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " + asc.language.getforadminfromdictionary("admin.categories.whereyouare.categories");




        if (!Page.IsPostBack)
        {
            buttNewSottocat.Text = asc.language.getforadminfromdictionary("admin.categories.button.new.category");

            lista.Columns[0].HeaderText = asc.language.getforadminfromdictionary("admin.categories.list.modify");
            lista.Columns[1].HeaderText = asc.language.getforadminfromdictionary("admin.categories.list.id.category");
            lista.Columns[2].HeaderText = asc.language.getforadminfromdictionary("admin.categories.list.image");
            lista.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.categories.list.name");
            lista.Columns[4].HeaderText = asc.language.getforadminfromdictionary("admin.categories.list.delete");
            bindData();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">

    <script>
        function confirm_delete() {
            if (confirm(<%="'" + asc.language.getforadminfromdictionary("admin.categories.warning.allsubcategories.deleted") + "'"%>) == true)
                return true;
            else
                return false;
        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>




        <br />
        <div align="center">
            <asp:Label EnableViewState="false" ID="lblErrore" Font-Size="Large" ForeColor="Red" runat="server" />
        </div>

        <asp:LinkButton ID="buttNewSottocat" OnClick="buttNewSottocat_click" runat="server"></asp:LinkButton>
        <p></p>
        <asp:DataGrid GridLines="None" CellSpacing="1" ID="lista" runat="server" Width="100%"
            AutoGenerateColumns="false" OnDeleteCommand="dGridRep_delete" OnItemDataBound="item_Created" OnItemCommand="comando">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <EditItemStyle CssClass="small" />
            <Columns>

                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="50" />
                    <ItemTemplate>
                        <center><asp:linkbutton ID="linkButtModifica" 
                    runat=server
                    Text="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" 
                    /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="20" />
                    <ItemTemplate>
                        <center><asp:label id="lblId" runat="server"  /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="44" />
                    <ItemTemplate>
                        <center><asp:image id="img" runat="server"  style="margin:4px; border:solid 1px #aaa; width:70px" /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="50%" />
                    <ItemTemplate>
                        <asp:Label ID="lblpathcat" runat="server" />
                    </ItemTemplate>
                </asp:TemplateColumn>



                <asp:TemplateColumn>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Width="40"></ItemStyle>
                    <ItemTemplate>
                        <center><asp:linkbutton id="lButtDelete" commandname="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >"  /></center>
                    </ItemTemplate>
                </asp:TemplateColumn>
            </Columns>
        </asp:DataGrid>



        <p></p>





    </form>
</asp:Content>
