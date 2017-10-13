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

    void bind()
    {
                imgmain.Src = "~/image.aspx?type=0&id=" + idart.ToString();

    }





    void buttsaveimg_click(object o, EventArgs e)
    {
        string imgrelativepath = "~/app_data/p/" + idart.ToString();


        if (fileImg0.PostedFile.FileName == "")
        {
            asc.common.jquerymodalmessage(this.Page, "select image from your hard-disk");
        }
        else
        {

            asc.images.deleteandsave(fileImg0.PostedFile, imgrelativepath);


        Response.Redirect(Request.Url.AbsoluteUri);
        }
    }


















    void dGrid_delete(object sender, DataGridCommandEventArgs e)
    {
        int id = int.Parse(((Label)(e.Item.FindControl("lblid"))).Text);
        string sql = "delete  FROM tzoom WHERE z_id=@id";
        OleDbParameter p1 = new OleDbParameter("@id", id);
        asc.helpDb.nonQuery(sql, p1);


        Response.Redirect(Request.Url.AbsoluteUri);


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
                    " &raquo; " + asc.language.getforadminfromdictionary("admin.product.main.image");

            buttupdate.Text = asc.language.getforadminfromdictionary("admin.product.main.image.save.image");

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
            <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /></div>

        <asp:Panel runat="server" ID="panellanguages" />


        <p></p>
            <div class="big"><%=asc.language.getforadminfromdictionary("admin.product.main.image") %></div>
        <p></p>

            <table width="100%">
                <tr>
                    <td nowrap valign="middle"><img runat="server" width="90" id="imgmain" /></td>
                    <td style="width:100%">&nbsp;&nbsp;<input runat="server" type="file" id="fileImg0" />&nbsp;&nbsp;<asp:linkButton ID="buttupdate" OnClick="buttsaveimg_click" runat="server" /></td>
                </tr>
            </table>
        <p>
            <br />
        </p>
    </form>
</asp:Content>
