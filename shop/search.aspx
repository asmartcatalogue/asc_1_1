<%@ Page Language="C#" MasterPageFile="masterpage.master" ValidateRequest="true" AutoEventWireup="true" CodeFile="search.aspx.cs" Inherits="articolipertermine" %>

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


<%@ Import Namespace="asc" %>


<asp:Content ID="Content1" ContentPlaceHolderID="parteCentrale" runat="server">



    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <tr>
            <td>
                <asp:Label runat="server" ID="lblerr" /></td>
        </tr>


        <tr>
            <td>
                <asp:ListView ID="listaarticoli" OnItemDataBound="listaarticoli_databound" runat="server"
                    OnPagePropertiesChanging="ListView1_PagePropertiesChanging" EnableViewState="true" ViewStateMode="Enabled">

                    <ItemTemplate>
                        <table style="width: 100%; height: 100px; margin-top: 20px; margin-bottom: 20px" border="0">

                            <tr>
                                <td valign="middle" style="width: 70px">
                                    <a id="linkimg" runat="server" >
                                        <img id="img" runat="server" class="defaultphoto" /></a>
                                </td>
                                <td width="20"></td>
                                <td valign="middle">
                                    <asp:HyperLink ID="linkartname" runat="server" />&nbsp;<asp:Label ID="lblprezzo" runat="server" /></span>

                                </td>
                            </tr>
                        </table>

                    </ItemTemplate>

                </asp:ListView>
            </td>
        </tr>

    </table>

    <div align="right">
        <%=asc.language.getforfrontfromdictionaryincurrentlanguage("preview.paging.label.page") %>  
        <asp:DataPager ID="datapager" runat="server" PagedControlID="listaarticoli">
            <Fields>
             <asp:NumericPagerField ButtonType="Link" NumericButtonCssClass="paging" />
            </Fields>
        </asp:DataPager>

    </div>


    <!-- fine parte sinistra-->





</asp:Content>










