# C# notes about SOLID

**Single Responsibility Principle**

A **module** should have only one responsibility, do only one thing. For ex. convert text to html, but not convert text to html and upload it to the storage.
> .. the final version of the SRP is: A module should be responsible to one, and only one, actor.
[Robert C. Martin]
* A **module** is a unit of code that performs a specific task. It can be a class, function, or procedure.
* An **actor** is a person, system, or process that interacts with the module. 

**Open-Closed Principle**

After introducing a new `feature` if code in present **class**, *function*, etc is changing *somehow* this principle is violated.
Create *plugin* system.

**Liskov Substitution Principle**. 

The [new](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/knowing-when-to-use-override-and-new-keywords) modifier should not be used to override virtual methods in inherited classes.

**Interface Segregation Principle**.

If **two** **classes** need to use different methods from *one* interface, the interface should be split into two.

**Dependency Inversion Principle**. 

Pass `interfaces` as parameters instead of classes.