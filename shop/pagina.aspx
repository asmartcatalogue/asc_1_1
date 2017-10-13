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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" %>

<%@ MasterType VirtualPath="~/shop/masterpage.master" %>
<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<script runat="server">

    int id;
    string nome = "";
    string testo = "";

    public void buttinfo_click(object o, EventArgs e)
    {
        lblerrinfo.Text = "";


        string fromemail = tboxinfoemail.Text.Trim();
        bool isvalidemail = true;

        try
        {
            var workemail = new System.Net.Mail.MailAddress(fromemail);
        }
        catch
        {
            isvalidemail = false;

        }

        if (!isvalidemail)
        {
            lblerrinfo.Text += asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.invalid.email.format");
        }


        if (tboxinfoname.Text.Trim() == "")
        {

            lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.missing.name");
        }

        if (tareainfo.InnerText.Trim() == "")
        {

            lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.missing.body");
        }
            if (!cboxprivacy.Checked)
            {

                lblerrinfo.Text += "<br>" + asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.missing.consent");
            }


        if (lblerrinfo.Text.Length == 0)
        {
            string subject = asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.subject.predefined") + " " + Application["config_nomesito"].ToString();
            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                string sql = "insert into trequests (r_when, r_subject, r_name, r_email, r_body) values (@when, @subject, @name, @email, @body)";

                asc.helpDb.nonQuery(
                    sql,
                    new OleDbParameter("when", System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")),
                    new OleDbParameter("subject", subject ),
                    new OleDbParameter("name", tboxinfoname.Text),
                    new OleDbParameter("email", tboxinfoemail.Text),
                    new OleDbParameter("body", tareainfo.InnerText)
                    );
            }



            string to = System.Configuration.ConfigurationManager.AppSettings["youremail"];
            string from = Server.HtmlEncode(tboxinfoemail.Text.Trim());
            string body = Server.HtmlEncode(tareainfo.InnerText.Trim());

            try
            {
                asc.email.send(from, to, subject, body, true);

            }
            catch (Exception E)
            { }

            lblerrinfo.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.message.sent");
            lblerrinfo.ForeColor = System.Drawing.Color.Blue;



        }

    }





    void Page_Load()
    {

        id = Convert.ToInt32(Request.QueryString["id"]);
        if (id > 0)
        {
            DataRow dr = asc.pagine.leggi(id);
            testo = asc.language.getforfrontfromstringincurrentlanguage(dr["pa_testo"].ToString());
            string rawname = dr["pa_nome"].ToString();

            lblContent.Text = testo;


            Label lblbreadcrumbsMaster = (Label)(Master.FindControl("lblbreadcrumbs"));
            lblbreadcrumbsMaster.Text =
                    common.linkescaped(asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home"), "default.aspx", "breadcrumbs") +
                    "&nbsp;&raquo;&nbsp;" +
                asc.language.getforfrontfromstringincurrentlanguage(rawname);

            string worktitle =
                 asc.language.getforfrontfromstringindefaultlanguage(rawname) + " | " + Application["config_nomesito"].ToString();
            Page.Title = asc.filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);

            if (dr["pa_type"].ToString()=="contactpage")
            {
                panelmodule.Visible = true;
                buttinfo.DataBind();
            }


        }


    }

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">





<center><b><asp:Label ID="lblWarning"  EnableViewState=false runat=server visible=false /></b></center>


<table cellspacing="0" cellpadding="0" width="100%" >
<tr>
<td>


<div style="text-align: left">
<asp:Label runat="server" ID="lblContent" Style="font-size: small" />
</div>


</td>
</tr>


</table>

                <p></p>

<asp:panel runat="server" ID="panelmodule" Visible="false">

                <table style="width:100%;border-spacing: 10px;" >
                    <tr>
                        <td colspan="3" class="spacetop">&nbsp;</td>
                    </tr>

                    <tr>
                        <td class="requestinfoleft">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.name") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <asp:TextBox runat="server" ID="tboxinfoname" class="requestinfoinput" ClientIDMode="Static" />
                        </td>
                    </tr>

                    <tr>
                        <td class="requestinfoleft">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.email") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <asp:TextBox runat="server" ID="tboxinfoemail" class="requestinfoinput" ClientIDMode="Static" />
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="vertical-align: top">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.body") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <textarea runat="server" id="tareainfo" class="requestinfotarea" clientidmode="Static"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="text-align: center" colspan="3">
                            <p></p>
                            <asp:checkbox runat="server" id="cboxprivacy" Checked="true"/>&nbsp;<%=asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.privacy.disclosures") %>
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="height: 30px; text-align: center" colspan="3">
                            <asp:Button OnClick="buttinfo_click" runat="server" ID="buttinfo" Text='<%#asc.language.getforfrontfromdictionaryincurrentlanguage("contactspage.request.info.sendbutton") %>' />
                        </td>
                    </tr>

                    <tr>
                        <td class="requestinfoleft" style="text-align: center" colspan="3">
                            <asp:Label runat="server" ID="lblerrinfo" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                </table>
    </asp:Panel>
                <p></p>




</asp:Content>
