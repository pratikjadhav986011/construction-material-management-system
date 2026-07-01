using System;
using System.Web;

namespace ConstructionMaterialsManagement
{
    public partial class AdminMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // CLEAR SESSION COMPLETELY
            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();

            // CLEAR AUTH COOKIE (if exists)
            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                HttpCookie authCookie = new HttpCookie(".ASPXAUTH");
                authCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(authCookie);
            }

            // CLEAR SESSION COOKIE
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId");
                sessionCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(sessionCookie);
            }

            // REDIRECT TO HOME PAGE
            Response.Redirect("~/Home.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
