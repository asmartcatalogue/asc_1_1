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

using System.Collections.Generic;
using System.Web;
using System;
using System.Linq;
using System.IO;
namespace asc
{



    public class language
    {
        public static void loadlanguages()
        {

            Dictionary<string, string> mydictionary = new Dictionary<string, string>();
            List<string> workalllanguages = System.Configuration.ConfigurationManager.AppSettings["frontlanguages"].Split(',').ToList<string>();
            string workadminlanguage = System.Configuration.ConfigurationManager.AppSettings["adminlanguage"];
            if (!workalllanguages.Contains(workadminlanguage)) workalllanguages.Add(workadminlanguage);

            string p = HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["languagespath"]);

            string[] arrf = Directory.GetFiles(p, "*.*", SearchOption.AllDirectories);


            foreach (string l in workalllanguages)
            {

                foreach (string f in arrf)
                {
                    using (var reader = new StreamReader(f))
                    {
                        string line1 = reader.ReadLine();
                        if (line1 == "<languagename>" + l + "</languagename>")
                        {
                            string text = reader.ReadToEnd();
                            mydictionary.Add(l, text);
                            break;
                        }
                    }

                }
            }


            HttpContext.Current.Application["mydictionary"] = mydictionary;

        }
        // front
        public static string getforfrontfromdictionaryincurrentlanguage(string pseudo)
        {
            return getfromdictionary(pseudo, (string)HttpContext.Current.Session["currentfrontlanguage"]);

        }
        // front
        public static string getforfrontfromdictionaryindefaultlanguage(string pseudo)
        {
            return getfromdictionary(pseudo, System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]);

        }
        // front
        public static string getforfrontfromstringincurrentlanguage(string stringtoparse)
        {

            return getfromstringandlanguagename(stringtoparse, (string)HttpContext.Current.Session["currentfrontlanguage"]);
        }
        // front
        public static string getforfrontfromstringindefaultlanguage(string stringtoparse)
        {

            return getfromstringandlanguagename(stringtoparse, System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]);
        }


        // admin
        public static string getforadminfromdictionary(string pseudo)
        {


            return getfromdictionary(pseudo, System.Configuration.ConfigurationManager.AppSettings["adminlanguage"]);

        }



        //admin
        public static string getforadminfromstring(string stringtoparse)
        {
            return getfromstringandlanguagename(stringtoparse, System.Configuration.ConfigurationManager.AppSettings["adminlanguage"]);


        }

        public static string getfromdictionary(string mypseudo, string mylanguagename)
        {

            string result = null;

            string tokens = ((Dictionary<string, string>)HttpContext.Current.Application["mydictionary"])[mylanguagename];


            string tosearch = mypseudo + "@@";

            int nfound = tokens.LastIndexOf(tosearch);

            if (nfound > -1)
            {
                int start = nfound + tosearch.Length;

                int end = tokens.IndexOf("</sent>", start);

                if (end > start) result = tokens.Substring(start, end - start);
            }


            if (result != null) return result;
            else throw new Exception("pseudo " + mypseudo + " not found in languagefile");
        }


        public static string getfromstringandlanguagename(string mystringtoparse, string mylanguagename)
        {
            if (mystringtoparse == null) return "";
            string result = "";
            string[] tokens = mystringtoparse.Split(new string[] { "@@" }, StringSplitOptions.RemoveEmptyEntries);

            for (int rip = 0; rip < tokens.Length; rip++)
            {
                string token = tokens[rip];
                int pointposition = token.IndexOf(".");
                if (pointposition < 0) return "";
                if (token.Substring(0, pointposition) == mylanguagename)
                {
                    result = token.Substring(pointposition + 1);
                    break;
                }
            }
            return result;

        }


        public static string addorupdateonetoken_and_removetokenswihoutwords(string mystringtoparse, string mylanguagename, string newword)
        {
            string result = "";

            if (mystringtoparse == null) mystringtoparse = "";

            List<string> tokens = mystringtoparse.Split(new string[] { "@@" }, StringSplitOptions.None).ToList<string>()
.Where(myrow => myrow.IndexOf(".") > 0 && myrow.Substring(myrow.IndexOf(".")).Length > 0)
.ToList();

            bool foundlanguage = false;
            for (int rip = 0; rip < tokens.Count; rip++)
            {
                int pointposition = tokens[rip].IndexOf(".");
                string leftpart = tokens[rip].Substring(0, pointposition);
                if (leftpart == mylanguagename)
                {
                    tokens[rip] = mylanguagename + "." + newword;
                    foundlanguage = true;
                    break;
                }
            }

            if (!foundlanguage) tokens.Add(mylanguagename + "." + newword);

            foreach (string s in tokens)
            {
                string separator = (result.Length > 0 ? "@@" : "");
                int pointposition = s.IndexOf(".");
                if (s.Length > pointposition + 1)
                {
                    // there is a word with at least one char so I add to the result the token with his language and word
                    string leftpart = s.Substring(0, pointposition);
                    string rightpart = s.Substring(pointposition + 1);
                    result += separator + leftpart + "." + rightpart;
                }
            }

            return result;

        }
    }

}