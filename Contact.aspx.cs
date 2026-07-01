using MySql.Data.MySqlClient;
using System;

namespace ConstructionMaterialsManagement
{
    public partial class Contact : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            // If not logged in → redirect to login
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["userId"]);

            // 1️⃣ CHECK USER EXISTS IN DATABASE
            if (!UserExists(userId))
            {
                lblMsg.Visible = true;
                lblMsg.CssClass = "text-danger fw-bold";
                lblMsg.Text = "User does not exist in database!";
                return;
            }

            // 2️⃣ SAVE MESSAGE
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string q = @"INSERT INTO ContactMessages (Name, Email, Message, CreatedAt)
                             VALUES (@n, @e, @m, NOW())";

                MySqlCommand cmd = new MySqlCommand(q, con);

                cmd.Parameters.AddWithValue("@n", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@e", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@m", txtMessage.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            // 3️⃣ SUCCESS MESSAGE
            lblMsg.Visible = true;
            lblMsg.CssClass = "text-success fw-bold";
            lblMsg.Text = "Your message has been sent successfully!";

            txtName.Text = "";
            txtEmail.Text = "";
            txtMessage.Text = "";
        }

        // 4️⃣ FUNCTION — CHECK USER EXISTENCE
        private bool UserExists(int userId)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string q = "SELECT COUNT(*) FROM Users WHERE UserID = @id";
                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@id", userId);

                int count = Convert.ToInt32(cmd.ExecuteScalar());

                return count > 0;
            }
        }
    }
}
