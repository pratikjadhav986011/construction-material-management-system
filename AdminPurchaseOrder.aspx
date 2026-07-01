<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminPurchaseOrder.aspx.cs"
    Inherits="ConstructionMaterialsManagement.AdminPurchaseOrder"
    MasterPageFile="~/AdminMaster.master" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
    body { background: #eef1f5 !important; }

    .card-box {
        background: white;
        padding: 30px;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.12);
        margin-bottom: 40px;
    }

    .form-control, .form-select {
        height: 50px;
        font-size: 16px;
        border-radius: 10px;
    }

    .btn-main {
        background: #0d6efd;
        padding: 13px 22px;
        color: white;
        font-size: 17px;
        border-radius: 8px;
        border: none;
        transition: 0.2s;
    }
    .btn-main:hover { background: #0b5ed7; }

    .table { font-size: 17px; }

    .btn-receive {
        background: #198754;
        color: white;
        border-radius: 8px;
        padding: 8px 18px !important;
    }
    .btn-receive:hover { background: #157347; }
</style>

<script>
    function calculateTotal() {
        let price = parseFloat(document.getElementById("<%= txtPrice.ClientID %>").value) || 0;
        let qty = parseFloat(document.getElementById("<%= txtQty.ClientID %>").value) || 0;
        document.getElementById("<%= txtTotal.ClientID %>").value = (price * qty).toFixed(2);
    }
</script>


<div class="container-fluid">

    <!-- CREATE PURCHASE ORDER -->
    <div class="card-box">
        <h3 class="fw-bold">Create Purchase Order</h3>
        <hr />

        <div class="row mb-4">

            <div class="col-md-4">
                <label class="fw-bold">Select Category</label>
                <asp:DropDownList ID="ddlCategory" CssClass="form-select"
                    runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <div class="col-md-4">
                <label class="fw-bold">Select Product</label>
                <asp:DropDownList ID="ddlProduct" CssClass="form-select"
                    runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged"></asp:DropDownList>
            </div>

            <div class="col-md-4">
                <label class="fw-bold">Select Supplier</label>
                <asp:DropDownList ID="ddlSupplier" CssClass="form-select" runat="server"></asp:DropDownList>
            </div>
        </div>

        <div class="row mb-4">
            <div class="col-md-4">
                <label class="fw-bold">Purchase Price (Auto 20% Less)</label>
                <asp:TextBox ID="txtPrice" CssClass="form-control" ReadOnly="true" runat="server" />
            </div>

            <div class="col-md-4">
                <label class="fw-bold">Quantity</label>
                <asp:TextBox ID="txtQty" CssClass="form-control" runat="server"
                    AutoPostBack="true" OnTextChanged="txtQty_TextChanged" />
            </div>

            <div class="col-md-4">
                <label class="fw-bold">Total Amount</label>
                <asp:TextBox ID="txtTotal" CssClass="form-control" ReadOnly="true" runat="server" />
            </div>
        </div>

        <asp:Button ID="btnCreatePO" runat="server"
            Text="Create Purchase Order"
            CssClass="btn-main"
            OnClick="btnCreatePO_Click" />

    </div>


    <!-- PURCHASE ORDER LIST -->
    <div class="card-box">
        <div class="d-flex align-items-center justify-content-between mb-2">
            <h3 class="fw-bold">Purchase Order List</h3>

            <div class="d-flex align-items-center gap-2">
                <asp:Label ID="lblPOMsg" runat="server" CssClass="me-2"></asp:Label>
                <asp:DropDownList ID="ddlSupplierFilter" runat="server" CssClass="form-select" Style="width:220px;" /></asp:DropDownList>
                <asp:Button ID="btnDownloadSupplierPO" runat="server" CssClass="btn btn-outline-primary" Text="Download Report" OnClick="btnDownloadSupplierPO_Click" />
            </div>
        </div>
        <hr />

        <asp:GridView ID="GridViewPO" runat="server"
            AutoGenerateColumns="False"
            CssClass="table table-bordered table-striped text-center"
            OnRowCommand="GridViewPO_RowCommand">

            <Columns>

                <asp:BoundField DataField="PO_ID" HeaderText="PO ID" />

                <asp:BoundField DataField="SupplierName" HeaderText="Supplier" />

                <asp:BoundField DataField="ProductName" HeaderText="Product" />

                <asp:BoundField DataField="Quantity" HeaderText="Qty" />

                <asp:BoundField DataField="PurchasePrice" HeaderText="Price" />

                <asp:BoundField DataField="TotalAmount" HeaderText="Total" />

                <asp:BoundField DataField="PO_Date" HeaderText="Date" />

                <asp:BoundField DataField="Status" HeaderText="Status" />

                <asp:TemplateField>
                    <ItemTemplate>
                        <div class="d-flex justify-content-center gap-2">
                            <asp:Button ID="btnInvoice" runat="server"
                                Text="Invoice"
                                CommandName="DownloadInvoice"
                                CommandArgument='<%# Eval("PO_ID") %>'
                                CssClass="btn btn-sm btn-outline-secondary" />

                            <asp:Button ID="btnReceive" runat="server"
                                Text="Receive Delivery"
                                CommandName="ReceiveDelivery"
                                CommandArgument='<%# Eval("PO_ID") %>'
                                CssClass="btn btn-receive" />
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>

    </div>

</div>

</asp:Content>
