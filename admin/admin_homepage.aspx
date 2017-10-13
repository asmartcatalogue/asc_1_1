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
    List<string> frontlanguages;
    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bind();


    }

    void updateorigin()
    {

        ViewState["welcomemessagetokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["welcomemessagetokens"].ToString(), ViewState["l"].ToString(), tareawelcomemessage.InnerText);

    }

    void bind()
    {

        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }


        tareawelcomemessage.InnerText = asc.language.getfromstringandlanguagename(ViewState["welcomemessagetokens"].ToString(), ViewState["l"].ToString());


    }

    void buttAggiorna_click(Object sender, EventArgs e)
    {
        updateorigin();


        string strSql;
        OleDbCommand cmd;

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {

            cnn.Open();

            strSql = "UPDATE tconfig SET" +
            " config_welcometext=@welcometext";

            cmd = new OleDbCommand(strSql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@welcometext", ViewState["welcomemessagetokens"]));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }


        asc.config.storeConfig();






        bind();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));

    }


    void Page_Load()
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

        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
         asc.language.getforadminfromdictionary("admin.homepage.whereyouare.homepage");

        if (!Page.IsPostBack)
        {
            buttAggiorna.Text = asc.language.getforadminfromdictionary("common.save.changes");
            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];
            if (ViewState["welcomemessagetokens"] == null)
                ViewState["welcomemessagetokens"] = (string)asc.helpDb.getScalar("select top 1 config_welcometext from tconfig");

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
        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.homepage.whereyouare.homepage") %>
        </div>
        <p></p>
        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>



        <table cellpadding="0" cellspacing="1" style="width: 100%">



            <tr class="admin_sfondo">
                <td colspan="2">
                    <%=asc.language.getforadminfromdictionary("admin.homepage.welcome.message") %>:
                <br />
                    <textarea runat="server" id="tareawelcomemessage" validaterequestmode="disabled"></textarea>
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td align="center" colspan="2" style="padding-top: 20px">
                    <asp:Button ID="buttAggiorna" OnClick="buttAggiorna_click" runat="server" class="bottone" /></td>
            </tr>
        </table>


    </form>
</asp:Content>


