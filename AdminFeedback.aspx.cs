using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace ConstructionMaterialsManagement
{
    public partial class AdminFeedback : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminUser"] == null)
            {
                Response.Redirect("AdminLogin.aspx");
            }

            if (!IsPostBack)
            {
                LoadFeedback();
            }
        }

        private void LoadFeedback()
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = @"
                    SELECT FeedbackID, UserID, Name, Email, Message, SubmittedOn
                    FROM Feedback
                    ORDER BY FeedbackID DESC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    rptFeedback.DataSource = dt;
                    rptFeedback.DataBind();
                    lblMsg.Text = "";
                }
                else
                {
                    lblMsg.Text = "No feedback found!";
                }
            }
        }

        protected void rptFeedback_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                int id = Convert.ToInt32(e.CommandArgument);

                using (MySqlConnection con = new MySqlConnection(conn))
                {
                    con.Open();
                    string q = "DELETE FROM Feedback WHERE FeedbackID=@id";

                    MySqlCommand cmd = new MySqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@id", id);
                    cmd.ExecuteNonQuery();
                }

                LoadFeedback();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("AdminLogin.aspx");
        }
    }
}
