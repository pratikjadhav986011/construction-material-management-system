<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="Services.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Services" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .service-box {
            background: #ffffff;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: 0.3s;
            height: 100%;
        }
        .service-box:hover {
            transform: translateY(-6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .service-icon {
            font-size: 45px;
            color: #ffc107;
            margin-bottom: 15px;
        }
        h1.page-title {
            font-weight: 700;
            text-align: center;
            margin-bottom: 40px;
        }
    </style>

    <div class="container my-5">

        <h1 class="page-title">Our Services</h1>

        <div class="row g-4">

            <!-- SERVICE 1 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-truck service-icon"></i>
                    <h4 class="fw-bold">Fast Delivery</h4>
                    <p class="text-muted">
                        We deliver construction materials at your location on time,
                        ensuring fast and safe delivery across all nearby cities.
                    </p>
                </div>
            </div>

            <!-- SERVICE 2 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-tools service-icon"></i>
                    <h4 class="fw-bold">Construction Assistance</h4>
                    <p class="text-muted">
                        Get expert consultation for building materials, quantity estimation,
                        and selection support for your dream project.
                    </p>
                </div>
            </div>

            <!-- SERVICE 3 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-headset service-icon"></i>
                    <h4 class="fw-bold">24/7 Customer Support</h4>
                    <p class="text-muted">
                        Our dedicated support team is always available to assist you with
                        orders, tracking, refunds, and more.
                    </p>
                </div>
            </div>

            <!-- SERVICE 4 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-industry service-icon"></i>
                    <h4 class="fw-bold">Bulk Material Supply</h4>
                    <p class="text-muted">
                        We offer high-quality materials for large construction
                        projects at discounted wholesale prices.
                    </p>
                </div>
            </div>

            <!-- SERVICE 5 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-calculator service-icon"></i>
                    <h4 class="fw-bold">Material Estimation</h4>
                    <p class="text-muted">
                        Need help calculating your material requirement?
                        We provide accurate estimation for Cement, TMT, Sand, Bricks etc.
                    </p>
                </div>
            </div>

            <!-- SERVICE 6 -->
            <div class="col-md-4">
                <div class="service-box text-center">
                    <i class="fas fa-warehouse service-icon"></i>
                    <h4 class="fw-bold">Warehouse Pickup</h4>
                    <p class="text-muted">
                        Prefer collecting yourself?  
                        We allow safe warehouse pickup from multiple locations.
                    </p>
                </div>
            </div>

        </div>

    </div>

</asp:Content>
