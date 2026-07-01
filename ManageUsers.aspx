<%@ Page Title="Manage Users" Language="C#"
    MasterPageFile="~/AdminMaster.master"
    AutoEventWireup="true"
    CodeBehind="ManageUsers.aspx.cs"
    Inherits="ConstructionMaterialsManagement.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

<style>
    .page-title {
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 20px;
    }

    .search-card, .table-card {
        border-radius: 12px;
        padding: 20px;
    }

    .search-card {
        background: #ffffff;
        box-shadow: 0 3px 12px rgba(0,0,0,0.08);
    }

    /* 3D Search Bar */
.search-input {
    height: 48px !important;
    width: 400px;
    font-size: 18px !important;
    border-radius: 10px !important;
    padding-left: 15px !important;
    border: 1px solid #d0d0d0 !important;
    box-shadow: 0 3px 10px rgba(0,0,0,0.12) !important;
    transition: 0.2s ease-in-out;
}

.search-input:focus {
    outline: none !important;
    box-shadow: 0 4px 14px rgba(0,0,0,0.22) !important;
}

/* Bigger 3D Search Button */
.search-btn {
    height: 48px !important;
    font-size: 18px !important;
    border-radius: 10px !important;
    padding: 0 25px !important;
    box-shadow: 0 3px 10px rgba(0,0,0,0.15) !important;
}


    .table-card {
        background: #ffffff;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

  
    .users-grid th {
        background: #f4f5f7 !important;
        padding: 12px !important;
        font-weight: 600 !important;
        color: #333 !important;
    }

    .users-grid td {
        padding: 10px !important;
        vertical-align: middle !important;
    }

    .users-grid tr:hover td {
        background: #f8f9fa !important;
    }

    .btn-edit {
        background: #28a745 !important;
        color: #fff !important;
        padding: 5px 12px !important;
        border-radius: 6px;
        text-decoration: none !important;
    }

    .btn-save, .btn-cancel {
    display: inline-block !important;
    margin-right: 6px !important;
    margin-top: 4px !important;
    padding: 4px 10px !important;
    font-size: 14px !important;
}


    .btn-delete {
        background: #dc3545 !important;
        color: #fff !important;
        padding: 6px 12px !important;
        border-radius: 6px;
    }

    .msg {
        padding: 10px 15px;
        border-radius: 6px;
        margin-bottom: 10px;
        display: inline-block;
    }

    .msg-error { background: #ffd3d3; color: #c00000; }
    .msg-success { background: #d8ffda; color: #0a8a00; }

    .header-row { display:flex; align-items:center; justify-content:space-between; margin-bottom:12px; }

</style>

<div class="container mt-4 mb-5">

    <div class="header-row">
        <h3 class="page-title"><i class="fa-solid fa-users"></i> Manage Users</h3>

        <div>
            <asp:Button ID="btnDownloadReport" runat="server" CssClass="btn btn-primary me-2" Text="Download Report" OnClick="btnDownloadReport_Click" />
            <asp:Button ID="btnDownloadCrystal" runat="server" CssClass="btn btn-outline-secondary" Text="Download Ledger (Crystal)" OnClick="btnDownloadCrystal_Click" />
        </div>
    </div>

    <asp:Label ID="lblMsg" runat="server"></asp:Label>

    <div class="search-card mb-4">
    <div class="input-group">

        <asp:TextBox ID="txtSearch" runat="server"
            CssClass="form-control search-input"
            placeholder="Search user by name, email or mobile">
        </asp:TextBox>

        <asp:Button ID="btnSearch" runat="server"
            CssClass="btn btn-dark search-btn"
            Text="Search" OnClick="btnSearch_Click" />

    </div>
</div>



    <div class="table-card">
        <asp:GridView ID="GridViewUsers" runat="server"
            AutoGenerateColumns="False"
            CssClass="table table-bordered table-hover users-grid"
            DataKeyNames="UserID"
            OnRowEditing="GridViewUsers_RowEditing"
            OnRowUpdating="GridViewUsers_RowUpdating"
            OnRowCancelingEdit="GridViewUsers_RowCancelingEdit"
            OnRowDeleting="GridViewUsers_RowDeleting">

            <Columns>

                <asp:BoundField DataField="RowNum" HeaderText="Sr No" ReadOnly="True" />

                <asp:BoundField DataField="FullName" HeaderText="Full Name" />

                <asp:BoundField DataField="Email" HeaderText="Email" />

                <asp:BoundField DataField="Mobile" HeaderText="Mobile" />

                <asp:BoundField DataField="Address" HeaderText="Address" />

    
                <asp:TemplateField HeaderText="Edit">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server"
                            Text="Edit"
                            CommandName="Edit"
                            CssClass="btn-edit" />
                    </ItemTemplate>

                    <EditItemTemplate>
                        <asp:LinkButton ID="btnUpdate" runat="server"
                            Text="Save"
                            CommandName="Update"
                            CssClass="btn-save" />

                        <asp:LinkButton ID="btnCancel" runat="server"
                            Text="Cancel"
                            CommandName="Cancel"
                            CssClass="btn-cancel" />
                    </EditItemTemplate>
                </asp:TemplateField>

   
                <asp:TemplateField HeaderText="Delete">
                    <ItemTemplate>
                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CommandName="Delete"
                            CssClass="btn-delete"
                            OnClientClick="return confirm('Are you sure you want to delete this user?');" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
</div>

</asp:Content>
