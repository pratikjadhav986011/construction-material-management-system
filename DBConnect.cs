using System;
using System.Configuration;
using MySql.Data.MySqlClient;

namespace ConstructionMaterialsManagement
{
    public class DBConnection
    {
        private MySqlConnection connection;

        public DBConnection()
        {
            // You can also store this in Web.config later
            string connectionString = "server=localhost;user id=root;password=;database=constructiondb;";
            connection = new MySqlConnection(connectionString);
        }

        public MySqlConnection GetConnection()
        {
            return connection;
        }

        public void OpenConnection()
        {
            if (connection.State == System.Data.ConnectionState.Closed)
            {
                connection.Open();
            }
        }

        public void CloseConnection()
        {
            if (connection.State == System.Data.ConnectionState.Open)
            {
                connection.Close();
            }
        }
    }
}
