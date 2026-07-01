using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

namespace ConstructionMaterialsManagement
{
    public partial class Products : System.Web.UI.Page
    {
        readonly string conn = "server=localhost;user=root;password=12345;database=constructiondb;SslMode=Preferred";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string search = Request.QueryString["search"];
                string categoryName = Request.QueryString["category"];
                string categoryId = Request.QueryString["cat"];

                // ============================ SEARCH ============================
                if (!string.IsNullOrEmpty(search))
                {
                    lblCategoryName.Text = "Search: " + search;
                    LoadSearchProducts(search);
                    return;
                }

                // ============================ CATEGORY BY NAME ==================
                if (!string.IsNullOrEmpty(categoryName))
                {
                    lblCategoryName.Text = categoryName;
                    LoadProductsByCategoryName(categoryName);
                    return;
                }

                // ============================ CATEGORY BY ID ====================
                if (!string.IsNullOrEmpty(categoryId))
                {
                    if (int.TryParse(categoryId, out int catID))
                    {
                        LoadCategoryNameById(catID);
                        LoadProductsByCategoryId(catID);
                    }
                    else
                    {
                        lblMessage.Text = "Invalid category selected.";
                        lblMessage.Visible = true;
                    }
                    return;
                }

                // ============================ DEFAULT (SHOW ALL) ================
                lblCategoryName.Text = "All Products";
                LoadAllProducts();
            }
        }

        // ======================= SEARCH PRODUCTS =============================
        private void LoadSearchProducts(string search)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                string q = @"
                    SELECT p.ProductID, p.ProductName, p.Price, p.Stock, p.ImageUrl
                    FROM Products p
                    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                    WHERE p.ProductName LIKE @s
                       OR c.CategoryName LIKE @s
                       OR p.Description LIKE @s";

                MySqlCommand cmd = new MySqlCommand(q, con);
                cmd.Parameters.AddWithValue("@s", "%" + search + "%");

                DataTable dt = new DataTable();
                new MySqlDataAdapter(cmd).Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    lblMessage.Text = "Product Not Available";
                    lblMessage.Visible = true;
                    rptProducts.DataSource = null;
                }
                else
                {
                    lblMessage.Visible = false;
                    rptProducts.DataSource = dt;
                }

                rptProducts.DataBind();
            }
        }

        // ======================= LOAD BY CATEGORY NAME =======================
        private void LoadProductsByCategoryName(string categoryName)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = @"
                    SELECT p.ProductID, p.ProductName, p.Price, p.Stock, p.ImageUrl
                    FROM Products p
                    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
                    WHERE c.CategoryName = @cat
                    ORDER BY p.ProductName ASC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@cat", categoryName);

                DataTable dt = new DataTable();
                da.Fill(dt);

                BindProducts(dt);
            }
        }

        // ======================= LOAD BY CATEGORY ID =========================
        private void LoadProductsByCategoryId(int catID)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = "SELECT * FROM Products WHERE CategoryID=@cat ORDER BY ProductName ASC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                da.SelectCommand.Parameters.AddWithValue("@cat", catID);

                DataTable dt = new DataTable();
                da.Fill(dt);

                BindProducts(dt);
            }
        }

        // ======================= LOAD CATEGORY NAME ==========================
        private void LoadCategoryNameById(int catID)
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = "SELECT CategoryName FROM Categories WHERE CategoryID=@id";

                MySqlCommand cmd = new MySqlCommand(query, con);
                cmd.Parameters.AddWithValue("@id", catID);

                object result = cmd.ExecuteScalar();
                lblCategoryName.Text = result != null ? result.ToString() : "Products";
            }
        }

        // ======================= LOAD ALL PRODUCTS ============================
        private void LoadAllProducts()
        {
            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();
                string query = "SELECT ProductID, ProductName, Price, Stock, ImageUrl FROM Products ORDER BY ProductName ASC";

                MySqlDataAdapter da = new MySqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                BindProducts(dt);
            }
        }

        // ======================= BIND COMMON METHOD ===========================
        private void BindProducts(DataTable dt)
        {
            rptProducts.DataSource = dt;
            rptProducts.DataBind();

            lblMessage.Visible = dt.Rows.Count == 0;
            if (dt.Rows.Count == 0)
                lblMessage.Text = "No products found.";
        }

        // ======================= ADD TO CART / BUY NOW =======================
        protected void RptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = Convert.ToInt32(e.CommandArgument);

            if (Session["userId"] == null)
            {
                Session["returnUrl"] = Request.RawUrl;
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["userId"]);

            using (MySqlConnection con = new MySqlConnection(conn))
            {
                con.Open();

                if (e.CommandName == "addToCart")
                {
                    string check = "SELECT Quantity FROM Cart WHERE UserID=@u AND ProductID=@p";
                    MySqlCommand cmd = new MySqlCommand(check, con);
                    cmd.Parameters.AddWithValue("@u", userId);
                    cmd.Parameters.AddWithValue("@p", productId);

                    object result = cmd.ExecuteScalar();

                    if (result == null)
                    {
                        string insert = "INSERT INTO Cart(UserID, ProductID, Quantity) VALUES(@u, @p, 1)";
                        MySqlCommand cmdInsert = new MySqlCommand(insert, con);
                        cmdInsert.Parameters.AddWithValue("@u", userId);
                        cmdInsert.Parameters.AddWithValue("@p", productId);
                        cmdInsert.ExecuteNonQuery();
                    }
                    else
                    {
                        string update = "UPDATE Cart SET Quantity = Quantity + 1 WHERE UserID=@u AND ProductID=@p";
                        MySqlCommand cmdUpdate = new MySqlCommand(update, con);
                        cmdUpdate.Parameters.AddWithValue("@u", userId);
                        cmdUpdate.Parameters.AddWithValue("@p", productId);
                        cmdUpdate.ExecuteNonQuery();
                    }

                    Response.Write("<script>alert('Product added to cart');</script>");
                }

                if (e.CommandName == "buyNow")
                {
                    string check = "SELECT Quantity FROM Cart WHERE UserID=@u AND ProductID=@p";
                    MySqlCommand cmdCheck = new MySqlCommand(check, con);
                    cmdCheck.Parameters.AddWithValue("@u", userId);
                    cmdCheck.Parameters.AddWithValue("@p", productId);

                    object result = cmdCheck.ExecuteScalar();

                    if (result == null)
                    {
                        string insert = "INSERT INTO Cart(UserID, ProductID, Quantity) VALUES(@u, @p, 1)";
                        MySqlCommand cmdInsert = new MySqlCommand(insert, con);
                        cmdInsert.Parameters.AddWithValue("@u", userId);
                        cmdInsert.Parameters.AddWithValue("@p", productId);
                        cmdInsert.ExecuteNonQuery();
                    }
                    else
                    {
                        string update = "UPDATE Cart SET Quantity = Quantity + 1 WHERE UserID=@u AND ProductID=@p";
                        MySqlCommand cmdUpdate = new MySqlCommand(update, con);
                        cmdUpdate.Parameters.AddWithValue("@u", userId);
                        cmdUpdate.Parameters.AddWithValue("@p", productId);
                        cmdUpdate.ExecuteNonQuery();
                    }

                    Response.Redirect("Checkout.aspx");
                }
            }
        }
    }
}
