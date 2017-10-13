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
<%@ Import Namespace="estensioni" %>
<%@ Import Namespace="System.Data.OleDb" %>


<script runat="server">





    void buttnewcurrency_click(object sender, EventArgs e)
    {



        double cambio = -1;

        try
        {
            cambio = double.Parse(tBoxCambio.Text, asc.admin.localization.primarynumberformatinfo);

        }
        catch
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currencies.warning.insert.a.number.for.exchange"));
            return;

        }

        int decimali;
        if (!int.TryParse(TBOXdecimali.Text, out decimali))
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currencies.warning.insert.a.number.for.decimal.digits"));
            return;
        }

        if (TBOXnome.Text == "")
        {

            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currencies.warning.insert.name.of.currency"));
            return;

        }

        if (tboxdecimalseparatorsymbol.Text == "")
        {

            lblerr.Text = asc.language.getforadminfromdictionary("admin.currencies.warning.insert.symbol.for.decimal.separator");
            return;

        }



        OleDbCommand cmd;
        string sql;

        using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
        {
            cnn.Open();

            sql = "INSERT INTO tcurrencies (cambio, nome, decimalseparatorsymbol, decimali, groupseparatorsymbol) VALUES (@cambio,@nome, @decimalseparatorsymbol, @decimali,@groupseparatorsymbol)";
            cmd = new OleDbCommand(sql, cnn);
            cmd.Parameters.Add(new OleDbParameter("@cambio", cambio));
            cmd.Parameters.Add(new OleDbParameter("@nome", TBOXnome.Text));
            cmd.Parameters.Add(new OleDbParameter("@decimalseparatorsymbol", tboxdecimalseparatorsymbol.Text));
            cmd.Parameters.Add(new OleDbParameter("@decimali", int.Parse(TBOXdecimali.Text)));
            cmd.Parameters.Add(new OleDbParameter("@groupseparatorsymbol", tboxgroupseparatorsymbol.Text));
            cmd.ExecuteNonQuery();

            cnn.Close();
        }

        System.Web.HttpRuntime.UnloadAppDomain();

        bind();
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));

    }


    void bind()
    {

        string sql;
        sql = "SELECT * FROM tcurrencies order by nome";
        DataTable dt = asc.helpDb.getDataTable(sql);



        dGrid.DataSource = dt;
        dGrid.DataBind();



    }



    void dGrid_delete(object sender, DataGridCommandEventArgs e)
    {
        if (int.Parse(e.CommandArgument.ToString()) == (int)asc.config.getCampoByDb("config_idmastercurrency"))
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currency.warning.must.set.another.master.currency.before.delete")); ;
            return;

        }


        asc.helpDb.nonQuery("DELETE FROM tcurrencies WHERE id=@id", new OleDbParameter("id", int.Parse(e.CommandArgument.ToString())));

        System.Web.HttpRuntime.UnloadAppDomain();

        bind();

        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.deleted"));


    }


    void dGrid_command(object sender, DataGridCommandEventArgs e)
    {
        if (e.CommandName.ToString() == "setmaster")
        {

            string sql;
            sql = "update tcurrencies set cambio=1 where id=@id";
            asc.helpDb.nonQuery(sql, new OleDbParameter("id", int.Parse(e.CommandArgument.ToString())));

            sql = "update tconfig set config_idmastercurrency=@id";
            OleDbParameter p1 = new OleDbParameter("id", int.Parse(e.CommandArgument.ToString()));
            asc.helpDb.nonQuery(sql, p1);
            asc.config.storeConfig();

            System.Web.HttpRuntime.UnloadAppDomain();

            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));

            bind();



        }

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


    void update(object sender, DataGridCommandEventArgs e)
    {

        double cambio;


        int id = Convert.ToInt32(e.Item.Cells[1].Text);
        if (id == (int)asc.config.getCampoByDb("config_idmastercurrency"))
        {

            cambio = 1;

        }
        else
        {

            try
            {
                cambio = double.Parse(((TextBox)e.Item.Cells[3].FindControl("tboxnewcambio")).Text, asc.admin.localization.primarynumberformatinfo);

            }
            catch
            {

                cambio = -1;
            }
        }

        int decimali;
        if (!int.TryParse((((TextBox)e.Item.Cells[6].Controls[0]).Text), out decimali))
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currencies.warning.insert.a.number.for.decimal.digits"));
            return;
        }
        decimali = int.Parse(((TextBox)e.Item.Cells[6].Controls[0]).Text);



        string nome = e.Item.Cells[2].Text.Substring(0, 3, true);

        if (((TextBox)e.Item.Cells[4].Controls[0]).Text == "")
        {
            asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("admin.currencies.warning.insert.symbol.for.decimal.separator"));

            return;

        }
        string decimalseparatorsymbol = ((TextBox)e.Item.Cells[4].Controls[0]).Text.Substring(0, 5, true);
        string groupseparatorsymbol = ((TextBox)e.Item.Cells[5].Controls[0]).Text.Substring(0, 5, true);



        string sql = "UPDATE tcurrencies SET" +
            " cambio=@cambio, nome=@nome, decimalseparatorsymbol=@decimalseparatorsymbol, groupseparatorsymbol=@groupseparatorsymbol, decimali=@decimali" +
            " WHERE id=@id";

        OleDbParameter p1 = new OleDbParameter("@cambio", cambio);
        OleDbParameter p2 = new OleDbParameter("@nome", nome);
        OleDbParameter p3 = new OleDbParameter("@decimalseparatorsymbol", decimalseparatorsymbol);
        OleDbParameter p3bis = new OleDbParameter("@groupseparatorsymbol", groupseparatorsymbol);
        OleDbParameter p4 = new OleDbParameter("@decimali", decimali);
        OleDbParameter p5 = new OleDbParameter("@id", id);
        asc.helpDb.nonQuery(sql, p1, p2, p3, p3bis, p4, p5);


        dGrid.EditItemIndex = -1;
        System.Web.HttpRuntime.UnloadAppDomain();

        bind();

        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));

    }






    void Page_Load()
    {


        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo;  " +
         asc.language.getforadminfromdictionary("admin.currencies.where.you.are.currencies");


        if (!Page.IsPostBack)
        {
            
            buttNewCorriere.Text = asc.language.getforadminfromdictionary("admin.currencies.button.add.new");
            dGrid.Columns[0].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.list.edit");

            dGrid.Columns[1].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.id");
            dGrid.Columns[2].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.currency.code");
            dGrid.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.exchange");
            dGrid.Columns[4].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.symbol.for.decimal.separator");
            dGrid.Columns[5].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.symbol.for.groups.separator");
            dGrid.Columns[6].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.decimal.digits");
            dGrid.Columns[7].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.list.delete");
            dGrid.Columns[8].HeaderText = asc.language.getforadminfromdictionary("admin.currencies.list.master.currency");
            


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
        <asp:Label ID="lblerr" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" />

        <div class="big"><%=asc.language.getforadminfromdictionary("admin.currencies.insert.new.currency")%></div>
        <p></p>

            <table>
                <tr>
                    <td width="300"><%=asc.language.getforadminfromdictionary("admin.currencies.currency.code") %>

                    </td>
                    <td>
                        <asp:TextBox ID="TBOXnome" Style="width: 100%" Css runat="server" /></td>
                </tr>
                <tr>
                    <td><%=asc.language.getforadminfromdictionary("admin.currencies.symbol.for.decimal.separator") %>
                    </td>
                    <td>
                        <asp:TextBox ID="tboxdecimalseparatorsymbol" Style="width: 50px" Css runat="server" Text="," /></td>
                </tr>
                <tr>
                    <td><%=asc.language.getforadminfromdictionary("admin.currencies.decimal.digits") %>
                    </td>
                    <td>
                        <asp:TextBox ID="TBOXdecimali" Style="width: 100px" Css runat="server" Text="2" /></td>
                </tr>
                <tr>
                    <td><%=asc.language.getforadminfromdictionary("admin.currencies.symbol.for.groups.separator") %>
                    </td>
                    <td>
                        <asp:TextBox ID="tboxgroupseparatorsymbol" Style="width: 100px" Css runat="server" Text="." /></td>
                </tr>

                <tr>
                    <td><%=asc.language.getforadminfromdictionary("admin.currencies.exchange") %>
                    </td>
                    <td>
                        <asp:TextBox Style="width: 100px" runat="server" EnableViewState="false" Text="" ID="tBoxCambio" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Linkbutton OnClick="buttnewcurrency_click" ID="buttNewCorriere" runat="server" class="bottone" />

                    </td>
                </tr>
            </table>

        <p><br /></p>

         <div class="big"><%=asc.language.getforadminfromdictionary("admin.currencies.title.all.supported.currencies")%></div>
        <p></p>   
         <asp:DataGrid GridLines="None" CellSpacing="1" ID="dGrid" runat="server" Width="100%" AutoGenerateColumns="false"
                OnCancelCommand="dGrid_cancel"
                OnEditCommand="dGrid_edit"
                OnUpdateCommand="update"
                OnDeleteCommand="dGrid_delete"
                OnItemCommand="dGrid_command">
                <HeaderStyle CssClass="admin_sfondodark" />
                <ItemStyle CssClass="admin_sfondo" />
                <AlternatingItemStyle CssClass="admin_sfondobis" />
                <EditItemStyle CssClass="small" />
                <Columns>
                    <asp:EditCommandColumn CancelText="cancel" UpdateText="OK" EditText="<img src=../immagini/edit.gif Border=0 Width=12 Height=12>" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundColumn DataField="id" ReadOnly="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundColumn DataField="nome" ReadOnly="true" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />

                    <asp:TemplateColumn>
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <div style="text-align: right">
                                <asp:Label runat="server" Text='<%#((double)Eval("cambio"))==-1? "N/A": Eval("cambio").ToString() %>' />
                            </div>
                        </ItemTemplate>

                        <EditItemTemplate>
                            <div style="text-align: right">
                                <asp:TextBox runat="server" ID="tboxnewcambio" Text='<%#((double)Eval("cambio"))==-1? "": Eval("cambio").ToString() %>' />
                            </div>
                        </EditItemTemplate>
                    </asp:TemplateColumn>

                    <asp:BoundColumn DataField="decimalseparatorsymbol" ReadOnly="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundColumn DataField="groupseparatorsymbol" ReadOnly="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundColumn DataField="decimali" ReadOnly="false" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                    <asp:TemplateColumn>
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <center><asp:linkbutton 
        text=<%#asc.language.getforadminfromdictionary("admin.currencies.list.delete")%>
        runat="server"  
        CommandName="delete" CommandArgument=<%#Eval("id") %> /></center>
                        </ItemTemplate>
                    </asp:TemplateColumn>
                    <asp:TemplateColumn>
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemTemplate>
                            <center>
                   <asp:linkbutton visible=<%#(int)Eval("id")!=(int)asc.config.getCampoByDb("config_idmastercurrency") %> text=<%#asc.language.getforadminfromdictionary("admin.currencies.list.set.as.master") %> runat="server"  CommandName="setmaster" CommandArgument=<%#Eval("id") %> />
                   <asp:Label runat="server" text=<%#"<b>" + asc.language.getforadminfromdictionary("admin.currencies.master.currency") + "</b>" %> visible=<%#(int)Eval("id")==(int)asc.config.getCampoByDb("config_idmastercurrency") %> />
               </center>
                        </ItemTemplate>
                    </asp:TemplateColumn>


                </Columns>
            </asp:DataGrid>




    </form>
</asp:Content>
