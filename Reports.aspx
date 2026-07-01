<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Reports.aspx.cs"
    Inherits="ConstructionMaterialsManagement.Reports"
    MasterPageFile="~/AdminMaster.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MasterPageTitle" runat="server">
    Reports
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<style>
    body { background-color: #f2f4f7; }

    .report-container {
        background: white;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 3px 12px rgba(0,0,0,0.1);
        width: 95%;
        margin: auto;
    }

    .section-header {
        font-size: 22px;
        font-weight: bold;
        margin-bottom: 20px;
    }

    .btn-report {
        width: 100%;
        padding: 12px;
        font-weight: 600;
        border-radius: 10px;
        color: white;
        border: none;
        font-size: 16px;
    }

    .btn-blue { background: #006aff; }
    .btn-blue:hover { background: #0053cc; }

    .btn-green { background: #028a39; }
    .btn-green:hover { background: #026f2f; }

    .btn-yellow { background: #ffc107; color: black; }
    .btn-yellow:hover { background: #e0ac07; }

    .btn-red { background: #d63232; }
    .btn-red:hover { background: #b52727; }

    .search-box { max-width: 420px; }
</style>

<div class="report-container">

    <div class="input-group search-box mb-4">
        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
            AutoPostBack="true" OnTextChanged="txtSearch_TextChanged"
            Placeholder="Search user by name, email or mobile" />
        <span class="input-group-text bg-dark text-white">
            <i class="fas fa-search"></i>
        </span>
    </div>



    <div class="row g-3 mb-4">

        <div class="col-md-3">
            <asp:Button ID="btnUserReport" runat="server" Text="User Report PDF"
                CssClass="btn-report btn-blue" OnClick="btnUserReport_Click" />
        </div>

        <div class="col-md-3">
            <asp:Button ID="btnProductReport" runat="server" Text="Product Report PDF"
                CssClass="btn-report btn-green" OnClick="btnProductReport_Click" />
        </div>

        <div class="col-md-3">
            <asp:Button ID="btnOrderReport" runat="server" Text="Order Report PDF"
                CssClass="btn-report btn-yellow" OnClick="btnOrderReport_Click" />
        </div>

        <div class="col-md-3">
            <asp:Button ID="btnFeedbackReport" runat="server" Text="Feedback Report PDF"
                CssClass="btn-report btn-red" OnClick="btnFeedbackReport_Click" />
        </div>

    </div>


 
    <h4 class="fw-bold mb-3">All Users</h4>

    <asp:GridView ID="gvUsers" runat="server"
        CssClass="table table-bordered table-striped"
        AutoGenerateColumns="False">

        <Columns>
            <asp:BoundField DataField="UserID" HeaderText="ID" />
            <asp:BoundField DataField="FullName" HeaderText="Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Mobile" HeaderText="Mobile" />
            <asp:BoundField DataField="Address" HeaderText="Address" />
        </Columns>

    </asp:GridView>

</div>

</asp:Content>
