<%@ Page Title="Manage Orders" Language="C#"
    MasterPageFile="~/AdminMaster.master"
    AutoEventWireup="true"
    CodeBehind="ManageOrders.aspx.cs"
    Inherits="ConstructionMaterialsManagement.ManageOrders" %>

<asp:Content ID="TitleContent" ContentPlaceHolderID="MasterPageTitle" runat="server">
    <span class="page-title">Manage Orders</span>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<!-- REQUIRED -->
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePartialRendering="true"></asp:ScriptManager>

<style>
    .stat-card {
        border-radius: 12px;
        padding: 18px;
        background: white;
        box-shadow: 0 2px 6px rgba(0,0,0,0.08);
    }
    .stat-label { font-size: 12px; color: #6b7280; text-transform: uppercase; }
    .stat-value { font-size: 1.6rem; font-weight: bold; }

    .badge-status { padding: 6px 14px; border-radius: 40px; }
    .badge-pending { background: #fde047; color: #854d0e; }
    .badge-shipped { background: #bae6fd; color: #0c4a6e; }
    .badge-delivered { background: #bbf7d0; color: #14532d; }

    .table th { background: #eef2ff; }
</style>

<!-- STATS -->
<div class="row g-3 mb-4">

    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Total Orders</div>
            <div class="stat-value"><asp:Label ID="lblTotalOrders" runat="server" /></div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Pending</div>
            <div class="stat-value text-warning"><asp:Label ID="lblPending" runat="server" /></div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Shipped</div>
            <div class="stat-value text-info"><asp:Label ID="lblShipped" runat="server" /></div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="stat-card">
            <div class="stat-label">Delivered</div>
            <div class="stat-value text-success"><asp:Label ID="lblDelivered" runat="server" /></div>
        </div>
    </div>

</div>

<!-- ORDERS TABLE -->
<div class="card shadow-sm">
    <div class="card-header bg-white">
        <div class="d-flex align-items-center justify-content-between">
            <h5 class="fw-bold mb-0">All Orders</h5>

            <div class="d-flex align-items-center gap-2">
                <asp:Label ID="lblMsg" runat="server"></asp:Label>

                <asp:TextBox ID="txtFrom" runat="server" CssClass="form-control" TextMode="Date" Style="width:150px;" />
                <asp:TextBox ID="txtTo" runat="server" CssClass="form-control" TextMode="Date" Style="width:150px;" />

                <asp:DropDownList ID="ddlStatusFilterReport" runat="server" CssClass="form-select" Style="width:150px;">
                    <asp:ListItem Value="">All</asp:ListItem>
                    <asp:ListItem Value="Pending">Pending</asp:ListItem>
                    <asp:ListItem Value="Shipped">Shipped</asp:ListItem>
                    <asp:ListItem Value="Delivered">Delivered</asp:ListItem>
                    <asp:ListItem Value="Paid">Paid</asp:ListItem>
                </asp:DropDownList>

                <asp:Button ID="btnDownloadReport" runat="server" CssClass="btn btn-primary me-2" Text="Download Report" OnClick="btnDownloadReport_Click" />
            </div>
        </div>
    </div>

    <div class="card-body">

        <asp:GridView ID="gvOrders" runat="server"
            CssClass="table table-bordered table-hover align-middle"
            AutoGenerateColumns="False"
            DataKeyNames="OrderID"
            OnRowCommand="gvOrders_RowCommand">

            <Columns>

                <asp:BoundField DataField="OrderID" HeaderText="Order ID" />

                <asp:TemplateField HeaderText="Customer">
                    <ItemTemplate>
                        <b><%# Eval("FullName") %></b><br />
                        <small class="text-muted">
                            <%# Eval("Email") %><br />
                            <%# Eval("Mobile") %>
                        </small>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="TotalAmount"
                    HeaderText="Amount (₹)"
                    DataFormatString="₹{0:0.00}" />

                <asp:BoundField DataField="OrderDate"
                    HeaderText="Date"
                    DataFormatString="{0:dd MMM yyyy hh:mm tt}" />

                <asp:TemplateField HeaderText="Status">
    <ItemTemplate>
        <span class='<%#
            Eval("Status").ToString()=="Pending"  ? "badge-status badge-pending"  :
            Eval("Status").ToString()=="Shipped"  ? "badge-status badge-shipped"  :
            Eval("Status").ToString()=="Paid"     ? "badge-status badge-shipped"  :  /* treat Paid as Shipped visually */
            "badge-status badge-delivered"
        %>'>
            <%# Eval("Status") %>
        </span>
    </ItemTemplate>
</asp:TemplateField>


                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>

                        <asp:LinkButton runat="server"
                            CssClass="btn btn-sm btn-outline-primary me-1"
                            CommandName="viewOrder"
                            CommandArgument='<%# Eval("OrderID") %>'>
                            View
                        </asp:LinkButton>

                        <asp:LinkButton runat="server"
                            CssClass="btn btn-sm btn-outline-warning me-1"
                            CommandName="changeStatus"
                            CommandArgument='<%# Eval("OrderID") %>'>
                            Next Status
                        </asp:LinkButton>

                        <asp:LinkButton runat="server"
                            CssClass="btn btn-sm btn-outline-danger"
                            CommandName="deleteOrder"
                            CommandArgument='<%# Eval("OrderID") %>'
                            OnClientClick="return confirm('Delete this order?');">
                            Delete
                        </asp:LinkButton>

                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

    </div>
</div>

<!-- MODAL -->
<div class="modal fade" id="itemsModal" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">Order Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <asp:GridView ID="gvOrderItems" runat="server"
                    CssClass="table table-striped table-bordered align-middle"
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="ProductName" HeaderText="Product" />
                        <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                        <asp:BoundField DataField="Price" HeaderText="Price (₹)"
                            DataFormatString="₹{0:0.00}" />
                        <asp:TemplateField HeaderText="Total">
                            <ItemTemplate>
                                ₹<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))).ToString("0.00") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</div>

</asp:Content>
