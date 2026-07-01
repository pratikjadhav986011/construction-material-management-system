using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Data;

namespace ConstructionMaterialsManagement
{
    public partial class Site : System.Web.UI.MasterPage
    {
        readonly string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
                UpdateLoginProfileVisibility();
                LoadCartCount();   // 🔥 NEW — Load cart count badge

              

            }
        }

        // ================= LOGIN/PROFILE VISIBILITY ======================
        private void UpdateLoginProfileVisibility()
        {
            if (Session["userId"] != null)
            {
                loginLink.Visible = false;
                logoutLink.Visible = true;
            }
            else
            {
                loginLink.Visible = true;
                logoutLink.Visible = false;
            }
        }
        protected void LogoutLink_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();

            Response.Redirect("Home.aspx");
        }



        // ================== LOAD CART COUNT ======================
        private void LoadCartCount()
        {
            if (Session["userId"] == null)
            {
                lblCartCount.InnerText = "0";   // FIXED
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string q = "SELECT SUM(Quantity) FROM Cart WHERE UserID=@u";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@u", userId);

                object result = cmd.ExecuteScalar();
                lblCartCount.InnerText = (result == DBNull.Value || result == null) ? "0" : result.ToString();  // FIXED
            }
        }



     

        // ================== LOGIN REQUIRED HELPER ======================
        public void RequireLogin()
        {
            if (Session["userId"] == null)
            {
                Session["RedirectAfterLogin"] = Request.RawUrl;
                Response.Redirect("Login.aspx");
            }
        }

        // =============== 🔥 CART BUTTON CLICK EVENT ===================
        protected void BtnCart_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Session["RedirectAfterLogin"] = "Checkout.aspx";
                Response.Redirect("Login.aspx");
            }
            else
            {
                Response.Redirect("Checkout.aspx");
            }
        }
        protected void BtnSearch_Click(object sender, EventArgs e)
        {
            string keyword = txtSearch.Text.Trim();

            if (keyword == "")
            {
                Response.Redirect("Products.aspx");
            }
            else
            {
                Response.Redirect("Products.aspx?search=" + keyword);
            }
        }

    }
}
