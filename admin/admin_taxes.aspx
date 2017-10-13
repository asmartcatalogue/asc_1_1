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
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>



<script runat="server">




    void bind()
    {



        string sql = "select config_showtaxincluded, config_taxrate, config_taxname from tconfig";
        DataRow dr = asc.helpDb.getFirstRow(sql);
        cboxtaxincluded.Checked = ((int)dr["config_showtaxincluded"]==1);
        tboxtaxname.Text = (string)dr["config_taxname"];
        tboxtaxrate.Text = dr["config_taxrate"].ToString();


    }


    void save_click(object sender, EventArgs e)
    {
        double worktaxrate = 0;
        try
        {
            worktaxrate = double.Parse(tboxtaxrate.Text);
        }
        catch { }

        string sql = "update tconfig SET " +
        " config_showtaxincluded=@showtaxincluded, config_taxrate=@taxrate, config_taxname=@taxname";

        asc.helpDb.nonQuery(sql,
         new OleDbParameter("@showtaxincluded", (cboxtaxincluded.Checked ? 1 : 0)),
         new OleDbParameter("taxrate", worktaxrate),
         new OleDbParameter("taxname", tboxtaxname.Text)
         );



        System.Web.HttpRuntime.UnloadAppDomain();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));
        bind();

    }

    void Page_Load()
    {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
            asc.language.getforadminfromdictionary("admin.menu.label.tax.settings");

        if (!Page.IsPostBack)
        {
            lbuttsave.Text = asc.language.getforadminfromdictionary("common.save.changes");
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
        <br />
        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />


        <asp:Panel runat="server" ID="panelshowhide">

            <asp:LinkButton runat="server" id="lbuttsave" OnClick="save_click" />
            <table width="100%" celspacing="1" cellpadding="0">

                <tr class="admin_sfondobis">
                    <td width="380"><%=asc.language.getforadminfromdictionary("admin_taxes.show.prices.vat.included")%></td>
                    <td>
                        <asp:CheckBox runat="server" ID="cboxtaxincluded" />
                    </td>
                </tr>
                <tr class="admin_sfondobis">
                <td><%=asc.language.getforadminfromdictionary("admin_taxes.tax.name")%></td>
                <td>
                    <asp:TextBox runat="server" ID="tboxtaxname" />
                </td>
                </tr>
                <tr class="admin_sfondobis">
                <td><%=asc.language.getforadminfromdictionary("admin_taxes.tax.rate")%></td>
                <td>
                    <asp:TextBox runat="server" ID="tboxtaxrate" CssClass="short" />&nbsp;%
                </td>
                </tr>


            </table>

        </asp:Panel>



    </form>
</asp:Content>
