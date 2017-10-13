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
using System.Security.Cryptography;
using System.Text;
using System.Web;



/// <summary>
/// Descrizione di riepilogo per Class1
/// </summary>

namespace asc
{
    namespace sicurezza
    {

        public class limit
        {

            public static bool containsonlycharsandnumbers(string stringa)
            {

                bool result = true;

                string ammessi = "01234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

                for (int rip = 0; rip < stringa.Length; rip++)
                {

                    if (!ammessi.Contains(stringa.Substring(rip, 1)))
                    {
                        
                        result = false;

                        rip = stringa.Length;
                    }


                }

                return result;

            }


        }



    

    public class xss
        {

            public static string getreplacedencoded(string stringa)
            {

                string result="";
                if (stringa!=null && stringa.Length > 0) { 
                    result = HttpContext.Current.Server.HtmlEncode(stringa);
                }

                return result;
            }

        }

        public class sanitize
        {
            public static string sanitizzata(string stringa, bool redirect = false)
            {


                string work1 = HttpContext.Current.Server.HtmlEncode(stringa);



                if ((stringa != work1) && redirect)
                {
                    HttpContext.Current.Session["strproblem"] = asc.language.getforfrontfromdictionaryincurrentlanguage("security.type.not.allowed.chars"); 

                    HttpContext.Current.Response.Redirect("~/shop/problem.aspx");
                }
                return work1;




            }

        }
        public class crittmd5
        {

            public static byte[] encoda(string stringa)
            {
                MD5CryptoServiceProvider md5Hasher = new MD5CryptoServiceProvider();
                UTF8Encoding encoder = new UTF8Encoding();
                return md5Hasher.ComputeHash(encoder.GetBytes(stringa));

            }
        }

        public class critt
        {

            private const string chiave = "AxTQQJCfGTbRbgLL";
            private const string iv = "xWExgfTHaxxLbqdO";

            public static string Encode(string S)
            {
                RijndaelManaged rjm = new RijndaelManaged();
                rjm.KeySize = 128;
                rjm.BlockSize = 128;
                rjm.Key = ASCIIEncoding.ASCII.GetBytes(chiave);
                rjm.IV = ASCIIEncoding.ASCII.GetBytes(iv);
                Byte[] input = Encoding.UTF8.GetBytes(S);
                Byte[] output = rjm.CreateEncryptor().TransformFinalBlock(input, 0,
                input.Length);
                return Convert.ToBase64String(output);
            }


            public static string Decode(string S)
            {
                RijndaelManaged rjm = new RijndaelManaged();
                rjm.KeySize = 128;
                rjm.BlockSize = 128;
                rjm.Key = ASCIIEncoding.ASCII.GetBytes(chiave);
                rjm.IV = ASCIIEncoding.ASCII.GetBytes(iv);
                try
                {
                    Byte[] input = Convert.FromBase64String(S);
                    Byte[] output = rjm.CreateDecryptor().TransformFinalBlock(input, 0,
                    input.Length);
                    return Encoding.UTF8.GetString(output);
                }
                catch
                {
                    return S;
                }
            }

            private const string chiavehost = "AxTGGJCfGTbRbgLL";
            private const string ivhost = "xWExgfTHaHHLbqdO";

            public static string Encodehost(string S)
            {
                RijndaelManaged rjm = new RijndaelManaged();
                rjm.KeySize = 128;
                rjm.BlockSize = 128;
                rjm.Key = ASCIIEncoding.ASCII.GetBytes(chiavehost);
                rjm.IV = ASCIIEncoding.ASCII.GetBytes(ivhost);
                Byte[] input = Encoding.UTF8.GetBytes(S);
                Byte[] output = rjm.CreateEncryptor().TransformFinalBlock(input, 0,
                input.Length);
                return Convert.ToBase64String(output);
            }

            public static string Decodehost(string S)
            {
                RijndaelManaged rjm = new RijndaelManaged();
                rjm.KeySize = 128;
                rjm.BlockSize = 128;
                rjm.Key = ASCIIEncoding.ASCII.GetBytes(chiavehost);
                rjm.IV = ASCIIEncoding.ASCII.GetBytes(ivhost);
                try
                {
                    Byte[] input = Convert.FromBase64String(S);
                    Byte[] output = rjm.CreateDecryptor().TransformFinalBlock(input, 0,
                    input.Length);
                    return Encoding.UTF8.GetString(output);
                }
                catch
                {
                    return S;
                }
            }




        }
    }
}