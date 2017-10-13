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



<script runat="server">

    protected int idArt;


    private void update(int idFascia, double sconto)
    {

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            OleDbCommand cmd;
            string sql;
            cnn.Open();

            sql = "UPDATE tscontiquantita SET s_sconto=@sconto WHERE s_id=@idfascia";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@sconto", sconto));
            cmd.Parameters.Add(new OleDbParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }
    }

    private void delete(int idFascia)
    {
        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            OleDbCommand cmd;
            string sql;

            sql = "delete  FROM tscontiquantita WHERE s_id=@idfascia";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@idFascia", idFascia));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }
    }


    private void add(out bool esisteQuantita, int idArt, int quantita, double sconto)
    {
        OleDbCommand cmd;
        string sql;

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            sql = "SELECT COUNT(*) FROM tscontiquantita WHERE s_idart=@idart AND s_quantita=@quantita";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@idArt", idArt));
            cmd.Parameters.Add(new OleDbParameter("@quantita", quantita));
            esisteQuantita = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

            if (esisteQuantita) return;

            sql = "INSERT INTO tscontiquantita (s_idart, s_quantita, s_sconto)" +
            " VALUES (@idart, @quantita, @sconto)";

            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@idArt", idArt));
            cmd.Parameters.Add(new OleDbParameter("@quantita", quantita));
            cmd.Parameters.Add(new OleDbParameter("@sconto", sconto));

            cmd.ExecuteNonQuery();

            cnn.Close();
        }

    }



    void bind()
    {


        string sql = "SELECT * FROM tscontiquantita WHERE s_idArt=@idart ORDER BY s_quantita";
        DataTable dt = asc.helpDb.getDataTable
            (
            sql,
            new OleDbParameter("idart", idArt)
            );

        dGrid.DataSource = dt;

        dGrid.DataBind();




    }








    void buttCrea_click(object sender, EventArgs e)
    {

        bool valid = true;
        bool esisteQuantita;

        int quantitaDb = 0;
        double scontoDb = 0;

        try { quantitaDb = int.Parse(tBoxQuantita.Text); } catch { valid = false; lblerroresopra.Text += "<br>inserire un numero nel campo quantita"; }

        try { scontoDb = double.Parse(tBoxSconto.Text, asc.admin.localization.primarynumberformatinfo); }
        catch { valid = false; lblerroresopra.Text += "<br>inserire un numero nel campo sconto"; }


        if (!valid) return;


        this.add(out esisteQuantita, idArt, quantitaDb, scontoDb);

        if (esisteQuantita)
        {
             asc.common.jquerymodalmessage(this.Page,asc.language.getforadminfromdictionary("admin.quantity.disc.bracket.exists"));
            return;
        }

        bind();
    }


    void dGrid_edit(object sender, DataGridCommandEventArgs e)
    {

        dGrid.EditItemIndex = e.Item.ItemIndex;
        bind();

    }


    void dGrid_cancel(object sender, DataGridCommandEventArgs e)
    {

        dGrid.EditItemIndex = -1;
        bind();
    }

    void dGrid_update(object sender, DataGridCommandEventArgs e)
    {

        double sconto;
        int idFascia;

        try { sconto = double.Parse(((TextBox)(e.Item.Cells[3].Controls[0])).Text, asc.admin.localization.primarynumberformatinfo); }
        catch
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.insert.number"));
            return;
        }

        idFascia = int.Parse(e.Item.Cells[1].Text);

        this.update(idFascia, sconto);
        dGrid.EditItemIndex = -1;
        bind();

    }

    void dGrid_delete(object sender, DataGridCommandEventArgs e)
    {
        int idFascia = int.Parse(e.Item.Cells[1].Text);
        this.delete(idFascia);
        dGrid.EditItemIndex = -1;
        bind();

    }

















    void Page_Load()
    {

        lblerroresopra.Text = "";
        idArt = Convert.ToInt32(Request.QueryString["idArt"]);

        if (!Page.IsPostBack)
        {
            ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
                " &raquo; " +
                "<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.products") + "</a>" +
                " &raquo; " +
                "<a href='admin_product.aspx?idArt=" + idArt.ToString() + "'>" + asc.language.getforadminfromdictionary("admin.product.where.you.are.product.id") + " " + idArt.ToString() + "</a>" +
                " &raquo; " + asc.language.getforadminfromdictionary("admin.quantity.disc.lbl.quantity.discounts");

            buttCrea.Text = asc.language.getforadminfromdictionary("admin.products.quantity.disc.butt.add.bracket");
            dGrid.Columns[1].HeaderText = "<b>" + asc.language.getforadminfromdictionary("admin.products.quantity.disc.bracketid") + "</b>";
            dGrid.Columns[2].HeaderText = "<b>" + asc.language.getforadminfromdictionary("admin.products.quantity.disc.from.quantity") + "</b>";
            dGrid.Columns[3].HeaderText = "<b>" + asc.language.getforadminfromdictionary("admin.products.quantity.disc.quantity.discount") + "</b>";
            dGrid.Columns[4].HeaderText = "<b>" + asc.language.getforadminfromdictionary("admin.products.quantity.disc.delete.bracket") + "</b>";
            bind();
        }
    }

</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">










    <form enctype="multipart/form-data" runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
        <div align="center" style="font-size: 13px; color: Red">
            <asp:Label ID="lblerroresopra" runat="server" />
        </div>

        <table width="100%" cellpadding="0" cellspacing="1">
            <tr class="admin_sfondodark">
                <td colspan="2" align="center"><b><%=asc.language.getforadminfromdictionary("admin.products.quantity.disc.lbl.add.bracket") %></b></td>
            </tr>
            <tr class="admin_sfondo">
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.products.quantity.disc.lbl.from.quantity") %>
                </td>
                <td>
                    <asp:TextBox size="5" EnableViewState="false" Text="" CssClass="small" ID="tBoxQuantita" runat="server" />
                    <asp:Label ForeColor="red" EnableViewState="false" ID="lblOpz" runat="server" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td>
                    <%=asc.language.getforadminfromdictionary("admin.products.quantity.disc.lbl.quantity.discount") %> %
                </td>
                <td>
                    <asp:TextBox Text="0" EnableViewState="false" size="5" CssClass="small" ID="tBoxSconto" runat="server" /><asp:Label ForeColor="red" EnableViewState="false" ID="lblPrezzoOpz" runat="server" />
                </td>
            </tr>
            <tr class="admin_sfondo">
                <td colspan="2" align="center">
                    <asp:Button CssClass="bottone" OnClick="buttCrea_click" ID="buttCrea" runat="server" />
                </td>
            </tr>
        </table>

        <br>
        <br>
        <br>
        <asp:DataGrid GridLines="None" CellSpacing="1" OnDeleteCommand="dGrid_delete" OnCancelCommand="dGrid_cancel" OnUpdateCommand="dGrid_update" OnEditCommand="dGrid_edit" PageSize="3" CellPadding="4" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false">
            <HeaderStyle CssClass="admin_sfondodark" />
            <ItemStyle CssClass="admin_sfondo" />
            <Columns>
                <asp:EditCommandColumn CancelText="cancel" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" />
                <asp:BoundColumn ReadOnly="true" DataField="s_id" />
                <asp:BoundColumn ReadOnly="true" DataField="s_quantita" />
                <asp:BoundColumn DataField="s_sconto" />
                <asp:ButtonColumn Text="<center><img src=../immagini/delete.gif Border=0 ></center>" CommandName="Delete" />
            </Columns>
        </asp:DataGrid>


    </form>
</asp:Content>
