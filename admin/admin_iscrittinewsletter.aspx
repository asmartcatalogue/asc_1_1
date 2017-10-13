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


<script runat="server">

    int quantiPerPag = 25;



    void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
    {
        dGridUt.CurrentPageIndex = e.NewPageIndex;
        bindData();

    }


    void bindData()
    {

        DataTable dt = asc.mailing.getEmailsNewsletter();

        dGridUt.DataSource = dt;
        dGridUt.DataBind();


    }




    void dGridUt_delete(object sender, DataGridCommandEventArgs e)
    {

        string email = ((Label)e.Item.FindControl("myemail")).Text;



        asc.mailing.deleteEmail(email);




        bindData();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.deleted"));
    }





    void Page_Load()
    {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
        asc.language.getforadminfromdictionary("admin.registeredtonewsletter.whereyouare.users.registered.to.newsletter");

        if (!Page.IsPostBack)
        {
            dGridUt.Columns[0].HeaderText = asc.language.getforadminfromdictionary("admin.registeredtonewsletter.list.email");
            dGridUt.Columns[1].HeaderText = asc.language.getforadminfromdictionary("admin.registeredtonewsletter.list.confirmed");
            dGridUt.Columns[2].HeaderText = asc.language.getforadminfromdictionary("common.button.delete");
            bindData();


        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
        <br />
        <asp:Label ID="Label1" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />


        <asp:DataGrid
            CellSpacing="1"
            GridLines="None" ID="dGridUt"
            runat="server"
            Width="100%"
            AutoGenerateColumns="false"
            OnDeleteCommand="dGridUt_delete"
            AllowPaging="true"
            PagerStyle-Mode="NumericPages"
            PageSize="<%# quantiPerPag%>"
            OnPageIndexChanged="Grid_Change">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <AlternatingItemStyle CssClass="admin_sfondobis" />
            <EditItemStyle CssClass="small" />
            <Columns>
                <asp:TemplateColumn>
                    <ItemStyle HorizontalAlign="Right" />
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label runat="server" ID="myemail" Text='<%# asc.sicurezza.xss.getreplacedencoded( Eval("m_email").ToString() )%>' />
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:BoundColumn DataField="m_confermato" ReadOnly="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                <asp:ButtonColumn Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />

            </Columns>
        </asp:DataGrid>
        <asp:Label ID="lblErr" runat="server" EnableViewState="false" ForeColor="red" />







    </form>
</asp:Content>
