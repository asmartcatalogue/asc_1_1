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

<script runat="server">



	void bind()
	{

		dDLOpenClose.SelectedValue = HttpContext.Current.Application["config_openclose"].ToString();
		tArea.InnerText = (string)HttpContext.Current.Application["config_msgchiusura"];



	}



	void buttAggiorna_click(object sender, EventArgs e)
	{



		int openClose = Convert.ToInt32(dDLOpenClose.SelectedValue);


		OleDbCommand cmd;
		string strSql;

		using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
		{
			cnn.Open();

			strSql = "UPDATE tconfig SET config_openclose=@openclose , config_msgchiusura=@msgchiusura";
			cmd = new OleDbCommand(strSql, cnn);

			cmd.Parameters.Add(new OleDbParameter("@openclose", openClose));
			cmd.Parameters.Add(new OleDbParameter("@msgchiusura", tArea.InnerText));
			cmd.ExecuteNonQuery();

			cnn.Close();
		}

		asc.config.storeConfig();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.message.changes.saved"));
		bind();

	}


	void Page_Load()
	{
		((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
		 asc.language.getforadminfromdictionary("admin_openclose.menu.bar.open.close.shop");


		if (!Page.IsPostBack)
		{

			dDLOpenClose.Items.Add ( new ListItem( asc.language.getforadminfromdictionary("admin_openclose.choose.open"), "0" ));
			dDLOpenClose.Items.Add ( new ListItem( asc.language.getforadminfromdictionary("admin_openclose.choose.closed"), "1" ));
			bind();
			buttAggiorna.Text = asc.language.getforadminfromdictionary("admin.button.update");
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

        <table align="center" cellspacing="1" width="100%">
            <tr class="admin_sfondo">
                <td width="322"><%=asc.language.getforadminfromdictionary("admin_openclose.label.open.closed.shop") %></td>
                <td width="718">
                    <asp:DropDownList runat="server" ID="dDLOpenClose" />
                </td>
            </tr>

            <tr class="admin_sfondo">
                <td><%=asc.language.getforadminfromdictionary("admin_openclose.label.message.for.closed.shop") %></td>
                <td >
                                  <textarea runat="server" id="tArea" validaterequestmode="disabled"></textarea>

                </td>
            </tr>




        </table>





        <br>


        <div align="right" style="padding-right: 20px">
            <asp:Button class="bottone" OnClick="buttAggiorna_click" ID="buttAggiorna" runat="server"  />
        </div>






</form></asp:Content>
