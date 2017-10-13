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

<script runat="server" >

    void Page_Load ()
    {

        int idart = int.Parse(Request.QueryString["id"]);

        string sql = "select " + asc.products.commaseparatedfields + " from tproducts where art_id=@idart";

        asc.product p = asc.products.get(sql, new System.Data.OleDb.OleDbParameter("idart", idart))[0];

        Response.Redirect(p.Linkart);
    }

</script>