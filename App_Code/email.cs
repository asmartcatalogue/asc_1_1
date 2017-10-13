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


using System.Net.Mail;
using System.Web;

namespace asc
{













    public class email
    {



        




        public static void send(string from, string to, string subject, string body, bool formatoHtml)
        {

            SmtpClient emailClient;
            emailClient = new SmtpClient(System.Configuration.ConfigurationManager.AppSettings["smtpserver"]);


            if (System.Configuration.ConfigurationManager.AppSettings["useauthentication"] == "true")
            {


                System.Net.NetworkCredential SMTPUserInfo;
                SMTPUserInfo = new System.Net.NetworkCredential(System.Configuration.ConfigurationManager.AppSettings["authenticationemail"], System.Configuration.ConfigurationManager.AppSettings["authenticationpass"]);
                emailClient.UseDefaultCredentials = false;
                emailClient.Credentials = SMTPUserInfo;

            }

            MailMessage message = new MailMessage();
            message.To.Add(to);
            message.From = new MailAddress(System.Configuration.ConfigurationManager.AppSettings["youremail"]);

            message.Subject = subject;
            message.Body = body;
            message.IsBodyHtml = formatoHtml;


            emailClient.Send(message);





        }
    }


}
























