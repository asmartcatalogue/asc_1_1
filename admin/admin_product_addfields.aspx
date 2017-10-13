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



    List<string> frontlanguages;
    int idart;

    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bind();


    }
    void updateorigin()
    {

        DataTable dt = (DataTable)ViewState["nameandvaluetokens"];
        for (int rip = 0; rip < dGrid.Items.Count; rip++)
        {
            string currvalue = ((TextBox)dGrid.Items[rip].FindControl("tboxvalue")).Text;
            dt.Rows[rip]["b_value"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(dt.Rows[rip]["b_value"].ToString(), ViewState["l"].ToString(), currvalue);
        }

    }

    void bind()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }

        dGrid.DataSource = (DataTable)ViewState["nameandvaluetokens"];
        dGrid.DataBind();

    }

    void updatenamefromgrid_click(object o, EventArgs e)
    {
        updateorigin();

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();


            DataTable dt = (DataTable)ViewState["nameandvaluetokens"];


            foreach (DataRow row in dt.Rows)
            {
                if (row["b_idart"] == System.DBNull.Value)
                {
                    if (row["b_value"].ToString().Length > 0)
                    {
                        asc.helpDb.nonQueryByOpenCnn
                            (cnn,
                                "insert into tadditionalfields_tarticoli (idart, idfield, [value]) values (@myidart, @myidfield, @myvalue)",
                                new OleDbParameter("myidart", idart),
                                new OleDbParameter("myidfield", (int)row["a_id"]),
                                new OleDbParameter("myvalue", row["b_value"].ToString())
                            );

                    }
                }
                else
                {
                    if (row["b_value"].ToString().Length > 0)
                        asc.helpDb.nonQueryByOpenCnn(
                            cnn,
                            "update tadditionalfields_tarticoli set [value]=@myvalue where idart=@myidart and idfield=@myidfield",
                            new OleDbParameter("myvalue", row["b_value"].ToString()),
                            new OleDbParameter("myidart", (int)row["b_idart"]),
                            new OleDbParameter("myidfield", (int)row["b_idfield"])
                        );

                    else
                        asc.helpDb.nonQueryByOpenCnn(
                            cnn,
                            "delete tadditionalfields_tarticoli where idart=@myidart and idfield=@myidfield",
                            new OleDbParameter("myidart", (int)row["b_idart"]),
                            new OleDbParameter("myidfield", (int)row["b_idfield"])
                            );
                }


            }
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
                     asc.language.getforadminfromdictionary("admin.menu.label.additional.fields");





            dGrid.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.additional.field.name.of.additional.field");
            dGrid.Columns[4].HeaderText = asc.language.getforadminfromdictionary("admin.additional.field.text.of.additional.field");

            buttsavegrid.Text = asc.language.getforadminfromdictionary("common.save.changes");

            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];

            if (ViewState["nameandvaluetokens"] == null)
            {
                DataTable dt = asc.helpDb.getDataTable(
                    "select b.idart as b_idart, b.idfield as b_idfield, b.value as b_value, a.id as a_id, a.name as a_name from tadditionalfields a left join (select * from tadditionalfields_tarticoli where idart=@idart) as b on a.id=b.idfield ",
                    new OleDbParameter("idart", idart)
                    );
                ViewState["nameandvaluetokens"] = dt;
            }

            bind();


        }

    }





</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>



        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>

                <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.menu.label.additional.fields") %>
        </div>

        <asp:DataGrid GridLines="None" CellSpacing="1"
            CellPadding="4" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <Columns>

                <asp:TemplateColumn Visible="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="idaddfield" Text='<%#Eval("a_id").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn Visible="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblidart" Text='<%#Eval("b_idart").ToString() %>'  />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn Visible="false">
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblidfield" Text='<%#Eval("b_idfield").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn >
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblname" Text='<%#asc.language.getfromstringandlanguagename(Eval("a_name").ToString(), ViewState["l"].ToString()) %>'  />&nbsp;
                    </ItemTemplate>
                </asp:TemplateColumn>



                <asp:TemplateColumn>
                    <ItemStyle Width="700" />
                    <ItemTemplate>
                        <table width="100%">
                            <tr>
                                <td valign="bottom" nowrap>
                                    <asp:TextBox runat="server" ID="tboxvalue" Text='<%#asc.language.getfromstringandlanguagename(Eval("b_value").ToString(), ViewState["l"].ToString()) %>'  />
                                </td>
                            </tr>
                        </table>
                    </ItemTemplate>
                </asp:TemplateColumn>

            </Columns>
        </asp:DataGrid>
        <table cellpadding="0" cellspacing="1" style="width: 100%">
            <tr class="admin_sfondo">
                <td>
                    <asp:linkButton runat="server" ID="buttsavegrid" OnClick="updatenamefromgrid_click" />
                </td>
            </tr>
        </table>



        <p></p>
        <br />
    </form>
</asp:Content>
