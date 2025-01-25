# Table Gateway

This pattern is designed to `modify` or `fetch` several rows of the table.

Comparing to the `Row Gateway` pattern, the `Table Gateway` pattern is more optimal for batch operations, it can fetch or modify several rows at once. It can also easily return data from joined tables.

However, it is always a question of where to put a query that fetches joined tables. Should it be in the `CustomerGateway` or the `OrderGateway`, or is it better to create a new `CustomerOrdersGateway` class?


```csharp
namespace DataAccessLayer
{
    public record Customer(int CustomerId, string FirstName, string LastName);

    public record CustomerWithOrders(int CustomerId, string FirstName, string LastName, List<Order> Orders);

    public record Order(int OrderId, DateTime OrderDate);

    public class CustomerGateway(string connectionString)
    {
        public List<Customer> GetCustomers()
        {
            List<Customer> customers = [];
            string query = "SELECT CustomerId, FirstName, LastName FROM Customers";

            using SqlConnection connection = new(connectionString);

            using SqlCommand command = new(query, connection);
            connection.Open();

            using SqlDataReader reader = command.ExecuteReader();

            while (reader.Read())
            {
                customers.Add(new Customer((int)reader["CustomerId"], (string)reader["FirstName"], (string)reader["LastName"]));
            }

            return customers;
        }

        public Customer? GetCustomerById(int customerId)
        {
            Customer? customer = null;
            string query = "SELECT CustomerId, FirstName, LastName FROM Customers WHERE CustomerId = @CustomerID";

            using SqlConnection connection = new(connectionString);
            using SqlCommand command = new(query, connection);

            command.Parameters.AddWithValue("@CustomerId", customerId);
            connection.Open();

            using SqlDataReader reader = command.ExecuteReader();

            if (reader.Read())
            {
                customer = new Customer((int)reader["CustomerId"], (string)reader["FirstName"], (string)reader["LastName"]);
            }

            return customer;
        }

        public List<CustomerWithOrders> GetCustomersWithOrders()
        {
            var query = @"SELECT c.CustomerId, 
                            c.FirstName, 
                            c.LastName, 
                            o.OrderId, 
                            o.OrderDate 
                          FROM Customers c 
                          JOIN Orders o ON c.CustomerId = o.CustomerId";
            List<CustomerWithOrders> customers = [];

            using var connection = new SqlConnection(connectionString);
            using SqlCommand command = new(query, connection);

            connection.Open();

            using var reader = command.ExecuteReader();

            while (reader.Read())
            {
                customers.Add(new CustomerWithOrders(
                    (int)reader["CustomerID"],
                    (string)reader["FirstName"],
                    (string)reader["LastName"],
                    [new((int)reader["OrderID"], (DateTime)reader["OrderDate"])]));
            }

            return customers;
        }
    }
}
```