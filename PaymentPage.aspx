<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentPage.aspx.cs"
    Inherits="ConstructionMaterialsManagement.PaymentPage"
    MasterPageFile="~/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterPageTitle" runat="server">
    Payment
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .card-box {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        margin-bottom: 30px;
    }

    .btn-pay {
        background: #28a745;
        color: white;
        padding: 12px 22px;
        border: none;
        border-radius: 8px;
        font-size: 17px;
    }

    .qr-box {
        width: 220px;
        height: 220px;
        border: 6px solid #eee;
        padding: 10px;
        border-radius: 12px;
    }

    .form-control {
        height: 45px;
        border-radius: 10px;
        font-size: 16px;
    }
</style>


<div class="card-box">
    <h3 id="lblHeader" runat="server" class="fw-bold">Complete Payment</h3>
    <hr />

    <p><b>Supplier:</b> <span id="lblSupplier" runat="server"></span></p>
    <p><b>Product:</b> <span id="lblProduct" runat="server"></span></p>
    <p><b>Quantity:</b> <span id="lblQty" runat="server"></span></p>
    <p><b>Total Amount:</b> ₹ <span id="lblTotal" runat="server"></span></p>

    <hr />

    <label><b>Select Payment Method</b></label>
    <asp:RadioButtonList ID="rblPayment" runat="server" CssClass="form-check"
        AutoPostBack="true" OnSelectedIndexChanged="rblPayment_SelectedIndexChanged">
        <asp:ListItem Value="UPI">UPI</asp:ListItem>
        <asp:ListItem Value="Card">Debit / Credit Card</asp:ListItem>
        <asp:ListItem Value="Cash">Cash On Delivery</asp:ListItem>
    </asp:RadioButtonList>

    <br />

   <!-- UPI Section -->
<div id="panelUPI" runat="server" visible="false" class="card-box">
    <h4>UPI Payment</h4>
    <p>Scan using GPay, PhonePe, Paytm etc.</p>

    <img src="https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=pratikjadhav986011-1@okaxis"
         class="qr-box" />

    <p class="mt-3"><b>UPI ID:</b> manjunath123-1@okaxis</p>

</div>


    <!-- Card Payment -->
    <div id="panelCard" runat="server" visible="false" class="card-box">
        <h4>Debit / Credit Card Payment</h4>

        <label>Card Number</label>
        <asp:TextBox ID="txtCardNumber" CssClass="form-control" runat="server"></asp:TextBox>

        <label class="mt-2">Expiry Date</label>
        <asp:TextBox ID="txtExpiry" CssClass="form-control" placeholder="MM/YY" runat="server"></asp:TextBox>

        <label class="mt-2">CVV</label>
        <asp:TextBox ID="txtCVV" CssClass="form-control" TextMode="Password" runat="server"></asp:TextBox>
    </div>

    <!-- Cash Payment -->
    <div id="panelCash" runat="server" visible="false" class="card-box">
        <h4>Cash on Delivery</h4>
        <p>No payment details required.</p>
    </div>

    <br />

    <asp:Button ID="btnConfirm" runat="server" Text="Confirm Payment"
        CssClass="btn-pay" OnClick="btnConfirm_Click" />

</div>

</asp:Content>
