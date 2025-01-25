# Active Record

`Active Record` is `object-relational mapping` (ORM) pattern. It integrates both `business logic` and `data persistence` within a single object.   

In `Active Record` pattern, each `object` in the system directly corresponds to a `row` in a database table.

It makes `Active Record` very similar to the `Row Gateway` pattern, but the *key* difference between them is that `Active Record` saves and retrieves the entire `object`, while the `Row Gateway pattern` saves and retrieves `raw database table data`.

* An `object` is an entity that has `state`, `behavior`, and `identity`.

### Drawbacks
* Leads to tightly coupled code between the domain model and the database.

### Example

```csharp
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;


namespace DomainLayer
{
    public class Product
    {
        public Product()
        {
            OrderProducts = [];
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public decimal Price { get; set; }

        public virtual ICollection<OrderProduct> OrderProducts { get; set; }

        #region Data Access

        public async Task<bool> SaveAsync(MyDbContext context)
        {
            try
            {
                if (Id == 0)
                {
                    await context.AddAsync(this);
                }
                else
                {
                    context.Update(this);
                }

                await context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                // Error saving Product .. 
                return false;
            }
        }

        public static async Task<List<Product>> GetAllAsync(MyDbContext context)
        {
            return await context.Products.ToListAsync();
        }

        public static async Task<Product?> GetByIdAsync(MyDbContext context, int id)
        {
            return await context.Products.FirstOrDefaultAsync(p => p.Id == id);
        }

        #endregion Data Access
    }

    public class Order
    {
        public Order()
        {
            OrderProducts = [];
        }
        public int Id { get; set; }

        public DateTime OrderDate { get; set; }

        public virtual ICollection<OrderProduct> OrderProducts { get; set; }


        #region Data Access

        public async Task<bool> SaveAsync(MyDbContext context)
        {
            try
            {
                if (Id == 0)
                {
                    await context.AddAsync(this);
                }
                else
                {
                    context.Update(this);
                }

                await context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                // Error saving Order ..
                return false;
            }
        }

        public static async Task<List<Order>> GetAllAsync(MyDbContext context)
        {
            return await context.Orders.ToListAsync();
        }

        public static async Task<Order?> GetByIdAsync(MyDbContext context, int id)
        {
            return await context.Orders.FirstOrDefaultAsync(o => o.Id == id);
        }

        #endregion Data Access
    }

    public class OrderProduct
    {
        public int OrderId { get; set; }

        public int ProductId { get; set; }

        public int Quantity { get; set; }

        public virtual Order Order { get; set; }

        public virtual Product Product { get; set; }

        #region Data Access
        
        public async Task<bool> SaveAsync(MyDbContext context)
        {
            try
            {
                if (OrderId == 0 && ProductId == 0)
                {
                    await context.AddAsync(this);
                }
                else
                {
                    context.Update(this);
                }

                await context.SaveChangesAsync();
                return true;
            }
            catch (Exception ex)
            {
                // Error saving OrderProduct ..
                return false;
            }
        }

        #endregion Data Access
    }

    public class MyDbContext : DbContext
    {
        public DbSet<Product> Products { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderProduct> OrderProducts { get; set; }

        // ... (Constructor and DbContextOptions configuration) ...
    }
}
```


