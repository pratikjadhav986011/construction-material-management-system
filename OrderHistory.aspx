<%@ Page Title="My Orders" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="OrderHistory.aspx.cs" Inherits="ConstructionMaterialsManagement.OrderHistory" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Order History Page Styles */
        .order-card {
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 6px 18px rgba(18, 38, 63, 0.06);
            margin-bottom: 24px;
        }

        .order-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 12px;
        }

        .order-header h3 {
            margin: 0;
            font-weight: 700;
            color: #263238;
            font-size: 1.25rem;
        }

        .order-actions { display:flex; gap:8px; }

        .order-table thead th {
            background: #f4f6f8;
            border-bottom: 2px solid #e9eef2;
            color: #394a56;
            font-weight: 700;
            padding: 12px 16px;
        }

        .order-table tbody td {
            padding: 12px 16px;
            vertical-align: middle;
            color: #3b4a52;
        }

        .order-table tbody tr:hover {
            background: #fbfdff;
        }

        .badge-status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .badge-pending { background:#fff7e6; color:#b26b00; border:1px solid #fde3a7; }
        .badge-paid { background:#e8f8ff; color:#05668d; border:1px solid #cfeefb; }
        .badge-shipped { background:#e9f7ec; color:#1f7a3a; border:1px solid #cfeed0; }
        .badge-delivered { background:#e9f7ec; color:#0b6623; border:1px solid #cfeed0; }

        .small-muted { color: #6c757d; font-size: 0.9rem; }

        /* Modal styling */
        .modal-content {
            border-radius: 10px;
            overflow: hidden;
            border: none;
            box-shadow: 0 12px 40px rgba(18, 38, 63, 0.16);
        }

        .modal-header { border-bottom: 1px solid #f1f4f6; }
        .modal-title { font-weight: 700; color:#23303b; }

        .invoice-amount {
            font-weight: 700;
            font-size: 1.05rem;
            color: #1f2d3d;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            .order-header { flex-direction: column; align-items: flex-start; gap:8px; }
            .order-actions { width: 100%; justify-content: flex-start; }
            .order-table thead { display: none; }
            .order-table tbody td { display: block; width:100%; }
            .order-table tbody td:before { display: inline-block; font-weight:700; width: 120px; }
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="order-card">
            <div class="order-header">
                <h3>My Orders</h3>
                <div class="order-actions">
                    <asp:Label ID="lblMessage" runat="server" CssClass="small-muted"></asp:Label>
                </div>
            </div>

            <asp:GridView ID="gvMyOrders" runat="server" CssClass="table order-table" AutoGenerateColumns="False" OnRowCommand="gvMyOrders_RowCommand">
                <Columns>
                    <asp:BoundField DataField="OrderID" HeaderText="Order ID" />
                    <asp:BoundField DataField="OrderDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy hh:mm tt}" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Amount (?)" DataFormatString="?{0:0.00}" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# Eval("Status").ToString()=="Pending" ?
                                (object)String.Format("<span class='badge-status badge-pending'>{0}</span>", Eval("Status")) :
                                Eval("Status").ToString()=="Paid" ?
                                (object)String.Format("<span class='badge-status badge-paid'>{0}</span>", Eval("Status")) :
                                Eval("Status").ToString()=="Shipped" ?
                                (object)String.Format("<span class='badge-status badge-shipped'>{0}</span>", Eval("Status")) :
                                (object)String.Format("<span class='badge-status badge-delivered'>{0}</span>", Eval("Status")) %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <div class="d-flex gap-2">
                                <asp:LinkButton runat="server" CssClass="btn btn-sm btn-outline-primary" CommandName="view" CommandArgument='<%# Eval("OrderID") %>'>View</asp:LinkButton>
                                <asp:HyperLink runat="server" CssClass="btn btn-sm btn-outline-secondary" Target="_blank" NavigateUrl='<%# Eval("OrderID", "Invoice.aspx?orderId={0}") %>'>Invoice</asp:HyperLink>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <!-- Bootstrap Modal for Order Details -->
        <div class="modal fade" id="orderModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><span id="lblDetailsTitle" runat="server"></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:GridView ID="gvOrderItems" runat="server" CssClass="table table-striped" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="ProductName" HeaderText="Product" />
                                <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                                <asp:BoundField DataField="Price" HeaderText="Price (?)" DataFormatString="?{0:0.00}" />
                                <asp:TemplateField HeaderText="Total">
                                    <ItemTemplate>
                                        ?<%# (Convert.ToDecimal(Eval("Price")) * Convert.ToInt32(Eval("Quantity"))).ToString("0.00") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                    <div class="modal-footer">
                        <asp:Button ID="btnCloseDetails" runat="server" Text="Close" CssClass="btn btn-sm btn-secondary" OnClick="btnCloseDetails_Click" />
                    </div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>