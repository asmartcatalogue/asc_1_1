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

<%@ Page Language="C#" CodeFile="articoli.aspx.cs" Inherits="asc.behindArticoliAspx" MasterPageFile="~/shop/masterpage.master" %>


<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.Common" %>

<asp:Content runat="server" ContentPlaceHolderID="parteCentrale">






    <div style="height: 20px"></div>

    <img runat="server" id="mainimg" class="defaultphoto" />



    <div style="height: 20px"></div>


    <ajaxToolkit:TabContainer runat="server" Width="100%" CssClass="CustomTabStyle" ID="tabcontainer">

        <ajaxToolkit:TabPanel ID="tabpanelfeatures" runat="server">
            <HeaderTemplate>
                <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.tab.features") %>
            </HeaderTemplate>
            <ContentTemplate>

                <div>
                    <p></p>
                    <div class="feature">
                        <b><%=(asc.language.getforfrontfromdictionaryincurrentlanguage("product.tab.name"))%>:</b>
                        <asp:Label ID="lblprodname" runat="server"></asp:Label>
                    </div>
                    <div class="feature">
                        <b><%=(asc.language.getforfrontfromdictionaryincurrentlanguage("product.artcode"))%>:</b>
                        <asp:Label ID="lblCodArticolo" runat="server"></asp:Label>
                    </div>
                    <asp:PlaceHolder runat="server" ID="pholderbrand" Visible="false">
                        <div class="feature">
                            <b><%=(asc.language.getforfrontfromdictionaryincurrentlanguage("product.brand"))%>:</b>
                            <asp:Label ID="lblbrand" runat="server"></asp:Label>
                        </div>
                    </asp:PlaceHolder>


                    <asp:PlaceHolder runat="server" ID="pholderprice" Visible="true">
                        <div class="feature">
                            <b><%=(asc.language.getforfrontfromdictionaryincurrentlanguage("product.price"))%>:</b>
                            <asp:Label ID="lblPrezzoArticolo" runat="server" />
                        </div>
                    </asp:PlaceHolder>


                    <asp:Label ID="lbladdfields" runat="server" />
                </div>
            </ContentTemplate>
        </ajaxToolkit:TabPanel>

        <ajaxToolkit:TabPanel ID="tabpaneldescrizione" runat="server" Visible="false">
            <HeaderTemplate>
                <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.description") %>
            </HeaderTemplate>
            <ContentTemplate>
                <div align="left">
                    <asp:Label ID="lblDescrizioneArticolo" runat="server" />
                </div>
            </ContentTemplate>
        </ajaxToolkit:TabPanel>

        <ajaxToolkit:TabPanel ID="tabpanelsecondayimages" Visible="false" runat="server">
            <HeaderTemplate>
                <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.tab.other.images")  %>
            </HeaderTemplate>
            <ContentTemplate>

                <asp:DataList
                    runat="server"
                    ID="listsecondaryimages"
                    RepeatDirection="Horizontal"
                    RepeatColumns="6"
                    OnItemDataBound="listsecondaryimages_databound">
                    <ItemStyle VerticalAlign="Bottom" />
                    <ItemTemplate>
                        <a href="#" id="anchorsecondaryimage" runat="server"><img runat="server" id="secondaryimage" class="addphoto" /></a>
                    </ItemTemplate>
                </asp:DataList>
            </ContentTemplate>
        </ajaxToolkit:TabPanel>


        <ajaxToolkit:TabPanel ID="tabpanelrelatedproducts" Visible="false" runat="server">
            <HeaderTemplate>
                <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.related.products")  %>
            </HeaderTemplate>
            <ContentTemplate>
                <p></p>
                <table border="0" cellpadding="0" cellspacing="0">
                    <asp:Repeater runat="server" ID="listrelatedproucts" OnItemDataBound="listrelatedproucts_databound">
                        <ItemTemplate>
                            <tr height="68">
                                <td runat="server" align="center">
                                    <a id="linkimg" runat="server" enableviewstate="false">
                                        <img id="img" runat="server" enableviewstate="false" class="smallphoto" /></a>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td runat="server" align="left">
                                    <asp:HyperLink ID="linkartname" runat="server" EnableViewState="false" />&nbsp;<asp:Label ID="lblPrezzoArticolo" runat="server" />
                                </td>
                            </tr>

                        </ItemTemplate>
                    </asp:Repeater>
                </table>

            </ContentTemplate>
        </ajaxToolkit:TabPanel>

        <ajaxToolkit:TabPanel ID="panelinfo" runat="server">
            <HeaderTemplate>
                <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.tab.info") %>
            </HeaderTemplate>
            <ContentTemplate>
                <p></p>
                <table style="width:100%;border-spacing: 10px;">
                    <tr>
                        <td colspan="3" class="spacetop">&nbsp;</td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.subject") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <asp:TextBox runat="server" ID="tboxinfosubject" class="requestinfoinput" ClientIDMode="Static" />
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.name") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <asp:TextBox runat="server" ID="tboxinfoname" class="requestinfoinput" ClientIDMode="Static" />
                        </td>
                    </tr>

                    <tr>
                        <td class="requestinfoleft">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.email") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <asp:TextBox runat="server" ID="tboxinfoemail" class="requestinfoinput" ClientIDMode="Static" />
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="vertical-align: top">
                            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.body") %>
                        </td>
                        <td class="requestinfomiddle">&nbsp;</td>
                        <td class="requestinforight">
                            <textarea runat="server" id="tareainfo" class="requestinfotarea" clientidmode="Static"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="text-align: center" colspan="3">
                            <p></p>
                            <asp:checkbox runat="server" id="cboxprivacy" Checked="true"/>&nbsp;<%=asc.language.getforfrontfromdictionaryincurrentlanguage("product.privacy.disclosures") %>
                        </td>
                    </tr>
                    <tr>
                        <td class="requestinfoleft" style="height: 30px; text-align: center" colspan="3">
                            <asp:Button OnClick="buttinfo_click" runat="server" ID="buttinfo" Text='<%#asc.language.getforfrontfromdictionaryincurrentlanguage("product.request.info.sendbutton") %>' />
                        </td>
                    </tr>

                    <tr>
                        <td class="requestinfoleft" style="text-align: center" colspan="3">
                            <asp:Label runat="server" ID="lblerrinfo" ForeColor="Red" Font-Bold="true" />
                        </td>
                    </tr>
                </table>

            </ContentTemplate>
        </ajaxToolkit:TabPanel>

        <p></p>
        <p></p>


    </ajaxToolkit:TabContainer>

















    <div>
        <br />
        <br />
    </div>

</asp:Content>




