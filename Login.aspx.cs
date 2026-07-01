using System;
using System.Configuration;
using System.Web;
using System.Web.SessionState;
using MySql.Data.MySqlClient;
using System.Security.Cryptography;

namespace ConstructionMaterialsManagement
{
    public partial class Login : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["MyDbConn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // If user is already logged in → go home
                if (Session["userId"] != null)
                    Response.Redirect("Home.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string pass = txtPassword.Text; // do not Trim password

            try
            {
                using (var con = new MySqlConnection(connStr))
                {
                    con.Open();

                    string query = "SELECT UserId, Password FROM Users WHERE Email='" + email + "'";
                    using (var cmd = new MySqlCommand(query, con))
                    {
                        using (var rdr = cmd.ExecuteReader())
                        {
                            if (rdr.Read())
                            {
                                int userId = Convert.ToInt32(rdr["UserId"]);
                                string stored = rdr["Password"]?.ToString();

                                // If stored appears to be a legacy PBKDF2 hash (format iterations:salt:hash)
                                if (!string.IsNullOrEmpty(stored) && stored.Contains(":"))
                                {
                                    bool ok = VerifyPbkdf2(pass, stored);
                                    if (ok)
                                    {
                                        // Migrate to plain text as requested: update DB to store plain password
                                        rdr.Close();
                                        using (var up = new MySqlCommand("UPDATE Users SET Password=@p WHERE UserId=@id", con))
                                        {
                                            up.Parameters.AddWithValue("@p", pass);
                                            up.Parameters.AddWithValue("@id", userId);
                                            up.ExecuteNonQuery();
                                        }

                                        // Log user in
                                        RegenerateSessionAndRedirect(userId);
                                        return;
                                    }
                                }
                                else if (!string.IsNullOrEmpty(stored) && stored == pass)
                                {
                                    // Plain-text match
                                    RegenerateSessionAndRedirect(userId);
                                    return;
                                }
                            }
                        }
                    }
                }

                ClientScript.RegisterStartupScript(GetType(), "invalid", "alert('Invalid Email or Password');", true);
            }
            catch (Exception ex)
            {
                // Development helper: show full exception to diagnose issues. Remove in production.
                string msg = Server.HtmlEncode(ex.Message + "\n" + ex.StackTrace);
                ClientScript.RegisterStartupScript(GetType(), "err", "alert('An unexpected error occurred: " + msg.Replace("'","\\'") + "');", true);
            }
        }

        private void RegenerateSessionAndRedirect(int userId)
        {
            Session.Clear();
            Session["userId"] = userId;
            Response.Redirect("Home.aspx", false);
        }


        private bool VerifyPbkdf2(string password, string storedHash)
        {
            try
            {
                var parts = storedHash.Split(':');
                if (parts.Length != 3) return false;

                int iterations = int.Parse(parts[0]);
                byte[] salt = Convert.FromBase64String(parts[1]);
                byte[] hash = Convert.FromBase64String(parts[2]);

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations))
                {
                    byte[] testHash = pbkdf2.GetBytes(hash.Length);
                    if (testHash.Length != hash.Length) return false;
                    // constant time comparison
                    int diff = 0;
                    for (int i = 0; i < hash.Length; i++) diff |= hash[i] ^ testHash[i];
                    return diff == 0;
                }
            }
            catch
            {
                return false;
            }
        }
    }
}
