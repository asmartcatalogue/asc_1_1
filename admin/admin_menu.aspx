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


<script runat="server">



























    void buttPass_click(object sender, EventArgs e)
    {

        Response.Redirect("admin_pass.aspx");
    }



    void buttCategorie_click(object sender, EventArgs e)
    {

        Response.Redirect("admin_categorie.aspx");

    }


    void Page_Init()
    {



        ((Label)Master.FindControl("lblDove")).Text = asc.language.getforadminfromdictionary("admin.label.administration.menu");




    }


</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">



    <table width="100%" border="0" id="tablemenuadmin">
        <tr>
            <td valign="top" width="100%">

                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.label.configuration") %></div>


                <a href="admin_pass.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.change.admin.password") %></a>

                <br />

                <a href="admin_openclose.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.open.close.shop") %></a>


                <br />
                <a href="admin_metatag.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.meta.tag") %></a>

                <br />
                <a href="admin_currencies.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.currencies") %></a>

                <br />
                <a href="admin_taxes.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.tax.settings") %></a>

                
                <br />

                <a href="admin_otherparameters.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.web.site.parameters") %></a>






                <div>
                    <br />
                </div>
                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.label.catalog") %></div>

                <a href="admin_categorie.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.categories.and.subcategories") %></a>
                <br />

                <a href="admin_products.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.products") %></a>
                <br />

                <a href="admin_additionalfields.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.additional.fields") %></a>
                <br />


                <div>
                    <br />
                </div>
                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.info.requests") %></div>
                <a href="admin_requests.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.view.info.requests") %></a>


                <div>
                    <br />
                </div>



                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.label.pages") %></div>
                <a href="admin_homepage.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.pages.homepage") %></a>

                <br />
                <a href="admin_pagine.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.extra.pages") %></a>


                <div>
                    <br />
                </div>
                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.label.newsletter") %></div>


                <a href="admin_newsletter.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.newsletter") %></a>

                <br />
                <a href="admin_iscrittinewsletter.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.registered.to.newsletter") %></a>


                <div>
                    <br />
                </div>




                <div class="groupmenu"><%=asc.language.getforadminfromdictionary("admin.menu.label.others") %></div>
                <a href="admin_cookiebar.aspx"><%=asc.language.getforadminfromdictionary("common.cookie.bar") %></a>
                <br />
                <a href="admin_restartsite.aspx"><%=asc.language.getforadminfromdictionary("admin.menu.label.restart.site") %></a>

            </td>
        </tr>
    </table>

    <div>
        <br />
        <br />
    </div>



</asp:Content>


