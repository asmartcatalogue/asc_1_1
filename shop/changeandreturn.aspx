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


<%@ Page Language="C#" %>
<%@ Import Namespace="asc" %>

<script runat="server">
		

		void Page_Load() {

	Dictionary<string, string> frontlanguages	 =(Dictionary<string, string>)Application["mydictionary"];


			// check language change
			if (Request.QueryString["idlanguage"] != null)
			{
				string value = Request.QueryString["idlanguage"].ToString();
				if (frontlanguages.Keys.Contains(value))
				{
					Session["currentfrontlanguage"] = value;
					Response.Redirect(Request.UrlReferrer.ToString());
				}
				else asc.problema.redirect("");



			}

			if (Request.QueryString["idcurrency"] != null)
			{

				string value = Request.QueryString["idcurrency"].ToString();
				int myvalue;
				if (Int32.TryParse(value, out myvalue))
				{
					System.Data.DataRow rowcurrentcurrency = asc.currencies.rowcurrencybyidcurrency(myvalue);
					asc.currency curr = new asc.currency(
					(int)rowcurrentcurrency["id"],
					(double)rowcurrentcurrency["cambio"],
					rowcurrentcurrency["nome"].ToString(),
					rowcurrentcurrency["decimalseparatorsymbol"].ToString(),
					(int)rowcurrentcurrency["decimali"],
					rowcurrentcurrency["groupseparatorsymbol"].ToString()
					);

					Session["frontendcurrency"] = curr;






					}


					Response.Redirect(Request.UrlReferrer.ToString());

				}
				else asc.problema.redirect("");
			}








</script>
