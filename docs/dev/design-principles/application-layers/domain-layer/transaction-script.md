# Transaction Script

The simplest way to describe business logic within the `Transaction Script` pattern is to create a script that represents a `business transaction`. 

This script explicitly defines the steps involved in the business process, and it can call upon `other transaction scripts` to perform `sub-tasks`.

```csharp
using DataAccessLayer;

namespace DomainLayer
{
    public class CustomerService(ICustomerGateway customerGateway)
    {
        public async Task ChangeCustomerName(Guid customerId, string firstName, string secondName)
        {
            ArgumentNullException.ThrowIfNullOrEmpty(firstName);
            ArgumentNullException.ThrowIfNullOrEmpty(firstName);

            CustomerNameDto nameDto = customerGateway.GetCustormerFirstName(customerId);

            if (nameDto.FirstName == firstName || nameDto.SecondName == secondName)
            {
                throw new DomainException("Name is the same.");
            }

            await customerGateway.ChangeCustromerName(customerId, firstName, secondName);
        }

        public async Task ChangeCustomerAddress(Guid customerId, string city, string address) {
            ArgumentException.ThrowIfNullOrEmpty(city);
            ArgumentException.ThrowIfNullOrEmpty(address);

            if (city.Length > 50 || address.Length > 100)
            {
                throw new DomainException("City or address is too long.");
            }

            await customerGateway.ChangeCustomerAddress(customerId, city, address);
        }
    }
}

namespace DataAccessLayer
{
    public class CustomerNameDto
    {
        public string FirstName { get; set; }

        public string SecondName { get; set; }
    }

    public interface ICustomerGateway
    {
        CustomerNameDto GetCustormerFirstName(Guid customerId);

        Task ChangeCustromerName(Guid customerId, string firstName, string secondName);
    }

    public class CustomerGateway : ICustomerGateway
    {
        public CustomerNameDto GetCustormerFirstName(Guid customerId)
        {
            // Get data from the database
            return ... 'select Id, FirstName from dbo.Customer;';
        }
        public async Task ChangeCustromerName(Guid customerId, string firstName, string secondName)
        {
            // Update data in the database
            ... 'update dbo.Customer set firstName=@firstName .. where Id=@customerId;';
        }
    }
}
```

### Pros of Transaction Script:

**Simplicity:**

- Easy to understand and implement, especially for simpler applications.
- Minimal upfront design required.
- Well-suited for procedural programming languages.

**Performance:**

- Can be efficient for straightforward transactions.
- Direct database access can minimize overhead in some cases.

### Cons of Transaction Script:

**Code Duplication:**

- Business logic can be scattered across multiple scripts, leading to redundancy.
- Difficult to maintain and update as the application grows.

**Limited Reusability:**

`Business rules` are tightly coupled with the database and specific transactions.
Reusing logic across different use cases can be challenging.

**Scalability Issues:**

As complexity increases, scripts can become large and difficult to manage.
Maintaining consistency and preventing errors can be more challenging.

**Poor Object-Oriented Design:**

Often leads to procedural code and limited encapsulation of business logic.
