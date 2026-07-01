using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web.UI;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace ConstructionMaterialsManagement
{
    public partial class ManageProducts : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            // IMPORTANT: ensure <form> supports file upload when using master page
            this.Form.Enctype = "multipart/form-data";

            if (!IsPostBack)
            {
                LoadCategories();
                LoadProducts();
                LoadStats();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("AdminLogin.aspx");
        }

        private void LoadStats()
        {
            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                lblTotalProducts.Text = new MySqlCommand("SELECT COUNT(*) FROM Products", con).ExecuteScalar().ToString();
                lblTotalCategories.Text = new MySqlCommand("SELECT COUNT(*) FROM Categories", con).ExecuteScalar().ToString();
            }
        }

        private void LoadCategories()
        {
            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                MySqlDataAdapter da = new MySqlDataAdapter("SELECT * FROM Categories", con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCategory.DataSource = dt;
                ddlCategory.DataTextField = "CategoryName";
                ddlCategory.DataValueField = "CategoryID";
                ddlCategory.DataBind();
            }
        }

        private void LoadProducts()
        {
            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                string query = @"SELECT p.ProductID, p.ProductName, p.Price, p.Stock, p.ImageUrl, 
                                 c.CategoryName
                                 FROM Products p
                                 LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                                 ORDER BY p.ProductID DESC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        protected void gvProducts_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            int rowIndex = Convert.ToInt32(e.CommandArgument);
            int id = Convert.ToInt32(gvProducts.DataKeys[rowIndex].Value);

            if (e.CommandName == "editProduct")
            {
                LoadProductForEdit(id);

                // Show Bootstrap 5 modal after postback
                string script = @"
                    setTimeout(function() {
                        var m = document.getElementById('productModal');
                        if (m) {
                            var modal = bootstrap.Modal.getOrCreateInstance(m);
                            modal.show();
                        }
                    }, 100);";

                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", script, true);
            }
            else if (e.CommandName == "deleteProduct")
            {
                DeleteProduct(id);
                LoadProducts();
                LoadStats();
            }
        }

        private void LoadProductForEdit(int id)
        {
            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                var cmd = new MySqlCommand("SELECT * FROM Products WHERE ProductID=@id", con);
                cmd.Parameters.AddWithValue("@id", id);

                var dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    hfProductID.Value = dr["ProductID"].ToString();
                    txtProductName.Text = dr["ProductName"].ToString();
                    txtPrice.Text = dr["Price"].ToString();
                    txtStock.Text = dr["Stock"].ToString();
                    ddlCategory.SelectedValue = dr["CategoryID"].ToString();
                    txtDescription.Text = dr["Description"].ToString();

                    ViewState["OldImage"] = dr["ImageUrl"].ToString();
                }
            }
        }

        private void DeleteProduct(int id)
        {
            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                var cmd = new MySqlCommand("DELETE FROM Products WHERE ProductID=@id", con);
                cmd.Parameters.AddWithValue("@id", id);
                cmd.ExecuteNonQuery();
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string name = txtProductName.Text.Trim();
            decimal price = Convert.ToDecimal(txtPrice.Text);
            int stock = Convert.ToInt32(txtStock.Text);
            int category = Convert.ToInt32(ddlCategory.SelectedValue);
            string desc = txtDescription.Text.Trim();

            string imageUrl = "";

            if (fileImage.HasFile)
            {
                string folder = Server.MapPath("~/uploads/products/");
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string file = DateTime.Now.Ticks + "_" + Path.GetFileName(fileImage.FileName);
                fileImage.SaveAs(Path.Combine(folder, file));

                imageUrl = "/uploads/products/" + file;
            }
            else
            {
                imageUrl = ViewState["OldImage"]?.ToString() ?? "";
            }

            using (var con = new MySqlConnection(conn))
            {
                con.Open();
                MySqlCommand cmd;

                if (hfProductID.Value == "") // INSERT
                {
                    cmd = new MySqlCommand(@"
                        INSERT INTO Products(ProductName, Price, Stock, CategoryID, ImageUrl, Description)
                        VALUES(@n,@p,@s,@c,@img,@d)", con);
                }
                else // UPDATE
                {
                    cmd = new MySqlCommand(@"
                        UPDATE Products SET 
                            ProductName=@n,
                            Price=@p,
                            Stock=@s,
                            CategoryID=@c,
                            ImageUrl=@img,
                            Description=@d
                        WHERE ProductID=@id", con);

                    cmd.Parameters.AddWithValue("@id", hfProductID.Value);
                }

                cmd.Parameters.AddWithValue("@n", name);
                cmd.Parameters.AddWithValue("@p", price);
                cmd.Parameters.AddWithValue("@s", stock);
                cmd.Parameters.AddWithValue("@c", category);
                cmd.Parameters.AddWithValue("@img", imageUrl);
                cmd.Parameters.AddWithValue("@d", desc);

                cmd.ExecuteNonQuery();
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "ok",
                "alert('Saved Successfully'); window.location='ManageProducts.aspx';", true);
        }

        protected void btnDownloadCrystal_Click(object sender, EventArgs e)
        {
            try
            {
                string rptPath = Server.MapPath("~/Reports/ProductsReport.rpt");
                string xsdPath = Server.MapPath("~/Reports/ProductsReport.xsd");

                string q = @"SELECT p.ProductID, p.ProductName, c.CategoryName, p.Price, p.Stock, p.ImageUrl, p.Description
                             FROM Products p
                             LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
                             ORDER BY p.ProductID DESC";

                DataTable dt = GetData(q);

                if (!File.Exists(rptPath))
                {
                    // create xsd to help design report
                    if (!File.Exists(xsdPath))
                    {
                        DataSet ds = new DataSet("ProductsDS");
                        dt.TableName = "Products";
                        ds.Tables.Add(dt.Copy());
                        ds.WriteXmlSchema(xsdPath);
                    }

                    // fallback: generate simple PDF
                    GenerateProductsPdfFallback(dt);
                    return;
                }

                ReportDocument rd = new ReportDocument();
                rd.Load(rptPath);
                rd.SetDataSource(dt);

                using (var stream = rd.ExportToStream(ExportFormatType.PortableDocFormat))
                {
                    Response.Clear();
                    Response.Buffer = true;
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("Content-Disposition", "attachment; filename=Products_Report.pdf;");
                    stream.Seek(0, SeekOrigin.Begin);
                    stream.CopyTo(Response.OutputStream);
                    Response.Flush();
                    Response.End();
                }

                rd.Close();
                rd.Dispose();
            }
            catch (Exception ex)
            {
                lblMsg.Text = "<div class='msg msg-error'>Error generating product report: " + ex.Message + "</div>";
            }
        }

        private void GenerateProductsPdfFallback(DataTable dt)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=Products_Report_Fallback.pdf");

            Document pdf = new Document(PageSize.A4, 36, 36, 90, 60);
            PdfWriter writer = PdfWriter.GetInstance(pdf, Response.OutputStream);
            writer.PageEvent = new ProductsFooter();
            pdf.Open();

            var titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16);
            var headerFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 11);
            var normal = FontFactory.GetFont(FontFactory.HELVETICA, 10);

            // Header
            PdfPTable head = new PdfPTable(2) { WidthPercentage = 100 };
            head.SetWidths(new float[] { 25f, 75f });

            PdfPCell logoCell = new PdfPCell() { Border = Rectangle.NO_BORDER, Padding = 6 };
            try
            {
                string logoPath = Server.MapPath("~/images/logo.png");
                if (File.Exists(logoPath))
                {
                    iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(logoPath);
                    logo.ScaleToFit(140f, 80f);
                    logo.Alignment = Element.ALIGN_LEFT;
                    logoCell.AddElement(logo);
                }
            }
            catch { }

            PdfPTable comp = new PdfPTable(1);
            comp.DefaultCell.Border = Rectangle.NO_BORDER;
            comp.AddCell(new PdfPCell(new Phrase("Construction Shop Pvt. Ltd.", titleFont)) { Border = Rectangle.NO_BORDER, PaddingBottom = 6f });
            comp.AddCell(new PdfPCell(new Phrase("Products Report", headerFont)) { Border = Rectangle.NO_BORDER, PaddingBottom = 6f });
            comp.AddCell(new PdfPCell(new Phrase("Generated: " + DateTime.Now.ToString("yyyy-MM-dd HH:mm"), normal)) { Border = Rectangle.NO_BORDER });

            head.AddCell(logoCell);
            head.AddCell(new PdfPCell(comp) { Border = Rectangle.NO_BORDER, VerticalAlignment = Element.ALIGN_MIDDLE });

            pdf.Add(head);
            pdf.Add(Chunk.NEWLINE);

            // Table
            PdfPTable tbl = new PdfPTable(5) { WidthPercentage = 100 };
            tbl.SetWidths(new float[] { 8f, 40f, 20f, 12f, 20f });

            tbl.AddCell(new PdfPCell(new Phrase("ID", headerFont)) { BackgroundColor = new BaseColor(230, 230, 250), Padding = 6 });
            tbl.AddCell(new PdfPCell(new Phrase("Product", headerFont)) { BackgroundColor = new BaseColor(230, 230, 250), Padding = 6 });
            tbl.AddCell(new PdfPCell(new Phrase("Category", headerFont)) { BackgroundColor = new BaseColor(230, 230, 250), Padding = 6 });
            tbl.AddCell(new PdfPCell(new Phrase("Price", headerFont)) { BackgroundColor = new BaseColor(230, 230, 250), Padding = 6, HorizontalAlignment = Element.ALIGN_RIGHT });
            tbl.AddCell(new PdfPCell(new Phrase("Stock", headerFont)) { BackgroundColor = new BaseColor(230, 230, 250), Padding = 6, HorizontalAlignment = Element.ALIGN_CENTER });

            foreach (DataRow r in dt.Rows)
            {
                tbl.AddCell(new PdfPCell(new Phrase(r["ProductID"].ToString(), normal)) { Padding = 6 });
                tbl.AddCell(new PdfPCell(new Phrase(r["ProductName"].ToString(), normal)) { Padding = 6 });
                tbl.AddCell(new PdfPCell(new Phrase(r["CategoryName"].ToString(), normal)) { Padding = 6 });
                decimal p = 0; decimal.TryParse(r["Price"].ToString(), out p);
                tbl.AddCell(new PdfPCell(new Phrase(p.ToString("0.00"), normal)) { Padding = 6, HorizontalAlignment = Element.ALIGN_RIGHT });
                tbl.AddCell(new PdfPCell(new Phrase(r["Stock"].ToString(), normal)) { Padding = 6, HorizontalAlignment = Element.ALIGN_CENTER });
            }

            pdf.Add(tbl);
            pdf.Close();
            Response.End();
        }

        private class ProductsFooter : PdfPageEventHelper
        {
            Font fnt = FontFactory.GetFont(FontFactory.HELVETICA, 8, BaseColor.GRAY);
            public override void OnEndPage(PdfWriter writer, Document document)
            {
                PdfPTable tbl = new PdfPTable(1);
                tbl.TotalWidth = document.PageSize.Width - document.LeftMargin - document.RightMargin;
                PdfPCell cell = new PdfPCell(new Phrase("Construction Shop Pvt. Ltd. - Products Report | Page " + writer.PageNumber, fnt));
                cell.Border = Rectangle.NO_BORDER;
                cell.HorizontalAlignment = Element.ALIGN_RIGHT;
                cell.PaddingTop = 8f;
                tbl.AddCell(cell);
                tbl.WriteSelectedRows(0, -1, document.LeftMargin, document.BottomMargin - 5, writer.DirectContent);
            }
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
    }
}
