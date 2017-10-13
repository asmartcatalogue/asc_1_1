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

<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>


<script runat="server">

    void buttEmail_click(object sender, EventArgs e)
    {

        Response.Redirect("newsletter.aspx?azione=iscrivi&email=" + Server.UrlEncode(tBoxEmail.Text));

    }


    void buttEmailCanc_click(object sender, EventArgs e)
    {
        Response.Redirect("newsletter.aspx?azione=cancella&email=" + Server.UrlEncode(tBoxEmail.Text));

    }



    void Page_Load()
    {

        Page.Title = asc.language.getforfrontfromdictionaryindefaultlanguage("newsletter.title");

        tBoxEmail.Attributes["onFocus"] = "this.value=''";
        buttEmail.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.mailinglistbox.label.subscribe");
        buttEmailCanc.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.mailinglistbox.label.unsubscribe");


        string worktitle =
             asc.language.getforfrontfromdictionaryindefaultlanguage("newsletter.you.are.here.newsletter") +
             " | " + Application["config_nomesito"].ToString();
        Page.Title = asc.filtertext.getonlyallowedcharsfortitleandmetatag(worktitle);


        Label lblbreadcrumbsMaster = (Label)(Master.FindControl("lblbreadcrumbs"));
        lblbreadcrumbsMaster.Text = common.linkescaped(asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.you.are.here.home"), "main.aspx", "breadcrumbs");
        lblbreadcrumbsMaster.Text += "&nbsp;&raquo;&nbsp;" + asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.you.are.here.newsletter");


        if (Request.QueryString["azione"] != null)
        {


            if (Request.QueryString["azione"].ToString() == "iscrivi")
            {

                string email = Server.UrlDecode(Request.QueryString["email"].ToString());
                if (email.Length < 1 || email.IndexOf("@") == -1 || email.IndexOf(".") == -1)
                {
                    lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.warning.email.not.valid");
                }
                else
                {

                    bool esiste =
                        Convert.ToInt32(
                            asc.helpDb.getScalar(
                                "SELECT COUNT(*) FROM tmailing WHERE m_email=@email",
                                new OleDbParameter("email", email)))
                        > 0;

                    if (esiste)
                    {
                        lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.warning.you.already.registered");
                    }
                    else
                    {

                        string guid = Guid.NewGuid().ToString().Replace("-", "").Substring(0, 10);
                        asc.helpDb.nonQuery(
                            "INSERT INTO tmailing (m_email, m_guid) VALUES (@email, @guid)",
                            new OleDbParameter("email", email),
                            new OleDbParameter("guid", guid)
                            );


                        string from = System.Configuration.ConfigurationManager.AppSettings["youremail"];
                        string to = email;
                        string subject = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.email.subject.confirm.registration") + " " + (string)Application["config_nomesito"];
                        string body;

                        string a = Request.Url.AbsoluteUri.Remove(Request.Url.AbsoluteUri.IndexOf("newsletter.aspx"));

                        body = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.email.body.confirm.registration") + ": " +
                              a + ("newsletter.aspx?azione=conferma&guid=" + guid.ToString()) + "</a>";

                        asc.email.send(from, to, subject, body, true);
                        lblEsito.ForeColor = System.Drawing.Color.Blue;
                        lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.message.confirm.registration");
                    }
                }
            }
            else if (Request.QueryString["azione"].ToString() == "conferma")
            {
                string guid = Request.QueryString["guid"].ToString();
                OleDbCommand cmd;
                string strSql;

                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    cnn.Open();

                    strSql = "SELECT COUNT(*) FROM tmailing WHERE m_guid=@guid";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@guid", guid));

                    bool esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

                    if (!esiste)
                    {
                        cnn.Close();
                        lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.warning.no.subscription.present.with.this.email");
                        return;
                    }


                    strSql = "UPDATE tmailing SET m_confermato=1 WHERE m_guid=@guid";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@guid", guid));
                    cmd.ExecuteNonQuery();
                    cnn.Close();

                }


                lblEsito.ForeColor = System.Drawing.Color.Blue;
                lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.message.successfull.subscribed");

            }
            else if (Request.QueryString["azione"].ToString() == "cancella")
            {
                string email = Server.UrlDecode(Request.QueryString["email"].ToString());
                bool esiste = false;


                using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
                {
                    string strSql;
                    OleDbCommand cmd;

                    cnn.Open();
                    strSql = "SELECT COUNT(*) FROM tmailing WHERE m_email=@email";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@email", email));

                    esiste = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

                    strSql = "delete  FROM tmailing WHERE m_email=@email";
                    cmd = new OleDbCommand(strSql, cnn);
                    cmd.Parameters.Add(new OleDbParameter("@email", email));
                    cmd.ExecuteNonQuery();

                    cnn.Close();
                }


                if (esiste)
                {
                    lblEsito.Text += asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.message.successfull.unsubscribed");
                    lblEsito.ForeColor = System.Drawing.Color.Blue;
                }
                else lblEsito.Text = asc.language.getforfrontfromdictionaryincurrentlanguage("newsletter.message.problem.unsubscription");


            }
        }
    }

</script>

<asp:Content runat="server" ContentPlaceHolderID="parteCentrale">

    <asp:TextBox EnableViewState="true" ViewStateMode="Enabled" ID="tBoxEmail" CssClass="form" Style="font-size: 11px; width: 165px;" runat="server" Text="email" />
    &nbsp;&nbsp;<asp:Button CssClass="pulsante" runat="server" ID="buttEmail" OnClick="buttEmail_click" EnableViewState="true" ViewStateMode="Enabled" />
    &nbsp;&nbsp;<asp:Button CssClass="pulsante" runat="server" ID="buttEmailCanc" OnClick="buttEmailCanc_click" EnableViewState="true" ViewStateMode="Enabled" />


    <p>
        <asp:Label runat="server" ID="lblEsito" ForeColor="red" />
    </p>





</asp:Content>













