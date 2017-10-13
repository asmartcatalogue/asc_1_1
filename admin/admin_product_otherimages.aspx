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

<%@ Import Namespace="System.IO" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>
<%@ Import Namespace="AjaxControlToolkit" %>
<script runat="server">
    int n = 0;

    int idart;
    List<string> frontlanguages;

    void savegrid_click(object o, EventArgs e)
    {
        updateorigin();

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            for (int rip = 0; rip < dGrid.Items.Count; rip++)
            {
                DataRow dr = ((DataTable)ViewState["griddesctokens"]).Rows[rip];

                asc.helpDb.nonQueryByOpenCnn(
                    cnn,
                    "update tzoom set z_text=@text where z_id=@id",
                    new OleDbParameter("text", dr["z_text"].ToString()),
                    new OleDbParameter("id", (int)dr["z_id"])
                    );
            }


        }

        Response.Redirect(Request.Url.AbsoluteUri);
    }

    void changelanguageclick(object o, EventArgs e)
    {
        string l = ((Button)o).CommandArgument.ToString();
        updateorigin();
        ViewState["l"] = l.ToString();
        bind();


    }

    void updateorigin()
    {
        DataTable dt = (DataTable)ViewState["griddesctokens"];
        for (int rip = 0; rip < dGrid.Items.Count; rip++)
        {
            string currvalue = ((HtmlTextArea)dGrid.Items[rip].FindControl("tareagriddesc")).InnerText;
            dt.Rows[rip]["z_text"] = asc.language.addorupdateonetoken_and_removetokenswihoutwords(dt.Rows[rip]["z_text"].ToString(), ViewState["l"].ToString(), currvalue);
        }

    }

    void bind()
    {
        foreach (Control c in panellanguages.Controls)
        {

            Button mybutton = (Button)c;
            if (mybutton.Text == ViewState["l"].ToString()) mybutton.CssClass = "buttlangsel";
            else mybutton.CssClass = "buttlangunsel";

        }

        dGrid.DataSource = ((DataTable)ViewState["griddesctokens"]);
        dGrid.DataBind();

    }

    void buttsaveimg_click(object o, EventArgs e)
    {
        updateorigin();

        if (fileImg0.PostedFile.FileName == "")
        {
            asc.common.jquerymodalmessage(this.Page, "select image from your hard-disk");
        }
        else
        {
            int idimg;

            asc.helpDb.nonQuery("insert into tzoom (z_idart) values (@idart)", new OleDbParameter("idart", idart));
            idimg = (int)asc.helpDb.getScalar("select max(z_id) from tzoom");

            string thisartreldirpath = "~/app_data/morep/" + idart.ToString();
            if (!Directory.Exists(Server.MapPath(thisartreldirpath))) Directory.CreateDirectory(Server.MapPath(thisartreldirpath));
            string thisimgrelpath = thisartreldirpath + "/" + idimg.ToString();

            string thisimgabspath = HttpContext.Current.Server.MapPath(thisimgrelpath);
            if (File.Exists(thisimgabspath)) File.Delete(thisimgabspath);


            int w;
            int h;
            asc.images.savesecondaryimage(fileImg0.PostedFile, thisimgabspath, out w, out h);
            asc.helpDb.nonQuery("update tzoom set z_w=@W, z_h=@h where z_id=@id",
                new OleDbParameter("w", w),
                new OleDbParameter("h", h),
                new OleDbParameter("id", idimg)
            );
            Response.Redirect(Request.Url.AbsoluteUri);
        }




    }



















    void dGrid_delete(object sender, DataGridCommandEventArgs e)



    {
        int id = int.Parse(((Label)(e.Item.FindControl("lblid"))).Text);
        string sql = "delete  FROM tzoom WHERE z_id=@id";
        OleDbParameter p1 = new OleDbParameter("@id", id);
        asc.helpDb.nonQuery(sql, p1);

        string a = "~/app_data/morep/" + idart.ToString() + "/" + id.ToString();

        if (File.Exists(Server.MapPath(a))) File.Delete(Server.MapPath(a));

        Response.Redirect(Request.Url.AbsoluteUri);

    }


    void Page_Init()
    {
        idart = Convert.ToInt32(Request.QueryString["idart"]);
        if (idart == 0) Response.Redirect("~/admin/admin_products.aspx");
        frontlanguages = ((Dictionary<string, string>)Application["mydictionary"]).Keys.ToList<string>(); ;
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






        if (!Page.IsPostBack)
        {
            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
                    " &raquo; " +
                    "<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.products") + "</a>" +
                    " &raquo; " +
                    "<a href='admin_product.aspx?idart=" + idart.ToString() + "'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idart.ToString() + "</a>" +
                    " &raquo; " + asc.language.getforadminfromdictionary("admin.product.additional.images");

            buttsaveimg.Text = asc.language.getforadminfromdictionary("common.save.changes");
            buttsavegrid.DataBind();
            dGrid.Columns[0].HeaderText = asc.language.getforadminfromdictionary("common.id");
            dGrid.Columns[1].HeaderText = "image";
            dGrid.Columns[2].HeaderText = "description";
            dGrid.Columns[3].HeaderText = "delete";
            if (ViewState["l"] == null) ViewState["l"] = frontlanguages[0];
            if (ViewState["griddesctokens"] == null)
            {
                DataTable dt = asc.helpDb.getDataTable("select z_id, z_text, z_idart from tzoom where z_idart=@idart", new OleDbParameter("idart", idart));
                ViewState["griddesctokens"] = dt;
            }
            bind();

        }



    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
        <br />

        <asp:Panel runat="server" ID="panellanguages" />
        <p></p>
        <div class="big">
            <%=asc.language.getforadminfromdictionary("admin.product.other.images.new") %>
        </div>

        <table width="100%">
            <tr>
                <td>
                    <input runat="server" type="file" id="fileImg0" />&nbsp;&nbsp;<asp:LinkButton ID="buttsaveimg" OnClick="buttsaveimg_click" runat="server" />
                </td>
            </tr>

        </table>


        <br>
        <br>
        <asp:DataGrid GridLines="None" CellSpacing="1"
            OnDeleteCommand="dGrid_delete"
            CellPadding="4" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <Columns>


                <asp:TemplateColumn>
                    <ItemTemplate>
                        <asp:Label runat="server" ID="lblid" Text='<%#Eval("z_id").ToString() %>' />
                    </ItemTemplate>
                </asp:TemplateColumn>



                <asp:TemplateColumn>
                    <ItemTemplate>
                        <div align="center">
                            <img src='<%#"~/image.aspx?type=2&idart=" + Eval("z_idart").ToString() + "&id=" + Eval("z_id").ToString()  %>'
                                runat="server"
                                id="img"
                                width="30" />
                            <br />
                        </div>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:TemplateColumn>
                    <ItemStyle Width="700" />
                    <ItemTemplate>
                        <textarea runat="server" id="tareagriddesc" validaterequestmode="disabled"><%#asc.language.getfromstringandlanguagename( Eval("z_text").ToString(), ViewState["l"].ToString()) %></textarea>
                    </ItemTemplate>
                </asp:TemplateColumn>


                <asp:ButtonColumn Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
        </asp:DataGrid>
        <table cellpadding="0" cellspacing="1" style="width: 100%">
            <tr class="admin_sfondo">
                <td>
                    <asp:LinkButton runat="server" ID="buttsavegrid" Text='<%#asc.language.getforadminfromdictionary("common.save.changes") %>' OnClick="savegrid_click" align="right" />
                </td>
            </tr>
        </table>


        <p></p>
        <p></p>
    </form>
</asp:Content>
