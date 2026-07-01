<%@ Page Title="Payment" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="Payment.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Payment" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .card-box {
            background: #fff;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }
        .qr-box {
            width: 200px;
            height: 200px;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 10px;
            background: #fafafa;
        }
        .card-input { margin-bottom: 15px; }
    </style>

    <!-- Hidden Fields -->
    <asp:HiddenField ID="hfUPILink" runat="server" />
    <asp:HiddenField ID="hfUPIPaid" runat="server" Value="NO" />

    <script>
        function processUPI() {
            var link = document.getElementById("<%= hfUPILink.ClientID %>").value;

            if (link) {
                window.location.href = link;

                setTimeout(function () {
                    document.getElementById("<%= hfUPIPaid.ClientID %>").value = "YES";
                }, 3000);
            }
            else {
                alert("Unable to start UPI Payment.");
            }
        }
    </script>
   
    <div class="container my-5">
        <h2 class="fw-bold mb-4">Payment</h2>

        <div class="row">

            <!-- LEFT SIDE -->
            <div class="col-md-7">

                <!-- PAYMENT METHOD -->
                <div class="card-box">
                    <h4 class="fw-bold mb-3">Select Payment Method</h4>

                    <asp:RadioButtonList ID="rbPayment" runat="server"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="rbPayment_SelectedIndexChanged">
                        <asp:ListItem Value="UPI" Selected="True">UPI</asp:ListItem>
                        <asp:ListItem Value="CARD">Debit / Credit Card</asp:ListItem>
                    </asp:RadioButtonList>
                </div>

                <!-- UPI PAYMENT -->
                <div id="upiBox" runat="server" class="card-box">
                    <h5 class="fw-bold">UPI Payment</h5>
                    <p>Scan using GPay, PhonePe, Paytm, etc.</p>

                    <img id="imgQR" runat="server" class="qr-box" />

                    <p class="mt-3">
                        <strong>UPI ID:</strong>
                        <span class="text-primary fw-bold">pratikjadhav986011-1@okaxis</span>
                    </p>

                    <a href="#" onclick="processUPI(); return false;"
                        class="btn btn-success w-50 mt-3">Pay Using UPI App</a>
                </div>

                <!-- CARD PAYMENT -->
                <div id="cardBox" runat="server" class="card-box" style="display:none;">
                    <h5 class="fw-bold">Card Payment</h5>

                    <asp:TextBox ID="txtCardName" runat="server" CssClass="form-control card-input"
                        placeholder="Card Holder Name"></asp:TextBox>

                    <asp:TextBox ID="txtCardNumber" runat="server" CssClass="form-control card-input"
                        MaxLength="16" placeholder="Card Number (16 digits)"></asp:TextBox>

                    <div class="row">
                        <div class="col-md-6">
                            <asp:TextBox ID="txtExpiry" runat="server" CssClass="form-control card-input"
                                MaxLength="5" placeholder="MM/YY"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-control card-input"
                                MaxLength="3" TextMode="Password" placeholder="CVV"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnPayCard" runat="server"
                        Text="Pay Securely"
                        CssClass="btn btn-primary w-50 mt-2"
                        OnClick="btnPayCard_Click" />
                </div>

            </div>

            <!-- RIGHT SIDE -->
            <div class="col-md-5">
                <div class="card-box">
                    <h4 class="fw-bold mb-3">Order Summary</h4>

                    <p class="d-flex justify-content-between">
                        <span>Subtotal:</span>
                        ₹ <strong><asp:Label ID="lblSubtotal" runat="server"></asp:Label></strong>
                    </p>

                    <p class="d-flex justify-content-between">
                        <span>Delivery:</span>
                        ₹ <strong><asp:Label ID="lblDelivery" runat="server"></asp:Label></strong>
                    </p>

                    <hr />

                    <p class="d-flex justify-content-between fs-5">
                        <span><strong>Total:</strong></span>
                        ₹ <strong><asp:Label ID="lblTotal" runat="server"></asp:Label></strong>
                    </p>

                    <asp:Button ID="btnComplete" runat="server"
                        Text="Complete Payment"
                        CssClass="btn btn-success w-100 mt-3"
                        OnClick="btnComplete_Click" />
                </div>
            </div>

        </div>
    </div>

</asp:Content>
