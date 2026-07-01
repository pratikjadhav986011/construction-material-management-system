using MySql.Data.MySqlClient;
using System.Data.SqlClient;

public class DBConnect
{
    private string connectionString = "server=localhost;user id=root;password=;database=constructiondb;";

    public MySqlConnection GetCon()
    {
        return new MySqlConnection(connectionString);
    }
}
