<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminFeedback.aspx.cs"
    Inherits="ConstructionMaterialsManagement.AdminFeedback"
    MasterPageFile="~/AdminMaster.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MasterPageTitle" runat="server">
    User Feedback
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<!-- MAIN CONTENT BOX -->
<div class="table-card">

    <h4 class="mb-3 fw-bold">User Feedback</h4>

    <asp:Label ID="lblMsg" runat="server" CssClass="text-danger fw-bold"></asp:Label>

    <div class="table-responsive">
        <table class="table table-hover table-striped align-middle">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>UserID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Message</th>
                    <th>Submitted On</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <asp:Repeater ID="rptFeedback" runat="server" OnItemCommand="rptFeedback_ItemCommand">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("FeedbackID") %></td>
                            <td><%# Eval("UserID") %></td>
                            <td><%# Eval("Name") %></td>
                            <td><%# Eval("Email") %></td>
                            <td><%# Eval("Message") %></td>
                            <td><%# Eval("SubmittedOn") %></td>

                            <td>
                                <asp:LinkButton ID="btnDelete" runat="server"
                                    CssClass="btn btn-danger btn-sm"
                                    CommandName="delete"
                                    CommandArgument='<%# Eval("FeedbackID") %>'>
                                    <i class="fas fa-trash"></i>
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </tbody>

        </table>
    </div>
</div>

</asp:Content>
