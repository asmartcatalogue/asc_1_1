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

<%@ Page Language="C#" ValidateRequest="true"  %>
<%@ Import Namespace="System.Web.Security" %>
<%@ import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<script runat="server">

    void buttAccedi_click(object sender, EventArgs e)
    {

        if (
                tBoxPw.Text.Length <= asc.common.maxLenPwAdmin &&
                asc.sicurezza.limit.containsonlycharsandnumbers(tBoxPw.Text) &&
                asc.admin.sicurezza.adminAutenticato(tBoxPw.Text)
           )
        {
          FormsAuthentication.SetAuthCookie("asmartcatalogueadministrator", cboxremember.Checked);
          Response.Redirect("admin_menu.aspx");
        }
        else
          {
            lblMsgInvalid.Text = "<br>Invalid password (password non valida)</b>";
        }



    }








    void Page_Load()
    {
        if (Context.User.Identity.IsAuthenticated) Response.Redirect("admin_menu.aspx");
    }
</script>

<html>
<head runat="server">
<meta http-equiv="Page-Enter" content="RevealTrans(Duration=0,Transition=0)"/>
<title>asmartcatalogue administrator access</title>
<link href="~/css/admin_struttura.css" type="text/css" rel="stylesheet"  runat="server"/>
</head>
<body>
<form runat="server">
<table cellpadding="0" cellspacing="0" align="center" id="tablecontaineradmin" border="0"><tr><td>

    <table id="tablemenubaradmin" cellpadding="0" cellspacing="0" >
        <tr id="trdove">
            <td width="100%" height="20" id="tddove">
                <asp:Label runat="server" ID="lblDove" />
            </td>
            <td  style="text-align:right;" nowrap><a href="admin_logout.aspx" class="top" >logout&nbsp;as&nbsp;administrator (scollegami da amministratore)</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a target="_blank" runat="server" href="~/shop/main.aspx" class="top" style="color:yellow" >open&nbsp;store&nbsp;front&nbsp;window&nbsp;(apri lato negozio)&nbsp;</a></td>
        </tr>
        <tr><td colspan="2" style="background-color:#dedede;height:1px"></td></tr>
        <tr><td colspan="2" style="height:3px"></td></tr>
    </table>



        <asp:Panel ID="Panel1" DefaultButton="buttAccedi" runat="server">



                <br />
                <img runat="server" src="~/icons/key1.gif" align="absmiddle">&nbsp;&nbsp;<span class="adminSectionTitle">administrator access (accesso amministratore)</span>
                <br>
                <br>



                    <table width="1000" align="center" style="background-color:#eeeeee; border:solid 1px #aaaaaa; padding:10px">
                        <tr>
                            <td >&nbsp;</td>
                            <td nowrap>administrator password (password amministratore):</td>
                            <td><asp:TextBox class="inputsmall" ID="tBoxPw" Width="150px" TextMode="password" runat="server"></asp:TextBox></td>
                            <td>&nbsp;&nbsp;</td>
                            <td >&nbsp;</td>
                        </tr>
                            <tr>
                                <td></td>
                                <td nowrap>remember me next times (mantienimi collegato come amministratore ai prossimi accessi)</td>
                                <td><asp:CheckBox runat="server" ID="cboxremember" Checked="true" Css /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td></td>
                            </tr>
                        <tr>
                            
                            <td colspan=5 align="center" style="padding-top: 10px">
                                <asp:Button OnClick="buttAccedi_click" class="bottone" ID="buttAccedi" runat="server" Text="LOGIN (ACCEDI)" Width="120px"/>
                                <br />
                                <asp:Label EnableViewState="false" ID="lblDemo" runat="server" />
                                <asp:Label EnableViewState="false" ID="lblMsgInvalid" runat="server"  ForeColor="Red" Font-Bold="true"/>
                            </td>
                        </tr>
                    </table>
              
    
    </asp:Panel>


</td></tr></table></form></body></html>
