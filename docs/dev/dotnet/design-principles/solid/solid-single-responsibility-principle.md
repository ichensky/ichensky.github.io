# SOLID Single Responsibility Principle (SRP)

Robert C. Martin:
[srp.pdf](https://web.archive.org/web/20150202200348/http://www.objectmentor.com/resources/articles/srp.pdf)
> There should never be more than one reason for a class to change.

Martin, Robert C. (2018). Clean architecture: a craftsman's guide to software structure and design:
> A module should be responsible to one, and only one, actor.

This `principle` is `violated` when `two or more actors` `use the same class`.

By an actor means a person or a group of people. Actor that's the single reason to change a module.

By `module` means a file with source code, which has structures and function related to each other. Object oriented, languages as `C#` place code in `classes`, in this case `module` can be interpreted as a `class`.

### Example of violation the principle 

An online shop have a `Product` class, which contains data such as title, description and price. The Product class have two associated pages: one for users and one for the seller. It also contains shared method `GetProductInformation` which is both used by users and a seller.

`Users` and `seller` are `actors`.<br>
`Product` class and its method `GetProductInformation` is `shared` between them and exactly this `violates` `Single Responsibility Principle`.
<hidden style="display:none">
@startuml
actor Seller
participant Product
actor Users
Seller -> Product : ctor
Seller -> Product : UpdateDescription()
Seller -> Product : UpdatePrice()
Users -> Product : GetProductInformation()
Product --> Users : ProductInformation
Seller -> Product : GetProductInformation()
Product --> Seller : ProductInformation
@enduml
</hidden>
```uml
        ┌─┐                                               ┌─┐  
        ║"│                                               ║"│  
        └┬┘                                               └┬┘  
        ┌┼┐                                               ┌┼┐  
         │                    ┌───────┐                    │   
        ┌┴┐                   │Product│                   ┌┴┐  
      Seller                  └───┬───┘                  Users 
         │         ctor           │                        │   
         │───────────────────────>│                        │   
         │                        │                        │   
         │  UpdateDescription()   │                        │   
         │───────────────────────>│                        │   
         │                        │                        │   
         │     UpdatePrice()      │                        │   
         │───────────────────────>│                        │   
         │                        │                        │   
         │                        │GetProductInformation() │   
         │                        │<───────────────────────│   
         │                        │                        │   
         │                        │  ProductInformation    │   
         │                        │ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ >│   
         │                        │                        │   
         │GetProductInformation() │                        │   
         │───────────────────────>│                        │   
         │                        │                        │   
         │  ProductInformation    │                        │   
         │<─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─│                        │   
      Seller                  ┌───┴───┐                  Users 
        ┌─┐                   │Product│                   ┌─┐  
        ║"│                   └───────┘                   ║"│  
        └┬┘                                               └┬┘  
        ┌┼┐                                               ┌┼┐  
         │                                                 │   
        ┌┴┐                                               ┌┴┐  
```

```csharp
// Online shop.
//
// Actors: Seller, Users
//


// Razor page1, used by Seller
{
    Product product = ...;
    var productInformation = product.GetProductInformation();
}

// Razor page2, used by Users
{
    Product product = ...;
    var productInformation = product.GetProductInformation();
}


class Product
{
    private string title;
    private string description;
    private decimal price;

    public Product(string title, string description, decimal price)
    {
        this.title = title;
        this.description = description;
        this.price = price;
    }

    public void UpdateDescription(string description)
    {
        this.description = description;
    }

    public void UpdatePrice(decimal price)
    {
        this.price = price;
    }

    public ProductInformation GetProductInformation() 
    {
        return new ProductInformation(this.title, this.description, this.price);
    }
}

record ProductInformation(string Title, string Description, decimal Price);
```


### Issue of violation the principle 
The issue of `sharing the same class` between `actors` is that if the `Product` class needs to change, for example, the `GetProductInformation()` method, to return `{Title} ${Price}` for Seller instead of `Title`, it would be necessary to consider how not to break existing functionality for `Users`.

```csharp
    public ProductInformation GetProductInformation() 
    {
        // Bug: After deployment, 
        // `Seller` will see the new update title, 
        // but `Users` will see an incorrect one.
        return new ProductInformation($"{this.title} ${this.price}", this.description, this.price);
    }

```

### Code improvement 
There are many ways to improve code by following the `Single Responsibility Principle`. However, all of these approaches boil down to separating methods into different classes. One example is inheritance.

Logic from class Product is split between `SellerProduct` and `UsersProduct` classes.
<hidden style="display:none">
@startuml
abstract Product{
 string title;
 string description;
 decimal price;
 Product(string title, string description, decimal price)
}
class SellerProduct{ 
void UpdateDescription()
void UpdatePrice()
SellerProductInformation GetSellerProductInformation()
}
class UsersProduct { 
UsersProductInformation GetUsersProductInformation()
}
Product <|-- SellerProduct
Product <|-- UsersProduct
@enduml
</hidden>

```uml
                           ┌────────────────────────────────────────────────────────┐                           
                           │Product                                                 │                           
                           ├────────────────────────────────────────────────────────┤                           
                           │string title;                                           │                           
                           │string description;                                     │                           
                           │decimal price;                                          │                           
                           │Product(string title, string description, decimal price)│                           
                           └────────────────────────────────────────────────────────┘                           
                                                                                                                
                                                                                                                
┌──────────────────────────────────────────────────────┐                                                        
│SellerProduct                                         │  ┌────────────────────────────────────────────────────┐
├──────────────────────────────────────────────────────┤  │UsersProduct                                        │
│void UpdateDescription()                              │  ├────────────────────────────────────────────────────┤
│void UpdatePrice()                                    │  │UsersProductInformation GetUsersProductInformation()│
│SellerProductInformation GetSellerProductInformation()│  └────────────────────────────────────────────────────┘
└──────────────────────────────────────────────────────┘                                                        
```

```csharp
abstract class Product
{
    protected string title;
    protected string description;
    protected decimal price;

    public Product(string title, string description, decimal price)
    {
        this.title = title;
        this.description = description;
        this.price = price;
    }
}

// Actor `Seller` has its own class to interact with
sealed class SellerProduct : Product
{
    public SellerProduct(string title, string description, decimal price): base(title, description, price) { }

    public void UpdateDescription(string description)
    {
        this.description = description;
    }

    public void UpdatePrice(decimal price)
    {
        this.price = price;
    }

    public SellerProductInformation GetSellerProductInformation() 
    {
        return new SellerProductInformation($"{this.title} ${this.price}", this.description, this.price);
    }
}

record SellerProductInformation(string Title, string Description, decimal Price);

// Actor `Users` has its own class to interact with
sealed class UsersProduct : Product
{
    public UsersProduct(string title, string description, decimal price) : base(title, description, price) { }

    public UsersProductInformation GetUsersProductInformation()
    {
        return new UsersProductInformation(this.title, this.description, this.price);
    }
}

record UsersProductInformation(string Title, string Description, decimal Price);
```