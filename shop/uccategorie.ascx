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

<%@ Control Language="c#" EnableViewState="true" ViewStateMode="Enabled" %>
<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.Collections" %>
<script runat="server">





    void Page_Load()
    {

        DataTable dtcat = (DataTable)Application["dtcat"];

        var sortedlist = (from row in dtcat.AsEnumerable()
                          where row.Field<int>("cat_idpadre") == 0
                          orderby (asc.language.getforfrontfromstringincurrentlanguage(row.Field<string>("cat_nome")))
                          select row).ToList<DataRow>();

        foreach (DataRow dr in sortedlist)
        {
            litcat.Text += "<tr><td class='contenutobox'><a href=\"" + asc.Category.Linkforrouting((int)dr["cat_id"], (string)dr["cat_nome"]) + "\">" +
            asc.language.getforfrontfromstringincurrentlanguage(dr["cat_nome"].ToString()) +
            "</a></td></tr>";
        }

    }
</script>


<table cellspacing="0" cellpadding="0" width="100%">
    <tr>
        <td class="titolobox">
            <%=asc.language.getforfrontfromdictionaryincurrentlanguage("inallthepages.menu.categories")%></td>
    </tr>

    <asp:Literal ID="litcat" runat="server" />


</table>


