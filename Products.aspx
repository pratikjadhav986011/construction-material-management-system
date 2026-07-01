<%@ Page Title="Products" Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="Products.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Products" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">

        <h3 class="fw-bold mb-4 text-center">
            <asp:Label ID="lblCategoryName" runat="server" Text=""></asp:Label>
        </h3>

        <asp:Label ID="lblMessage" runat="server" CssClass="text-danger fw-bold"></asp:Label>

        <div class="row">

            <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="RptProducts_ItemCommand">
                <ItemTemplate>

                    <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                        <div class="card shadow-sm border-0 product-card">
                            
                            <img src='<%# ResolveUrl("~/" + Eval("ImageUrl")) %>' 
                                 class="card-img-top"
                                 style="height:180px; object-fit:contain;" />

                            <div class="card-body text-center">
                                <h6 class="fw-bold"><%# Eval("ProductName") %></h6>

                                <p class="text-muted mb-1">₹ <%# Eval("Price") %></p>
                                <p class="small text-secondary">Stock: <%# Eval("Stock") %></p>

                                <asp:Button ID="btnAddCart" runat="server"
                                            Text="Add to Cart"
                                            CssClass="btn btn-primary w-100 mb-2"
                                            CommandName="addToCart"
                                            CommandArgument='<%# Eval("ProductID") %>' />

                                <asp:Button ID="btnBuyNow" runat="server"
                                            Text="Buy Now"
                                            CssClass="btn btn-success w-100"
                                            CommandName="buyNow"
                                            CommandArgument='<%# Eval("ProductID") %>' />
                            </div>

                        </div>
                    </div>

                </ItemTemplate>
            </asp:Repeater>

        </div>

    </div>

    <style>
        .product-card:hover {
            transform: scale(1.03);
            transition: 0.3s;
        }
    </style>

</asp:Content>
