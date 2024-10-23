# Liskov Substitution Principle

Barbara Liskov, “Data Abstraction and Hierarchy,"
> What is wanted here is something like the following substitution property: If
for each object o1 of type S there is an object o2 of type T such that for all
programs P defined in terms of T, `the behavior of P is unchanged` when o1 is
substituted for o2 then S is a subtype of T.

Martin, Robert C.
> Functions that use pointers or references to base classes must be able to use objects of derived classes without knowing it.

To understand the idea, let's check several examples.

## Examples of violaiton the principle

### Rectangle and a Square

A class `Rectangle` has several methods to set width, height of a rectangle and calculate its area.<br>
Derived class `Square` overrides methods `SetWidth()` and `SetHeight()`, by setting the same width, height.

```csharp
public class Rectangle
{
    protected int width;
    protected int height;
    
    public virtual void SetWidth(int width) { this.width = width; }
    
    public virtual void SetHeight(int height) { this.height = height; }
    
    public int GetArea() => this.width * this.height;
}

public class Square : Rectangle
{
    public override void SetWidth(int width)
    {
        // For the Square width is equal to the height
        //
        this.width = this.height = width;
    }
    
    public override void SetHeight(int height)
    {
        this.width = this.height = height;
    }
}
```
For the first view it might look okay, if user create an instance of the class `Square` and execute method `GetArea()`. The area will be calculated properly.

```csharp
var square = new Square();
square.SetWidth(5);
Console.WriteLine(square.GetArea()); // 25

```
However, if an object casted to `Rectangle` passed as a parameter into a `function`, depending on whether it is a `Square` or `Rectangle`, the object's `GetArea()` function will return `different results`.

Inside of function `ExecuteSomeLogic()` developer might think, that he is working with `Rectangle` object, but it is not true in all cases. 

```csharp
Rectangle rectangle;

rectangle = Lib.InitRectangleV1();
ExecuteSomeLogic(rectangle); // Area: 50

rectangle = Lib.InitRectangleV2();
ExecuteSomeLogic(rectangle); // 25


//
// Function uses base class Rectangle 
// and knows nothing about derived
//
// The `Liskov Substitution Principle` is violated.
//
static void ExecuteSomeLogic(Rectangle rectangle)
{
    // User, who use `Rectangle` thinks, 
    // that he is working with `Rectangle`
    //
    rectangle.SetWidth(10);
    rectangle.SetHeight(5);

    int area = rectangle.GetArea();

    if(area == 50)
    {
        Console.Write("Area: ");
    }

    Console.WriteLine(area); 
}

// Some external library
public static class Lib
{
    public static Rectangle InitRectangleV1() => new Rectangle();

    public static Rectangle InitRectangleV2() => new Square();
}
```

### C# `new` modifier
Even if the `virtual` modifiers are removed from the base `Rectangle` class, in `C#`, it is still possible to violate the `LSP` by using the `new` modifier in the derived class.

User create an object `Square` and think that he is working with object `Square`.<br>
That's why in function `ExecuteSomeLogic()` is called only one function `SetWidth()` sufficient for `Square()`. <br>
But as was used modifier `new`, object `Rectangle` doesn't have a reference in its `virtual method table` to the method `SetWidth` from object `Square`.<br>
As the reselt called `SetWidth()` method from `Rectangle` object, which multiply `10 x 0 = 0`.
```csharp
var rectangle = new Square();
ExecuteSomeLogic(rectangle); // 0


static void ExecuteSomeLogic(Rectangle rectangle)
{
    rectangle.SetWidth(10);

    int area = rectangle.GetArea();

    Console.WriteLine(area); 
}

public class Rectangle
{
    protected int width;
    protected int height;
    
    public void SetWidth(int width) { this.width = width; }
    
    public void SetHeight(int height) { this.height = height; }
    
    public int GetArea() => this.width * this.height;
}

public class Square : Rectangle
{
    public new void SetWidth(int width) { this.width = this.height = width; }
    
    public new void SetHeight(int height) { this.width = this.height = height; }
}

``` 
To protect class from the inheritance in C# can be used `sealed` modifier.
```csharp
sealed class Foo { }
```

## How to protect code from the principle violation 

Square mathematicaly is a rectangle, however object `Square` is not a `Rectangle` object, it has its `own behavior`. 

It's vital to `control public behavior` of all `derived classes` so that they act like base types. 

Expect `behavior` requirements, Liskov substitution principle imposes some standard requirements on `signatures` that have been adopted in newer object-oriented programming languages.

## LSP Methods Signature requirements

### * `Covariance` of method return types in the subtype.

```csharp
using System;

var square = new Square();
ExecuteSomeLogic(square); // Dog

void ExecuteSomeLogic(Rectangle rectangle)
{
    var animal = square.GetAnimal();
    Console.WriteLine(animal.ToString());
}

class Animal {}

class Dog : Animal {}

class Rectangle
{
    public virtual Animal GetAnimal()
    {
        return new Animal();
    }
}

class Square : Rectangle
{
    // Type `Dog` is covariant to type `Animal`
    public override Dog GetAnimal()
    {
        return new Dog();
    }
}
```


`.NET Framework (x64)` does not support covariant return types in overrides.<br> 
It will throw an exception<br>
>error CS8830: 'Square.GetAnimal()': Target runtime doesn't support covariant return types in overrides. Return type must be 'Animal' to match overridden member 'Rectangle.GetAnimal()'

`.NET 9.0` does support covariant return types in overrides. [see](https://github.com/dotnet/csharplang/blob/main/proposals/csharp-9.0/covariant-returns.md) 


### * `Contravariance` of method parameter types in the subtype.
```csharp
using System;

var animal = new Dog();
var square = new Square();


ExecuteSomeLogic(square);

void ExecuteSomeLogic(Rectangle rectangle)
{
    square.SetAnimal(animal);
}

class Animal { }

class Dog : Animal { }

class Rectangle
{
    public virtual void SetAnimal(Animal dog)
    {
        Console.WriteLine(dog);
    }
}

class Square : Rectangle
{
    // Type Animal is contrvariant to type Dog 
    public override void SetAnimal(Dog animal)
    {
        base.SetAnimal(animal);
    }
}
```

`.NET 9.0` does not support contrvariant types as parameters in overrides.<br>
> error CS0115: 'Square.SetAnimal(Dog)': no suitable method found to override
see [dicussion](https://github.com/dotnet/csharplang/discussions/3562)

In `.NET 9.0` this requirement will be automatically met.


### * New exceptions cannot be thrown by the methods in the subtype, except if they are subtypes of exceptions thrown by the methods of the supertype.

Method `Method()` from `Rectangle` class throw only one exception `BusinessException`.<br>
`BusinessException` has only one derived exception class `UserBusinessException`.<br>
So, in subtype `Square` it is allowed only to throw `BusinessException` or `UserBusinessException`.

```csharp
class BusinessException : Exception { }

// Sub type of `BusinessException` class 
class UserBusinessException : BusinessException { }

class Rectangle
{
    public virtual void Method(){ 
        throw new BusinessException(); 
    }
}

class Square
{
    public override void Method()
    {
        // It is allowed to throw the same Exceptions 
        // as a base class `Rectangle` 
        throw new BusinessException();
        
        // It is allowed to throw this exception, 
        // because it is subtype of BusinessException
        throw new UserBusinessException();

        // It is NOT allowed to throw `ArgumentException`
        // in sybtype `Square` method `Method()`,
        // because it was never thrown in the base
        // class `Rectangle` `Method()`
        // throw new ArgumentException();
    }
}

```


## LSP Methods behavior requirements

Subtypes must satisfy a set of `behavioral` requirements. These requirements are expressed using `design by contract` approach.

### * Preconditions cannot be strengthened in the subtype.
```csharp
using System.Diagnostics.Contracts;

class Rectangle
{
    protected int width;
    protected int height;

    public virtual void SetWidth(int width)
    {
        Contract.Requires(width > 100);

        this.width = width;
    }
}

class Square : Rectangle
{
    public override void SetWidth(int width)
    {
        // It is not allowed
        // Debug.Assert(width > 1000); 

        // Precondition can be only weakened here
        Contract.Requires(width > 50);

        base.SetWidth(width);
        this.height = this.width;
    }
}
```

### * Postconditions cannot be weakened in the subtype.
```csharp
using System.Diagnostics.Contracts;

class Rectangle
{
    protected int width;
    protected int height;

    public virtual void SetWidth(int width)
    {
        this.width = width;

        Contract.Ensures(width > 100);
    }
}

class Square : Rectangle
{
    public override void SetWidth(int width)
    {
        base.SetWidth(width);
        this.height = this.width;

        // Postcondition can be only strengthened here
        Contract.Ensures(width > 1000);

        // It is not allowed
        //Contract.Ensures(width > 50);
    }
}
```

### * Invariants cannot be weakened in the subtype.
```csharp
using System.Diagnostics.Contracts;

class Rectangle
{
    protected int width;
    protected int height;

    public virtual void SetWidth(int width)
    {
        this.width = width;

        Contract.Invariant(width > 100);
    }
}

class Square : Rectangle
{
    public override void SetWidth(int width)
    {
        this.height = this.width = width;

        // It is not allowed, 
        // the condition is stronger then in the base class
        // Contract.Invariant(width > 100 && height > 100);
    }
}
```

> NOTE: Code `Contracts` provide static analyze of code and are not supported by `.NET Core` or `.NET`.

### * History constraint.
In OOP, `Objects` are designed to be modified solely through their `methods`.<br> 
However, because `subtypes can introduce new methods` that are `not available` in the `supertype`, these methods could potentially allow `state changes` in the subtype that are `not permitted` in the `supertype`.<br> 
The history constraint prevents this.

Class `Rectangle` has imutable `FromPoint = {0,0}`, which should never be changed.<br>
Class `Square` has additional method `ChangePosition()`, which after execution modifies immutable data for the base type and finaly breaks the object invariants.
```csharp
var square = new Square();
square.ChangePosition(5, 10);

void ExecuteSomeLogic(Rectangle rectangle)
{
    // The state of `Rectangle` is broken
    rectangle.PrintToPoint();
}

class Point { public int X, Y; };

class Rectangle
{
    protected Point FromPoint = new () { };
    protected int width;
    protected int height;

    public virtual void SetWidth(int width) { }

    public void PrintToPoint() {
        if (FromPoint.X > 0 || FromPoint.Y > 0)
        {
            throw new InvalidOperationException("State of Rectangle is broken.");
        }
        Console.WriteLine($"{width + FromPoint.X} {height + FromPoint.Y}");
    }
}

class Square : Rectangle
{
    public override void SetWidth(int width) { }

    public void ChangePosition(int x, int y) {
        this.FromPoint.X = x;
        this.FromPoint.Y = y;
    }
}
```