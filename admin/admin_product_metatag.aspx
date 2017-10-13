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

<%@ Import Namespace="System.IO" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="AjaxControlToolkit" %>
<script runat="server">

    int idart;
    List<string> frontlanguages;


    void save_click(object o, EventArgs e)
    {


        asc.helpDb.nonQuery(
            "update tproducts set art_metadescription=@metadesc, art_metakeywords=@metakeyw where art_id=@idart",
            new OleDbParameter("@metadesc", tboxdesc.Text ),
            new OleDbParameter("@metakeyw", tboxkeyw.Text ),
            new OleDbParameter("idart", idart)
            );
        Response.Redirect(Request.Url.AbsoluteUri);

    }













    void bind()
    {

        DataRow dr = asc.helpDb.getFirstRow("select art_metadescription, art_metakeywords from tproducts where art_id=@idart", new OleDbParameter("idart", idart));
        tboxdesc.Text = dr[0].ToString();
        tboxkeyw.Text = dr[1].ToString();

    }








    void Page_Init()
    {
        idart = Convert.ToInt32(Request.QueryString["idart"]);
        if (idart == 0) Response.Redirect("~/admin/admin_products.aspx");



    }


    void Page_Load()
    {





        if (!IsPostBack)
        {

            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
                    " &raquo; " +
                    "<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.products") + "</a>" +
                    " &raquo; " +
                    "<a href='admin_product.aspx?idart=" + idart.ToString() + "'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idart.ToString() + "</a>" +
                    " &raquo; " + asc.language.getforadminfromdictionary("admin.product.metatag");

            buttsave.Text = asc.language.getforadminfromdictionary("common.save.changes");
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
        <div>
            <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />
        </div>

        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.product.metatag") %>
        </div>
        <p></p>
        <p></p>
        <table style="width:100%">
            <tr>
                <td style="width:140px">
                    <%=asc.language.getforadminfromdictionary("admin.product.metatag.description") %>&nbsp;
                </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxdesc" />
                </td>
            </tr>
            <tr>
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.product.metatag.keywords") %>&nbsp;
                </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxkeyw" />
                </td>
            </tr>
        </table>
        <asp:LinkButton runat="server" ID="buttsave" OnClick="save_click" />
    </form>
</asp:Content>
