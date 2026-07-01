<%@ Page Title="Manage Products" Language="C#"
    MasterPageFile="~/AdminMaster.master"
    AutoEventWireup="true"
    CodeBehind="ManageProducts.aspx.cs"
    Inherits="ConstructionMaterialsManagement.ManageProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <!-- If Bootstrap/FontAwesome are already in AdminMaster, you can remove these -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI'; }

        .page-topbar {
            background: #ffffff;
            height: 60px;
            padding: 15px 25px;
            margin: -15px -15px 20px -15px; /* blend with master content padding */
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .stats-box {
            background: #ffffff;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.06);
        }

        .stats-box h3 {
            font-weight: 700;
        }

        .product-img {
            width: 55px;
            height: 55px;
            object-fit: cover;
            border-radius: 6px;
        }

        .modal-header { background: #0d6efd; color: white; }
    </style>

    <!-- Needed for ScriptManager.RegisterStartupScript in code-behind -->
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <div class="container-fluid mt-3">

        <!-- TOP BAR (inside content, master already has sidebar) -->
        <div class="page-topbar">
            <b>Manage Products</b>

            <div>
                <asp:Label ID="lblMsg" runat="server" CssClass="me-2"></asp:Label>

                <a href="AdminDashboard.aspx" class="btn btn-primary btn-sm me-2">
                    <i class="fas fa-arrow-left"></i> Back
                </a>

                <asp:Button ID="btnDownloadCrystal" runat="server" CssClass="btn btn-outline-secondary btn-sm me-2" Text="Download Report" OnClick="btnDownloadCrystal_Click" />

                <button type="button" class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#productModal"
                        onclick="resetForm()">
                    + Add New Product
                </button>
            </div>
        </div>

        <!-- PAGE TITLE ROW -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold m-0">Products</h3>
        </div>

        <!-- STAT CARDS -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-box p-3">
                    <h3><asp:Label ID="lblTotalProducts" runat="server" /></h3>
                    <p class="mb-0">Total Products</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="stats-box p-3">
                    <h3><asp:Label ID="lblTotalCategories" runat="server" /></h3>
                    <p class="mb-0">Total Categories</p>
                </div>
            </div>
        </div>

        <!-- PRODUCT TABLE -->
        <div class="card shadow-sm">
            <div class="card-body">

                <asp:GridView ID="gvProducts" runat="server"
                    CssClass="table table-striped table-bordered"
                    AutoGenerateColumns="False"
                    DataKeyNames="ProductID"
                    OnRowCommand="gvProducts_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="ProductID" HeaderText="ID" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                        <asp:BoundField DataField="Price" HeaderText="Price (₹)" DataFormatString="₹{0:0.00}" />
                        <asp:BoundField DataField="Stock" HeaderText="Stock" />

                        <asp:TemplateField HeaderText="Image">
                            <ItemTemplate>
                                <img src="<%# Eval("ImageUrl") %>" class="product-img" />
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <!-- use row index (Container.DataItemIndex) -->
                                <asp:LinkButton ID="btnEdit" runat="server"
                                    CssClass="btn btn-sm btn-primary me-1"
                                    CommandName="editProduct"
                                    CommandArgument='<%# Container.DataItemIndex %>'>
                                    Edit
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CssClass="btn btn-sm btn-danger"
                                    CommandName="deleteProduct"
                                    CommandArgument='<%# Container.DataItemIndex %>'
                                    OnClientClick="return confirm('Delete this product?');">
                                    Delete
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                </asp:GridView>

            </div>
        </div>
    </div>

    <!-- MODAL: ADD / EDIT PRODUCT -->
    <div class="modal fade" id="productModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">

                <asp:HiddenField ID="hfProductID" runat="server" />

                <div class="modal-header">
                    <h5 class="modal-title">Add / Edit Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">

                    <label>Product Name</label>
                    <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control mb-3" />

                    <label>Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control mb-3" />

                    <label>Price</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control mb-3" />

                    <label>Stock</label>
                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control mb-3" />

                    <label>Image</label>
                    <asp:FileUpload ID="fileImage" runat="server" CssClass="form-control mb-3" />

                    <label>Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine"
                                 Rows="4" CssClass="form-control mb-3" />
                </div>

                <div class="modal-footer">
                    <asp:Button ID="btnSave" runat="server" CssClass="btn btn-success"
                        Text="Save" OnClick="btnSave_Click" />
                </div>

            </div>
        </div>
    </div>

    <!-- Bootstrap JS (if not already in master, keep this) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function resetForm() {
            document.getElementById('<%= hfProductID.ClientID %>').value = "";
            document.getElementById('<%= txtProductName.ClientID %>').value = "";
            document.getElementById('<%= txtPrice.ClientID %>').value = "";
            document.getElementById('<%= txtStock.ClientID %>').value = "";
            document.getElementById('<%= txtDescription.ClientID %>').value = "";
            var ddl = document.getElementById('<%= ddlCategory.ClientID %>');
            if (ddl && ddl.options.length > 0) ddl.selectedIndex = 0;
        }
    </script>

</asp:Content>
