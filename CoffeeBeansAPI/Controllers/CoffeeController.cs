using CoffeeBeansAPI.Models;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Linq;

namespace CoffeeBeansAPI.Controllers
{
    [Microsoft.AspNetCore.Mvc.Route("api/coffee")]
    [ApiController]
    public class CoffeeController : ControllerBase
    {
        private CoffeeProductContext _dbContext;

        public CoffeeController(CoffeeProductContext coffeeProductContext)
        {
            _dbContext = coffeeProductContext;   
        }

        // GET //
        [HttpGet("id")]
        public async Task<ActionResult<CoffeeProduct>> GetProduct(string id)
        {
            if (_dbContext.Products == null)
                return NotFound();

            CoffeeProduct product =  await _dbContext.Products.FindAsync(id);

            if (product == null)
                return NotFound(id);

            return product;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<CoffeeProduct>>> GetProducts()
        {
            if (_dbContext.Products == null)  
                return NotFound(); ;


            return await _dbContext.Products.ToListAsync();
        }

        
        [HttpGet("beanoftheday")]
        public async Task<ActionResult<CoffeeProduct>> GetBeanOfTheDay(DateTime date)
        {
            string id = await _dbContext.GetBeanOfTheDay(date);

            CoffeeProduct product = await _dbContext.Products.FindAsync(id);

            if (product == null)
                return NotFound(id);
            else
                return product;         
        }

        
        [HttpGet("beansearch")]
        public async Task<ActionResult<IEnumerable<CoffeeProduct>>> SearchProducts(string? name, string? colour, string? description, string? country)
        {
            List<CoffeeProduct> filteredProducts = new List<CoffeeProduct>();
            var query = _dbContext.Products.AsQueryable();

            if (!string.IsNullOrWhiteSpace(name))
            {
                query = query.Where(p => EF.Functions.Like(p.Name, $"%{name}%"));
                filteredProducts.AddRange(query);
            }

            if (!string.IsNullOrWhiteSpace(description))
            {
                query = query.Where(p => EF.Functions.Like(p.Description, $"%{description}%"));
                filteredProducts.AddRange(query);
            }

            if (!string.IsNullOrWhiteSpace(country))
            {
                query = query.Where(p => EF.Functions.Like(p.Country, $"%{country}%"));
                filteredProducts.AddRange(query);
            }

            return filteredProducts;         
        }
        
        // POST //
        [HttpPost]
        public async Task<ActionResult<CoffeeProduct>> PostProduct(CoffeeProduct product)
        {
            _dbContext.Products.Add(product);
            await _dbContext.SaveChangesAsync();
            return CreatedAtAction(nameof(GetProduct), new { Id = product.Id }, product);
        }

        // DELETE //
        [HttpDelete("id")]
        public async Task<ActionResult<CoffeeProduct>> DeleteProduct(string id)
        {
            if (_dbContext.Products == null)
                return NotFound();

            CoffeeProduct product = await _dbContext.Products.FindAsync(id);
            if (product == null)
                return NotFound();
            else
            {
                _dbContext.Products.Remove(product);
                await _dbContext.SaveChangesAsync();
                return NoContent();
            }    
        }

        // PUT //
        [HttpPut]
        public async Task<ActionResult<CoffeeProduct>> AlterProduct(CoffeeProduct product)
        {
            if (_dbContext.Products == null)
                return NotFound();

            int productsFound = await _dbContext.Products.Where(e => e.Id == product.Id).CountAsync();
            if (productsFound == 0)
                return NotFound();
            else
            {
                _dbContext.Entry(product).State = EntityState.Modified;
                await _dbContext.SaveChangesAsync();
            }

            return product;

        }

    }
}
