using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;


namespace ConstructionMaterialsManagement
{
    public partial class Checkout : System.Web.UI.Page
    {
        string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["userId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                if (Session["BuyNowProduct"] != null)
                    LoadBuyNowProduct();
                else
                    LoadCartProducts();

                CalculateTotals();
            }
        }

        private void LoadBuyNowProduct()
        {
            int productId = Convert.ToInt32(Session["BuyNowProduct"]);

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string query = "SELECT ProductID, ProductName, ImageUrl, Price, 1 AS Quantity FROM products WHERE ProductID=@id";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@id", productId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCheckout.DataSource = dt;
                rptCheckout.DataBind();

                Session["BuyNowTable"] = dt;
                lblEmpty.Visible = (dt.Rows.Count == 0);
            }
        }

        private void LoadCartProducts()
        {
            int userId = Convert.ToInt32(Session["userId"]);

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string query = @"
                    SELECT 
                        c.ProductID,
                        p.ProductName,
                        p.ImageUrl,
                        p.Price,
                        c.Quantity
                    FROM cart c
                    INNER JOIN products p ON c.ProductID = p.ProductID
                    WHERE c.UserID = @u";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@u", userId);

                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCheckout.DataSource = dt;
                rptCheckout.DataBind();

                lblEmpty.Visible = (dt.Rows.Count == 0);
            }
        }

        protected void rptCheckout_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);
            int userId = Convert.ToInt32(Session["userId"]);

            // BUY-NOW MODE
            if (Session["BuyNowProduct"] != null)
            {
                DataTable dt = (DataTable)Session["BuyNowTable"];

                if (e.CommandName == "qtyPlus")
                    dt.Rows[0]["Quantity"] = Convert.ToInt32(dt.Rows[0]["Quantity"]) + 1;

                else if (e.CommandName == "qtyMinus")
                {
                    int q = Convert.ToInt32(dt.Rows[0]["Quantity"]);
                    if (q > 1) dt.Rows[0]["Quantity"] = q - 1;
                }

                else if (e.CommandName == "remove")
                {
                    Session.Remove("BuyNowProduct");
                    Session.Remove("BuyNowTable");
                    Response.Redirect("Home.aspx");
                    return;
                }

                rptCheckout.DataSource = dt;
                rptCheckout.DataBind();
                CalculateTotals();
                return;
            }

            // CART MODE
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                if (e.CommandName == "qtyPlus")
                {
                    string q = "UPDATE cart SET Quantity = Quantity + 1 WHERE UserID=@u AND ProductID=@p";
                    MySqlCommand cmd = new MySqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@u", userId);
                    cmd.Parameters.AddWithValue("@p", productId);
                    cmd.ExecuteNonQuery();
                }

                else if (e.CommandName == "qtyMinus")
                {
                    string q = "UPDATE cart SET Quantity = Quantity - 1 WHERE UserID=@u AND ProductID=@p AND Quantity > 1";
                    MySqlCommand cmd = new MySqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@u", userId);
                    cmd.Parameters.AddWithValue("@p", productId);
                    cmd.ExecuteNonQuery();
                }

                else if (e.CommandName == "remove")
                {
                    string q = "DELETE FROM cart WHERE UserID=@u AND ProductID=@p";
                    MySqlCommand cmd = new MySqlCommand(q, con);
                    cmd.Parameters.AddWithValue("@u", userId);
                    cmd.Parameters.AddWithValue("@p", productId);
                    cmd.ExecuteNonQuery();
                }
            }

            LoadCartProducts();
            CalculateTotals();
        }
        protected void txtQty_TextChanged(object sender, EventArgs e)
        {
            TextBox txt = (TextBox)sender;
            RepeaterItem item = (RepeaterItem)txt.NamingContainer;

            HiddenField hfPrice = (HiddenField)item.FindControl("hfPrice");
            HiddenField hfProductID = (HiddenField)item.FindControl("hfProductID");

            int productId = Convert.ToInt32(hfProductID.Value);
            int userId = Convert.ToInt32(Session["userId"]);

            // Validate quantity
            int qty;
            if (!int.TryParse(txt.Text, out qty) || qty <= 0)
            {
                qty = 1;
                txt.Text = "1";
            }

            // BUY NOW MODE
            if (Session["BuyNowProduct"] != null)
            {
                DataTable dt = (DataTable)Session["BuyNowTable"];
                dt.Rows[0]["Quantity"] = qty;

                rptCheckout.DataSource = dt;
                rptCheckout.DataBind();
                CalculateTotals();
                return;
            }

            // CART MODE
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string update = "UPDATE cart SET Quantity=@q WHERE UserID=@u AND ProductID=@p";
                MySqlCommand cmd = new MySqlCommand(update, con);
                cmd.Parameters.AddWithValue("@q", qty);
                cmd.Parameters.AddWithValue("@u", userId);
                cmd.Parameters.AddWithValue("@p", productId);
                cmd.ExecuteNonQuery();
            }

            LoadCartProducts();
            CalculateTotals();
        }



        private void CalculateTotals()
        {
            decimal subtotal = 0;

            foreach (RepeaterItem item in rptCheckout.Items)
            {
                HiddenField hfPrice = item.FindControl("hfPrice") as HiddenField;
                TextBox txtQty = item.FindControl("txtQty") as TextBox;

                if (hfPrice == null || txtQty == null) continue;

                decimal price = 0;
                decimal.TryParse(hfPrice.Value, out price);

                int qty = 0;
                int.TryParse(txtQty.Text, out qty);

                subtotal += price * qty;
            }

            decimal delivery = subtotal > 500 ? 0 : 40;
            decimal total = subtotal + delivery;

            lblSubtotal.Text = subtotal.ToString("0.00");
            lblDelivery.Text = delivery.ToString("0.00");
            lblTotal.Text = total.ToString("0.00");

            Session["CheckoutSubtotal"] = subtotal;
            Session["CheckoutDelivery"] = delivery;
            Session["CheckoutTotal"] = total;
        }

        protected void btnPlaceOrder_Click(object sender, EventArgs e)
        {
            if (rptCheckout.Items.Count == 0)
                return;

            Response.Redirect("Payment.aspx");
        }
    }
}
