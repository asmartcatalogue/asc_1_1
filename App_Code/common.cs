/*
 
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
 
*/

using System;
using System.Web;

namespace asc
{


	public class common
	{
		public static void jquerymodalmessage(System.Web.UI.Page mypage, string s)
		{

            String csname1 = "PopupScript";
            Type cstype = mypage.GetType();
            System.Web.UI.ClientScriptManager cs = mypage.ClientScript;
            if (!cs.IsStartupScriptRegistered(cstype, csname1))
            {
                System.Text.StringBuilder mytext = new System.Text.StringBuilder();
                mytext.Append("<script type=text/javascript>");
                mytext.Append("$('#modaltable').show();");
                mytext.Append("jQuery('#maintable').css('opacity', '0.6'); ") ;
                mytext.Append("jQuery('#modalid').html(\"" + (s == "" ? "" : HttpUtility.JavaScriptStringEncode(s)) + "\")" ) ;
                mytext.Append("</");
                mytext.Append("script>");
                cs.RegisterStartupScript(cstype, csname1, mytext.ToString());
            }

        }


		public static int maxLenCod = 255;
		public static int maxLenNome = 255;
		public static int maxLenMarca = 255;
		public static int maxLenPwAdmin = 15;


		public static string linkescaped(string testo, string currentPageUrl)
		{
			string urlWithoutQuery = currentPageUrl.IndexOf('?') >= 0
					? currentPageUrl.Substring(0, currentPageUrl.IndexOf('?'))
					: currentPageUrl;

			string queryString = currentPageUrl.IndexOf('?') >= 0
					? currentPageUrl.Substring(currentPageUrl.IndexOf('?'))
					: null;

			var queryParamList = queryString != null
					? HttpUtility.ParseQueryString(queryString)
					: HttpUtility.ParseQueryString(string.Empty);



			string escapedurl = urlWithoutQuery + "?";

			foreach (string key in queryParamList)
			{

				string newvalue = ((queryParamList[key] == null ? string.Empty : System.Net.WebUtility.UrlEncode(queryParamList[key])));

				escapedurl += "&" + key + "=" + newvalue;

			}

			return "<a href=\"" + escapedurl + "\">" + HttpContext.Current.Server.HtmlEncode(testo) + "</a>";

		}

		public static string linkescaped(string testo, string currentPageUrl, string classe)
		{

			return linkescaped(testo,currentPageUrl).Replace("<a ", "<a class=\"" + classe + "\" ");

		}








	}

}