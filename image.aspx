<%@ Page Language="C#" ContentType="image/gif" %>

<%@ Import Namespace="System.Drawing" %>
<%@ Import Namespace="System.Drawing.Imaging" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="System.IO" %>


<script runat="server">


    void showna ()
    {

        Bitmap mybitmap = new Bitmap(Server.MapPath("~/immagini/non_disponibile.gif"));
        mybitmap.Save(Response.OutputStream, ImageFormat.Gif);
        Response.End();

    }

    void Page_Load(object sender, System.EventArgs e)
    {
        // types
        // 0 : product
        // 1 : category
        // 2 : seconday image
        //
        if (Request.QueryString["id"] == null || Request.QueryString["id"] == null) return;

        int type = int.Parse(Request.QueryString["type"].ToString());

        int id =int.Parse( Request.QueryString["id"]);

        string relpath = "";

        switch (type)
        {

            case 0:
                relpath = "~/app_data/p/" + id.ToString();
                break;

            case 1:
                relpath = "~/app_data/c/" + id.ToString();
                break;

            case 2:
                relpath = "~/app_data/morep/" + int.Parse(Request.QueryString["idart"].ToString()) + "/" + id.ToString();
                break;


            default:
                showna();
                break;
        }



        string fullpath = Server.MapPath(ResolveUrl(relpath));
        if (File.Exists (fullpath))
        {
            byte[] imgByteData = (byte[])File.ReadAllBytes(fullpath);
            Bitmap bitmap = new Bitmap(new System.IO.MemoryStream(imgByteData));
            bitmap.Save(Response.OutputStream, ImageFormat.Png);
        }
        else
        {
            showna();
        }
    }






</script>


