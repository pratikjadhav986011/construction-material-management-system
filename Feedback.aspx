<%@ Page Title="Feedback" Language="C#" MasterPageFile="~/Site.master"
    AutoEventWireup="true" CodeBehind="Feedback.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Feedback" %>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <h2 class="fw-bold text-center mb-4">We Value Your Feedback</h2>

        <!-- Message -->
        <asp:Label ID="lblMessage" runat="server" CssClass="fw-bold text-center d-block mb-4"
            Visible="false"></asp:Label>

        <!-- Feedback Form -->
        <div id="feedbackForm" runat="server" class="card shadow p-4"
             style="max-width:600px; margin:auto;">

            <div class="mb-3">3
                .0
                <label class="form-label">Your Name</label>
                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Your Email</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label">Your Feedback</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine"
                    CssClass="form-control" Rows="4" placeholder="Write your feedback..."></asp:TextBox>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Feedback"
                CssClass="btn btn-primary w-100" OnClick="btnSubmit_Click" />
        </div>

    </div>

</asp:Content>
