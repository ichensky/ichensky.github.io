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

