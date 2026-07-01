<%@ Page Title="Forgot Password" Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.master"
    CodeBehind="ForgotPassword.aspx.cs"
    Inherits="ConstructionMaterialsManagement.ForgotPassword" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .forgot-container {
            max-width: 550px;
            margin: 60px auto;
            background: #fff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 5px 18px rgba(0,0,0,0.15);
        }

        .forgot-container h3 {
            font-weight: 700;
            text-align: center;
            margin-bottom: 25px;
        }

        .otp-box {
            text-align: center;
            font-size: 22px;
            font-weight: bold;
            letter-spacing: 4px;
        }

        .resend-btn {
            font-weight: 600;
        }

        #timerText {
            font-size: 14px;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

    <div class="forgot-container">

        <h3>Forgot Password</h3>

        <!-- ================= EMAIL INPUT SECTION ================= -->
        <div id="emailDiv" runat="server">
            <label>Enter Registered Email</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />

            <asp:Button ID="btnSendOTP" runat="server" Text="Send OTP"
                CssClass="btn btn-primary w-100 mt-4 py-2"
                OnClick="btnSendOTP_Click" />
        </div>

        <!-- ================= OTP VERIFICATION SECTION ================= -->
        <div id="otpDiv" runat="server" visible="false">

            <label class="mt-3">Enter OTP</label>
            <asp:TextBox ID="txtOTP" runat="server" CssClass="form-control otp-box" MaxLength="6" />

            <asp:Button ID="btnVerifyOTP" runat="server" Text="Verify OTP"
                CssClass="btn btn-success w-100 mt-3 py-2"
                OnClick="btnVerifyOTP_Click" />

            <!-- RESEND OTP BUTTON -->
            <asp:Button ID="btnResendOTP" runat="server" Text="Resend OTP"
                CssClass="btn btn-warning w-100 mt-3 py-2 resend-btn"
                OnClick="btnResendOTP_Click" />

            <!-- TIMER TEXT -->
            <p id="timerText" runat="server" class="text-danger text-center mt-2"></p>

        </div>

    </div>

</asp:Content>
