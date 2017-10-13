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
    int lastid = 0;

    void timer_tick(object o, EventArgs e)
    {
        if (ViewState["lastid"] == null) ViewState["lastid"] = 0;

        string sql;

        sql = "SELECT top 1 m_email,id as currentid FROM tmailing where m_confermato=1 and id>@lastid";



        DataTable dt = (asc.helpDb.getDataTable(sql, new OleDbParameter("lastid", (int)ViewState["lastid"])));

        if (dt.Rows.Count < 1)
        {

            timer1.Enabled = false;
            lblesito.Text += "<br><b>" + asc.language.getforadminfromdictionary("admin.newsletter.all.sent") + "</b>.";
            return;
        }

        string to = (string)(dt.Rows[0][0]);


        bool ok = true;
        try
        {
            asc.email.send(tBoxFrom.Text, to, tBoxSubject.Text, tArea.InnerText, cBoxHtml.Checked);
        }
        catch 
        {

            ok = false;
        }

        if (ok)
        {
            lblesito.Text += "<br>" + asc.language.getforadminfromdictionary("admin.newsletter.1.email.successfull.sent") + " " + asc.sicurezza.xss.getreplacedencoded(to);
        }
        else
        {
            lblesito.Text += "<br>" + asc.language.getforadminfromdictionary("admin.newsletter.1.email.unsuccessfull.sent") + " " + asc.sicurezza.xss.getreplacedencoded(to);
        }

        ViewState["lastid"] = (int)dt.Rows[0]["currentid"];

        lblesito.Text += "<br>" + String.Format(asc.language.getforfrontfromdictionaryincurrentlanguage("admin.newsletter.next.email"), (timer1.Interval / 1000).ToString());
    }


    void buttInvia_click(object sender, EventArgs e)
    {
        lblesito.Text = asc.language.getforadminfromdictionary("admin.newsletter.started.delivery");
        timer1.Enabled = true;
    }

    void buttInviaProva_click(object sender, EventArgs e)
    {

        if (tboxtestemailto.Text.Length < 1)
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.newsletter.type.to.test.email"));
            return;
        }


        bool ok = true;
        try
        {
            asc.email.send(tBoxFrom.Text, tboxtestemailto.Text, tBoxSubject.Text, tArea.InnerText, cBoxHtml.Checked);
        }
        catch (Exception E)
        {
            asc.common.jquerymodalmessage(this.Page, asc.sicurezza.xss.getreplacedencoded(E.ToString()));
            ok = false;
        }
        if (ok) asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.newletter.test.delivery.succesfull"));

    }


    void Page_Load()
    {

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " + asc.language.getforadminfromdictionary("admin.newsletter.wheryouare.newsletter");


        if (!IsPostBack)
        {
            buttInviaProva.Text = asc.language.getforadminfromdictionary("admin.newsletter.button.send.test.newsletter");
            buttInvia.Text = asc.language.getforadminfromdictionary("admin.newsletter.button.send.newsletter.to.users");

            tBoxFrom.Text = System.Configuration.ConfigurationManager.AppSettings["youremail"];

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





        <table width="100%" cellspacing="1">

            <tr class="admin_sfondo">
                <td width="300"><%=asc.language.getforadminfromdictionary("admin.newsletter.from") %>:&nbsp;&nbsp;</td>
                <td class="admin_sfondobis">
                    <asp:TextBox EnableViewState="TRUE" ID="tBoxFrom" style="color:#aaa" runat="server" onfocus="blur()" />
                </td>
            </tr>


            <tr class="admin_sfondo">
                <td width="300"><%=asc.language.getforadminfromdictionary("admin.newsletter.subject") %>:&nbsp;&nbsp;</td>
                <td class="admin_sfondobis">
                    <asp:TextBox Text="" EnableViewState="TRUE" ID="tBoxSubject" size="100" runat="server" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td width="300" colspan="2">
                    <%=asc.language.getforadminfromdictionary("admin.newsletter.body") %>:
        <br />
                    <textarea runat="server" id="tArea" validaterequestmode="disabled"></textarea>
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td width="300"><%=asc.language.getforadminfromdictionary("admin.newsletter.html.format") %>&nbsp;&nbsp;</td>
                <td class="admin_sfondobis">
                    <asp:CheckBox ID="cBoxHtml" EnableViewState="TRUE" runat="server" Checked="true" /></td>
            </tr>



        </table>


        <br>
        <br>
        <fieldset>
            <legend><%=asc.language.getforadminfromdictionary("admin.newsletter.send.test.email") %></legend>
            <br />
            <%=asc.language.getforadminfromdictionary("admin.newsletter.send.to.test.email") %>&nbsp;<asp:TextBox ID="tboxtestemailto" runat="server" />
            <br />
            <br />
            <asp:Button OnClick="buttInviaProva_click" runat="server" ID="buttInviaProva" class="bottone" />

            <asp:Label runat="server" ForeColor="Red" ID="lblesitotest" />
        </fieldset>
        <br />

        <fieldset>
            <legend>
                <%=asc.language.getforadminfromdictionary("admin.newsletter.send.to.users") %>
            </legend>


            <asp:Button OnClick="buttInvia_click" runat="server" ID="buttInvia" class="bottone" />
            <br />
            <asp:Label runat="server" ID="lblesito" />
            <asp:Timer ID="timer1" runat="server" Interval="60000" OnTick="timer_tick" Enabled="false" />



            <asp:Label runat="server" ForeColor="Red" ID="lblesitowork" />
            <p></p>
        </fieldset>
       <p></p>

    </form>
</asp:Content>



