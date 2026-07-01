<%@ Page Title="Reset Password" Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.master"
    CodeBehind="ResetPassword.aspx.cs"
    Inherits="ConstructionMaterialsManagement.ResetPassword" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .reset-container {
            max-width: 500px;
            margin: 60px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .reset-container h3 {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

    <div class="reset-container">

        <h3>Reset Password</h3>

        <label>New Password</label>
        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control" />

        <label class="mt-3">Confirm Password</label>
        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />

        <asp:Button ID="btnReset" runat="server" Text="Update Password"
            CssClass="btn btn-success w-100 mt-4 py-2"
            OnClick="btnReset_Click" />

    </div>

</asp:Content>
