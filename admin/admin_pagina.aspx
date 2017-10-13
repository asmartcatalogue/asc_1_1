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
    int id;
    string title = "";

    void buttapri_click(object o, EventArgs e)
    {

        Response.Redirect("~/shop/pagina.aspx?id=" + id.ToString());

    }

    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bind();


    }

    void updateorigin()
    {

        ViewState["nametokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["nametokens"].ToString(), ViewState["l"].ToString(), tboxname.Text);
        ViewState["texttokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["texttokens"].ToString(), ViewState["l"].ToString(), tareatext.InnerText);

    }

    void bind()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }


        tboxname.Text = asc.language.getfromstringandlanguagename(ViewState["nametokens"].ToString(), ViewState["l"].ToString());
        tareatext.InnerText = asc.language.getfromstringandlanguagename(ViewState["texttokens"].ToString(), ViewState["l"].ToString());



    }






    void buttAggiorna_click(object sender, EventArgs e)
    {


        updateorigin();

        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            if (asc.language.getfromstringandlanguagename(ViewState["nametokens"].ToString(), frontlanguages[rip]) == "") ViewState["nametokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["nametokens"].ToString(), frontlanguages[rip], id.ToString());
        }


        string sql = "UPDATE tpagine SET" +
                " pa_nome=@nome, pa_testo=@testo, pa_type=@mytype" +
                " WHERE pa_id=@id";

        OleDbParameter p1 = new OleDbParameter("nome", ViewState["nametokens"].ToString());
        OleDbParameter p2 = new OleDbParameter("testo", ViewState["texttokens"].ToString());
        OleDbParameter p3 = new OleDbParameter("mytype", dlisttype.SelectedValue.ToString());
        OleDbParameter p4 = new OleDbParameter("id", id);

        asc.helpDb.nonQuery(sql, p1, p2, p3,p4);

        Response.Redirect(Request.Url.AbsoluteUri);

    }

    void Page_Init()
    {
        id = Convert.ToInt32(Request.QueryString["id"]);
        frontlanguages = ((Dictionary<string, string>)Application["mydictionary"]).Keys.ToList<string>(); ;
        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            Button b = new Button();
            b.CommandArgument = frontlanguages[rip];
            b.Text = frontlanguages[rip];
            b.Click += new EventHandler(changelanguageclick);
            panellanguages.Controls.Add(b);



        }


        id = Convert.ToInt32(Request.QueryString["id"]);


        if (id == 0)
        {



            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                cnn.Open();

                string sql;
                OleDbCommand cmd;

                sql = "INSERT INTO tpagine (pa_nome) VALUES ('')";
                cmd = new OleDbCommand(sql, cnn);
                cmd.ExecuteNonQuery();

                sql = "select max(pa_id) from tpagine";
                cmd = new OleDbCommand(sql, cnn);
                id = (int)cmd.ExecuteScalar();


                Response.Redirect(ResolveUrl("~/admin/admin_pagina.aspx?id=") + id.ToString());

            }
        }




    }

    void Page_Load()
    {


        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; ";
        ((Label)Master.FindControl("lbldove")).Text +=
                                                        "<a href='admin_pagine.aspx'>" +
                                                        asc.language.getforadminfromdictionary("admin.page.whereyouare") +
                                                        "</a> &raquo; " + asc.language.getforadminfromdictionary("admin.where.you.are.page.with.id") + " " + id.ToString();





        if (!Page.IsPostBack && id != 0)
        {
            buttAggiorna.Text = asc.language.getforadminfromdictionary("common.save.changes");
            buttapri.Text = asc.language.getforadminfromdictionary("admin.page.open.page");
            buttapri.Visible = true;

            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];

            if (ViewState["texttokens"] == null || ViewState["nametokens"] == null)
            {

                DataRow dr = asc.helpDb.getFirstRow("select pa_nome, pa_testo, pa_type from tpagine where pa_id=@id", new OleDbParameter("id", id));
                ViewState["texttokens"] = (string)dr["pa_testo"];
                ViewState["nametokens"] = (string)dr["pa_nome"];
                dlisttype.SelectedValue = dr["pa_type"].ToString();
            }
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

        <p></p>
        <div class="big">
 <%=asc.language.getforadminfromdictionary("admin.where.you.are.page.with.id") + " " + id.ToString()%>
        </div>
        <p></p>
        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>


        <asp:linkButton class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server" />
        &nbsp;&nbsp;
        <asp:LinkButton CssClass="bottone" OnClick="buttapri_click" ID="buttapri" runat="server" OnClientClick="window.document.forms[0].target='_blank';" />

        <p></p>
        <table width="100%" cellspacing="1">

            <tr class="admin_sfondo">
                <td><%=asc.language.getforadminfromdictionary("admin.page.title") %>
                </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxname"></asp:TextBox>
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td>type
                </td>
                <td>
                    <asp:DropDownList runat="server" ID="dlisttype">
                        <asp:ListItem Value="standardpage">standardpage</asp:ListItem>
                        <asp:ListItem Value="contactpage">contactpage</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>



            <tr class="admin_sfondo">
                <td colspan="2">
                    <%=asc.language.getforadminfromdictionary("admin.page.text") %>
                    <textarea runat="server" id="tareatext" validaterequestmode="disabled"></textarea>
                </td>
            </tr>



        </table>




    </form>
</asp:Content>
