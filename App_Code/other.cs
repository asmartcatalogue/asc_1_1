using System;
using System.IO;
using System.Web;
using System.Data.OleDb;
using System.Linq;
namespace asc
{



    public class other
    {

        public static void RestartIfLanguagesHaveChanges()
        {
            DirectoryInfo di = new DirectoryInfo(HttpContext.Current.Server.MapPath(System.Configuration.ConfigurationManager.AppSettings["languagespath"]));
            var lastmod = di.GetFiles("*.*", SearchOption.AllDirectories)
            .OrderByDescending(f => f.LastWriteTime)
            .First().LastWriteTime;


            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                cnn.Open();
                DateTime lastrestart = (DateTime)asc.helpDb.getScalarByOpenCnn(cnn, "select top 1 o_lastrestart from other");
                if (lastrestart < lastmod)
                {
                    asc.helpDb.nonQueryByOpenCnn(cnn, "update other set o_lastrestart=@lastrestart", new OleDbParameter("lastrestart", lastmod.AddSeconds(1).ToString("yyyy-MM-dd HH:mm:ss")));
                    asc.language.loadlanguages();
                }

            }
        }
    }
}