# Data Access Object

The `DAO` pattern is a specific type of `Data Gateway` – it provides a mechanism to retrieve or store a particular type of data from the data store.

In the purest sense of the DAO pattern, a DAO should ideally return `Business Objects`. However, it often works directly with `data transfer objects` (`DTOs`) instead of domain objects. DAOs are more focused on `database interactions` than on the specific needs of domain objects.

#### DAO operates
- Model Objects - domain object, that contains business logic
- Data transfert objects (DTOs)

#### DAO Types
* One DAO for each table.

* One DAO for all the tables for a particular DBMS.

* Where the SELECT query is limited only to its target table and cannot incorporate JOINS, UNIONS, subqueries and Common Table Expressions (CTEs)

* Where the SELECT query can contain anything that the DBMS allows.

### Pros of DAO
* Improved Testability. DAOs are easily isolated and tested independently of other parts of the application.
* Changes to data access logic are confined within the DAO, making it easier to maintain and modify. If database changes are required, it is needed to update the corresponding DAO, without other parts of the application.
* Allows easily switch to a different data source (e.g., from a relational database to a NoSQL database) by modifying the DAO implementation without affecting other parts of the application.

### Const of DAO
* DAO increase `performance overhead`. While generally minimal, there might be a slight performance overhead due to the extra layer of abstraction and data mapping.
* It's possible to over-engineer the DAO layer, leading to unnecessary complexity and making the system harder to maintain.
* The DAO can limit the level of control developers have over the specific details of database interactions.<br>
If the application requires very specific database features (e.g., complex SQL queries, stored procedures, database-specific functions), the DAO might not provide the necessary flexibility to access or utilize them directly. It might be needed to work around the limitations of the DAO or modify its implementation to accommodate these features.

### Q/A

Q: Can DAO call `storage procedures`?<br>
A: Yes, DAOs can execute stored procedures.

### Example 

```csharp
namespace DomainLayer
{
    public class Product
    {
        public Product(int id, string name, decimal price)
        {
            Id = id;
            Name = name;
            Price = price;
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Price { get; set; }

        public string Description { get; set; }

        // Domain business logic
        public void ApplyDiscount(decimal discountPercent)
        {
            this.Price = Price - (Price * discountPercent);
        }
    }

    public interface IProductDao
    {
        Task<ProductNameDto> CreateAsync(Product product);

        Task<bool> DeleteAsync(int id);

        Task<IEnumerable<Product>> GetAllAsync();

        Task<Product?> GetByIdAsync(int id);
    }

    public record ProductDto(int Id, string Name, decimal Price);

    public record ProductNameDto(int Id, string Name);
}

namespace DataAccessLayer
{
    using Dapper;
    using DomainLayer;
    using System.Collections.Generic;
    using System.Data;
    using System.Threading.Tasks;
    using Microsoft.Data.SqlClient;


    public class ProductDao(string connectionString) : IProductDao
    {
        // Gets Domain Objects
        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            string sql = "SELECT Id, Name, Price FROM Products";

            using SqlConnection connection = new(connectionString);

            IEnumerable<ProductDto> productDtos = await connection.QueryAsync<ProductDto>(sql);

            IEnumerable<Product> products = productDtos.Select(dto => new Product(dto.Id, dto.Name, dto.Price));

            return products;
        }

        // By passing DTO(id), method returns Domain Object
        public async Task<Product?> GetByIdAsync(int id)
        {
            string sql = "SELECT Id, Name, Price FROM Products WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);

            var productDto = await connection.QueryFirstOrDefaultAsync<ProductDto>(sql, new { Id = id });

            if (productDto == null)
            {
                return null;
            }

            return new Product(productDto.Id, productDto.Name, productDto.Price);
        }

        // Gets DTO
        public async Task<ProductNameDto> CreateAsync(Product product)
        {
            using SqlConnection connection = new(connectionString);

            string sql = @"
                INSERT INTO Products (Name, Price) 
                OUTPUT INSERTED.Id, INSERTED.Name 
                VALUES (@Name, @Price)";

            var dto = await connection.QuerySingleAsync<ProductNameDto>(sql, new { product.Name, product.Price });

            return dto;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            using (var connection = new SqlConnection(connectionString))
            {
                string sql = "DELETE FROM Products WHERE Id = @Id";
                return await connection.ExecuteAsync(sql, new { Id = id }) > 0;
            }
        }
    }

}

```
