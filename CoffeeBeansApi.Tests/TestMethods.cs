using System.Net;

namespace CoffeeBeansApi.Tests
{
    [TestClass]
    public sealed class TestMethods
    {
        private HttpClient _client;
        public TestMethods()
        {
            _client = new HttpClient
            {
                BaseAddress = new Uri("https://localhost:7294/api/coffee")
            };
        }

        [TestMethod]
        public void GetProducts()
        {
            var response = _client.GetAsync("").GetAwaiter().GetResult();

            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public void GetSingleProduct()
        {
            var response = _client.GetAsync("66a374593a88b14d9fff0e2e").GetAwaiter().GetResult();

            Assert.AreEqual(HttpStatusCode.OK, response.StatusCode);
        }

        [TestMethod]
        public void AddProduct()
        {

        }

        [TestMethod]
        public void DeleteProduct()
        {

        }

        [TestMethod]
        public void AlterProduct()
        {

        }
    }
}
