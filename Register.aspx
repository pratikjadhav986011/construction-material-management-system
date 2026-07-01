<%@ Page Title="Register" Language="C#"
    MasterPageFile="~/Site.master"
    AutoEventWireup="true"
    CodeBehind="Register.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Register" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .register-container {
            max-width: 450px;
            margin: 50px auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .register-container h3 {
            font-weight: 700;
        }
        .text-danger {
            color: red !important;
            font-size: 13px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container">
        <div class="register-container">

            <h3 class="text-center mb-4">Create Account</h3>

            <!-- FULL NAME -->
            <div class="mb-3">
                <label>Full Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" />
                <asp:RequiredFieldValidator ID="reqName" runat="server"
                    ControlToValidate="txtName"
                    ErrorMessage="Full Name is required"
                    CssClass="text-danger" Display="Dynamic" />
            </div>

            <!-- EMAIL -->
            <div class="mb-3">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" />

                <asp:RequiredFieldValidator ID="reqEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Email is required"
                    CssClass="text-danger" Display="Dynamic" />

                <asp:RegularExpressionValidator ID="valEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ErrorMessage="Only Gmail addresses are allowed (example@gmail.com)"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationExpression="^[a-zA-Z0-9._%+-]+@gmail\.com$" />
            </div>


            <!-- MOBILE -->
            <div class="mb-3">
                <label>Mobile</label>
                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="10" />

                <asp:RequiredFieldValidator ID="reqMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ErrorMessage="Mobile Number is required"
                    CssClass="text-danger" Display="Dynamic" />

                <asp:RegularExpressionValidator ID="valMobile" runat="server"
                    ControlToValidate="txtMobile"
                    ErrorMessage="Enter valid 10-digit mobile number"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationExpression="^[0-9]{10}$" />
            </div>

            <!-- PASSWORD -->
            <div class="mb-3">
                <label>Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />

                <asp:RequiredFieldValidator ID="reqPass" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password is required"
                    CssClass="text-danger" Display="Dynamic" />

                <asp:RegularExpressionValidator ID="valPass" runat="server"
                    ControlToValidate="txtPassword"
                    ErrorMessage="Password must be 6+ chars and include letters & numbers"
                    CssClass="text-danger" Display="Dynamic"
                    ValidationExpression="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$" />
            </div>

            <!-- ADDRESS -->
            <div class="mb-3">
                <label>Address</label>
                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" />
            </div>

            <!-- REGISTER BUTTON -->
            <div class="d-grid">
                <asp:Button ID="btnRegister" runat="server" Text="Register"
                    CssClass="btn btn-success"
                    OnClick="btnRegister_Click" />
            </div>

            <div class="text-center mt-3">
                <small>Already have an account? <a href="Login.aspx">Login</a></small>
            </div>

        </div>
    </div>

</asp:Content>
