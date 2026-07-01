    using MySql.Data.MySqlClient;
    using System;

    namespace ConstructionMaterialsManagement
    {
        public partial class PaymentPage : System.Web.UI.Page
        {
            MySqlConnection con = new MySqlConnection("server=localhost;user=root;password=12345;database=constructiondb");

            protected void Page_Load(object sender, EventArgs e)
            {
                if (!IsPostBack)
                {
                    int poid = Convert.ToInt32(Request.QueryString["poid"]);
                    LoadPOData(poid);
                }
            }

            private void LoadPOData(int poid)
            {
                con.Open();
                string q = @"SELECT PO.PO_ID, S.SupplierName, P.ProductName, PO.Quantity, PO.TotalAmount
                             FROM PurchaseOrders PO
                             JOIN Suppliers S ON PO.SupplierID = S.SupplierID
                             JOIN Products P ON PO.ProductID = P.ProductID
                             WHERE PO.PO_ID = @id";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@id", poid);

                MySqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblHeader.InnerText = "Payment for PO #" + poid;
                    lblSupplier.InnerText = dr["SupplierName"].ToString();
                    lblProduct.InnerText = dr["ProductName"].ToString();
                    lblQty.InnerText = dr["Quantity"].ToString();
                    lblTotal.InnerText = dr["TotalAmount"].ToString();
                }
                con.Close();
            }

            protected void rblPayment_SelectedIndexChanged(object sender, EventArgs e)
            {
                panelUPI.Visible = rblPayment.SelectedValue == "UPI";
                panelCard.Visible = rblPayment.SelectedValue == "Card";
                panelCash.Visible = rblPayment.SelectedValue == "Cash";
            }

            protected void btnConfirm_Click(object sender, EventArgs e)
            {
                string method = rblPayment.SelectedValue;
                string details = "";
                int poid = Convert.ToInt32(Request.QueryString["poid"]);

                if (method == "")
                {
                    Response.Write("<script>alert('Please select payment method');</script>");
                    return;
                }

                if (method == "UPI")
                {
                    details = "UPI Payment Completed";
                }
                else if (method == "Card")
                {
                    if (string.IsNullOrWhiteSpace(txtCardNumber.Text) ||
                        string.IsNullOrWhiteSpace(txtExpiry.Text) ||
                        string.IsNullOrWhiteSpace(txtCVV.Text))
                    {
                        Response.Write("<script>alert('Enter all card details');</script>");
                        return;
                    }

                    details = "Card: ****" + txtCardNumber.Text.Substring(txtCardNumber.Text.Length - 4);
                }
                else if (method == "Cash")
                {
                    details = "Cash on Delivery";
                }

                con.Open();

                // INSERT PAYMENT
                string insert = @"INSERT INTO Payments (PO_ID, PaymentMethod, PaymentDetails, PaymentDate)
                                  VALUES (@poid, @method, @details, NOW())";

                MySqlCommand cmd1 = new MySqlCommand(insert, con);
                cmd1.Parameters.AddWithValue("@poid", poid);
                cmd1.Parameters.AddWithValue("@method", method);
                cmd1.Parameters.AddWithValue("@details", details);
                cmd1.ExecuteNonQuery();

                // UPDATE ORDER STATUS
                string update = @"UPDATE PurchaseOrders SET Status='Paid' WHERE PO_ID=@id";
                MySqlCommand cmd2 = new MySqlCommand(update, con);
                cmd2.Parameters.AddWithValue("@id", poid);
                cmd2.ExecuteNonQuery();

                con.Close();

                Response.Write("<script>alert('Payment Successful');window.location='AdminPurchaseOrder.aspx';</script>");
            }
        }
    }
