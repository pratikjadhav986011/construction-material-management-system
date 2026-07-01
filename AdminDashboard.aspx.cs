using MySql.Data.MySqlClient;
using System;

namespace ConstructionMaterialsManagement
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null)
                Response.Redirect("AdminLogin.aspx");

            if (!IsPostBack)
                LoadDashboardCounts();
        }

        private void LoadDashboardCounts()
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                lblUsers.Text = new MySqlCommand("SELECT COUNT(*) FROM Users", con).ExecuteScalar().ToString();
                lblProducts.Text = new MySqlCommand("SELECT COUNT(*) FROM Products", con).ExecuteScalar().ToString();
                lblOrders.Text = new MySqlCommand("SELECT COUNT(*) FROM Orders", con).ExecuteScalar().ToString();
            }
        }
    }
}
