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

<%@ Page Language="C#" ValidateRequest="true" MasterPageFile="~/admin/admin_master.master" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="AjaxControlToolkit" %>
<%@ Import Namespace="asc" %>
<%@ Import Namespace="System.IO" %>


<script runat="server" id="↨">
    List<string> frontlanguages;

    protected int id;


    class c
    {
        public int Id;
        public string Name;
        public int Parentid;
        public c(int _id, int _parentid, string _name)
        {
            this.Parentid = _parentid;
            this.Id = _id;
            this.Name = _name;
        }
    }
    class cc
    {
        public int Id;
        public string Path;

        public cc(int _id, string _path)
        {

            this.Id = _id;
            this.Path = _path;
        }
    }



    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bindtoviewstate();

    }

    void bindtoviewstate()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }

        tboxname.Text = asc.language.getfromstringandlanguagename(ViewState["nametokens"].ToString(), ViewState["l"].ToString());
    }

    void updateorigin()
    {

        ViewState["nametokens"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(ViewState["nametokens"].ToString(), ViewState["l"].ToString(), tboxname.Text);

    }




    void bind()
    {



        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            OleDbCommand cmd;
            cnn.Open();
            string sql = "SELECT cat_id, cat_idpadre, cat_metadescription, cat_metakeywords FROM tcategorie WHERE cat_id=@id ORDER BY cat_nome";

            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@id", id));

            OleDbDataReader dr = cmd.ExecuteReader();
            dr.Read();

            tboxmetadescription.Text =  dr["cat_metadescription"].ToString();
            tboxmetakeywords.Text = dr["cat_metakeywords"].ToString();
            dDListCatPadre.SelectedValue = dr["cat_idpadre"].ToString();
            imgAttuale.ImageUrl = "~/image.aspx?type=1&id=" + dr["cat_id"].ToString();

            dr.Close();

        }





    }
















    void buttAggiorna_click(object sender, EventArgs e)
    {

        updateorigin();


        string nametokens = ViewState["nametokens"].ToString();

        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            if (asc.language.getfromstringandlanguagename(nametokens, frontlanguages[rip]) == "")
                nametokens = asc.language.addorupdateonetoken_and_removetokenswihoutwords(nametokens, frontlanguages[rip], id.ToString());
        }

        int idparent = int.Parse(dDListCatPadre.SelectedValue);


        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            string sql = "UPDATE tcategorie SET cat_idpadre=@idpadre, cat_nome=@nome WHERE cat_id=@id";
            OleDbCommand cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@idpadre", idparent));
            cmd.Parameters.Add(new OleDbParameter("@nome", nametokens));
            cmd.Parameters.Add(new OleDbParameter("@id", id));
            cmd.ExecuteNonQuery();

        }
        asc.caching.cacheallcategories();

        bool reload = true;
        if (pholderimg.Visible == true)
        {
            string imgrelativepath = "~/app_data/c/" + id.ToString();
            if (fileImg0.PostedFile.FileName != "")
            {
                asc.images.deleteandsave(fileImg0.PostedFile, imgrelativepath);
            }
            else
            {
                reload = false;
                asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.image.category.missing"));
            }
        }
        if (reload) Response.Redirect(Request.Url.AbsoluteUri);


    }



    void Page_Init()
    {
        frontlanguages = ((Dictionary<string, string>)Application["mydictionary"]).Keys.ToList<string>(); ;
        if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];
        if (ViewState["nametokens"] == null) ViewState["nametokens"] = "";

        for (int rip = 0; rip < frontlanguages.Count; rip++)
        {
            Button b = new Button();
            b.CommandArgument = frontlanguages[rip];
            b.Text = frontlanguages[rip];
            b.Click += new EventHandler(changelanguageclick);
            panellanguages.Controls.Add(b);

        }

    }
    void Page_Load()
    {

        id = Convert.ToInt32(Request.QueryString["id"]);
        if (id == 0)
        {
            // new category

            OleDbCommand cmd;
            string strSql;
            int idNew = 0;

            using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
            {
                cnn.Open();
                strSql = "INSERT INTO tcategorie" +
                " (cat_nome, cat_idpadre) " +
                " VALUES ('', 0)";
                cmd = new OleDbCommand(strSql, cnn);
                cmd.ExecuteNonQuery();
                strSql = "SELECT MAX(cat_id) FROM tcategorie";
                cmd = new OleDbCommand(strSql, cnn);
                idNew = (int)cmd.ExecuteScalar();

                string catname = "";
                for (int rip = 0; rip < frontlanguages.Count; rip++)
                {
                    if (catname.Length > 0) catname += "@@";
                    catname += frontlanguages[rip].ToString() + "." + idNew.ToString();
                }


                strSql = "update tcategorie set cat_nome=@catname, cat_metadescription=@metadescription, cat_metakeywords=@metakeywords where cat_id=@id";
                cmd = new OleDbCommand(strSql, cnn);
                cmd.Parameters.AddWithValue("catname", catname);
                cmd.Parameters.AddWithValue("metadescription", asc.language.getfromdictionary("admin.category.default.metatag.description", System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]));
                cmd.Parameters.AddWithValue("metakeywords", asc.language.getfromdictionary("admin.category.default.metatag.keywords", System.Configuration.ConfigurationManager.AppSettings["defaultfrontlanguage"]));
                cmd.Parameters.AddWithValue("id", idNew);
                cmd.ExecuteNonQuery();
                cnn.Close();
            }
            asc.caching.cacheallcategories();


            Response.Redirect("admin_catsottocat.aspx?id=" + idNew.ToString());
        }
        else
        {

            // in edit mode


            if (!Page.IsPostBack)
            {

                ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
                 " &raquo; " +
                 "<a href='" + ResolveUrl("~/admin/admin_categorie.aspx") + "'>" + asc.language.getforadminfromdictionary("admin.category.whereyouare.categories") + "</a>" +
                " &raquo; ";
                ((Label)Master.FindControl("lbldove")).Text += asc.language.getforadminfromdictionary("admin.category.whereyouare.categoryid") + id.ToString();

                buttAggiorna.Text = " " + asc.language.getforadminfromdictionary("admin.category.button.save") + " ";

                dDListCatPadre.Items.Add(new ListItem(asc.language.getforadminfromdictionary("admin.category.categorylist.no.parent.category"), "0"));

                DataTable dtcat = (DataTable)Application["dtcat"];
                DataRow currentrow = dtcat.Rows.Find(id);

                foreach (DataRow row in dtcat.Rows)
                {
                    ArrayList arcatid = new ArrayList();
                    ArrayList arcatname = new ArrayList();

                    arcatid.Add((int)row["cat_id"]);
                    arcatname.Add(asc.language.getforadminfromstring((string)row["cat_nome"]));
                    bool take = true;
                    int x = (int)row["cat_idpadre"];
                    bool loop = true;
                    while (loop)
                    {

                        DataRow drfound = dtcat.Rows.Find(x);
                        if (drfound == null) loop = false;
                        else
                        {

                            if ((int)drfound["cat_id"] == (int)currentrow["cat_id"])
                            {
                                take = false;
                                break;
                            }
                            arcatid.Add((int)drfound["cat_id"]);
                            arcatname.Add(asc.language.getforadminfromstring((string)drfound["cat_nome"]));
                            x = (int)drfound["cat_idpadre"];
                        }
                    }

                    if (take)
                    {
                        arcatid.Reverse();
                        arcatname.Reverse();
                        string path = "";
                        for (int rip = 0; rip < arcatid.Count; rip++)
                        {
                            if (path.Length > 0) path += "-->";
                            path += (string)arcatname[rip];
                        }
                        if ((int)row["cat_id"] != id) dDListCatPadre.Items.Add(new ListItem(path, row["cat_id"].ToString()));

                    }
                }
                dDListCatPadre.SelectedValue = currentrow["cat_id"].ToString();

                ViewState["nametokens"] = (string)asc.helpDb.getScalar("select cat_nome from tcategorie where cat_id=@id", new OleDbParameter("id", id));


                bindtoviewstate();
                bind();


            }
            if (dDListCatPadre.SelectedIndex == 0) pholderimg.Visible = false; else pholderimg.Visible = true;


        }
    }








</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server" EnableViewState="true" ViewStateMode="Enabled">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
        <br />





        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>

        <table width="100%" cellpadding="3" cellspacing="1" border="0">


            <asp:PlaceHolder ID="pHolderCatPadre" runat="server">

                <tr class="admin_sfondobis">
                    <td><%=asc.language.getforadminfromdictionary("admin.category.parent.category") %></td>
                    <td>
                        <asp:DropDownList ID="dDListCatPadre" runat="server" AutoPostBack="true" />
                    </td>
                </tr>

            </asp:PlaceHolder>




            <tr class="admin_sfondobis">
                <td style="width: 200px"><%=asc.language.getforadminfromdictionary("admin.category.category.name") %> </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxname" />
                </td>
            </tr>

            <tr class="admin_sfondobis">
                <td><%=asc.language.getforadminfromdictionary("admin.category.metadescription") %> </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxmetadescription" />
                </td>
            </tr>
            <tr class="admin_sfondobis">
                <td><%=asc.language.getforadminfromdictionary("admin.category.metakeywords") %> </td>
                <td>
                    <asp:TextBox runat="server" ID="tboxmetakeywords" />
                </td>
            </tr>



            <asp:PlaceHolder runat="server" ID="pholderimg">
                <tr class="admin_sfondobis">
                    <td><%=asc.language.getforadminfromdictionary("admin.category.image") %></td>
                    <td>
                        <asp:Image ID="imgAttuale" runat="server" Width="120" />
                        <br>
                        <%=asc.language.getforadminfromdictionary("admin.category.choose.image.from.disk")%>
                        <input runat="server" type="file" id="fileImg0" />
                    </td>
                </tr>
            </asp:PlaceHolder>

        </table>


        <div>
            <asp:LinkButton ID="buttAggiorna" OnClick="buttAggiorna_click" runat="server" />
        </div>
        <p></p>
    </form>
</asp:Content>




