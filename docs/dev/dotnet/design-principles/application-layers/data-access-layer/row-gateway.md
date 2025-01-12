# Row Gateway

Row Gateway pattern represents a `single row` of a database table as an `object`.
It's methods provides access to individual fields of the row.

### Q/A
**Q**: Can Row Gateway pattern modify several rows at once? 

**A**: No, the `Row Gateway` pattern is fundamentally designed to encapsulate access to a **single** row within a database table.


**Q**: Can `Row Gateway` pattern fetch several rows?

**A**: No, when a class starts fetching multiple rows, it's shifting towards the responsibilities of a `Table Gateway`.


**Q**: How to fetch data from joined tables?

**A**: The `Row Gateway` pattern is primarily designed to encapsulate access to a single row within a database table. To fetch data from joined tables, it is needed to create another Gateway class specifically for the joined data.

### Row Gateway Pattern Pros
- Hides database access logic within the Row Gateway class.
- Avoids loading and inserting `unnecessary data`.
- Easy to write optimized queries for the database. Additionally to improve performance, queries can be written as stored procedures, and they can be cached by the database server for even better performance.

### Row Gateway Pattern Pros
- It is very easy to leak business logic into the data access layer.
- In some code places, loading by one row introduces a slight performance overhead.
- Code is very bound to changes in the database schema.
- It is hard to manage `transactions`. Adding them in one place requires reviewing many other places.


### Example: 

A `User` object have properties like id, name, and email, and `UserRowGateway` methods to get and set their values.

```csharp
using DataAccessLayer;
using Microsoft.Data.SqlClient;

namespace DomainLayer
{
    public class UserService(UserRowGateway userRowGateway)
    {
        public void CreateUser(string name, string email)
        {
            var user = new User(1, name, email);
            userRowGateway.Save(user);
        }

        public void UpdateUserName(int userId, string name)
        {
            // Updates only one column
            userRowGateway.UpdateUserName(userId, name);
        }

        public void DeleteUser(int userId)
        {
            userRowGateway.Delete(userId);
        }

        public IEnumerable<User?> FindUsers(int[] userIds)
        {
            return userIds.Select(userRowGateway.Find);
        }
    }
}

namespace DataAccessLayer
{
    public record User(int Id, string Name, string Email);

    public class UserRowGateway(string connectionString)
    {
        public User? Find(int id)
        {
            string query = "SELECT * FROM Users WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);
            using SqlCommand command = new(query, connection);

            command.Parameters.AddWithValue("@Id", id);

            connection.Open();

            using SqlDataReader reader = command.ExecuteReader();

            if (reader.Read())
            {
                return new User((int)reader["Id"], (string)reader["Name"], (string)reader["Email"]);
            }

            return null;
        }

        public void Save(User user)
        {
            string query;

            if (user.Id == 0)
            {
                // Insert
                query = "INSERT INTO Users (Name, Email) VALUES (@Name, @Email)";
            }
            else
            {
                // Update
                query = "UPDATE Users SET Name = @Name, Email = @Email WHERE Id = @Id";
            }

            using SqlConnection connection = new(connectionString);
            using SqlCommand command = new(query, connection);

            command.Parameters.AddWithValue("@Name", user.Name);
            command.Parameters.AddWithValue("@Email", user.Email);

            if (user.Id != 0)
            {
                command.Parameters.AddWithValue("@Id", user.Id);
            }

            connection.Open();
            command.ExecuteNonQuery();
        }

        public void Delete(int id)
        {
            string query = "DELETE FROM Users WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);
            using SqlCommand command = new(query, connection);

            command.Parameters.AddWithValue("@Id", id);

            connection.Open();
            command.ExecuteNonQuery();
        }

        public void UpdateUserName(int userId, string userName)
        {
            string query = "UPDATE Users SET Name = @Name WHERE Id = @Id";

            using SqlConnection connection = new(connectionString);
            using SqlCommand command = new(query, connection);

            command.Parameters.AddWithValue("@Name", userName);
            command.Parameters.AddWithValue("@Id", userId);

            connection.Open();
            command.ExecuteNonQuery();
        }
    }
}

```