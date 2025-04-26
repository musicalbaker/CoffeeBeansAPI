
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;

namespace CoffeeBeansAPI.Models
{
    public class CoffeeProductContext: DbContext 
    {
        public DbSet<CoffeeProduct> Products { get; set; }

        public CoffeeProductContext(DbContextOptions<CoffeeProductContext> options): base(options) 
        {
            
        }

        public async Task<int> GetBeanOfTheDay(DateTime date)
        {
            //return await Database.ExecuteSqlRawAsync(sql, parameters);
            //await Database.ExecuteSql("exec dbo.spBEANOFTHEDAY", date);
            return 0;
        }


    }
}
