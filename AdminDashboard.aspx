<%@ Page Title="Dashboard" Language="C#"
    MasterPageFile="~/AdminMaster.master"
    AutoEventWireup="true"
    CodeBehind="AdminDashboard.aspx.cs"
    Inherits="ConstructionMaterialsManagement.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<!-- DASHBOARD CONTENT -->
<div class="container-fluid dashboard-content mt-4">

    <div class="row g-4">

        <!-- Users -->
        <div class="col-md-4">
            <div class="card-box bg-users">
                <i class="fas fa-users"></i>
                <p class="mt-2 mb-1">Total Users</p>
                <asp:Label ID="lblUsers" runat="server" CssClass="card-value"></asp:Label>
            </div>
        </div>

        <!-- Products -->
        <div class="col-md-4">
            <div class="card-box bg-products">
                <i class="fas fa-box"></i>
                <p class="mt-2 mb-1">Total Products</p>
                <asp:Label ID="lblProducts" runat="server" CssClass="card-value"></asp:Label>
            </div>
        </div>

        <!-- Orders -->
        <div class="col-md-4">
            <div class="card-box bg-orders">
                <i class="fas fa-shopping-cart"></i>
                <p class="mt-2 mb-1">Total Orders</p>
                <asp:Label ID="lblOrders" runat="server" CssClass="card-value"></asp:Label>
            </div>
        </div>

    </div>

</div>

<style>
    body {
        background-color: #eef1f5 !important;
    }

    .dashboard-content {
        padding: 20px 35px;
    }

    .card-box {
        border-radius: 15px;
        padding: 25px;
        color: white;
        box-shadow: 0 4px 15px rgba(0,0,0,0.12);
        transition: 0.3s;
    }

    .card-box:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 22px rgba(0,0,0,0.18);
    }

    .bg-users { background: linear-gradient(45deg, #007bff, #00a2ff); }
    .bg-products { background: linear-gradient(45deg, #28a745, #4cd964); }
    .bg-orders { background: linear-gradient(45deg, #fd7e14, #ffa743); }

    .card-box i {
        font-size: 38px;
        margin-bottom: 10px;
        opacity: 0.9;
    }

    .card-value {
        font-size: 32px;
        font-weight: 700;
        margin-top: -5px;
    }
</style>

</asp:Content>
