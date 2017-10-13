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


<script runat="server">
    int posizione;
    DataSet ds;

    private void item_databound(Object Sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            LinkButton myButton = (LinkButton)e.Item.FindControl("lButtDelete");

            myButton.Attributes.Add("onclick", "return confirm_delete();");
        }

    }


    void dGrid_itemCommand(object sender, DataGridCommandEventArgs e)
    {

        int id = int.Parse(e.CommandArgument.ToString());

        switch (e.CommandName)
        {


            case "edit":
                Response.Redirect("admin_pagina.aspx?id=" + id.ToString());
                break;

            case "delete":
                asc.pagine.delete(id);
                bind();
                asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.deleted"));
                break;
        }

    }




    void dGrid_edit(object sender, DataGridCommandEventArgs e)
    {
        int id = int.Parse(e.CommandArgument.ToString());
        Response.Redirect("admin_pagina.aspx?id=" + id.ToString());

    }


    void bind()
    {

        dGrid.DataSource = asc.helpDb.getDataTable("select * from tpagine order by pa_id");
        dGrid.DataBind();

    }


    void Page_Load()
    {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; ";
        ((Label)Master.FindControl("lbldove")).Text += asc.language.getforadminfromdictionary("admin.pages.whereyouare");


        if (!Page.IsPostBack)
        {
            dGrid.Columns[0].HeaderText = asc.language.getforadminfromdictionary("common.id");
            dGrid.Columns[1].HeaderText = asc.language.getforadminfromdictionary("common.delete");
            dGrid.Columns[2].HeaderText = asc.language.getforadminfromdictionary("common.edit");
            dGrid.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.pages.list.title");
            dGrid.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[2].ItemStyle.HorizontalAlign = HorizontalAlign.Center;

            dGrid.Columns[4].ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
            dGrid.Columns[4].HeaderText = "type";

            bind();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
    <script>
        function confirm_delete() {
            if (confirm("confirm?") == true)
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
        <p></p>
        <div class="big"><%=asc.language.getforadminfromdictionary("admin.pages.whereyouare") %></div>

        <p></p>

        <p></p>
        <asp:DataGrid
            GridLines="none"
            ID="dGrid"
            runat="server"
            Width="100%"
            AutoGenerateColumns="false"
            CellSpacing="1"
            AlternatingItemStyle-CssClass="admin_sfondo"
            ItemStyle-CssClass="admin_sfondobis"
            OnItemCommand="dGrid_itemCommand"
            OnItemDataBound="item_databound">
            <HeaderStyle CssClass="admin_sfondodark" />
            <Columns>
                <asp:BoundColumn DataField="pa_id" ItemStyle-Width="30" />

                <asp:TemplateColumn>
                    <ItemStyle Width="40" HorizontalAlign="Center"></ItemStyle>
                    <ItemTemplate>
                        <asp:LinkButton ID="lButtDelete" CommandArgument='<%#Eval ("pa_id") %>' CommandName="delete" runat="server" Text="<img src=../immagini/delete.gif Border=0 >" />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn>
                    <ItemStyle Width="40" HorizontalAlign="Center"></ItemStyle>
                    <ItemTemplate>
                        <asp:LinkButton CommandName="edit" CommandArgument='<%#Eval ("pa_id") %>' runat="server" Text="<img src=../immagini/edit.gif Border=0 >" />
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <ItemStyle Width="400" HorizontalAlign="left"></ItemStyle>
                    <ItemTemplate>
                        <asp:Label runat="server" Text='<%#asc.language.getforadminfromstring(Eval("pa_nome").ToString()) %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:BoundColumn DataField="pa_type" ItemStyle-Width="30" />

            </Columns>
        </asp:DataGrid>


        <div align="right" style="padding: 6px">
            <input class="bottone" type="submit" onclick="window.location.href = 'admin_pagina.aspx'; return false;" value=<%="'" + asc.language.getforadminfromdictionary("admin.pages.new") + "'" %> />
        </div>


    </form>
</asp:Content>
