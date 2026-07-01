<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="Contact.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Contact" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .contact-box {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        .contact-icon {
            font-size: 35px;
            color: #ffc107;
            margin-bottom: 10px;
        }
        .map-box iframe {
            width: 100%;
            height: 350px;
            border: 0;
            border-radius: 12px;
        }
    </style>

    <div class="container my-5">

        <!-- PAGE TITLE -->
        <h1 class="text-center fw-bold mb-4">Contact Us</h1>

        <div class="row g-4">

            <!-- CONTACT FORM -->
            <div class="col-lg-6 col-md-12">
                <div class="contact-box">

                    <h4 class="fw-bold mb-3">Send Us a Message</h4>

                    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>

                    <div class="mb-3">
                        <label>Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-control" Placeholder="Your Name" />
                    </div>

                    <div class="mb-3">
                        <label>Email</label>
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" Placeholder="Your Email" />
                    </div>

                    <div class="mb-3">
                        <label>Message</label>
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="5" Placeholder="Write your message here..." />
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Send Message"
                        CssClass="btn btn-warning w-100 fw-bold" OnClick="btnSubmit_Click" />

                </div>
            </div>

            <!-- CONTACT INFO -->
            <div class="col-lg-6 col-md-12">
                <div class="contact-box">

                    <div class="mb-4 text-center">
                        <i class="fas fa-map-marker-alt contact-icon"></i>
                        <h5 class="fw-bold">Office Address</h5>
                        <p class="text-muted">
                            Vijaynagar, Sangli<br />
                            Maharashtra, India 416416
                        </p>
                    </div>

                    <hr />

                    <div class="mb-4 text-center">
                        <i class="fas fa-phone-alt contact-icon"></i>
                        <h5 class="fw-bold">Phone</h5>
                        <p class="text-muted">+91 9175984788</p>
                    </div>

                    <hr />

                    <div class="mb-4 text-center">
                        <i class="fas fa-envelope contact-icon"></i>
                        <h5 class="fw-bold">Email</h5>
                        <p class="text-muted">support@construction.com</p>
                    </div>

                </div>
            </div>

        </div>

        <!-- GOOGLE MAP - VIJAYNAGAR, SANGLI -->
        <div class="map-box mt-5">
            <iframe
              src="https://www.google.com/maps?q=Vijaynagar%20Sangli&z=14&output=embed"
              loading="lazy">
            </iframe>
        </div>

    </div>

</asp:Content>
