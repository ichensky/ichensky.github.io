# OO vs Procedural programming 

## Object-oriented programming (OOP)
`Object-oriented programming` (OOP) is a programming paradigm based on the concept of `objects`.
`Object` can contain methods and data in form of fields.<br> 
`Objects` must be self-sufficient with well-defined behavior, providing interfaces/ports/methods through which they can interact with each other. 

### Alan Kay's version of OOP
> I thought of objects being like biological cells and/or individual computers on a network, only able to `communicate with messages` (so messaging came at the very beginning – it took a while to see how to do messaging in a programming language efficiently enough to be useful).

> (I'm not against types, but I don't know of any type systems that aren't a complete pain, so I still like dynamic typing.)<br>
OOP to me means only `messaging`, `local retention` and `protection` and `hiding of state-process`, and `extreme late-binding of all things`.<br>
It can be done in Smalltalk and in LISP. There are possibly other systems in which this is possible, but *I'm not aware of them*.
[Alan Kay](http://www.purl.org/stefan_ram/pub/doc_kay_oop_en)

**Only Messaging**: In OOP, the primary means of interaction between objects is through messages.<br>
Instead of calling functions directly or manipulating data structures, objects communicate by sending messages to one another. This encapsulates behavior and promotes a more modular design.

**Local Retention**: This refers to the idea that an object should manage its own state internally.<br> 
Each object retains its own state (data) and is responsible for its own behavior, which helps to maintain integrity and reduces dependencies between objects.

**Protection and Hiding of State-Process**: This principle is about encapsulation, where the internal state of an object is hidden from the outside world. Objects expose only what is necessary through their public interface, protecting their internal workings and preventing external entities from directly modifying their state.

**Extreme Late-Binding**: Late binding (or dynamic binding) is a concept where method calls are resolved at runtime rather than compile time. This allows for more flexible and dynamic behavior in programs, as the specific method that gets invoked can depend on the actual object type at runtime, rather than being determined statically.

**Can be Done in Smalltalk and in LISP**: Kay points out that these principles of OOP can be implemented in various programming languages, particularly Smalltalk, which is known for its pure OOP model, and LISP, which supports functional programming and can also encapsulate OOP concepts.

###


Interaction between `objects`:
```csharp
User user = new(30, "123456", "Alan", "Kay");
user.ChangeFirstName("Bob");
user.ChangePassword("password");

internal class FullName {
    private string firstName;
    private string lastName;

    public FullName(string firstName, string lastName)
    {
        this.firstName = firstName;
        this.lastName = lastName;
    }

    public void ChangeFirstName(string firstName)
    {
        this.firstName = firstName;
    }
}

public class User {
    private int age;
    private string password;
    private FullName fullName; 

    public User(int age, string password, string firstName, string lastName) {
        if (age < 0 || age > 150)
        {
            throw new ArgumentException("Invalid age.");
        }
        this.age = age;
        // Creating an object that will become a part only of the `User` object
        this.fullName = new FullName(firstName, lastName);
        this.password = password;
    }

    public void ChangePassword(string password) { 
        this.password = password;
    }

    public void ChangeFirstName(string firstName) {
        this.fullName.ChangeFirstName(firstName);
    }
}
```

#### Procedural programming
`Procedural programming` is a programming paradigm, that involves implementing the behavior of a computer program as procedures (a.k.a. functions, subroutines) that call each other.

Interaction between several `Records` and `Procedures` 
```csharp
User user = new();
AgeValidationService ageValidationService = new();
int age = 30;
ageValidationService.ValidateAge(age);
user.age = age;

user.password = "123456";
user.fullName = new FullName();
// Record can be changed directly
user.fullName.firstName = "Alan";
user.fullName.lastName = "Kay";
UserService userService = new();
// Record can be changed by methods
userService.ChangePassword(user, "password");
FullNameService fullNameService = new();
userService.ChangeFirstName(fullNameService, user, "Bob");

public class FullName
{
    public string firstName;
    public string lastName;
}

public class User
{
    public int age;
    public string password;
    public FullName fullName;
}

class FullNameService
{
    // Procedure
    public void ChangeFirstName(FullName fullName, string firstName)
    {
        fullName.firstName = firstName;
    }
}

class AgeValidationService
{
    // Procedure
    public void ValidateAge(int age)
    {
        if (age < 0 || age > 150)
        {
            throw new ArgumentException("Invalid age.");
        }
    }
}

class UserService
{
    // Procedure
    public void ChangePassword(User user, string password)
    {
        user.password = password;
    }

    // Procedure
    public void ChangeFirstName(FullNameService service, User user, string firstName)
    {
        service.ChangeFirstName(user.fullName, firstName);
    }
}
```

#### OOP vs PP
| Procedural | Object-oriented |
|------------|-----------------|
| Procedure	 | Method          |
| Record	 | Object          |
| Module	 | Class           |
| Procedure call | Message     |

`The biggest pitfall of procedural programming` is that it is difficult to create well-supported code that is loosely coupled and easily extended. Changes made in one part of a project often break code in other parts. Procedures and records that are not intended for use in other "Services" are frequently used, complicating the entire system.<br>
`The advantages of procedural programming` include faster overall program execution, as the runtime does not need to recreate chains of virtual methods to find the correct method to execute.


### Anemic Domain Model
The `anemic domain model` is described as a programming `anti-pattern` where `domain objects` contain little or `no business logic`. `Business logic` is often separated from data and `placed in separate "Service" classes`. The anemic domain model `resembles` a `procedural programming` style when `using an object-oriented language`.