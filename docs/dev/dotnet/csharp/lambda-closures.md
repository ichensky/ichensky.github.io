# Lambda closures in C#

In C#, a lambda expression can capture variables from its enclosing scope, creating what is known as a closure. This allows the lambda to access and modify those variables even after the scope in which they were defined has ended.

```csharp
var f = fn();
// 0
Console.WriteLine(f());
// 1
Console.WriteLine(f());

static Func<int> fn()
{
    int i =0;
    return ()=> i++;
}
```

## `static` lambdas

In C# 9.0 and later, can be declared a lambda expression as `static`, which means it cannot capture any variables from its enclosing scope. This can improve performance and reduce memory allocation since the lambda does not need to create a closure.

```csharp
static Func<int> fn()
{
    int i =0;
    return static () => 
    //i++; // Compilation Error: Cannot modify 'i' because it is not in scope
    0
    ;
}
```