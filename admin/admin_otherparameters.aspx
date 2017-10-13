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
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
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

        ViewState["bottomtokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["bottomtokens"].ToString(), ViewState["l"].ToString(), tareabottom.InnerText);

    }

    void bind()
    {
        tboxsitename.Text = asc.sicurezza.xss.getreplacedencoded(asc.config.getCampoByDb("config_nomesito").ToString());

        tboxartperpag.Text = HttpContext.Current.Application["config_artperpag"].ToString();

        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }


        tareabottom.InnerText = asc.language.getfromstringandlanguagename(ViewState["bottomtokens"].ToString(), ViewState["l"].ToString());


    }








    void buttAggiorna_click(object sender, EventArgs e)
    {
        updateorigin();


        int artperpag = -1;

        try
        {
            artperpag = int.Parse(tboxartperpag.Text);

        }
        catch
        {

            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.layout.warning.insert.number.products.per.page"));
            return;
        }

        OleDbCommand cmd;
        string strSql;

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            strSql = "UPDATE tconfig SET config_artperpag=@artperpag, config_piede=@piede, config_nomeSito=@nomesito";
            cmd = new OleDbCommand(strSql, cnn);

            cmd.Parameters.Add(new OleDbParameter("@artperpag", tboxartperpag.Text));
            cmd.Parameters.Add(new OleDbParameter("@piede", ViewState["bottomtokens"]));
            cmd.Parameters.Add(new OleDbParameter("nomesito", tboxsitename.Text));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        asc.config.storeConfig();

        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));
        bind();

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
        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
         asc.language.getforadminfromdictionary("admin.parameters.whereyouare");

        if (!Page.IsPostBack)
        {
            buttAggiorna.Text = asc.language.getforadminfromdictionary("common.save.changes");
            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];
            if (ViewState["bottomtokens"] == null)
                ViewState["bottomtokens"] = (string)asc.helpDb.getScalar("select top 1 config_piede from tconfig");

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
            <%=asc.language.getforadminfromdictionary("admin.layout.layout") %>
        </div>
        <p></p>
        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>

        <table align="center" cellspacing="1" width="100%">

            <tr  class="admin_sfondo">
                <td width="322"><%=asc.language.getforadminfromdictionary("admin.parameters.site.name") %>:&nbsp;&nbsp;</td>
                <td width="718">
                    <asp:TextBox EnableViewState="false" ID="tboxsitename" runat="server" />
            </tr>

            <tr class="admin_sfondo">
                <td ><%=asc.language.getforadminfromdictionary("admin.layout.products.per.page") %>
                </td>
                <td >
                    <asp:TextBox EnableViewState="false" ID="tboxartperpag" Width="80" runat="server" />
            </tr>
            <tr class="admin_sfondo">
                <td colspan="2">
                    <%=asc.language.getforadminfromdictionary("admin.layout.bottom.text") %>
                    <textarea runat="server" id="tareabottom" validaterequestmode="disabled"></textarea>
                </td>
            </tr>


        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" />
        </div>






    </form>
</asp:Content>
