# Domain Layer

### Domain Layer implementation patterns:
- Transaction Script
- Table Module
- Domain Model
    - Domain Model (Simple OOP Model)
    - Actor Model
    - DDD Domain Model

### Domain Layer definition
The `domain layer`, also known as the `business layer`, is a crucial component of software architecture. It is responsible for encapsulating the core `business logic` and `rules of an application`. As the heart of the software, it represents the specific problem domain that the software is trying to solve. 

Domain layer consists from: 

##### Business Rules 
These are the specific regulations, policies, and constraints that govern how your business operates. 

For example, in an e-commerce system, a business rule might be that a customer cannot order more than 10 units of a particular product. 

```csharp
enum ProductType
{
    None = 0,

    Normal = 1,

    Special = 2,
}
class OrderModel
{
    const int SpecialProductsMaxCount = 10;

    public void AddProduct(Guid productId, string name, int count, ProductType productType)
    {
        if (productType == ProductType.Special && count == SpecialProductsMaxCount)
        {
            throw new DomainException($"Order cannot contain more then {SpecialProductsMaxCount} {ProductType.Special} products.");
        }

        // Add product logic ...
    }
}
class DomainException : Exception
{
    public DomainException(string message) : base(message) { }
};
```

##### Processes
These are the workflows and procedures that define how tasks are performed within your business.

For instance, the process of placing an order might involve steps like adding items to the cart, applying discounts, calculating shipping costs, and processing payment.

```csharp
class BusinessService {
    public void CalculateOrderDiscount(OrderModel order, DiscountModel discount)
    {
        (int TotalAmount, int ProductsCount, ProductType productType) orderDto = order;

        // Calculating discount
        int orderDiscount = discount.Calulate(orderDto);

        // Make discount
        order.MakeDiscount(orderDiscount);
    }
}
```

##### Operations
These are the actions and calculations that are performed on data within your system. 

This could include things like calculating taxes, validating user input, or generating reports

```csharp
class BusinessService {
    public TopUserOrdersReport CreateTopUserOrdersReport(IReadOnlyList<OrderModel> order, UserModel user, IReadOnlyList<Products> mostPurchasedProducts)
    {
        var report = new TopUserOrdersReport();

        report.AddUserOrders(order);

        report.AddUserInformation(user);

        report.AddMostPurchasedProducts();

        return report;
    }
}
```

### What pattern should be chosen? 

#### Table Module

The `Table Module` pattern would be a good choice if:

- There is no time to consider domain models. 
- Requirements are not fully defined and can be significantly be changed.

- The team is large, and there is neither time nor staff for code review.
- Most of the team members lack experience and knowledge of OOP and DDD. 
- There is not time for unit and integration tests.

- A project mostly consists of CRUD operations.
- Performance is a priority for the project.

The `Table Module` works well with the `Table Gateway` data access layer pattern.

Code rich in business logic can be moved to separate `business services`, and even parts of the application can be incorporated into `Domain models`.

If performance is a high priority, bottlenecks can be optimized using the `Transaction Script` pattern.

The `Table Module` pattern is well-suited for projects with simple code where the goal is to quickly create a more or less functional prototype with the main functionality.

#### Domain Model

The `Domain Model` pattern would be a good choice if:

- The requirements are reasonably clear, and there is an understanding of which domain models can be created.
- The application will have business logic that is suitable for being incorporated into domain models.
- There are architects on the team who can plan the development of domain models that can be reused across different user stories, especially at the beginning of the project.

- The business logic is planned to be covered with unit or integration tests.

- The team lacks knowledge of DDD.
- It is planned to implement many lazy loadings in the objects from the start for performance improvements. 

#### DDD Domain Model

The `DDD` pattern would be a good choice if:

- Code maintainability, supportability and clear business logic are prioritized over performance.
- The team has time to carefully plan domain objects, for example, using the `Event Storming` technique.
- The project is planned for long-term, easy support with minimal effort.

When a project is built with DDD, stabilized, and covered by unit, integration, smoke, and other tests, optimizing different parts of the application without breaking anything can be achieved with relatively little effort. For example, this can be done by introducing lazy loading or even rewriting some parts with the `Transaction Script` pattern for frequently changing elements, such as the status of objects.

Code well-written using DDD is very easy to support. It is a good choice for projects full of business logic.