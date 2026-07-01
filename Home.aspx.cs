    using System;

    namespace ConstructionMaterialsManagement
    {
        public partial class Home : System.Web.UI.Page
        {
        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateLoginProfileVisibility();
        }


        private void UpdateLoginProfileVisibility()
            {
                // find master page controls
                var login = Master.FindControl("loginLink");
                var profile = Master.FindControl("profileLink");

                if (login == null || profile == null)
                    return;

                var loginLink = (System.Web.UI.HtmlControls.HtmlAnchor)login;
                var profileLink = (System.Web.UI.HtmlControls.HtmlAnchor)profile;

                if (Session["userId"] != null)
                {
                    loginLink.Visible = false;
                    profileLink.Visible = true;
                }
                else
                {
                    loginLink.Visible = true;
                    profileLink.Visible = false;
                }
            }
        }
    }