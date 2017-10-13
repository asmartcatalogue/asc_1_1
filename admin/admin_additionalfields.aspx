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
<%@ Import Namespace="AjaxControlToolkit" %>




<script runat="server">
    int n = 0;

    List<string> frontlanguages;

    void updatenamefromgrid_click(object o, EventArgs e)
    {
        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            DataTable dt = (DataTable)ViewState["nametokens"];


            for ( int rip=0; rip<dGrid.Items.Count;rip++)
            {
                string newnametokens = ((TextBox)dGrid.Items[rip].FindControl("tboxname")).Text;

                string updatednametoken = asc.language.addorupdateonetoken_and_removetokenswihoutwords(dt.Rows[rip]["name"].ToString(), ViewState["l"].ToString(), newnametokens);

                asc.helpDb.nonQueryByOpenCnn(
                    cnn,
                    "update tadditionalfields set name=@name where id=@id",
                    new OleDbParameter("name", updatednametoken),
                    new OleDbParameter("id", (int)dt.Rows[rip]["id"])
                    );
            }
        }
        Response.Redirect(Request.Url.AbsoluteUri);


    }

    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bindtoviewstate();

    }
    void updateorigin()
    {

        ViewState["addednametokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["addednametokens"].ToString(), ViewState["l"].ToString(), tboxaddedname.Text);

        DataTable dt = (DataTable)ViewState["nametokens"];
        for (int rip = 0; rip < dGrid.Items.Count; rip++)
        {
            string currvalue = ((TextBox)dGrid.Items[rip].FindControl("tboxname")).Text;
            dt.Rows[rip]["name"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords( dt.Rows[rip]["name"].ToString(), ViewState["l"].ToString(), currvalue);

        }

    }






    void bindtoviewstate()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }

        tboxaddedname.Text = asc.language.getfromstringandlanguagename(ViewState["addednametokens"].ToString(), ViewState["l"].ToString());

        for (int rip = 0; rip < dGrid.Items.Count; rip++)
        {
            ((TextBox)dGrid.Items[rip].FindControl("tboxname")).Text = asc.language.getfromstringandlanguagename( ((DataTable)ViewState["nametokens"]).Rows[rip]["name"].ToString(), ViewState["l"].ToString());
        }

    }


    void dGrid_delete(object sender, DataGridCommandEventArgs e)
    {
        int id = int.Parse(((Label)(e.Item.FindControl("lblid"))).Text);
        string sql = "delete  FROM tadditionalfields WHERE id=@id";
        OleDbParameter p1 = new OleDbParameter("@id", id);
        asc.helpDb.nonQuery(sql, p1);
        Response.Redirect(Request.Url.AbsoluteUri);

        dGrid.EditItemIndex = -1;

    }





    void buttadd_click(Object sender, EventArgs e)
    {
        updateorigin();

        string addednametokens = ViewState["addednametokens"].ToString();

        string sql = "insert into tadditionalfields (name) values (@name)";
        asc.helpDb.nonQuery(sql, new OleDbParameter("name", addednametokens));



        Response.Redirect(Request.Url.AbsoluteUri);



    }



    void Page_Init()
    {
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
        if (!IsPostBack)
        {

            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
             asc.language.getforadminfromdictionary("admin.menu.label.additional.fields");


            dGrid.Columns[0].HeaderText = asc.language.getforadminfromdictionary("common.id");
            dGrid.Columns[1].HeaderText = asc.language.getforadminfromdictionary("admin.additional.field.name.of.additional.field");
            dGrid.Columns[2].HeaderText = asc.language.getforadminfromdictionary("common.delete");;

            buttadd.Text = asc.language.getforadminfromdictionary("common.save.changes");
            buttsavegrid.Text = asc.language.getforadminfromdictionary("common.save.changes");

            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];

            if (ViewState["addednametokens"] == null)
            {
                ViewState["addednametokens"] = "";
            }
            if (ViewState["nametokens"] == null)
            {
                DataTable dt = asc.helpDb.getDataTable("select id,name from tadditionalfields order by id");
                ViewState["nametokens"] = dt;
                bindtoviewstate();
                dGrid.DataSource = dt;
                dGrid.DataBind();
            }




        }

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />

        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>



            <table cellpadding="0" cellspacing="1" style="width: 100%">


                <tr class="admin_sfondo">
                    <td style="width: 300px">
                        <%=asc.language.getforadminfromdictionary("admin.additional.field.name.of.additional.field") %>
                    </td>
                    <td>
                        <asp:TextBox runat="server" ID="tboxaddedname" />
                    </td>
                </tr>

                <tr class="admin_sfondo">
                    <td align="center" colspan="2" style="padding-top: 20px">
                        <asp:Button ID="buttadd" OnClick="buttadd_click" runat="server" class="bottone" /></td>
                </tr>
            </table>


        <p></p>
        <p></p>

        <asp:DataGrid GridLines="None" CellSpacing="1"
            OnDeleteCommand="dGrid_delete"
            CellPadding="4" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <Columns>


                <asp:TemplateColumn>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblid" Text='<%#Eval("id").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>




                <asp:TemplateColumn>
                    <ItemStyle Width="700" />
                    <ItemTemplate>
                        <table width="100%">
                            <tr>
                                <td valign="bottom">
                                    <asp:TextBox runat="server" ID="tboxname" Text='<%# asc.language.getfromstringandlanguagename(Eval("name").ToString(), ViewState["l"].ToString()) %>'  />
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:ButtonColumn Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
        </asp:DataGrid>
            <table cellpadding="0" cellspacing="1" style="width: 100%">
                <tr class="admin_sfondo">
                    <td>
         <asp:Button runat="server" id="buttsavegrid" OnClick="updatenamefromgrid_click"  />
                        </td>
                    </tr>
                </table>


    </form>
</asp:Content>


