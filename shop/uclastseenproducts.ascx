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


<%@ Control Language="c#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Data" %>

<script runat="server">
    public void bindingseenproducts(object sender, DataListItemEventArgs e)
    {




        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            asc.product myproduct = (asc.product)e.Item.DataItem;

            ((HtmlAnchor)e.Item.FindControl("linkImage")).HRef = myproduct.Linkart;
            ((HtmlAnchor)e.Item.FindControl("linkImage")).Title = asc.language.getforfrontfromstringincurrentlanguage( myproduct.Namealllang);


            HtmlImage img = (HtmlImage)e.Item.FindControl("imgArt");
            img.Src = ResolveUrl("~/image.aspx?type=0&id=" + myproduct.Id);


        }

    }

    void Page_Load()
    {

        // show seen products
        List<product> codatoshow = (List<product>)Session["coda"];

        if (codatoshow.Count > 0)
        {

            List<product> codaOrdinata = new List<product>();
            // ordine inverso
            for (int rip = codatoshow.Count - 1; rip >= 0; rip--)
            {
                codaOrdinata.Add(codatoshow[rip]);
            }
            listseenproducts.DataSource = codaOrdinata;
            listseenproducts.DataBind();

            pholderlastseenproducts.Visible = true;

        }


    }


</script>

<asp:PlaceHolder runat="server" ID="pholderlastseenproducts" Visible="false">

    <table cellspacing="0" cellpadding="0">
        <tr>
            <td nowrap><span style="font-size: small"><%=(asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.menu.viewed.products"))%></span>&nbsp;</td>
        </tr>
    </table>

        <asp:DataList runat="server" ID="listseenproducts" OnItemDataBound="bindingseenproducts" RepeatColumns="1" RepeatDirection="Horizontal" >
            <ItemTemplate>
                <a runat="server" id="linkImage"><img id="imgArt" class="smallphoto" runat="server" /></a>
            </ItemTemplate>
            <SeparatorTemplate><img src="~/immagini/space.gif" runat="server" width="20"/></SeparatorTemplate>
        </asp:DataList>


</asp:PlaceHolder>
