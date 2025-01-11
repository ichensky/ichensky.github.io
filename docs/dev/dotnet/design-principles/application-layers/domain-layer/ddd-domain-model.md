# DDD Domain Model
`Domain-Driven Design (DDD)` adds the crucial requirement that all invariants of Domain Models must always be in a valid state.

This means that if a `Domain Model` aggregate root object contains related collections, then when the object is loaded into memory, it should contain all those collections as well.

When `Domain Model` aggregate root object is saved into DB, it must be saved entirely in one transaction.

This means that a `DDD Domain Model` aggregate root object cannot have any direct references to other aggregate root objects. It can only reference them by their `IDs`.

"Therefore, it is crucial to carefully consider the domain area beforehand to prevent excessive data loading into memory. If performance issues arise due to excessive data loading, future refactoring may involve breaking down the aggregate root into smaller entities or even deviating from the `DDD pattern` by implementing `lazy loading` or replacing some parts of the system with a `Transaction Script` approach, for ex. for often update of the `Status`.

```csharp
public class Hotel : IAggregateRoot
    {
        public Guid Id { get; set; }

        // Inderect reference to another Aggregate Root
        public Guid OwnerId {get; set; }

        public string Name { get; set; }

        public int Status { get; set; }

        // If `Hotel` is loaded, all its collections loaded as well
        public virtual ICollection<Booking> Bookings { get; set; } = [];
    }

public class VipRoom : IAggregateRoot {} 

public class SimpleRoom : IAggregateRoot {} 

public class Booking : IEntity { } 

public class Owner : IAggregateRoot {} 
```