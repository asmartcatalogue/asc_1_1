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

        tBoxDescription.Text = asc.sicurezza.xss.getreplacedencoded(asc.config.getCampoByDb("config_metatagdescription").ToString());
        tBoxKeywords.Text = asc.sicurezza.xss.getreplacedencoded(asc.config.getCampoByDb("config_metatagkeywords").ToString());
    }


    void aggiorna_click(object sender, EventArgs e)
    {




        string sql = "update tconfig SET " +
         " config_metatagdescription=@description, config_metatagkeywords=@keywords";
        asc.helpDb.nonQuery(sql,
           new OleDbParameter("description", tBoxDescription.Text),
           new OleDbParameter("keywords", tBoxKeywords.Text)
       );

        asc.config.storeConfig();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));
        bind();

    }

    void Page_Load()
    {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; meta tag";

        if (!Page.IsPostBack)
        {
            buttAggiorna.Text = asc.language.getforadminfromdictionary("common.save.changes");

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



        <table width="100%" cellspacing="1" cellpadding="0">
            <tr class="admin_sfondo">
                <td style="width:300px">METATAG Description <%=asc.language.getforadminfromdictionary("admin.metatag.for.search.engine") %>
                </td>
                <td>
                    <asp:TextBox ID="tBoxDescription" runat="server" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>METATAG Keywords <%=asc.language.getforadminfromdictionary("admin.metatag.for.search.engine") %>
                </td>
                <td>
                    <asp:TextBox ID="tBoxKeywords" runat="server" />
                </td>
            </tr>



        </table>

        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="aggiorna_click" ID="buttAggiorna" runat="server" />
        </div>




    </form>
</asp:Content>
