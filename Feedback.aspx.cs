using MySql.Data.MySqlClient;
using System;

namespace ConstructionMaterialsManagement
{
    public partial class Feedback : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int userId = Convert.ToInt32(Session["userId"]);

                if (HasUserGivenFeedback(userId))
                {
                    feedbackForm.Visible = false;
                    lblMessage.Text = "You have already submitted feedback. Thank you!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    lblMessage.Visible = true;
                }
                else
                {
                    AutoFillUserData();
                }
            }
        }

        // ----------------------------------------------------------
        // AUTO-FILL USER DATA (FullName + Email)
        // ----------------------------------------------------------
        private void AutoFillUserData()
        {
            int userId = Convert.ToInt32(Session["userId"]);

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string q = "SELECT FullName, Email FROM Users WHERE UserID=@id";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@id", userId);

                MySqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtName.Text = dr["FullName"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                }
            }
        }

        // ----------------------------------------------------------
        // CHECK IF USER ALREADY GAVE FEEDBACK
        // ----------------------------------------------------------
        private bool HasUserGivenFeedback(int userId)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string q = "SELECT COUNT(*) FROM Feedback WHERE UserID=@u";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@u", userId);

                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        // ----------------------------------------------------------
        // SUBMIT FEEDBACK
        // ----------------------------------------------------------
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["userId"]);

            if (HasUserGivenFeedback(userId))
            {
                lblMessage.Text = "You already submitted feedback!";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Visible = true;
                return;
            }

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string q = @"INSERT INTO Feedback (UserID, Name, Email, Message, SubmittedOn)
                             VALUES (@uid, @name, @mail, @msg, NOW())";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@uid", userId);
                cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@mail", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@msg", txtMessage.Text.Trim());

                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "Thank you for your feedback!";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Visible = true;
            feedbackForm.Visible = false;
        }
    }
}
