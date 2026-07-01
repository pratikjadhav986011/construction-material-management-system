using System;
using System.Data;
using MySql.Data.MySqlClient;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace ConstructionMaterialsManagement
{
    public partial class Reports : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadUsers();
        }

        private void LoadUsers(string search = "")
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string q = @"SELECT UserID, FullName, Email, Mobile, Address
             FROM Users
             WHERE FullName LIKE @s OR Email LIKE @s OR Mobile LIKE @s
             ORDER BY UserID DESC";


                MySqlDataAdapter da = new MySqlDataAdapter(q, con);
                da.SelectCommand.Parameters.AddWithValue("@s", "%" + search + "%");

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadUsers(txtSearch.Text.Trim());
        }

        // ==============================================
        //               PDF GENERATION
        // ==============================================
        private void GeneratePDF(string title, DataTable dt)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=" + title + ".pdf");

            Document pdf = new Document(PageSize.A4);
            PdfWriter.GetInstance(pdf, Response.OutputStream);

            pdf.Open();

            pdf.Add(new Paragraph(title + " REPORT"));
            pdf.Add(new Paragraph("Generated on: " + DateTime.Now));
            pdf.Add(new Paragraph("\n"));

            PdfPTable table = new PdfPTable(dt.Columns.Count);

            foreach (DataColumn col in dt.Columns)
                table.AddCell(new Phrase(col.ColumnName));

            foreach (DataRow row in dt.Rows)
                foreach (var cell in row.ItemArray)
                    table.AddCell(new Phrase(cell.ToString()));

            pdf.Add(table);
            pdf.Close();
            Response.End();
        }

        private DataTable GetData(string query)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                MySqlDataAdapter da = new MySqlDataAdapter(query, con);

                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }

        protected void btnUserReport_Click(object sender, EventArgs e)
        {
            GeneratePDF("Users", GetData("SELECT UserID, FullName, Email, Mobile, Address FROM Users"));
        }

        protected void btnProductReport_Click(object sender, EventArgs e)
        {
            GeneratePDF("Products", GetData("SELECT ProductID, ProductName, Price, Stock FROM Products"));
        }

        protected void btnOrderReport_Click(object sender, EventArgs e)
        {
            GeneratePDF("Orders", GetData("SELECT OrderID, UserID, TotalAmount, OrderDate, Status FROM Orders"));
        }

        protected void btnFeedbackReport_Click(object sender, EventArgs e)
        {
            string query = "SELECT FeedbackID, UserID, Name, Email, Message, SubmittedOn FROM Feedback ORDER BY FeedbackID DESC";
            GeneratePDF("Feedback_Report", GetData(query));
        }


        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("AdminLogin.aspx");
        }
    }
}
