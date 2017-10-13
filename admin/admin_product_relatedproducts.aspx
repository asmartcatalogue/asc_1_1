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

<script runat="server">

	int idart;
	string[] arrArtCorr;


	void checkedchange(object o, EventArgs e)
	{

		CheckBox cbox = ((CheckBox)o);

		int idcorr = int.Parse(cbox.ToolTip);

		using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
		{
			OleDbCommand cmd;
			cnn.Open();
			string sql;
			if (((cbox.Checked)))
			{
				sql = "select COUNT(*) from tcorrelati where idart=@idart AND idartcorr=@idartcorr;";
				cmd = new OleDbCommand(sql, cnn);
				cmd.Parameters.AddWithValue("idart", idart);
				cmd.Parameters.AddWithValue("idartcorr", idcorr);
				int quanti = Convert.ToInt32(cmd.ExecuteScalar());

				if (quanti < 1)
				{
					sql = "insert into tcorrelati (idart, idartcorr) VALUES (@idart, @idartcorr)";
					cmd = new OleDbCommand(sql, cnn);
					cmd.Parameters.Add(new OleDbParameter("idart", idart));
					cmd.Parameters.Add(new OleDbParameter("idartcorr", idcorr));
					cmd.ExecuteNonQuery();
				}
			}
			else
			{
				sql =
				 "delete from tcorrelati where idart=@idart AND idartcorr=@idartcorr;";
				cmd = new OleDbCommand(sql, cnn);
				cmd.Parameters.Add(new OleDbParameter("idart", idart));
				cmd.Parameters.Add(new OleDbParameter("idartcorr", idcorr));
				cmd.ExecuteNonQuery();


			}

			cnn.Close();
		}
        asc.common.jquerymodalmessage(this.Page, asc.language.getforadminfromdictionary("common.data.saved"));

		bindData();

	}


	void Grid_Change(Object sender, DataGridPageChangedEventArgs e)
	{
		dGridart.CurrentPageIndex = e.NewPageIndex;
		bindData();

	}











	private void databound(Object Sender, DataGridItemEventArgs e)
	{




		if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
		{
			CheckBox myCheckBox = (CheckBox)e.Item.FindControl("cBox");
			DataRowView drv = (DataRowView)(e.Item.DataItem);
			string id = drv["art_id"].ToString();



			using (OleDbConnection cnn = new OleDbConnection(System.Configuration.ConfigurationManager.ConnectionStrings["strcnn"].ConnectionString))
			{
				OleDbCommand cmd;
				cnn.Open();
				string sql = "select COUNT(*) From tcorrelati WHERE idart=@idart AND idartcorr=@idartcorr";
				cmd = new OleDbCommand(sql, cnn);
				cmd.Parameters.Add(new OleDbParameter("idart", idart));
				cmd.Parameters.Add(new OleDbParameter("idartcorr", id));
				bool isCorrelato = Convert.ToInt32(cmd.ExecuteScalar()) > 0;

				myCheckBox.Checked = isCorrelato;

				cnn.Close();
			}
		}

	}


	void bindData()
	{

		string sql;
		sql = "SELECT art_name, art_id, art_cod FROM tproducts  where art_id<>@idart ORDER BY art_id";
		OleDbParameter p1 = new OleDbParameter("idart", idart);
		dGridart.DataSource = asc.helpDb.getDataTable(sql, p1);
		dGridart.DataBind();

	}



	void Page_Init () {



		idart = Convert.ToInt32(Request.QueryString["idart"]);
                if (idart == 0) Response.Redirect("~/admin/admin_products.aspx");

	}





	void Page_Load () {

		if (!Page.IsPostBack) {
			((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a>" +
" &raquo; " +
"<a href='admin_products.aspx'>" + asc.language.getforadminfromdictionary("admin.related.products") + "</a>" +
" &raquo; " +
"<a href='admin_product.aspx?idart=" + idart.ToString() + "'>" + asc.language.getforadminfromdictionary("common.product.with.id") + " " + idart.ToString() + "</a>" +
" &raquo; " +
asc.language.getforadminfromdictionary("admin.related.whereyouare.related.products");

			dGridart.Columns[0].HeaderText = asc.language.getforadminfromdictionary("admin.related.list.select");
			dGridart.Columns[1].HeaderText = asc.language.getforadminfromdictionary("common.id");
			dGridart.Columns[2].HeaderText = asc.language.getforadminfromdictionary("admin.related.list.code");
			dGridart.Columns[3].HeaderText = asc.language.getforadminfromdictionary("admin.related.list.name");
			dGridart.Columns[0].HeaderStyle.HorizontalAlign=HorizontalAlign.Center;
			dGridart.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
			dGridart.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
			dGridart.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
			dGridart.Columns[0].ItemStyle.HorizontalAlign = HorizontalAlign.Center;
			dGridart.Columns[1].ItemStyle.HorizontalAlign = HorizontalAlign.Center;
			dGridart.Columns[2].ItemStyle.HorizontalAlign = HorizontalAlign.Left;
			dGridart.Columns[3].ItemStyle.HorizontalAlign = HorizontalAlign.Left;

			bindData();
		}
	}

</script>

<asp:Content ContentPlaceHolderID="headcontent" runat="server">
 <script>
  function confirm_delete() {
   if (confirm("Confirm?") == true)
    return true;
   else
    return false;
  }
 </script>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="partecentrale" runat="Server">
 <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>
  <br />




  <asp:Label ID="Label1" EnableViewState="false" runat="server" CssClass="messaggioerroreadmin" /><br />



  <asp:DataGrid
   EnableViewState="true"
   gridlines="none"
   CellSpacing="1"
   ID="dGridart"
   runat="server"
   Width="100%"
   AutoGenerateColumns="false"
   OnItemDataBound="databound"
   AllowPaging="true"
   PagerStyle-Mode="NumericPages"
   PageSize="20"
   OnPageIndexChanged="Grid_Change">
   <HeaderStyle CssClass="admin_sfondodark" />
   <ItemStyle CssClass="admin_sfondo" />
   <AlternatingItemStyle CssClass="admin_sfondobis" />
   <Columns>
    <asp:TemplateColumn>
     <ItemStyle Width="40"></ItemStyle>
     <ItemTemplate>
      <asp:CheckBox runat="server" ID="cBox" OnCheckedChanged="checkedchange" ToolTip='<%#Eval("art_id").ToString() %>' AutoPostBack="true" />
     </ItemTemplate>
    </asp:TemplateColumn>




    <asp:BoundColumn DataField="art_id"  />
    <asp:BoundColumn DataField="art_cod"  />
    <asp:TemplateColumn>
     <HeaderStyle HorizontalAlign="Center" />
     <ItemStyle Width="500" />
   <ItemTemplate>
    <asp:Label runat="server" Text=<%#asc.language.getforadminfromstring(Eval("art_name").ToString()) %> />
   </ItemTemplate>
      </asp:TemplateColumn>
   
   </Columns>
  </asp:DataGrid>


 </form>



</asp:Content>
