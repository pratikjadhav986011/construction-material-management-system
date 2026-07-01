<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="About.aspx.cs"
    Inherits="ConstructionMaterialsManagement.About" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .section-title {
            font-weight: 700;
            font-size: 32px;
            margin-bottom: 20px;
            text-align: center;
        }
        .about-box {
            background: #ffffff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .icon-lg {
            font-size: 45px;
            color: #ffc107;
        }
        .why-card {
            padding: 20px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0px 3px 12px rgba(0,0,0,0.08);
            transition: .3s;
            height: 100%;
        }
        .why-card:hover {
            transform: translateY(-5px);
        }
    </style>

    <div class="container my-5">

        <!-- TITLE -->
        <h1 class="section-title mb-4">About Our Company</h1>

        <!-- ABOUT BOX -->
        <div class="about-box mb-5">
            <p class="lead">
                <strong>Construction Materials Management</strong> is your trusted online store 
                for high-quality construction materials like Steel, Cement, Sand, Bricks, Paints, 
                Tiles, and much more.
            </p>

            <p class="mt-3">
                We provide a simple and fast way to order building materials online with doorstep 
                delivery. Our platform helps homeowners, builders, contractors, and construction 
                companies to save time and cost.
            </p>
        </div>

        <!-- MISSION • VISION • VALUES -->
        <div class="row text-center mb-5">

            <div class="col-md-4 mb-4">
                <div class="why-card">
                    <i class="fas fa-bullseye icon-lg mb-3"></i>
                    <h4 class="fw-bold">Our Mission</h4>
                    <p class="text-muted">
                        To provide high-quality construction materials at affordable prices 
                        with fast and reliable delivery.
                    </p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="why-card">
                    <i class="fas fa-lightbulb icon-lg mb-3"></i>
                    <h4 class="fw-bold">Our Vision</h4>
                    <p class="text-muted">
                        To become India’s most trusted digital marketplace for construction materials.
                    </p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="why-card">
                    <i class="fas fa-handshake icon-lg mb-3"></i>
                    <h4 class="fw-bold">Our Values</h4>
                    <p class="text-muted">
                        Honesty, Quality, Trust, Customer Satisfaction, and Long-term Commitment.
                    </p>
                </div>
            </div>

        </div>

        <!-- WHY CHOOSE US -->
        <h2 class="section-title mb-4">Why Choose Us?</h2>

        <div class="row text-center g-4 mb-5">

            <div class="col-md-3">
                <div class="why-card">
                    <i class="fas fa-truck-fast icon-lg mb-3"></i>
                    <h5 class="fw-bold">Fast Delivery</h5>
                    <p class="text-muted small">Get materials delivered to your site quickly and safely.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <i class="fas fa-wallet icon-lg mb-3"></i>
                    <h5 class="fw-bold">Affordable Pricing</h5>
                    <p class="text-muted small">Competitive market rates to reduce your project cost.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <i class="fas fa-check-circle icon-lg mb-3"></i>
                    <h5 class="fw-bold">Premium Quality</h5>
                    <p class="text-muted small">We provide only genuine and trusted brand materials.</p>
                </div>
            </div>

            <div class="col-md-3">
                <div class="why-card">
                    <i class="fas fa-headset icon-lg mb-3"></i>
                    <h5 class="fw-bold">24/7 Support</h5>
                    <p class="text-muted small">Help available for orders, queries, and project guidance.</p>
                </div>
            </div>

        </div>

        <!-- TEAM SECTION (OPTIONAL) -->
        <h2 class="section-title mb-4">Our Team</h2>

        <div class="row text-center">

            <div class="col-md-4 mb-4">
                <div class="about-box">
                    <img src="https://via.placeholder.com/200" class="rounded-circle mb-3" />
                    <h5 class="fw-bold">Pratik Jadhav</h5>
                    <p class="text-muted">Founder & CEO</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="about-box">
                    <img src="https://via.placeholder.com/200" class="rounded-circle mb-3" />
                    <h5 class="fw-bold">Ravi Sharma</h5>
                    <p class="text-muted">Operations Manager</p>
                </div>
            </div>

            <div class="col-md-4 mb-4">
                <div class="about-box">
                    <img src="https://via.placeholder.com/200" class="rounded-circle mb-3" />
                    <h5 class="fw-bold">Anjali Desai</h5>
                    <p class="text-muted">Customer Support Lead</p>
                </div>
            </div>

        </div>

    </div>

</asp:Content>
