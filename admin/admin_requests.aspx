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
    int page = 1;
    int howmany;
    int reqperpage = 10;

    void delete_click (object o, EventArgs e)
    {

        int id = int.Parse(((LinkButton)o).CommandArgument);
        asc.helpDb.nonQuery("delete from trequests where id=@id", new OleDbParameter("id", id));
        Response.Redirect("admin_requests.aspx");

    }

    void list_databound(Object Sender, RepeaterItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {

            LinkButton myButton = (LinkButton)e.Item.FindControl("linkdelete");
            myButton.Attributes.Add("onclick", "return confirm('confirm?')");
        }

    }
    void bind()
    {
        DataTable dt;

            string sql = "select id,  r_when, r_name, r_email, r_subject, r_body from trequests order by r_when desc";
            dt = asc.helpDb.getDataTable(sql);

        int howmany = dt.Rows.Count;

        if (howmany > 0)
        {
            var l1 = dt.AsEnumerable().Skip((page - 1) * reqperpage).Take(reqperpage);

            if (l1.Any())
            {

                list.DataSource = l1.CopyToDataTable();
                list.DataBind();



                // show pager
                int restoZeroUno = (howmany % reqperpage > 0) ? 1 : 0;
                int totPag = (int)(restoZeroUno + Math.Floor((double)howmany / reqperpage));
                for (int a = 1; a <= totPag; a++)
                {
                    if (page == a)
                    {
                        lblpaging.Text += " <span class='paging'>" + Convert.ToString(a) + "</span> ";
                    }
                    else
                    {

                        lblpaging.Text += "<span class='paging'>" + asc.common.linkescaped(
                                Convert.ToString(a),
                                "admin_requests.aspx?page=" + a.ToString(), "paging"
                        ) + "</span> ";

                    }
                }

            }
        }





    }
    void Page_Load()
    {

        if (Request.QueryString["page"] != null) page = Convert.ToInt32(Request.QueryString["page"].ToString());

        if (!Page.IsPostBack) bind();


        ((Label)Master.FindControl("lbldove")).Text = "<a href='admin_menu.aspx'>" + asc.language.getforadminfromdictionary("admin.label.administration.menu") + "</a> &raquo; " +
         asc.language.getforadminfromdictionary("admin.info.requests");

    }
</script>
<asp:Content ContentPlaceHolderID="headcontent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="partecentrale" runat="Server">
    <form runat="server">
        <asp:ScriptManager runat="server" />
        <div id="dialog" style="display: none"></div>

        <p></p>
        <div class="big"><%=asc.language.getforadminfromdictionary("admin.info.requests") %></div>

        <p></p>

        <asp:Repeater runat="server" ID="list" OnItemDataBound="list_databound">

            <ItemTemplate>

                <hr />
                <p></p>
                <asp:LinkButton
                     CommandArgument=<%#Eval("id").ToString() %>
                    id="linkdelete"
                    runat="server"  
                    onclick="delete_click" 
                     on="return confirm('confirm?')"
                    text=<%# asc.language.getforadminfromdictionary("common.delete") %> />
                <br />
                <b><%=asc.language.getforadminfromdictionary("admin.requests.date") %></b>: <%#((DateTime)Eval("r_when")).ToString("yyyy-MM-dd HH:mm:ss") %>
                <br />
                <b><%=asc.language.getforadminfromdictionary("admin.requests.name") %></b>: <%#Server.HtmlEncode(Eval("r_name").ToString()) %>
                <br />
                <b><%=asc.language.getforadminfromdictionary("admin.requests.email") %></b>: <%#Server.HtmlEncode(Eval("r_email").ToString()) %>
                <br />
                <b><%=asc.language.getforadminfromdictionary("admin.requests.subject") %></b>: <%#Server.HtmlEncode(Eval("r_subject").ToString()) %>
                <br />
                <b><%=asc.language.getforadminfromdictionary("admin.requests.body") %></b>:<br /><%#Server.HtmlEncode(Eval("r_body").ToString()) %>
                <p></p>
            </ItemTemplate>



        </asp:Repeater>
        <hr /><p></p>
        <asp:Label ID="lblpaging" runat="server" />
        <p><br /></p>
    </form>
</asp:Content>


