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


<%@ Page Language="C#" ValidateRequest="true" %>
<%@ Import Namespace="asc" %>
<script runat="server">

    public bool done = false;

    void Page_PreInit()
    {

        if (Request.QueryString["strproblem"] != null)
        {
            lblmessage.Text = Server.HtmlEncode(Request.QueryString["strproblem"].ToString());
            done = true;
        }


    }

    void Page_Load()
    {
        if (!done)
        {



            if (Session["strproblem"] != null)
            {
                lblmessage.Text += Server.HtmlEncode(Session["strproblem"].ToString());
                Session["strproblem"] = null;
            }

            
            
            
            if (Session["linkreturn"] != null)
            {

                lblmessage.Text += ("<br><br><a href='" + Session["linkreturn"].ToString() + "'>back</a>");
                Session["linkreturn"] = null;
            }
            else lblmessage.Text += "<div align='center'><a href='#' onclick='history.back(1)'>back</a>";

        }
    }
    
</script>


<!DOCTYPE html>


<head>
 <title>asmartcatalogue error page</title>
<style>

 body {font-size:22px; font-family:Calibri}
 fieldset > legend {font-size:22px;font-family:Calibri}

</style>

</head>
<body>




<div align="center">

 <fieldset style="width:1000px">

  <legend>

   <%=asc.language.getforfrontfromdictionaryincurrentlanguage("problem.label.error.has.occurred") %>

  </legend>


    <asp:Label ID="lblmessage" runat="server" />

  </fieldset>


</div>

 </body>







