<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminSupplier.aspx.cs"
    Inherits="ConstructionMaterialsManagement.SupplierManagement"
    MasterPageFile="~/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!-- JavaScript: Allow only numbers -->
<script>
    function allowOnlyNumbers(evt) {
        var ch = String.fromCharCode(evt.which);

        if (!(/[0-9]/.test(ch))) {
            evt.preventDefault();
        }
    }
</script>

<style>
    .card-box {
        background: white;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.08);
        margin-bottom: 35px;
    }

    .table th {
        background: #f0f0f0;
        font-weight: 600;
    }

    .btn-edit {
        color: #0d6efd;
        font-weight: 600;
        margin-right: 10px;
    }

    .btn-delete {
        color: #dc3545;
        font-weight: 600;
    }
</style>

<div class="container-fluid">

    <!-- ADD SUPPLIER -->
    <div class="row mb-3">
    <div class="col-md-3">
        <label>Supplier Name</label>
        <asp:TextBox ID="txtSupplierName" runat="server" CssClass="form-control" />
    </div>

    <div class="col-md-3">
        <label>Category</label>
        <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control" />
    </div>

    <div class="col-md-3">
        <label>Address</label>
        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
    </div>

    <div class="col-md-3">
        <label>City</label>
        <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" />
    </div>
</div>

<div class="row mb-3">
    <div class="col-md-3">
        <label>Contact Number</label>
        <asp:TextBox ID="txtContact" runat="server"
            CssClass="form-control"
            MaxLength="10"
            onkeypress="allowOnlyNumbers(event)" />
    </div>
</div>
    <div class="row mb-4">
    <div class="col-md-6">

        <!-- ADD SUPPLIER BUTTON -->
        <asp:Button ID="btnAddSupplier" runat="server"
            CssClass="btn btn-primary"
            Text="Add Supplier"
            OnClick="btnAddSupplier_Click" />

        <!-- MESSAGE LABEL (THIS FIXES YOUR ERROR) -->
        <asp:Label ID="lblMsg" runat="server"
            CssClass="fw-bold ms-3">
        </asp:Label>

    </div>
</div>



    <!-- SUPPLIER LIST -->
    <div class="card-box">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <h4 class="fw-bold mb-0">Supplier List</h4>
            <div>
                <asp:Button ID="btnDownloadSupplierLedger" runat="server" CssClass="btn btn-outline-secondary" Text="Download Supplier Ledger" OnClick="btnDownloadSupplierLedger_Click" />
            </div>
        </div>

        <asp:GridView ID="gvSuppliers" runat="server"
            CssClass="table table-bordered table-striped"
            AutoGenerateColumns="False"
            DataKeyNames="SupplierID"
            OnRowCommand="gvSuppliers_RowCommand">

            <Columns>
                <asp:BoundField DataField="SupplierID" HeaderText="ID" />
<asp:BoundField DataField="SupplierName" HeaderText="Name" />
<asp:BoundField DataField="Address" HeaderText="Address" />
<asp:BoundField DataField="City" HeaderText="City" />
<asp:BoundField DataField="CategoryName" HeaderText="Category" />
<asp:BoundField DataField="Contact" HeaderText="Contact" />


               <asp:TemplateField HeaderText="Actions">
    <ItemTemplate>

                <!-- EDIT BUTTON -->
                <asp:LinkButton ID="btnEdit" runat="server"
                    CommandName="editSupplier"
                    CommandArgument='<%# Eval("SupplierID") %>'
                    CssClass="btn btn-sm btn-outline-primary rounded-pill px-3 me-2 d-inline-flex align-items-center">
                    <i class="fas fa-edit me-1"></i> Edit
                </asp:LinkButton>

                <!-- DELETE BUTTON -->
                <asp:LinkButton ID="btnDelete" runat="server"
                    CommandName="deleteSupplier"
                    CommandArgument='<%# Eval("SupplierID") %>'
                    CssClass="btn btn-sm btn-outline-danger rounded-pill px-3 d-inline-flex align-items-center"
                    OnClientClick="return confirm('Are you sure you want to delete this supplier?');">
                    <i class="fas fa-trash-alt me-1"></i> Delete
                </asp:LinkButton>

            </ItemTemplate>
        </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>


    <!-- EDIT SUPPLIER MODAL -->
    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title">Edit Supplier</h5>
                    <button class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <asp:HiddenField ID="hfSupplierID" runat="server" />

                    <label>Name</label>
                    <asp:TextBox ID="txtEditName" runat="server"
                        CssClass="form-control mb-3" />

                    <label>Address</label>
<asp:TextBox ID="txtEditAddress" runat="server"
    CssClass="form-control mb-3" />

<label>City</label>
<asp:TextBox ID="txtEditCity" runat="server"
    CssClass="form-control mb-3" />


                    <label>Category</label>
                    <asp:DropDownList ID="ddlEditCategory" runat="server"
                        CssClass="form-control mb-3">
                    </asp:DropDownList>

                    <label>Contact Number</label>
                    <asp:TextBox ID="txtEditContact" runat="server"
                        CssClass="form-control mb-3"
                        MaxLength="10"
                        onkeypress="allowOnlyNumbers(event)" />

                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnUpdate" runat="server"
                        CssClass="btn btn-success"
                        Text="Update"
                        OnClick="btnUpdate_Click" />
                </div>

            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</asp:Content>
