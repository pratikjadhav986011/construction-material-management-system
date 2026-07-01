<%@ Page Title="Admin Login" Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.master"
    CodeBehind="AdminLogin.aspx.cs"
    Inherits="ConstructionMaterialsManagement.AdminLogin" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .admin-login-container {
            width: 420px;
            margin: 100px auto;
            background: #fff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .admin-title {
            text-align: center;
            font-weight: 700;
            margin-bottom: 25px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex justify-content-center">
        <div class="admin-login-container">

            <h3 class="admin-title">Admin Login</h3>

            <div class="mb-3">
                <label>Admin Username</label>
                <asp:TextBox ID="txtAdminUser" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label>Password</label>
                <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" CssClass="form-control" />
            </div>

            <div class="d-grid">
                <asp:Button ID="btnAdminLogin" runat="server" Text="Login"
                    CssClass="btn btn-dark"
                    OnClick="btnAdminLogin_Click" />
            </div>

        </div>
    </div>

</asp:Content>
