
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace CoffeeBeansAPI.Models
{
    public class CoffeeProductContext: DbContext 
    {
        public DbSet<CoffeeProduct> Products { get; set; }

        public CoffeeProductContext(DbContextOptions<CoffeeProductContext> options): base(options) 
        {
            
        }

        public async Task<string> GetBeanOfTheDay(DateTime date)
        {  
            string beanId = string.Empty;

            string query = "DBO.SP_BEANOFTHEDAY";
            SqlCommand sqlcomm = new SqlCommand(query, new SqlConnection(Database.GetConnectionString()));
            sqlcomm.CommandType = System.Data.CommandType.StoredProcedure;
            sqlcomm.Parameters.AddWithValue("@date", date.ToString("yyyy-MM-dd"));

            if (sqlcomm.Connection.State == System.Data.ConnectionState.Closed)
                sqlcomm.Connection.Open();

            using (SqlDataReader rdr = sqlcomm.ExecuteReader())
            {
                while (rdr.Read())
                    beanId = rdr.GetString(0);
            
            }
            sqlcomm.Connection.Close();

            return beanId;   

          
        }

        
 
        
    }
}
