using CoffeeBeansAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace CoffeeBeansAPI.Controllers
{
    [Route("api/Coffee")]
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

        [HttpGet]
        public async Task<ActionResult<CoffeeProduct>> GetBeanOfTheDay(DateTime date)
        {
            return NoContent();
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
