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


<%@ Page Language="C#" MasterPageFile="masterpage.master" Inherits="asc.behindPreviewAspx" CodeFile="preview.aspx.cs" %>

<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>


<asp:Content ContentPlaceHolderID="headerpart" runat="server">

    <script type="text/javascript">
        function changedthusreload(selectobject, myparameter) {


            var myparameters = "?nosense=1";

            var requestUrl = decodeURI(window.location.search.toString());
            requestUrl = requestUrl.substring(1);

            var kvPairs = requestUrl.split('&');
            for (var i = 0; i < kvPairs.length; i++) {
                if (kvPairs[i].startsWith("page")) kvPairs[i] = "page=1";
                var kvPair = kvPairs[i].split('=');
                if (kvPair[0] != myparameter && kvPair[0] != "" && kvPair[0] != "nosense") {
                    myparameters += "&" + kvPair[0] + "=" + kvPair[1];
                }
            }
            // here myparameters contains '?nosense=1' plus the page query parameters concatenated with "&" ,  except the parameter myparameter (passed in the function) and except the parameter nosense


            window.location.href = encodeURI(
             window.location.href.split('?')[0] +
             myparameters +
             "&" + myparameter + "=" + selectobject.options[selectobject.selectedIndex].value
             )
            // myparameter is added and browser is redirected

            // 
        }
    </script>

</asp:Content>





<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">



    <asp:Panel ID="panelsubcat" runat="server" Visible="false" ViewStateMode="Disabled" EnableViewState="false">



        <asp:DataList ID="dlistsubcat" runat="server" RepeatColumns="4" OnItemDataBound="dlistsubcat_databound">
            <HeaderTemplate>
                <div class="big"><%#asc.language.getforfrontfromdictionaryincurrentlanguage("preview.subcategories") %></div>
                <p></p>
            </HeaderTemplate>
            <ItemTemplate>
                <table width="40" border="0">
                    <tr>
                        <td style="height: 80px" align="center">
                            <a runat="server" id="ancorImg" >
                                <img class="defaultphoto" runat="server" id="imgcat" /></a>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:HyperLink ID="linknamesubcat" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 20px">&nbsp;</td>
                    </tr>
                </table>

            </ItemTemplate>
            <SeparatorTemplate>
                <div style="width: 30px"></div>
            </SeparatorTemplate>
        </asp:DataList>




    </asp:Panel>







    <asp:Panel ID="panelArticoli" runat="server" Visible="false" EnableViewState="false">

        <div class="big"><%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.label.products") %></div>

        <table cellspacing="0" cellpadding="0" width="100%" id="tableprodincat">
            <tr>
                <td style="text-align:left">
                    <asp:PlaceHolder runat="server" ID="pHolderFiltri">
                        <div style="margin-top: 10px">
                            <asp:DropDownList ID="dlistord" runat="server" onchange="changedthusreload(this, 'ord')" />
                        </div>
                    </asp:PlaceHolder>

                </td>
            </tr>



            <tr>
                <td valign="middle">
                    <div style="margin-top: 10px">
                        <asp:ListView ID="list" runat="server" OnItemDataBound="listaarticoli_databound">

                            <ItemTemplate>

                                <table style="width: 100%; margin-top: 26px; margin-bottom: 26px">
                                    <tr>
                                        <td style="width: 70px"><a id="linkimg" runat="server">
                                            <img id="img" class="defaultphoto" runat="server" /></a></td>
                                        <td style="width: 20px">&nbsp;</td>
                                        <td>
                                            <asp:HyperLink ID="linkartname" runat="server" /><br />
                                            <asp:Label ID="lblPrezzo" runat="server" />
                                        </td>
                                    </tr>
                                </table>



                            </ItemTemplate>


                        </asp:ListView>
                    </div>
                </td>
            </tr>

            <tr>
                <td style="text-align:right">
                   <p></p>
                 <%=asc.language.getforfrontfromdictionaryincurrentlanguage("preview.paging.label.page") %>   <asp:Label ID="lblpaging" runat="server" />
                </td>
            </tr>
        </table>





    </asp:Panel>






</asp:Content>


