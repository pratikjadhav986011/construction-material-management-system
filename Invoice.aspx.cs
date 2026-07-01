using System;
using System.Data;
using System.IO;
using MySql.Data.MySqlClient;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace ConstructionMaterialsManagement
{
    public partial class Invoice : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int orderId = 0;
                if (!int.TryParse(Request.QueryString["orderId"], out orderId) || orderId == 0)
                {
                    Response.Write("Invalid order id");
                    return;
                }

                DataTable order = GetData($@"SELECT o.OrderID,o.TotalAmount,o.OrderDate,o.Status,u.FullName,u.Email,u.Mobile,u.Address
                                            FROM Orders o
                                            JOIN Users u ON o.UserID = u.UserID
                                            WHERE o.OrderID = {orderId}");

                DataTable items = GetData($@"SELECT oi.ProductID,p.ProductName,oi.Quantity,oi.Price
                                            FROM OrderItems oi
                                            JOIN Products p ON oi.ProductID = p.ProductID
                                            WHERE oi.OrderID = {orderId}");

                if (order.Rows.Count == 0)
                {
                    Response.Write("Order not found");
                    return;
                }

                GenerateInvoicePDF(order.Rows[0], items);
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

        private void GenerateInvoicePDF(DataRow order, DataTable items)
        {
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", "attachment;filename=Invoice_" + order["OrderID"] + ".pdf");

            Document pdf = new Document(PageSize.A4, 36, 36, 54, 54);
            PdfWriter.GetInstance(pdf, Response.OutputStream);
            pdf.Open();

            // Fonts
            var titleFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 16, BaseColor.BLACK);
            var headerFont = FontFactory.GetFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.BLACK);
            var normal = FontFactory.GetFont(FontFactory.HELVETICA, 10, BaseColor.BLACK);
            var small = FontFactory.GetFont(FontFactory.HELVETICA, 9, BaseColor.GRAY);

            // Header: logo + company info
            PdfPTable header = new PdfPTable(2);
            header.WidthPercentage = 100;
            header.SetWidths(new float[] { 40f, 60f });

            // Left: logo
            PdfPCell logoCell = new PdfPCell() { Border = Rectangle.NO_BORDER };
            try
            {
                string logoPath = Server.MapPath("~/images/logo.png");
                if (File.Exists(logoPath))
                {
                    iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(logoPath);
                    logo.ScaleToFit(120f, 60f);
                    logo.Alignment = Element.ALIGN_LEFT;
                    logoCell.AddElement(logo);
                }
                else
                {
                    // If no logo, show company short title
                    logoCell.AddElement(new Phrase("Construction Shop", headerFont));
                }
            }
            catch
            {
                logoCell.AddElement(new Phrase("Construction Shop", headerFont));
            }

            // Right: company details and invoice title
            PdfPCell compCell = new PdfPCell();
            compCell.Border = Rectangle.NO_BORDER;
            compCell.AddElement(new Phrase("Construction Shop", headerFont));
            compCell.AddElement(new Phrase("123 Builder Lane, City, Country", normal));
            compCell.AddElement(new Phrase("Email: info@constructionshop.example", normal));
            compCell.AddElement(new Phrase("Phone: +91-9876543210", normal));
            compCell.AddElement(new Phrase("\n"));
            // Invoice title box
            PdfPTable invBox = new PdfPTable(1);
            invBox.WidthPercentage = 100;
            PdfPCell invCell = new PdfPCell(new Phrase("INVOICE", titleFont));
            invCell.BackgroundColor = new BaseColor(230, 230, 250);
            invCell.HorizontalAlignment = Element.ALIGN_CENTER;
            invCell.Padding = 6;
            invCell.Border = Rectangle.NO_BORDER;
            invBox.AddCell(invCell);
            compCell.AddElement(invBox);

            header.AddCell(logoCell);
            header.AddCell(compCell);

            pdf.Add(header);
            pdf.Add(new Paragraph("\n"));

            // Customer and order info
            PdfPTable info = new PdfPTable(2);
            info.WidthPercentage = 100;
            info.SetWidths(new float[] { 60f, 40f });

            PdfPTable left = new PdfPTable(1);
            left.AddCell(new PdfPCell(new Phrase("Bill To:", headerFont)) { Border = Rectangle.NO_BORDER });
            left.AddCell(new PdfPCell(new Phrase(order["FullName"].ToString(), normal)) { Border = Rectangle.NO_BORDER });
            left.AddCell(new PdfPCell(new Phrase(order["Email"].ToString(), normal)) { Border = Rectangle.NO_BORDER });
            left.AddCell(new PdfPCell(new Phrase(order["Mobile"].ToString(), normal)) { Border = Rectangle.NO_BORDER });
            left.AddCell(new PdfPCell(new Phrase(order["Address"].ToString(), normal)) { Border = Rectangle.NO_BORDER });

            PdfPTable right = new PdfPTable(1);
            right.AddCell(new PdfPCell(new Phrase("Invoice # " + order["OrderID"].ToString(), headerFont)) { Border = Rectangle.NO_BORDER });
            right.AddCell(new PdfPCell(new Phrase("Date: " + Convert.ToDateTime(order["OrderDate"]).ToString("yyyy-MM-dd"), normal)) { Border = Rectangle.NO_BORDER });
            right.AddCell(new PdfPCell(new Phrase("Status: " + order["Status"].ToString(), normal)) { Border = Rectangle.NO_BORDER });

            info.AddCell(new PdfPCell(left) { Border = Rectangle.NO_BORDER });
            info.AddCell(new PdfPCell(right) { Border = Rectangle.NO_BORDER });

            pdf.Add(info);
            pdf.Add(new Paragraph("\n"));

            // Items Table with styled header
            PdfPTable table = new PdfPTable(4);
            table.WidthPercentage = 100;
            table.SetWidths(new float[] { 8f, 52f, 10f, 30f });

            BaseColor headerBg = new BaseColor(245, 245, 255);
            PdfPCell h1 = new PdfPCell(new Phrase("#", headerFont)) { BackgroundColor = headerBg, HorizontalAlignment = Element.ALIGN_CENTER };
            PdfPCell h2 = new PdfPCell(new Phrase("Product", headerFont)) { BackgroundColor = headerBg, HorizontalAlignment = Element.ALIGN_LEFT };
            PdfPCell h3 = new PdfPCell(new Phrase("Qty", headerFont)) { BackgroundColor = headerBg, HorizontalAlignment = Element.ALIGN_CENTER };
            PdfPCell h4 = new PdfPCell(new Phrase("Amount (?)", headerFont)) { BackgroundColor = headerBg, HorizontalAlignment = Element.ALIGN_RIGHT };

            table.AddCell(h1);
            table.AddCell(h2);
            table.AddCell(h3);
            table.AddCell(h4);

            int i = 1;
            decimal subtotal = 0;
            foreach (DataRow r in items.Rows)
            {
                int qty = Convert.ToInt32(r["Quantity"]);
                decimal price = Convert.ToDecimal(r["Price"]);
                decimal amount = qty * price;
                subtotal += amount;

                PdfPCell c1 = new PdfPCell(new Phrase(i.ToString(), normal));
                c1.HorizontalAlignment = Element.ALIGN_CENTER;
                PdfPCell c2 = new PdfPCell(new Phrase(r["ProductName"].ToString(), normal));
                c2.HorizontalAlignment = Element.ALIGN_LEFT;
                PdfPCell c3 = new PdfPCell(new Phrase(qty.ToString(), normal));
                c3.HorizontalAlignment = Element.ALIGN_CENTER;
                PdfPCell c4 = new PdfPCell(new Phrase(amount.ToString("0.00"), normal));
                c4.HorizontalAlignment = Element.ALIGN_RIGHT;

                table.AddCell(c1);
                table.AddCell(c2);
                table.AddCell(c3);
                table.AddCell(c4);
                i++;
            }

            pdf.Add(table);
            pdf.Add(new Paragraph("\n"));

            // Totals box
            PdfPTable totals = new PdfPTable(2);
            totals.WidthPercentage = 40;
            totals.HorizontalAlignment = Element.ALIGN_RIGHT;
            totals.SetWidths(new float[] { 50f, 50f });

            PdfPCell lblSubtotal = new PdfPCell(new Phrase("Subtotal", normal)) { Border = Rectangle.NO_BORDER };
            PdfPCell valSubtotal = new PdfPCell(new Phrase(subtotal.ToString("0.00"), normal)) { Border = Rectangle.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT };

            decimal delivery = Convert.ToDecimal(order["TotalAmount"]) - subtotal;
            if (delivery < 0) delivery = 0;

            PdfPCell lblDelivery = new PdfPCell(new Phrase("Delivery", normal)) { Border = Rectangle.NO_BORDER };
            PdfPCell valDelivery = new PdfPCell(new Phrase(delivery.ToString("0.00"), normal)) { Border = Rectangle.NO_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT };

            PdfPCell lblTotal = new PdfPCell(new Phrase("Total", headerFont)) { Border = Rectangle.TOP_BORDER, PaddingTop = 6 };
            PdfPCell valTotal = new PdfPCell(new Phrase(Convert.ToDecimal(order["TotalAmount"]).ToString("0.00"), headerFont)) { Border = Rectangle.TOP_BORDER, HorizontalAlignment = Element.ALIGN_RIGHT, PaddingTop = 6 };

            totals.AddCell(lblSubtotal);
            totals.AddCell(valSubtotal);
            totals.AddCell(lblDelivery);
            totals.AddCell(valDelivery);
            totals.AddCell(lblTotal);
            totals.AddCell(valTotal);

            pdf.Add(totals);
            pdf.Add(new Paragraph("\n"));

            // Footer note
            Paragraph footer = new Paragraph("Thank you for your business! If you have any questions about this invoice, please contact us.", small);
            footer.Alignment = Element.ALIGN_CENTER;
            pdf.Add(footer);

            pdf.Close();
            Response.End();
        }
    }
}