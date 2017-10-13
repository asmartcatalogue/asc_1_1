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


<%@ Page Language="C#" MasterPageFile="~/shop/masterpage.master" CodeFile="~/shop/main.aspx.cs" Inherits="asc.behindMainAspx" %>

<%@ MasterType VirtualPath="~/shop/masterpage.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">


<table cellspacing="0" cellpadding="0" width="100%" style="margin-top:10px">
<tr>
<td>
<div style="font-size: small">
<%= asc.language.getforfrontfromstringincurrentlanguage(HttpContext.Current.Application["config_welcometext"].ToString()) %>
</div>
</td>
</tr>
</table>

</asp:Content>

