# Data Access Layer
The Data Access Layer (DAL) handles all interactions between an application and the underlying data storage system. It acts as an intermediary, shielding the rest of the application from the `complexities` of `data access`.

The key responsibilities of Data Access Layer is to retriev data from the database based on specific criteria (e.g., queries, filters).
`Transforms` `raw data` from the database into `objects` that the application can understand.

## Data Access Layer implementation

### Data access type
- Raw database table data
- Object

The `Data Access Layer` can retrieve or save `objects` from the database, or it can be implemented to access `raw database table data`.

* An `object` is an entity that has `state`, `behavior`, and `identity`.

| Feature           | Object-oriented           | Data-oriented          |
|-------------------|---------------------------|------------------------|
| Abstraction Level | High                      | Lower                  |
| Focus             | Object-relational mapping | Row-level operations | 
| Complexity        | Generally more complex    | Simpler to implement   |

### Patterns

- Gateway
    - Data oriented
        - Row Gateway
        - Table Gateway 
        - Data Acceess Object

    - Object oriented
        - Data Mapper
        - Repository
        - Data Acceess Object

- Active Record
    - Object-oriented 
        - Active Record

The `Data Access Layer` can be implemented using either the `Gateway` pattern or the `Active Record` pattern.

#### Gateway

The `Gateway` is a pattern that centralizes and controls interactions with external systems or subsystems. <br>
It isolates clients from the complexities of directly interacting with external systems by providing simplified interface to interact with.<br>

In essence, the `Gateway` pattern aims to create a more maintainable and efficient interaction between clients and external systems.

##### Examples
**API Gateway** In microservices architecture, it acts as a single entry point for clients to access multiple microservices. 

**Database Gateway** Encapsulates all database access logic for a specific table or set of tables.   

**Third-party API Gateway** Acts as an intermediary between the application and external APIs (e.g., image Service, payment Service)

#### Active Record   

The `Active Record` pattern is a software design pattern that integrates both business logic and data persistence within a `single object`.

Where each `object` in the system directly corresponds to a `row` in a database table.