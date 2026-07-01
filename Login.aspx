<%@ Page Title="Login" Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="Login.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Login" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .login-container {
            width: 450px;
            margin: 100px auto;
            background: #fff;
            padding: 35px;
            border-radius: 12px;
            position: relative; /* Needed for Admin login absolute positioning */
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        /* Center the Login heading */
        .login-title {
            font-weight: 700;
            text-align: center;
            margin-bottom: 35px;
        }

        /* Admin Login link positioned slightly higher */
        .admin-login-link {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 15px;
            text-decoration: none;
            font-weight: 600;
            height: 17px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Entire Login Box centered -->
    <div class="d-flex justify-content-center">
        <div class="login-container">

            <!-- ADMIN LOGIN TOP RIGHT (hidden visually; accessible via Ctrl+Shift+S) -->
            <a id="lnkAdminHidden" href="AdminLogin.aspx" style="display:none;" aria-hidden="true">Admin</a>

            <!-- LOGIN TITLE CENTERED -->
            <h3 class="login-title">Login</h3>

            <div class="mb-3">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />
            </div>

            <div class="mb-3">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
            </div>

            <div class="d-grid">
                <asp:Button ID="btnLogin" runat="server" Text="Login"
                    CssClass="btn btn-primary"
                    OnClick="btnLogin_Click" />
            </div>

            <div class="text-center mt-3">
                <a href="ForgotPassword.aspx" class="text-primary" style="text-decoration:none;">
                    Forgot Password?
                </a>
            </div>

            <div class="text-center mt-3">
                <small>Don't have an account? <a href="Register.aspx">Register</a></small>
            </div>

        </div>
    </div>

    <script>
        // Shortcut: Ctrl + Shift + S opens Admin login
        document.addEventListener('keydown', function (e) {
            try {
                // Ignore if focus is on an input to avoid interfering with typing
                var tag = document.activeElement && document.activeElement.tagName;
                if (tag === 'INPUT' || tag === 'TEXTAREA' || document.activeElement && document.activeElement.isContentEditable) return;

                if (e.ctrlKey && e.shiftKey && (e.key === 'S' || e.key === 's')) {
                    // navigate to admin login
                    window.location.href = 'AdminLogin.aspx';
                }
            } catch (ex) {
                // swallow errors
            }
        });
    </script>

</asp:Content>
