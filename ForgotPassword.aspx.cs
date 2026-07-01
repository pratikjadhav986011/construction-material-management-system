using MySql.Data.MySqlClient;
using System;
using System.Net;
using System.Net.Mail;
using System.IO;

namespace ConstructionMaterialsManagement
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                otpDiv.Visible = false;
            }
        }

        // ========================= SEND OTP =========================
        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(email))
            {
                ShowAlert("Enter your registered email!");
                return;
            }

            if (!UserEmailExists(email))
            {
                ShowAlert("Email is not registered!");
                return;
            }

            // Generate OTP
            Random rnd = new Random();
            string otp = rnd.Next(100000, 999999).ToString();

            Session["ForgotEmail"] = email;
            Session["ForgotOTP"] = otp;

            bool sent = SendEmailOTP(email, otp);

            if (sent)
            {
                ShowAlert("OTP sent to your email!");

                emailDiv.Visible = false;
                otpDiv.Visible = true;

                StartTimer();
            }
            else
            {
                ShowAlert("Failed to send OTP. Try again.");
            }
        }

        // ========================= RESEND OTP =========================
        protected void btnResendOTP_Click(object sender, EventArgs e)
        {
            string email = Session["ForgotEmail"]?.ToString();

            if (email == null)
            {
                ShowAlert("Session expired. Try again.");
                Response.Redirect("ForgotPassword.aspx");
                return;
            }

            Random rnd = new Random();
            string newOtp = rnd.Next(100000, 999999).ToString();

            Session["ForgotOTP"] = newOtp;

            bool sent = SendEmailOTP(email, newOtp);

            if (sent)
            {
                ShowAlert("OTP resent successfully!");
                StartTimer();
            }
            else
            {
                ShowAlert("Failed to resend OTP");
            }
        }

        // ========================= VERIFY OTP =========================
        protected void btnVerifyOTP_Click(object sender, EventArgs e)
        {
            string enteredOtp = txtOTP.Text.Trim();
            string correctOtp = Session["ForgotOTP"]?.ToString();

            if (enteredOtp == correctOtp)
            {
                ShowAlert("OTP Verified!");
                Response.Redirect("ResetPassword.aspx");
            }
            else
            {
                ShowAlert("Invalid OTP!");
            }
        }

        // ========================= CHECK IF EMAIL EXISTS =========================
        private bool UserEmailExists(string email)
        {
            string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = "SELECT COUNT(*) FROM Users WHERE Email=@Email";
                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        // ========================= SEND OTP THROUGH EMAIL =========================
        private bool SendEmailOTP(string email, string otp)
        {
            try
            {
                string senderEmail = "pratikjadhav986011@gmail.com";
                string appPassword = "nrnbfshjlzvrkkfv"; // remove spaces

                MailMessage msg = new MailMessage();
                msg.From = new MailAddress(senderEmail, "Construction Materials Management");
                msg.To.Add(email);

                msg.Subject = "🔐 Password Reset OTP - Construction Materials Management";

                msg.IsBodyHtml = true;

                msg.Body = $@"
        <div style='font-family: Arial, sans-serif; padding:20px; background-color:#f4f4f4'>
            <div style='max-width:600px; margin:auto; background:white; padding:30px; border-radius:8px;'>

                <h2 style='color:#2c3e50;'>Construction Materials Management</h2>
                <hr style='border:1px solid #eee;' />

                <p>Dear Customer,</p>

                <p>We received a request to reset your account password.</p>

                <p>Please use the following One-Time Password (OTP) to proceed:</p>

                <div style='text-align:center; margin:30px 0;'>
                    <span style='font-size:28px; letter-spacing:5px; font-weight:bold; color:#e74c3c;'>
                        {otp}
                    </span>
                </div>

                <p><strong>This OTP is valid for 5 minutes.</strong></p>

                <p>If you did not request a password reset, please ignore this email or contact our support team immediately.</p>

                <br/>

                <p>Regards,<br/>
                <strong>Construction Materials Management Team</strong><br/>
                📧 support@constructionmaterials.com<br/>
                📞 +91 98765 43210</p>

                <hr style='border:1px solid #eee;' />
                <p style='font-size:12px; color:gray; text-align:center;'>
                    This is an automated message. Please do not reply directly to this email.
                </p>

            </div>
        </div>";

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(senderEmail, appPassword);
                smtp.DeliveryMethod = SmtpDeliveryMethod.Network;

                smtp.Send(msg);
                return true;
            }
            catch (Exception ex)
            {
                ShowAlert("Email sending error: " + ex.Message);
                return false;
            }
        }




        // ========================= TIMER TEXT =========================
        private void StartTimer()
        {
            timerText.InnerText = "OTP valid for 30 seconds";
        }

        // ========================= ALERT FUNCTION =========================
        private void ShowAlert(string message)
        {
            Response.Write("<script>alert('" + message.Replace("'", "\\'") + "');</script>");
        }
    }
}
