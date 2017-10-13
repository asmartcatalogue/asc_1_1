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


<script runat="server">

    void cambioPass_click (object sender, EventArgs e) {



        if ( !asc.admin.sicurezza.adminAutenticato(tBoxOld.Text))
            lblerr.Text = asc.language.getforadminfromdictionary("admin_pass.error.wrong.old.password");
        else
        if (tBoxPass.Text != tBoxRipetiPass.Text)
            lblerr.Text = asc.language.getforadminfromdictionary("admin_pass.error.password.and.repeat.password.different");
        else
        if (tBoxPass.Text.Length>asc.common.maxLenPwAdmin)
            lblerr.Text =
              String.Format(asc.language.getforadminfromdictionary ("admin_pass.error.max.length.is"), asc.common.maxLenPwAdmin) ;
        else if ( !asc.sicurezza.limit.containsonlycharsandnumbers(tBoxPass.Text))
            lblerr.Text = asc.language.getforadminfromdictionary ("admin_pass.char.not.allowed");

        else {
            asc.admin.sicurezza.cambioPass (tBoxPass.Text);
            Response.Redirect("~/admin/admin_logout.aspx");
        }
    }


    void Page_Init()
    {
        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; "+
         asc.language.getforadminfromdictionary("admin_pass.label.change.password");

        buttCambioPass.Text = asc.language.getforadminfromdictionary("admin_pass.button.change.password");

    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server" >
</asp:content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
<form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
<asp:label id="lblerr" enableviewstate=false runat=server CssClass="messaggioerroreadmin" /><br />
            
			
	<div class="big"><%=asc.language.getforadminfromdictionary("admin_pass.label.change.password")%>
 
		<table>

			<tr>
				<td>
         <%=asc.language.getforadminfromdictionary("admin_pass.label.old.password")%>:
				</td>
				<td>
				<asp:textbox
	        enableviewstate="false"
	        id="tBoxOld"
	        cssClass="inputsmall"
            width="200px"
            textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td>
        <%=asc.language.getforadminfromdictionary("admin_pass.label.new.password")%>:
				</td>
				<td>
				<asp:textbox
	        enableviewstate="false"
	        id="tBoxPass"
	        cssClass="inputsmall"
					width="200px"
					textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td>
        <%=asc.language.getforadminfromdictionary("admin_pass.label.repeat.new.password")%>:
				</td>
				<td><asp:textbox
	        enableviewstate="false"
	        id="tBoxRipetiPass"
	        cssClass="inputsmall"
					width="200px"
					textmode="password"
	        runat="server" />
				</td>
			</tr>
			<tr>
				<td colspan="2" style="padding-top:10px">
        <asp:linkbutton
        id="buttCambioPass"
        onClick="cambioPass_click"
        runat="server" />
				</td>
			</tr>
		</table>
	</div>

</form></asp:Content>