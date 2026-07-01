<%@ Page Title="Home" Language="C#" AutoEventWireup="true"
    MasterPageFile="~/Site.master"
    CodeBehind="Home.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Home" %>

<asp:Content ID="HeadSection" ContentPlaceHolderID="HeadContent" runat="server">
<style>

/* ================= HERO SLIDER ================= */

.full-banner-slider {
    margin: 1.5rem 0;
    overflow: hidden;
    position: relative;
    border-radius: 10px;
}

.full-banner-slider .carousel-item {
    height: 380px;
    background-size: cover;
    background-position: center;
}

.slide-image-1 { background-image: url('/images/banners/b1.png'); }
.slide-image-2 { background-image: url('/images/banners/b2.png'); }
.slide-image-3 { background-image: url('/images/banners/b3.png'); }

/* ================= CATEGORIES ================= */

.categories-section {
    background: #f8f9fa;
    padding: 60px 0 80px 0;
}

.section-title {
    font-weight: 700;
    text-align: center;
    margin-bottom: 60px;
}

/* Row */
.category-row {
    display: flex;
    justify-content: space-between;
    gap: 20px;
}

/* ================= LIGHT ROTATING CARD BORDER ================= */

.category-card {
    position: relative;
    background: #ffffff;
    border-radius: 18px;
    padding: 25px 15px;
    text-align: center;
    width: 16%;
    box-shadow: 0 8px 20px rgba(0,0,0,0.05);
    overflow: hidden;
    z-index: 1;
}

/* Light faint rotating border */
.category-card::before {
    content: "";
    position: absolute;
    inset: -2px;
    border-radius: 20px;
    padding: 2px;
    background: conic-gradient(
        from 0deg,
        rgba(255,193,7,0.25),
        rgba(255,193,7,0.05),
        rgba(255,193,7,0.25)
    );
    animation: rotateCard 6s linear infinite;
    -webkit-mask:
        linear-gradient(#fff 0 0) content-box,
        linear-gradient(#fff 0 0);
    -webkit-mask-composite: xor;
            mask-composite: exclude;
    z-index: -1;
}

/* Smooth slow rotation */
@keyframes rotateCard {
    from { transform: rotate(0deg); }
    to { transform: rotate(360deg); }
}

/* Hover lift */
.category-card:hover {
    transform: translateY(-6px);
    box-shadow: 0 12px 30px rgba(255,193,7,0.15);
}

/* Image */
.image-wrapper {
    margin: auto;
}

.image-wrapper img {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
}

/* Title */
.category-card h5 {
    margin-top: 15px;
    font-weight: 600;
}

/* Remove link style */
.category-card a {
    text-decoration: none;
    color: inherit;
}

</style>
</asp:Content>

<asp:Content ID="MainSection" ContentPlaceHolderID="MainContent" runat="server">

<!-- HERO -->
<div id="FullBannerSlider" class="carousel slide full-banner-slider"
    data-bs-ride="carousel" data-bs-interval="4000">

    <div class="carousel-inner">
        <div class="carousel-item active slide-image-1"></div>
        <div class="carousel-item slide-image-2"></div>
        <div class="carousel-item slide-image-3"></div>
    </div>

    <button class="carousel-control-prev" type="button"
        data-bs-target="#FullBannerSlider" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>

    <button class="carousel-control-next" type="button"
        data-bs-target="#FullBannerSlider" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<!-- CATEGORIES -->
<section class="categories-section">
    <div class="container">
        <h2 class="section-title">CATEGORIES</h2>

        <div class="category-row">

            <div class="category-card">
                <a href="Products.aspx?cat=1">
                    <div class="image-wrapper">
                        <img src="/images/categories/bricks.png" />
                    </div>
                    <h5>Bricks</h5>
                </a>
            </div>

            <div class="category-card">
                <a href="Products.aspx?cat=2">
                    <div class="image-wrapper">
                        <img src="/images/categories/cement.png" />
                    </div>
                    <h5>Cement</h5>
                </a>
            </div>

            <div class="category-card">
                <a href="Products.aspx?cat=3">
                    <div class="image-wrapper">
                        <img src="/images/categories/steel.png" />
                    </div>
                    <h5>Reinforcement & Steel</h5>
                </a>
            </div>

            <div class="category-card">
                <a href="Products.aspx?cat=4">
                    <div class="image-wrapper">
                        <img src="/images/categories/sand.png" />
                    </div>
                    <h5>Aggregates & Sand</h5>
                </a>
            </div>

            <div class="category-card">
                <a href="Products.aspx?cat=5">
                    <div class="image-wrapper">
                        <img src="/images/categories/tiles.png" />
                    </div>
                    <h5>Tiles & Flooring</h5>
                </a>
            </div>

            <div class="category-card">
                <a href="Products.aspx?cat=6">
                    <div class="image-wrapper">
                        <img src="/images/categories/pipes.png" />
                    </div>
                    <h5>Pipes for Fitting</h5>
                </a>
            </div>

        </div>
    </div>
</section>

</asp:Content>