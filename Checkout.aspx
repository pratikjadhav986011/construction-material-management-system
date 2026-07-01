<%@ Page Title="Checkout" Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="Checkout.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Checkout" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-4">
        <h2 class="fw-bold text-center mb-4">Checkout</h2>

        <div class="row">

            <!-- LEFT ITEMS -->
            <div class="col-lg-8">
                <asp:Repeater ID="rptCheckout" runat="server" OnItemCommand="rptCheckout_ItemCommand">
                    <ItemTemplate>

                        <div class="card mb-3 shadow-sm border-0">
                            <div class="card-body d-flex align-items-center">

                                <!-- IMAGE -->
                                <div style="width:150px;" class="me-3">
                                    <img src='<%# ResolveUrl("~/" + Eval("ImageUrl")) %>'
                                         class="img-fluid rounded"
                                         style="object-fit:cover; max-height:120px;" />
                                </div>

                                <!-- NAME + PRICE -->
                                <div class="flex-grow-1">
                                    <h5 class="mb-1"><%# Eval("ProductName") %></h5>

                                    <div class="text-muted mb-2">
                                        ₹ <%# Eval("Price","{0:0.00}") %>
                                    </div>

                                    <asp:HiddenField ID="hfPrice" runat="server" Value='<%# Eval("Price") %>' /></div>
                                <asp:HiddenField ID="hfProductID" runat="server" Value='<%# Eval("ProductID") %>' />


                                <!-- QTY BUTTONS -->
                                <div class="d-flex align-items-center me-3">
                                    <asp:LinkButton ID="btnMinus" runat="server"
                                        CommandName="qtyMinus"
                                        CommandArgument='<%# Eval("ProductID") %>'
                                        CssClass="btn btn-outline-secondary btn-sm me-1">-</asp:LinkButton>

                                   <asp:TextBox ID="txtQty" runat="server"
                                    CssClass="form-control text-center"
                                    Style="width:60px;"
                                    AutoPostBack="true"
                                    OnTextChanged="txtQty_TextChanged"
                                    Text='<%# Eval("Quantity") %>' />


                                    <asp:LinkButton ID="btnPlus" runat="server"
                                        CommandName="qtyPlus"
                                        CommandArgument='<%# Eval("ProductID") %>'
                                        CssClass="btn btn-outline-secondary btn-sm ms-1">+</asp:LinkButton>
                                </div>

                                <!-- Remove -->
                                <asp:LinkButton ID="btnRemove" runat="server"
                                    CommandName="remove"
                                    CommandArgument='<%# Eval("ProductID") %>'
                                    CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Remove this item?');">
                                    Remove
                                </asp:LinkButton>

                            </div>
                        </div>

                    </ItemTemplate>
                </asp:Repeater>

                <asp:Label ID="lblEmpty" runat="server"
                    Text="Your cart is empty."
                    CssClass="text-center text-muted d-block mt-3"
                    Visible="false" />
            </div>

            <!-- RIGHT SUMMARY -->
            <div class="col-lg-4">
                <div class="card shadow-sm">
                    <div class="card-body">

                        <h4 class="fw-bold mb-3">Order Summary</h4>

                        <div class="d-flex justify-content-between">
                            <span>Subtotal:</span>
                            <span>₹ <asp:Label ID="lblSubtotal" runat="server" Text="0.00" /></span>
                        </div>

                        <div class="d-flex justify-content-between">
                            <span>Delivery Charge:</span>
                            <span>₹ <asp:Label ID="lblDelivery" runat="server" Text="0.00" /></span>
                        </div>

                        <hr />

                        <div class="d-flex justify-content-between fw-bold mb-3">
                            <span>Total Amount:</span>
                            <span>₹ <asp:Label ID="lblTotal" runat="server" Text="0.00" /></span>
                        </div>

                        <asp:Button ID="btnPlaceOrder" runat="server"
                            Text="Proceed to Payment"
                            CssClass="btn btn-success w-100"
                            OnClick="btnPlaceOrder_Click" />

                    </div>
                </div>
            </div>

        </div>
    </div>
    <script>
        document.addEventListener("input", function (e) {
            if (e.target.matches("input[id*='txtQty']")) {
                // allow only numbers
                e.target.value = e.target.value.replace(/[^0-9]/g, "");

                // prevent empty
                if (e.target.value === "") e.target.value = "1";
            }
        });
    </script>


</asp:Content>
