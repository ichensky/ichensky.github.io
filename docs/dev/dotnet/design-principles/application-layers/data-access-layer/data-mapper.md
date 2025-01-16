# Data Mapper

The `Data Mapper` pattern is an architectural pattern that aims to separate the in-memory objects from the database.<br>
It does this by creating a dedicated layer (the Data Mapper/Data Access) responsible for transferring data between the two.

### Pros
* Improves testebility. By separating data access logic from `domain objects`, `unit tests` for the `business logic` can be easily written without relying on a real database.

* Changes to database schema or data access strategies can be made within the `Mapper` without impacting other parts of the application.

* Allows easily switch between different database (e.g., from MS SQL to PostgreSQL) without affecting the `domain logic`.


### Cons

* Introduces an extra layer of abstraction, making the system slightly more complex to understand and implement compared to simpler approaches.

* Requires *careful design and implementation* to avoid over-engineering and potential *performance bottlenecks*.


### Example


```csharp
namespace ApplicationLayer {
    using DomainLayer;
    using DataAccessLayer;

    public class ProductService(string connectionString)
    {
        public async Task Ex() {
            ProductMapper mapper = new(connectionString);

            // Get all products
            IList<Product> allProducts = await mapper.GetAllAsync();

            // Get a specific product
            Product product = await mapper.GetByIdAsync(1) ?? throw new InvalidOperationException("Product not found.");

            product.ApplyDiscount(30);

            await mapper.SaveAsync(product);
        }
    }
}

namespace DomainLayer
{
    public class Product
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Price { get; set; }

        // Domain business logic
        public void ApplyDiscount(decimal discountPercent)
        {
            this.Price = Price - (Price * discountPercent);
        }
    }
}
namespace DataAccessLayer
{
    using DomainLayer;
    using Microsoft.Data.SqlClient;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public class ProductMapper(string connectionString)
    {
        public async Task<List<Product>> GetAllAsync()
        {
            var products = new List<Product>();

            using SqlConnection connection = new(connectionString);

            await connection.OpenAsync();

            using SqlCommand command = new("SELECT Id, Name, Price FROM Products", connection);

            using var reader = await command.ExecuteReaderAsync();

            while (await reader.ReadAsync())
            {
                products.Add(new Product
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    Price = reader.GetDecimal(2)
                });
            }

            return products;
        }

        public async Task<Product?> GetByIdAsync(int id)
        {
            using var connection = new SqlConnection(connectionString);

            await connection.OpenAsync();

            using var command = new SqlCommand("SELECT Id, Name, Price FROM Products WHERE Id = @Id", connection);

            command.Parameters.AddWithValue("@Id", id);

            using var reader = await command.ExecuteReaderAsync();

            if (await reader.ReadAsync())
            {
                return new Product
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1),
                    Price = reader.GetDecimal(2)
                };
            }

            return null;
        }


        public async Task<bool> SaveAsync(Product product)
        {
            using SqlConnection connection = new(connectionString);

            await connection.OpenAsync();

            using var command = new SqlCommand(
                product.Id == 0
                    ? "INSERT INTO Products (Name, Price) VALUES (@Name, @Price);"
                    : "UPDATE Products SET Name = @Name, Price = @Price WHERE Id = @Id;",
                connection);

            command.Parameters.AddWithValue("@Name", product.Name);
            command.Parameters.AddWithValue("@Price", product.Price);

            if (product.Id != 0)
            {
                command.Parameters.AddWithValue("@Id", product.Id);
            }

            int rowsAffected = await command.ExecuteNonQueryAsync();

            return rowsAffected > 0;
        }
    }
}

```

### Data mapper implementation

Third-party libraries help to simplify the creation of a Data Mapper layer.

#### C# - EF Core
* Acts as a more comprehensive Data Mapper, handling a significant portion of the data mapping logic internally.

* It translates LINQ queries into SQL, `tracks changes` to entities, and manages relationships between objects.

* The mapping process can be customize using fluent API or data annotations.

##### Example. EF Core Data Mapper

```csharp
namespace ApplicationLayer
{
    using DataAccessLayer;
    using DomainLayer;

    public class ProductService(MyDbContext myDbContext)
    {
        public async Task Ex()
        {
            ProductMapper mapper = new(myDbContext);

            // Get all products
            IList<Product> allProducts = await mapper.GetAllAsync();

            // Get a specific product
            Product product = await mapper.GetByIdAsync(1) ?? throw new InvalidOperationException("Product not found.");

            product.ApplyDiscount(30);

            await mapper.UpdateAsync(product);
        }
    }
}

namespace DomainLayer
{
    public class Product
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Price { get; set; }

        // Domain business logic
        public void ApplyDiscount(decimal discountPercent)
        {
            this.Price = Price - (Price * discountPercent);
        }
    }

    public interface IProductMapper
    {
        Task<List<Product>> GetAllAsync();

        Task<Product?> GetByIdAsync(int id);

        Task<Product> CreateAsync(Product product);

        Task<bool> UpdateAsync(Product product);

        Task<bool> DeleteAsync(int id);
    }
}

namespace DataAccessLayer
{
    using DomainLayer;
    using Microsoft.EntityFrameworkCore;
    using System.Collections.Generic;
    using System.Threading.Tasks;

    public class ProductMapper(MyDbContext context) : IProductMapper
    {
        public async Task<List<Product>> GetAllAsync()
        {
            return await context.Products.ToListAsync();
        }

        public async Task<Product?> GetByIdAsync(int id)
        {
            return await context.Products.FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<Product> CreateAsync(Product product)
        {
            context.Products.Add(product);

            await context.SaveChangesAsync();

            return product;
        }

        public async Task<bool> UpdateAsync(Product product)
        {
            context.Products.Update(product);

            await context.SaveChangesAsync();

            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var product = await context.Products.FindAsync(id);

            if (product == null)
            {
                return false;
            }

            context.Products.Remove(product);

            await context.SaveChangesAsync();

            return true;
        }
    }


    public class MyDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        // ... (Constructor and DbContextOptions configuration) ...
    }
}
```

#### C# - Dapper

* A more lightweight `Data Mapper` then `EF Core`.
* There is more control over the mapping process, code is written with raw SQL queries and the results are manually mapped to .NET objects.
* While less automated, it offers greater flexibility and can be more performant for certain scenarios.

##### Example. Dapper Data Mapper

```csharp
using Dapper;
using Microsoft.Data.SqlClient;

namespace DomainLayer
{
    public class Product
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Price { get; set; }
    }

    public interface IProductMapper
    {
        Task<IEnumerable<Product>> GetAllAsync();

        Task<Product?> GetByIdAsync(int id);

        Task<Product> CreateAsync(Product product);

        Task<bool> UpdateAsync(Product product);

        Task<bool> DeleteAsync(int id);
    }
}

namespace DataAccessLayer
{
    using DomainLayer;

    public class ProductMapper(string connectionString) : IProductMapper
    {
        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            string sql = "SELECT Id, Name, Price FROM Products";

            using SqlConnection connection = new(connectionString);

            var products = await connection.QueryAsync<Product>(sql);

            return products;
        }

        public async Task<Product?> GetByIdAsync(int id)
        {
            string sql = "SELECT Id, Name, Price FROM Products WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);

            return await connection.QueryFirstOrDefaultAsync<Product>(sql, new { Id = id });
        }

        public async Task<Product> CreateAsync(Product product)
        {
            string sql = "INSERT INTO Products (Name, Price) OUTPUT INSERTED.Id VALUES (@Name, @Price)";

            using SqlConnection connection = new(connectionString);

            product.Id = await connection.ExecuteScalarAsync<int>(sql, product);

            return product;
        }

        public async Task<bool> UpdateAsync(Product product)
        {
            string sql = "UPDATE Products SET Name = @Name, Price = @Price WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);

            return await connection.ExecuteAsync(sql, product) > 0;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            string sql = "DELETE FROM Products WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);

            return await connection.ExecuteAsync(sql, new { Id = id }) > 0;
        }
    }
}

```

### Typescript/JavaScript - TypeOrm

`TypeOrm` is ORM designed for `Node.js` and `TypeScript` environments.

```ts
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Product {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column('decimal', { precision: 10, scale: 2 })
  price: number;
}

import { EntityRepository, Repository } from 'typeorm';

@EntityRepository(Product)
export class ProductMapper extends Repository<Product> {
  async getAll(): Promise<Product[]> {
    return await this.find();
  }

  async getById(id: number): Promise<Product | null> {
    return await this.findOneBy({ id });
  }

  async create(product: Product): Promise<Product> {
    return await this.save(product);
  }

  async update(product: Product): Promise<boolean> {
    const result = await this.save(product);
    return !!result; 
  }

  async deleteById(id: number): Promise<boolean> {
    const result = await this.delete({ id });
    return result.affected > 0;
  }
}
```