using System;
using MySql.Data.MySqlClient;
using System.Configuration;

namespace ConstructionMaterialsManagement
{
    public partial class DBTest : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string conStr = ConfigurationManager.ConnectionStrings["MyConnection"].ConnectionString;

            using (MySqlConnection con = new MySqlConnection(conStr))
            {
                try
                {
                    con.Open();

                    // ===== ADD THESE TWO LINES HERE =====
                    string path = Request.QueryString["path"];
                    string text = System.IO.File.ReadAllText(path);
                    // ====================================

                    Response.Write("<h3 style='color:green;'>✅ Database Connection Successful!</h3>");
                }
                catch (Exception ex)
                {
                    Response.Write("<h3 style='color:red;'>❌ Connection Failed: " + ex.Message + "</h3>");
                }
            }
        }
    }
}