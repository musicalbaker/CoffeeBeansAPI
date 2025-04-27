using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CoffeeBeansAPI.Models
{
    [Table("CoffeeProducts")]
    public class CoffeeProduct
    {

        [Key]
        public string Id { get; set; }

        [Required]
        public int Index { get; set; }

        [Required]
        public bool IsBotd { get; set; }

        [Required]
        public decimal Cost { get; set; }

        [MaxLength(500)]
        public string Image { get; set; }

        [MaxLength(50)]
        public string Colour { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; }

        public string Description { get; set; }

        [MaxLength(100)]
        public string Country { get; set; }
    }
}
